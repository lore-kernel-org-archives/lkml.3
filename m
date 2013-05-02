Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab3EBNMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:12:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48774 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3EBNMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:12:06 -0400
Date: Thu, 2 May 2013 15:10:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@sr71.net, fweisbec@gmail.com, tglx@linutronix.de,
        sgruszka@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Avoid cputime scaling overflow
Message-ID: <20130502131033.GG13837@dyad.programming.kicks-ass.net>
References: <20130430151441.GC10465@redhat.com>
 <tip-55eaa7c1f511af5fb6ef808b5328804f4d4e5243@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-55eaa7c1f511af5fb6ef808b5328804f4d4e5243@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	for (;;) {
> +		/* Make sure "rtime" is the bigger of stime/rtime */
> +		if (stime > rtime) {
> +			u64 tmp = rtime; rtime = stime; stime = tmp;

I keep forgetting to mention we have swap(rtime, stime); that does the above.

> +		}
> +
> +		/* Make sure 'total' fits in 32 bits */
> +		if (total >> 32)
> +			goto drop_precision;
> +
> +		/* Does rtime (and thus stime) fit in 32 bits? */
> +		if (!(rtime >> 32))
> +			break;
> +
> +		/* Can we just balance rtime/stime rather than dropping bits? */
> +		if (stime >> 31)
> +			goto drop_precision;
> +
> +		/* We can grow stime and shrink rtime and try to make them both fit */
> +		stime <<= 1;
> +		rtime >>= 1;
> +		continue;
> +
> +drop_precision:
> +		/* We drop from rtime, it has more bits than stime */
> +		rtime >>= 1;
> +		total >>= 1;
>  	}
>  
> +	/*
> +	 * Make sure gcc understands that this is a 32x32->64 multiply,
> +	 * followed by a 64/32->64 divide.
> +	 */
> +	scaled = div_u64((u64) (u32) stime * (u64) (u32) rtime, (u32)total);
>  	return (__force cputime_t) scaled;
>  }
>  
