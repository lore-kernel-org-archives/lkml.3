Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaEWEjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:39:09 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58757 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaEWEiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:38:51 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH 2/2] staging: slicoss: handle errors from slic_config_get
Date: Thu, 22 May 2014 21:38:45 -0700
Message-Id: <1400819925-19390-3-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400819925-19390-1-git-send-email-matlackdavid@gmail.com>
References: <1400819925-19390-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slic_config_get() can fail. Change the return type from void to
int and handle the error in slic_card_init(). So now, instead of
silently failing (and then timing out waiting for the config data),
the driver will fail loudly at request time.

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
 drivers/staging/slicoss/slicoss.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 5b82455..9c48cd8 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1140,14 +1140,10 @@ static void slic_upr_request_complete(struct adapter *adapter, u32 isr)
 				adapter->upr_lock.flags);
 }
 
-static void slic_config_get(struct adapter *adapter, u32 config,
-							u32 config_h)
+static int slic_config_get(struct adapter *adapter, u32 config, u32 config_h)
 {
-	int status;
-
-	status = slic_upr_request(adapter,
-				  SLIC_UPR_RCONFIG,
-				  (u32) config, (u32) config_h, 0, 0);
+	return slic_upr_request(adapter, SLIC_UPR_RCONFIG, config, config_h,
+				0, 0);
 }
 
 /*
@@ -3262,7 +3258,12 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
 					adapter->bit64reglock.flags);
 
-		slic_config_get(adapter, phys_configl, phys_configh);
+		status = slic_config_get(adapter, phys_configl, phys_configh);
+		if (status) {
+			dev_err(&adapter->pcidev->dev,
+				"Failed to fetch config data from device.\n");
+			goto card_init_err;
+		}
 
 		for (;;) {
 			if (adapter->pshmem->isr) {
@@ -3293,10 +3294,8 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 						&slic_regs->slic_isp, 0,
 						&slic_regs->slic_addr_upper,
 						0, FLUSH);
-					pci_free_consistent(adapter->pcidev,
-						sizeof(struct slic_eeprom),
-						peeprom, phys_config);
-					return -EINVAL;
+					status = -EINVAL;
+					goto card_init_err;
 				}
 			}
 		}
@@ -3406,6 +3405,11 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 	card->reset_in_progress = 0;
 
 	return 0;
+
+card_init_err:
+	pci_free_consistent(adapter->pcidev, sizeof(struct slic_eeprom),
+			    peeprom, phys_config);
+	return status;
 }
 
 static void slic_init_driver(void)
-- 
1.9.2

