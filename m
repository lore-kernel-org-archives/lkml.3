Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaADCp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:45:59 -0500
Received: from mout.gmx.net ([212.227.17.21]:53601 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbaADCnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:43:23 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 14/15] tpm: tpm_tis: Fix compile problems with CONFIG_PM_SLEEP/CONFIG_PNP
Date: Sat,  4 Jan 2014 03:44:48 +0100
Message-Id: <1388803489-13258-14-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:Zuc2J+gC0W7S33cBx1advI2vgXtOStFYyuysWym5U1wTBHVV4lI
 QJvEeKTiZ0bJbnAyr4gNZmquKQ53uo5SNhxecX4wOg2HviqACkuoCr0W9+wScSE7dQlgd9b
 5Q28gwILcKccHBIk8YJMOaZynxSpbfPp1yutGxeGH7bNf459olZwHBLrhBfm3jk1XL1iCsY
 6qZzxhgV4eC6uM273mDBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

If CONFIG_PM_SLEEP=n, CONFIG_PNP=y we get this warning:

drivers/char/tpm/tpm_tis.c:706:13: warning: 'tpm_tis_reenable_interrupts' defined but not used [-Wunused-function]

This seems to have been introduced in a2fa3fb0d 'tpm: convert tpm_tis driver
to use dev_pm_ops from legacy pm_ops'

Also, unpon reviewing, the #ifdefs around tpm_tis_pm are not right, the first
reference is protected, the second is not. tpm_tis_pm is always defined so we
can drop the #ifdef.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
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
1.8.1.5

