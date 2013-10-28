Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab3J1RMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:12:31 -0400
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:60891 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756806Ab3J1RMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:12:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12295:12296:12438:12517:12519:12663:12740:13069:13095:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: veil34_313f944ff384d
X-Filterd-Recvd-Size: 2549
Message-ID: <1382980336.30941.40.camel@joe-AO722>
Subject: Re: [PATCH] can: c_can: Speed up rx_poll function
From: Joe Perches <joe@perches.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date: Mon, 28 Oct 2013 10:12:16 -0700
In-Reply-To: <1382979582-10352-1-git-send-email-mpa@pengutronix.de>
References: <1382979582-10352-1-git-send-email-mpa@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 17:59 +0100, Markus Pargmann wrote:
> This patch speeds up the rx_poll function by reducing the number of
> register reads.

trivial notes:

> diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
[]
> @@ -259,6 +259,12 @@ static u32 c_can_read_reg32(struct c_can_priv *priv, enum reg index)
> +u16 c_can_read_reg16(struct c_can_priv *priv, enum reg index)
> +{
> +	u16 val = priv->read_reg(priv, index);
> +	return val;
> +}

This function doesn't seem useful at all.
It's not exported and it's not static.

Why not use an in-place priv->read_reg(priv, index)?

> +
>  static void c_can_enable_all_interrupts(struct c_can_priv *priv,
>  						int enable)
>  {
> @@ -798,17 +804,21 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
>  	u32 num_rx_pkts = 0;
>  	unsigned int msg_obj, msg_ctrl_save;
>  	struct c_can_priv *priv = netdev_priv(dev);
> -	u32 val = c_can_read_reg32(priv, C_CAN_INTPND1_REG);
> +	unsigned long val = c_can_read_reg16(priv, C_CAN_INTPND1_REG);

Probably better as a u16 as detailed below.

> +	/*
> +	 * It is faster to read only one 16bit register. This is only possible
> +	 * for a maximum number of 16 objects.
> +	 */
> +	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
> +			"Implementation does not support more message objects than 16");
> +
> +	while (quota > 0 && (val = c_can_read_reg16(priv, C_CAN_INTPND1_REG))) {
> +		msg_obj = 0;
> +		while ((msg_obj = find_next_bit(&val, 16, msg_obj)) < 16 &&

Using ffs instead of find_next_bit would be more standard
and probably faster too.


