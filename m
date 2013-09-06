Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3IFQwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:52:01 -0400
Received: from mail-pd0-f193.google.com ([209.85.192.193]:39027 "EHLO
	mail-pd0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3IFQwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:52:00 -0400
From: Avinash Kumar <avi.kp.137@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devendra.aaru@gmail.com, gmate.amit@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Avinash Kumar <avi.kp.137@gmail.com>
Subject: [PATCH 3/3] staging: wlan-ng: hfa384x_usb.c: replaced printk() debugs with netdev_warn()/netdev_err()
Date: Fri,  6 Sep 2013 22:21:49 +0530
Message-Id: <1378486309-6283-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replaced the printk debug lines with respective netdev_warn()/netdev_err()

Signed-off-by: Avinash kumar <avi.kp.137@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   90 ++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index c1a8cb6..5b8b094 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -355,7 +355,7 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
 
 		/* Check whether we need to reset the RX pipe */
 		if (result == -EPIPE) {
-			printk(KERN_WARNING
+			netdev_warn(hw->wlandev->netdev,
 			       "%s rx pipe stalled: requesting reset\n",
 			       hw->wlandev->netdev->name);
 			if (!test_and_set_bit(WORK_RX_HALT, &hw->usb_flags))
@@ -405,7 +405,7 @@ static int submit_tx_urb(hfa384x_t *hw, struct urb *tx_urb, gfp_t memflags)
 
 			/* Test whether we need to reset the TX pipe */
 			if (result == -EPIPE) {
-				printk(KERN_WARNING
+				netdev_warn(hw->wlandev->netdev,
 				       "%s tx pipe stalled: requesting reset\n",
 				       netdev->name);
 				set_bit(WORK_TX_HALT, &hw->usb_flags);
@@ -454,11 +454,11 @@ static void hfa384x_usb_defer(struct work_struct *data)
 
 		ret = usb_clear_halt(hw->usb, hw->endp_in);
 		if (ret != 0) {
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 			       "Failed to clear rx pipe for %s: err=%d\n",
 			       netdev->name, ret);
 		} else {
-			printk(KERN_INFO "%s rx pipe reset complete.\n",
+			netdev_info(hw->wlandev->netdev, "%s rx pipe reset complete.\n",
 			       netdev->name);
 			clear_bit(WORK_RX_HALT, &hw->usb_flags);
 			set_bit(WORK_RX_RESUME, &hw->usb_flags);
@@ -471,7 +471,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
 
 		ret = submit_rx_urb(hw, GFP_KERNEL);
 		if (ret != 0) {
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 			       "Failed to resume %s rx pipe.\n", netdev->name);
 		} else {
 			clear_bit(WORK_RX_RESUME, &hw->usb_flags);
@@ -485,11 +485,11 @@ static void hfa384x_usb_defer(struct work_struct *data)
 		usb_kill_urb(&hw->tx_urb);
 		ret = usb_clear_halt(hw->usb, hw->endp_out);
 		if (ret != 0) {
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 			       "Failed to clear tx pipe for %s: err=%d\n",
 			       netdev->name, ret);
 		} else {
-			printk(KERN_INFO "%s tx pipe reset complete.\n",
+			netdev_info(hw->wlandev->netdev, "%s tx pipe reset complete.\n",
 			       netdev->name);
 			clear_bit(WORK_TX_HALT, &hw->usb_flags);
 			set_bit(WORK_TX_RESUME, &hw->usb_flags);
@@ -1211,7 +1211,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 
 	result = usb_reset_device(hw->usb);
 	if (result < 0) {
-		printk(KERN_ERR "usb_reset_device() failed, result=%d.\n",
+		netdev_err(hw->wlandev->netdev, "usb_reset_device() failed, result=%d.\n",
 		       result);
 	}
 
@@ -1311,7 +1311,7 @@ cleanup:
 		if (ctlx->state == CTLX_COMPLETE) {
 			result = completor->complete(completor);
 		} else {
-			printk(KERN_WARNING "CTLX[%d] error: state(%s)\n",
+			netdev_warn(hw->wlandev->netdev, "CTLX[%d] error: state(%s)\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state));
 			result = -EIO;
@@ -2018,7 +2018,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	if (hw->dlstate != HFA384x_DLSTATE_FLASHENABLED)
 		return -EINVAL;
 
-	printk(KERN_INFO "Download %d bytes to flash @0x%06x\n", len, daddr);
+	netdev_info(hw->wlandev->netdev, "Download %d bytes to flash @0x%06x\n", len, daddr);
 
 	/* Convert to flat address for arithmetic */
 	/* NOTE: dlbuffer RID stores the address in AUX format */
@@ -2028,7 +2028,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		 hw->bufinfo.page, hw->bufinfo.offset, dlbufaddr);
 
 #if 0
-	printk(KERN_WARNING "dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
+	netdev_warn(hw->wlandev->netdev, "dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
 	       hw->bufinfo.len, hw->dltimeout);
 #endif
 	/* Calculations to determine how many fills of the dlbuffer to do
@@ -2055,14 +2055,14 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		burnlo = HFA384x_ADDR_CMD_MKOFF(burndaddr);
 		burnhi = HFA384x_ADDR_CMD_MKPAGE(burndaddr);
 
-		printk(KERN_INFO "Writing %d bytes to flash @0x%06x\n",
+		netdev_info(hw->wlandev->netdev, "Writing %d bytes to flash @0x%06x\n",
 		       burnlen, burndaddr);
 
 		/* Set the download mode */
 		result = hfa384x_cmd_download(hw, HFA384x_PROGMODE_NV,
 					      burnlo, burnhi, burnlen);
 		if (result) {
-			printk(KERN_ERR "download(NV,lo=%x,hi=%x,len=%x) "
+			netdev_err(hw->wlandev->netdev, "download(NV,lo=%x,hi=%x,len=%x) "
 			       "cmd failed, result=%d. Aborting d/l\n",
 			       burnlo, burnhi, burnlen, result);
 			goto exit_proc;
@@ -2094,7 +2094,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 					      HFA384x_PROGMODE_NVWRITE,
 					      0, 0, 0);
 		if (result) {
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 			       "download(NVWRITE,lo=%x,hi=%x,len=%x) "
 			       "cmd failed, result=%d. Aborting d/l\n",
 			       burnlo, burnhi, burnlen, result);
@@ -2279,7 +2279,7 @@ int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr)
 	/* Check that a port isn't active */
 	for (i = 0; i < HFA384x_PORTID_MAX; i++) {
 		if (hw->port_enabled[i]) {
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 			       "Can't download with a macport enabled.\n");
 			return -EINVAL;
 		}
@@ -2287,7 +2287,7 @@ int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr)
 
 	/* Check that we're not already in a download state */
 	if (hw->dlstate != HFA384x_DLSTATE_DISABLED) {
-		printk(KERN_ERR "Download state not disabled.\n");
+		netdev_err(hw->wlandev->netdev, "Download state not disabled.\n");
 		return -EINVAL;
 	}
 
@@ -2352,7 +2352,7 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	if (hw->dlstate != HFA384x_DLSTATE_RAMENABLED)
 		return -EINVAL;
 
-	printk(KERN_INFO "Writing %d bytes to ram @0x%06x\n", len, daddr);
+	netdev_info(hw->wlandev->netdev, "Writing %d bytes to ram @0x%06x\n", len, daddr);
 
 	/* How many dowmem calls?  */
 	nwrites = len / HFA384x_USB_RWMEM_MAXLEN;
@@ -2449,7 +2449,7 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 						len);
 
 		if (result) {
-			printk(KERN_WARNING
+			netdev_warn(hw->wlandev->netdev,
 			       "Read from index %zd failed, continuing\n", i);
 			continue;
 		}
@@ -2462,13 +2462,13 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 			pdrcode = le16_to_cpu(pda[currpdr + 1]);
 			/* Test the record length */
 			if (pdrlen > HFA384x_PDR_LEN_MAX || pdrlen == 0) {
-				printk(KERN_ERR "pdrlen invalid=%d\n", pdrlen);
+				netdev_err(hw->wlandev->netdev, "pdrlen invalid=%d\n", pdrlen);
 				pdaok = 0;
 				break;
 			}
 			/* Test the code */
 			if (!hfa384x_isgood_pdrcode(pdrcode)) {
-				printk(KERN_ERR "pdrcode invalid=%d\n",
+				netdev_err(hw->wlandev->netdev, "pdrcode invalid=%d\n",
 				       pdrcode);
 				pdaok = 0;
 				break;
@@ -2484,7 +2484,7 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 			}
 		}
 		if (pdaok) {
-			printk(KERN_INFO
+			netdev_info(hw->wlandev->netdev,
 			       "PDA Read from 0x%08x in %s space.\n",
 			       pdaloc[i].cardaddr,
 			       pdaloc[i].auxctl == 0 ? "EXTDS" :
@@ -2564,20 +2564,20 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	result =
 	    usb_get_status(hw->usb, USB_RECIP_ENDPOINT, hw->endp_in, &status);
 	if (result < 0) {
-		printk(KERN_ERR "Cannot get bulk in endpoint status.\n");
+		netdev_err(hw->wlandev->netdev, "Cannot get bulk in endpoint status.\n");
 		goto done;
 	}
 	if ((status == 1) && usb_clear_halt(hw->usb, hw->endp_in))
-		printk(KERN_ERR "Failed to reset bulk in endpoint.\n");
+		netdev_err(hw->wlandev->netdev, "Failed to reset bulk in endpoint.\n");
 
 	result =
 	    usb_get_status(hw->usb, USB_RECIP_ENDPOINT, hw->endp_out, &status);
 	if (result < 0) {
-		printk(KERN_ERR "Cannot get bulk out endpoint status.\n");
+		netdev_err(hw->wlandev->netdev, "Cannot get bulk out endpoint status.\n");
 		goto done;
 	}
 	if ((status == 1) && usb_clear_halt(hw->usb, hw->endp_out))
-		printk(KERN_ERR "Failed to reset bulk out endpoint.\n");
+		netdev_err(hw->wlandev->netdev, "Failed to reset bulk out endpoint.\n");
 
 	/* Synchronous unlink, in case we're trying to restart the driver */
 	usb_kill_urb(&hw->rx_urb);
@@ -2585,7 +2585,7 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	/* Post the IN urb */
 	result = submit_rx_urb(hw, GFP_KERNEL);
 	if (result != 0) {
-		printk(KERN_ERR
+		netdev_err(hw->wlandev->netdev,
 		       "Fatal, failed to submit RX URB, result=%d\n", result);
 		goto done;
 	}
@@ -2605,7 +2605,7 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	result = result2 = hfa384x_cmd_initialize(hw);
 	if (result1 != 0) {
 		if (result2 != 0) {
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 				"cmd_initialize() failed on two attempts, results %d and %d\n",
 				result1, result2);
 			usb_kill_urb(&hw->rx_urb);
@@ -2616,9 +2616,9 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 			pr_debug("but second attempt succeeded. All should be ok\n");
 		}
 	} else if (result2 != 0) {
-		printk(KERN_WARNING "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
+		netdev_warn(hw->wlandev->netdev, "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
 			result2);
-		printk(KERN_WARNING
+		netdev_warn(hw->wlandev->netdev,
 		       "Most likely the card will be functional\n");
 		goto done;
 	}
@@ -2709,7 +2709,7 @@ int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
 	char *ptr;
 
 	if (hw->tx_urb.status == -EINPROGRESS) {
-		printk(KERN_WARNING "TX URB already in use\n");
+		netdev_warn(hw->wlandev->netdev, "TX URB already in use\n");
 		result = 3;
 		goto exit;
 	}
@@ -2784,7 +2784,7 @@ int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
 	result = 1;
 	ret = submit_tx_urb(hw, &hw->tx_urb, GFP_ATOMIC);
 	if (ret != 0) {
-		printk(KERN_ERR "submit_tx_urb() failed, error=%d\n", ret);
+		netdev_err(hw->wlandev->netdev, "submit_tx_urb() failed, error=%d\n", ret);
 		result = 3;
 	}
 
@@ -3009,7 +3009,7 @@ static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx)
 		break;
 
 	default:
-		printk(KERN_ERR "CTLX[%d] not in a terminating state(%s)\n",
+		netdev_err(hw->wlandev->netdev, "CTLX[%d] not in a terminating state(%s)\n",
 		       le16_to_cpu(ctlx->outbuf.type), ctlxstr(ctlx->state));
 		break;
 	}			/* switch */
@@ -3091,7 +3091,7 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 			 * this CTLX back in the "pending" queue
 			 * and schedule a reset ...
 			 */
-			printk(KERN_WARNING
+			netdev_warn(hw->wlandev->netdev,
 			       "%s tx pipe stalled: requesting reset\n",
 			       hw->wlandev->netdev->name);
 			list_move(&head->list, &hw->ctlxq.pending);
@@ -3101,12 +3101,12 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 		}
 
 		if (result == -ESHUTDOWN) {
-			printk(KERN_WARNING "%s urb shutdown!\n",
+			netdev_warn(hw->wlandev->netdev, "%s urb shutdown!\n",
 			       hw->wlandev->netdev->name);
 			break;
 		}
 
-		printk(KERN_ERR "Failed to submit CTLX[%d]: error=%d\n",
+		netdev_err(hw->wlandev->netdev, "Failed to submit CTLX[%d]: error=%d\n",
 		       le16_to_cpu(head->outbuf.type), result);
 		unlocked_usbctlx_complete(hw, head);
 	}			/* while */
@@ -3173,7 +3173,7 @@ static void hfa384x_usbin_callback(struct urb *urb)
 		break;
 
 	case -EPIPE:
-		printk(KERN_WARNING "%s rx pipe stalled: requesting reset\n",
+		netdev_warn(hw->wlandev->netdev, "%s rx pipe stalled: requesting reset\n",
 		       wlandev->netdev->name);
 		if (!test_and_set_bit(WORK_RX_HALT, &hw->usb_flags))
 			schedule_work(&hw->usb_work);
@@ -3224,7 +3224,7 @@ static void hfa384x_usbin_callback(struct urb *urb)
 		result = submit_rx_urb(hw, GFP_ATOMIC);
 
 		if (result != 0) {
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 			       "Fatal, failed to resubmit rx_urb. error=%d\n",
 			       result);
 		}
@@ -3360,7 +3360,7 @@ retry:
 		 * Check that our message is what we're expecting ...
 		 */
 		if (ctlx->outbuf.type != intype) {
-			printk(KERN_WARNING
+			netdev_warn(hw->wlandev->netdev,
 			       "Expected IN[%d], received IN[%d] - ignored.\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       le16_to_cpu(intype));
@@ -3396,7 +3396,7 @@ retry:
 			/*
 			 * Throw this CTLX away ...
 			 */
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 			       "Matched IN URB, CTLX[%d] in invalid state(%s)."
 			       " Discarded.\n",
 			       le16_to_cpu(ctlx->outbuf.type),
@@ -3534,7 +3534,7 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 		break;
 
 	default:
-		printk(KERN_WARNING "Received frame on unsupported port=%d\n",
+		netdev_warn(hw->wlandev->netdev, "Received frame on unsupported port=%d\n",
 		       HFA384x_RXSTATUS_MACPORT_GET(usbin->rxfrm.desc.status));
 		goto done;
 		break;
@@ -3596,7 +3596,7 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 
 	skb = dev_alloc_skb(skblen);
 	if (skb == NULL) {
-		printk(KERN_ERR
+		netdev_err(hw->wlandev->netdev,
 		       "alloc_skb failed trying to allocate %d bytes\n",
 		       skblen);
 		return;
@@ -3714,7 +3714,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 		case -EPIPE:
 			{
 				hfa384x_t *hw = wlandev->priv;
-				printk(KERN_WARNING
+				netdev_warn(hw->wlandev->netdev,
 				       "%s tx pipe stalled: requesting reset\n",
 				       wlandev->netdev->name);
 				if (!test_and_set_bit
@@ -3747,7 +3747,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 			break;
 
 		default:
-			printk(KERN_INFO "unknown urb->status=%d\n",
+			netdev_info(wlandev->netdev, "unknown urb->status=%d\n",
 			       urb->status);
 			++(wlandev->linux_stats.tx_errors);
 			break;
@@ -3841,7 +3841,7 @@ retry:
 
 		default:
 			/* This is NOT a valid CTLX "success" state! */
-			printk(KERN_ERR
+			netdev_err(hw->wlandev->netdev,
 				"Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
 				le16_to_cpu(ctlx->outbuf.type),
 				ctlxstr(ctlx->state), urb->status);
@@ -3851,7 +3851,7 @@ retry:
 		/* If the pipe has stalled then we need to reset it */
 		if ((urb->status == -EPIPE) &&
 		    !test_and_set_bit(WORK_TX_HALT, &hw->usb_flags)) {
-			printk(KERN_WARNING
+			netdev_warn(hw->wlandev->netdev,
 			       "%s tx pipe stalled: requesting reset\n",
 			       hw->wlandev->netdev->name);
 			schedule_work(&hw->usb_work);
-- 
1.7.10.4

