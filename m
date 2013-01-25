Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3AYI6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:58:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:43768 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3AYI6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:58:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,537,1355126400"; 
   d="scan'208,223";a="282059961"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V2 1/3] Xen stub driver for CPU hotplug
Thread-Topic: [PATCH V2 1/3] Xen stub driver for CPU hotplug
Thread-Index: Ac362fePW2aBwoidR9+YO2QW6QHzZA==
Date: Fri, 25 Jan 2013 08:57:13 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353DD6E1@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353DD6E1SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6E1SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 74028ed6e4190ba0ea8ec87cba1d28de95a128bf Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Thu, 24 Jan 2013 22:12:30 +0800
Subject: [PATCH 1/3] Xen stub driver for CPU hotplug

Add Xen stub driver for CPU hotplug, early occupy to block native,
will be replaced later by real Xen processor driver module.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-stub.c |   39 +++++++++++++++++++++++++++++++++++++--
 include/xen/acpi.h     |    7 +++++++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
index 811152f..d85e411 100644
--- a/drivers/xen/xen-stub.c
+++ b/drivers/xen/xen-stub.c
@@ -28,12 +28,12 @@
 #include <acpi/acpi_drivers.h>
 #include <xen/acpi.h>
=20
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
@@ -63,4 +63,39 @@ void xen_stub_memory_device_exit(void)
 }
 EXPORT_SYMBOL_GPL(xen_stub_memory_device_exit);
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
+static struct acpi_driver xen_stub_processor_driver =3D {
+	/* same name as native processor driver to block native loaded */
+	.name =3D "processor",
+	.class =3D ACPI_PROCESSOR_CLASS,
+	.ids =3D processor_device_ids,
+};
+
+int xen_stub_processor_init(void)
+{
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* just reserve space for Xen, block native driver loaded */
+	return acpi_bus_register_driver(&xen_stub_processor_driver);
+}
+EXPORT_SYMBOL_GPL(xen_stub_processor_init);
+subsys_initcall(xen_stub_processor_init);
+
+void xen_stub_processor_exit(void)
+{
+	acpi_bus_unregister_driver(&xen_stub_processor_driver);
+}
+EXPORT_SYMBOL_GPL(xen_stub_processor_exit);
+
 #endif
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index ce7e526..2b3103b 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -47,6 +47,13 @@
 int xen_stub_memory_device_init(void);
 void xen_stub_memory_device_exit(void);
=20
+#define ACPI_PROCESSOR_CLASS            "processor"
+#define ACPI_PROCESSOR_DEVICE_HID       "ACPI0007"
+#define ACPI_PROCESSOR_DEVICE_NAME      "Processor"
+
+int xen_stub_processor_init(void);
+void xen_stub_processor_exit(void);
+
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6E1SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-stub-driver-for-CPU-hotplug.patch"
Content-Description: 0001-Xen-stub-driver-for-CPU-hotplug.patch
Content-Disposition: attachment;
	filename="0001-Xen-stub-driver-for-CPU-hotplug.patch"; size=2707;
	creation-date="Fri, 25 Jan 2013 08:52:32 GMT";
	modification-date="Fri, 25 Jan 2013 16:45:18 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3NDAyOGVkNmU0MTkwYmEwZWE4ZWM4N2NiYTFkMjhkZTk1YTEyOGJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUaHUsIDI0IEphbiAyMDEzIDIyOjEyOjMwICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzNd
