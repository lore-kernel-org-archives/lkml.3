Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab3KHUP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:15:27 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46968 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3KHUPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:15:25 -0500
Date: Fri, 8 Nov 2013 15:14:59 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
Message-ID: <20131108201459.GE16052@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
 <20131106153429.GA26336@redhat.com>
 <20131106155445.GB6357@neilslaptop.think-freely.org>
 <1383758363.7940.19.camel@joe-AO722>
 <20131108190136.GB16052@hmsreliant.think-freely.org>
 <1383939193.2639.39.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383939193.2639.39.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 11:33:13AM -0800, Joe Perches wrote:
> On Fri, 2013-11-08 at 14:01 -0500, Neil Horman wrote:
> > On Wed, Nov 06, 2013 at 09:19:23AM -0800, Joe Perches wrote:
> > > On Wed, 2013-11-06 at 10:54 -0500, Neil Horman wrote:
> > > > On Wed, Nov 06, 2013 at 10:34:29AM -0500, Dave Jones wrote:
> > > > > On Wed, Nov 06, 2013 at 10:23:19AM -0500, Neil Horman wrote:
> > > > >  > do_csum was identified via perf recently as a hot spot when doing
> > > > >  > receive on ip over infiniband workloads.  After alot of testing and
> > > > >  > ideas, we found the best optimization available to us currently is to
> > > > >  > prefetch the entire data buffer prior to doing the checksum
> > > []
> > > > I'll fix this up and send a v3, but I'll give it a day in case there are more
> > > > comments first.
> > > 
> > > Perhaps a reduction in prefetch loop count helps.
> > > 
> > > Was capping the amount prefetched and letting the
> > > hardware prefetch also tested?
> > > 
> > > 	prefetch_lines(buff, min(len, cache_line_size() * 8u));
> > > 
> > 
> > Just tested this out:
> 
> Thanks.
> 
> Reformatting the table so it's a bit more
> readable/comparable for me:
> 
> len	SetSz	Loops	cycles/byte
> 			limited	unlimited
> 1500B	64MB	1M	1.3442	1.3605
> 1500B	128MB	1M	1.3410	1.3542
> 1500B	256MB	1M	1.3536	1.3710
> 1500B	512MB	1M	1.3463	1.3536
> 9000B	64MB	1M	0.8522	0.8504
> 9000B	128MB	1M	0.8528	0.8536
> 9000B	256MB	1M	0.8532	0.8520
> 9000B	512MB	1M	0.8527	0.8525
> 64KB	64MB	1M	0.7686	0.7683
> 64KB	128MB	1M	0.7695	0.7686
> 64KB	256MB	1M	0.7699	0.7708
> 64KB	512MB	1M	0.7799	0.7694
> 
> This data appears to show some value
> in capping for 1500b lengths and noise
> for shorter and longer lengths.
> 
> Any idea what the actual distribution of
> do_csum lengths is under various loads?
> 

I don't have any hard data no, sorry. I chose the above values for length based
on typical mtus for ethernet, jumbo frame ethernet and ipoib (which Doug tells
me commonly has a 64k mtu).  I expect we anecdotally say 1500 bytes is going to
be the most common case.  I'll cap the prefetch at 1500B for now, since it
doesn't seem to hurt or help beyond that
Neil


