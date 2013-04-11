Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161002Ab3DKMOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:14:31 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:56161 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3DKMOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:14:30 -0400
Date: Thu, 11 Apr 2013 14:14:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Do not force shutdown/reboot to boot cpu.
Message-ID: <20130411121425.GA19216@gmail.com>
References: <20130410165934.GB21951@gmail.com>
 <20130410171420.GF3658@sgi.com>
 <20130410172236.GE21951@gmail.com>
 <20130410175519.GG3658@sgi.com>
 <20130410190003.GH3658@sgi.com>
 <20130411085751.GD11824@gmail.com>
 <20130411113412.GP3658@sgi.com>
 <20130411120027.GA18709@gmail.com>
 <20130411120358.GQ3658@sgi.com>
 <20130411120829.GR3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411120829.GR3658@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> On Thu, Apr 11, 2013 at 07:03:58AM -0500, Robin Holt wrote:
> > On Thu, Apr 11, 2013 at 02:00:27PM +0200, Ingo Molnar wrote:
> > > 
> > > * Robin Holt <holt@sgi.com> wrote:
> > > 
> > > > > Ok, so it looks profilable.
> > > > > 
> > > > > The result above is not surprising: most CPUs sit in idle and don't do anything, 
> > > > > while the loop goes on, right?
> > > > > 
> > > > > The interesting thing to profile would be the parallel bring-down, with the 
> > > > > simplest global lock solution you mentioned. In that case most CPUs should be 
> > > > > doing 'something' all the time - maybe spinning on the lock, maybe something else, 
> > > > > right?
> > > > 
> > > > Again, mostly looks idle.
> > > 
> > > Forgot to suggest:
> > > 
> > >   perf record -a /sbin/reboot
> > 
> > I used perf record -a /sbin/reboot -f -d -n
> 
> OK.  Looking at Russ' patch, I understand now why it is looking idle.
> We are still serially doing the DOWN_PREPARE, etc.  All those other cpus
> are still sitting idle.
> 
> Can we call the __cpu_down functions from an smp_call_function()?

I think the kthread_park() will generally schedule.

But ... whether it's an IPI or a wakeup should matter little: wakeups are IPI 
based (sometimes faster, mwait based).

So the main overhead is the serial loop - if that's done in parallel, and then all 
CPUs are waited for in a second loop, then much of the work can go on in parallel.

Thanks,

	Ingo
