Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3LSRZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:25:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59907 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3LSRZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:25:51 -0500
Date: Thu, 19 Dec 2013 18:25:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power
 regression
Message-ID: <20131219172535.GN16438@laptop.programming.kicks-ass.net>
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
 <20131219122257.GC11279@gmail.com>
 <52B316FF.50906@zytor.com>
 <20131219160210.GA28426@gmail.com>
 <52B31B21.6010901@zytor.com>
 <20131219162136.GM16438@laptop.programming.kicks-ass.net>
 <52B323BE.7090108@zytor.com>
 <20131219170741.GB30382@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219170741.GB30382@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:07:41PM +0100, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 12/19/2013 08:21 AM, Peter Zijlstra wrote:
> > > 
> > > What's that mb for?
> > > 
> > 
> > It already exists in mwait_idle_with_hints(); I just moved it into 
> > this common function.  It is a bit odd, I have to admit; it seems 
> > like it should be *before* the monitor (and possibly we should have 
> > one after the CLFLUSH as well?)
> 
> Yes, I think we need a barrier before the CLFLUSH, because according 
> to my reading of the Intel documentation CLFLUSH has no implicit 
> ordering so it might get reordered with the store to ->flags in 
> current_set_polling_and_test(), which might result in spurious wakeup 
> problems again.

No it cannot; since current_set_polling_and_test() already has a barrier
to prevent that.

Also, the location patched by hpa doesn't actually call that at all.

That said, I would find it very strange indeed if a CLFLUSH doesn't also
flush the store buffer.

> (And CLFLUSH is a store in a sense, so special in that the regular 
> ordering for stores does not apply.)
> 
> Likewise, having a barrier before the MONITOR looks sensible as well. 
> Having it _after_ monitor looks weird and is probably wrong. [It might 
> have been the effects of someone seeing the spurious wakeup problems 
> with realizing the true source, or so.]

I again have to disagree, one would expect monitor to flush all that is
required to start the monitor -- and it actually does so. As is
testified by this extra CLFLUSH being called a bug workaround.
