Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3F2IEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 04:04:54 -0400
Received: from 8bytes.org ([85.214.48.195]:47766 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab3F2IEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 04:04:50 -0400
Date: Sat, 29 Jun 2013 10:04:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
Message-ID: <20130629080447.GX11309@8bytes.org>
References: <lhtAZ-q1-5@gated-at.bofh.it>
 <lhtB1-q1-53@gated-at.bofh.it>
 <20130628181136.52d00e9c@dualc.maya.org>
 <20130628182533.GT11309@8bytes.org>
 <51CDD8FD.808@01019freenet.de>
 <20130628192319.GV11309@8bytes.org>
 <51CE768C.3030102@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CE768C.3030102@01019freenet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Jun 29 10:04:48 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51ce952020869695614606
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 07:54:20AM +0200, Andreas Hartmann wrote:
> Sorry, but it doesn't work for me at all :-(. Behaviour is unchanged. It
> is exactly as described in the other mail: at the moment of binding vfio
> to 14.0, the fire begins.

Hmm, VFIO attaches the device to a new domain. That clears the bit, how
about this patch:

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 1a5285b..cdf346f 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2111,6 +2111,8 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain, bool ats)
 
 		tmp = DTE_GCR3_VAL_C(gcr3) << DTE_GCR3_SHIFT_C;
 		flags    |= tmp;
+
+		flags	 |= DTE_FLAG_SE;
 	}
 
 	flags &= ~(0xffffUL);
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index e3c2d74..74e1d1c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1431,6 +1431,7 @@ static void init_device_table_dma(void)
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
 		set_dev_entry_bit(devid, DEV_ENTRY_TRANSLATION);
+		set_dev_entry_bit(devid, DEV_ENTRY_ONE_FAULT);
 	}
 }
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 083f98c..2104ca4 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -173,6 +173,7 @@
 #define DEV_ENTRY_TRANSLATION   0x01
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
+#define DEV_ENTRY_ONE_FAULT	0x61
 #define DEV_ENTRY_NO_PAGE_FAULT	0x62
 #define DEV_ENTRY_EX            0x67
 #define DEV_ENTRY_SYSMGT1       0x68
@@ -282,6 +283,7 @@
 #define IOMMU_PTE_IW (1ULL << 62)
 
 #define DTE_FLAG_IOTLB	(0x01UL << 32)
+#define DTE_FLAG_SE	(0x01UL << 33)
 #define DTE_FLAG_GV	(0x01ULL << 55)
 #define DTE_GLX_SHIFT	(56)
 #define DTE_GLX_MASK	(3)

