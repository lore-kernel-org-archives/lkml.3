Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbaGVUK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:10:27 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:37134 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbaGVUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:09:01 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 1/5] staging: vt6655: change type of PortOffset to void __iomem *
Date: Tue, 22 Jul 2014 22:08:26 +0200
Message-Id: <1406059710-30903-2-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406059710-30903-1-git-send-email-gclement@baobob.org>
References: <1406059710-30903-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PortOffset was an unsigned long, but used as an pointer to io
memory. Sometimes it was not properly cast before use, which caused
many warning by sparse.

By updating its type to void __iomem *, and reflecting the changes
where it is needed, this removes most of those warnings.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/baseband.c    |  30 +++++-----
 drivers/staging/vt6655/baseband.h    |  24 ++++----
 drivers/staging/vt6655/card.c        |   8 +--
 drivers/staging/vt6655/card.h        |   8 +--
 drivers/staging/vt6655/device.h      |   2 +-
 drivers/staging/vt6655/device_main.c |   6 +-
 drivers/staging/vt6655/key.c         |  18 +++---
 drivers/staging/vt6655/key.h         |  16 +++---
 drivers/staging/vt6655/mac.c         | 104 +++++++++++++++++-----------------
 drivers/staging/vt6655/mac.h         | 106 +++++++++++++++++------------------
 drivers/staging/vt6655/rf.c          |  16 +++---
 drivers/staging/vt6655/rf.h          |   8 +--
 drivers/staging/vt6655/srom.c        |  24 ++++----
 drivers/staging/vt6655/srom.h        |  24 ++++----
 drivers/staging/vt6655/upc.h         |  18 ++----
 15 files changed, 203 insertions(+), 209 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 490ca96..0985563 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1987,7 +1987,7 @@ BBvCalculateParameter(
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool BBbReadEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char *pbyData)
+bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char *pbyData)
 {
 	unsigned short ww;
 	unsigned char byValue;
@@ -2029,7 +2029,7 @@ bool BBbReadEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned ch
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool BBbWriteEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byData)
+bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byData)
 {
 	unsigned short ww;
 	unsigned char byValue;
@@ -2070,7 +2070,7 @@ bool BBbWriteEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned c
  * Return Value: true if all TestBits are set; false otherwise.
  *
  */
-bool BBbIsRegBitsOn(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byTestBits)
+bool BBbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits)
 {
 	unsigned char byOrgData;
 
@@ -2092,7 +2092,7 @@ bool BBbIsRegBitsOn(unsigned long dwIoBase, unsigned char byBBAddr, unsigned cha
  * Return Value: true if all TestBits are clear; false otherwise.
  *
  */
-bool BBbIsRegBitsOff(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byTestBits)
+bool BBbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits)
 {
 	unsigned char byOrgData;
 
@@ -2119,7 +2119,7 @@ bool BBbVT3253Init(PSDevice pDevice)
 {
 	bool bResult = true;
 	int        ii;
-	unsigned long dwIoBase = pDevice->PortOffset;
+	void __iomem *dwIoBase = pDevice->PortOffset;
 	unsigned char byRFType = pDevice->byRFType;
 	unsigned char byLocalID = pDevice->byLocalID;
 
@@ -2285,7 +2285,7 @@ bool BBbVT3253Init(PSDevice pDevice)
  * Return Value: none
  *
  */
-void BBvReadAllRegs(unsigned long dwIoBase, unsigned char *pbyBBRegs)
+void BBvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyBBRegs)
 {
 	int  ii;
 	unsigned char byBase = 1;
@@ -2312,7 +2312,7 @@ void BBvReadAllRegs(unsigned long dwIoBase, unsigned char *pbyBBRegs)
 void BBvLoopbackOn(PSDevice pDevice)
 {
 	unsigned char byData;
-	unsigned long dwIoBase = pDevice->PortOffset;
+	void __iomem *dwIoBase = pDevice->PortOffset;
 
 	/* CR C9 = 0x00 */
 	BBbReadEmbedded(dwIoBase, 0xC9, &pDevice->byBBCRc9); /* CR201 */
@@ -2365,7 +2365,7 @@ void BBvLoopbackOn(PSDevice pDevice)
 void BBvLoopbackOff(PSDevice pDevice)
 {
 	unsigned char byData;
-	unsigned long dwIoBase = pDevice->PortOffset;
+	void __iomem *dwIoBase = pDevice->PortOffset;
 
 	BBbWriteEmbedded(dwIoBase, 0xC9, pDevice->byBBCRc9); /* CR201 */
 	BBbWriteEmbedded(dwIoBase, 0x88, pDevice->byBBCR88); /* CR136 */
@@ -2448,7 +2448,7 @@ void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData)
  *
  */
 void
-BBvSoftwareReset(unsigned long dwIoBase)
+BBvSoftwareReset(void __iomem *dwIoBase)
 {
 	BBbWriteEmbedded(dwIoBase, 0x50, 0x40);
 	BBbWriteEmbedded(dwIoBase, 0x50, 0);
@@ -2469,7 +2469,7 @@ BBvSoftwareReset(unsigned long dwIoBase)
  *
  */
 void
-BBvPowerSaveModeON(unsigned long dwIoBase)
+BBvPowerSaveModeON(void __iomem *dwIoBase)
 {
 	unsigned char byOrgData;
 
@@ -2491,7 +2491,7 @@ BBvPowerSaveModeON(unsigned long dwIoBase)
  *
  */
 void
-BBvPowerSaveModeOFF(unsigned long dwIoBase)
+BBvPowerSaveModeOFF(void __iomem *dwIoBase)
 {
 	unsigned char byOrgData;
 
@@ -2515,7 +2515,7 @@ BBvPowerSaveModeOFF(unsigned long dwIoBase)
  */
 
 void
-BBvSetTxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode)
+BBvSetTxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode)
 {
 	unsigned char byBBTxConf;
 
@@ -2548,7 +2548,7 @@ BBvSetTxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode)
  */
 
 void
-BBvSetRxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode)
+BBvSetRxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode)
 {
 	unsigned char byBBRxConf;
 
@@ -2578,14 +2578,14 @@ BBvSetRxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode)
  *
  */
 void
-BBvSetDeepSleep(unsigned long dwIoBase, unsigned char byLocalID)
+BBvSetDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID)
 {
 	BBbWriteEmbedded(dwIoBase, 0x0C, 0x17); /* CR12 */
 	BBbWriteEmbedded(dwIoBase, 0x0D, 0xB9); /* CR13 */
 }
 
 void
-BBvExitDeepSleep(unsigned long dwIoBase, unsigned char byLocalID)
+BBvExitDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID)
 {
 	BBbWriteEmbedded(dwIoBase, 0x0C, 0x00); /* CR12 */
 	BBbWriteEmbedded(dwIoBase, 0x0D, 0x01); /* CR13 */
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index e31bb76..2466e2f8 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -99,26 +99,26 @@ BBvCalculateParameter(
 	unsigned char *pbyPhySgn
 );
 
-bool BBbReadEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
-bool BBbWriteEmbedded(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byData);
+bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
+bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byData);
 
-void BBvReadAllRegs(unsigned long dwIoBase, unsigned char *pbyBBRegs);
+void BBvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyBBRegs);
 void BBvLoopbackOn(PSDevice pDevice);
 void BBvLoopbackOff(PSDevice pDevice);
 void BBvSetShortSlotTime(PSDevice pDevice);
