Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbbAYVCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:02:14 -0500
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:49778 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753634AbbAYVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:02:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:2729:2828:2904:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:4225:4250:4321:4605:5007:6119:7652:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12294:12296:12438:12517:12519:12740:13019:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: loss56_68528fdab2c02
X-Filterd-Recvd-Size: 4360
Message-ID: <1422135432.18650.2.camel@perches.com>
Subject: Re: [PATCH] net: Linn Ethernet Packet Sniffer driver
From: Joe Perches <joe@perches.com>
To: Stathis Voukelatos <stathisv70@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Stathis Voukelatos <stathis.voukelatos@linn.co.uk>,
        abrestic@chromium.org
In-Reply-To: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk>
References: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 24 Jan 2015 13:37:12 -0800
Mime-Version: 1.0
X-Mailer: Evolution 3.12.7-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-23 at 10:07 +0000, Stathis Voukelatos wrote:
> This patch adds support the Ethernet Packet Sniffer H/W module
> developed by Linn Products Ltd and found in the IMG Pistachio SoC.
> The module allows Ethernet packets to be parsed, matched against
> a user-defined pattern and timestamped. It sits between a 100M
> Ethernet MAC and PHY and is completely passive with respect to
> Ethernet frames.
[]
>  include/linux/pkt_sniffer.h                        |  89 +++++

Why should this file be here?
Why not in the drivers/net/pkt-sniffer directory?

> diff --git a/drivers/net/pkt-sniffer/backends/ether/channel.c b/drivers/net/pkt-sniffer/backends/ether/channel.c
[]
> +static int esnf_start(struct snf_chan *dev);

Be nice to rearrange the code to avoid the forward declarations.

> +static int esnf_stop(struct snf_chan *dev);
> +static int esnf_set_pattern(struct snf_chan *dev, const u8 *pattern, int count);
> +static int esnf_num_recs_avail(struct snf_chan *dev);
> +static int esnf_max_ptn_entries(struct snf_chan *dev);
> +static int esnf_max_match_bytes(struct snf_chan *dev);
> +static int validate_pattern(
> +			struct ether_snf_chan *ch,
> +			const u8 *buf,
> +			int count);

[]

> +static int validate_pattern(struct ether_snf_chan *ch, const u8 *buf, int count)
> +{

Maybe better as bool

> +	int i, complete, max_copy_bytes;
[]
> +	/* Check if the string was properly terminated
> +	 * and contained valid number of commands
> +	 */
> +	if (complete) {
> +		max_copy_bytes = ch->fifo_blk_words * 4;
> +		if (ts)
> +			max_copy_bytes -= 4;
> +		if ((copy_before + copy_after) > max_copy_bytes)
> +			return 0;
> +		ch->ts_present = ts;
> +		ch->nfb_before = copy_before;
> +		ch->nfb_after = copy_after;
> +		return 1;
> +	} else {
> +		return 0;
> +	}

	return complete;

[]

> +/* Interrupt thread function */
> +static irqreturn_t esnf_irq_thread(int irq, void *dev_id)
> +{
> +	struct platform_device *pdev = (struct platform_device *)dev_id;
> +	struct ether_snf *esnf = (struct ether_snf *)platform_get_drvdata(pdev);
> +	u32 irq_status;
> +
> +	if (unlikely(esnf->irq != irq))
> +		return IRQ_NONE;
> +
> +	irq_status = ioread32(esnf->regs + INTERRUPT_STATUS) &
> +				 ioread32(esnf->regs + INTERRUPT_ENABLE);
> +
> +	dev_dbg(&pdev->dev, "irq: 0x%08x\n", irq_status);
> +
> +	/* TX FIFO full */
> +	if (unlikely(irq_status & TX_FULL_IRQ_BIT))
> +		dev_notice(&pdev->dev, "TX FIFO full");

Missing terminating newlines
> +
> +	/* RX FIFO full */
> +	if (unlikely(irq_status & RX_FULL_IRQ_BIT))
> +		dev_notice(&pdev->dev, "RX FIFO full");
> +
> +	/* TX match data available */
> +	if (irq_status & TX_DATA_IRQ_BIT) {
> +		dev_dbg(&pdev->dev, "TX data");
> +		channel_data_available(&esnf->txc);
> +	}
> +
> +	/* RX match data available */
> +	if (irq_status & RX_DATA_IRQ_BIT) {
> +		dev_dbg(&pdev->dev, "RX data");
> +		channel_data_available(&esnf->rxc);
> +	}

> diff --git a/drivers/net/pkt-sniffer/core/nl.c b/drivers/net/pkt-sniffer/core/nl.c
[]
> +int snf_netlink_init(int id, struct snf_chan *dev, const char *name)
> +{
[]
> +	/* Allocate ops array and copy template data */
> +	nl->ops = kmalloc(sizeof(snf_ops_tmpl), GFP_KERNEL);
> +	if (!nl->ops) {
> +		ret = -ENOMEM;
> +		goto fail2;
> +	}
> +	memcpy(nl->ops, snf_ops_tmpl, sizeof(snf_ops_tmpl));

kmemdup



