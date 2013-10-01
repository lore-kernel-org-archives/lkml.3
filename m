Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3JANf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:35:58 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7206 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3JANf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:35:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 01 Oct 2013 06:35:57 -0700
From: Manoj Chourasia <mchourasia@nvidia.com>
To: "jkosina@suse.cz" <jkosina@suse.cz>,
        "Mika Westerberg (mika.westerberg@linux.intel.com)" 
	<mika.westerberg@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Oct 2013 19:05:56 +0530
Subject: FW: [PATCH] hidraw: close underlying device at removal of last
 reader
Thread-Topic: [PATCH] hidraw: close underlying device at removal of last
 reader
Thread-Index: Ac6+qppQHC4L5S3uS5u9ddG6R22DJAAACmqQ
Message-ID: <F1F6C959961EA744BBD5B8EEF8B8FEA16DDD19DD43@BGMAIL02.nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_F1F6C959961EA744BBD5B8EEF8B8FEA16DDD19DD43BGMAIL02nvidi_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_F1F6C959961EA744BBD5B8EEF8B8FEA16DDD19DD43BGMAIL02nvidi_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Mika Westerberg mika.westerberg@linux.intel.com reported a bug introduced i=
n hid driver after=20
commit 212a871a393 (HID: hidraw: correctly deallocate memory on device disc=
onnect)=20
that hidraw doesn't close the underlying hid device when the device node is=
 closed last time.

I am proposing following patch as fix. =A0Please review it. =A0Mika will he=
lp in testing.

----------------------------------------
>From b37519b65be0d51b90c5fc177c0dc0cd2f6358b1 Mon Sep 17 00:00:00 2001
From: Manoj Chourasia <mchourasia@nvidia.com>
Date: Tue, 1 Oct 2013 15:39:00 +0530
Subject: [PATCH] HID: hidraw: close underlying device at removal of last re=
ader

Even though device exist bit is set the underlying
HW device should be closed when the last reader
of the device is closed i.e. open count drops to zero.

Signed-off-by: Manoj Chourasia <mchourasia@nvidia.com>
---
 drivers/hid/hidraw.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index dbfe300..3c0dd44 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -305,19 +305,28 @@ static int hidraw_fasync(int fd, struct file *file, i=
nt on)
 static void drop_ref(struct hidraw *hidraw, int exists_bit)
 {
        if (exists_bit) {
-               hid_hw_close(hidraw->hid);
                hidraw->exist =3D 0;
-               if (hidraw->open)
+               if (hidraw->open) {
+                       hid_hw_close(hidraw->hid);
                        wake_up_interruptible(&hidraw->wait);
+               }
        } else {
                --hidraw->open;
        }

-       if (!hidraw->open && !hidraw->exist) {
-               device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->mi=
nor));
-               hidraw_table[hidraw->minor] =3D NULL;
-               kfree(hidraw);
+       if (!hidraw->open) {
+               if (!hidraw->exist) {
+                       device_destroy(hidraw_class,
+                               MKDEV(hidraw_major, hidraw->minor));
+                       hidraw_table[hidraw->minor] =3D NULL;
+                       kfree(hidraw);
+               } else {
+                       /* close device for last reader */
+                       hid_hw_power(hidraw->hid, PM_HINT_NORMAL);
+                       hid_hw_close(hidraw->hid);
+               }
        }
+
 }

 static int hidraw_release(struct inode * inode, struct file * file)
--
1.7.9.5


-Regards
Manoj


--_002_F1F6C959961EA744BBD5B8EEF8B8FEA16DDD19DD43BGMAIL02nvidi_
Content-Type: application/octet-stream;
	name="PATCH-hidraw-close-underlying-device-at-removal-of-las.patch"
Content-Description: PATCH-hidraw-close-underlying-device-at-removal-of-las.patch
Content-Disposition: attachment;
	modification-date="Tue, 01 Oct 2013 13:27:13 GMT"; creation-date="Tue, 01 Oct 2013 13:26:34 GMT";
	size=1641;
	filename="PATCH-hidraw-close-underlying-device-at-removal-of-las.patch"
Content-Transfer-Encoding: base64

