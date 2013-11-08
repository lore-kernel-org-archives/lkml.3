Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3KHU3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:29:13 -0500
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:42872 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757478Ab3KHU3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:29:11 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1605:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2553:2559:2562:2691:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:7652:8957:9108:10004:10400:10848:11026:11232:11658:11914:12043:12050:12517:12519:12740:13161:13229:13869,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pear23_4fdb675f34b16
X-Filterd-Recvd-Size: 3768
Message-ID: <1383942547.2639.49.camel@joe-AO722>
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
From: Joe Perches <joe@perches.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Fri, 08 Nov 2013 12:29:07 -0800
In-Reply-To: <20131108201459.GE16052@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
	 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
	 <20131106153429.GA26336@redhat.com>
	 <20131106155445.GB6357@neilslaptop.think-freely.org>
	 <1383758363.7940.19.camel@joe-AO722>
	 <20131108190136.GB16052@hmsreliant.think-freely.org>
	 <1383939193.2639.39.camel@joe-AO722>
	 <20131108201459.GE16052@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-08 at 15:14 -0500, Neil Horman wrote:
> On Fri, Nov 08, 2013 at 11:33:13AM -0800, Joe Perches wrote:
> > On Fri, 2013-11-08 at 14:01 -0500, Neil Horman wrote:
> > > On Wed, Nov 06, 2013 at 09:19:23AM -0800, Joe Perches wrote:
> > > > On Wed, 2013-11-06 at 10:54 -0500, Neil Horman wrote:
> > > > > On Wed, Nov 06, 2013 at 10:34:29AM -0500, Dave Jones wrote:
> > > > > > On Wed, Nov 06, 2013 at 10:23:19AM -0500, Neil Horman wrote:
> > > > > >  > do_csum was identified via perf recently as a hot spot when doing
> > > > > >  > receive on ip over infiniband workloads.  After alot of testing and
> > > > > >  > ideas, we found the best optimization available to us currently is to
> > > > > >  > prefetch the entire data buffer prior to doing the checksum
> > > > []
> > > > > I'll fix this up and send a v3, but I'll give it a day in case there are more
> > > > > comments first.
> > > > 
> > > > Perhaps a reduction in prefetch loop count helps.
> > > > 
> > > > Was capping the amount prefetched and letting the
> > > > hardware prefetch also tested?
> > > > 
> > > > 	prefetch_lines(buff, min(len, cache_line_size() * 8u));
> > > > 
> > > 
> > > Just tested this out:
> > 
> > Thanks.
> > 
> > Reformatting the table so it's a bit more
> > readable/comparable for me:
> > 
> > len	SetSz	Loops	cycles/byte
> > 			limited	unlimited
> > 1500B	64MB	1M	1.3442	1.3605
> > 1500B	128MB	1M	1.3410	1.3542
> > 1500B	256MB	1M	1.3536	1.3710
> > 1500B	512MB	1M	1.3463	1.3536
> > 9000B	64MB	1M	0.8522	0.8504
> > 9000B	128MB	1M	0.8528	0.8536
> > 9000B	256MB	1M	0.8532	0.8520
> > 9000B	512MB	1M	0.8527	0.8525
> > 64KB	64MB	1M	0.7686	0.7683
> > 64KB	128MB	1M	0.7695	0.7686
> > 64KB	256MB	1M	0.7699	0.7708
> > 64KB	512MB	1M	0.7799	0.7694
> > 
> > This data appears to show some value
> > in capping for 1500b lengths and noise
> > for shorter and longer lengths.
> > 
> > Any idea what the actual distribution of
> > do_csum lengths is under various loads?
> > 
> I don't have any hard data no, sorry.

I think you should before you implement this.
You might find extremely short lengths.

> I'll cap the prefetch at 1500B for now, since it
> doesn't seem to hurt or help beyond that

The table data has a max prefetch of
8 * boot_cpu_data.x86_cache_alignment so
I believe it's always less than 1500 but
perhaps 4 might be slightly better still.


