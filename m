Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3ANGJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 01:09:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:17283 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3ANGJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 01:09:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,465,1355126400"; 
   d="scan'208,223";a="190778791"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V3 1/2] Xen stub driver for memory hotplug
Thread-Topic: [PATCH V3 1/2] Xen stub driver for memory hotplug
Thread-Index: Ac3yHamdiLz2ywgWQIiAFIGXONJltA==
Date: Mon, 14 Jan 2013 06:09:07 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353C24AD@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353C24ADSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353C24ADSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 008ab02becba5ca94fddd6ce9be27b9877a6c55e Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Tue, 8 Jan 2013 11:15:14 +0800
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
 drivers/xen/xen-stub.c |   60 ++++++++++++++++++++++++++++++++++++++++++++=
++++
 include/xen/acpi.h     |    6 ++++
 4 files changed, 78 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen-stub.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index cabfa97..1dcb5fc 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -180,6 +180,17 @@ config XEN_PRIVCMD
 	depends on XEN
 	default m
=20
+config XEN_STUB
+	bool "Xen stub drivers"
+	depends on XEN_DOM0 && X86_64
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
index 0000000..01a49e3
--- /dev/null
+++ b/drivers/xen/xen-stub.c
@@ -0,0 +1,60 @@
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
+struct acpi_driver xen_stub_memory_device_driver =3D {
+	/* same name as native memory driver to block native loaded */
+	.name =3D "acpi_memhotplug",
+	.class =3D ACPI_MEMORY_DEVICE_CLASS,
+	.ids =3D memory_device_ids,
+};
+EXPORT_SYMBOL_GPL(xen_stub_memory_device_driver);
+
+static int __init xen_stub_memory_device_init(void)
+{
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* just reserve space for Xen, block native driver loaded */
+	return acpi_bus_register_driver(&xen_stub_memory_device_driver);
+}
+subsys_initcall(xen_stub_memory_device_init);
+
+#endif
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 48a9c01..7366e58 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -40,6 +40,12 @@
 #include <xen/xen.h>
 #include <linux/acpi.h>
=20
+#define ACPI_MEMORY_DEVICE_CLASS        "memory"
+#define ACPI_MEMORY_DEVICE_HID          "PNP0C80"
+#define ACPI_MEMORY_DEVICE_NAME         "Hotplug Mem Device"
+
+extern struct acpi_driver xen_stub_memory_device_driver;
+
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353C24ADSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-stub-driver-for-memory-hotplug.patch"
Content-Description: 0001-Xen-stub-driver-for-memory-hotplug.patch
Content-Disposition: attachment;
	filename="0001-Xen-stub-driver-for-memory-hotplug.patch"; size=4918;
	creation-date="Mon, 14 Jan 2013 06:06:53 GMT";
	modification-date="Mon, 14 Jan 2013 13:58:30 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwMDhhYjAyYmVjYmE1Y2E5NGZkZGQ2Y2U5YmUyN2I5ODc3YTZjNTVlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUdWUsIDggSmFuIDIwMTMgMTE6MTU6MTQgKzA4MDAKU3ViamVjdDogW1BBVENIIDEvMl0g
