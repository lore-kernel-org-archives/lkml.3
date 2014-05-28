Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaE1QJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:09:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:38135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbaE1QJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:09:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,928,1392192000"; 
   d="scan'208";a="547863958"
Date: Wed, 28 May 2014 09:08:47 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528160847.GJ29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <20140528153548.GY11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528153548.GY11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 05:35:48PM +0200, Peter Zijlstra wrote:
> On Wed, May 28, 2014 at 07:58:31AM -0700, Andi Kleen wrote:
> > > In particular, the 0x90 offset (IA32_PERF_GLOBAL_STATUS). Intel once
> > > confirmed to me that that is a direct copy of the similarly named MSR at
> > > the time of the PEBS assist.
> > 
> > That is correct.
> > 
> > > 
> > > This is a problem, since if multiple counters overflow multiple bits
> > > will be set and its (afaict) ambiguous which event is for which counter.
> > 
> > When a PEBS counter overflows it clears its respective GLOBAL_STATUS bit
> > automatically.
> 
> That's an ambiguous statement; did you mean to say a PEBS enabled
> counter will not raise its bit in GLOBAL_STATUS on counter overflow?

Let's revisit how PEBS works:

- The counter overflows and sets the GLOBAL_STATUS bit
- The PEBS assist is armed
- The counter triggers again
- The PEBS assist fires and delivers a PEBS record
- Finally it clears the GLOBAL_STATUS
- When the threshold is reached it raises an PMI

So the GLOBAL_STATUS bit is visible between the first overflow and the end 
of the PEBS record delivery.

> 
> Because if it does raise it, but then clears it again, its raised for a
> short while and might be observed.

That's correct. 

But it's no different than with threshold 1 and relatively rare.

-andi
-- 
ak@linux.intel.com -- Speaking for myself only
