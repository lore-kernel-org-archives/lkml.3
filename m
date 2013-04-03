Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735Ab3DCQXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:23:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51390 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab3DCQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:23:30 -0400
Date: Wed, 3 Apr 2013 17:19:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Nicolas Pitre <nico@linaro.org>, Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Ingo Molnar <mingo@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] ARM: keep __my_cpu_offset consistent with generic
	one
Message-ID: <20130403161955.GE17995@n2100.arm.linux.org.uk>
References: <1362663356-21151-1-git-send-email-tom.leiming@gmail.com> <CACVXFVOhr222CVrzkVP_oLgVkdReD9BXXSBg7fmp6Wvx9_peCw@mail.gmail.com> <20130312105638.GQ4977@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312105638.GQ4977@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:56:38AM +0000, Russell King - ARM Linux wrote:
> On Tue, Mar 12, 2013 at 10:32:21AM +0800, Ming Lei wrote:
> > On Thu, Mar 7, 2013 at 9:35 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> > > Commit 14318efb(ARM: 7587/1: implement optimized percpu variable access)
> > > introduces arm's __my_cpu_offset to optimize percpu vaiable access,
> > > which really works well on hackbench, but will cause __my_cpu_offset
> > > to return garbage value before it is initialized in cpu_init() called
> > > by setup_arch, so accessing percpu variable before setup_arch may cause
> > > kernel hang. But generic __my_cpu_offset always returns zero before
> > > percpu area is brought up, and won't hang kernel.
> > >
> > > So the patch tries to clear __my_cpu_offset on boot CPU early
> > > to avoid boot hang.
> > >
> > > At least now percpu variable is accessed by lockdep before
> > > setup_arch(), and enabling CONFIG_LOCK_STAT or CONFIG_DEBUG_LOCKDEP
> > > can trigger kernel hang.
> > >
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: Rob Herring <rob.herring@calxeda.com>
> > > Cc: Will Deacon <will.deacon@arm.com>
> > > Cc: Nicolas Pitre <nico@linaro.org>
> > > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > > ---
> > > V1:
> > >         - documents lockdep uses percpu variable early
> > 
> > Looks no one objects the patch, so I has submitted it into Russell's
> > patch system, and hope it can be pushed to linus tree soon and
> > make LOCK_STAT/DEBUG_LOCKDEP usable on ARMv7.
> 
> I'm not convinced it is correct.  Is the percpu data as stored in the
> kernel image (in other words, at offset zero) supposed to be read only?
> If so, the above means that we'll be accessing that rather than the
> copy of the percpu data we should be accessing.
> 
> The percpu data areas are allocated by setup_per_cpu_areas() - that's
> where we should be initializing this, just like it's done on PowerPC.

Still not convinced this is a proper fix.  Look, the problem is this:

- Initially, set the CPU percpu offset to zero.  This means the boot
  CPU reads and writes to the percpu data section in the kernel image.

- The percpu areas are initialized, and the percpu data copied to each
  percpu data - this will have any writes from the boot CPU included as
  changes to the percpu data.

- The boot CPU continues to read/write to the percpu data section.

- If the boot CPU suspends/resumes, cpu_init() gets called, which will
  call set_my_cpu_offset(per_cpu_offset(cpu)); for the boot CPU.

- The boot CPU now uses the allocated percpu data section and any
  updates it did in the percpu data section in the kernel image are
  lost to it.

Your patch may be right on its own to solve the initial problem, but
it leaves a _big_ hole.

Now, the big question here: is it right that the boot CPU should ever
write to the static percpu data section in the kernel image?  What if
there's a pointer in there, initially NULL, which then gets checked
by each CPU and initialized if NULL - we'll end up sharing the same
allocation amongst all CPUs, which probably isn't what was intended.
If there's a list_head which gets added to, that too will be very bad.

Although you have uncovered a problem, I still think by setting the
offset to zero initially, you're just papering over a much bigger
can of worms.

So, should percpu data be used this early in boot before the percpu
stuff is properly initialized?  That feels _extremely_ unsafe.

This, I think, needs to be addressed properly.  And part of that is
knowing where things went wrong.  Will Deacon asked you for a backtrace
showing where this problem occured.  Your response seems to be to
resend the patch with a "v1" tag a no new information.

Sorry, not applying this until the above issue has been discussed
and the location of these percpu accesses has been properly analysed.
