Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3ILUaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:30:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57605 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab3ILUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:30:31 -0400
Date: Thu, 12 Sep 2013 22:30:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] completely bonkers use of set_need_resched +
 VM_FAULT_NOPAGE
Message-ID: <20130912203020.GB1798@laptop.programming.kicks-ass.net>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
 <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
 <20130912154329.GB31370@twins.programming.kicks-ass.net>
 <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com>
 <20130912162210.GE31370@twins.programming.kicks-ass.net>
 <20130912163543.GB12961@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912163543.GB12961@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:35:43PM +0100, Chris Wilson wrote:
> Not quite, as it would be possible for the evil userspace to trigger a
> GPU hang that would cause the sane userspace to spin indefinitely 
> waiting for the error recovery to kick in.

So with FIFOn+1 preempting FIFOn its a live-lock because the faulting
thread will forever keep yielding to itself since its the highest
priority task around, therefore the set_need_resched() is an absolute
NOP in that case.

For OTHER it might run another task with set_need_resched(), without
set_need_resched() it'll simply spin on the fault until it runs out of
time and gets force preempted and another task gets to run.

So for either case, the set_need_resched() doesn't make an appreciable
difference.

Removing it will not make evil userspace much worse -- at worst it will
cause slightly more wasted cycles.
