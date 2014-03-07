Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaCGItc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:49:32 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:57564 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaCGItb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:49:31 -0500
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2014 03:49:31 EST
Message-ID: <53198609.3010605@grandegger.com>
Date: Fri, 07 Mar 2014 09:40:41 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>, linux-can@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
CC: Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: FlexCAN on i.MX28 interrupt flooding retrying send
References: <53197E8A.5050409@meduna.org> <5319806A.6050809@pengutronix.de>
In-Reply-To: <5319806A.6050809@pengutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 09:16 AM, Marc Kleine-Budde wrote:
> Adding the linux-can mailinglist to Cc.
> 
> Marc
> 
> On 03/07/2014 09:08 AM, Stanislav Meduna wrote:
>> Hi,
>>
>> I am using a FlexCAN CAN controller on a Freescale i.MX28 platform [1].
>> If a packet is being sent when the bus is disconnected, I am getting
>> an interrupt flooed that basically kills the machine.
>>
>> This is _not_ the same problem as [2] - my kernel already has
>> the fix.
>>
>> The first interrupt comes with ESR 0x00028652, i.e.
>>
>> TXWRN_INT
>> BIT1_ERR
>> STF_ERR
>> TX_WRN
>> TXRX
>> FLT_CONF error passive
>> ERR_INT
>>
>> The next ones come the same without the acked TXWRN_INT.
>> Reading the ESR again immediately after acking gives
>> 0x00000250, i.e.
>>
>> TX_WRN
>> TXRX
>> FLT_CONF error passive
>>
>> so everything ackable has actually been acked.
>>
>> I think that the problem is that the FlexCAN tries to retransmit
>> the frame indefinitely. Each retry senses the bus in the invalid
>> state (BIT1_ERR) and immediately fires a new ERR_INT. To verify
>> this I aborted the transmitted frame in the error state in the
>> interrupt handler
>>
>> #define FLEXCAN_ESR_ERR_TRANSMIT \
>> 	(FLEXCAN_ESR_BIT1_ERR | FLEXCAN_ESR_BIT0_ERR | FLEXCAN_ESR_ACK_ERR)
>>
>> if (reg_esr & FLEXCAN_ESR_ERR_TRANSMIT) {
>>
>> 	/* In case of a transmission error the packet is retried and
>> 	 * if the error persists, we will get another interrupt right
>> 	 * away. Abort the transmission - a lost packet is better than
>> 	 * an irq storm.
>> 	 */
>> 	if(printk_ratelimit())
>> 		netdev_err(dev, "Aborted transmission, ESR %08x\n", reg_esr);
>>
>> 	can_get_echo_skb(dev, 0);
>> 	flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
>> 		&regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
>> 	netif_wake_queue(dev);
>> }
>>
>> and the problem disappeared as expected. However, the correct
>> way is probably to retry during some reasonable (configurable?)
>> time interval.
>>
>> What puzzles me is that I did not found any other instance
>> of this problem in the relevant mailing lists, only the original [2].
>>
>> I am using the 3.4.77 kernel with the realtime patches, but the
>> code in the latest mainline looks the same in this respect.
>> Maybe the realtime patches change some bevaviour, but I don't
>> think they affect the core problem. I am not really an expert
>> in the network devices, NAPI etc - maybe in that case the error
>> interrupt should be disabled and re-enabled only if the
>> error condition goes away? - I don't know...
>>
>> Please Cc: me when answering to the list.
>>
>> [1] http://www.tq-group.com/en/products/product-details/prod/embedded-modul-tqma28/extb/Main/productdetail/
>> [2] https://gitorious.org/linux-can/wg-linux-can-next/commit/8ad94fa

If bus-error reporting is enabled, you will get an interrupt for each
TX retry. That's normal behavior. But for the i.MX28 it should not be
enabled:

  $ cat flexcan.c
  ...
        /*
         * enable the "error interrupt" (FLEXCAN_CTRL_ERR_MSK),
         * on most Flexcan cores, too. Otherwise we don't get
         * any error warning or passive interrupts.
         */
        if (priv->devtype_data->features & FLEXCAN_HAS_BROKEN_ERR_STATE ||
            priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)
                reg_ctrl |= FLEXCAN_CTRL_ERR_MSK;

Maybe there is something wrong with you platform code or DTS file. What
kernel are you using and how is the DTS can node defined in your DTS file?

Wolfgang.

