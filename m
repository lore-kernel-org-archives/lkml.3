Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3IQLWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:22:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45205 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3IQLWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:22:19 -0400
Date: Tue, 17 Sep 2013 13:22:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/11] preempt_count rework -v3
Message-ID: <20130917112205.GF12926@twins.programming.kicks-ass.net>
References: <20130917082838.218329307@infradead.org>
 <20130917105344.GA23024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917105344.GA23024@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 12:53:44PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > These patches optimize preempt_enable by firstly folding the preempt and
> > need_resched tests into one -- this should work for all architectures. And
> > secondly by providing per-arch preempt_count implementations; with x86 using
> > per-cpu preempt_count for fastest access.
> > 
> > These patches have been boot tested on CONFIG_PREEMPT=y x86_64 and survive
> > building a x86_64-defconfig kernel.
> > 
> >    text    data     bss     filename
> > 11387014  1454776 1187840 defconfig-build/vmlinux.before
> > 11352294  1454776 1187840 defconfig-build/vmlinux.after
> 
> That's a 0.3% size improvement (and most of the improvement is in 
> hotpaths), despite GCC is being somewhat stupid about not allowing us to 
> mark asm goto targets as cold paths and thus causes some unnecessary 
> register shuffling in some cases, right?

I'm not entire sure where the bloat in 1/11 comes from; several
functions look like they avoid using stack variables for using more
registers which create more push/pop on entry/exit paths. Others I'm not
entirely sure of what happens with.

But it does look like the unlikely() thing still works, even with the
asm goto, you'll note that the call to schedule_preempt is out-of-line.
