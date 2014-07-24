Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbaGXXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:09:58 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36032 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801AbaGXXHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:07 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 07/14] staging: vt6655: Use pr_* functions instead of printk
Date: Fri, 25 Jul 2014 01:06:21 +0200
Message-Id: <1406243188-13413-8-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of printk are used in vt6655, replace them with the pr_*
equivalent.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/card.c        | 12 +++---
 drivers/staging/vt6655/device_cfg.h  |  2 +-
 drivers/staging/vt6655/device_main.c | 71 ++++++++++++++++++------------------
 drivers/staging/vt6655/ioctl.c       |  8 ++--
 drivers/staging/vt6655/iwctl.c       | 16 ++++----
 drivers/staging/vt6655/vntwifi.c     |  2 +-
 drivers/staging/vt6655/wcmd.c        | 11 +++---
 drivers/staging/vt6655/wmgr.c        |  9 +++--
 drivers/staging/vt6655/wpactl.c      |  4 +-
 9 files changed, 69 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index ac49fba..58d707f 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -910,7 +910,7 @@ bool CARDbRadioPowerOff(void *pDeviceHandler)
 
 	pDevice->bRadioOff = true;
 	//2007-0409-03,<Add> by chester
-	printk("chester power off\n");
+	pr_debug("chester power off\n");
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_GPIOCTL0, LED_ACTSET);  //LED issue
 	return bResult;
 }
@@ -932,14 +932,14 @@ bool CARDbRadioPowerOn(void *pDeviceHandler)
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	bool bResult = true;
 
-	printk("chester power on\n");
+	pr_debug("chester power on\n");
 	if (pDevice->bRadioControlOff == true) {
-		if (pDevice->bHWRadioOff == true) printk("chester bHWRadioOff\n");
-		if (pDevice->bRadioControlOff == true) printk("chester bRadioControlOff\n");
+		if (pDevice->bHWRadioOff == true) pr_debug("chester bHWRadioOff\n");
+		if (pDevice->bRadioControlOff == true) pr_debug("chester bRadioControlOff\n");
 		return false; }
 
 	if (pDevice->bRadioOff == false) {
-		printk("chester pbRadioOff\n");
+		pr_debug("chester pbRadioOff\n");
 		return true; }
 
 	BBvExitDeepSleep(pDevice->PortOffset, pDevice->byLocalID);
@@ -963,7 +963,7 @@ bool CARDbRadioPowerOn(void *pDeviceHandler)
 
 	pDevice->bRadioOff = false;
 //  2007-0409-03,<Add> by chester
-	printk("chester power on\n");
+	pr_debug("chester power on\n");
 	MACvRegBitsOff(pDevice->PortOffset, MAC_REG_GPIOCTL0, LED_ACTSET); //LED issue
 	return bResult;
 }
