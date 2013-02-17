Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3BQHj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 02:39:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:23970 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab3BQHjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 02:39:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,682,1355126400"; 
   d="scan'208,223";a="263685543"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH 2/2] xen/acpi: xen cpu hotplug minor updates
Thread-Topic: [PATCH 2/2] xen/acpi: xen cpu hotplug minor updates
Thread-Index: Ac4M4fgaVCcyNOGFQf2uUoQZIyZF5A==
Date: Sun, 17 Feb 2013 07:39:51 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353FCCD5@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353FCCD5SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353FCCD5SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 195df2bf6174959baa025ccb249041bb53d6060a Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sun, 17 Feb 2013 11:47:24 +0800
Subject: [PATCH 2/2] xen/acpi: xen cpu hotplug minor updates

Recently at native Rafael did some cleanup for acpi, say, drop
acpi_bus_add, remove unnecessary argument of acpi_bus_scan,
and run acpi_bus_scan under acpi_scan_lock.

This patch does similar cleanup for xen cpu hotplug, removing
redundant logic, and adding lock.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-acpi-cpuhotplug.c |   34 ++++++++++++---------------------=
-
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuho=
tplug.c
index 7578279..18c742b 100644
--- a/drivers/xen/xen-acpi-cpuhotplug.c
+++ b/drivers/xen/xen-acpi-cpuhotplug.c
@@ -239,24 +239,6 @@ static acpi_status xen_acpi_cpu_hotadd(struct acpi_pro=
cessor *pr)
 	return AE_OK;
 }
=20
-static
-int acpi_processor_device_add(acpi_handle handle, struct acpi_device **dev=
ice)
-{
-	acpi_handle phandle;
-	struct acpi_device *pdev;
-
-	if (acpi_get_parent(handle, &phandle))
-		return -ENODEV;
-
-	if (acpi_bus_get_device(phandle, &pdev))
-		return -ENODEV;
-
-	if (acpi_bus_scan(handle))
-		return -ENODEV;
-
-	return 0;
-}
-
 static int acpi_processor_device_remove(struct acpi_device *device)
 {
 	pr_debug(PREFIX "Xen does not support CPU hotremove\n");
@@ -272,6 +254,8 @@ static void acpi_processor_hotplug_notify(acpi_handle h=
andle,
 	u32 ost_code =3D ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 	int result;
=20
+	acpi_scan_lock_acquire();
+
 	switch (event) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
@@ -286,12 +270,16 @@ static void acpi_processor_hotplug_notify(acpi_handle=
 handle,
 		if (!acpi_bus_get_device(handle, &device))
 			break;
=20
-		result =3D acpi_processor_device_add(handle, &device);
+		result =3D acpi_bus_scan(handle);
 		if (result) {
 			pr_err(PREFIX "Unable to add the device\n");
 			break;
 		}
-
+		result =3D acpi_bus_get_device(handle, &device);
+		if (result) {
+			pr_err(PREFIX "Missing device object\n");
+			break;
+		}
 		ost_code =3D ACPI_OST_SC_SUCCESS;
 		break;
=20
@@ -321,11 +309,13 @@ static void acpi_processor_hotplug_notify(acpi_handle=
 handle,
 				  "Unsupported event [0x%x]\n", event));
=20
 		/* non-hotplug event; possibly handled by other handler */
-		return;
+		goto out;
 	}
=20
 	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
-	return;
+
+out:
+	acpi_scan_lock_release();
 }
=20
 static acpi_status is_processor_device(acpi_handle handle)
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353FCCD5SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-xen-acpi-xen-cpu-hotplug-minor-updates.patch"
Content-Description: 0002-xen-acpi-xen-cpu-hotplug-minor-updates.patch
Content-Disposition: attachment;
	filename="0002-xen-acpi-xen-cpu-hotplug-minor-updates.patch"; size=2614;
	creation-date="Sun, 17 Feb 2013 07:24:14 GMT";
	modification-date="Sun, 17 Feb 2013 15:14:24 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxOTVkZjJiZjYxNzQ5NTliYWEwMjVjY2IyNDkwNDFiYjUzZDYwNjBhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBTdW4sIDE3IEZlYiAyMDEzIDExOjQ3OjI0ICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzJd
