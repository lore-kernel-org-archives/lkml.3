Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077AbaDJHUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:20:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:43590 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934688AbaDJHU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:20:27 -0400
Message-ID: <53464639.2040208@linutronix.de>
Date: Thu, 10 Apr 2014 09:20:25 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@freescale.com>
Subject: Re: [PATCH RT 2/2] net: gianfar: do not try to cleanup TX packets
 if they are not done
References: <1396004220-5711-1-git-send-email-bigeasy@linutronix.de>	 <1396004220-5711-2-git-send-email-bigeasy@linutronix.de> <1397090916.20280.36.camel@snotra.buserror.net>
In-Reply-To: <1397090916.20280.36.camel@snotra.buserror.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 02:48 AM, Scott Wood wrote:
> Why is this only being sent to RT and not to netdev for mainline?

I tried. And complained about how that problem was fixed by a duct tape
solution (by dropping the outer loop) instead of understanding the
problem and fixing it properly. Even Eric tied to point out that there
might be something else going on. Look at netdev for "gianfar: Simplify
MQ polling to avoid soft lockup".
The threaded ended ended up with the fact that I took this for -RT only
because netdev had already code for v3.15 and Claudiu managed to
rewrite that part (again) and added napi for TX. So that Patch as-is
does not apply anymore.
With NAPI for TX I had may no longer persists so I will probably drop
this patch in -RT >= 3.15

>> --- a/drivers/net/ethernet/freescale/gianfar.c
>> +++ b/drivers/net/ethernet/freescale/gianfar.c
>> @@ -2516,7 +2515,7 @@ static void gfar_align_skb(struct sk_buff *skb)
>>  }
>>  
>>  /* Interrupt Handler for Transmit complete */
>> -static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
>> +static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
>>  {
>>  	struct net_device *dev = tx_queue->dev;
>>  	struct netdev_queue *txq;
>> @@ -2939,10 +2938,14 @@ static int gfar_poll(struct napi_struct *napi, int budget)
> 
> You changed the return from void to int, but you never added any return
> statement.  GCC should have warned you about this...

Interesting. I remember that I added "howmany" as return value. I
remember testing it. And yet there is evidence that I did not such a
thing. I will add it. Thanks for pointing out.

> 
> -Scott
> 

Sebastian