diff --git a/drivers/staging/vt6655/device_cfg.h b/drivers/staging/vt6655/device_cfg.h
index 1137ade..af28924 100644
--- a/drivers/staging/vt6655/device_cfg.h
+++ b/drivers/staging/vt6655/device_cfg.h
@@ -81,7 +81,7 @@ typedef enum  _chip_type {
 #define ASSERT(x)							\
 do {									\
 	if (!(x)) {							\
-		printk(KERN_ERR "assertion %s failed: file %s line %d\n", \
+		pr_err("assertion %s failed: file %s line %d\n", \
 		       #x, __func__, __LINE__);				\
 		*(int *)0 = 0;						\
 	}								\
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 8c035d5..c3cae50 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -579,12 +579,12 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 
 			else {
 				if (zonetype != pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
-					printk("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n", zonetype, pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
+					pr_debug("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n", zonetype, pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
 				else
-					printk("Read Zonetype file success,use default zonetype setting[%02x]\n", zonetype);
+					pr_debug("Read Zonetype file success,use default zonetype setting[%02x]\n", zonetype);
 			}
 		} else
-			printk("Read Zonetype file fail,use default zonetype setting[%02x]\n", SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ZONETYPE));
+			pr_debug("Read Zonetype file fail,use default zonetype setting[%02x]\n", SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ZONETYPE));
 
 		// Get RFType
 		pDevice->byRFType = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_RFTYPE);
@@ -809,8 +809,9 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	PCHIP_INFO  pChip_info = (PCHIP_INFO)ent->driver_data;
 	PSDevice    pDevice;
 	int         rc;
+
 	if (device_nics++ >= MAX_UINTS) {
-		printk(KERN_NOTICE DEVICE_NAME ": already found %d NICs\n", device_nics);
+		pr_notice(DEVICE_NAME ": already found %d NICs\n", device_nics);
 		return -ENODEV;
 	}
 
@@ -819,7 +820,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	pDevice = (PSDevice) netdev_priv(dev);
 
 	if (dev == NULL) {
-		printk(KERN_ERR DEVICE_NAME ": allocate net device failed\n");
+		pr_err(DEVICE_NAME ": allocate net device failed\n");
 		return -ENOMEM;
 	}
 
@@ -827,8 +828,8 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	SET_NETDEV_DEV(dev, &pcid->dev);
 
 	if (bFirst) {
-		printk(KERN_NOTICE "%s Ver. %s\n", DEVICE_FULL_DRV_NAM, DEVICE_VERSION);
-		printk(KERN_NOTICE "Copyright (c) 2003 VIA Networking Technologies, Inc.\n");
+		pr_notice("%s Ver. %s\n", DEVICE_FULL_DRV_NAM, DEVICE_VERSION);
+		pr_notice("Copyright (c) 2003 VIA Networking Technologies, Inc.\n");
 		bFirst = false;
 	}
 
@@ -844,10 +845,10 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	dev->irq = pcid->irq;
 
 #ifdef	DEBUG
-	printk("Before get pci_info memaddr is %x\n", pDevice->memaddr);
+	pr_debug("Before get pci_info memaddr is %x\n", pDevice->memaddr);
 #endif
 	if (!device_get_pci_info(pDevice, pcid)) {
-		printk(KERN_ERR DEVICE_NAME ": Failed to find PCI device.\n");
+		pr_err(DEVICE_NAME ": Failed to find PCI device.\n");
 		device_free_info(pDevice);
 		return -ENODEV;
 	}
@@ -856,7 +857,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 #ifdef	DEBUG
 
-	printk("after get pci_info memaddr is %x, io addr is %x,io_size is %d\n", pDevice->memaddr, pDevice->ioaddr, pDevice->io_size);
+	pr_debug("after get pci_info memaddr is %x, io addr is %x,io_size is %d\n", pDevice->memaddr, pDevice->ioaddr, pDevice->io_size);
 	{
 		int i;
 		u32 bar, len;
@@ -870,9 +871,9 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 			0};
 		for (i = 0; address[i]; i++) {
 			pci_read_config_dword(pcid, address[i], &bar);
-			printk("bar %d is %x\n", i, bar);
+			pr_debug("bar %d is %x\n", i, bar);
 			if (!bar) {
-				printk("bar %d not implemented\n", i);
+				pr_debug("bar %d not implemented\n", i);
 				continue;
 			}
 			if (bar & PCI_BASE_ADDRESS_SPACE_IO) {
@@ -881,12 +882,12 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 				len = bar & (PCI_BASE_ADDRESS_IO_MASK & 0xFFFF);
 				len = len & ~(len - 1);
 
-				printk("IO space:  len in IO %x, BAR %d\n", len, i);
+				pr_debug("IO space:  len in IO %x, BAR %d\n", len, i);
 			} else {
 				len = bar & 0xFFFFFFF0;
 				len = ~len + 1;
 
-				printk("len in MEM %x, BAR %d\n", len, i);
+				pr_debug("len in MEM %x, BAR %d\n", len, i);
 			}
 		}
 	}
@@ -897,14 +898,14 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	pDevice->PortOffset = ioremap(pDevice->memaddr & PCI_BASE_ADDRESS_MEM_MASK, pDevice->io_size);
 
 	if (pDevice->PortOffset == NULL) {
-		printk(KERN_ERR DEVICE_NAME ": Failed to IO remapping ..\n");
+		pr_err(DEVICE_NAME ": Failed to IO remapping ..\n");
 		device_free_info(pDevice);
 		return -ENODEV;
 	}
 
 	rc = pci_request_regions(pcid, DEVICE_NAME);
 	if (rc) {
-		printk(KERN_ERR DEVICE_NAME ": Failed to find PCI device\n");
+		pr_err(DEVICE_NAME ": Failed to find PCI device\n");
 		device_free_info(pDevice);
 		return -ENODEV;
 	}
@@ -914,10 +915,10 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	unsigned char value;
 
 	VNSvInPortB(pDevice->PortOffset+0x4F, &value);
-	printk("Before write: value is %x\n", value);
+	pr_debug("Before write: value is %x\n", value);
 	VNSvOutPortB(pDevice->PortOffset, value);
 	VNSvInPortB(pDevice->PortOffset+0x4F, &value);
-	printk("After write: value is %x\n", value);
+	pr_debug("After write: value is %x\n", value);
 #endif
 
 #ifdef IO_MAP
@@ -925,7 +926,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 #endif
 	// do reset
 	if (!MACbSoftwareReset(pDevice->PortOffset)) {
-		printk(KERN_ERR DEVICE_NAME ": Failed to access MAC hardware..\n");
+		pr_err(DEVICE_NAME ": Failed to access MAC hardware..\n");
 		device_free_info(pDevice);
 		return -ENODEV;
 	}
@@ -951,7 +952,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 	rc = register_netdev(dev);
 	if (rc) {
-		printk(KERN_ERR DEVICE_NAME " Failed to register netdev\n");
+		pr_err(DEVICE_NAME " Failed to register netdev\n");
 		device_free_info(pDevice);
 		return -ENODEV;
 	}
@@ -1038,10 +1039,10 @@ static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid)
 	}
 	for (ii = 0, j = 1; ii < 0x100; ii++, j++) {
 		if (j % 16 == 0) {
-			printk("%x:", pci_config[ii]);
-			printk("\n");
+			pr_debug("%x:", pci_config[ii]);
+			pr_debug("\n");
 		} else {
-			printk("%x:", pci_config[ii]);
+			pr_debug("%x:", pci_config[ii]);
 		}
 	}
 #endif
