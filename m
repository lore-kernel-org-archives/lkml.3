Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3AQXI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:08:59 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:34255 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445Ab3AQXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:08:57 -0500
From: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
To: linux-kernel@i4.informatik.uni-erlangen.de, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Subject: [PATCH 3/3] wlan-ng/prism2mgmt.c Replace printk(...) with netdev_warn, netdev_err
Date: Fri, 18 Jan 2013 00:07:32 +0100
Message-Id: <1358464052-14002-4-git-send-email-qi50dube@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
References: <20130117205834.GA659@kroah.com>
 <1358464052-14002-1-git-send-email-qi50dube@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Wankerl <sisewank@cip.cs.fau.de>

We are uncertain if the netdev_struct is properly initialized in each function
call. Please be sure to really review this patch.

Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>

---
 drivers/staging/wlan-ng/prism2mgmt.c |  125 +++++++++++++++++++---------------
 1 file changed, 69 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
index 8404754..d44d9f3 100644
--- a/drivers/staging/wlan-ng/prism2mgmt.c
+++ b/drivers/staging/wlan-ng/prism2mgmt.c
@@ -129,8 +129,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 				     hw->ident_sta_fw.minor,
 				     hw->ident_sta_fw.variant) <
 	    HFA384x_FIRMWARE_VERSION(1, 3, 2)) {
-		printk(KERN_ERR
-		       "HostScan not supported with current firmware (<1.3.2).\n");
+		netdev_err(wlandev->netdev,
+			   "HostScan not supported with current firmware (<1.3.2).\n");
 		result = 1;
 		msg->resultcode.data = P80211ENUM_resultcode_not_supported;
 		goto exit;
@@ -143,8 +143,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 					  HFA384x_RID_CNFROAMINGMODE,
 					  &roamingmode);
 	if (result) {
-		printk(KERN_ERR "getconfig(ROAMMODE) failed. result=%d\n",
-		       result);
+		netdev_err(wlandev->netdev,
+			   "getconfig(ROAMMODE) failed. result=%d\n", result);
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		goto exit;
@@ -155,8 +155,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 					  HFA384x_RID_CNFROAMINGMODE,
 					  HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM);
 	if (result) {
-		printk(KERN_ERR "setconfig(ROAMINGMODE) failed. result=%d\n",
-		       result);
+		netdev_err(wlandev->netdev,
+			   "setconfig(ROAMINGMODE) failed. result=%d\n", result);
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		goto exit;
@@ -176,8 +176,9 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 		    hfa384x_drvr_setconfig16(hw, HFA384x_RID_CNFPASSIVESCANCTRL,
 					     word);
 		if (result) {
-			printk(KERN_WARNING "Passive scan not supported with "
-			       "current firmware.  (<1.5.1)\n");
+			netdev_warn(wlandev->netdev,
+				    "Passive scan not supported with current "
+				    "firmware.  (<1.5.1)\n");
 		}
 	}
 
