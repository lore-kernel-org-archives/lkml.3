Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab3DZG3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:29:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:50180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759215Ab3DZG3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,554,1363158000"; 
   d="scan'208,223";a="302978811"
From: "Zhang, LongX" <longx.zhang@intel.com>
To: "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@Emulex.Com>
Subject: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
Thread-Topic: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
Thread-Index: Ac5CQUdmhbSX64FbRraxMqZGOLGlLwABCDYw
Date: Fri, 26 Apr 2013 06:28:59 +0000
Message-ID: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_F7B8FD780A346D46A0042F5C63B06AE785E3B2SHSMSX102ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_F7B8FD780A346D46A0042F5C63B06AE785E3B2SHSMSX102ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Zhang Long <longx.zhang@intel.com>

Specific pci device drivers might have many functions to call
pci_channel_offline to check device states. When slot_reset happens,
drivers' slot_reset callback might call such functions and eventually
abort the reset.

The patch resets pdev->error_state to pci_channel_io_normal at
the begining of report_slot_reset.

Thank Liu Joseph for pointing it out.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Zhang Long <longx.zhang@intel.com>
---
 drivers/pci/pcie/aer/aerdrv_core.c |    1 +
 drivers/pci/pcie/portdrv_pci.c     |   12 +++++-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerd=
rv_core.c
index 564d97f..c61fd44 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -286,6 +286,7 @@ static int report_slot_reset(struct pci_dev *dev, void =
*data)
 	result_data =3D (struct aer_broadcast_data *) data;
=20
 	device_lock(&dev->dev);
+	dev->error_state =3D pci_channel_io_normal;
 	if (!dev->driver ||
 		!dev->driver->err_handler ||
 		!dev->driver->err_handler->slot_reset)
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.=
c
index ed4d094..7abefd9 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -332,13 +332,11 @@ static pci_ers_result_t pcie_portdrv_slot_reset(struc=
t pci_dev *dev)
 	pci_ers_result_t status =3D PCI_ERS_RESULT_RECOVERED;
 	int retval;
=20
-	/* If fatal, restore cfg space for possible link reset at upstream */
-	if (dev->error_state =3D=3D pci_channel_io_frozen) {
-		dev->state_saved =3D true;
-		pci_restore_state(dev);
-		pcie_portdrv_restore_config(dev);
-		pci_enable_pcie_error_reporting(dev);
-	}
+	/* restore cfg space for possible link reset at upstream */
+	dev->state_saved =3D true;
+	pci_restore_state(dev);
+	pcie_portdrv_restore_config(dev);
+	pci_enable_pcie_error_reporting(dev);
=20
 	/* get true return value from &status */
 	retval =3D device_for_each_child(&dev->dev, &status, slot_reset_iter);
--=20
1.7.4.1




--_002_F7B8FD780A346D46A0042F5C63B06AE785E3B2SHSMSX102ccrcorpi_
Content-Type: application/octet-stream; name=
	"0001-pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset.patch"
Content-Description: 0001-pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset.patch
Content-Disposition: attachment; filename=
	"0001-pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset.patch";
	size=2283; creation-date="Fri, 26 Apr 2013 05:31:16 GMT";
	modification-date="Fri, 26 Apr 2013 04:50:02 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxNWJkMTVmNThlOTQ5NzM5Njk0NmQ4ZWI0MWQ3N2QyODlkNTVhMzY0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBaaGFuZyBZYW5taW4gPHlhbm1pbi56aGFuZ0BpbnRlbC5jb20+