-bool BBbIsRegBitsOn(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byTestBits);
-bool BBbIsRegBitsOff(unsigned long dwIoBase, unsigned char byBBAddr, unsigned char byTestBits);
+bool BBbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits);
+bool BBbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits);
 void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData);
 
 // VT3253 Baseband
 bool BBbVT3253Init(PSDevice pDevice);
-void BBvSoftwareReset(unsigned long dwIoBase);
-void BBvPowerSaveModeON(unsigned long dwIoBase);
-void BBvPowerSaveModeOFF(unsigned long dwIoBase);
-void BBvSetTxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode);
-void BBvSetRxAntennaMode(unsigned long dwIoBase, unsigned char byAntennaMode);
-void BBvSetDeepSleep(unsigned long dwIoBase, unsigned char byLocalID);
-void BBvExitDeepSleep(unsigned long dwIoBase, unsigned char byLocalID);
+void BBvSoftwareReset(void __iomem *dwIoBase);
+void BBvPowerSaveModeON(void __iomem *dwIoBase);
+void BBvPowerSaveModeOFF(void __iomem *dwIoBase);
+void BBvSetTxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode);
+void BBvSetRxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode);
+void BBvSetDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID);
+void BBvExitDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID);
 
 // timer for antenna diversity
 
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 0b2ca2f..988858b 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -1891,7 +1891,7 @@ unsigned char CARDbyGetPktType(void *pDeviceHandler)
  * Return Value: none
  *
  */