RnJvbSBiMzc1MTliNjViZTBkNTFiOTBjNWZjMTc3YzBkYzBjZDJmNjM1OGIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5vaiBDaG91cmFzaWEgPG1jaG91cmFzaWFAbnZpZGlhLmNv
bT4KRGF0ZTogVHVlLCAxIE9jdCAyMDEzIDE1OjM5OjAwICswNTMwClN1YmplY3Q6IFtQQVRDSF0g
SElEOiBoaWRyYXc6IGNsb3NlIHVuZGVybHlpbmcgZGV2aWNlIGF0IHJlbW92YWwgb2YgbGFzdAog
cmVhZGVyCgpFdmVuIHRob3VnaCBkZXZpY2UgZXhpc3QgaXMgc2V0IHRoZSB1bmRlcmx5aW5nCkhX
IGRldmljZSBzaG91bGQgYmUgY2xvc2VkIHdoZW4gdGhlIGxhc3QgcmVhZGVyCm9mIHRoZSBkZXZp
Y2UgaXMgY2xvc2VkIGkuZS4gb3BlbiBjb3VudCBkcm9wcyB0byB6ZXJvLgoKU2lnbmVkLW9mZi1i
eTogTWFub2ogQ2hvdXJhc2lhIDxtY2hvdXJhc2lhQG52aWRpYS5jb20+Ci0tLQogZHJpdmVycy9o
aWQvaGlkcmF3LmMgfCAgIDIxICsrKysrKysrKysrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDE1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9o
aWQvaGlkcmF3LmMgYi9kcml2ZXJzL2hpZC9oaWRyYXcuYwppbmRleCBkYmZlMzAwLi4zYzBkZDQ0
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2hpZC9oaWRyYXcuYworKysgYi9kcml2ZXJzL2hpZC9oaWRy
YXcuYwpAQCAtMzA1LDE5ICszMDUsMjggQEAgc3RhdGljIGludCBoaWRyYXdfZmFzeW5jKGludCBm
ZCwgc3RydWN0IGZpbGUgKmZpbGUsIGludCBvbikKIHN0YXRpYyB2b2lkIGRyb3BfcmVmKHN0cnVj
dCBoaWRyYXcgKmhpZHJhdywgaW50IGV4aXN0c19iaXQpCiB7CiAJaWYgKGV4aXN0c19iaXQpIHsK
LQkJaGlkX2h3X2Nsb3NlKGhpZHJhdy0+aGlkKTsKIAkJaGlkcmF3LT5leGlzdCA9IDA7Ci0JCWlm
IChoaWRyYXctPm9wZW4pCisJCWlmIChoaWRyYXctPm9wZW4pIHsKKwkJCWhpZF9od19jbG9zZSho
aWRyYXctPmhpZCk7CiAJCQl3YWtlX3VwX2ludGVycnVwdGlibGUoJmhpZHJhdy0+d2FpdCk7CisJ
CX0KIAl9IGVsc2UgewogCQktLWhpZHJhdy0+b3BlbjsKIAl9CiAKLQlpZiAoIWhpZHJhdy0+b3Bl
biAmJiAhaGlkcmF3LT5leGlzdCkgewotCQlkZXZpY2VfZGVzdHJveShoaWRyYXdfY2xhc3MsIE1L
REVWKGhpZHJhd19tYWpvciwgaGlkcmF3LT5taW5vcikpOwotCQloaWRyYXdfdGFibGVbaGlkcmF3
LT5taW5vcl0gPSBOVUxMOwotCQlrZnJlZShoaWRyYXcpOworCWlmICghaGlkcmF3LT5vcGVuKSB7
CisJCWlmICghaGlkcmF3LT5leGlzdCkgeworCQkJZGV2aWNlX2Rlc3Ryb3koaGlkcmF3X2NsYXNz
LAorCQkJCU1LREVWKGhpZHJhd19tYWpvciwgaGlkcmF3LT5taW5vcikpOworCQkJaGlkcmF3X3Rh
YmxlW2hpZHJhdy0+bWlub3JdID0gTlVMTDsKKwkJCWtmcmVlKGhpZHJhdyk7CisJCX0gZWxzZSB7
CisJCQkvKiBjbG9zZSBkZXZpY2UgZm9yIGxhc3QgcmVhZGVyICovCisJCQloaWRfaHdfcG93ZXIo
aGlkcmF3LT5oaWQsIFBNX0hJTlRfTk9STUFMKTsKKwkJCWhpZF9od19jbG9zZShoaWRyYXctPmhp
ZCk7CisJCX0KIAl9CisKIH0KIAogc3RhdGljIGludCBoaWRyYXdfcmVsZWFzZShzdHJ1Y3QgaW5v
ZGUgKiBpbm9kZSwgc3RydWN0IGZpbGUgKiBmaWxlKQotLSAKMS43LjkuNQoK

--_002_F1F6C959961EA744BBD5B8EEF8B8FEA16DDD19DD43BGMAIL02nvidi_--
