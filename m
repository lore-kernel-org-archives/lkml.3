Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab3KHTB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:01:57 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46191 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3KHTB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:01:56 -0500
Date: Fri, 8 Nov 2013 14:01:36 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
Message-ID: <20131108190136.GB16052@hmsreliant.think-freely.org>
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

Just tested this out:

With limiting:
1500B   | 64MB  | 1000000       | 1.344167
1500B   | 128MB | 1000000       | 1.340970
1500B   | 256MB | 1000000       | 1.353562
1500B   | 512MB | 1000000       | 1.346349
9000B   | 64MB  | 1000000       | 0.852174
9000B   | 128MB | 1000000       | 0.852765
9000B   | 256MB | 1000000       | 0.853153
9000B   | 512MB | 1000000       | 0.852661
64KB    | 64MB  | 1000000       | 0.768585
64KB    | 128MB | 1000000       | 0.769465
64KB    | 256MB | 1000000       | 0.769909
64KB    | 512MB | 1000000       | 0.779895


Without limiting

1500B   | 64MB  | 1000000       | 1.360525
1500B   | 128MB | 1000000       | 1.354220
1500B   | 256MB | 1000000       | 1.371037
1500B   | 512MB | 1000000       | 1.353557
9000B   | 64MB  | 1000000       | 0.850415
9000B   | 128MB | 1000000       | 0.853642
9000B   | 256MB | 1000000       | 0.852048
9000B   | 512MB | 1000000       | 0.852484
64KB    | 64MB  | 1000000       | 0.768261
64KB    | 128MB | 1000000       | 0.768566
64KB    | 256MB | 1000000       | 0.770822
64KB    | 512MB | 1000000       | 0.769391

Doesn't look like much consistent improvement.

Neil

