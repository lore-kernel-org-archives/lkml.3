Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaG1UoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:44:21 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:37835 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1UoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:44:16 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/4] staging: vt6655: remove undefined TASK_LET code
Date: Mon, 28 Jul 2014 21:43:27 +0100
Message-Id: <1406580210-2794-1-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing all code within and function MngWorkItem.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  1 -
 drivers/staging/vt6655/device_main.c |  6 ------
 drivers/staging/vt6655/dpc.c         | 24 ------------------------
 drivers/staging/vt6655/dpc.h         |  2 --
 4 files changed, 33 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index a707984..fccb510 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -425,7 +425,6 @@ typedef struct __device_info {
 
 	spinlock_t                  lock;
 //PLICE_DEBUG->
-	struct	tasklet_struct	RxMngWorkItem;
 	RxManagementQueue	rxManeQueue;
 //PLICE_DEBUG<-
 //PLICE_DEBUG ->
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1e1d3b4..c43fc79 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1704,9 +1704,6 @@ static int  device_open(struct net_device *dev)
 	vMgrTimerInit(pDevice);
 
 //PLICE_DEBUG->
-#ifdef	TASK_LET
-	tasklet_init(&pDevice->RxMngWorkItem, (void *)MngWorkItem, (unsigned long)pDevice);
-#endif
 #ifdef	THREAD
 	InitRxManagementQueue(pDevice);
 	mlme_kill = 0;
@@ -1789,9 +1786,6 @@ static int  device_close(struct net_device *dev)
 		del_timer(&pDevice->TimerSQ3Tmax3);
 	}
 
-#ifdef	TASK_LET
-	tasklet_kill(&pDevice->RxMngWorkItem);
-#endif
 	netif_stop_queue(dev);
 	pDevice->bCmdRunning = false;
 	MACbShutdown(pDevice->PortOffset);
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index ac588cb..31bb2b7 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -268,23 +268,6 @@ s_vGetDASA(unsigned char *pbyRxBufferAddr, unsigned int *pcbHeaderSize,
 	*pcbHeaderSize = cbHeaderSize;
 }
 
-//PLICE_DEBUG ->
-
-void	MngWorkItem(void *Context)
-{
-	PSRxMgmtPacket			pRxMgmtPacket;
-	PSDevice	pDevice =  (PSDevice) Context;
-
-	spin_lock_irq(&pDevice->lock);
-	while (pDevice->rxManeQueue.packet_num != 0) {
-		pRxMgmtPacket =  DeQueue(pDevice);
-		vMgrRxManagePacket(pDevice, pDevice->pMgmt, pRxMgmtPacket);
-	}
-	spin_unlock_irq(&pDevice->lock);
-}
-
-//PLICE_DEBUG<-
-
 bool
 device_receive_frame(
 	PSDevice pDevice,
@@ -551,15 +534,8 @@ device_receive_frame(
 #ifdef	THREAD
 			EnQueue(pDevice, pRxPacket);
 #else
-
-#ifdef	TASK_LET
-			EnQueue(pDevice, pRxPacket);
-			tasklet_schedule(&pDevice->RxMngWorkItem);
-#else
 			vMgrRxManagePacket((void *)pDevice, pDevice->pMgmt, pRxPacket);
 #endif
-
-#endif
 //PLICE_DEBUG<-
 			// hostap Deamon handle 802.11 management
 			if (pDevice->bEnableHostapd) {
diff --git a/drivers/staging/vt6655/dpc.h b/drivers/staging/vt6655/dpc.h
index 0c7e0e7..4914890 100644
--- a/drivers/staging/vt6655/dpc.h
+++ b/drivers/staging/vt6655/dpc.h
@@ -39,6 +39,4 @@ device_receive_frame(
 	PSRxDesc pCurrRD
 );
 
-void	MngWorkItem(void *Context);
-
 #endif // __RXTX_H__
-- 
1.9.1

