Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3KFRTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:19:23 -0500
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:33973 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754235Ab3KFRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:19:22 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:7652:9108:10004:10400:10848:11026:11232:11658:11914:12050:12296:12517:12519:12740:13069:13095:13311:13357:13869,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cook51_342ddb45f8f03
X-Filterd-Recvd-Size: 2640
Message-ID: <1383758363.7940.19.camel@joe-AO722>
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
From: Joe Perches <joe@perches.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Wed, 06 Nov 2013 09:19:23 -0800
In-Reply-To: <20131106155445.GB6357@neilslaptop.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
	 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
	 <20131106153429.GA26336@redhat.com>
	 <20131106155445.GB6357@neilslaptop.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 10:54 -0500, Neil Horman wrote:
> On Wed, Nov 06, 2013 at 10:34:29AM -0500, Dave Jones wrote:
> > On Wed, Nov 06, 2013 at 10:23:19AM -0500, Neil Horman wrote:
> >  > do_csum was identified via perf recently as a hot spot when doing
> >  > receive on ip over infiniband workloads.  After alot of testing and
> >  > ideas, we found the best optimization available to us currently is to
> >  > prefetch the entire data buffer prior to doing the checksum
[]
> I'll fix this up and send a v3, but I'll give it a day in case there are more
> comments first.

Perhaps a reduction in prefetch loop count helps.

Was capping the amount prefetched and letting the
hardware prefetch also tested?

	prefetch_lines(buff, min(len, cache_line_size() * 8u));

Also pedantry/trivial comments:

__always_inline instead of inline
static __always_inline void prefetch_lines(const void *addr, size_t len)
{
	const void *end = addr + len;
...

buff doesn't need a void * cast in prefetch_lines

Beside the commit message, the comment above prefetch_lines
also needs updating to remove the "Manual Prefetching" line.

/*
 * Do a 64-bit checksum on an arbitrary memory area.
 * Returns a 32bit checksum.
 *
 * This isn't as time critical as it used to be because many NICs
 * do hardware checksumming these days.
 * 
 * Things tried and found to not make it faster:
 * Manual Prefetching
 * Unrolling to an 128 bytes inner loop.
 */