@@ -1060,7 +1061,7 @@ static void device_free_info(PSDevice pDevice)
 //2008-07-21-01<Add>by MikeLiu
 //unregister wpadev
 	if (wpa_set_wpadev(pDevice, 0) != 0)
-		printk("unregister wpadev fail?\n");
+		pr_err("unregister wpadev fail?\n");
 
 	if (pDevice_Infos == NULL)
 		return;
@@ -1694,7 +1695,7 @@ static int  device_open(struct net_device *dev)
 	mlme_kill = 0;
 	mlme_task = kthread_run(MlmeThread, (void *)pDevice, "MLME");
 	if (IS_ERR(mlme_task)) {
-		printk("thread create fail\n");
+		pr_err("thread create fail\n");
 		return -1;
 	}
 
@@ -2146,7 +2147,7 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (pDevice->bFixRate) {
 #ifdef	PLICE_DEBUG
-		printk("Fix Rate: PhyType is %d,ConnectionRate is %d\n", pDevice->eCurrentPHYType, pDevice->uConnectionRate);
+		pr_debug("Fix Rate: PhyType is %d,ConnectionRate is %d\n", pDevice->eCurrentPHYType, pDevice->uConnectionRate);
 #endif
 
 		if (pDevice->eCurrentPHYType == PHY_TYPE_11B) {
@@ -2284,7 +2285,7 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev)
 	pDevice->apCurrTD[TYPE_AC0DMA] = pHeadTD;
 
 	if (pDevice->bFixRate)
-		printk("FixRate:Rate is %d,TxPower is %d\n", pDevice->wCurrentRate, pDevice->byCurPwr);
+		pr_debug("FixRate:Rate is %d,TxPower is %d\n", pDevice->wCurrentRate, pDevice->byCurPwr);
 
 	{
 		unsigned char Protocol_Version;    //802.1x Authentication
@@ -2306,10 +2307,10 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev)
 					    (Key_info & BIT8) && (Key_info & BIT9)) {    //send 2/2 key
 						pDevice->fWPA_Authened = true;
 						if (Descriptor_type == 254)
-							printk("WPA ");
+							pr_debug("WPA ");
 						else
-							printk("WPA2 ");
-						printk("Authentication completed!!\n");
+							pr_debug("WPA2 ");
+						pr_debug("Authentication completed!!\n");
 					}
 				}
 			}
