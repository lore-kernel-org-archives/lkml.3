Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbaGPHrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:47:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:7552 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbaGPHrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:47:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="544054952"
Date: Wed, 16 Jul 2014 07:45:05 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: bsegall@google.com
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        pjt@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140715234505.GA2901@intel.com>
References: <1405293352-9305-1-git-send-email-yuyang.du@intel.com>
 <1405293352-9305-3-git-send-email-yuyang.du@intel.com>
 <xm26vbqzwx9a.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140715015105.GA2532@intel.com>
 <xm26pph6wmzy.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm26pph6wmzy.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:27:45AM -0700, bsegall@google.com wrote:
> >  
> >> > +static __always_inline u64 decay_load64(u64 val, u64 n)
> >> > +{
> >> > +	if (likely(val <= UINT_MAX))
> >> > +		val = decay_load(val, n);
> >> > +	else {
> >> > +		/*
> >> > +		 * LOAD_AVG_MAX can last ~500ms (=log_2(LOAD_AVG_MAX)*32ms).
> >> > +		 * Since we have so big runnable load_avg, it is impossible
> >> > +		 * load_avg has not been updated for such a long time. So
> >> > +		 * LOAD_AVG_MAX is enough here.
> >> > +		 */
> >> 
> >> I mean, LOAD_AVG_MAX is irrelevant - the constant could just as well be
> >> 1<<20, or whatever, yes? In fact, if you're going to then turn it into a
> >> fraction of 1<<10, just do (with whatever temporaries you find most tasteful):
> >> 
> >> val *= (u32) decay_load(1 << 10, n);
> >> val >>= 10;
> >> 
> >
> > LOAD_AVG_MAX is selected on purpose. The val arriving here specifies that it is really
> > big. So the decay_load may not decay it to 0 even period n is not small. If we use 1<<10
> > here, n=10*32 will decay it to 0, but val (larger than 1<<32) can
> > survive.
> 
> But when you do *1024 / LOAD_AVG_MAX it will go back to zero. In general
> the code you have now is exactly equivalent to factor = decay_load(1<<10,n)
> ignoring possible differences in rounding.
> 
Oh, yes...., I did not go to that deep.

Then to avoid this, maybe should first val*factor, then val/LOAD_AVG_MAX, but then risk
overflow again... Ok, I will do:

val *= (u32) decay_load(1 << 10, n);
val >>= 10;

if not enough, I believe decay_load(1 << 15, n) should be safe too.

Thanks a lot,
Yuyang
