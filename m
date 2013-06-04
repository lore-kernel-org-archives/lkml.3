Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3FDQ7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:59:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48285 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3FDQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 18/75] staging: vt6656: [bug] Fix missing spin lock in iwctl_siwpower.
Date: Tue,  4 Jun 2013 09:55:02 -0700
Message-Id: <1370364959-9475-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 91ec61f8f01cf32868e2ed2fa96a299e77964055 upstream.

Fixes occasional dead lock on power up / down.

spin_lock_irq is used because of unlocking with spin_unlock_irq
elsewhere in the driver.

Only relevant to kernels 3.8 and later when command was
transferred to the iw_handler.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/vt6656/iwctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 52fce69..9f2f1be 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1348,9 +1348,12 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		return rc;
 	}
 
+	spin_lock_irq(&pDevice->lock);
+
 	if (wrq->disabled) {
 		pDevice->ePSMode = WMAC_POWER_CAM;
 		PSvDisablePowerSaving(pDevice);
+		spin_unlock_irq(&pDevice->lock);
 		return rc;
 	}
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
@@ -1361,6 +1364,9 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		pDevice->ePSMode = WMAC_POWER_FAST;
 		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
 	}
+
+	spin_unlock_irq(&pDevice->lock);
+
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R \n");
-- 
1.8.1.2