IFhlbiBzdHViIGRyaXZlciBmb3IgQ1BVIGhvdHBsdWcKCkFkZCBYZW4gc3R1YiBkcml2ZXIgZm9y
IENQVSBob3RwbHVnLCBlYXJseSBvY2N1cHkgdG8gYmxvY2sgbmF0aXZlLAp3aWxsIGJlIHJlcGxh
Y2VkIGxhdGVyIGJ5IHJlYWwgWGVuIHByb2Nlc3NvciBkcml2ZXIgbW9kdWxlLgoKU2lnbmVkLW9m
Zi1ieTogTGl1IEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hl
bi94ZW4tc3R1Yi5jIHwgICAzOSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0KIGluY2x1ZGUveGVuL2FjcGkuaCAgICAgfCAgICA3ICsrKysrKysKIDIgZmlsZXMgY2hhbmdl
ZCwgNDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3hlbi94ZW4tc3R1Yi5jIGIvZHJpdmVycy94ZW4veGVuLXN0dWIuYwppbmRleCA4MTExNTJmLi5k
ODVlNDExIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi94ZW4tc3R1Yi5jCisrKyBiL2RyaXZlcnMv
eGVuL3hlbi1zdHViLmMKQEAgLTI4LDEyICsyOCwxMiBAQAogI2luY2x1ZGUgPGFjcGkvYWNwaV9k
cml2ZXJzLmg+CiAjaW5jbHVkZSA8eGVuL2FjcGkuaD4KIAorI2lmZGVmIENPTkZJR19BQ1BJCisK
IC8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIAlzdHViIGRy
aXZlciBmb3IgWGVuIG1lbW9yeSBob3RwbHVnCiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLSovCiAKLSNpZmRlZiBDT05GSUdfQUNQSQotCiBzdGF0aWMgY29uc3Qg
c3RydWN0IGFjcGlfZGV2aWNlX2lkIG1lbW9yeV9kZXZpY2VfaWRzW10gPSB7CiAJe0FDUElfTUVN
T1JZX0RFVklDRV9ISUQsIDB9LAogCXsiIiwgMH0sCkBAIC02Myw0ICs2MywzOSBAQCB2b2lkIHhl
bl9zdHViX21lbW9yeV9kZXZpY2VfZXhpdCh2b2lkKQogfQogRVhQT1JUX1NZTUJPTF9HUEwoeGVu
X3N0dWJfbWVtb3J5X2RldmljZV9leGl0KTsKIAorCisvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tCisJc3R1YiBkcml2ZXIgZm9yIFhlbiBjcHUgaG90cGx1Zwor
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLworCitzdGF0aWMg
Y29uc3Qgc3RydWN0IGFjcGlfZGV2aWNlX2lkIHByb2Nlc3Nvcl9kZXZpY2VfaWRzW10gPSB7CisJ
e0FDUElfUFJPQ0VTU09SX09CSkVDVF9ISUQsIDB9LAorCXtBQ1BJX1BST0NFU1NPUl9ERVZJQ0Vf
SElELCAwfSwKKwl7IiIsIDB9LAorfTsKKworc3RhdGljIHN0cnVjdCBhY3BpX2RyaXZlciB4ZW5f
c3R1Yl9wcm9jZXNzb3JfZHJpdmVyID0geworCS8qIHNhbWUgbmFtZSBhcyBuYXRpdmUgcHJvY2Vz
c29yIGRyaXZlciB0byBibG9jayBuYXRpdmUgbG9hZGVkICovCisJLm5hbWUgPSAicHJvY2Vzc29y
IiwKKwkuY2xhc3MgPSBBQ1BJX1BST0NFU1NPUl9DTEFTUywKKwkuaWRzID0gcHJvY2Vzc29yX2Rl
dmljZV9pZHMsCit9OworCitpbnQgeGVuX3N0dWJfcHJvY2Vzc29yX2luaXQodm9pZCkKK3sKKwlp
ZiAoIXhlbl9pbml0aWFsX2RvbWFpbigpKQorCQlyZXR1cm4gLUVOT0RFVjsKKworCS8qIGp1c3Qg
cmVzZXJ2ZSBzcGFjZSBmb3IgWGVuLCBibG9jayBuYXRpdmUgZHJpdmVyIGxvYWRlZCAqLworCXJl
dHVybiBhY3BpX2J1c19yZWdpc3Rlcl9kcml2ZXIoJnhlbl9zdHViX3Byb2Nlc3Nvcl9kcml2ZXIp
OworfQorRVhQT1JUX1NZTUJPTF9HUEwoeGVuX3N0dWJfcHJvY2Vzc29yX2luaXQpOworc3Vic3lz
X2luaXRjYWxsKHhlbl9zdHViX3Byb2Nlc3Nvcl9pbml0KTsKKwordm9pZCB4ZW5fc3R1Yl9wcm9j
ZXNzb3JfZXhpdCh2b2lkKQoreworCWFjcGlfYnVzX3VucmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fc3R1
Yl9wcm9jZXNzb3JfZHJpdmVyKTsKK30KK0VYUE9SVF9TWU1CT0xfR1BMKHhlbl9zdHViX3Byb2Nl
c3Nvcl9leGl0KTsKKwogI2VuZGlmCmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9hY3BpLmggYi9p
bmNsdWRlL3hlbi9hY3BpLmgKaW5kZXggY2U3ZTUyNi4uMmIzMTAzYiAxMDA2NDQKLS0tIGEvaW5j
bHVkZS94ZW4vYWNwaS5oCisrKyBiL2luY2x1ZGUveGVuL2FjcGkuaApAQCAtNDcsNiArNDcsMTMg
QEAKIGludCB4ZW5fc3R1Yl9tZW1vcnlfZGV2aWNlX2luaXQodm9pZCk7CiB2b2lkIHhlbl9zdHVi
X21lbW9yeV9kZXZpY2VfZXhpdCh2b2lkKTsKIAorI2RlZmluZSBBQ1BJX1BST0NFU1NPUl9DTEFT
UyAgICAgICAgICAgICJwcm9jZXNzb3IiCisjZGVmaW5lIEFDUElfUFJPQ0VTU09SX0RFVklDRV9I
SUQgICAgICAgIkFDUEkwMDA3IgorI2RlZmluZSBBQ1BJX1BST0NFU1NPUl9ERVZJQ0VfTkFNRSAg
ICAgICJQcm9jZXNzb3IiCisKK2ludCB4ZW5fc3R1Yl9wcm9jZXNzb3JfaW5pdCh2b2lkKTsKK3Zv
aWQgeGVuX3N0dWJfcHJvY2Vzc29yX2V4aXQodm9pZCk7CisKIGludCB4ZW5fYWNwaV9ub3RpZnlf
aHlwZXJ2aXNvcl9zdGF0ZSh1OCBzbGVlcF9zdGF0ZSwKIAkJCQkgICAgIHUzMiBwbTFhX2NudCwg
dTMyIHBtMWJfY25kKTsKIAotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6E1SHSMSX101ccrcorpi_--
