Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3AOMaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:30:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:23472 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab3AOMaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:30:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="scan'208,223";a="244084702"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V1 1/3] Xen stub driver for CPU hotplug
Thread-Topic: [PATCH V1 1/3] Xen stub driver for CPU hotplug
Thread-Index: Ac3zHBQL8PY/7ecyRCyznwJrYWrqNg==
Date: Tue, 15 Jan 2013 12:30:19 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353C3DB4@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353C3DB4SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DB4SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 110b4ef3b8ebefeaf68832dd8ef8aa916a782e89 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Mon, 14 Jan 2013 15:19:30 +0800
Subject: [PATCH 1/3] Xen stub driver for CPU hotplug

Add Xen stub driver for CPU hotplug, early occupy to block native,
will be replaced later by real Xen processor driver module.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-stub.c |   34 ++++++++++++++++++++++++++++++++--
 include/xen/acpi.h     |    6 ++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
index 01a49e3..681e9cc 100644
--- a/drivers/xen/xen-stub.c
+++ b/drivers/xen/xen-stub.c
@@ -28,12 +28,13 @@
 #include <acpi/acpi_drivers.h>
 #include <xen/acpi.h>
=20
+
+#ifdef CONFIG_ACPI
+
 /*--------------------------------------------
 	stub driver for Xen memory hotplug
 --------------------------------------------*/
=20
-#ifdef CONFIG_ACPI
-
 static const struct acpi_device_id memory_device_ids[] =3D {
 	{ACPI_MEMORY_DEVICE_HID, 0},
 	{"", 0},
@@ -57,4 +58,33 @@ static int __init xen_stub_memory_device_init(void)
 }
 subsys_initcall(xen_stub_memory_device_init);
=20
+
+/*--------------------------------------------
+	stub driver for Xen cpu hotplug
+--------------------------------------------*/
+
+static const struct acpi_device_id processor_device_ids[] =3D {
+	{ACPI_PROCESSOR_OBJECT_HID, 0},
+	{ACPI_PROCESSOR_DEVICE_HID, 0},
+	{"", 0},
+};
+
+struct acpi_driver xen_stub_processor_driver =3D {
+	/* same name as native processor driver to block native loaded */
+	.name =3D "processor",
+	.class =3D ACPI_PROCESSOR_CLASS,
+	.ids =3D processor_device_ids,
+};
+EXPORT_SYMBOL_GPL(xen_stub_processor_driver);
+
+static int __init xen_stub_processor_init(void)
+{
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* just reserve space for Xen, block native driver loaded */
+	return acpi_bus_register_driver(&xen_stub_processor_driver);
+}
+subsys_initcall(xen_stub_processor_init);
+
 #endif
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 7366e58..1c99eb5 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -46,6 +46,12 @@
=20
 extern struct acpi_driver xen_stub_memory_device_driver;
=20
+#define ACPI_PROCESSOR_CLASS            "processor"
+#define ACPI_PROCESSOR_DEVICE_HID       "ACPI0007"
+#define ACPI_PROCESSOR_DEVICE_NAME      "Processor"
+
+extern struct acpi_driver xen_stub_processor_driver;
+
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DB4SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-stub-driver-for-CPU-hotplug.patch"
Content-Description: 0001-Xen-stub-driver-for-CPU-hotplug.patch
Content-Disposition: attachment;
	filename="0001-Xen-stub-driver-for-CPU-hotplug.patch"; size=2536;
	creation-date="Tue, 15 Jan 2013 12:28:09 GMT";
	modification-date="Tue, 15 Jan 2013 20:17:14 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxMTBiNGVmM2I4ZWJlZmVhZjY4ODMyZGQ4ZWY4YWE5MTZhNzgyZTg5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBNb24sIDE0IEphbiAyMDEzIDE1OjE5OjMwICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzNd
