Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaLITCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:02:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60563 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaLITCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:02:13 -0500
Date: Tue, 9 Dec 2014 20:02:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: __hci_cmd_sync() not suitable for nokia h4p
Message-ID: <20141209190210.GA15641@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Major problem with Nokia H4P driver was, that it uses custom functions
instead of __hci_cmd_sync().

To recap, code was something like this: (You can see ifdefs with old
code and my new replacements).

....
	len = sizeof(*neg_cmd) + sizeof(*neg_hdr) + H4_TYPE_SIZE;
#undef OLD 
#ifdef OLD
	skb = bt_skb_alloc(len, GFP_KERNEL);
	if (!skb)
		return -ENOMEM;

	memset(skb->data, 0x00, len);
	*skb_put(skb, 1) = H4_NEG_PKT;
	neg_hdr = (struct hci_h4p_neg_hdr *)skb_put(skb, sizeof(*neg_hdr));
	neg_cmd = (struct hci_h4p_neg_cmd *)skb_put(skb, sizeof(*neg_cmd));
	neg_hdr->dlen = sizeof(*neg_cmd);
#else      
	struct {
		struct hci_h4p_neg_cmd neg_cmd;
	} data;

	memset(&data, 0, len-1);
	neg_cmd = &data.neg_cmd;
#endif

	neg_cmd->ack = H4P_NEG_REQ;
	neg_cmd->baud = cpu_to_le16(BT_BAUDRATE_DIVIDER/MAX_BAUD_RATE);
	neg_cmd->proto = H4P_PROTO_BYTE;
	neg_cmd->sys_clk = cpu_to_le16(sysclk);

	hci_h4p_change_speed(info, INIT_SPEED);

	printk("Setting up packet\n");
	hci_h4p_set_rts(info, 1);
	info->init_error = 0;
	init_completion(&info->init_completion);
	printk("skb_queue_tail\n");

#ifdef OLD
	skb_queue_tail(&info->txq, skb);

	spin_lock_irqsave(&info->lock, flags);
	hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
		     UART_IER_THRI);
	spin_unlock_irqrestore(&info->lock, flags);
#else
	printk("hci_cmd_sync\n");
//	set_bit(HCI_RUNNING, &info->hdev->flags);

	info->initing = 2;
	
	skb = __hci_cmd_sync(info->hdev, H4_NEG_PKT << 8, sizeof(*neg_cmd), ((void *) &data), 20);

...but there's problem with __hci_cmd_sync(): the packet it produces
is one byte too long; for initialization, I can work around that with
<< 8, so the added zero is at the begining (and device will be still
initialized), but that is a) an extreme hack, b) only works for first
packet and c) means that __hci_cmd_sync() will not recognize the
reply, meaning it does not really help.

Are there different variants of the protocol I should switch to? Any
ideas? Should I forget about __hci_cmd_sync()?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