CkRhdGU6IFN1biwgMjEgQXByIDIwMTMgMTA6MTg6NDIgKzA4MDAKU3ViamVjdDogW1BBVENIXSBw
Y2k6IHJlc2V0IGVycm9yX3N0YXRlIHRvIHBjaV9jaGFubmVsX2lvX25vcm1hbCBhdCByZXBvcnRf
c2xvdF9yZXNldAoKU3BlY2lmaWMgcGNpIGRldmljZSBkcml2ZXJzIG1pZ2h0IGhhdmUgbWFueSBm
dW5jdGlvbnMgdG8gY2FsbApwY2lfY2hhbm5lbF9vZmZsaW5lIHRvIGNoZWNrIGRldmljZSBzdGF0
ZXMuIFdoZW4gc2xvdF9yZXNldCBoYXBwZW5zLApkcml2ZXJzJyBzbG90X3Jlc2V0IGNhbGxiYWNr
IG1pZ2h0IGNhbGwgc3VjaCBmdW5jdGlvbnMgYW5kIGV2ZW50dWFsbHkKYWJvcnQgdGhlIHJlc2V0
LgoKVGhlIHBhdGNoIHJlc2V0cyBwZGV2LT5lcnJvcl9zdGF0ZSB0byBwY2lfY2hhbm5lbF9pb19u
b3JtYWwgYXQKdGhlIGJlZ2luaW5nIG9mIHJlcG9ydF9zbG90X3Jlc2V0LgoKVGhhbmsgTGl1IEpv
c2VwaCBmb3IgcG9pbnRpbmcgaXQgb3V0LgoKU2lnbmVkLW9mZi1ieTogWmhhbmcgWWFubWluIDx5
YW5taW5femhhbmdAbGludXguaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBaaGFuZyBMb25nIDxs
b25neC56aGFuZ0BpbnRlbC5jb20+Ci0tLQogZHJpdmVycy9wY2kvcGNpZS9hZXIvYWVyZHJ2X2Nv
cmUuYyB8ICAgIDEgKwogZHJpdmVycy9wY2kvcGNpZS9wb3J0ZHJ2X3BjaS5jICAgICB8ICAgMTIg
KysrKystLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9wY2llL2Flci9hZXJkcnZfY29yZS5jIGIv
ZHJpdmVycy9wY2kvcGNpZS9hZXIvYWVyZHJ2X2NvcmUuYwppbmRleCA1NjRkOTdmLi5jNjFmZDQ0
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9wY2llL2Flci9hZXJkcnZfY29yZS5jCisrKyBiL2Ry
aXZlcnMvcGNpL3BjaWUvYWVyL2FlcmRydl9jb3JlLmMKQEAgLTI4Niw2ICsyODYsNyBAQCBzdGF0
aWMgaW50IHJlcG9ydF9zbG90X3Jlc2V0KHN0cnVjdCBwY2lfZGV2ICpkZXYsIHZvaWQgKmRhdGEp
CiAJcmVzdWx0X2RhdGEgPSAoc3RydWN0IGFlcl9icm9hZGNhc3RfZGF0YSAqKSBkYXRhOwogCiAJ
ZGV2aWNlX2xvY2soJmRldi0+ZGV2KTsKKwlkZXYtPmVycm9yX3N0YXRlID0gcGNpX2NoYW5uZWxf
aW9fbm9ybWFsOwogCWlmICghZGV2LT5kcml2ZXIgfHwKIAkJIWRldi0+ZHJpdmVyLT5lcnJfaGFu
ZGxlciB8fAogCQkhZGV2LT5kcml2ZXItPmVycl9oYW5kbGVyLT5zbG90X3Jlc2V0KQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9wY2kvcGNpZS9wb3J0ZHJ2X3BjaS5jIGIvZHJpdmVycy9wY2kvcGNpZS9w
b3J0ZHJ2X3BjaS5jCmluZGV4IGVkNGQwOTQuLjdhYmVmZDkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
cGNpL3BjaWUvcG9ydGRydl9wY2kuYworKysgYi9kcml2ZXJzL3BjaS9wY2llL3BvcnRkcnZfcGNp
LmMKQEAgLTMzMiwxMyArMzMyLDExIEBAIHN0YXRpYyBwY2lfZXJzX3Jlc3VsdF90IHBjaWVfcG9y
dGRydl9zbG90X3Jlc2V0KHN0cnVjdCBwY2lfZGV2ICpkZXYpCiAJcGNpX2Vyc19yZXN1bHRfdCBz
dGF0dXMgPSBQQ0lfRVJTX1JFU1VMVF9SRUNPVkVSRUQ7CiAJaW50IHJldHZhbDsKIAotCS8qIElm
IGZhdGFsLCByZXN0b3JlIGNmZyBzcGFjZSBmb3IgcG9zc2libGUgbGluayByZXNldCBhdCB1cHN0
cmVhbSAqLwotCWlmIChkZXYtPmVycm9yX3N0YXRlID09IHBjaV9jaGFubmVsX2lvX2Zyb3plbikg
ewotCQlkZXYtPnN0YXRlX3NhdmVkID0gdHJ1ZTsKLQkJcGNpX3Jlc3RvcmVfc3RhdGUoZGV2KTsK
LQkJcGNpZV9wb3J0ZHJ2X3Jlc3RvcmVfY29uZmlnKGRldik7Ci0JCXBjaV9lbmFibGVfcGNpZV9l
cnJvcl9yZXBvcnRpbmcoZGV2KTsKLQl9CisJLyogcmVzdG9yZSBjZmcgc3BhY2UgZm9yIHBvc3Np
YmxlIGxpbmsgcmVzZXQgYXQgdXBzdHJlYW0gKi8KKwlkZXYtPnN0YXRlX3NhdmVkID0gdHJ1ZTsK
KwlwY2lfcmVzdG9yZV9zdGF0ZShkZXYpOworCXBjaWVfcG9ydGRydl9yZXN0b3JlX2NvbmZpZyhk
ZXYpOworCXBjaV9lbmFibGVfcGNpZV9lcnJvcl9yZXBvcnRpbmcoZGV2KTsKIAogCS8qIGdldCB0
cnVlIHJldHVybiB2YWx1ZSBmcm9tICZzdGF0dXMgKi8KIAlyZXR2YWwgPSBkZXZpY2VfZm9yX2Vh
Y2hfY2hpbGQoJmRldi0+ZGV2LCAmc3RhdHVzLCBzbG90X3Jlc2V0X2l0ZXIpOwotLSAKMS43LjQu
MQoK

--_002_F7B8FD780A346D46A0042F5C63B06AE785E3B2SHSMSX102ccrcorpi_--
