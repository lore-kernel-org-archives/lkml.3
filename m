Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3HAOzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:55:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:7188 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab3HAOzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,795,1367996400"; 
   d="scan'208";a="380135932"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Bjorn Helgaas <bhelgaas@google.com>, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: /sys/module/pcie_aspm/parameters/policy not writable?
Thread-Topic: /sys/module/pcie_aspm/parameters/policy not writable?
Thread-Index: AQHOfae/YJf6t4xSdkSmx+6rM4DMuJlhWxyAgAtunQCABzyS4IAGpr2AgAEsTUA=
Date: Thu, 1 Aug 2013 14:55:31 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B6264F92AA50@ORSMSX102.amr.corp.intel.com>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com> <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz>
 <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
 <9BBC4E0CF881AA4299206E2E1412B6264F921872@ORSMSX102.amr.corp.intel.com>
 <20130728135103.GC5382@amd.pavel.ucw.cz>
In-Reply-To: <20130728135103.GC5382@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: multipart/mixed;
	boundary="_002_9BBC4E0CF881AA4299206E2E1412B6264F92AA50ORSMSX102amrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_9BBC4E0CF881AA4299206E2E1412B6264F92AA50ORSMSX102amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

[..]=20
> If there's patch, I'll gladly try it :-). Thanks,
>=20
								Pavel
Thanks Pavel,

It ended up taking more time than I thought.  The checking of whether ASPM =
is really enabled or not is, unfortunately, not as straightforward as I tho=
ught initially, so we ended up rewriting the function a bit.  In this patch=
 we try to use the pci_disable_link_state_locked() call, but if it fails, w=
e then write to pci config space of the device to disable it.

Please let me know if this actually disables the ASPM for your 82574 parts =
or not.  We can still continue the discussion on whether this is the best a=
pproach or not, or what else could be done.

This patch attempts to work around a problem found with some systems where =
the call to pci_diable_link_state_locked() fails.  As a result, ASPM is not=
, in fact, disabled.  Changing disable aspm code to check if state actually=
 is disabled after the call and, if not, try another way to disable it.

Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
---

 drivers/net/ethernet/intel/e1000e/netdev.c |   86 ++++++++++++++++++++----=
----
 1 files changed, 60 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ether=
net/intel/e1000e/netdev.c
index e6d2c0f..bc3025b 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -64,8 +64,6 @@ static int debug =3D -1;  module_param(debug, int, 0);  M=
ODULE_PARM_DESC(debug, "Debug level (0=3Dnone,...,16=3Dall)");
=20
-static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state);
-
 static const struct e1000_info *e1000_info_tbl[] =3D {
 	[board_82571]		=3D &e1000_82571_info,
 	[board_82572]		=3D &e1000_82572_info,
@@ -6019,38 +6017,74 @@ static int __e1000_shutdown(struct pci_dev *pdev, b=
ool runtime)
 	return 0;
 }
=20
-#ifdef CONFIG_PCIEASPM
-static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
+/**
+ * e1000e_disable_aspm - Disable ASPM states
+ * @pdev: pointer to PCI device struct
+ * @state: bit-mask of ASPM states to disable
+ *
+ * Some devices *must* have certain ASPM states disabled per hardware erra=
ta.
+ **/
+static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
 {
+	struct pci_dev *parent =3D pdev->bus->self;
+	u16 aspm_dis_mask =3D 0;
+	u16 pdev_aspmc, parent_aspmc;
+
+	switch (state) {
+	case PCIE_LINK_STATE_L0S:
+	case PCIE_LINK_STATE_L0S + PCIE_LINK_STATE_L1:
+		aspm_dis_mask |=3D PCI_EXP_LNKCTL_ASPM_L0S;
+		/* fall-through - can't have L1 without L0s */
+	case PCIE_LINK_STATE_L1:
+		aspm_dis_mask |=3D PCI_EXP_LNKCTL_ASPM_L1;
+		break;
+	default:
+		return;
+	}
+
+	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &pdev_aspmc);
+	pdev_aspmc &=3D PCI_EXP_LNKCTL_ASPMC;
+
+	if (parent) {
+		pcie_capability_read_word(parent, PCI_EXP_LNKCTL,
+					  &parent_aspmc);
+		parent_aspmc &=3D PCI_EXP_LNKCTL_ASPMC;
+	}
+
+	/* Nothing to do if the ASPM states to be disabled already are */
+	if (!(pdev_aspmc & aspm_dis_mask) &&
+	    (!parent || !(parent_aspmc & aspm_dis_mask)))
+		return;
+
+	dev_info(&pdev->dev, "Disabling ASPM %s %s\n",
+		 (aspm_dis_mask & pdev_aspmc & PCI_EXP_LNKCTL_ASPM_L0S) ?
+		 "L0s" : "",
+		 (aspm_dis_mask & pdev_aspmc & PCI_EXP_LNKCTL_ASPM_L1) ?
+		 "L1" : "");
+
+#ifdef CONFIG_PCIEASPM
 	pci_disable_link_state_locked(pdev, state); -} -#else -static void __e100=
