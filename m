Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3GVMxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:53:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15967 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3GVMxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:53:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 22 Jul 2013 05:53:23 -0700
From: Manoj Chourasia <mchourasia@nvidia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "jkosina@suse.cz" <jkosina@suse.cz>
Date: Mon, 22 Jul 2013 18:23:15 +0530
Subject: [PATCH] hidraw: correctly deallocate memory on device disconnect
Thread-Topic: [PATCH] hidraw: correctly deallocate memory on device
 disconnect
Thread-Index: Ac6G2mYOHLDl5rP5T86nibcvj4Ef2Q==
Message-ID: <F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47@BGMAIL02.nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_003_F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47BGMAIL02nvidi_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_003_F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47BGMAIL02nvidi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

This is mail is in regard to your commit for hidaw devices. We were seeing =
kernel crashes while connect and disconnect a hidraw device and we were hit=
ting=20
rb tree corruption in vmalloc and kernel was crashing because of null point=
er de-reference.
Later we figure out that was because the hid device disconnect is freeing m=
emory which later got access by hidraw_read and hid_write.=20

commit df0cfd6990347c20ae031f3f34137cba274f1972
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Nov 1 11:33:26 2012 +0100

    HID: hidraw: put old deallocation mechanism in place

    This basically reverts commit 4fe9f8e203fda. It causes multiple problem=
s,
    namely:


We found following commit by Ratan Nalumasu was helping in solving our issu=
e
commit 4fe9f8e203fdad1524c04beb390f3c6099781ed9
Author: Ratan Nalumasu <ratan@google.com>
Date:   Sat Sep 22 11:46:30 2012 -0700

    HID: hidraw: don't deallocate memory when it is in use

    When a device is unplugged, wait for all processes that have opened the=
 device
    to close before deallocating the device.


But there was a bug in Ratan's that commit which was causing slab memory co=
rruption.  We fixed that bug and now our issue solved. I can give evidence =
on issue.
The bug that was there in the commit that he was deleting list after words =
and feeing head of it before.
I am attaching the patch. =20


-regards
Manoj


-----------------------------------------------------------------------

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index a745163..612a655 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -113,7 +113,7 @@ static ssize_t hidraw_send_report(struct file *file, co=
nst char __user *buffer,
 	__u8 *buf;
 	int ret =3D 0;
=20
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		ret =3D -ENODEV;
 		goto out;
 	}
@@ -261,7 +261,7 @@ static int hidraw_open(struct inode *inode, struct file=
 *file)
 	}
=20
 	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
+	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		err =3D -ENODEV;
 		goto out_unlock;
 	}
@@ -302,39 +302,38 @@ static int hidraw_fasync(int fd, struct file *file, i=
nt on)
 	return fasync_helper(fd, file, on, &list->fasync);
 }
=20
+static void drop_ref(struct hidraw *hidraw, int exists_bit)
+{
+	if (exists_bit) {
+		hid_hw_close(hidraw->hid);
+		hidraw->exist =3D 0;
+		if (hidraw->open)
+			wake_up_interruptible(&hidraw->wait);
+	} else {
+		--hidraw->open;
+	}
+
+	if (!hidraw->open && !hidraw->exist) {
+		device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
+		hidraw_table[hidraw->minor] =3D NULL;
+		kfree(hidraw);
+	}
+}
+
 static int hidraw_release(struct inode * inode, struct file * file)
 {
 	unsigned int minor =3D iminor(inode);
-	struct hidraw *dev;
 	struct hidraw_list *list =3D file->private_data;
-	int ret;
-	int i;
=20
 	mutex_lock(&minors_lock);
-	if (!hidraw_table[minor]) {
-		ret =3D -ENODEV;
-		goto unlock;
-	}
=20
 	list_del(&list->node);
-	dev =3D hidraw_table[minor];
-	if (!--dev->open) {
-		if (list->hidraw->exist) {
-			hid_hw_power(dev->hid, PM_HINT_NORMAL);
-			hid_hw_close(dev->hid);
-		} else {
-			kfree(list->hidraw);
-		}
-	}
-
-	for (i =3D 0; i < HIDRAW_BUFFER_SIZE; ++i)
-		kfree(list->buffer[i].value);
 	kfree(list);
-	ret =3D 0;
-unlock:
-	mutex_unlock(&minors_lock);
=20
-	return ret;
+	drop_ref(hidraw_table[minor], 0);
+
+	mutex_unlock(&minors_lock);
+	return 0;
 }
