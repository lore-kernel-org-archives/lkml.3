Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050Ab3EBT6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:58:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:41646 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761631Ab3EBT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:58:05 -0400
Date: Thu, 2 May 2013 21:58:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
In-Reply-To: <20130502154621.GA23990@redhat.com>
Message-ID: <alpine.LFD.2.02.1305022152280.2891@ionos>
References: <20130430212007.GB18598@redhat.com> <20130430213719.GA14988@redhat.com> <alpine.LFD.2.02.1305021234510.3972@ionos> <20130502154621.GA23990@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Dave Jones wrote:
> On Thu, May 02, 2013 at 12:37:26PM +0200, Thomas Gleixner wrote:
> 
>  > > On a second machine, I'm seeing an oops even earlier. As soon as I
>  > > exit grub, I get a blinking cursor.  If I boot with earlyprintk=vga
>  > > I can see..
>  > > 
>  > > Call Trace:
>  > >  <IRQ>
>  > >   tick_check_oneshot_broadcast
>  > >   tick_check_idle
>  > >   irq_enter
>  > >   do_IRQ
>  > >   common_interrupt
>  > >  <EOI>
>  > >   x86_64_start_reservations
>  > >   x86_64_start_kernel
>  > > RIP: clockevents_set_mode+0x18
>  > > 
>  > > Matching up the Code: line of the trace with the disassembly I see..
>  > > 
>  > >         if (dev->mode != mode) {
>  > >  4c8:   39 77 38                cmp    %esi,0x38(%rdi)
>  > > 
>  > > 
>  > 
>  > diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
>  > index 61d00a8..db9da73 100644
>  > --- a/kernel/time/tick-broadcast.c
>  > +++ b/kernel/time/tick-broadcast.c
>  > @@ -475,7 +475,8 @@ void tick_check_oneshot_broadcast(int cpu)
>  >  	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
>  >  		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
>  >  
>  > -		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
>  > +		if (td)
>  > +			clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
>  >  	}
>  >  }
>  >  
> 
> td must be non-null, because this doesn't change anything.

Bah, I'm a moron. td is always non-null.

The check should be: 

    if (td->evtdev && tick_device_is_functional(td->evtdev))

> a clue: If I disable CONFIG_SLUB_DEBUG, or even boot with slub_debug=- then it boots fine.

Huch? That does not make any sense.

Thanks,

	tglx