0e_disable_aspm(struct pci_dev *pdev, u16 state) -{
-	u16 aspm_ctl =3D 0;
=20
-	if (state & PCIE_LINK_STATE_L0S)
-		aspm_ctl |=3D PCI_EXP_LNKCTL_ASPM_L0S;
-	if (state & PCIE_LINK_STATE_L1)
-		aspm_ctl |=3D PCI_EXP_LNKCTL_ASPM_L1;
+	/* Double-check ASPM control.  If not disabled by the above, the
+	 * BIOS is preventing that from happening (or CONFIG_PCIEASPM is
+	 * not enabled); override by writing PCI config space directly.
+	 */
+	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &pdev_aspmc);
+	pdev_aspmc &=3D PCI_EXP_LNKCTL_ASPMC;
+
+	if (!(aspm_dis_mask & pdev_aspmc))
+		return;
+	}
+#endif
=20
 	/* Both device and parent should have the same ASPM setting.
 	 * Disable ASPM in downstream component first and then upstream.
 	 */
-	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_ctl);
-
-	if (pdev->bus->self)
-		pcie_capability_clear_word(pdev->bus->self, PCI_EXP_LNKCTL,
-					   aspm_ctl);
-}
-#endif
-static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state) -{
-	dev_info(&pdev->dev, "Disabling ASPM %s %s\n",
-		 (state & PCIE_LINK_STATE_L0S) ? "L0s" : "",
-		 (state & PCIE_LINK_STATE_L1) ? "L1" : "");
+	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_dis_mask);
=20
-	__e1000e_disable_aspm(pdev, state);
+	if (parent)
+		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
+					   aspm_dis_mask);
 }
=20
 #ifdef CONFIG_PM


--_002_9BBC4E0CF881AA4299206E2E1412B6264F92AA50ORSMSX102amrcor_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Thu, 01 Aug 2013 14:55:31 GMT";
	modification-date="Thu, 01 Aug 2013 14:55:31 GMT"

Received: from AZSMGA002.ch.intel.com (10.2.17.35) by ORSMSX104-2.jf.intel.com
 (10.22.225.137) with Microsoft SMTP Server id 14.3.123.3; Thu, 1 Aug 2013
 07:50:55 -0700
Received: from cmw-ivy.jf.intel.com (HELO localhost.localdomain)
 ([10.23.21.75])  by AZSMGA002.ch.intel.com with ESMTP; 01 Aug 2013 07:50:49
 -0700
Received: from localhost6.localdomain6 (cmw-ivy [127.0.0.1])	by
 localhost.localdomain (8.14.4/8.14.4) with ESMTP id r71EojuB026296	for
 <carolyn.wyborny@intel.com>; Thu, 1 Aug 2013 07:50:45 -0700
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Subject: [NET-NEXT PATCH] e1000e: Add code to check for failure of
 pci_disable_link_state call
Thread-Topic: [NET-NEXT PATCH] e1000e: Add code to check for failure of
 pci_disable_link_state call
Thread-Index: AQHOjsaGefMCwnQkTkWrKNm+10by3w==
Date: Thu, 1 Aug 2013 14:50:45 +0000
Message-ID: <20130801145006.26259.67384.stgit@localhost6.localdomain6>
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: ORSMSX104.amr.corp.intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.89,795,1367996400";
    d="scan'208";a="276317258"
