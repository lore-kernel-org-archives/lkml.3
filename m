Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3BQHhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 02:37:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:47818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab3BQHhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 02:37:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,682,1355126400"; 
   d="scan'208,223";a="263685221"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH 1/2] xen/acpi: xen memory hotplug minor updates
Thread-Topic: [PATCH 1/2] xen/acpi: xen memory hotplug minor updates
Thread-Index: Ac4M4abEDm8BJ5/PS2+i93UswO8RQQ==
Date: Sun, 17 Feb 2013 07:37:34 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353FCCC8@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353FCCC8SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353FCCC8SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From aa363f1a4f862fab2f50dfe3ad602bb8dd234709 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sat, 16 Feb 2013 16:59:03 +0800
Subject: [PATCH 1/2] xen/acpi: xen memory hotplug minor updates

Dan Carpenter found current xen memory hotplug logic
has potential issue: at func acpi_memory_get_device()
*mem_device =3D acpi_driver_data(device);
while the device may be NULL and then dereference.

At native side, Rafael recently updated acpi_memory_get_device(),
dropping acpi_bus_add, adding lock, and avoiding above issue.

This patch updates xen memory hotplug logic accordingly, removing
redundant logic, adding lock, and avoiding dereference.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-acpi-memhotplug.c |   52 ++++++++++++++++++---------------=
---
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
index 853b12d..faef5b3 100644
--- a/drivers/xen/xen-acpi-memhotplug.c
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -158,31 +158,17 @@ acpi_memory_get_device_resources(struct acpi_memory_d=
evice *mem_device)
 	return 0;
 }
=20
-static int
-acpi_memory_get_device(acpi_handle handle,
-		       struct acpi_memory_device **mem_device)
+static int acpi_memory_get_device(acpi_handle handle,
+				  struct acpi_memory_device **mem_device)
 {
-	acpi_status status;
-	acpi_handle phandle;
 	struct acpi_device *device =3D NULL;
-	struct acpi_device *pdevice =3D NULL;
-	int result;
+	int result =3D 0;
=20
-	if (!acpi_bus_get_device(handle, &device) && device)
-		goto end;
+	acpi_scan_lock_acquire();
=20
-	status =3D acpi_get_parent(handle, &phandle);
-	if (ACPI_FAILURE(status)) {
-		pr_warn(PREFIX "Cannot find acpi parent\n");
-		return -EINVAL;
-	}
-
-	/* Get the parent device */
-	result =3D acpi_bus_get_device(phandle, &pdevice);
-	if (result) {
-		pr_warn(PREFIX "Cannot get acpi bus device\n");
-		return -EINVAL;
-	}
+	acpi_bus_get_device(handle, &device);
+	if (device)
+		goto end;
=20
 	/*
 	 * Now add the notified device.  This creates the acpi_device
@@ -190,18 +176,28 @@ acpi_memory_get_device(acpi_handle handle,
 	 */
 	result =3D acpi_bus_scan(handle);
 	if (result) {
-		pr_warn(PREFIX "Cannot add acpi bus\n");
-		return -EINVAL;
+		pr_warn(PREFIX "ACPI namespace scan failed\n");
+		result =3D -EINVAL;
+		goto out;
+	}
+	result =3D acpi_bus_get_device(handle, &device);
+	if (result) {
+		pr_warn(PREFIX "Missing device object\n");
+		result =3D -EINVAL;
+		goto out;
 	}
=20
 end:
 	*mem_device =3D acpi_driver_data(device);
 	if (!(*mem_device)) {
-		pr_err(PREFIX "Driver data not found\n");
-		return -ENODEV;
+		pr_err(PREFIX "driver data not found\n");
+		result =3D -ENODEV;
+		goto out;
 	}
=20
-	return 0;
+out:
+	acpi_scan_lock_release();
+	return result;
 }
=20
 static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
