Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbaLJNP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:15:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39437 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbaLJNPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:15:25 -0500
Date: Wed, 10 Dec 2014 14:15:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, sre@debian.org,
        Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, tony@atomide.com,
        khilman@kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<ivo.g.dimitrov.75@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
Message-ID: <20141210131519.GA14748@amd>
References: <20141209190210.GA15641@amd>
 <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
 <20141209201328.GA18003@amd>
 <7EFD3C33-E503-4FB6-BCCF-52836080ABD6@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7EFD3C33-E503-4FB6-BCCF-52836080ABD6@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The TODO file says:
> > 
> > # > +
> > # > +     skb_queue_tail(&info->txq, fw_skb);
> > # > +     spin_lock_irqsave(&info->lock, flags);
> > # > +     hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
> > # > +                     UART_IER_THRI);
> > # > +     spin_unlock_irqrestore(&info->lock, flags);
> > # > +}
> > # 
> > # and as I explained before, this crazy can not continue. Bluetooth drivers can provide a
> > # +hdev->setup callback for loading firmware and doing other setup details. You can just
> > # +bring up the HCI transport. We are providing __hci_cmd_sync for easy loading of the
> > # +firmware. Especially if the firmware just consists of HCI commands. Which is clearly the
> > # +case with the Nokia firmware files.
> > 
> > ...so I take it you (and thus TODO) were wrong and __hci_cmd_sync is
> > not suitable after all?
> 
> __hci_cmd_sync is to be used in hdev->setup where you load the firmware. However when hdev->setup is run, we expect that the HCI transport is fully up and running and that the driver takes care of the transport. That is done via hdev->send and hci_recv_frame.
>

h4p changes uart speed again after load of the firmware, but I guess
that's ok.

> > But I don't understand what you want me to do at this point. I guess
> > skb_queue_tail+hci_h4p_outb should be moved to a helper function
> > (that's easy), and I already moved initialization to hci_setup().
> > 
> > nokia_core.c uses test_bit(HCI_RUNNING, &info->hdev->flags) to tell
> > between initialization and data traffic, but I guess that's fine?
> 
> I have no idea on how much more I can explain this. There should be code in the driver that handles the HCI transport. That means init of the transport and sending and receiving HCI frames. And then there is the piece to load the firmware etc. These are two independent things.
>

Ok, it looks like __hci_cmd_sync() is indeed good match for the
firmware load.

> 
> What needs to be done is the bring up of the device including the proper UART settings and speed and then just run the firmware downloads. All firmware files on the Nokia devices where just HCI commands with vendor specific details. Some from CSR, some from Broadcom and some from TI. You can actually decode them if you really want to. Shouldn't be that hard.
>

Speed changes at the end of firmware load, but I guess that's detail?
Anyway, patch would look like this.

diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 9ece2c8..5cdb86a 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -475,12 +475,6 @@ static inline void hci_h4p_recv_frame(struct hci_h4p_info *info,
 			info->rx_state = WAIT_FOR_PKT_TYPE;
 			return;
 		}
-
-		if (!test_bit(HCI_UP, &info->hdev->flags)) {
-			BT_DBG("fw_event");
-			hci_h4p_parse_fw_event(info, skb);
-			return;
-		}
 	}
 
 	hci_recv_frame(info->hdev, skb);
diff --git a/drivers/staging/nokia_h4p/nokia_fw-bcm.c b/drivers/staging/nokia_h4p/nokia_fw-bcm.c
index 8066b21..89718d4 100644
--- a/drivers/staging/nokia_h4p/nokia_fw-bcm.c
+++ b/drivers/staging/nokia_h4p/nokia_fw-bcm.c
@@ -45,84 +45,17 @@ static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info,
 	return 0;
 }
 