-void CARDvSetLoopbackMode(unsigned long dwIoBase, unsigned short wLoopbackMode)
+void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode)
 {
 	switch (wLoopbackMode) {
 	case CARD_LB_NONE:
@@ -1980,7 +1980,7 @@ QWORD CARDqGetTSFOffset(unsigned char byRxRate, QWORD qwTSF1, QWORD qwTSF2)
  * Return Value: true if success; otherwise false
  *
  */
-bool CARDbGetCurrentTSF(unsigned long dwIoBase, PQWORD pqwCurrTSF)
+bool CARDbGetCurrentTSF(void __iomem *dwIoBase, PQWORD pqwCurrTSF)
 {
 	unsigned short ww;
 	unsigned char byData;
@@ -2053,7 +2053,7 @@ QWORD CARDqGetNextTBTT(QWORD qwTSF, unsigned short wBeaconInterval)
  * Return Value: none
  *
  */
-void CARDvSetFirstNextTBTT(unsigned long dwIoBase, unsigned short wBeaconInterval)
+void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterval)
 {
 	QWORD   qwNextTBTT;
 
@@ -2084,7 +2084,7 @@ void CARDvSetFirstNextTBTT(unsigned long dwIoBase, unsigned short wBeaconInterva
  * Return Value: none
  *
  */
-void CARDvUpdateNextTBTT(unsigned long dwIoBase, QWORD qwTSF, unsigned short wBeaconInterval)
+void CARDvUpdateNextTBTT(void __iomem *dwIoBase, QWORD qwTSF, unsigned short wBeaconInterval)
 {
 	qwTSF = CARDqGetNextTBTT(qwTSF, wBeaconInterval);
 	// Set NextTBTT
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 829be92..2ab46f3 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -89,11 +89,11 @@ void vUpdateIFS(void *pDeviceHandler);
 void CARDvUpdateBasicTopRate(void *pDeviceHandler);
 bool CARDbAddBasicRate(void *pDeviceHandler, unsigned short wRateIdx);
 bool CARDbIsOFDMinBasicRate(void *pDeviceHandler);
-void CARDvSetLoopbackMode(unsigned long dwIoBase, unsigned short wLoopbackMode);
+void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode);
 bool CARDbSoftwareReset(void *pDeviceHandler);
-void CARDvSetFirstNextTBTT(unsigned long dwIoBase, unsigned short wBeaconInterval);
-void CARDvUpdateNextTBTT(unsigned long dwIoBase, QWORD qwTSF, unsigned short wBeaconInterval);
-bool CARDbGetCurrentTSF(unsigned long dwIoBase, PQWORD pqwCurrTSF);
+void CARDvSetFirstNextTBTT(void __iomem *dwIoBase, unsigned short wBeaconInterval);
+void CARDvUpdateNextTBTT(void __iomem *dwIoBase, QWORD qwTSF, unsigned short wBeaconInterval);
+bool CARDbGetCurrentTSF(void __iomem *dwIoBase, PQWORD pqwCurrTSF);
 QWORD CARDqGetNextTBTT(QWORD qwTSF, unsigned short wBeaconInterval);
 QWORD CARDqGetTSFOffset(unsigned char byRxRate, QWORD qwTSF1, QWORD qwTSF2);
 bool CARDbSetTxPower(void *pDeviceHandler, unsigned long ulTxPower);
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index aab63ca..647e36fe 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -391,7 +391,7 @@ typedef struct __device_info {
 
 	CHIP_TYPE                   chip_id;
 
-	unsigned long               PortOffset;
+	void __iomem                *PortOffset;
 	unsigned long dwIsr;
 	u32                         memaddr;
 	u32                         ioaddr;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index d17cb1a..4dcdfca 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -891,9 +891,9 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 #endif
 
-	pDevice->PortOffset = (unsigned long)ioremap(pDevice->memaddr & PCI_BASE_ADDRESS_MEM_MASK, pDevice->io_size);
+	pDevice->PortOffset = ioremap(pDevice->memaddr & PCI_BASE_ADDRESS_MEM_MASK, pDevice->io_size);
 
-	if (pDevice->PortOffset == 0) {
+	if (pDevice->PortOffset == NULL) {
 		printk(KERN_ERR DEVICE_NAME ": Failed to IO remapping ..\n");
 		device_free_info(pDevice);
 		return -ENODEV;
@@ -1079,7 +1079,7 @@ static void device_free_info(PSDevice pDevice) {
 		unregister_netdev(dev);
 
 	if (pDevice->PortOffset)
-		iounmap((void *)pDevice->PortOffset);
+		iounmap(pDevice->PortOffset);
 
 	if (pDevice->pcid)
 		pci_release_regions(pDevice->pcid);
diff --git a/drivers/staging/vt6655/key.c b/drivers/staging/vt6655/key.c
index 09a8bf5..f5bc4a2 100644
--- a/drivers/staging/vt6655/key.c
+++ b/drivers/staging/vt6655/key.c
@@ -58,7 +58,7 @@ static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
 static void
-s_vCheckKeyTableValid(PSKeyManagement pTable, unsigned long dwIoBase)
+s_vCheckKeyTableValid(PSKeyManagement pTable, void __iomem *dwIoBase)
 {
 	int i;
 
@@ -91,7 +91,7 @@ s_vCheckKeyTableValid(PSKeyManagement pTable, unsigned long dwIoBase)
  * Return Value: none
  *
  */
-void KeyvInitTable(PSKeyManagement pTable, unsigned long dwIoBase)
+void KeyvInitTable(PSKeyManagement pTable, void __iomem *dwIoBase)
 {
 	int i;
 	int jj;
@@ -187,7 +187,7 @@ bool KeybSetKey(
 	PQWORD          pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
-	unsigned long dwIoBase,
+	void __iomem *dwIoBase,
 	unsigned char byLocalID
 )
 {
@@ -351,7 +351,7 @@ bool KeybRemoveKey(
 	PSKeyManagement pTable,
 	unsigned char *pbyBSSID,
 	unsigned long dwKeyIndex,
-	unsigned long dwIoBase
+	void __iomem *dwIoBase
 )
 {
 	int  i;
@@ -418,7 +418,7 @@ bool KeybRemoveKey(
 bool KeybRemoveAllKey(
 	PSKeyManagement pTable,
 	unsigned char *pbyBSSID,
-	unsigned long dwIoBase
+	void __iomem *dwIoBase
 )
 {
 	int i, u;
@@ -453,7 +453,7 @@ bool KeybRemoveAllKey(
 void KeyvRemoveWEPKey(
 	PSKeyManagement pTable,
 	unsigned long dwKeyIndex,
-	unsigned long dwIoBase
+	void __iomem *dwIoBase
 )
 {
 	if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
@@ -473,7 +473,7 @@ void KeyvRemoveWEPKey(
 
 void KeyvRemoveAllWEPKey(
 	PSKeyManagement pTable,
-	unsigned long dwIoBase
+	void __iomem *dwIoBase
 )
 {
 	int i;
@@ -610,7 +610,7 @@ bool KeybSetDefaultKey(
 	PQWORD          pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
-	unsigned long dwIoBase,
+	void __iomem *dwIoBase,
 	unsigned char byLocalID
 )
 {
@@ -716,7 +716,7 @@ bool KeybSetAllGroupKey(
 	PQWORD          pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
-	unsigned long dwIoBase,
+	void __iomem *dwIoBase,
 	unsigned char byLocalID
 )
 {
diff --git a/drivers/staging/vt6655/key.h b/drivers/staging/vt6655/key.h
index 4b8b4b6..4eee192 100644
--- a/drivers/staging/vt6655/key.h
+++ b/drivers/staging/vt6655/key.h
@@ -97,7 +97,7 @@ typedef struct tagSKeyManagement
 
 /*---------------------  Export Functions  --------------------------*/
 
-void KeyvInitTable(PSKeyManagement pTable, unsigned long dwIoBase);
+void KeyvInitTable(PSKeyManagement pTable, void __iomem *dwIoBase);
 
 bool KeybGetKey(
 	PSKeyManagement pTable,
@@ -114,7 +114,7 @@ bool KeybSetKey(
 	PQWORD          pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
-	unsigned long dwIoBase,
+	void __iomem *dwIoBase,
 	unsigned char byLocalID
 );
 
@@ -125,7 +125,7 @@ bool KeybSetDefaultKey(
 	PQWORD          pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
-	unsigned long dwIoBase,
+	void __iomem *dwIoBase,
 	unsigned char byLocalID
 );
 
@@ -133,7 +133,7 @@ bool KeybRemoveKey(
 	PSKeyManagement pTable,
 	unsigned char *pbyBSSID,
 	unsigned long dwKeyIndex,
-	unsigned long dwIoBase
+	void __iomem *dwIoBase
 );
 
 bool KeybGetTransmitKey(
@@ -151,18 +151,18 @@ bool KeybCheckPairewiseKey(
 bool KeybRemoveAllKey(
 	PSKeyManagement pTable,
 	unsigned char *pbyBSSID,
-	unsigned long dwIoBase
+	void __iomem *dwIoBase
 );
 
 void KeyvRemoveWEPKey(
 	PSKeyManagement pTable,
 	unsigned long dwKeyIndex,
-	unsigned long dwIoBase
+	void __iomem *dwIoBase
 );
 
 void KeyvRemoveAllWEPKey(
 	PSKeyManagement pTable,
-	unsigned long dwIoBase
+	void __iomem *dwIoBase
 );
 
 bool KeybSetAllGroupKey(
@@ -172,7 +172,7 @@ bool KeybSetAllGroupKey(
 	PQWORD          pKeyRSC,
 	unsigned char *pbyKey,
 	unsigned char byKeyDecMode,
-	unsigned long dwIoBase,
+	void __iomem *dwIoBase,
 	unsigned char byLocalID
 );
 
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index af6876a..9bbc873 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -98,7 +98,7 @@ static int msglevel = MSG_LEVEL_INFO;
  * Return Value: none
  *
  */
-void MACvReadAllRegs(unsigned long dwIoBase, unsigned char *pbyMacRegs)
+void MACvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyMacRegs)
 {
 	int ii;
 
@@ -134,7 +134,7 @@ void MACvReadAllRegs(unsigned long dwIoBase, unsigned char *pbyMacRegs)
  * Return Value: true if all test bits On; otherwise false
  *
  */
-bool MACbIsRegBitsOn(unsigned long dwIoBase, unsigned char byRegOfs, unsigned char byTestBits)
+bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits)
 {
 	unsigned char byData;
 
@@ -157,7 +157,7 @@ bool MACbIsRegBitsOn(unsigned long dwIoBase, unsigned char byRegOfs, unsigned ch
  * Return Value: true if all test bits Off; otherwise false
  *
  */
-bool MACbIsRegBitsOff(unsigned long dwIoBase, unsigned char byRegOfs, unsigned char byTestBits)
+bool MACbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits)
 {
 	unsigned char byData;
 
@@ -178,7 +178,7 @@ bool MACbIsRegBitsOff(unsigned long dwIoBase, unsigned char byRegOfs, unsigned c
  * Return Value: true if interrupt is disable; otherwise false
  *
  */
-bool MACbIsIntDisable(unsigned long dwIoBase)
+bool MACbIsIntDisable(void __iomem *dwIoBase)
 {
 	unsigned long dwData;
 
@@ -203,7 +203,7 @@ bool MACbIsIntDisable(unsigned long dwIoBase)
  * Return Value: Mask Value read
  *
  */
-unsigned char MACbyReadMultiAddr(unsigned long dwIoBase, unsigned int uByteIdx)
+unsigned char MACbyReadMultiAddr(void __iomem *dwIoBase, unsigned int uByteIdx)
 {
 	unsigned char byData;
 
@@ -228,7 +228,7 @@ unsigned char MACbyReadMultiAddr(unsigned long dwIoBase, unsigned int uByteIdx)
  * Return Value: none
  *
  */
-void MACvWriteMultiAddr(unsigned long dwIoBase, unsigned int uByteIdx, unsigned char byData)
+void MACvWriteMultiAddr(void __iomem *dwIoBase, unsigned int uByteIdx, unsigned char byData)
 {
 	MACvSelectPage1(dwIoBase);
 	VNSvOutPortB(dwIoBase + MAC_REG_MAR0 + uByteIdx, byData);
@@ -249,7 +249,7 @@ void MACvWriteMultiAddr(unsigned long dwIoBase, unsigned int uByteIdx, unsigned
  * Return Value: none
  *
  */
-void MACvSetMultiAddrByHash(unsigned long dwIoBase, unsigned char byHashIdx)
+void MACvSetMultiAddrByHash(void __iomem *dwIoBase, unsigned char byHashIdx)
 {
 	unsigned int uByteIdx;
 	unsigned char byBitMask;
@@ -280,7 +280,7 @@ void MACvSetMultiAddrByHash(unsigned long dwIoBase, unsigned char byHashIdx)
  * Return Value: none
  *
  */
-void MACvResetMultiAddrByHash(unsigned long dwIoBase, unsigned char byHashIdx)
+void MACvResetMultiAddrByHash(void __iomem *dwIoBase, unsigned char byHashIdx)
 {
 	unsigned int uByteIdx;
 	unsigned char byBitMask;
@@ -311,7 +311,7 @@ void MACvResetMultiAddrByHash(unsigned long dwIoBase, unsigned char byHashIdx)
  * Return Value: none
  *
  */
-void MACvSetRxThreshold(unsigned long dwIoBase, unsigned char byThreshold)
+void MACvSetRxThreshold(void __iomem *dwIoBase, unsigned char byThreshold)
 {
 	unsigned char byOrgValue;
 
@@ -336,7 +336,7 @@ void MACvSetRxThreshold(unsigned long dwIoBase, unsigned char byThreshold)
  * Return Value: none
  *
  */
-void MACvGetRxThreshold(unsigned long dwIoBase, unsigned char *pbyThreshold)
+void MACvGetRxThreshold(void __iomem *dwIoBase, unsigned char *pbyThreshold)
 {
 	// get FCR0
 	VNSvInPortB(dwIoBase + MAC_REG_FCR0, pbyThreshold);
@@ -357,7 +357,7 @@ void MACvGetRxThreshold(unsigned long dwIoBase, unsigned char *pbyThreshold)
  * Return Value: none
  *
  */
-void MACvSetTxThreshold(unsigned long dwIoBase, unsigned char byThreshold)
+void MACvSetTxThreshold(void __iomem *dwIoBase, unsigned char byThreshold)
 {
 	unsigned char byOrgValue;
 
@@ -382,7 +382,7 @@ void MACvSetTxThreshold(unsigned long dwIoBase, unsigned char byThreshold)
  * Return Value: none
  *
  */
-void MACvGetTxThreshold(unsigned long dwIoBase, unsigned char *pbyThreshold)
+void MACvGetTxThreshold(void __iomem *dwIoBase, unsigned char *pbyThreshold)
 {
 	// get FCR0
 	VNSvInPortB(dwIoBase + MAC_REG_FCR0, pbyThreshold);
@@ -403,7 +403,7 @@ void MACvGetTxThreshold(unsigned long dwIoBase, unsigned char *pbyThreshold)
  * Return Value: none
  *
  */
-void MACvSetDmaLength(unsigned long dwIoBase, unsigned char byDmaLength)
+void MACvSetDmaLength(void __iomem *dwIoBase, unsigned char byDmaLength)
 {
 	unsigned char byOrgValue;
 
@@ -428,7 +428,7 @@ void MACvSetDmaLength(unsigned long dwIoBase, unsigned char byDmaLength)
  * Return Value: none
  *
  */
-void MACvGetDmaLength(unsigned long dwIoBase, unsigned char *pbyDmaLength)
+void MACvGetDmaLength(void __iomem *dwIoBase, unsigned char *pbyDmaLength)
 {
 	// get FCR0
 	VNSvInPortB(dwIoBase + MAC_REG_FCR0, pbyDmaLength);
@@ -449,7 +449,7 @@ void MACvGetDmaLength(unsigned long dwIoBase, unsigned char *pbyDmaLength)
  * Return Value: none
  *
  */
-void MACvSetShortRetryLimit(unsigned long dwIoBase, unsigned char byRetryLimit)
+void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
 {
 	// set SRT
 	VNSvOutPortB(dwIoBase + MAC_REG_SRT, byRetryLimit);
@@ -468,7 +468,7 @@ void MACvSetShortRetryLimit(unsigned long dwIoBase, unsigned char byRetryLimit)
  * Return Value: none
  *
  */
-void MACvGetShortRetryLimit(unsigned long dwIoBase, unsigned char *pbyRetryLimit)
+void MACvGetShortRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit)
 {
 	// get SRT
 	VNSvInPortB(dwIoBase + MAC_REG_SRT, pbyRetryLimit);
@@ -488,7 +488,7 @@ void MACvGetShortRetryLimit(unsigned long dwIoBase, unsigned char *pbyRetryLimit
  * Return Value: none
  *
  */
-void MACvSetLongRetryLimit(unsigned long dwIoBase, unsigned char byRetryLimit)
+void MACvSetLongRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
 {
 	// set LRT
 	VNSvOutPortB(dwIoBase + MAC_REG_LRT, byRetryLimit);
@@ -507,7 +507,7 @@ void MACvSetLongRetryLimit(unsigned long dwIoBase, unsigned char byRetryLimit)
  * Return Value: none
  *
  */
-void MACvGetLongRetryLimit(unsigned long dwIoBase, unsigned char *pbyRetryLimit)
+void MACvGetLongRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit)
 {
 	// get LRT
 	VNSvInPortB(dwIoBase + MAC_REG_LRT, pbyRetryLimit);
@@ -527,7 +527,7 @@ void MACvGetLongRetryLimit(unsigned long dwIoBase, unsigned char *pbyRetryLimit)
  * Return Value: none
  *
  */
-void MACvSetLoopbackMode(unsigned long dwIoBase, unsigned char byLoopbackMode)
+void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode)
 {
 	unsigned char byOrgValue;
 
@@ -553,7 +553,7 @@ void MACvSetLoopbackMode(unsigned long dwIoBase, unsigned char byLoopbackMode)
  * Return Value: true if in Loopback mode; otherwise false
  *
  */
-bool MACbIsInLoopbackMode(unsigned long dwIoBase)
+bool MACbIsInLoopbackMode(void __iomem *dwIoBase)
 {
 	unsigned char byOrgValue;
 
@@ -577,7 +577,7 @@ bool MACbIsInLoopbackMode(unsigned long dwIoBase)
  * Return Value: none
  *
  */
-void MACvSetPacketFilter(unsigned long dwIoBase, unsigned short wFilterType)
+void MACvSetPacketFilter(void __iomem *dwIoBase, unsigned short wFilterType)
 {
 	unsigned char byOldRCR;
 	unsigned char byNewRCR = 0;
@@ -636,7 +636,7 @@ void MACvSetPacketFilter(unsigned long dwIoBase, unsigned short wFilterType)
  * Return Value: none
  *
  */
-void MACvSaveContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
+void MACvSaveContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
 {
 	int         ii;
 
@@ -667,7 +667,7 @@ void MACvSaveContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
  * Return Value: none
  *
  */
-void MACvRestoreContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
+void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
 {
 	int         ii;
 
@@ -716,7 +716,7 @@ void MACvRestoreContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
  * Return Value: true if all values are the same; otherwise false
  *
  */
-bool MACbCompareContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
+bool MACbCompareContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
 {
 	unsigned long dwData;
 
@@ -756,7 +756,7 @@ bool MACbCompareContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf)
  * Return Value: true if Reset Success; otherwise false
  *
  */
-bool MACbSoftwareReset(unsigned long dwIoBase)
+bool MACbSoftwareReset(void __iomem *dwIoBase)
 {
 	unsigned char byData;
 	unsigned short ww;
@@ -787,7 +787,7 @@ bool MACbSoftwareReset(unsigned long dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbSafeSoftwareReset(unsigned long dwIoBase)
+bool MACbSafeSoftwareReset(void __iomem *dwIoBase)
 {
 	unsigned char abyTmpRegData[MAC_MAX_CONTEXT_SIZE_PAGE0+MAC_MAX_CONTEXT_SIZE_PAGE1];
 	bool bRetVal;
@@ -819,7 +819,7 @@ bool MACbSafeSoftwareReset(unsigned long dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbSafeRxOff(unsigned long dwIoBase)
+bool MACbSafeRxOff(void __iomem *dwIoBase)
 {
 	unsigned short ww;
 	unsigned long dwData;
@@ -880,7 +880,7 @@ bool MACbSafeRxOff(unsigned long dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbSafeTxOff(unsigned long dwIoBase)
+bool MACbSafeTxOff(void __iomem *dwIoBase)
 {
 	unsigned short ww;
 	unsigned long dwData;
@@ -943,7 +943,7 @@ bool MACbSafeTxOff(unsigned long dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbSafeStop(unsigned long dwIoBase)
+bool MACbSafeStop(void __iomem *dwIoBase)
 {
 	MACvRegBitsOff(dwIoBase, MAC_REG_TCR, TCR_AUTOBCNTX);
 
@@ -978,7 +978,7 @@ bool MACbSafeStop(unsigned long dwIoBase)
  * Return Value: true if success; otherwise false
  *
  */
-bool MACbShutdown(unsigned long dwIoBase)
+bool MACbShutdown(void __iomem *dwIoBase)
 {
 	// disable MAC IMR
 	MACvIntDisable(dwIoBase);
@@ -1005,7 +1005,7 @@ bool MACbShutdown(unsigned long dwIoBase)
  * Return Value: none
  *
  */
-void MACvInitialize(unsigned long dwIoBase)
+void MACvInitialize(void __iomem *dwIoBase)
 {
 	// clear sticky bits
 	MACvClearStckDS(dwIoBase);
@@ -1041,7 +1041,7 @@ void MACvInitialize(unsigned long dwIoBase)
  * Return Value: none
  *
  */
-void MACvSetCurrRx0DescAddr(unsigned long dwIoBase, unsigned long dwCurrDescAddr)
+void MACvSetCurrRx0DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr)
 {
 	unsigned short ww;
 	unsigned char byData;
@@ -1079,7 +1079,7 @@ void MACvSetCurrRx0DescAddr(unsigned long dwIoBase, unsigned long dwCurrDescAddr
  * Return Value: none
  *
  */
-void MACvSetCurrRx1DescAddr(unsigned long dwIoBase, unsigned long dwCurrDescAddr)
+void MACvSetCurrRx1DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr)
 {
 	unsigned short ww;
 	unsigned char byData;
@@ -1117,7 +1117,7 @@ void MACvSetCurrRx1DescAddr(unsigned long dwIoBase, unsigned long dwCurrDescAddr
  * Return Value: none
  *
  */
-void MACvSetCurrTx0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAddr)
+void MACvSetCurrTx0DescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr)
 {
 	unsigned short ww;
 	unsigned char byData;
@@ -1155,7 +1155,7 @@ void MACvSetCurrTx0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAd
  *
  */
 //TxDMA1 = AC0DMA
-void MACvSetCurrAC0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAddr)
+void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr)
 {
 	unsigned short ww;
 	unsigned char byData;
@@ -1179,7 +1179,7 @@ void MACvSetCurrAC0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAd
 		VNSvOutPortB(dwIoBase + MAC_REG_AC0DMACTL, DMACTL_RUN);
 }
 
-void MACvSetCurrTXDescAddr(int iTxType, unsigned long dwIoBase, unsigned long dwCurrDescAddr)
+void MACvSetCurrTXDescAddr(int iTxType, void __iomem *dwIoBase, unsigned long dwCurrDescAddr)
 {
 	if (iTxType == TYPE_AC0DMA)
 		MACvSetCurrAC0DescAddrEx(dwIoBase, dwCurrDescAddr);
@@ -1201,7 +1201,7 @@ void MACvSetCurrTXDescAddr(int iTxType, unsigned long dwIoBase, unsigned long dw
  * Return Value: none
  *
  */
-void MACvTimer0MicroSDelay(unsigned long dwIoBase, unsigned int uDelay)
+void MACvTimer0MicroSDelay(void __iomem *dwIoBase, unsigned int uDelay)
 {
 	unsigned char byValue;
 	unsigned int uu, ii;
@@ -1236,7 +1236,7 @@ void MACvTimer0MicroSDelay(unsigned long dwIoBase, unsigned int uDelay)
  * Return Value: none
  *
  */
-void MACvOneShotTimer0MicroSec(unsigned long dwIoBase, unsigned int uDelayTime)
+void MACvOneShotTimer0MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime)
 {
 	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL0, 0);
 	VNSvOutPortD(dwIoBase + MAC_REG_TMDATA0, uDelayTime);
@@ -1257,14 +1257,14 @@ void MACvOneShotTimer0MicroSec(unsigned long dwIoBase, unsigned int uDelayTime)
  * Return Value: none
  *
  */
-void MACvOneShotTimer1MicroSec(unsigned long dwIoBase, unsigned int uDelayTime)
+void MACvOneShotTimer1MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime)
 {
 	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL1, 0);
 	VNSvOutPortD(dwIoBase + MAC_REG_TMDATA1, uDelayTime);
 	VNSvOutPortB(dwIoBase + MAC_REG_TMCTL1, (TMCTL_TMD | TMCTL_TE));
 }
 
-void MACvSetMISCFifo(unsigned long dwIoBase, unsigned short wOffset, unsigned long dwData)
+void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset, unsigned long dwData)
 {
 	if (wOffset > 273)
 		return;
@@ -1273,7 +1273,7 @@ void MACvSetMISCFifo(unsigned long dwIoBase, unsigned short wOffset, unsigned lo
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 }
 
-bool MACbTxDMAOff(unsigned long dwIoBase, unsigned int idx)
+bool MACbTxDMAOff(void __iomem *dwIoBase, unsigned int idx)
 {
 	unsigned char byData;
 	unsigned int ww = 0;
@@ -1301,7 +1301,7 @@ bool MACbTxDMAOff(unsigned long dwIoBase, unsigned int idx)
 	return true;
 }
 
-void MACvClearBusSusInd(unsigned long dwIoBase)
+void MACvClearBusSusInd(void __iomem *dwIoBase)
 {
 	unsigned long dwOrgValue;
 	unsigned int ww;
@@ -1323,7 +1323,7 @@ void MACvClearBusSusInd(unsigned long dwIoBase)
 	}
 }
 
-void MACvEnableBusSusEn(unsigned long dwIoBase)
+void MACvEnableBusSusEn(void __iomem *dwIoBase)
 {
 	unsigned char byOrgValue;
 	unsigned long dwOrgValue;
@@ -1345,7 +1345,7 @@ void MACvEnableBusSusEn(unsigned long dwIoBase)
 	}
 }
 
-bool MACbFlushSYNCFifo(unsigned long dwIoBase)
+bool MACbFlushSYNCFifo(void __iomem *dwIoBase)
 {
 	unsigned char byOrgValue;
 	unsigned int ww;
@@ -1369,7 +1369,7 @@ bool MACbFlushSYNCFifo(unsigned long dwIoBase)
 	return true;
 }
 
-bool MACbPSWakeup(unsigned long dwIoBase)
+bool MACbPSWakeup(void __iomem *dwIoBase)
 {
 	unsigned char byOrgValue;
 	unsigned int ww;
@@ -1409,7 +1409,7 @@ bool MACbPSWakeup(unsigned long dwIoBase)
  *
  */
 
-void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx,
+void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx,
 		     unsigned int uKeyIdx, unsigned char *pbyAddr, u32 *pdwKey, unsigned char byLocalID)
 {
 	unsigned short wOffset;
@@ -1473,7 +1473,7 @@ void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned in
  * Return Value: none
  *
  */
-void MACvDisableKeyEntry(unsigned long dwIoBase, unsigned int uEntryIdx)
+void MACvDisableKeyEntry(void __iomem *dwIoBase, unsigned int uEntryIdx)
 {
 	unsigned short wOffset;
 
@@ -1500,7 +1500,7 @@ void MACvDisableKeyEntry(unsigned long dwIoBase, unsigned int uEntryIdx)
  *
  */
 
-void MACvSetDefaultKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
+void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 			    unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID)
 {
 	unsigned short wOffset;
@@ -1549,7 +1549,7 @@ void MACvSetDefaultKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
  *
  */
 /*
-  void MACvEnableDefaultKey(unsigned long dwIoBase, unsigned char byLocalID)
+  void MACvEnableDefaultKey(void __iomem *dwIoBase, unsigned char byLocalID)
   {
   unsigned short wOffset;
   unsigned long dwData;
@@ -1583,7 +1583,7 @@ void MACvSetDefaultKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
  * Return Value: none
  *
  */
-void MACvDisableDefaultKey(unsigned long dwIoBase)
+void MACvDisableDefaultKey(void __iomem *dwIoBase)
 {
 	unsigned short wOffset;
 	unsigned long dwData;
@@ -1612,7 +1612,7 @@ void MACvDisableDefaultKey(unsigned long dwIoBase)
  * Return Value: none
  *
  */
-void MACvSetDefaultTKIPKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
+void MACvSetDefaultTKIPKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 				unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID)
 {
 	unsigned short wOffset;
@@ -1665,7 +1665,7 @@ void MACvSetDefaultTKIPKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
  *
  */
 
-void MACvSetDefaultKeyCtl(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx, unsigned char byLocalID)
+void MACvSetDefaultKeyCtl(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx, unsigned char byLocalID)
 {
 	unsigned short wOffset;
 	unsigned long dwData;
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 7333b8b..98ade83 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -973,78 +973,78 @@ do {								\
 /*---------------------  Export Functions  --------------------------*/
 
 extern unsigned short TxRate_iwconfig;//2008-5-8 <add> by chester
-void MACvReadAllRegs(unsigned long dwIoBase, unsigned char *pbyMacRegs);
+void MACvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyMacRegs);
 
-bool MACbIsRegBitsOn(unsigned long dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
-bool MACbIsRegBitsOff(unsigned long dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
+bool MACbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
+bool MACbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byRegOfs, unsigned char byTestBits);
 
-bool MACbIsIntDisable(unsigned long dwIoBase);
+bool MACbIsIntDisable(void __iomem *dwIoBase);
 
-unsigned char MACbyReadMultiAddr(unsigned long dwIoBase, unsigned int uByteIdx);
-void MACvWriteMultiAddr(unsigned long dwIoBase, unsigned int uByteIdx, unsigned char byData);
-void MACvSetMultiAddrByHash(unsigned long dwIoBase, unsigned char byHashIdx);
-void MACvResetMultiAddrByHash(unsigned long dwIoBase, unsigned char byHashIdx);
+unsigned char MACbyReadMultiAddr(void __iomem *dwIoBase, unsigned int uByteIdx);
+void MACvWriteMultiAddr(void __iomem *dwIoBase, unsigned int uByteIdx, unsigned char byData);
+void MACvSetMultiAddrByHash(void __iomem *dwIoBase, unsigned char byHashIdx);
+void MACvResetMultiAddrByHash(void __iomem *dwIoBase, unsigned char byHashIdx);
 
-void MACvSetRxThreshold(unsigned long dwIoBase, unsigned char byThreshold);
-void MACvGetRxThreshold(unsigned long dwIoBase, unsigned char *pbyThreshold);
+void MACvSetRxThreshold(void __iomem *dwIoBase, unsigned char byThreshold);
+void MACvGetRxThreshold(void __iomem *dwIoBase, unsigned char *pbyThreshold);
 
-void MACvSetTxThreshold(unsigned long dwIoBase, unsigned char byThreshold);
-void MACvGetTxThreshold(unsigned long dwIoBase, unsigned char *pbyThreshold);
+void MACvSetTxThreshold(void __iomem *dwIoBase, unsigned char byThreshold);
+void MACvGetTxThreshold(void __iomem *dwIoBase, unsigned char *pbyThreshold);
 
-void MACvSetDmaLength(unsigned long dwIoBase, unsigned char byDmaLength);
-void MACvGetDmaLength(unsigned long dwIoBase, unsigned char *pbyDmaLength);
+void MACvSetDmaLength(void __iomem *dwIoBase, unsigned char byDmaLength);
+void MACvGetDmaLength(void __iomem *dwIoBase, unsigned char *pbyDmaLength);
 
-void MACvSetShortRetryLimit(unsigned long dwIoBase, unsigned char byRetryLimit);
-void MACvGetShortRetryLimit(unsigned long dwIoBase, unsigned char *pbyRetryLimit);
+void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit);
+void MACvGetShortRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit);
 
-void MACvSetLongRetryLimit(unsigned long dwIoBase, unsigned char byRetryLimit);
-void MACvGetLongRetryLimit(unsigned long dwIoBase, unsigned char *pbyRetryLimit);
+void MACvSetLongRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit);
+void MACvGetLongRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit);
 
-void MACvSetLoopbackMode(unsigned long dwIoBase, unsigned char byLoopbackMode);
-bool MACbIsInLoopbackMode(unsigned long dwIoBase);
+void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode);
+bool MACbIsInLoopbackMode(void __iomem *dwIoBase);
 
-void MACvSetPacketFilter(unsigned long dwIoBase, unsigned short wFilterType);
+void MACvSetPacketFilter(void __iomem *dwIoBase, unsigned short wFilterType);
 
-void MACvSaveContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf);
-void MACvRestoreContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf);
-bool MACbCompareContext(unsigned long dwIoBase, unsigned char *pbyCxtBuf);
+void MACvSaveContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
+void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
+bool MACbCompareContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
 
-bool MACbSoftwareReset(unsigned long dwIoBase);
-bool MACbSafeSoftwareReset(unsigned long dwIoBase);
-bool MACbSafeRxOff(unsigned long dwIoBase);
-bool MACbSafeTxOff(unsigned long dwIoBase);
-bool MACbSafeStop(unsigned long dwIoBase);
-bool MACbShutdown(unsigned long dwIoBase);
-void MACvInitialize(unsigned long dwIoBase);
-void MACvSetCurrRx0DescAddr(unsigned long dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrRx1DescAddr(unsigned long dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrTXDescAddr(int iTxType, unsigned long dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrTx0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrAC0DescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrSyncDescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAddr);
-void MACvSetCurrATIMDescAddrEx(unsigned long dwIoBase, unsigned long dwCurrDescAddr);
-void MACvTimer0MicroSDelay(unsigned long dwIoBase, unsigned int uDelay);
-void MACvOneShotTimer0MicroSec(unsigned long dwIoBase, unsigned int uDelayTime);
-void MACvOneShotTimer1MicroSec(unsigned long dwIoBase, unsigned int uDelayTime);
+bool MACbSoftwareReset(void __iomem *dwIoBase);
+bool MACbSafeSoftwareReset(void __iomem *dwIoBase);
+bool MACbSafeRxOff(void __iomem *dwIoBase);
+bool MACbSafeTxOff(void __iomem *dwIoBase);
+bool MACbSafeStop(void __iomem *dwIoBase);
+bool MACbShutdown(void __iomem *dwIoBase);
+void MACvInitialize(void __iomem *dwIoBase);
+void MACvSetCurrRx0DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
+void MACvSetCurrRx1DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
+void MACvSetCurrTXDescAddr(int iTxType, void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
+void MACvSetCurrTx0DescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
+void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
+void MACvSetCurrSyncDescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
+void MACvSetCurrATIMDescAddrEx(void __iomem *dwIoBase, unsigned long dwCurrDescAddr);
+void MACvTimer0MicroSDelay(void __iomem *dwIoBase, unsigned int uDelay);
+void MACvOneShotTimer0MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime);
+void MACvOneShotTimer1MicroSec(void __iomem *dwIoBase, unsigned int uDelayTime);
 
-void MACvSetMISCFifo(unsigned long dwIoBase, unsigned short wOffset, unsigned long dwData);
+void MACvSetMISCFifo(void __iomem *dwIoBase, unsigned short wOffset, unsigned long dwData);
 
-bool MACbTxDMAOff(unsigned long dwIoBase, unsigned int idx);
+bool MACbTxDMAOff(void __iomem *dwIoBase, unsigned int idx);
 
-void MACvClearBusSusInd(unsigned long dwIoBase);
-void MACvEnableBusSusEn(unsigned long dwIoBase);
+void MACvClearBusSusInd(void __iomem *dwIoBase);
+void MACvEnableBusSusEn(void __iomem *dwIoBase);
 
-bool MACbFlushSYNCFifo(unsigned long dwIoBase);
-bool MACbPSWakeup(unsigned long dwIoBase);
+bool MACbFlushSYNCFifo(void __iomem *dwIoBase);
+bool MACbPSWakeup(void __iomem *dwIoBase);
 
-void MACvSetKeyEntry(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx,
+void MACvSetKeyEntry(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx,
 		     unsigned int uKeyIdx, unsigned char *pbyAddr, u32 *pdwKey, unsigned char byLocalID);
-void MACvDisableKeyEntry(unsigned long dwIoBase, unsigned int uEntryIdx);
-void MACvSetDefaultKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
+void MACvDisableKeyEntry(void __iomem *dwIoBase, unsigned int uEntryIdx);
+void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 			    unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID);
-void MACvDisableDefaultKey(unsigned long dwIoBase);
-void MACvSetDefaultTKIPKeyEntry(unsigned long dwIoBase, unsigned int uKeyLen,
+void MACvDisableDefaultKey(void __iomem *dwIoBase);
+void MACvSetDefaultTKIPKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 				unsigned int uKeyIdx, unsigned long *pdwKey, unsigned char byLocalID);
-void MACvSetDefaultKeyCtl(unsigned long dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx, unsigned char byLocalID);
+void MACvSetDefaultKeyCtl(void __iomem *dwIoBase, unsigned short wKeyCtl, unsigned int uEntryIdx, unsigned char byLocalID);
 
 #endif // __MAC_H__
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 99c89a1..33913e5 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -424,7 +424,7 @@ static const unsigned long dwAL7230ChannelTable2[CB_MAX_CHANNEL] = {
  * Return Value: true if succeeded; false if failed.
  *
  */
-static bool s_bAL7230Init(unsigned long dwIoBase)
+static bool s_bAL7230Init(void __iomem *dwIoBase)
 {
 	int     ii;
 	bool bResult;
@@ -467,7 +467,7 @@ static bool s_bAL7230Init(unsigned long dwIoBase)
 }
 
 // Need to Pull PLLON low when writing channel registers through 3-wire interface
-static bool s_bAL7230SelectChannel(unsigned long dwIoBase, unsigned char byChannel)
+static bool s_bAL7230SelectChannel(void __iomem *dwIoBase, unsigned char byChannel)
 {
 	bool bResult;
 
@@ -567,7 +567,7 @@ static bool s_bAL7230SelectChannel(unsigned long dwIoBase, unsigned char byChann
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool IFRFbWriteEmbedded(unsigned long dwIoBase, unsigned long dwData)
+bool IFRFbWriteEmbedded(void __iomem *dwIoBase, unsigned long dwData)
 {
 	unsigned short ww;
 	unsigned long dwValue;
@@ -626,7 +626,7 @@ bool IFRFbWriteEmbedded(unsigned long dwIoBase, unsigned long dwData)
  * Return Value: true if succeeded; false if failed.
  *
  */
-static bool RFbAL2230Init(unsigned long dwIoBase)
+static bool RFbAL2230Init(void __iomem *dwIoBase)
 {
 	int     ii;
 	bool bResult;
@@ -673,7 +673,7 @@ static bool RFbAL2230Init(unsigned long dwIoBase)
 	return bResult;
 }
 
-static bool RFbAL2230SelectChannel(unsigned long dwIoBase, unsigned char byChannel)
+static bool RFbAL2230SelectChannel(void __iomem *dwIoBase, unsigned char byChannel)
 {
 	bool bResult;
 
@@ -783,7 +783,7 @@ bool RFbInit(
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool RFbSelectChannel(unsigned long dwIoBase, unsigned char byRFType, unsigned char byChannel)
+bool RFbSelectChannel(void __iomem *dwIoBase, unsigned char byRFType, unsigned char byChannel)
 {
 	bool bResult = true;
 	switch (byRFType) {
@@ -818,7 +818,7 @@ bool RFbSelectChannel(unsigned long dwIoBase, unsigned char byRFType, unsigned c
  * Return Value: None.
  *
  */
-bool RFvWriteWakeProgSyn(unsigned long dwIoBase, unsigned char byRFType, unsigned int uChannel)
+bool RFvWriteWakeProgSyn(void __iomem *dwIoBase, unsigned char byRFType, unsigned int uChannel)
 {
 	int   ii;
 	unsigned char byInitCount = 0;
@@ -1070,7 +1070,7 @@ RFvRSSITodBm(
 
 // Post processing for the 11b/g and 11a.
 // for save time on changing Reg2,3,5,7,10,12,15
-bool RFbAL7230SelectChannelPostProcess(unsigned long dwIoBase, unsigned char byOldChannel, unsigned char byNewChannel)
+bool RFbAL7230SelectChannelPostProcess(void __iomem *dwIoBase, unsigned char byOldChannel, unsigned char byNewChannel)
 {
 	bool bResult;
 
diff --git a/drivers/staging/vt6655/rf.h b/drivers/staging/vt6655/rf.h
index ef3c6de..ba55561 100644
--- a/drivers/staging/vt6655/rf.h
+++ b/drivers/staging/vt6655/rf.h
@@ -74,12 +74,12 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-bool IFRFbWriteEmbedded(unsigned long dwIoBase, unsigned long dwData);
-bool RFbSelectChannel(unsigned long dwIoBase, unsigned char byRFType, unsigned char byChannel);
+bool IFRFbWriteEmbedded(void __iomem *dwIoBase, unsigned long dwData);
+bool RFbSelectChannel(void __iomem *dwIoBase, unsigned char byRFType, unsigned char byChannel);
 bool RFbInit(
 	PSDevice  pDevice
 );
-bool RFvWriteWakeProgSyn(unsigned long dwIoBase, unsigned char byRFType, unsigned int uChannel);
+bool RFvWriteWakeProgSyn(void __iomem *dwIoBase, unsigned char byRFType, unsigned int uChannel);
 bool RFbSetPower(PSDevice pDevice, unsigned int uRATE, unsigned int uCH);
 bool RFbRawSetPower(
 	PSDevice  pDevice,
@@ -95,7 +95,7 @@ RFvRSSITodBm(
 );
 
 //{{ RobertYu: 20050104
-bool RFbAL7230SelectChannelPostProcess(unsigned long dwIoBase, unsigned char byOldChannel, unsigned char byNewChannel);
+bool RFbAL7230SelectChannelPostProcess(void __iomem *dwIoBase, unsigned char byOldChannel, unsigned char byNewChannel);
 //}} RobertYu
 
 #endif // __RF_H__
diff --git a/drivers/staging/vt6655/srom.c b/drivers/staging/vt6655/srom.c
index eaddc33..5396e58 100644
--- a/drivers/staging/vt6655/srom.c
+++ b/drivers/staging/vt6655/srom.c
@@ -73,7 +73,7 @@
  * Return Value: data read
  *
  */
-unsigned char SROMbyReadEmbedded(unsigned long dwIoBase, unsigned char byContntOffset)
+unsigned char SROMbyReadEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset)
 {
 	unsigned short wDelay, wNoACK;
 	unsigned char byWait;
@@ -121,7 +121,7 @@ unsigned char SROMbyReadEmbedded(unsigned long dwIoBase, unsigned char byContntO
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool SROMbWriteEmbedded(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byData)
+bool SROMbWriteEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byData)
 {
 	unsigned short wDelay, wNoACK;
 	unsigned char byWait;
@@ -173,7 +173,7 @@ bool SROMbWriteEmbedded(unsigned long dwIoBase, unsigned char byContntOffset, un
  * Return Value: none
  *
  */
-void SROMvRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byBits)
+void SROMvRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits)
 {
 	unsigned char byOrgData;
 
@@ -193,7 +193,7 @@ void SROMvRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsign
  *      none
  *
  */
-void SROMvRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byBits)
+void SROMvRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits)
 {
 	unsigned char byOrgData;
 
@@ -215,7 +215,7 @@ void SROMvRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, unsig
  * Return Value: true if all test bits on; otherwise false
  *
  */
-bool SROMbIsRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
+bool SROMbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
 {
 	unsigned char byOrgData;
 
@@ -237,7 +237,7 @@ bool SROMbIsRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsi
  * Return Value: true if all test bits off; otherwise false
  *
  */
-bool SROMbIsRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
+bool SROMbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
 {
 	unsigned char byOrgData;
 
@@ -257,7 +257,7 @@ bool SROMbIsRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, uns
  * Return Value: none
  *
  */
-void SROMvReadAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs)
+void SROMvReadAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs)
 {
 	int     ii;
 
@@ -281,7 +281,7 @@ void SROMvReadAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs)
  * Return Value: none
  *
  */
-void SROMvWriteAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs)
+void SROMvWriteAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs)
 {
 	int     ii;
 
@@ -304,7 +304,7 @@ void SROMvWriteAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs)
  * Return Value: none
  *
  */
-void SROMvReadEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddress)
+void SROMvReadEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress)
 {
 	unsigned char ii;
 
@@ -328,7 +328,7 @@ void SROMvReadEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddres
  * Return Value: none
  *
  */
-void SROMvWriteEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddress)
+void SROMvWriteEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress)
 {
 	unsigned char ii;
 
@@ -351,7 +351,7 @@ void SROMvWriteEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddre
  * Return Value: none
  *
  */
-void SROMvReadSubSysVenId(unsigned long dwIoBase, unsigned long *pdwSubSysVenId)
+void SROMvReadSubSysVenId(void __iomem *dwIoBase, unsigned long *pdwSubSysVenId)
 {
 	unsigned char *pbyData;
 
@@ -376,7 +376,7 @@ void SROMvReadSubSysVenId(unsigned long dwIoBase, unsigned long *pdwSubSysVenId)
  * Return Value: true if success; otherwise false
  *
  */
-bool SROMbAutoLoad(unsigned long dwIoBase)
+bool SROMbAutoLoad(void __iomem *dwIoBase)
 {
 	unsigned char byWait;
 	int     ii;
diff --git a/drivers/staging/vt6655/srom.h b/drivers/staging/vt6655/srom.h
index 1df58c5..3128e53 100644
--- a/drivers/staging/vt6655/srom.h
+++ b/drivers/staging/vt6655/srom.h
@@ -133,23 +133,23 @@ typedef struct tagSSromReg {
 
 /*---------------------  Export Functions  --------------------------*/
 
-unsigned char SROMbyReadEmbedded(unsigned long dwIoBase, unsigned char byContntOffset);
-bool SROMbWriteEmbedded(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byData);
+unsigned char SROMbyReadEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset);
+bool SROMbWriteEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byData);
 
-void SROMvRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byBits);
-void SROMvRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byBits);
+void SROMvRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits);
+void SROMvRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits);
 
-bool SROMbIsRegBitsOn(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byTestBits);
-bool SROMbIsRegBitsOff(unsigned long dwIoBase, unsigned char byContntOffset, unsigned char byTestBits);
+bool SROMbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits);
+bool SROMbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits);
 
-void SROMvReadAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs);
-void SROMvWriteAllContents(unsigned long dwIoBase, unsigned char *pbyEepromRegs);
+void SROMvReadAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs);
+void SROMvWriteAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs);
 
-void SROMvReadEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddress);
-void SROMvWriteEtherAddress(unsigned long dwIoBase, unsigned char *pbyEtherAddress);
+void SROMvReadEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress);
+void SROMvWriteEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress);
 
-void SROMvReadSubSysVenId(unsigned long dwIoBase, unsigned long *pdwSubSysVenId);
+void SROMvReadSubSysVenId(void __iomem *dwIoBase, unsigned long *pdwSubSysVenId);
 
-bool SROMbAutoLoad(unsigned long dwIoBase);
+bool SROMbAutoLoad(void __iomem *dwIoBase);
 
 #endif // __EEPROM_H__
diff --git a/drivers/staging/vt6655/upc.h b/drivers/staging/vt6655/upc.h
index 155e664..af12a86 100644
--- a/drivers/staging/vt6655/upc.h
+++ b/drivers/staging/vt6655/upc.h
@@ -72,38 +72,32 @@ do {						\
 
 #define VNSvInPortB(dwIOAddress, pbyData)				\
 do {									\
-	volatile unsigned char *pbyAddr = (unsigned char *)(dwIOAddress); \
-	*(pbyData) = readb(pbyAddr);					\
+	*(pbyData) = readb(dwIOAddress);				\
 } while (0)
 
 #define VNSvInPortW(dwIOAddress, pwData)				\
 do {									\
-	volatile unsigned short *pwAddr = (unsigned short *)(dwIOAddress); \
-	*(pwData) = readw(pwAddr);					\
+	*(pwData) = readw(dwIOAddress);					\
 } while (0)
 
 #define VNSvInPortD(dwIOAddress, pdwData)				\
 do {									\
-	volatile unsigned long *pdwAddr = (unsigned long *)(dwIOAddress); \
-	*(pdwData) = readl(pdwAddr);					\
+	*(pdwData) = readl(dwIOAddress);				\
 } while (0)
 
 #define VNSvOutPortB(dwIOAddress, byData)				\
 do {									\
-	volatile unsigned char *pbyAddr = (unsigned char *)(dwIOAddress); \
-	writeb((unsigned char)byData, pbyAddr);				\
+	writeb((unsigned char)byData, dwIOAddress);			\
 } while (0)
 
 #define VNSvOutPortW(dwIOAddress, wData)				\
 do {									\
-	volatile unsigned short *pwAddr = ((unsigned short *)(dwIOAddress)); \
-	writew((unsigned short)wData, pwAddr);				\
+	writew((unsigned short)wData, dwIOAddress);			\
 } while (0)
 
 #define VNSvOutPortD(dwIOAddress, dwData)				\
 do {									\
-	volatile unsigned long *pdwAddr = (unsigned long *)(dwIOAddress); \
-	writel((unsigned long)dwData, pdwAddr);				\
+	writel((unsigned long)dwData, dwIOAddress);			\
 } while (0)
 
 #endif
-- 
1.8.5.5

