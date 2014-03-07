Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaCGIkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:40:03 -0500
Received: from optimeas.de ([78.46.18.2]:34227 "EHLO optimeas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaCGIkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:40:00 -0500
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2014 03:40:00 EST
From: "Matthias Klein" <matthias.klein@optimeas.de>
To: "Stanislav Meduna" <stano@meduna.org>, wg@grandegger.com,
        mkl@pengutronix.de, linux-can@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: FlexCAN on i.MX28 interrupt flooding retrying send
Date: Fri, 07 Mar 2014 08:32:57 +0000
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; format=flowed; charset=utf-8
In-Reply-To: <53197E8A.5050409@meduna.org>
Message-Id: <emb03a570d-a7ce-4ae7-b026-29c159b98a36@nb-mak>
Mime-Version: 1.0
Reply-To: "Matthias Klein" <matthias.klein@optimeas.de>
User-Agent: eM_Client/5.0.19406.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stanislav,

I made a similar observation on an i.MX537 with the 3.12.12-rt19 kernel: 
I see the same interrupt flooed when the bus is disconnected.

What do you mean with "kills the machine"? I have a high interrupt load, 
but the machine is still responsive.


Best regards,

Matthias


------ Originalnachricht ------
Von: "Stanislav Meduna" <stano@meduna.org>
An: wg@grandegger.com; mkl@pengutronix.de; linux-can@vger.kernel.org; 
"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; 
"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Gesendet: 07.03.2014 09:08:42
Betreff: FlexCAN on i.MX28 interrupt flooding retrying send
>Hi,
>
>I am using a FlexCAN CAN controller on a Freescale i.MX28 platform [1].
>If a packet is being sent when the bus is disconnected, I am getting
>an interrupt flooed that basically kills the machine.
>
>This is _not_ the same problem as [2] - my kernel already has
>the fix.
>
>The first interrupt comes with ESR 0x00028652, i.e.
>
>TXWRN_INT
>BIT1_ERR
>STF_ERR
>TX_WRN
>TXRX
>FLT_CONF error passive
>ERR_INT
>
>The next ones come the same without the acked TXWRN_INT.
>Reading the ESR again immediately after acking gives
>0x00000250, i.e.
>
>TX_WRN
>TXRX
>FLT_CONF error passive
>
>so everything ackable has actually been acked.
>
>I think that the problem is that the FlexCAN tries to retransmit
>the frame indefinitely. Each retry senses the bus in the invalid
>state (BIT1_ERR) and immediately fires a new ERR_INT. To verify
>this I aborted the transmitted frame in the error state in the
>interrupt handler
>
>#define FLEXCAN_ESR_ERR_TRANSMIT \
>  (FLEXCAN_ESR_BIT1_ERR | FLEXCAN_ESR_BIT0_ERR | FLEXCAN_ESR_ACK_ERR)
>
>if (reg_esr & FLEXCAN_ESR_ERR_TRANSMIT) {
>
>  /* In case of a transmission error the packet is retried and
>   * if the error persists, we will get another interrupt right
>   * away. Abort the transmission - a lost packet is better than
>   * an irq storm.
>   */
>  if(printk_ratelimit())
>   netdev_err(dev, "Aborted transmission, ESR %08x\n", reg_esr);
>
>  can_get_echo_skb(dev, 0);
>  flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
>   &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
>  netif_wake_queue(dev);
>}
>
>and the problem disappeared as expected. However, the correct
>way is probably to retry during some reasonable (configurable?)
>time interval.
>
>What puzzles me is that I did not found any other instance
>of this problem in the relevant mailing lists, only the original [2].
>
>I am using the 3.4.77 kernel with the realtime patches, but the
>code in the latest mainline looks the same in this respect.
>Maybe the realtime patches change some bevaviour, but I don't
>think they affect the core problem. I am not really an expert
>in the network devices, NAPI etc - maybe in that case the error
>interrupt should be disabled and re-enabled only if the
>error condition goes away? - I don't know...
>
>Please Cc: me when answering to the list.
>
>[1] 
>http://www.tq-group.com/en/products/product-details/prod/embedded-modul-tqma28/extb/Main/productdetail/
>[2] https://gitorious.org/linux-can/wg-linux-can-next/commit/8ad94fa
>
>Thanks
>--
>                                            Stano
>--
>To unsubscribe from this list: send the line "unsubscribe 
>linux-rt-users" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at http://vger.kernel.org/majordomo-info.html
>

