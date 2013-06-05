Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab3FEWHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:07:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3FEVfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 018/127] staging: vt6656: [bug] Fix missing spin lock in iwctl_siwpower.
Date: Wed,  5 Jun 2013 14:33:05 -0700
Message-Id: <20130605213220.090697582@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/vt6656/iwctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1348,9 +1348,12 @@ int iwctl_siwpower(struct net_device *de
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
@@ -1361,6 +1364,9 @@ int iwctl_siwpower(struct net_device *de
 		pDevice->ePSMode = WMAC_POWER_FAST;
 		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
 	}
+
+	spin_unlock_irq(&pDevice->lock);
+
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R \n");


