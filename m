Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaD1GiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:38:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:60265 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaD1GiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:38:07 -0400
Message-ID: <535DF744.60606@linutronix.de>
Date: Mon, 28 Apr 2014 08:37:56 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable-rt@vger.kernel.org
Subject: Re: [PATCH RT 2/4] net: gianfar: do not try to cleanup TX packets
 if they are not done
References: <20140427143119.898655303@goodmis.org> <20140427143140.384915886@goodmis.org>
In-Reply-To: <20140427143140.384915886@goodmis.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 04:31 PM, Steven Rostedt wrote:
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index 5c0efcc..8aecc1d 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -2856,10 +2855,14 @@ static int gfar_poll(struct napi_struct *napi, int budget)
>  			tx_queue = priv->tx_queue[i];
>  			/* run Tx cleanup to completion */
>  			if (tx_queue->tx_skbuff[tx_queue->skb_dirtytx]) {
> -				gfar_clean_tx_ring(tx_queue);
> -				has_tx_work = 1;
> +				int ret;
> +
> +				ret = gfar_clean_tx_ring(tx_queue);
> +				if (ret)
> +					has_tx_work++;
>  			}
>  		}
> +		work_done += has_tx_work;
>  
>  		for_each_set_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
>  			/* skip queue if not active */

The 3.14-RT version of the patch should have an additional return
statement here which I forgot initially.

Sebastian
