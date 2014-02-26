Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBZOqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:46:54 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:3597 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbaBZOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:46:51 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275dh1de097h186068h1954cbhz2fh95h109h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh906i1155h)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v4] can: xilinx CAN controller support.
Thread-Topic: [PATCH v4] can: xilinx CAN controller support.
Thread-Index: AQHPMnBMZEwPglt3TUmAMsU8apdwWZrHhtZVgAAVneA=
Date: Wed, 26 Feb 2014 14:46:43 +0000
References: <74d607e9-ac9c-4a9b-ac49-e84ae49d20c2@TX2EHSMHS031.ehs.local>
 <530D0A9C.5090402@pengutronix.de>
 <cd00fb2d-c8a7-423d-8aa0-2b413e9ac101@CO9EHSMHS017.ehs.local>
 <530DEA7C.6010609@pengutronix.de>
In-Reply-To: <530DEA7C.6010609@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.228.241]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <678ca296-8687-4e7c-9014-ae69d886a068@CO9EHSMHS014.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1QEl0j6031231

Hi Marc,


> -----Original Message-----
> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> Sent: Wednesday, February 26, 2014 6:52 PM
> To: Appana Durga Kedareswara Rao; wg@grandegger.com; Michal Simek;
> grant.likely@linaro.org; robh+dt@kernel.org; linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org
> Subject: Re: [PATCH v4] can: xilinx CAN controller support.
>
> On 02/26/2014 02:07 PM, Appana Durga Kedareswara Rao wrote:
> >> This loop looks broken. Can you explain how it works.
> >>
> >> What it shoud do is:
> >> We have put (priv->tx_head - priv->tx_tail) CAN frames into the FIFO.
> >> This means at maximum there could be this amount of CAN frames which
> >> have been successfully transmitted. For every cycle in this while
> >> loop you
> >> should:
> >> a) check if a CAN frame has successfully been transmitted
> >>    (as this CAN core uses a FIFO it should be "oldest")
> >>    A read_reg() of some kind is missing in your loop.
> >> b) if needed, remove this event from the FIFO or
> >>    mark the interrupt as done. Whatever you hardware needs.
> >> c) update your statistics
> >> d) Use can_get_echo_skb to push this frame into the networking stack
> >> e) As a CAN frame has been transmitted successfully, wake the tx_queue.
> >>
> >>> +   while (priv->tx_head - priv->tx_tail > 0) {
> >>> +           if (isr & XCAN_IXR_TXFLL_MASK) {
> >>> +                   priv->write_reg(priv, XCAN_ICR_OFFSET,
> >>> +                                   XCAN_IXR_TXFLL_MASK);
> >>> +                   netif_stop_queue(ndev);
> >>
> >> Why do you stop the queue here? A CAN frame has successfully been
> >> transmitted, there should be room in the FIFO.
> >>
> >>> +                   break;
> >>> +           }
> >>> +           can_get_echo_skb(ndev, priv->tx_tail %
> >>> +                                   priv->xcan_echo_skb_max_tx);
> >>> +           priv->tx_tail++;
> >>> +   }
> >>> +
> >
> > The below are the bit fields available for the Transmit FIFO.
> > 1) In the ISR(interrupt status register)  Tx Ok interrupt and Tx fifo full
> interrupt.
> > 2) in the SR(Status Register) Tx fifo full condition.
> >
> >
> > I am modifying the entire tx interrupt logic to like below.
> >
> > static void xcan_tx_interrupt(struct net_device *ndev, u32 isr) {
> >         struct xcan_priv *priv = netdev_priv(ndev);
> >         struct net_device_stats *stats = &ndev->stats;
> >
> >             while (priv->tx_head - priv->tx_tail > 0) {
> >                 if (isr & XCAN_IXR_TXFLL_MASK) {
> >                         priv->write_reg(priv, XCAN_ICR_OFFSET,
> >                                         XCAN_IXR_TXFLL_MASK);
> >                           break;
> >                 }
> >                 can_get_echo_skb(ndev, priv->tx_tail %
> >                                         priv->xcan_echo_skb_max_tx);
> >                 priv->tx_tail++;
> >          stats->tx_packets++;
> >         netif_wake_queue(ndev);
> >               can_led_event(ndev, CAN_LED_EVENT_TX);
> >
> >         }
>
> You just need to wake the queue once.

Ok
>
> > }
> >
> >
> > Are you Ok with the above logic?
>
> No, how can you tell how many frames have been transmitted?

There is no register to read how many can frames are transmitted.
The only way to know Is by reading this parameter (stats->tx_packets++;) through ip command
ip -d -s link show can
Or using ifconfig command.

At the h/w level it can transmit Max upto 64 packets (Max fifo depth)
We need to monitor the Tx fifo full bit in the ISR(Interrupt Status Register)  or Tx fifo full bit in the SR(Status Register) and if it is full we need to stop the queue that is
I am doing in the _xmit by reading the status register before proceeding the   packet transmission.

Regards,
Kedar.


>
> Marc
>
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