@@ -2625,24 +2626,24 @@ int Config_FileOperation(PSDevice pDevice,bool fwrite,unsigned char *Parameter)
 	int result=0;
 
 	if (!buffer) {
-		printk("allocate mem for file fail?\n");
+		pr_err("allocate mem for file fail?\n");
 		return -1;
 	}
 	file = filp_open(CONFIG_PATH, O_RDONLY, 0);
 	if (IS_ERR(file)) {
 		kfree(buffer);
-		printk("Config_FileOperation:open file fail?\n");
+		pr_err("Config_FileOperation:open file fail?\n");
 		return -1;
 	}
 
 	if (kernel_read(file, 0, buffer, 1024) < 0) {
-		printk("read file error?\n");
+		pr_err("read file error?\n");
 		result = -1;
 		goto error1;
 	}
 
 	if (Config_FileGetParameter("ZONETYPE",tmpbuffer,buffer)!=true) {
-		printk("get parameter error?\n");
+		pr_err("get parameter error?\n");
 		result = -1;
 		goto error1;
 	}
@@ -2655,7 +2656,7 @@ int Config_FileOperation(PSDevice pDevice,bool fwrite,unsigned char *Parameter)
 		result = ZoneType_Europe;
 	} else {
 		result = -1;
-		printk("Unknown Zonetype[%s]?\n",tmpbuffer);
+		pr_err("Unknown Zonetype[%s]?\n", tmpbuffer);
 	}
 
 error1:
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index 18d11d1..65e5933 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -123,13 +123,13 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			/* write zonetype */
 			if (sZoneTypeCmd.ZoneType == ZoneType_USA) {
 				/* set to USA */
-				printk("set_ZoneType:USA\n");
+				pr_debug("set_ZoneType:USA\n");
 			} else if (sZoneTypeCmd.ZoneType == ZoneType_Japan) {
 				/* set to Japan */
-				printk("set_ZoneType:Japan\n");
+				pr_debug("set_ZoneType:Japan\n");
 			} else if (sZoneTypeCmd.ZoneType == ZoneType_Europe) {
 				/* set to Europe */
-				printk("set_ZoneType:Europe\n");
+				pr_debug("set_ZoneType:Europe\n");
 			}
 		} else {
 			/* read zonetype */
@@ -142,7 +142,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			} else if (zonetype == 0x02) {	/* Europe */
 				sZoneTypeCmd.ZoneType = ZoneType_Europe;
 			} else {			/* Unknown ZoneType */
-				printk("Error:ZoneType[%x] Unknown ???\n", zonetype);
+				pr_err("Error:ZoneType[%x] Unknown ???\n", zonetype);
 				result = -EFAULT;
 				break;
 			}
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 06ddb85..501cd64 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -643,7 +643,7 @@ int iwctl_siwap(struct net_device *dev,
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWAP\n");
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
-		printk("SIOCSIWAP(??)-->In scanning...\n");
+		pr_debug("SIOCSIWAP(??)-->In scanning..\n");
 	}
 	if (wrq->sa_family != ARPHRD_ETHER)
 		rc = -EINVAL;
