Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaG2NQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:16:02 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaG2NQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:16:00 -0400
Date: Tue, 29 Jul 2014 15:15:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140729131556.GD3935@laptop>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <20140728104837.GQ6758@twins.programming.kicks-ass.net>
 <20140729005640.GA5203@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729005640.GA5203@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 08:56:41AM +0800, Yuyang Du wrote:
> On Mon, Jul 28, 2014 at 12:48:37PM +0200, Peter Zijlstra wrote:
> > > +static __always_inline u64 decay_load(u64 val, u64 n)
> > > +{
> > > +	if (likely(val <= UINT_MAX))
> > > +		val = decay_load32(val, n);
> > > +	else {
> > > +		val *= (u32)decay_load32(1 << 15, n);
> > > +		val >>= 15;
> > > +	}
> > > +
> > > +	return val;
> > > +}
> > 
> > Please just use mul_u64_u32_shr().
> > 
> > /me continues reading the rest of it..
> 
> Good. Since 128bit is considered in mul_u64_u32_shr, load_sum can
> afford more tasks :)

96bit actually. While for 64bit platforms it uses the 64x64->128 mult it
only uses 2 32x32->64 mults for 32bit, which isn't sufficient for 128 as
that would require 4.

It also reduces to 1 32x32->64 mult (on 32bit) in case val fits in
32bit.

Therefore its as efficient as your code, but more accurate for not
loosing bits in the full (val is bigger than 32bit) case.
