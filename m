Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3KFSL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:11:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46198 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KFSL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:11:27 -0500
Date: Wed, 6 Nov 2013 13:11:08 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
Message-ID: <20131106181108.GA11233@neilslaptop.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
 <20131106153429.GA26336@redhat.com>
 <20131106155445.GB6357@neilslaptop.think-freely.org>
 <1383758363.7940.19.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383758363.7940.19.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 09:19:23AM -0800, Joe Perches wrote:
> On Wed, 2013-11-06 at 10:54 -0500, Neil Horman wrote:
> > On Wed, Nov 06, 2013 at 10:34:29AM -0500, Dave Jones wrote:
> > > On Wed, Nov 06, 2013 at 10:23:19AM -0500, Neil Horman wrote:
> > >  > do_csum was identified via perf recently as a hot spot when doing
> > >  > receive on ip over infiniband workloads.  After alot of testing and
> > >  > ideas, we found the best optimization available to us currently is to
> > >  > prefetch the entire data buffer prior to doing the checksum
> []
> > I'll fix this up and send a v3, but I'll give it a day in case there are more
> > comments first.
> 
> Perhaps a reduction in prefetch loop count helps.
> 
> Was capping the amount prefetched and letting the
> hardware prefetch also tested?
> 
> 	prefetch_lines(buff, min(len, cache_line_size() * 8u));
> 
It was not, but I did not bother to try since accurate branch predicion in the
loop and prefetch issuing should be very fast.  Id also be worried that capping
prefetch would be relatively hardware specific, so what worked well on some
hardware, wouldn't be enough on other hardware.  I'd rather just issue the
prefetch for the whole buffer, as that should produce consistent results.

> Also pedantry/trivial comments:
> 
> __always_inline instead of inline
> static __always_inline void prefetch_lines(const void *addr, size_t len)
> {
> 	const void *end = addr + len;
> ...
> 
> buff doesn't need a void * cast in prefetch_lines
> 
ACK

> Beside the commit message, the comment above prefetch_lines
> also needs updating to remove the "Manual Prefetching" line.
> 
Yup, Dave noted the Manual Prefetch issue, and I'll move the whole comment as
part of that.

> /*
>  * Do a 64-bit checksum on an arbitrary memory area.
>  * Returns a 32bit checksum.
>  *
>  * This isn't as time critical as it used to be because many NICs
>  * do hardware checksumming these days.
>  * 
>  * Things tried and found to not make it faster:
>  * Manual Prefetching
>  * Unrolling to an 128 bytes inner loop.
>  */
> 
> 
> 

Regards
Neil