@@ -804,7 +804,7 @@ int iwctl_siwessid(struct net_device *dev,
 	pDevice->fWPA_Authened = false;
 	if (pMgmt->eScanState ==  WMAC_IS_SCANNING) {
 		// In scanning..
-		printk("SIOCSIWESSID(??)-->In scanning...\n");
+		pr_debug("SIOCSIWESSID(??)-->In scanning..\n");
 	}
 	// Check if we asked for `any'
 	if (wrq->flags == 0) {
@@ -827,7 +827,7 @@ int iwctl_siwessid(struct net_device *dev,
 				pItemSSID->len = wrq->length - 1;
 		} else
 			pItemSSID->len = wrq->length;
-		printk("set essid to %s\n", pItemSSID->abySSID);
+		pr_debug("set essid to %s\n", pItemSSID->abySSID);
 		//2008-0409-05, <Add> by Einsn Liu
 		len = (pItemSSID->len > ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len) ? pItemSSID->len : ((PWLAN_IE_SSID)pMgmt->abyCurrSSID)->len;
 		if ((pDevice->bLinkPass == true) &&
@@ -873,7 +873,7 @@ int iwctl_siwessid(struct net_device *dev,
 						}
 					}
 					if (uSameBssidNum >= 2) {  //hit: desired AP is in hidden ssid mode!!!
-						printk("SIOCSIWESSID:hidden ssid directly associate.......\n");
+						pr_debug("SIOCSIWESSID:hidden ssid directly associate.......\n");
 						vResetCommandTimer((void *)pDevice);
 						pMgmt->eScanType = WMAC_SCAN_PASSIVE;          //this scan type,you'll submit scan result!
 						bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, pMgmt->abyDesireSSID);
@@ -987,7 +987,7 @@ int iwctl_siwrate(struct net_device *dev,
 	if (wrq->fixed != 0) {
 		// Fixed mode
 		// One rate, fixed
-		printk("Rate Fix\n");
+		pr_debug("Rate Fix\n");
 		pDevice->bFixRate = true;
 		if ((pDevice->byBBType == BB_TYPE_11B) && (brate > 3)) {
 			pDevice->uConnectionRate = 3;
@@ -999,7 +999,7 @@ int iwctl_siwrate(struct net_device *dev,
 	} else {
 		pDevice->bFixRate = false;
 		pDevice->uConnectionRate = 13;
-		printk("auto rate:connection_rate is 13\n");
+		pr_debug("auto rate:connection_rate is 13\n");
 	}
 
 	return rc;
@@ -1775,7 +1775,7 @@ int iwctl_siwencodeext(struct net_device *dev,
 
 	}
 	if (pDevice->bwextcount == 4) {
-		printk("SIOCSIWENCODEEXT:Enable WPA WEXT SUPPORT!!!!!\n");
+		pr_debug("SIOCSIWENCODEEXT:Enable WPA WEXT SUPPORT!!!!!\n");
 		pDevice->bwextcount = 0;
 		pDevice->bWPASuppWextEnabled = true;
 	}
@@ -1819,7 +1819,7 @@ int iwctl_siwmlme(struct net_device *dev,
 		break;
 	case IW_MLME_DISASSOC:
 		if (pDevice->bLinkPass == true) {
-			printk("iwctl_siwmlme--->send DISASSOCIATE\n");
+			pr_debug("iwctl_siwmlme--->send DISASSOCIATE\n");
 			//clear related flags
 			memset(pMgmt->abyDesireBSSID, 0xFF, 6);
 			KeyvInitTable(&pDevice->sKey, pDevice->PortOffset);
diff --git a/drivers/staging/vt6655/vntwifi.c b/drivers/staging/vt6655/vntwifi.c
index 0ee1e8a..160707d 100644
--- a/drivers/staging/vt6655/vntwifi.c
+++ b/drivers/staging/vt6655/vntwifi.c
@@ -544,7 +544,7 @@ VNTWIFIvGetTxRate(
 
 		wTxDataRate = (pMgmt->sNodeDBTable[0].wTxDataRate);
 #ifdef	PLICE_DEBUG
-		printk(KERN_DEBUG "GetTxRate:AP MAC is %pM,TxRate is %d\n",
+		pr_debug("GetTxRate:AP MAC is %pM,TxRate is %d\n",
 		       pMgmt->sNodeDBTable[0].abyMACAddr, wTxDataRate);
 #endif
 
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 049bdab..0c38fcf 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -492,7 +492,7 @@ vCommandTimer(
 			spin_unlock_irq(&pDevice->lock);
 			return;
 		}
-		printk("chester-abyDesireSSID=%s\n", ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySSID);
+		pr_debug("chester-abyDesireSSID=%s\n", ((PWLAN_IE_SSID)pMgmt->abyDesireSSID)->abySSID);
 		pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
 		pItemSSIDCurr = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " cmd: desire ssid = %s\n", pItemSSID->abySSID);
@@ -583,9 +583,10 @@ vCommandTimer(
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 				{
 					union iwreq_data  wrqu;
+
 					memset(&wrqu, 0, sizeof(wrqu));
 					wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-					printk("wireless_send_event--->SIOCGIWAP(disassociated:vMgrJoinBSSBegin Fail !!)\n");
+					pr_debug("wireless_send_event--->SIOCGIWAP(disassociated:vMgrJoinBSSBegin Fail !!)\n");
 					wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 				}
 #endif
@@ -613,10 +614,10 @@ vCommandTimer(
 		}
 
 		else if (pMgmt->eCurrState < WMAC_STATE_AUTHPENDING) {
-			printk("WLAN_AUTHENTICATE_WAIT:Authen Fail???\n");
+			pr_debug("WLAN_AUTHENTICATE_WAIT:Authen Fail???\n");
 		} else if (pDevice->byLinkWaitCount <= 4) {    //mike add:wait another 2 sec if authenticated_frame delay!
 			pDevice->byLinkWaitCount++;
-			printk("WLAN_AUTHENTICATE_WAIT:wait %d times!!\n", pDevice->byLinkWaitCount);
+			pr_debug("WLAN_AUTHENTICATE_WAIT:wait %d times!!\n", pDevice->byLinkWaitCount);
 			spin_unlock_irq(&pDevice->lock);
 			vCommandTimerWait((void *)pDevice, AUTHENTICATE_TIMEOUT/2);
 			return;
@@ -663,7 +664,7 @@ vCommandTimer(
 			printk("WLAN_ASSOCIATE_WAIT:Association Fail???\n");
 		} else if (pDevice->byLinkWaitCount <= 4) {    //mike add:wait another 2 sec if associated_frame delay!
 			pDevice->byLinkWaitCount++;
-			printk("WLAN_ASSOCIATE_WAIT:wait %d times!!\n", pDevice->byLinkWaitCount);
+			pr_debug("WLAN_ASSOCIATE_WAIT:wait %d times!!\n", pDevice->byLinkWaitCount);
 			spin_unlock_irq(&pDevice->lock);
 			vCommandTimerWait((void *)pDevice, ASSOCIATE_TIMEOUT/2);
 			return;
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index c02b59d..57373c9 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -698,7 +698,7 @@ s_vMgrRxAssocRequest(
 		pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate =
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
 #ifdef	PLICE_DEBUG
-		printk("RxAssocRequest:wTxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
+		pr_debug("RxAssocRequest:wTxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
 #endif
 		// Todo: check sta preamble, if ap can't support, set status code
 		pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble =
@@ -846,7 +846,7 @@ s_vMgrRxReAssocRequest(
 		pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate =
 			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
 #ifdef	PLICE_DEBUG
-		printk("RxReAssocRequest:TxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
+		pr_debug("RxReAssocRequest:TxDataRate is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate);
 #endif
 		// Todo: check sta preamble, if ap can't support, set status code
 		pMgmt->sNodeDBTable[uNodeIndex].bShortPreamble =
@@ -1570,9 +1570,10 @@ s_vMgrRxDisassociation(
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 		{
 			union iwreq_data  wrqu;
+
 			memset(&wrqu, 0, sizeof(wrqu));
 			wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-			printk("wireless_send_event--->SIOCGIWAP(disassociated)\n");
+			pr_debug("wireless_send_event--->SIOCGIWAP(disassociated)\n");
 			wireless_send_event(pDevice->dev, SIOCGIWAP, &wrqu, NULL);
 		}
 #endif
@@ -2109,7 +2110,7 @@ s_vMgrRxBeacon(
 				pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate = pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate;
 #ifdef	PLICE_DEBUG
 				{
-					printk("s_vMgrRxBeacon:TxDataRate is %d,Index is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate, uNodeIndex);
+					pr_debug("s_vMgrRxBeacon:TxDataRate is %d,Index is %d\n", pMgmt->sNodeDBTable[uNodeIndex].wTxDataRate, uNodeIndex);
 				}
 #endif
 			}
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index fe45f2b..5f454ca 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -557,7 +557,7 @@ static int wpa_get_scan(PSDevice pDevice,
 	ptempBSS = kmalloc(sizeof(KnownBSS), GFP_ATOMIC);
 
 	if (ptempBSS == NULL) {
-		printk(KERN_ERR "bubble sort kmalloc memory fail@@@\n");
+		pr_err("bubble sort kmalloc memory fail@@@\n");
 
 		ret = -ENOMEM;
 
@@ -775,7 +775,7 @@ static int wpa_set_associate(PSDevice pDevice,
 );
 
 		if (pCurr == NULL) {
-			printk("wpa_set_associate---->hidden mode site survey before associate.......\n");
+			pr_debug("wpa_set_associate---->hidden mode site survey before associate.......\n");
 			bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, pMgmt->abyDesireSSID);
 		}
 	}
-- 
1.8.5.5