user-agent: StGIT/0.14.3
x-extloop1: 1
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D6ECC985DB4034EABED1A8DE9D99C3A@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0

VGhpcyBwYXRjaCBhdHRlbXB0cyB0byB3b3JrIGFyb3VuZCBhIHByb2JsZW0gZm91bmQgd2l0aCBz
b21lIHN5c3RlbXMgd2hlcmUgdGhlIGNhbGwgdG8gcGNpX2RpYWJsZV9saW5rX3N0YXRlX2xvY2tl
ZCgpIGZhaWxzLiAgQXMgYSByZXN1bHQsIEFTUE0gaXMgbm90LCBpbiBmYWN0LCBkaXNhYmxlZC4g
IENoYW5naW5nIGRpc2FibGUgYXNwbSBjb2RlIHRvIGNoZWNrIGlmIHN0YXRlIGFjdHVhbGx5IGlz
IGRpc2FibGVkIGFmdGVyIHRoZSBjYWxsIGFuZCwgaWYgbm90LCB0cnkgYW5vdGhlciB3YXkgdG8g
ZGlzYWJsZSBpdC4NCg0KU2lnbmVkLW9mZi1ieTogQ2Fyb2x5biBXeWJvcm55IDxjYXJvbHluLnd5
Ym9ybnlAaW50ZWwuY29tPg0KLS0tDQoNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAw
MGUvbmV0ZGV2LmMgfCAgIDg2ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0NCiAxIGZpbGVz
IGNoYW5nZWQsIDYwIGluc2VydGlvbnMoKyksIDI2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jDQppbmRleCBlNmQyYzBmLi5iYzMwMjVi
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5j
DQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvbmV0ZGV2LmMNCkBAIC02
NCw4ICs2NCw2IEBAIHN0YXRpYyBpbnQgZGVidWcgPSAtMTsNCiBtb2R1bGVfcGFyYW0oZGVidWcs
IGludCwgMCk7DQogTU9EVUxFX1BBUk1fREVTQyhkZWJ1ZywgIkRlYnVnIGxldmVsICgwPW5vbmUs
Li4uLDE2PWFsbCkiKTsNCiANCi1zdGF0aWMgdm9pZCBlMTAwMGVfZGlzYWJsZV9hc3BtKHN0cnVj
dCBwY2lfZGV2ICpwZGV2LCB1MTYgc3RhdGUpOw0KLQ0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZTEw
MDBfaW5mbyAqZTEwMDBfaW5mb190YmxbXSA9IHsNCiAJW2JvYXJkXzgyNTcxXQkJPSAmZTEwMDBf
ODI1NzFfaW5mbywNCiAJW2JvYXJkXzgyNTcyXQkJPSAmZTEwMDBfODI1NzJfaW5mbywNCkBAIC02
MDE5LDM4ICs2MDE3LDc0IEBAIHN0YXRpYyBpbnQgX19lMTAwMF9zaHV0ZG93bihzdHJ1Y3QgcGNp
X2RldiAqcGRldiwgYm9vbCBydW50aW1lKQ0KIAlyZXR1cm4gMDsNCiB9DQogDQotI2lmZGVmIENP
TkZJR19QQ0lFQVNQTQ0KLXN0YXRpYyB2b2lkIF9fZTEwMDBlX2Rpc2FibGVfYXNwbShzdHJ1Y3Qg
cGNpX2RldiAqcGRldiwgdTE2IHN0YXRlKQ0KKy8qKg0KKyAqIGUxMDAwZV9kaXNhYmxlX2FzcG0g
LSBEaXNhYmxlIEFTUE0gc3RhdGVzDQorICogQHBkZXY6IHBvaW50ZXIgdG8gUENJIGRldmljZSBz
dHJ1Y3QNCisgKiBAc3RhdGU6IGJpdC1tYXNrIG9mIEFTUE0gc3RhdGVzIHRvIGRpc2FibGUNCisg
Kg0KKyAqIFNvbWUgZGV2aWNlcyAqbXVzdCogaGF2ZSBjZXJ0YWluIEFTUE0gc3RhdGVzIGRpc2Fi
bGVkIHBlciBoYXJkd2FyZSBlcnJhdGEuDQorICoqLw0KK3N0YXRpYyB2b2lkIGUxMDAwZV9kaXNh
YmxlX2FzcG0oc3RydWN0IHBjaV9kZXYgKnBkZXYsIHUxNiBzdGF0ZSkNCiB7DQorCXN0cnVjdCBw
Y2lfZGV2ICpwYXJlbnQgPSBwZGV2LT5idXMtPnNlbGY7DQorCXUxNiBhc3BtX2Rpc19tYXNrID0g
MDsNCisJdTE2IHBkZXZfYXNwbWMsIHBhcmVudF9hc3BtYzsNCisNCisJc3dpdGNoIChzdGF0ZSkg
ew0KKwljYXNlIFBDSUVfTElOS19TVEFURV9MMFM6DQorCWNhc2UgUENJRV9MSU5LX1NUQVRFX0ww
UyArIFBDSUVfTElOS19TVEFURV9MMToNCisJCWFzcG1fZGlzX21hc2sgfD0gUENJX0VYUF9MTktD
VExfQVNQTV9MMFM7DQorCQkvKiBmYWxsLXRocm91Z2ggLSBjYW4ndCBoYXZlIEwxIHdpdGhvdXQg
TDBzICovDQorCWNhc2UgUENJRV9MSU5LX1NUQVRFX0wxOg0KKwkJYXNwbV9kaXNfbWFzayB8PSBQ
Q0lfRVhQX0xOS0NUTF9BU1BNX0wxOw0KKwkJYnJlYWs7DQorCWRlZmF1bHQ6DQorCQlyZXR1cm47
DQorCX0NCisNCisJcGNpZV9jYXBhYmlsaXR5X3JlYWRfd29yZChwZGV2LCBQQ0lfRVhQX0xOS0NU
TCwgJnBkZXZfYXNwbWMpOw0KKwlwZGV2X2FzcG1jICY9IFBDSV9FWFBfTE5LQ1RMX0FTUE1DOw0K
Kw0KKwlpZiAocGFyZW50KSB7DQorCQlwY2llX2NhcGFiaWxpdHlfcmVhZF93b3JkKHBhcmVudCwg
UENJX0VYUF9MTktDVEwsDQorCQkJCQkgICZwYXJlbnRfYXNwbWMpOw0KKwkJcGFyZW50X2FzcG1j
ICY9IFBDSV9FWFBfTE5LQ1RMX0FTUE1DOw0KKwl9DQorDQorCS8qIE5vdGhpbmcgdG8gZG8gaWYg
dGhlIEFTUE0gc3RhdGVzIHRvIGJlIGRpc2FibGVkIGFscmVhZHkgYXJlICovDQorCWlmICghKHBk
ZXZfYXNwbWMgJiBhc3BtX2Rpc19tYXNrKSAmJg0KKwkgICAgKCFwYXJlbnQgfHwgIShwYXJlbnRf
YXNwbWMgJiBhc3BtX2Rpc19tYXNrKSkpDQorCQlyZXR1cm47DQorDQorCWRldl9pbmZvKCZwZGV2
LT5kZXYsICJEaXNhYmxpbmcgQVNQTSAlcyAlc1xuIiwNCisJCSAoYXNwbV9kaXNfbWFzayAmIHBk
ZXZfYXNwbWMgJiBQQ0lfRVhQX0xOS0NUTF9BU1BNX0wwUykgPw0KKwkJICJMMHMiIDogIiIsDQor
CQkgKGFzcG1fZGlzX21hc2sgJiBwZGV2X2FzcG1jICYgUENJX0VYUF9MTktDVExfQVNQTV9MMSkg
Pw0KKwkJICJMMSIgOiAiIik7DQorDQorI2lmZGVmIENPTkZJR19QQ0lFQVNQTQ0KIAlwY2lfZGlz
YWJsZV9saW5rX3N0YXRlX2xvY2tlZChwZGV2LCBzdGF0ZSk7DQotfQ0KLSNlbHNlDQotc3RhdGlj
IHZvaWQgX19lMTAwMGVfZGlzYWJsZV9hc3BtKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCB1MTYgc3Rh
dGUpDQotew0KLQl1MTYgYXNwbV9jdGwgPSAwOw0KIA0KLQlpZiAoc3RhdGUgJiBQQ0lFX0xJTktf
U1RBVEVfTDBTKQ0KLQkJYXNwbV9jdGwgfD0gUENJX0VYUF9MTktDVExfQVNQTV9MMFM7DQotCWlm
IChzdGF0ZSAmIFBDSUVfTElOS19TVEFURV9MMSkNCi0JCWFzcG1fY3RsIHw9IFBDSV9FWFBfTE5L
Q1RMX0FTUE1fTDE7DQorCS8qIERvdWJsZS1jaGVjayBBU1BNIGNvbnRyb2wuICBJZiBub3QgZGlz
YWJsZWQgYnkgdGhlIGFib3ZlLCB0aGUNCisJICogQklPUyBpcyBwcmV2ZW50aW5nIHRoYXQgZnJv
bSBoYXBwZW5pbmcgKG9yIENPTkZJR19QQ0lFQVNQTSBpcw0KKwkgKiBub3QgZW5hYmxlZCk7IG92
ZXJyaWRlIGJ5IHdyaXRpbmcgUENJIGNvbmZpZyBzcGFjZSBkaXJlY3RseS4NCisJICovDQorCXBj
aWVfY2FwYWJpbGl0eV9yZWFkX3dvcmQocGRldiwgUENJX0VYUF9MTktDVEwsICZwZGV2X2FzcG1j
KTsNCisJcGRldl9hc3BtYyAmPSBQQ0lfRVhQX0xOS0NUTF9BU1BNQzsNCisNCisJaWYgKCEoYXNw
bV9kaXNfbWFzayAmIHBkZXZfYXNwbWMpKQ0KKwkJcmV0dXJuOw0KKwl9DQorI2VuZGlmDQogDQog
CS8qIEJvdGggZGV2aWNlIGFuZCBwYXJlbnQgc2hvdWxkIGhhdmUgdGhlIHNhbWUgQVNQTSBzZXR0
aW5nLg0KIAkgKiBEaXNhYmxlIEFTUE0gaW4gZG93bnN0cmVhbSBjb21wb25lbnQgZmlyc3QgYW5k
IHRoZW4gdXBzdHJlYW0uDQogCSAqLw0KLQlwY2llX2NhcGFiaWxpdHlfY2xlYXJfd29yZChwZGV2
LCBQQ0lfRVhQX0xOS0NUTCwgYXNwbV9jdGwpOw0KLQ0KLQlpZiAocGRldi0+YnVzLT5zZWxmKQ0K
LQkJcGNpZV9jYXBhYmlsaXR5X2NsZWFyX3dvcmQocGRldi0+YnVzLT5zZWxmLCBQQ0lfRVhQX0xO
S0NUTCwNCi0JCQkJCSAgIGFzcG1fY3RsKTsNCi19DQotI2VuZGlmDQotc3RhdGljIHZvaWQgZTEw
MDBlX2Rpc2FibGVfYXNwbShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgdTE2IHN0YXRlKQ0KLXsNCi0J
ZGV2X2luZm8oJnBkZXYtPmRldiwgIkRpc2FibGluZyBBU1BNICVzICVzXG4iLA0KLQkJIChzdGF0
ZSAmIFBDSUVfTElOS19TVEFURV9MMFMpID8gIkwwcyIgOiAiIiwNCi0JCSAoc3RhdGUgJiBQQ0lF
X0xJTktfU1RBVEVfTDEpID8gIkwxIiA6ICIiKTsNCisJcGNpZV9jYXBhYmlsaXR5X2NsZWFyX3dv
cmQocGRldiwgUENJX0VYUF9MTktDVEwsIGFzcG1fZGlzX21hc2spOw0KIA0KLQlfX2UxMDAwZV9k
aXNhYmxlX2FzcG0ocGRldiwgc3RhdGUpOw0KKwlpZiAocGFyZW50KQ0KKwkJcGNpZV9jYXBhYmls
aXR5X2NsZWFyX3dvcmQocGFyZW50LCBQQ0lfRVhQX0xOS0NUTCwNCisJCQkJCSAgIGFzcG1fZGlz
X21hc2spOw0KIH0NCiANCiAjaWZkZWYgQ09ORklHX1BNDQoNCg==

--_002_9BBC4E0CF881AA4299206E2E1412B6264F92AA50ORSMSX102amrcor_--
