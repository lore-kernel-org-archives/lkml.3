Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3AYIzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:55:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:28422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3AYIyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:54:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,537,1355126400"; 
   d="scan'208,223";a="276483551"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V4 1/2] Xen stub driver for memory hotplug
Thread-Topic: [PATCH V4 1/2] Xen stub driver for memory hotplug
Thread-Index: Ac362ZycrEYDOLoYSvyvQyEMkHALtQ==
Date: Fri, 25 Jan 2013 08:54:41 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353DD6CB@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353DD6CBSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6CBSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From ccd5a2e956b51579a641a4b7922e95f9f4a51bbb Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Thu, 24 Jan 2013 20:16:59 +0800
Subject: [PATCH 1/2] Xen stub driver for memory hotplug

This patch create a file (xen-stub.c) for Xen stub drivers.
Xen stub drivers are used to reserve space for Xen drivers, i.e.
memory hotplug and cpu hotplug, and to block native drivers loaded,
so that real Xen drivers can be modular and loaded on demand.

This patch is specific for Xen memory hotplug (other Xen logic
can add stub drivers on their own). The xen stub driver will
occupied earlier via subsys_initcall (than native memory hotplug
driver via module_init and so blocking native). Later real Xen
memory hotplug logic will unregister the stub driver and register
itself to take effect on demand.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/Kconfig    |   11 ++++++++
 drivers/xen/Makefile   |    1 +
 drivers/xen/xen-stub.c |   66 ++++++++++++++++++++++++++++++++++++++++++++=
++++
 include/xen/acpi.h     |    7 +++++
 4 files changed, 85 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen-stub.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index cabfa97..c1c8566 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -180,6 +180,17 @@ config XEN_PRIVCMD
 	depends on XEN
 	default m
=20
+config XEN_STUB
+	bool "Xen stub drivers"
+	depends on XEN && X86_64
+	default n
+	help
+	  Allow kernel to install stub drivers, to reserve space for Xen drivers,
+	  i.e. memory hotplug and cpu hotplug, and to block native drivers loaded=
,
+	  so that real Xen drivers can be modular.
+
+	  To enable Xen features like cpu and memory hotplug, select Y here.
+
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
 	depends on XEN && X86 && ACPI_PROCESSOR && CPU_FREQ
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index fb213cf..b63edd8 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
 obj-$(CONFIG_XEN_MCE_LOG)		+=3D mcelog.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
+obj-$(CONFIG_XEN_STUB)			+=3D xen-stub.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+=3D xen-acpi-processor.o
 xen-evtchn-y				:=3D evtchn.o
 xen-gntdev-y				:=3D gntdev.o
diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
new file mode 100644
index 0000000..811152f
--- /dev/null
+++ b/drivers/xen/xen-stub.c
@@ -0,0 +1,66 @@
+/*
+ * xen-stub.c - stub drivers to reserve space for Xen
+ *
+ * Copyright (C) 2012 Intel Corporation
+ *    Author: Liu Jinsong <jinsong.liu@intel.com>
+ *    Author: Jiang Yunhong <yunhong.jiang@intel.com>
+ *
+ * Copyright (C) 2012 Oracle Inc
+ *    Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_drivers.h>
+#include <xen/acpi.h>
+
+/*--------------------------------------------
+	stub driver for Xen memory hotplug
+--------------------------------------------*/
+
+#ifdef CONFIG_ACPI
+
+static const struct acpi_device_id memory_device_ids[] =3D {
+	{ACPI_MEMORY_DEVICE_HID, 0},
+	{"", 0},
+};
+
+static struct acpi_driver xen_stub_memory_device_driver =3D {
+	/* same name as native memory driver to block native loaded */
+	.name =3D "acpi_memhotplug",
+	.class =3D ACPI_MEMORY_DEVICE_CLASS,
+	.ids =3D memory_device_ids,
+};
+
+int xen_stub_memory_device_init(void)
+{
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* just reserve space for Xen, block native driver loaded */
+	return acpi_bus_register_driver(&xen_stub_memory_device_driver);
+}
+EXPORT_SYMBOL_GPL(xen_stub_memory_device_init);
+subsys_initcall(xen_stub_memory_device_init);
+
+void xen_stub_memory_device_exit(void)
+{
+	acpi_bus_unregister_driver(&xen_stub_memory_device_driver);
+}
+EXPORT_SYMBOL_GPL(xen_stub_memory_device_exit);
+
+#endif
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 48a9c01..ce7e526 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -40,6 +40,13 @@
 #include <xen/xen.h>
 #include <linux/acpi.h>
