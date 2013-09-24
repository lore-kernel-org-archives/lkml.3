Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab3IXUjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:39:17 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:55428 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab3IXUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:39:15 -0400
Date: Tue, 24 Sep 2013 14:39:10 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
Message-ID: <20130924203910.GB9302@google.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:13:06PM +0800, Yijing Wang wrote:
> Refactor qib_tune_pcie_caps() function, use pcie_set_mps()
> and pcie_get_mps() to simply code. Because pci core caches
> the "PCI-E Max Payload Size Supported" in pci_dev->pcie_mpss,
> so use that instead of pcie_capability_read_word(). Remove
> the unused val2fld() and fld2val().

I propose the following patch on top of this one:


IB/qib: Drop qib_tune_pcie_caps() and qib_tune_pcie_coalesce() return values

From: Bjorn Helgaas <bhelgaas@google.com>

The callers of qib_tune_pcie_caps() and qib_tune_pcie_coalesce() don't
check the return values, so this patch drops the return values altogether.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/infiniband/hw/qib/qib_pcie.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 24973c8..c8d9c4a 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -51,8 +51,8 @@
  * file calls, even though this violates some
  * expectations of harmlessness.
  */
-static int qib_tune_pcie_caps(struct qib_devdata *);
-static int qib_tune_pcie_coalesce(struct qib_devdata *);
+static void qib_tune_pcie_caps(struct qib_devdata *);
+static void qib_tune_pcie_coalesce(struct qib_devdata *);
 
 /*
  * Do all the common PCIe setup and initialization.
@@ -487,7 +487,7 @@ MODULE_PARM_DESC(pcie_coalesce, "tune PCIe colescing on some Intel chipsets");
  * of these chipsets, with some BIOS settings, and enabling it on those
  * systems may result in the system crashing, and/or data corruption.
  */
-static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
+static void qib_tune_pcie_coalesce(struct qib_devdata *dd)
 {
 	int r;
 	struct pci_dev *parent;
@@ -495,18 +495,18 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
 	u32 mask, bits, val;
 
 	if (!qib_pcie_coalesce)
-		return 0;
+		return;
 
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
 	if (parent->bus->parent) {
 		qib_devinfo(dd->pcidev, "Parent not root\n");
-		return 1;
+		return;
 	}
 	if (!pci_is_pcie(parent))
-		return 1;
+		return;
 	if (parent->vendor != 0x8086)
-		return 1;
+		return;
 
 	/*
 	 *  - bit 12: Max_rdcmp_Imt_EN: need to set to 1
@@ -539,13 +539,12 @@ static int qib_tune_pcie_coalesce(struct qib_devdata *dd)
 		mask = (3U << 24) | (7U << 10);
 	} else {
 		/* not one of the chipsets that we know about */
-		return 1;
+		return;
 	}
 	pci_read_config_dword(parent, 0x48, &val);
 	val &= ~mask;
 	val |= bits;
 	r = pci_write_config_dword(parent, 0x48, val);
-	return 0;
 }
 
 /*
@@ -556,9 +555,8 @@ static int qib_pcie_caps;
 module_param_named(pcie_caps, qib_pcie_caps, int, S_IRUGO);
 MODULE_PARM_DESC(pcie_caps, "Max PCIe tuning: Payload (0..3), ReadReq (4..7)");
 
-static int qib_tune_pcie_caps(struct qib_devdata *dd)
+static void qib_tune_pcie_caps(struct qib_devdata *dd)
 {
-	int ret = 1; /* Assume the worst */
 	struct pci_dev *parent;
 	u16 rc_mpss, rc_mps, ep_mpss, ep_mps;
 	u16 rc_mrrs, ep_mrrs, max_mrrs;
@@ -567,18 +565,18 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 	parent = dd->pcidev->bus->self;
 	if (!pci_is_root_bus(parent->bus)) {
 		qib_devinfo(dd->pcidev, "Parent not root\n");
-		goto bail;
+		return;
 	}
 
 	if (!pci_is_pcie(parent) || !pci_is_pcie(dd->pcidev))
-		goto bail;
+		return;
+
 	rc_mpss = parent->pcie_mpss;
 	rc_mps = ffs(pcie_get_mps(parent)) - 8;
 	/* Find out supported and configured values for endpoint (us) */
 	ep_mpss = dd->pcidev->pcie_mpss;
 	ep_mps = ffs(pcie_get_mps(dd->pcidev)) - 8;
 
-	ret = 0;
 	/* Find max payload supported by root, endpoint */
 	if (rc_mpss > ep_mpss)
 		rc_mpss = ep_mpss;
@@ -618,8 +616,6 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 		ep_mrrs = max_mrrs;
 		pcie_set_readrq(dd->pcidev, ep_mrrs);
 	}
-bail:
-	return ret;
 }
 /* End of PCIe capability tuning */
 
