Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab3KZUbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:31:14 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:35869 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933Ab3KZUbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:31:06 -0500
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <adlai@linux.vnet.ibm.com>,
        tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 7/7] tpm: tpm_tis: Fix compile problems with CONFIG_PM_SLEEP/CONFIG_PNP
Date: Tue, 26 Nov 2013 13:30:46 -0700
Message-Id: <1385497846-29103-7-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385497846-29103-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1385497846-29103-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM_SLEEP=n, CONFIG_PNP=y we get this warning:

drivers/char/tpm/tpm_tis.c:706:13: warning: 'tpm_tis_reenable_interrupts' defined but not used [-Wunused-function]

This seems to have been introduced in a2fa3fb0d 'tpm: convert tpm_tis driver
to use dev_pm_ops from legacy pm_ops'

Also, unpon reviewing, the #ifdefs around tpm_tis_pm are not right, the first
reference is protected, the second is not. tpm_tis_pm is always defined so we
can drop the #ifdef.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_tis.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 8094b08..a9ed227 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -702,7 +702,7 @@ out_err:
 	return rc;
 }
 
-#if defined(CONFIG_PNP) || defined(CONFIG_PM_SLEEP)
+#ifdef CONFIG_PM_SLEEP
 static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 {
 	u32 intmask;
@@ -723,9 +723,7 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 	iowrite32(intmask,
 		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
 }
-#endif
 
-#ifdef CONFIG_PM_SLEEP
 static int tpm_tis_resume(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
@@ -794,11 +792,9 @@ static struct pnp_driver tis_pnp_driver = {
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_tis_pnp_init,
 	.remove = tpm_tis_pnp_remove,
-#ifdef CONFIG_PM_SLEEP
 	.driver	= {
 		.pm = &tpm_tis_pm,
 	},
-#endif
 };
 
 #define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
-- 
1.8.1.2

