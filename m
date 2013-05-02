Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3EBKha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:37:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:39083 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3EBKh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:37:28 -0400
Date: Thu, 2 May 2013 12:37:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
In-Reply-To: <20130430213719.GA14988@redhat.com>
Message-ID: <alpine.LFD.2.02.1305021234510.3972@ionos>
References: <20130430212007.GB18598@redhat.com> <20130430213719.GA14988@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Dave Jones wrote:
> On Tue, Apr 30, 2013 at 05:20:07PM -0400, Dave Jones wrote:
>  > I have a machine that crashes instantly on boot up on Linus'
>  > post-3.9 tree. (8c55f1463c1fd318d5e785f02b80bcc32176d342)
>  > 
>  > By booting with boot_delay=100, I was able to take a photo
>  > and capture the top of the trace.  (For some reason, larger boot
>  > delay parameters seem to make it take forever before printing
>  > even a single character, which made this a pain to debug).
>  > 
>  > The WARN_ON it prints right before locking up is this in clockevents_program_event
>  > 
>  > 208         if (unlikely(expires.tv64 < 0)) {
>  > 209                 WARN_ON_ONCE(1);
>  > 210                 return -ETIME;
>  > 211         }
>  > 
>  > booting with maxcpus=1 avoids the problem.
>  > 
>  > I'm still trying to get a complete stack trace, though it's painful
>  > due to the above reason.
> 
> On a second machine, I'm seeing an oops even earlier. As soon as I
> exit grub, I get a blinking cursor.  If I boot with earlyprintk=vga
> I can see..
> 
> Call Trace:
>  <IRQ>
>   tick_check_oneshot_broadcast
>   tick_check_idle
>   irq_enter
>   do_IRQ
>   common_interrupt
>  <EOI>
>   x86_64_start_reservations
>   x86_64_start_kernel
> RIP: clockevents_set_mode+0x18
> 
> Matching up the Code: line of the trace with the disassembly I see..
> 
>         if (dev->mode != mode) {
>  4c8:   39 77 38                cmp    %esi,0x38(%rdi)
> 
> 
> the comment above that code is telling..
> 
> /*
>  * Must be called with interrupts disabled !
>  */
> 
> So how did we get an IRQ ?
 
Well, we are inside an IRQ and the code is called with interrupts
disabled from there. Fix below.

Thanks,

	tglx

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 61d00a8..db9da73 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -475,7 +475,8 @@ void tick_check_oneshot_broadcast(int cpu)
 	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
-		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
+		if (td)
+			clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
 	}
 }
 

