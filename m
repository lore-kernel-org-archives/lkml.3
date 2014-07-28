Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaG1Uoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:44:32 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53946 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaG1UoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:44:20 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] staging: vt6655: deadcode remove undefined macro THREAD code.
Date: Mon, 28 Jul 2014 21:43:28 +0100
Message-Id: <1406580210-2794-2-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406580210-2794-1-git-send-email-tvboxspy@gmail.com>
References: <1406580210-2794-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing _RxManagementQueue, InitRxManagementQueue, MlmeThread, mlme_kill,
EnQueue and DeQueue.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 49 +-------------------------------
 drivers/staging/vt6655/device_main.c | 55 ------------------------------------
 drivers/staging/vt6655/dpc.c         |  7 +----
 3 files changed, 2 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index fccb510..b36c631 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -328,16 +328,6 @@ typedef struct tagSDeFragControlBlock {
 //for device_set_media_duplex
 #define     DEVICE_LINK_CHANGE           0x00000001UL
 
-//PLICE_DEBUG->
-
-typedef	struct _RxManagementQueue {
-	int	packet_num;
-	int	head, tail;
-	PSRxMgmtPacket	Q[NUM];
-} RxManagementQueue, *PSRxManagementQueue;
-
-//PLICE_DEBUG<-
-
 typedef struct __device_opt {
 	int         nRxDescs0;    //Number of RX descriptors0
 	int         nRxDescs1;    //Number of RX descriptors1
@@ -424,9 +414,7 @@ typedef struct __device_info {
 	unsigned char byRxMode;
 
 	spinlock_t                  lock;
-//PLICE_DEBUG->
-	RxManagementQueue	rxManeQueue;
-//PLICE_DEBUG<-
+
 //PLICE_DEBUG ->
 	pid_t			MLMEThr_pid;
 	struct completion	notify;
@@ -764,41 +752,6 @@ typedef struct __device_info {
 	bool bCommit;
 } DEVICE_INFO, *PSDevice;
 
-//PLICE_DEBUG->
-
-inline  static	void   EnQueue(PSDevice pDevice, PSRxMgmtPacket  pRxMgmtPacket)
-{
-	if ((pDevice->rxManeQueue.tail+1) % NUM == pDevice->rxManeQueue.head) {
-		return;
-	} else {
-		pDevice->rxManeQueue.tail = (pDevice->rxManeQueue.tail + 1) % NUM;
-		pDevice->rxManeQueue.Q[pDevice->rxManeQueue.tail] = pRxMgmtPacket;
-		pDevice->rxManeQueue.packet_num++;
-	}
-}
-
-static inline PSRxMgmtPacket DeQueue(PSDevice pDevice)
-{
-	PSRxMgmtPacket  pRxMgmtPacket;
-
-	if (pDevice->rxManeQueue.tail == pDevice->rxManeQueue.head) {
-		printk("Queue is Empty\n");
-		return NULL;
-	} else {
-		int	x;
-		//x=pDevice->rxManeQueue.head = (pDevice->rxManeQueue.head+1)%NUM;
-		pDevice->rxManeQueue.head = (pDevice->rxManeQueue.head+1)%NUM;
-		x = pDevice->rxManeQueue.head;
-		pRxMgmtPacket = pDevice->rxManeQueue.Q[x];
-		pDevice->rxManeQueue.packet_num--;
-		return pRxMgmtPacket;
-	}
-}
-
-void	InitRxManagementQueue(PSDevice   pDevice);
-
-//PLICE_DEBUG<-
-
 static inline bool device_get_ip(PSDevice pInfo) {
 	struct in_device *in_dev = (struct in_device *)pInfo->dev->ip_ptr;
 	struct in_ifaddr *ifa;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c43fc79..fe6de98 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -98,10 +98,6 @@ MODULE_AUTHOR("VIA Networking Technologies, Inc., <lyndonchen@vntek.com.tw>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VIA Networking Solomon-A/B/G Wireless LAN Adapter Driver");
 
-#ifdef	THREAD
-static int mlme_kill;
-#endif
-
 #define DEVICE_PARAM(N, D)
 
 #define RX_DESC_MIN0     16
@@ -1630,41 +1626,6 @@ static void device_free_tx_buf(PSDevice pDevice, PSTxDesc pDesc)
 	pTDInfo->byFlags = 0;
 }
 
-//PLICE_DEBUG ->
-void	InitRxManagementQueue(PSDevice  pDevice)
-{
-	pDevice->rxManeQueue.packet_num = 0;
-	pDevice->rxManeQueue.head = pDevice->rxManeQueue.tail = 0;
-}
-//PLICE_DEBUG<-
-
-//PLICE_DEBUG ->
-#ifdef	THREAD
-static int MlmeThread(
-	void *Context)
-{
-	PSDevice	pDevice =  (PSDevice) Context;
-	PSRxMgmtPacket			pRxMgmtPacket;
-
-	while (1) {
-		spin_lock_irq(&pDevice->lock);
-		while (pDevice->rxManeQueue.packet_num != 0) {
-			pRxMgmtPacket = DeQueue(pDevice);
-			vMgrRxManagePacket(pDevice, pDevice->pMgmt, pRxMgmtPacket);
-		}
-		spin_unlock_irq(&pDevice->lock);
-		if (mlme_kill == 0)
-			break;
-
-		schedule();
-		if (mlme_kill == 0)
-			break;
-	}
-
-	return 0;
-}
-#endif
-
 static int  device_open(struct net_device *dev)
 {
 	PSDevice pDevice = (PSDevice)netdev_priv(dev);
@@ -1703,19 +1664,6 @@ static int  device_open(struct net_device *dev)
 	vMgrObjectInit(pDevice);
 	vMgrTimerInit(pDevice);
 
-//PLICE_DEBUG->
-#ifdef	THREAD
-	InitRxManagementQueue(pDevice);
-	mlme_kill = 0;
-	mlme_task = kthread_run(MlmeThread, (void *)pDevice, "MLME");
-	if (IS_ERR(mlme_task)) {
-		pr_err("thread create fail\n");
-		return -1;
-	}
-
-	mlme_kill = 1;
-#endif
-
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "call device_init_registers\n");
 	device_init_registers(pDevice, DEVICE_INIT_COLD);
 	MACvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
@@ -1766,9 +1714,6 @@ static int  device_close(struct net_device *dev)
 	PSDevice  pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject     pMgmt = pDevice->pMgmt;
 	//PLICE_DEBUG->
-#ifdef	THREAD
-	mlme_kill = 0;
-#endif
 //PLICE_DEBUG<-
 //2007-1121-02<Add>by EinsnLiu
 	if (pDevice->bLinkPass) {
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 31bb2b7..0bcf6c7 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -529,14 +529,9 @@ device_receive_frame(
 			}
 			pRxPacket->byRxRate = s_byGetRateIdx(*pbyRxRate);
 			pRxPacket->byRxChannel = (*pbyRxSts) >> 2;
-//PLICE_DEBUG->
 
-#ifdef	THREAD
-			EnQueue(pDevice, pRxPacket);
-#else
 			vMgrRxManagePacket((void *)pDevice, pDevice->pMgmt, pRxPacket);
-#endif
-//PLICE_DEBUG<-
+
 			// hostap Deamon handle 802.11 management
 			if (pDevice->bEnableHostapd) {
 				skb->dev = pDevice->apdev;
-- 
1.9.1