IFhlbiBzdHViIGRyaXZlciBmb3IgQ1BVIGhvdHBsdWcKCkFkZCBYZW4gc3R1YiBkcml2ZXIgZm9y
IENQVSBob3RwbHVnLCBlYXJseSBvY2N1cHkgdG8gYmxvY2sgbmF0aXZlLAp3aWxsIGJlIHJlcGxh
Y2VkIGxhdGVyIGJ5IHJlYWwgWGVuIHByb2Nlc3NvciBkcml2ZXIgbW9kdWxlLgoKU2lnbmVkLW9m
Zi1ieTogTGl1IEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hl
bi94ZW4tc3R1Yi5jIHwgICAzNCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tCiBp
bmNsdWRlL3hlbi9hY3BpLmggICAgIHwgICAgNiArKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMzgg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi94
ZW4tc3R1Yi5jIGIvZHJpdmVycy94ZW4veGVuLXN0dWIuYwppbmRleCAwMWE0OWUzLi42ODFlOWNj
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi94ZW4tc3R1Yi5jCisrKyBiL2RyaXZlcnMveGVuL3hl
bi1zdHViLmMKQEAgLTI4LDEyICsyOCwxMyBAQAogI2luY2x1ZGUgPGFjcGkvYWNwaV9kcml2ZXJz
Lmg+CiAjaW5jbHVkZSA8eGVuL2FjcGkuaD4KIAorCisjaWZkZWYgQ09ORklHX0FDUEkKKwogLyot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogCXN0dWIgZHJpdmVy
IGZvciBYZW4gbWVtb3J5IGhvdHBsdWcKIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tKi8KIAotI2lmZGVmIENPTkZJR19BQ1BJCi0KIHN0YXRpYyBjb25zdCBzdHJ1
Y3QgYWNwaV9kZXZpY2VfaWQgbWVtb3J5X2RldmljZV9pZHNbXSA9IHsKIAl7QUNQSV9NRU1PUllf
REVWSUNFX0hJRCwgMH0sCiAJeyIiLCAwfSwKQEAgLTU3LDQgKzU4LDMzIEBAIHN0YXRpYyBpbnQg
X19pbml0IHhlbl9zdHViX21lbW9yeV9kZXZpY2VfaW5pdCh2b2lkKQogfQogc3Vic3lzX2luaXRj
YWxsKHhlbl9zdHViX21lbW9yeV9kZXZpY2VfaW5pdCk7CiAKKworLyotLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQorCXN0dWIgZHJpdmVyIGZvciBYZW4gY3B1IGhv
dHBsdWcKKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8KKwor
c3RhdGljIGNvbnN0IHN0cnVjdCBhY3BpX2RldmljZV9pZCBwcm9jZXNzb3JfZGV2aWNlX2lkc1td
ID0geworCXtBQ1BJX1BST0NFU1NPUl9PQkpFQ1RfSElELCAwfSwKKwl7QUNQSV9QUk9DRVNTT1Jf
REVWSUNFX0hJRCwgMH0sCisJeyIiLCAwfSwKK307CisKK3N0cnVjdCBhY3BpX2RyaXZlciB4ZW5f
c3R1Yl9wcm9jZXNzb3JfZHJpdmVyID0geworCS8qIHNhbWUgbmFtZSBhcyBuYXRpdmUgcHJvY2Vz
c29yIGRyaXZlciB0byBibG9jayBuYXRpdmUgbG9hZGVkICovCisJLm5hbWUgPSAicHJvY2Vzc29y
IiwKKwkuY2xhc3MgPSBBQ1BJX1BST0NFU1NPUl9DTEFTUywKKwkuaWRzID0gcHJvY2Vzc29yX2Rl
dmljZV9pZHMsCit9OworRVhQT1JUX1NZTUJPTF9HUEwoeGVuX3N0dWJfcHJvY2Vzc29yX2RyaXZl
cik7CisKK3N0YXRpYyBpbnQgX19pbml0IHhlbl9zdHViX3Byb2Nlc3Nvcl9pbml0KHZvaWQpCit7
CisJaWYgKCF4ZW5faW5pdGlhbF9kb21haW4oKSkKKwkJcmV0dXJuIC1FTk9ERVY7CisKKwkvKiBq
dXN0IHJlc2VydmUgc3BhY2UgZm9yIFhlbiwgYmxvY2sgbmF0aXZlIGRyaXZlciBsb2FkZWQgKi8K
KwlyZXR1cm4gYWNwaV9idXNfcmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fc3R1Yl9wcm9jZXNzb3JfZHJp
dmVyKTsKK30KK3N1YnN5c19pbml0Y2FsbCh4ZW5fc3R1Yl9wcm9jZXNzb3JfaW5pdCk7CisKICNl
bmRpZgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vYWNwaS5oIGIvaW5jbHVkZS94ZW4vYWNwaS5o
CmluZGV4IDczNjZlNTguLjFjOTllYjUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUveGVuL2FjcGkuaAor
KysgYi9pbmNsdWRlL3hlbi9hY3BpLmgKQEAgLTQ2LDYgKzQ2LDEyIEBACiAKIGV4dGVybiBzdHJ1
Y3QgYWNwaV9kcml2ZXIgeGVuX3N0dWJfbWVtb3J5X2RldmljZV9kcml2ZXI7CiAKKyNkZWZpbmUg
QUNQSV9QUk9DRVNTT1JfQ0xBU1MgICAgICAgICAgICAicHJvY2Vzc29yIgorI2RlZmluZSBBQ1BJ
X1BST0NFU1NPUl9ERVZJQ0VfSElEICAgICAgICJBQ1BJMDAwNyIKKyNkZWZpbmUgQUNQSV9QUk9D
RVNTT1JfREVWSUNFX05BTUUgICAgICAiUHJvY2Vzc29yIgorCitleHRlcm4gc3RydWN0IGFjcGlf
ZHJpdmVyIHhlbl9zdHViX3Byb2Nlc3Nvcl9kcml2ZXI7CisKIGludCB4ZW5fYWNwaV9ub3RpZnlf
aHlwZXJ2aXNvcl9zdGF0ZSh1OCBzbGVlcF9zdGF0ZSwKIAkJCQkgICAgIHUzMiBwbTFhX2NudCwg
dTMyIHBtMWJfY25kKTsKIAotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DB4SHSMSX101ccrcorpi_--