IHhlbi9hY3BpOiB4ZW4gY3B1IGhvdHBsdWcgbWlub3IgdXBkYXRlcwoKUmVjZW50bHkgYXQgbmF0
aXZlIFJhZmFlbCBkaWQgc29tZSBjbGVhbnVwIGZvciBhY3BpLCBzYXksIGRyb3AKYWNwaV9idXNf
YWRkLCByZW1vdmUgdW5uZWNlc3NhcnkgYXJndW1lbnQgb2YgYWNwaV9idXNfc2NhbiwKYW5kIHJ1
biBhY3BpX2J1c19zY2FuIHVuZGVyIGFjcGlfc2Nhbl9sb2NrLgoKVGhpcyBwYXRjaCBkb2VzIHNp
bWlsYXIgY2xlYW51cCBmb3IgeGVuIGNwdSBob3RwbHVnLCByZW1vdmluZwpyZWR1bmRhbnQgbG9n
aWMsIGFuZCBhZGRpbmcgbG9jay4KClNpZ25lZC1vZmYtYnk6IExpdSBKaW5zb25nIDxqaW5zb25n
LmxpdUBpbnRlbC5jb20+Ci0tLQogZHJpdmVycy94ZW4veGVuLWFjcGktY3B1aG90cGx1Zy5jIHwg
ICAzNCArKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQs
IDEyIGluc2VydGlvbnMoKyksIDIyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
eGVuL3hlbi1hY3BpLWNwdWhvdHBsdWcuYyBiL2RyaXZlcnMveGVuL3hlbi1hY3BpLWNwdWhvdHBs
dWcuYwppbmRleCA3NTc4Mjc5Li4xOGM3NDJiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi94ZW4t
YWNwaS1jcHVob3RwbHVnLmMKKysrIGIvZHJpdmVycy94ZW4veGVuLWFjcGktY3B1aG90cGx1Zy5j
CkBAIC0yMzksMjQgKzIzOSw2IEBAIHN0YXRpYyBhY3BpX3N0YXR1cyB4ZW5fYWNwaV9jcHVfaG90
YWRkKHN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHIpCiAJcmV0dXJuIEFFX09LOwogfQogCi1zdGF0
aWMKLWludCBhY3BpX3Byb2Nlc3Nvcl9kZXZpY2VfYWRkKGFjcGlfaGFuZGxlIGhhbmRsZSwgc3Ry
dWN0IGFjcGlfZGV2aWNlICoqZGV2aWNlKQotewotCWFjcGlfaGFuZGxlIHBoYW5kbGU7Ci0Jc3Ry
dWN0IGFjcGlfZGV2aWNlICpwZGV2OwotCi0JaWYgKGFjcGlfZ2V0X3BhcmVudChoYW5kbGUsICZw
aGFuZGxlKSkKLQkJcmV0dXJuIC1FTk9ERVY7Ci0KLQlpZiAoYWNwaV9idXNfZ2V0X2RldmljZShw
aGFuZGxlLCAmcGRldikpCi0JCXJldHVybiAtRU5PREVWOwotCi0JaWYgKGFjcGlfYnVzX3NjYW4o
aGFuZGxlKSkKLQkJcmV0dXJuIC1FTk9ERVY7Ci0KLQlyZXR1cm4gMDsKLX0KLQogc3RhdGljIGlu
dCBhY3BpX3Byb2Nlc3Nvcl9kZXZpY2VfcmVtb3ZlKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNl
KQogewogCXByX2RlYnVnKFBSRUZJWCAiWGVuIGRvZXMgbm90IHN1cHBvcnQgQ1BVIGhvdHJlbW92
ZVxuIik7CkBAIC0yNzIsNiArMjU0LDggQEAgc3RhdGljIHZvaWQgYWNwaV9wcm9jZXNzb3JfaG90
cGx1Z19ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxlLAogCXUzMiBvc3RfY29kZSA9IEFDUElfT1NU
X1NDX05PTl9TUEVDSUZJQ19GQUlMVVJFOyAvKiBkZWZhdWx0ICovCiAJaW50IHJlc3VsdDsKIAor
CWFjcGlfc2Nhbl9sb2NrX2FjcXVpcmUoKTsKKwogCXN3aXRjaCAoZXZlbnQpIHsKIAljYXNlIEFD
UElfTk9USUZZX0JVU19DSEVDSzoKIAljYXNlIEFDUElfTk9USUZZX0RFVklDRV9DSEVDSzoKQEAg
LTI4NiwxMiArMjcwLDE2IEBAIHN0YXRpYyB2b2lkIGFjcGlfcHJvY2Vzc29yX2hvdHBsdWdfbm90
aWZ5KGFjcGlfaGFuZGxlIGhhbmRsZSwKIAkJaWYgKCFhY3BpX2J1c19nZXRfZGV2aWNlKGhhbmRs
ZSwgJmRldmljZSkpCiAJCQlicmVhazsKIAotCQlyZXN1bHQgPSBhY3BpX3Byb2Nlc3Nvcl9kZXZp
Y2VfYWRkKGhhbmRsZSwgJmRldmljZSk7CisJCXJlc3VsdCA9IGFjcGlfYnVzX3NjYW4oaGFuZGxl
KTsKIAkJaWYgKHJlc3VsdCkgewogCQkJcHJfZXJyKFBSRUZJWCAiVW5hYmxlIHRvIGFkZCB0aGUg
ZGV2aWNlXG4iKTsKIAkJCWJyZWFrOwogCQl9Ci0KKwkJcmVzdWx0ID0gYWNwaV9idXNfZ2V0X2Rl
dmljZShoYW5kbGUsICZkZXZpY2UpOworCQlpZiAocmVzdWx0KSB7CisJCQlwcl9lcnIoUFJFRklY
ICJNaXNzaW5nIGRldmljZSBvYmplY3RcbiIpOworCQkJYnJlYWs7CisJCX0KIAkJb3N0X2NvZGUg
PSBBQ1BJX09TVF9TQ19TVUNDRVNTOwogCQlicmVhazsKIApAQCAtMzIxLDExICszMDksMTMgQEAg
c3RhdGljIHZvaWQgYWNwaV9wcm9jZXNzb3JfaG90cGx1Z19ub3RpZnkoYWNwaV9oYW5kbGUgaGFu
ZGxlLAogCQkJCSAgIlVuc3VwcG9ydGVkIGV2ZW50IFsweCV4XVxuIiwgZXZlbnQpKTsKIAogCQkv
KiBub24taG90cGx1ZyBldmVudDsgcG9zc2libHkgaGFuZGxlZCBieSBvdGhlciBoYW5kbGVyICov
Ci0JCXJldHVybjsKKwkJZ290byBvdXQ7CiAJfQogCiAJKHZvaWQpIGFjcGlfZXZhbHVhdGVfaG90
cGx1Z19vc3QoaGFuZGxlLCBldmVudCwgb3N0X2NvZGUsIE5VTEwpOwotCXJldHVybjsKKworb3V0
OgorCWFjcGlfc2Nhbl9sb2NrX3JlbGVhc2UoKTsKIH0KIAogc3RhdGljIGFjcGlfc3RhdHVzIGlz
X3Byb2Nlc3Nvcl9kZXZpY2UoYWNwaV9oYW5kbGUgaGFuZGxlKQotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923353FCCD5SHSMSX101ccrcorpi_--