WGVuIHN0dWIgZHJpdmVyIGZvciBtZW1vcnkgaG90cGx1ZwoKVGhpcyBwYXRjaCBjcmVhdGUgYSBm
aWxlICh4ZW4tc3R1Yi5jKSBmb3IgWGVuIHN0dWIgZHJpdmVycy4KWGVuIHN0dWIgZHJpdmVycyBh
cmUgdXNlZCB0byByZXNlcnZlIHNwYWNlIGZvciBYZW4gZHJpdmVycywgaS5lLgptZW1vcnkgaG90
cGx1ZyBhbmQgY3B1IGhvdHBsdWcsIGFuZCB0byBibG9jayBuYXRpdmUgZHJpdmVycyBsb2FkZWQs
CnNvIHRoYXQgcmVhbCBYZW4gZHJpdmVycyBjYW4gYmUgbW9kdWxhciBhbmQgbG9hZGVkIG9uIGRl
bWFuZC4KClRoaXMgcGF0Y2ggaXMgc3BlY2lmaWMgZm9yIFhlbiBtZW1vcnkgaG90cGx1ZyAob3Ro
ZXIgWGVuIGxvZ2ljCmNhbiBhZGQgc3R1YiBkcml2ZXJzIG9uIHRoZWlyIG93bikuIFRoZSB4ZW4g
c3R1YiBkcml2ZXIgd2lsbApvY2N1cGllZCBlYXJsaWVyIHZpYSBzdWJzeXNfaW5pdGNhbGwgKHRo
YW4gbmF0aXZlIG1lbW9yeSBob3RwbHVnCmRyaXZlciB2aWEgbW9kdWxlX2luaXQgYW5kIHNvIGJs
b2NraW5nIG5hdGl2ZSkuIExhdGVyIHJlYWwgWGVuCm1lbW9yeSBob3RwbHVnIGxvZ2ljIHdpbGwg
dW5yZWdpc3RlciB0aGUgc3R1YiBkcml2ZXIgYW5kIHJlZ2lzdGVyCml0c2VsZiB0byB0YWtlIGVm
ZmVjdCBvbiBkZW1hbmQuCgpTaWduZWQtb2ZmLWJ5OiBMaXUgSmluc29uZyA8amluc29uZy5saXVA
aW50ZWwuY29tPgotLS0KIGRyaXZlcnMveGVuL0tjb25maWcgICAgfCAgIDExICsrKysrKysrCiBk
cml2ZXJzL3hlbi9NYWtlZmlsZSAgIHwgICAgMSArCiBkcml2ZXJzL3hlbi94ZW4tc3R1Yi5jIHwg
ICA2MCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGlu
Y2x1ZGUveGVuL2FjcGkuaCAgICAgfCAgICA2ICsrKysKIDQgZmlsZXMgY2hhbmdlZCwgNzggaW5z
ZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3hl
bi94ZW4tc3R1Yi5jCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vS2NvbmZpZyBiL2RyaXZlcnMv
eGVuL0tjb25maWcKaW5kZXggY2FiZmE5Ny4uMWRjYjVmYyAxMDA2NDQKLS0tIGEvZHJpdmVycy94
ZW4vS2NvbmZpZworKysgYi9kcml2ZXJzL3hlbi9LY29uZmlnCkBAIC0xODAsNiArMTgwLDE3IEBA
IGNvbmZpZyBYRU5fUFJJVkNNRAogCWRlcGVuZHMgb24gWEVOCiAJZGVmYXVsdCBtCiAKK2NvbmZp
ZyBYRU5fU1RVQgorCWJvb2wgIlhlbiBzdHViIGRyaXZlcnMiCisJZGVwZW5kcyBvbiBYRU5fRE9N
MCAmJiBYODZfNjQKKwlkZWZhdWx0IG4KKwloZWxwCisJICBBbGxvdyBrZXJuZWwgdG8gaW5zdGFs
bCBzdHViIGRyaXZlcnMsIHRvIHJlc2VydmUgc3BhY2UgZm9yIFhlbiBkcml2ZXJzLAorCSAgaS5l
LiBtZW1vcnkgaG90cGx1ZyBhbmQgY3B1IGhvdHBsdWcsIGFuZCB0byBibG9jayBuYXRpdmUgZHJp
dmVycyBsb2FkZWQsCisJICBzbyB0aGF0IHJlYWwgWGVuIGRyaXZlcnMgY2FuIGJlIG1vZHVsYXIu
CisKKwkgIFRvIGVuYWJsZSBYZW4gZmVhdHVyZXMgbGlrZSBjcHUgYW5kIG1lbW9yeSBob3RwbHVn
LCBzZWxlY3QgWSBoZXJlLgorCiBjb25maWcgWEVOX0FDUElfUFJPQ0VTU09SCiAJdHJpc3RhdGUg
IlhlbiBBQ1BJIHByb2Nlc3NvciIKIAlkZXBlbmRzIG9uIFhFTiAmJiBYODYgJiYgQUNQSV9QUk9D
RVNTT1IgJiYgQ1BVX0ZSRVEKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2VmaWxlIGIvZHJp
dmVycy94ZW4vTWFrZWZpbGUKaW5kZXggZmIyMTNjZi4uYjYzZWRkOCAxMDA2NDQKLS0tIGEvZHJp
dmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAgLTMwLDYgKzMw
LDcgQEAgb2JqLSQoQ09ORklHX1NXSU9UTEJfWEVOKQkJKz0gc3dpb3RsYi14ZW4ubwogb2JqLSQo
Q09ORklHX1hFTl9NQ0VfTE9HKQkJKz0gbWNlbG9nLm8KIG9iai0kKENPTkZJR19YRU5fUENJREVW
X0JBQ0tFTkQpCSs9IHhlbi1wY2liYWNrLwogb2JqLSQoQ09ORklHX1hFTl9QUklWQ01EKQkJKz0g
eGVuLXByaXZjbWQubworb2JqLSQoQ09ORklHX1hFTl9TVFVCKQkJCSs9IHhlbi1zdHViLm8KIG9i
ai0kKENPTkZJR19YRU5fQUNQSV9QUk9DRVNTT1IpCSs9IHhlbi1hY3BpLXByb2Nlc3Nvci5vCiB4
ZW4tZXZ0Y2huLXkJCQkJOj0gZXZ0Y2huLm8KIHhlbi1nbnRkZXYteQkJCQk6PSBnbnRkZXYubwpk
aWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4veGVuLXN0dWIuYyBiL2RyaXZlcnMveGVuL3hlbi1zdHVi
LmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uMDFhNDllMwotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMveGVuL3hlbi1zdHViLmMKQEAgLTAsMCArMSw2MCBAQAorLyoKKyAq
IHhlbi1zdHViLmMgLSBzdHViIGRyaXZlcnMgdG8gcmVzZXJ2ZSBzcGFjZSBmb3IgWGVuCisgKgor
ICogQ29weXJpZ2h0IChDKSAyMDEyIEludGVsIENvcnBvcmF0aW9uCisgKiAgICBBdXRob3I6IExp
dSBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+CisgKiAgICBBdXRob3I6IEppYW5nIFl1
bmhvbmcgPHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgorICoKKyAqIENvcHlyaWdodCAoQykgMjAx
MiBPcmFjbGUgSW5jCisgKiAgICBBdXRob3I6IEtvbnJhZCBSemVzenV0ZWsgV2lsayA8a29ucmFk
LndpbGtAb3JhY2xlLmNvbT4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsg
eW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICogaXQgdW5kZXIgdGhlIHRl
cm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKKyAq
IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgdGhlIExp
Y2Vuc2UsIG9yIChhdAorICogeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgorICoKKyAq
IFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUg
dXNlZnVsLCBidXQKKyAqIFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGlt
cGxpZWQgd2FycmFudHkgb2YKKyAqIE1FUkNIQU5UQUJJTElUWSBPUiBGSVRORVNTIEZPUiBBIFBB
UlRJQ1VMQVIgUFVSUE9TRSwgR09PRCBUSVRMRSBvcgorICogTk9OIElORlJJTkdFTUVOVC4gIFNl
ZSB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUKKyAqIGRldGFpbHMuCisg
Ki8KKworI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4K
KyNpbmNsdWRlIDxsaW51eC9leHBvcnQuaD4KKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgorI2lu
Y2x1ZGUgPGxpbnV4L2FjcGkuaD4KKyNpbmNsdWRlIDxhY3BpL2FjcGlfZHJpdmVycy5oPgorI2lu
Y2x1ZGUgPHhlbi9hY3BpLmg+CisKKy8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0KKwlzdHViIGRyaXZlciBmb3IgWGVuIG1lbW9yeSBob3RwbHVnCistLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovCisKKyNpZmRlZiBDT05GSUdf
QUNQSQorCitzdGF0aWMgY29uc3Qgc3RydWN0IGFjcGlfZGV2aWNlX2lkIG1lbW9yeV9kZXZpY2Vf
aWRzW10gPSB7CisJe0FDUElfTUVNT1JZX0RFVklDRV9ISUQsIDB9LAorCXsiIiwgMH0sCit9Owor
CitzdHJ1Y3QgYWNwaV9kcml2ZXIgeGVuX3N0dWJfbWVtb3J5X2RldmljZV9kcml2ZXIgPSB7CisJ
Lyogc2FtZSBuYW1lIGFzIG5hdGl2ZSBtZW1vcnkgZHJpdmVyIHRvIGJsb2NrIG5hdGl2ZSBsb2Fk
ZWQgKi8KKwkubmFtZSA9ICJhY3BpX21lbWhvdHBsdWciLAorCS5jbGFzcyA9IEFDUElfTUVNT1JZ
X0RFVklDRV9DTEFTUywKKwkuaWRzID0gbWVtb3J5X2RldmljZV9pZHMsCit9OworRVhQT1JUX1NZ
TUJPTF9HUEwoeGVuX3N0dWJfbWVtb3J5X2RldmljZV9kcml2ZXIpOworCitzdGF0aWMgaW50IF9f
aW5pdCB4ZW5fc3R1Yl9tZW1vcnlfZGV2aWNlX2luaXQodm9pZCkKK3sKKwlpZiAoIXhlbl9pbml0
aWFsX2RvbWFpbigpKQorCQlyZXR1cm4gLUVOT0RFVjsKKworCS8qIGp1c3QgcmVzZXJ2ZSBzcGFj
ZSBmb3IgWGVuLCBibG9jayBuYXRpdmUgZHJpdmVyIGxvYWRlZCAqLworCXJldHVybiBhY3BpX2J1
c19yZWdpc3Rlcl9kcml2ZXIoJnhlbl9zdHViX21lbW9yeV9kZXZpY2VfZHJpdmVyKTsKK30KK3N1
YnN5c19pbml0Y2FsbCh4ZW5fc3R1Yl9tZW1vcnlfZGV2aWNlX2luaXQpOworCisjZW5kaWYKZGlm
ZiAtLWdpdCBhL2luY2x1ZGUveGVuL2FjcGkuaCBiL2luY2x1ZGUveGVuL2FjcGkuaAppbmRleCA0
OGE5YzAxLi43MzY2ZTU4IDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9hY3BpLmgKKysrIGIvaW5j
bHVkZS94ZW4vYWNwaS5oCkBAIC00MCw2ICs0MCwxMiBAQAogI2luY2x1ZGUgPHhlbi94ZW4uaD4K
ICNpbmNsdWRlIDxsaW51eC9hY3BpLmg+CiAKKyNkZWZpbmUgQUNQSV9NRU1PUllfREVWSUNFX0NM
QVNTICAgICAgICAibWVtb3J5IgorI2RlZmluZSBBQ1BJX01FTU9SWV9ERVZJQ0VfSElEICAgICAg
ICAgICJQTlAwQzgwIgorI2RlZmluZSBBQ1BJX01FTU9SWV9ERVZJQ0VfTkFNRSAgICAgICAgICJI
b3RwbHVnIE1lbSBEZXZpY2UiCisKK2V4dGVybiBzdHJ1Y3QgYWNwaV9kcml2ZXIgeGVuX3N0dWJf
bWVtb3J5X2RldmljZV9kcml2ZXI7CisKIGludCB4ZW5fYWNwaV9ub3RpZnlfaHlwZXJ2aXNvcl9z
dGF0ZSh1OCBzbGVlcF9zdGF0ZSwKIAkJCQkgICAgIHUzMiBwbTFhX2NudCwgdTMyIHBtMWJfY25k
KTsKIAotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923353C24ADSHSMSX101ccrcorpi_--