-void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
-{
-	struct sk_buff *fw_skb;
-	int err;
-	unsigned long flags;
-
-	if (skb->data[5] != 0x00) {
-		dev_err(info->dev, "Firmware sending command failed 0x%.2x\n",
-			skb->data[5]);
-		info->fw_error = -EPROTO;
-	}
-
-	kfree_skb(skb);
-
-	fw_skb = skb_dequeue(info->fw_q);
-	if (fw_skb == NULL || info->fw_error) {
-		complete(&info->fw_completion);
-		return;
-	}
-
-	if (fw_skb->data[1] == 0x01 && fw_skb->data[2] == 0xfc &&
-			fw_skb->len >= 10) {
-		BT_DBG("Setting bluetooth address");
-		err = hci_h4p_bcm_set_bdaddr(info, fw_skb);
-		if (err < 0) {
-			kfree_skb(fw_skb);
-			info->fw_error = err;
-			complete(&info->fw_completion);
-			return;
-		}
-	}
-
-	hci_h4p_simple_send_frame(info, fw_skb);
-}
-
-
 int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
 			struct sk_buff_head *fw_queue)
 {
-	struct sk_buff *skb;
-	unsigned long flags, time;
+	unsigned long time;
 
 	info->fw_error = 0;
 
-	BT_DBG("Sending firmware");
+	printk("Sending firmware (not really)\n");
 
 	time = jiffies;
-
-	info->fw_q = fw_queue;
-	skb = skb_dequeue(fw_queue);
-	if (!skb)
-		return -ENODATA;
-
-	BT_DBG("Sending commands");
-
-	/*
-	 * Disable smart-idle as UART TX interrupts
-	 * are not wake-up capable
-	 */
-	hci_h4p_smart_idle(info, 0);
-
-	/* Check if this is bd_address packet */
-	init_completion(&info->fw_completion);
-
-	hci_h4p_simple_send_frame(info, skb);
-
-	if (!wait_for_completion_timeout(&info->fw_completion,
-				msecs_to_jiffies(2000))) {
-		dev_err(info->dev, "No reply to fw command\n");
-		return -ETIMEDOUT;
-	}
-
-	if (info->fw_error) {
-		dev_err(info->dev, "FW error\n");
-		return -EPROTO;
-	}
-
-	BT_DBG("Firmware sent in %d msecs",
+	printk("Firmware sent in %d msec\n",
 		   jiffies_to_msecs(jiffies-time));
 
 	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
diff --git a/drivers/staging/nokia_h4p/nokia_fw.c b/drivers/staging/nokia_h4p/nokia_fw.c
index b5748c8..be5f619 100644
--- a/drivers/staging/nokia_h4p/nokia_fw.c
+++ b/drivers/staging/nokia_h4p/nokia_fw.c
@@ -76,6 +72,7 @@ static int hci_h4p_read_fw_cmd(struct hci_h4p_info *info, struct sk_buff **skb,
 			       const struct firmware *fw_entry, gfp_t how)
 {
 	unsigned int cmd_len;
+	static int num = 0;
 
 	if (fw_pos >= fw_entry->size)
 		return 0;
@@ -95,16 +92,24 @@ static int hci_h4p_read_fw_cmd(struct hci_h4p_info *info, struct sk_buff **skb,
 		return -EMSGSIZE;
 	}
 
-	*skb = bt_skb_alloc(cmd_len, how);
-	if (!*skb) {
-		dev_err(info->dev, "Cannot reserve memory for buffer\n");
-		return -ENOMEM;
+	/* Note that this is timing-critical. If sending packets takes too
+	   long, initialization will fail. */
+	printk("Packet %d...", num);
+	if (num > 1) {
+		int cmd = fw_entry->data[fw_pos+1] + (fw_entry->data[fw_pos+2] << 8);
+		int len = fw_entry->data[fw_pos+3];
+		printk("cmd %x, len %d.", cmd, len);
+		*skb = __hci_cmd_sync(info->hdev, cmd, len, fw_entry->data+fw_pos+4, 500);
+		if (IS_ERR(*skb)) {
+			printk("...sending cmd failed %d\n", PTR_ERR(*skb));
+			return -EIO;
+		}
 	}
-	memcpy(skb_put(*skb, cmd_len), &fw_entry->data[fw_pos], cmd_len);
+	num++;
 
 	fw_pos += cmd_len;
 
-	return (*skb)->len;
+	return 1;
 }
 
 int hci_h4p_read_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue)
@@ -113,31 +118,22 @@ int hci_h4p_read_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue)
 	struct sk_buff *skb = NULL;
 	int err;
 
+	/*
+	 * Disable smart-idle as UART TX interrupts
+	 * are not wake-up capable
+	 */
+	hci_h4p_smart_idle(info, 0);
+	
 	err = hci_h4p_open_firmware(info, &fw_entry);
 	if (err < 0 || !fw_entry)
 		goto err_clean;
 
+	printk("read firmware\n");
+	/* FIXME: remove skb... */
 	while ((err = hci_h4p_read_fw_cmd(info, &skb, fw_entry, GFP_KERNEL))) {
-		if (err < 0 || !skb)
-			goto err_clean;
-
-		skb_queue_tail(fw_queue, skb);
 	}
 
-	/* Chip detection code does neg and alive stuff
-	 * discard two first skbs */
-	skb = skb_dequeue(fw_queue);
-	if (!skb) {
-		err = -EMSGSIZE;
-		goto err_clean;
-	}
-	kfree_skb(skb);
-	skb = skb_dequeue(fw_queue);
-	if (!skb) {
-		err = -EMSGSIZE;
-		goto err_clean;
-	}
-	kfree_skb(skb);
+	printk("done read firmware\n");
 
 err_clean:
 	hci_h4p_close_firmware(fw_entry);
@@ -160,20 +156,4 @@ int hci_h4p_send_fw(struct hci_h4p_info *info, struct sk_buff_head *fw_queue)
 	return err;
 }
 
-void hci_h4p_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
-{
-	switch (info->man_id) {
-	case H4P_ID_BCM2048:
-		hci_h4p_bcm_parse_fw_event(info, skb);
-		break;
-	default:
-		dev_err(info->dev, "Don't know how to parse fw event\n");
-		info->fw_error = -EINVAL;
-	}
-}
-
-MODULE_FIRMWARE(FW_NAME_TI1271_PRELE);
-MODULE_FIRMWARE(FW_NAME_TI1271_LE);
-MODULE_FIRMWARE(FW_NAME_TI1271);
 MODULE_FIRMWARE(FW_NAME_BCM2048);
-MODULE_FIRMWARE(FW_NAME_CSR);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