=20
+#define ACPI_MEMORY_DEVICE_CLASS        "memory"
+#define ACPI_MEMORY_DEVICE_HID          "PNP0C80"
+#define ACPI_MEMORY_DEVICE_NAME         "Hotplug Mem Device"
+
+int xen_stub_memory_device_init(void);
+void xen_stub_memory_device_exit(void);
+
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6CBSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-stub-driver-for-memory-hotplug.patch"
Content-Description: 0001-Xen-stub-driver-for-memory-hotplug.patch
Content-Disposition: attachment;
	filename="0001-Xen-stub-driver-for-memory-hotplug.patch"; size=5088;
	creation-date="Fri, 25 Jan 2013 08:52:32 GMT";
	modification-date="Fri, 25 Jan 2013 16:45:18 GMT"
Content-Transfer-Encoding: base64

RnJvbSBjY2Q1YTJlOTU2YjUxNTc5YTY0MWE0Yjc5MjJlOTVmOWY0YTUxYmJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUaHUsIDI0IEphbiAyMDEzIDIwOjE2OjU5ICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IFhlbiBzdHViIGRyaXZlciBmb3IgbWVtb3J5IGhvdHBsdWcKClRoaXMgcGF0Y2ggY3JlYXRlIGEg
ZmlsZSAoeGVuLXN0dWIuYykgZm9yIFhlbiBzdHViIGRyaXZlcnMuClhlbiBzdHViIGRyaXZlcnMg
YXJlIHVzZWQgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgWGVuIGRyaXZlcnMsIGkuZS4KbWVtb3J5IGhv
dHBsdWcgYW5kIGNwdSBob3RwbHVnLCBhbmQgdG8gYmxvY2sgbmF0aXZlIGRyaXZlcnMgbG9hZGVk
LApzbyB0aGF0IHJlYWwgWGVuIGRyaXZlcnMgY2FuIGJlIG1vZHVsYXIgYW5kIGxvYWRlZCBvbiBk
ZW1hbmQuCgpUaGlzIHBhdGNoIGlzIHNwZWNpZmljIGZvciBYZW4gbWVtb3J5IGhvdHBsdWcgKG90
aGVyIFhlbiBsb2dpYwpjYW4gYWRkIHN0dWIgZHJpdmVycyBvbiB0aGVpciBvd24pLiBUaGUgeGVu
IHN0dWIgZHJpdmVyIHdpbGwKb2NjdXBpZWQgZWFybGllciB2aWEgc3Vic3lzX2luaXRjYWxsICh0
aGFuIG5hdGl2ZSBtZW1vcnkgaG90cGx1Zwpkcml2ZXIgdmlhIG1vZHVsZV9pbml0IGFuZCBzbyBi
bG9ja2luZyBuYXRpdmUpLiBMYXRlciByZWFsIFhlbgptZW1vcnkgaG90cGx1ZyBsb2dpYyB3aWxs
IHVucmVnaXN0ZXIgdGhlIHN0dWIgZHJpdmVyIGFuZCByZWdpc3RlcgppdHNlbGYgdG8gdGFrZSBl
ZmZlY3Qgb24gZGVtYW5kLgoKU2lnbmVkLW9mZi1ieTogTGl1IEppbnNvbmcgPGppbnNvbmcubGl1
QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hlbi9LY29uZmlnICAgIHwgICAxMSArKysrKysrKwog
ZHJpdmVycy94ZW4vTWFrZWZpbGUgICB8ICAgIDEgKwogZHJpdmVycy94ZW4veGVuLXN0dWIuYyB8
ICAgNjYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiBp
bmNsdWRlL3hlbi9hY3BpLmggICAgIHwgICAgNyArKysrKwogNCBmaWxlcyBjaGFuZ2VkLCA4NSBp
bnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMv
eGVuL3hlbi1zdHViLmMKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9LY29uZmlnIGIvZHJpdmVy
cy94ZW4vS2NvbmZpZwppbmRleCBjYWJmYTk3Li5jMWM4NTY2IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3hlbi9LY29uZmlnCisrKyBiL2RyaXZlcnMveGVuL0tjb25maWcKQEAgLTE4MCw2ICsxODAsMTcg
QEAgY29uZmlnIFhFTl9QUklWQ01ECiAJZGVwZW5kcyBvbiBYRU4KIAlkZWZhdWx0IG0KIAorY29u
ZmlnIFhFTl9TVFVCCisJYm9vbCAiWGVuIHN0dWIgZHJpdmVycyIKKwlkZXBlbmRzIG9uIFhFTiAm
JiBYODZfNjQKKwlkZWZhdWx0IG4KKwloZWxwCisJICBBbGxvdyBrZXJuZWwgdG8gaW5zdGFsbCBz
dHViIGRyaXZlcnMsIHRvIHJlc2VydmUgc3BhY2UgZm9yIFhlbiBkcml2ZXJzLAorCSAgaS5lLiBt
ZW1vcnkgaG90cGx1ZyBhbmQgY3B1IGhvdHBsdWcsIGFuZCB0byBibG9jayBuYXRpdmUgZHJpdmVy
cyBsb2FkZWQsCisJICBzbyB0aGF0IHJlYWwgWGVuIGRyaXZlcnMgY2FuIGJlIG1vZHVsYXIuCisK
KwkgIFRvIGVuYWJsZSBYZW4gZmVhdHVyZXMgbGlrZSBjcHUgYW5kIG1lbW9yeSBob3RwbHVnLCBz
ZWxlY3QgWSBoZXJlLgorCiBjb25maWcgWEVOX0FDUElfUFJPQ0VTU09SCiAJdHJpc3RhdGUgIlhl
biBBQ1BJIHByb2Nlc3NvciIKIAlkZXBlbmRzIG9uIFhFTiAmJiBYODYgJiYgQUNQSV9QUk9DRVNT
T1IgJiYgQ1BVX0ZSRVEKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2VmaWxlIGIvZHJpdmVy
cy94ZW4vTWFrZWZpbGUKaW5kZXggZmIyMTNjZi4uYjYzZWRkOCAxMDA2NDQKLS0tIGEvZHJpdmVy
cy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAgLTMwLDYgKzMwLDcg
QEAgb2JqLSQoQ09ORklHX1NXSU9UTEJfWEVOKQkJKz0gc3dpb3RsYi14ZW4ubwogb2JqLSQoQ09O
RklHX1hFTl9NQ0VfTE9HKQkJKz0gbWNlbG9nLm8KIG9iai0kKENPTkZJR19YRU5fUENJREVWX0JB
Q0tFTkQpCSs9IHhlbi1wY2liYWNrLwogb2JqLSQoQ09ORklHX1hFTl9QUklWQ01EKQkJKz0geGVu
LXByaXZjbWQubworb2JqLSQoQ09ORklHX1hFTl9TVFVCKQkJCSs9IHhlbi1zdHViLm8KIG9iai0k
KENPTkZJR19YRU5fQUNQSV9QUk9DRVNTT1IpCSs9IHhlbi1hY3BpLXByb2Nlc3Nvci5vCiB4ZW4t
ZXZ0Y2huLXkJCQkJOj0gZXZ0Y2huLm8KIHhlbi1nbnRkZXYteQkJCQk6PSBnbnRkZXYubwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy94ZW4veGVuLXN0dWIuYyBiL2RyaXZlcnMveGVuL3hlbi1zdHViLmMK
bmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uODExMTUyZgotLS0gL2Rldi9udWxs
CisrKyBiL2RyaXZlcnMveGVuL3hlbi1zdHViLmMKQEAgLTAsMCArMSw2NiBAQAorLyoKKyAqIHhl
bi1zdHViLmMgLSBzdHViIGRyaXZlcnMgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgWGVuCisgKgorICog
Q29weXJpZ2h0IChDKSAyMDEyIEludGVsIENvcnBvcmF0aW9uCisgKiAgICBBdXRob3I6IExpdSBK
aW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+CisgKiAgICBBdXRob3I6IEppYW5nIFl1bmhv
bmcgPHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgorICoKKyAqIENvcHlyaWdodCAoQykgMjAxMiBP
cmFjbGUgSW5jCisgKiAgICBBdXRob3I6IEtvbnJhZCBSemVzenV0ZWsgV2lsayA8a29ucmFkLndp
bGtAb3JhY2xlLmNvbT4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91
IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICogaXQgdW5kZXIgdGhlIHRlcm1z
IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKKyAqIHRo
ZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vu
c2UsIG9yIChhdAorICogeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgorICoKKyAqIFRo
aXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNl
ZnVsLCBidXQKKyAqIFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxp
ZWQgd2FycmFudHkgb2YKKyAqIE1FUkNIQU5UQUJJTElUWSBPUiBGSVRORVNTIEZPUiBBIFBBUlRJ
Q1VMQVIgUFVSUE9TRSwgR09PRCBUSVRMRSBvcgorICogTk9OIElORlJJTkdFTUVOVC4gIFNlZSB0
aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUKKyAqIGRldGFpbHMuCisgKi8K
KworI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNp
bmNsdWRlIDxsaW51eC9leHBvcnQuaD4KKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgorI2luY2x1
ZGUgPGxpbnV4L2FjcGkuaD4KKyNpbmNsdWRlIDxhY3BpL2FjcGlfZHJpdmVycy5oPgorI2luY2x1
ZGUgPHhlbi9hY3BpLmg+CisKKy8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KKwlzdHViIGRyaXZlciBmb3IgWGVuIG1lbW9yeSBob3RwbHVnCistLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovCisKKyNpZmRlZiBDT05GSUdfQUNQ
SQorCitzdGF0aWMgY29uc3Qgc3RydWN0IGFjcGlfZGV2aWNlX2lkIG1lbW9yeV9kZXZpY2VfaWRz
W10gPSB7CisJe0FDUElfTUVNT1JZX0RFVklDRV9ISUQsIDB9LAorCXsiIiwgMH0sCit9OworCitz
dGF0aWMgc3RydWN0IGFjcGlfZHJpdmVyIHhlbl9zdHViX21lbW9yeV9kZXZpY2VfZHJpdmVyID0g
eworCS8qIHNhbWUgbmFtZSBhcyBuYXRpdmUgbWVtb3J5IGRyaXZlciB0byBibG9jayBuYXRpdmUg
bG9hZGVkICovCisJLm5hbWUgPSAiYWNwaV9tZW1ob3RwbHVnIiwKKwkuY2xhc3MgPSBBQ1BJX01F
TU9SWV9ERVZJQ0VfQ0xBU1MsCisJLmlkcyA9IG1lbW9yeV9kZXZpY2VfaWRzLAorfTsKKworaW50
IHhlbl9zdHViX21lbW9yeV9kZXZpY2VfaW5pdCh2b2lkKQoreworCWlmICgheGVuX2luaXRpYWxf
ZG9tYWluKCkpCisJCXJldHVybiAtRU5PREVWOworCisJLyoganVzdCByZXNlcnZlIHNwYWNlIGZv
ciBYZW4sIGJsb2NrIG5hdGl2ZSBkcml2ZXIgbG9hZGVkICovCisJcmV0dXJuIGFjcGlfYnVzX3Jl
Z2lzdGVyX2RyaXZlcigmeGVuX3N0dWJfbWVtb3J5X2RldmljZV9kcml2ZXIpOworfQorRVhQT1JU
X1NZTUJPTF9HUEwoeGVuX3N0dWJfbWVtb3J5X2RldmljZV9pbml0KTsKK3N1YnN5c19pbml0Y2Fs
bCh4ZW5fc3R1Yl9tZW1vcnlfZGV2aWNlX2luaXQpOworCit2b2lkIHhlbl9zdHViX21lbW9yeV9k
ZXZpY2VfZXhpdCh2b2lkKQoreworCWFjcGlfYnVzX3VucmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fc3R1
Yl9tZW1vcnlfZGV2aWNlX2RyaXZlcik7Cit9CitFWFBPUlRfU1lNQk9MX0dQTCh4ZW5fc3R1Yl9t
ZW1vcnlfZGV2aWNlX2V4aXQpOworCisjZW5kaWYKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2Fj
cGkuaCBiL2luY2x1ZGUveGVuL2FjcGkuaAppbmRleCA0OGE5YzAxLi5jZTdlNTI2IDEwMDY0NAot
LS0gYS9pbmNsdWRlL3hlbi9hY3BpLmgKKysrIGIvaW5jbHVkZS94ZW4vYWNwaS5oCkBAIC00MCw2
ICs0MCwxMyBAQAogI2luY2x1ZGUgPHhlbi94ZW4uaD4KICNpbmNsdWRlIDxsaW51eC9hY3BpLmg+
CiAKKyNkZWZpbmUgQUNQSV9NRU1PUllfREVWSUNFX0NMQVNTICAgICAgICAibWVtb3J5IgorI2Rl
ZmluZSBBQ1BJX01FTU9SWV9ERVZJQ0VfSElEICAgICAgICAgICJQTlAwQzgwIgorI2RlZmluZSBB
Q1BJX01FTU9SWV9ERVZJQ0VfTkFNRSAgICAgICAgICJIb3RwbHVnIE1lbSBEZXZpY2UiCisKK2lu
dCB4ZW5fc3R1Yl9tZW1vcnlfZGV2aWNlX2luaXQodm9pZCk7Cit2b2lkIHhlbl9zdHViX21lbW9y
eV9kZXZpY2VfZXhpdCh2b2lkKTsKKwogaW50IHhlbl9hY3BpX25vdGlmeV9oeXBlcnZpc29yX3N0
YXRlKHU4IHNsZWVwX3N0YXRlLAogCQkJCSAgICAgdTMyIHBtMWFfY250LCB1MzIgcG0xYl9jbmQp
OwogCi0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6CBSHSMSX101ccrcorpi_--
