Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaLOKCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:02:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbaLOKB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:01:57 -0500
Message-ID: <1418637710.4443.11.camel@linux-0dmf.site>
Subject: Re: bluetooth: Add hci_h4p driver
From: Oliver Neukum <oneukum@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Date: Mon, 15 Dec 2014 11:01:50 +0100
In-Reply-To: <20141213223727.GA13894@amd>
References: <20141213223727.GA13894@amd>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a few remarks about possible issues.

	Regards
		Oliver

> +static int h4p_send_negotiation(struct h4p_info *info)
> +{
> +	struct h4p_neg_cmd *neg_cmd;
> +	struct h4p_neg_hdr *neg_hdr;
> +	struct sk_buff *skb;
> +	int err, len;
> +	u16 sysclk = 38400;
> +
> +	printk("Sending negotiation..");
> +	len = sizeof(*neg_cmd) + sizeof(*neg_hdr) + H4_TYPE_SIZE;
> +
> +	skb = bt_skb_alloc(len, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	memset(skb->data, 0x00, len);
> +	*skb_put(skb, 1) = H4_NEG_PKT;
> +	neg_hdr = (struct h4p_neg_hdr *)skb_put(skb, sizeof(*neg_hdr));
> +	neg_cmd = (struct h4p_neg_cmd *)skb_put(skb, sizeof(*neg_cmd));
> +
> +	neg_hdr->dlen = sizeof(*neg_cmd);
> +	neg_cmd->ack = H4P_NEG_REQ;
> +	neg_cmd->baud = cpu_to_le16(BT_BAUDRATE_DIVIDER/MAX_BAUD_RATE);
> +	neg_cmd->proto = H4P_PROTO_BYTE;
> +	neg_cmd->sys_clk = cpu_to_le16(sysclk);
> +
> +	h4p_change_speed(info, INIT_SPEED);
> +
> +	h4p_set_rts(info, 1);
> +	info->init_error = 0;
> +	init_completion(&info->init_completion);
> +
> +	h4p_simple_send_frame(info, skb);
> +
> +	if (!wait_for_completion_interruptible_timeout(&info->init_completion,
> +						       msecs_to_jiffies(1000))) {
> +		printk("h4p: negotiation did not return\n");

Memory leak in the error case

> +		return -ETIMEDOUT;
> +	}
> +
> +	if (info->init_error < 0)
> +		return info->init_error;
> +
> +	/* Change to operational settings */
> +	h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
> +	h4p_set_rts(info, 0);
> +	h4p_change_speed(info, MAX_BAUD_RATE);
> +
> +	err = h4p_wait_for_cts(info, 1, 100);
> +	if (err < 0)
> +		return err;
> +
> +	h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
> +	init_completion(&info->init_completion);
> +	err = h4p_send_alive_packet(info);
> +
> +	if (err < 0)
> +		return err;
> +
> +	if (!wait_for_completion_interruptible_timeout(&info->init_completion,
> +				msecs_to_jiffies(1000)))
> +		return -ETIMEDOUT;
> +
> +	if (info->init_error < 0)
> +		return info->init_error;
> +
> +	printk("Negotiation successful\n");
> +	return 0;
> +}



> +static unsigned int h4p_get_data_len(struct h4p_info *info,
> +					 struct sk_buff *skb)
> +{
> +	long retval = -1;
> +	struct hci_acl_hdr *acl_hdr;
> +	struct hci_sco_hdr *sco_hdr;
> +	struct hci_event_hdr *evt_hdr;
> +	struct h4p_neg_hdr *neg_hdr;
> +	struct h4p_alive_hdr *alive_hdr;
> +	struct h4p_radio_hdr *radio_hdr;
> +
> +	switch (bt_cb(skb)->pkt_type) {
> +	case H4_EVT_PKT:
> +		evt_hdr = (struct hci_event_hdr *)skb->data;
> +		retval = evt_hdr->plen;
> +		break;
> +	case H4_ACL_PKT:
> +		acl_hdr = (struct hci_acl_hdr *)skb->data;
> +		retval = le16_to_cpu(acl_hdr->dlen);

Could you explain, why only this needs endianness converted?

> +		break;
> +	case H4_SCO_PKT:
> +		sco_hdr = (struct hci_sco_hdr *)skb->data;
> +		retval = sco_hdr->dlen;
> +		break;
> +	case H4_RADIO_PKT:
> +		radio_hdr = (struct h4p_radio_hdr *)skb->data;
> +		retval = radio_hdr->dlen;
> +		break;
> +	case H4_NEG_PKT:
> +		neg_hdr = (struct h4p_neg_hdr *)skb->data;
> +		retval = neg_hdr->dlen;
> +		break;
> +	case H4_ALIVE_PKT:
> +		alive_hdr = (struct h4p_alive_hdr *)skb->data;
> +		retval = alive_hdr->dlen;
> +		break;
> +	}
> +
> +	return retval;
> +}



> +static void h4p_rx_tasklet(unsigned long data)
> +{
> +	u8 byte;
> +	struct h4p_info *info = (struct h4p_info *)data;
> +
> +	BT_DBG("tasklet woke up");
> +	BT_DBG("rx_tasklet woke up");

Isn't this a bit redundant?

> +
> +	while (h4p_inb(info, UART_LSR) & UART_LSR_DR) {
> +		byte = h4p_inb(info, UART_RX);
> +		BT_DBG("[in: %02x]", byte);
> +		if (info->garbage_bytes) {
> +			info->garbage_bytes--;
> +			continue;
> +		}
> +		if (info->rx_skb == NULL) {
> +			info->rx_skb = bt_skb_alloc(HCI_MAX_FRAME_SIZE,
> +						    GFP_ATOMIC | GFP_DMA);
> +			if (!info->rx_skb) {
> +				dev_err(info->dev,
> +					"No memory for new packet\n");
> +				goto finish_rx;
> +			}
> +			info->rx_state = WAIT_FOR_PKT_TYPE;
> +			info->rx_skb->dev = (void *)info->hdev;
> +		}
> +		info->hdev->stat.byte_rx++;
> +		h4p_handle_byte(info, byte);
> +	}
> +
> +	if (!info->rx_enabled) {
> +		if (h4p_inb(info, UART_LSR) & UART_LSR_TEMT &&
> +						  info->autorts) {
> +			__h4p_set_auto_ctsrts(info, 0 , UART_EFR_RTS);
> +			info->autorts = 0;
> +		}
> +		/* Flush posted write to avoid spurious interrupts */
> +		h4p_inb(info, UART_OMAP_SCR);
> +		h4p_set_clk(info, &info->rx_clocks_en, 0);
> +	}
> +
> +finish_rx:
> +	BT_DBG("rx_ended");
> +}
> +
> +static void h4p_tx_tasklet(unsigned long data)
> +{
> +	unsigned int sent = 0;
> +	struct sk_buff *skb;
> +	struct h4p_info *info = (struct h4p_info *)data;
> +
> +	BT_DBG("tasklet woke up");
> +	BT_DBG("tx_tasklet woke up");

Doubled?

> +	if (info->autorts != info->rx_enabled) {
> +		if (h4p_inb(info, UART_LSR) & UART_LSR_TEMT) {
> +			if (info->autorts && !info->rx_enabled) {
> +				__h4p_set_auto_ctsrts(info, 0,
> +							  UART_EFR_RTS);
> +				info->autorts = 0;
> +			}
> +			if (!info->autorts && info->rx_enabled) {
> +				__h4p_set_auto_ctsrts(info, 1,
> +							  UART_EFR_RTS);
> +				info->autorts = 1;
> +			}
> +		} else {
> +			h4p_outb(info, UART_OMAP_SCR,
> +				     h4p_inb(info, UART_OMAP_SCR) |
> +				     UART_OMAP_SCR_EMPTY_THR);
> +			goto finish_tx;
> +		}
> +	}
> +
> +	skb = skb_dequeue(&info->txq);
> +	if (!skb) {
> +		/* No data in buffer */
> +		BT_DBG("skb ready");
> +		if (h4p_inb(info, UART_LSR) & UART_LSR_TEMT) {
> +			h4p_outb(info, UART_IER,
> +				     h4p_inb(info, UART_IER) &
> +				     ~UART_IER_THRI);
> +			h4p_inb(info, UART_OMAP_SCR);
> +			h4p_disable_tx(info);
> +			return;
> +		}
> +		h4p_outb(info, UART_OMAP_SCR,
> +			     h4p_inb(info, UART_OMAP_SCR) |
> +			     UART_OMAP_SCR_EMPTY_THR);
> +		goto finish_tx;
> +	}
> +
> +	/* Copy data to tx fifo */
> +	while (!(h4p_inb(info, UART_OMAP_SSR) & UART_OMAP_SSR_TXFULL) &&
> +	       (sent < skb->len)) {
> +		//printk("[Out: %02x]", skb->data[sent]);
> +		//printk("%02x ", skb->data[sent]);
> +		h4p_outb(info, UART_TX, skb->data[sent]);
> +		sent++;
> +	}
> +
> +	info->hdev->stat.byte_tx += sent;
> +	if (skb->len == sent) {
> +		kfree_skb(skb);
> +	} else {
> +		skb_pull(skb, sent);
> +		skb_queue_head(&info->txq, skb);
> +	}
> +
> +	h4p_outb(info, UART_OMAP_SCR, h4p_inb(info, UART_OMAP_SCR) &
> +						     ~UART_OMAP_SCR_EMPTY_THR);
> +	h4p_outb(info, UART_IER, h4p_inb(info, UART_IER) |
> +						 UART_IER_THRI);
> +
> +finish_tx:
> +	/* Flush posted write to avoid spurious interrupts */
> +	h4p_inb(info, UART_OMAP_SCR);
> +
> +}



















