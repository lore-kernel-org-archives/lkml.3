Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3CFQ1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:27:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:8607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab3CFQ1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:27:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,795,1355126400"; 
   d="scan'208";a="300174602"
Date: Thu, 7 Mar 2013 00:26:33 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 4/5] clocksource: Enable clocksource_cyc2ns() to cover
 big cycles
Message-ID: <20130306162633.GC25790@feng-snb>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
 <1362554271-22382-5-git-send-email-feng.tang@intel.com>
 <alpine.LFD.2.02.1303061451340.22263@ionos>
 <20130306143742.GB25790@feng-snb>
 <alpine.LFD.2.02.1303061701130.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303061701130.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 05:10:53PM +0100, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Feng Tang wrote:
> > Hi Thomas,
> > 
> > Thanks for the reviews.
> > 
> > On Wed, Mar 06, 2013 at 03:09:26PM +0100, Thomas Gleixner wrote:
> > > On Wed, 6 Mar 2013, Feng Tang wrote:
> > > 
> > > > Current clocksource_cyc2ns() has a implicit limit that the (cycles * mult)
> > > > can not exceed 64 bits limit. Jason Gunthorpe proposed a way to
> > > > handle this big cycles case, and this patch put the handling into
> > > > clocksource_cyc2ns() so that it could be used unconditionally.
> > > 
> > > Could be used if it wouldn't break the world and some more.
> > 
> > Exactly.
> > 
> > One excuse I can think of is usually the clocksource_cyc2ns() will be called
> > for cycles less than 600 seconds, based on which the "mult" and "shift" are
> > calculated for a clocksource.
> 
> That's not an excuse for making even the build fail on ARM and other
> 32bit archs.

That's a huge mistake I made in my patch, and I didn't meant to excuse for it :)

> > 
> > trying to avoid expensieve maths. But as Jason pointed, there is some accuracy
> > lost. 
> 
> Right, but if you precalculate the max_fast_cycles value you can avoid
> at least the division in the fast path and then do
> 
>    if (cycles > max_fast_cycles)
>       return clocksource_cyc2ns_slow();
>    return ((u64) cycles * mult) >> shift;	      
> 
> clocksource_cyc2ns_slow() should be out of line and there you can do
> all the slow 64 bit operations. That keeps the fast path sane and we
> don't need extra magic for the large cycle values.

Yeah! This should well cover all possilbe cycles and solve the fast/slow
problem. Thanks. Will try to make a new patch.

- Feng