@@ -203,8 +204,9 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 	/* Enable the MAC port if it's not already enabled  */
 	result = hfa384x_drvr_getconfig16(hw, HFA384x_RID_PORTSTATUS, &word);
 	if (result) {
-		printk(KERN_ERR "getconfig(PORTSTATUS) failed. "
-		       "result=%d\n", result);
+		netdev_err(wlandev->netdev,
+			   "getconfig(PORTSTATUS) failed. result=%d\n",
+			   result);
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		goto exit;
@@ -216,9 +218,9 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 					HFA384x_RID_CNFROAMINGMODE,
 					HFA384x_ROAMMODE_HOSTSCAN_HOSTROAM);
 		if (result) {
-			printk(KERN_ERR
-			       "setconfig(ROAMINGMODE) failed. result=%d\n",
-			       result);
+			netdev_err(wlandev->netdev,
+				   "setconfig(ROAMINGMODE) failed. result=%d\n",
+				   result);
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
@@ -232,7 +234,7 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 						wordbuf,
 						HFA384x_RID_CNFOWNSSID_LEN);
 		if (result) {
-			printk(KERN_ERR "Failed to set OwnSSID.\n");
+			netdev_err(wlandev->netdev, "Failed to set OwnSSID.\n");
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
@@ -241,7 +243,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 						wordbuf,
 						HFA384x_RID_CNFDESIREDSSID_LEN);
 		if (result) {
-			printk(KERN_ERR "Failed to set DesiredSSID.\n");
+			netdev_err(wlandev->netdev,
+				   "Failed to set DesiredSSID.\n");
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
@@ -251,7 +254,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 						  HFA384x_RID_CNFPORTTYPE,
 						  HFA384x_PORTTYPE_IBSS);
 		if (result) {
-			printk(KERN_ERR "Failed to set CNFPORTTYPE.\n");
+			netdev_err(wlandev->netdev,
+				   "Failed to set CNFPORTTYPE.\n");
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
@@ -261,15 +265,17 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 					HFA384x_RID_CREATEIBSS,
 					HFA384x_CREATEIBSS_JOINCREATEIBSS);
 		if (result) {
-			printk(KERN_ERR "Failed to set CREATEIBSS.\n");
+			netdev_err(wlandev->netdev,
+				   "Failed to set CREATEIBSS.\n");
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
 		}
 		result = hfa384x_drvr_enable(hw, 0);
 		if (result) {
-			printk(KERN_ERR "drvr_enable(0) failed. "
-			       "result=%d\n", result);
+			netdev_err(wlandev->netdev,
+				   "drvr_enable(0) failed. result=%d\n",
+				   result);
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
@@ -288,8 +294,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 					HFA384x_RID_HOSTSCAN, &scanreq,
 					sizeof(hfa384x_HostScanRequest_data_t));
 	if (result) {
-		printk(KERN_ERR "setconfig(SCANREQUEST) failed. result=%d\n",
-		       result);
+		netdev_err(wlandev->netdev,
+			   "setconfig(SCANREQUEST) failed. result=%d\n", result);
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		goto exit;
@@ -310,8 +316,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 	if (istmpenable) {
 		result = hfa384x_drvr_disable(hw, 0);
 		if (result) {
-			printk(KERN_ERR "drvr_disable(0) failed. "
-			       "result=%d\n", result);
+			netdev_err(wlandev->netdev,
+				   "drvr_disable(0) failed. result=%d\n", result);
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			goto exit;
@@ -322,8 +328,8 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
 	result = hfa384x_drvr_setconfig16(hw, HFA384x_RID_CNFROAMINGMODE,
 					  roamingmode);
 	if (result) {
-		printk(KERN_ERR "setconfig(ROAMMODE) failed. result=%d\n",
-		       result);
+		netdev_err(wlandev->netdev,
+			   "setconfig(ROAMMODE) failed. result=%d\n", result);
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		goto exit;
@@ -372,8 +378,8 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
 	req->resultcode.status = P80211ENUM_msgitem_status_data_ok;
 
 	if (!hw->scanresults) {
-		printk(KERN_ERR
-		       "dot11req_scan_results can only be used after a successful dot11req_scan.\n");
+		netdev_err(wlandev->netdev,
+			   "dot11req_scan_results can only be used after a successful dot11req_scan.\n");
 		result = 2;
 		req->resultcode.data = P80211ENUM_resultcode_invalid_parameters;
 		goto exit;
@@ -555,14 +561,14 @@ int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 	result = hfa384x_drvr_setconfig(hw, HFA384x_RID_CNFOWNSSID,
 					bytebuf, HFA384x_RID_CNFOWNSSID_LEN);
 	if (result) {
-		printk(KERN_ERR "Failed to set CnfOwnSSID\n");
+		netdev_err(wlandev->netdev, "Failed to set CnfOwnSSID\n");
 		goto failed;
 	}
 	result = hfa384x_drvr_setconfig(hw, HFA384x_RID_CNFDESIREDSSID,
 					bytebuf,
 					HFA384x_RID_CNFDESIREDSSID_LEN);
 	if (result) {
-		printk(KERN_ERR "Failed to set CnfDesiredSSID\n");
+		netdev_err(wlandev->netdev, "Failed to set CnfDesiredSSID\n");
 		goto failed;
 	}
 
@@ -574,7 +580,8 @@ int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 	word = msg->beaconperiod.data;
 	result = hfa384x_drvr_setconfig16(hw, HFA384x_RID_CNFAPBCNint, word);
 	if (result) {
-		printk(KERN_ERR "Failed to set beacon period=%d.\n", word);
+		netdev_err(wlandev->netdev, "Failed to set beacon period=%d.\n",
+			   word);
 		goto failed;
 	}
 
@@ -582,7 +589,8 @@ int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 	word = msg->dschannel.data;
 	result = hfa384x_drvr_setconfig16(hw, HFA384x_RID_CNFOWNCHANNEL, word);
 	if (result) {
-		printk(KERN_ERR "Failed to set channel=%d.\n", word);
+		netdev_err(wlandev->netdev, "Failed to set channel=%d.\n",
+			   word);
 		goto failed;
 	}
 	/* Basic rates */
@@ -610,7 +618,8 @@ int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 
 	result = hfa384x_drvr_setconfig16(hw, HFA384x_RID_CNFBASICRATES, word);
 	if (result) {
-		printk(KERN_ERR "Failed to set basicrates=%d.\n", word);
+		netdev_err(wlandev->netdev, "Failed to set basicrates=%d.\n",
+			   word);
 		goto failed;
 	}
 
@@ -639,13 +648,15 @@ int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 
 	result = hfa384x_drvr_setconfig16(hw, HFA384x_RID_CNFSUPPRATES, word);
 	if (result) {
-		printk(KERN_ERR "Failed to set supprates=%d.\n", word);
+		netdev_err(wlandev->netdev, "Failed to set supprates=%d.\n",
+			   word);
 		goto failed;
 	}
 
 	result = hfa384x_drvr_setconfig16(hw, HFA384x_RID_TXRATECNTL, word);
 	if (result) {
-		printk(KERN_ERR "Failed to set txrates=%d.\n", word);
+		netdev_err(wlandev->netdev, "Failed to set txrates=%d.\n",
+			   word);
 		goto failed;
 	}
 
@@ -659,7 +670,8 @@ int prism2mgmt_start(wlandevice_t *wlandev, void *msgp)
 	/* Enable the Port */
 	result = hfa384x_drvr_enable(hw, 0);
 	if (result) {
-		printk(KERN_ERR "Enable macport failed, result=%d.\n", result);
+		netdev_err(wlandev->netdev,
+			   "Enable macport failed, result=%d.\n", result);
 		goto failed;
 	}
 
@@ -704,8 +716,8 @@ int prism2mgmt_readpda(wlandevice_t *wlandev, void *msgp)
 	 * state.
 	 */
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
-		printk(KERN_ERR
-		       "PDA may only be read " "in the fwload state.\n");
+		netdev_err(wlandev->netdev,
+			   "PDA may only be read in the fwload state.\n");
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
@@ -717,9 +729,9 @@ int prism2mgmt_readpda(wlandevice_t *wlandev, void *msgp)
 					      msg->pda.data,
 					      HFA384x_PDA_LEN_MAX);
 		if (result) {
-			printk(KERN_ERR
-			       "hfa384x_drvr_readpda() failed, "
-			       "result=%d\n", result);
+			netdev_err(wlandev->netdev,
+				   "hfa384x_drvr_readpda() failed, "
+				   "result=%d\n", result);
 
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
@@ -766,9 +778,9 @@ int prism2mgmt_ramdl_state(wlandevice_t *wlandev, void *msgp)
 	struct p80211msg_p2req_ramdl_state *msg = msgp;
 
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
-		printk(KERN_ERR
-		       "ramdl_state(): may only be called "
-		       "in the fwload state.\n");
+		netdev_err(wlandev->netdev,
+			   "ramdl_state(): may only be called "
+			   "in the fwload state.\n");
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
@@ -825,9 +837,9 @@ int prism2mgmt_ramdl_write(wlandevice_t *wlandev, void *msgp)
 	u8 *buf;
 
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
-		printk(KERN_ERR
-		       "ramdl_write(): may only be called "
-		       "in the fwload state.\n");
+		netdev_err(wlandev->netdev,
+			   "ramdl_write(): may only be called "
+			   "in the fwload state.\n");
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
@@ -885,9 +897,9 @@ int prism2mgmt_flashdl_state(wlandevice_t *wlandev, void *msgp)
 	struct p80211msg_p2req_flashdl_state *msg = msgp;
 
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
-		printk(KERN_ERR
-		       "flashdl_state(): may only be called "
-		       "in the fwload state.\n");
+		netdev_err(wlandev->netdev,
+			   "flashdl_state(): may only be called "
+			   "in the fwload state.\n");
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
@@ -920,8 +932,9 @@ int prism2mgmt_flashdl_state(wlandevice_t *wlandev, void *msgp)
 		wlandev->msdstate = WLAN_MSD_HWPRESENT;
 		result = prism2sta_ifstate(wlandev, P80211ENUM_ifstate_fwload);
 		if (result != P80211ENUM_resultcode_success) {
-			printk(KERN_ERR "prism2sta_ifstate(fwload) failed,"
-			       "P80211ENUM_resultcode=%d\n", result);
+			netdev_err(wlandev->netdev,
+				   "prism2sta_ifstate(fwload) failed,"
+				   "P80211ENUM_resultcode=%d\n", result);
 			msg->resultcode.data =
 			    P80211ENUM_resultcode_implementation_failure;
 			result = -1;
@@ -958,9 +971,9 @@ int prism2mgmt_flashdl_write(wlandevice_t *wlandev, void *msgp)
 	u8 *buf;
 
 	if (wlandev->msdstate != WLAN_MSD_FWLOAD) {
-		printk(KERN_ERR
-		       "flashdl_write(): may only be called "
-		       "in the fwload state.\n");
+		netdev_err(wlandev->netdev,
+			   "flashdl_write(): may only be called "
+			   "in the fwload state.\n");
 		msg->resultcode.data =
 		    P80211ENUM_resultcode_implementation_failure;
 		msg->resultcode.status = P80211ENUM_msgitem_status_data_ok;
@@ -1154,7 +1167,7 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 
 		}
 
-		printk(KERN_INFO "monitor mode disabled\n");
+		netdev_info(wlandev->netdev, "monitor mode disabled\n");
 		msg->resultcode.data = P80211ENUM_resultcode_success;
 		result = 0;
 		goto exit;
@@ -1285,7 +1298,7 @@ int prism2mgmt_wlansniff(wlandevice_t *wlandev, void *msgp)
 		}
 
 		if (wlandev->netdev->type == ARPHRD_ETHER)
-			printk(KERN_INFO "monitor mode enabled\n");
+			netdev_info(wlandev->netdev, "monitor mode enabled\n");
 
 		/* Set the driver state */
 		/* Do we want the prism2 header? */
-- 
1.7.10.4

