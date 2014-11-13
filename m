Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbaKMUKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:10:09 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:50249 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbaKMUKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:10:07 -0500
Date: Thu, 13 Nov 2014 12:10:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@freescale.com>,
        Michael Neuling <mikey@neuling.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Cristian Stoica <cristian.stoica@freescale.com>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/16] crypto: caam - Remove unnecessary
 smp_read_barrier_depends()
Message-ID: <20141113201001.GQ4460@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
 <1415906662-4576-2-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415906662-4576-2-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111320-0025-0000-0000-000006156572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 02:24:07PM -0500, Pranith Kumar wrote:
> Recently lockless_dereference() was added which can be used in place of
> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  drivers/crypto/caam/jr.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index bae20d8..9b3ef1bc 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -181,8 +181,6 @@ static void caam_jr_dequeue(unsigned long devarg)
>  		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
>  			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
> 
> -			smp_read_barrier_depends();
> -

Did you mean to add a lockless_dereference() somewhere?  I would guess
that one is required on the load into sw_idx before the "for" loop,
but I cannot claim to be familiar with this code.

							Thanx, Paul

>  			if (jrp->outring[hw_idx].desc ==
>  			    jrp->entinfo[sw_idx].desc_addr_dma)
>  				break; /* found */
> @@ -218,7 +216,6 @@ static void caam_jr_dequeue(unsigned long devarg)
>  		if (sw_idx == tail) {
>  			do {
>  				tail = (tail + 1) & (JOBR_DEPTH - 1);
> -				smp_read_barrier_depends();
>  			} while (CIRC_CNT(head, tail, JOBR_DEPTH) >= 1 &&
>  				 jrp->entinfo[tail].desc_addr_dma == 0);
> 
> -- 
> 1.9.1
> 

