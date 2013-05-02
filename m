Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679Ab3EBPqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:46:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab3EBPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:46:30 -0400
Date: Thu, 2 May 2013 11:46:21 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
Message-ID: <20130502154621.GA23990@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130430212007.GB18598@redhat.com>
 <20130430213719.GA14988@redhat.com>
 <alpine.LFD.2.02.1305021234510.3972@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305021234510.3972@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 12:37:26PM +0200, Thomas Gleixner wrote:

 > > On a second machine, I'm seeing an oops even earlier. As soon as I
 > > exit grub, I get a blinking cursor.  If I boot with earlyprintk=vga
 > > I can see..
 > > 
 > > Call Trace:
 > >  <IRQ>
 > >   tick_check_oneshot_broadcast
 > >   tick_check_idle
 > >   irq_enter
 > >   do_IRQ
 > >   common_interrupt
 > >  <EOI>
 > >   x86_64_start_reservations
 > >   x86_64_start_kernel
 > > RIP: clockevents_set_mode+0x18
 > > 
 > > Matching up the Code: line of the trace with the disassembly I see..
 > > 
 > >         if (dev->mode != mode) {
 > >  4c8:   39 77 38                cmp    %esi,0x38(%rdi)
 > > 
 > > 
 > 
 > diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
 > index 61d00a8..db9da73 100644
 > --- a/kernel/time/tick-broadcast.c
 > +++ b/kernel/time/tick-broadcast.c
 > @@ -475,7 +475,8 @@ void tick_check_oneshot_broadcast(int cpu)
 >  	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
 >  		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 >  
 > -		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
 > +		if (td)
 > +			clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
 >  	}
 >  }
 >  

td must be non-null, because this doesn't change anything.

a clue: If I disable CONFIG_SLUB_DEBUG, or even boot with slub_debug=- then it boots fine.

I'll bisect.

	Dave