@@ -259,12 +255,15 @@ static void acpi_memory_device_notify(acpi_handle han=
dle, u32 event, void *data)
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			"\nReceived EJECT REQUEST notification for device\n"));
=20
+		acpi_scan_lock_acquire();
 		if (acpi_bus_get_device(handle, &device)) {
+			acpi_scan_lock_release();
 			pr_err(PREFIX "Device doesn't exist\n");
 			break;
 		}
 		mem_device =3D acpi_driver_data(device);
 		if (!mem_device) {
+			acpi_scan_lock_release();
 			pr_err(PREFIX "Driver Data is NULL\n");
 			break;
 		}
@@ -274,6 +273,7 @@ static void acpi_memory_device_notify(acpi_handle handl=
e, u32 event, void *data)
 		 * acpi_bus_remove if Xen support hotremove in the future
 		 */
 		acpi_memory_disable_device(mem_device);
+		acpi_scan_lock_release();
 		break;
=20
 	default:
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353FCCC8SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-acpi-xen-memory-hotplug-minor-updates.patch"
Content-Description: 0001-xen-acpi-xen-memory-hotplug-minor-updates.patch
Content-Disposition: attachment;
	filename="0001-xen-acpi-xen-memory-hotplug-minor-updates.patch"; size=3664;
	creation-date="Sun, 17 Feb 2013 07:24:14 GMT";
	modification-date="Sun, 17 Feb 2013 15:14:12 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhYTM2M2YxYTRmODYyZmFiMmY1MGRmZTNhZDYwMmJiOGRkMjM0NzA5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBTYXQsIDE2IEZlYiAyMDEzIDE2OjU5OjAzICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IHhlbi9hY3BpOiB4ZW4gbWVtb3J5IGhvdHBsdWcgbWlub3IgdXBkYXRlcwoKRGFuIENhcnBlbnRl