=20
 static long hidraw_ioctl(struct file *file, unsigned int cmd,
@@ -539,18 +538,9 @@ void hidraw_disconnect(struct hid_device *hid)
 	struct hidraw *hidraw =3D hid->hidraw;
=20
 	mutex_lock(&minors_lock);
-	hidraw->exist =3D 0;
-
-	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
=20
-	hidraw_table[hidraw->minor] =3D NULL;
+	drop_ref(hidraw, 1);
=20
-	if (hidraw->open) {
-		hid_hw_close(hid);
-		wake_up_interruptible(&hidraw->wait);
-	} else {
-		kfree(hidraw);
-	}
 	mutex_unlock(&minors_lock);
 }
 EXPORT_SYMBOL_GPL(hidraw_disconnect);
--

-Regards
Manoj


--_003_F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47BGMAIL02nvidi_
Content-Type: text/plain; name="kernel_crash.txt"
Content-Description: kernel_crash.txt
Content-Disposition: attachment;
	modification-date="Mon, 22 Jul 2013 10:22:37 GMT";
	creation-date="Mon, 22 Jul 2013 10:23:08 GMT"; size=895; filename="kernel_crash.txt"
Content-Transfer-Encoding: base64

WyAgMTExLjU3ODExNl0gVW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVm
ZXJlbmNlIGF0IHZpcnR1YWwgYWRkcmVzcyAwMDAwMDAwMQoKWyAgMTExLjU3ODEzNF0gcGdkID0g
YWE4NzAwMDAKClsgIDExMS41NzgxNDNdIFswMDAwMDAwMV0gKnBnZD0yYWZiYjgzMSwgKnB0ZT0w
MDAwMDAwMCwgKnBwdGU9MDAwMDAwMDAKClsgIDExMS41NzgxNjhdIEludGVybmFsIGVycm9yOiBP
b3BzOiAxNyBbIzFdIFBSRUVNUFQgU01QCgpbICAxMTEuNTc4MzUyXSBDUFU6IDEgICAgVGFpbnRl
ZDogUAoKWyAgMTExLjU3ODM3OF0gUEMgaXMgYXQgcmJfZXJhc2UrMHgxYjQvMHgzNzAKClsgIDEx
MS41NzgzOTldIExSIGlzIGF0IF9fZnJlZV92bWFwX2FyZWErMHg1Yy8weGY0CgpbICAxMTEuNTc4
NDEzXSBwYyA6IFs8ODAxZDJiYTg+XSAgICBsciA6IFs8ODAwYjdmYjg+XSAgICBwc3I6IDIwMGYw
MDEzCgpbICAxMTEuNTc4NDE5XSBzcCA6IGFhMjA1ZDg4ICBpcCA6IDAwMDAwMDAxICBmcCA6IDAw
MDAwMDAyCgpbICAxMTEuNTc4NDMxXSByMTA6IDAwMDAwZDMwICByOSA6IDAwMDAwMDAyICByOCA6
IGMxYWIyMDAwCgpbICAxMTEuNTc4NDQyXSByNyA6IDAwMDAwZDMwICByNiA6IDljYTU0NGVjICBy
NSA6IDgwNWYzOGEwICByNCA6IDljYTI0YjZjCgpbICAxMTEuNTc4NDU0XSByMyA6IDljOGE4N2Vj
ICByMiA6IDAwMDAwMDAxICByMSA6IGI2MjdiZjZjICByMCA6IDAwMDAwMDAxCgpbICAxMTEuNTc4
NDY4XSBGbGFnczogbnpDdiAgSVJRcyBvbiAgRklRcyBvbiAgTW9kZSBTVkNfMzIgIElTQSBBUk0g
IFNlZ21lbnQgdXNlcgoKWyAgMTExLjU3ODQ4MV0gQ29udHJvbDogMTBjNTM4N2QgIFRhYmxlOiAy
YTg3MDA0YSAgREFDOiAwMDAwMDAxNQoKWyAgMTExLjU3ODQ5MV0KCg==

