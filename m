Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbaDWKKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:10:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaDWKKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:10:44 -0400
Date: Wed, 23 Apr 2014 12:10:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] yet another 32/64-bit range check failure
Message-ID: <20140423101038.GK11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404230011280.28524@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404230011280.28524@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:14:52AM -0400, Vince Weaver wrote:
> On Tue, 22 Apr 2014, Vince Weaver wrote:
> 
> > This is allowing events to be allocated memory but not being freed somehow
> > before returning EINVAL (a memory leak).
> > At least it looks like this is happening in the huge traces I have trying 
> > to track down the perf_fuzzer memory corruption bug.
> 
> I can't find where the memory leak happens, but it looks like this in the 
> trace:
> 
> [ 3524.626452] perf_fuz-1798    0.... 1271584315us : sys_enter: NR 298 (698e40, 706, ffffffff, f, 800000000000, 800000000000)
> [ 3524.642312] perf_fuz-1798    0.... 1271584324us : kmalloc: call_site=ffffffff8113a575 ptr=ffff88007d5b0800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> [ 3524.662598] perf_fuz-1798    0.... 1271584337us : sys_exit: NR 298 = -22
> 
> The call site for the kmalloc is in perf_event_alloc()
> 
> The memory is eventually freed as:
> 
> [ 3547.895534]   <idle>-0       0.Ns. 1271595088us : kfree: call_site=ffffffff811316aa ptr=ffff88007d5b0800

So perf_event_open() -> err_alloc: -> free_event() -> __free_event() ->
call_rcu() -> free_event_rcu() -> kfree().

Would explain that, right? The memory is RCU freed, which means we need
to wait a grace period before releasing it.