ciBmb3VuZCBjdXJyZW50IHhlbiBtZW1vcnkgaG90cGx1ZyBsb2dpYwpoYXMgcG90ZW50aWFsIGlz
c3VlOiBhdCBmdW5jIGFjcGlfbWVtb3J5X2dldF9kZXZpY2UoKQoqbWVtX2RldmljZSA9IGFjcGlf
ZHJpdmVyX2RhdGEoZGV2aWNlKTsKd2hpbGUgdGhlIGRldmljZSBtYXkgYmUgTlVMTCBhbmQgdGhl
biBkZXJlZmVyZW5jZS4KCkF0IG5hdGl2ZSBzaWRlLCBSYWZhZWwgcmVjZW50bHkgdXBkYXRlZCBh
Y3BpX21lbW9yeV9nZXRfZGV2aWNlKCksCmRyb3BwaW5nIGFjcGlfYnVzX2FkZCwgYWRkaW5nIGxv
Y2ssIGFuZCBhdm9pZGluZyBhYm92ZSBpc3N1ZS4KClRoaXMgcGF0Y2ggdXBkYXRlcyB4ZW4gbWVt
b3J5IGhvdHBsdWcgbG9naWMgYWNjb3JkaW5nbHksIHJlbW92aW5nCnJlZHVuZGFudCBsb2dpYywg
YWRkaW5nIGxvY2ssIGFuZCBhdm9pZGluZyBkZXJlZmVyZW5jZS4KClNpZ25lZC1vZmYtYnk6IExp
dSBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+Ci0tLQogZHJpdmVycy94ZW4veGVuLWFj
cGktbWVtaG90cGx1Zy5jIHwgICA1MiArKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0t
LS0KIDEgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4veGVuLWFjcGktbWVtaG90cGx1Zy5jIGIvZHJpdmVycy94
ZW4veGVuLWFjcGktbWVtaG90cGx1Zy5jCmluZGV4IDg1M2IxMmQuLmZhZWY1YjMgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMveGVuL3hlbi1hY3BpLW1lbWhvdHBsdWcuYworKysgYi9kcml2ZXJzL3hlbi94
ZW4tYWNwaS1tZW1ob3RwbHVnLmMKQEAgLTE1OCwzMSArMTU4LDE3IEBAIGFjcGlfbWVtb3J5X2dl
dF9kZXZpY2VfcmVzb3VyY2VzKHN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2Up
CiAJcmV0dXJuIDA7CiB9CiAKLXN0YXRpYyBpbnQKLWFjcGlfbWVtb3J5X2dldF9kZXZpY2UoYWNw
aV9oYW5kbGUgaGFuZGxlLAotCQkgICAgICAgc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSAqKm1l
bV9kZXZpY2UpCitzdGF0aWMgaW50IGFjcGlfbWVtb3J5X2dldF9kZXZpY2UoYWNwaV9oYW5kbGUg
aGFuZGxlLAorCQkJCSAgc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSAqKm1lbV9kZXZpY2UpCiB7
Ci0JYWNwaV9zdGF0dXMgc3RhdHVzOwotCWFjcGlfaGFuZGxlIHBoYW5kbGU7CiAJc3RydWN0IGFj
cGlfZGV2aWNlICpkZXZpY2UgPSBOVUxMOwotCXN0cnVjdCBhY3BpX2RldmljZSAqcGRldmljZSA9
IE5VTEw7Ci0JaW50IHJlc3VsdDsKKwlpbnQgcmVzdWx0ID0gMDsKIAotCWlmICghYWNwaV9idXNf
Z2V0X2RldmljZShoYW5kbGUsICZkZXZpY2UpICYmIGRldmljZSkKLQkJZ290byBlbmQ7CisJYWNw
aV9zY2FuX2xvY2tfYWNxdWlyZSgpOwogCi0Jc3RhdHVzID0gYWNwaV9nZXRfcGFyZW50KGhhbmRs
ZSwgJnBoYW5kbGUpOwotCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkgewotCQlwcl93YXJuKFBS
RUZJWCAiQ2Fubm90IGZpbmQgYWNwaSBwYXJlbnRcbiIpOwotCQlyZXR1cm4gLUVJTlZBTDsKLQl9
Ci0KLQkvKiBHZXQgdGhlIHBhcmVudCBkZXZpY2UgKi8KLQlyZXN1bHQgPSBhY3BpX2J1c19nZXRf
ZGV2aWNlKHBoYW5kbGUsICZwZGV2aWNlKTsKLQlpZiAocmVzdWx0KSB7Ci0JCXByX3dhcm4oUFJF
RklYICJDYW5ub3QgZ2V0IGFjcGkgYnVzIGRldmljZVxuIik7Ci0JCXJldHVybiAtRUlOVkFMOwot
CX0KKwlhY3BpX2J1c19nZXRfZGV2aWNlKGhhbmRsZSwgJmRldmljZSk7CisJaWYgKGRldmljZSkK
KwkJZ290byBlbmQ7CiAKIAkvKgogCSAqIE5vdyBhZGQgdGhlIG5vdGlmaWVkIGRldmljZS4gIFRo
aXMgY3JlYXRlcyB0aGUgYWNwaV9kZXZpY2UKQEAgLTE5MCwxOCArMTc2LDI4IEBAIGFjcGlfbWVt
b3J5X2dldF9kZXZpY2UoYWNwaV9oYW5kbGUgaGFuZGxlLAogCSAqLwogCXJlc3VsdCA9IGFjcGlf
YnVzX3NjYW4oaGFuZGxlKTsKIAlpZiAocmVzdWx0KSB7Ci0JCXByX3dhcm4oUFJFRklYICJDYW5u
b3QgYWRkIGFjcGkgYnVzXG4iKTsKLQkJcmV0dXJuIC1FSU5WQUw7CisJCXByX3dhcm4oUFJFRklY
ICJBQ1BJIG5hbWVzcGFjZSBzY2FuIGZhaWxlZFxuIik7CisJCXJlc3VsdCA9IC1FSU5WQUw7CisJ
CWdvdG8gb3V0OworCX0KKwlyZXN1bHQgPSBhY3BpX2J1c19nZXRfZGV2aWNlKGhhbmRsZSwgJmRl
dmljZSk7CisJaWYgKHJlc3VsdCkgeworCQlwcl93YXJuKFBSRUZJWCAiTWlzc2luZyBkZXZpY2Ug
b2JqZWN0XG4iKTsKKwkJcmVzdWx0ID0gLUVJTlZBTDsKKwkJZ290byBvdXQ7CiAJfQogCiBlbmQ6
CiAJKm1lbV9kZXZpY2UgPSBhY3BpX2RyaXZlcl9kYXRhKGRldmljZSk7CiAJaWYgKCEoKm1lbV9k
ZXZpY2UpKSB7Ci0JCXByX2VycihQUkVGSVggIkRyaXZlciBkYXRhIG5vdCBmb3VuZFxuIik7Ci0J
CXJldHVybiAtRU5PREVWOworCQlwcl9lcnIoUFJFRklYICJkcml2ZXIgZGF0YSBub3QgZm91bmRc
biIpOworCQlyZXN1bHQgPSAtRU5PREVWOworCQlnb3RvIG91dDsKIAl9CiAKLQlyZXR1cm4gMDsK
K291dDoKKwlhY3BpX3NjYW5fbG9ja19yZWxlYXNlKCk7CisJcmV0dXJuIHJlc3VsdDsKIH0KIAog
c3RhdGljIGludCBhY3BpX21lbW9yeV9jaGVja19kZXZpY2Uoc3RydWN0IGFjcGlfbWVtb3J5X2Rl
dmljZSAqbWVtX2RldmljZSkKQEAgLTI1OSwxMiArMjU1LDE1IEBAIHN0YXRpYyB2b2lkIGFjcGlf
bWVtb3J5X2RldmljZV9ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxlLCB1MzIgZXZlbnQsIHZvaWQg
KmRhdGEpCiAJCUFDUElfREVCVUdfUFJJTlQoKEFDUElfREJfSU5GTywKIAkJCSJcblJlY2VpdmVk
IEVKRUNUIFJFUVVFU1Qgbm90aWZpY2F0aW9uIGZvciBkZXZpY2VcbiIpKTsKIAorCQlhY3BpX3Nj
YW5fbG9ja19hY3F1aXJlKCk7CiAJCWlmIChhY3BpX2J1c19nZXRfZGV2aWNlKGhhbmRsZSwgJmRl
dmljZSkpIHsKKwkJCWFjcGlfc2Nhbl9sb2NrX3JlbGVhc2UoKTsKIAkJCXByX2VycihQUkVGSVgg
IkRldmljZSBkb2Vzbid0IGV4aXN0XG4iKTsKIAkJCWJyZWFrOwogCQl9CiAJCW1lbV9kZXZpY2Ug
PSBhY3BpX2RyaXZlcl9kYXRhKGRldmljZSk7CiAJCWlmICghbWVtX2RldmljZSkgeworCQkJYWNw
aV9zY2FuX2xvY2tfcmVsZWFzZSgpOwogCQkJcHJfZXJyKFBSRUZJWCAiRHJpdmVyIERhdGEgaXMg
TlVMTFxuIik7CiAJCQlicmVhazsKIAkJfQpAQCAtMjc0LDYgKzI3Myw3IEBAIHN0YXRpYyB2b2lk
IGFjcGlfbWVtb3J5X2RldmljZV9ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxlLCB1MzIgZXZlbnQs
IHZvaWQgKmRhdGEpCiAJCSAqIGFjcGlfYnVzX3JlbW92ZSBpZiBYZW4gc3VwcG9ydCBob3RyZW1v
dmUgaW4gdGhlIGZ1dHVyZQogCQkgKi8KIAkJYWNwaV9tZW1vcnlfZGlzYWJsZV9kZXZpY2UobWVt
X2RldmljZSk7CisJCWFjcGlfc2Nhbl9sb2NrX3JlbGVhc2UoKTsKIAkJYnJlYWs7CiAKIAlkZWZh
dWx0OgotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923353FCCC8SHSMSX101ccrcorpi_--