--_003_F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47BGMAIL02nvidi_
Content-Type: application/octet-stream;
	name="PATCH_HID-hidraw-correctly-deallocate-memory-on-device-dis.patch"
Content-Description: PATCH_HID-hidraw-correctly-deallocate-memory-on-device-dis.patch
Content-Disposition: attachment;
	modification-date="Mon, 22 Jul 2013 10:12:28 GMT"; creation-date="Mon, 22 Jul 2013 10:13:10 GMT";
	size=3564; filename=
	"PATCH_HID-hidraw-correctly-deallocate-memory-on-device-dis.patch"
Content-Transfer-Encoding: base64

RnJvbSBmZDlhODk5ZWQ2MzI4MGVkODBmZTQ1YTIwYmUxZGVmMTIzMzJkNTI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5vaiBDaG91cmFzaWEgPG1jaG91cmFzaWFAbnZpZGlhLmNv
bT4KRGF0ZTogTW9uLCAyMiBKdWwgMjAxMyAxNTozMzoxMyArMDUzMApTdWJqZWN0OiBbUEFUQ0hd
IEhJRDogaGlkcmF3OiBjb3JyZWN0bHkgZGVhbGxvY2F0ZSBtZW1vcnkgb24gZGV2aWNlCiBkaXNj
b25uZWN0CgpUaGlzIGNoYW5nZXMgcHV0cyB0aGUgY29tbWl0IDRmZTlmOGUyMDNmIGJhY2sgaW4g
cGxhY2UKd2l0aCB0aGUgZml4ZXMgZm9yIHNsYWIgY29ycnVwdGlvbiBiZWNhdXNlIG9mIHRoZSBj
b21taXQuCgpXaGVuIGEgZGV2aWNlIGlzIHVucGx1Z2dlZCwgd2FpdCBmb3IgYWxsIHByb2Nlc3Nl
cyB0aGF0CmhhdmUgb3BlbmVkIHRoZSBkZXZpY2UgdG8gY2xvc2UgYmVmb3JlIGRlYWxsb2NhdGlu
ZyB0aGUgZGV2aWNlLgoKVGhpcyBjb21taXQgd2FzIHNvbHZpbmcga2VybmVsIGNyYXNoIGJlY2F1
c2Ugb2YgdGhlIGNvcnJ1cHRpb24gaW4KcmIgdHJlZSBvZiB2bWFsbG9jLiBUaGUgcm9vdGNhdXNl
IHdhcyB0aGUgZGV2aWNlIGRhdGEgcG9pbnRlciB3YXMKZ2V0aW5nIGV4Y2Vzc2VkIGFmdGVyIHRo
ZSBtZW1vcnkgYXNzb2NpYXRlZCB3aXRoIGhpZHJhdyB3YXMgZnJlZWQuCgpUaGUgY29tbWl0IDRm
ZTlmOGUyMDNmIHdhcyBidWdneSBhcyBpdCB3YXMgYWxzbyBmcmVlaW5nIHRoZSBoaWRyYXcKZmly
c3QgYW5kIHRoZW4gY2FsbGluZyBkZWxldGUgb3BlcmF0aW9uIG9uIHRoZSBsaXN0IGFzc29jaWF0
ZWQgd2l0aAp0aGF0IGhpZHJhdyBsZWFkaW5nIHRvIHNsYWIgY29ycnVwdGlvbi4KClNpZ25lZC1v
ZmYtYnk6IE1hbm9qIENob3VyYXNpYSA8bWNob3VyYXNpYUBudmlkaWEuY29tPgotLS0KIGRyaXZl
cnMvaGlkL2hpZHJhdy5jIHwgICA2MCArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDM1IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2hpZHJhdy5jIGIvZHJpdmVycy9o
aWQvaGlkcmF3LmMKaW5kZXggYTc0NTE2My4uNjEyYTY1NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9o
aWQvaGlkcmF3LmMKKysrIGIvZHJpdmVycy9oaWQvaGlkcmF3LmMKQEAgLTExMyw3ICsxMTMsNyBA
QCBzdGF0aWMgc3NpemVfdCBoaWRyYXdfc2VuZF9yZXBvcnQoc3RydWN0IGZpbGUgKmZpbGUsIGNv
bnN0IGNoYXIgX191c2VyICpidWZmZXIsCiAJX191OCAqYnVmOwogCWludCByZXQgPSAwOwogCi0J
aWYgKCFoaWRyYXdfdGFibGVbbWlub3JdKSB7CisJaWYgKCFoaWRyYXdfdGFibGVbbWlub3JdIHx8
ICFoaWRyYXdfdGFibGVbbWlub3JdLT5leGlzdCkgewogCQlyZXQgPSAtRU5PREVWOwogCQlnb3Rv
IG91dDsKIAl9CkBAIC0yNjEsNyArMjYxLDcgQEAgc3RhdGljIGludCBoaWRyYXdfb3BlbihzdHJ1
Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAl9CiAKIAltdXRleF9sb2NrKCZt
aW5vcnNfbG9jayk7Ci0JaWYgKCFoaWRyYXdfdGFibGVbbWlub3JdKSB7CisJaWYgKCFoaWRyYXdf
dGFibGVbbWlub3JdIHx8ICFoaWRyYXdfdGFibGVbbWlub3JdLT5leGlzdCkgewogCQllcnIgPSAt
RU5PREVWOwogCQlnb3RvIG91dF91bmxvY2s7CiAJfQpAQCAtMzAyLDM5ICszMDIsMzggQEAgc3Rh
dGljIGludCBoaWRyYXdfZmFzeW5jKGludCBmZCwgc3RydWN0IGZpbGUgKmZpbGUsIGludCBvbikK
IAlyZXR1cm4gZmFzeW5jX2hlbHBlcihmZCwgZmlsZSwgb24sICZsaXN0LT5mYXN5bmMpOwogfQog
CitzdGF0aWMgdm9pZCBkcm9wX3JlZihzdHJ1Y3QgaGlkcmF3ICpoaWRyYXcsIGludCBleGlzdHNf
Yml0KQoreworCWlmIChleGlzdHNfYml0KSB7CisJCWhpZF9od19jbG9zZShoaWRyYXctPmhpZCk7
CisJCWhpZHJhdy0+ZXhpc3QgPSAwOworCQlpZiAoaGlkcmF3LT5vcGVuKQorCQkJd2FrZV91cF9p
bnRlcnJ1cHRpYmxlKCZoaWRyYXctPndhaXQpOworCX0gZWxzZSB7CisJCS0taGlkcmF3LT5vcGVu
OworCX0KKworCWlmICghaGlkcmF3LT5vcGVuICYmICFoaWRyYXctPmV4aXN0KSB7CisJCWRldmlj
ZV9kZXN0cm95KGhpZHJhd19jbGFzcywgTUtERVYoaGlkcmF3X21ham9yLCBoaWRyYXctPm1pbm9y
KSk7CisJCWhpZHJhd190YWJsZVtoaWRyYXctPm1pbm9yXSA9IE5VTEw7CisJCWtmcmVlKGhpZHJh
dyk7CisJfQorfQorCiBzdGF0aWMgaW50IGhpZHJhd19yZWxlYXNlKHN0cnVjdCBpbm9kZSAqIGlu
b2RlLCBzdHJ1Y3QgZmlsZSAqIGZpbGUpCiB7CiAJdW5zaWduZWQgaW50IG1pbm9yID0gaW1pbm9y
KGlub2RlKTsKLQlzdHJ1Y3QgaGlkcmF3ICpkZXY7CiAJc3RydWN0IGhpZHJhd19saXN0ICpsaXN0
ID0gZmlsZS0+cHJpdmF0ZV9kYXRhOwotCWludCByZXQ7Ci0JaW50IGk7CiAKIAltdXRleF9sb2Nr
KCZtaW5vcnNfbG9jayk7Ci0JaWYgKCFoaWRyYXdfdGFibGVbbWlub3JdKSB7Ci0JCXJldCA9IC1F
Tk9ERVY7Ci0JCWdvdG8gdW5sb2NrOwotCX0KIAogCWxpc3RfZGVsKCZsaXN0LT5ub2RlKTsKLQlk
ZXYgPSBoaWRyYXdfdGFibGVbbWlub3JdOwotCWlmICghLS1kZXYtPm9wZW4pIHsKLQkJaWYgKGxp
c3QtPmhpZHJhdy0+ZXhpc3QpIHsKLQkJCWhpZF9od19wb3dlcihkZXYtPmhpZCwgUE1fSElOVF9O
T1JNQUwpOwotCQkJaGlkX2h3X2Nsb3NlKGRldi0+aGlkKTsKLQkJfSBlbHNlIHsKLQkJCWtmcmVl
KGxpc3QtPmhpZHJhdyk7Ci0JCX0KLQl9Ci0KLQlmb3IgKGkgPSAwOyBpIDwgSElEUkFXX0JVRkZF
Ul9TSVpFOyArK2kpCi0JCWtmcmVlKGxpc3QtPmJ1ZmZlcltpXS52YWx1ZSk7CiAJa2ZyZWUobGlz
dCk7Ci0JcmV0ID0gMDsKLXVubG9jazoKLQltdXRleF91bmxvY2soJm1pbm9yc19sb2NrKTsKIAot
CXJldHVybiByZXQ7CisJZHJvcF9yZWYoaGlkcmF3X3RhYmxlW21pbm9yXSwgMCk7CisKKwltdXRl
eF91bmxvY2soJm1pbm9yc19sb2NrKTsKKwlyZXR1cm4gMDsKIH0KIAogc3RhdGljIGxvbmcgaGlk
cmF3X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxlLCB1bnNpZ25lZCBpbnQgY21kLApAQCAtNTM5LDE4
ICs1MzgsOSBAQCB2b2lkIGhpZHJhd19kaXNjb25uZWN0KHN0cnVjdCBoaWRfZGV2aWNlICpoaWQp
CiAJc3RydWN0IGhpZHJhdyAqaGlkcmF3ID0gaGlkLT5oaWRyYXc7CiAKIAltdXRleF9sb2NrKCZt
aW5vcnNfbG9jayk7Ci0JaGlkcmF3LT5leGlzdCA9IDA7Ci0KLQlkZXZpY2VfZGVzdHJveShoaWRy
YXdfY2xhc3MsIE1LREVWKGhpZHJhd19tYWpvciwgaGlkcmF3LT5taW5vcikpOwogCi0JaGlkcmF3
X3RhYmxlW2hpZHJhdy0+bWlub3JdID0gTlVMTDsKKwlkcm9wX3JlZihoaWRyYXcsIDEpOwogCi0J
aWYgKGhpZHJhdy0+b3BlbikgewotCQloaWRfaHdfY2xvc2UoaGlkKTsKLQkJd2FrZV91cF9pbnRl
cnJ1cHRpYmxlKCZoaWRyYXctPndhaXQpOwotCX0gZWxzZSB7Ci0JCWtmcmVlKGhpZHJhdyk7Ci0J
fQogCW11dGV4X3VubG9jaygmbWlub3JzX2xvY2spOwogfQogRVhQT1JUX1NZTUJPTF9HUEwoaGlk
cmF3X2Rpc2Nvbm5lY3QpOwotLSAKMS43LjkuNQoK

--_003_F17EA9D408D3644C864D33B8F5E1CC526DAC2ACF47BGMAIL02nvidi_--
