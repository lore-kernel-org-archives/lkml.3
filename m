Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaLAQ4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:56:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbaLAQ4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:56:40 -0500
Date: Mon, 1 Dec 2014 11:56:35 -0500
From: Don Zickus <dzickus@redhat.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141201165635.GU116159@redhat.com>
References: <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141126002501.GA11752@redhat.com>
 <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
 <20141126024032.GA13246@redhat.com>
 <20141126225745.GA30346@redhat.com>
 <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
 <20141127225637.GA24019@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127225637.GA24019@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 05:56:37PM -0500, Dave Jones wrote:
> On Thu, Nov 27, 2014 at 11:17:16AM -0800, Linus Torvalds wrote:
>  > On Wed, Nov 26, 2014 at 2:57 PM, Dave Jones <davej@redhat.com> wrote:
>  > >
>  > > So 3.17 also has this problem.
>  > > Good news I guess in that it's not a regression, but damn I really didn't
>  > > want to have to go digging through the mists of time to find the last 'good' point.
>  > 
>  > So I'm looking at the watchdog code, and it seems racy wrt parking and startup.
>  > 
>  > In particular, it sets the high priority *after* starting the hrtimer,
>  > and it goes back to SCHED_NORMAL *before* canceling the timer.
>  > 
>  > Which seems completely ass-backwards. And the smp_hotplug_thread stuff
>  > explicitly enables preemption around the setup/cleanup/part/unpark
>  > operations.
>  > 
>  > However, that would be an issue only if trinity might be doing things
>  > that enable and disable the watchdog. And doing so under insane loads.
>  > Even then it seems unlikely.
>  > 
>  > The insane loads you have. But even then, could a load average of 169
>  > possibly delay running a non-RT process for 22 seconds? Doubtful.
>  > 
>  > But just in case: do you do cpu hotplug events (that will disable and
>  > re-enable the watchdog process?).  Anything else that will part/unpark
>  > the hotplug thread?
> 
> That's root-only iirc, and I'm not running trinity as root, so that
> shouldn't be happening. There's also no sign of such behaviour in dmesg
> when the problem occurs.

Yeah, the watchdog code is very chatty during thread 'unparking'.  If
Dave's dmesg log isn't seeing any:

"enabled on all CPUs, permanently consumes one hw-PMU counter"

except on boot, then I believe the park/unpark race you see shouldn't
be occuring in this scenario.


> 
>  > Quite frankly, I'm just grasping for straws here, but a lot of the
>  > watchdog traces really have seemed spurious...
> 
> Agreed.

Well we can explore this route..

I added a patch below that just logs the watchdog timer function and
kernel thread for each cpu.  It's a little chatty but every 4 seconds you
will see something like this in the logs:

[ 2507.580184] 1: watchdog process kicked (reset)
[ 2507.581154] 0: watchdog process kicked (reset)
[ 2507.581172] 0: watchdog run
[ 2507.593469] 1: watchdog run
[ 2507.595106] 2: watchdog process kicked (reset)
[ 2507.595120] 2: watchdog run
[ 2507.608136] 3: watchdog process kicked (reset)
[ 2507.613204] 3: watchdog run

With the printk timestamps it would be interesting to see what the
watchdog was doing in its final moments and if the timestamps verify the
exceeded duration or if the watchdog screws up the calculation and falsely
reports a lockup.

Cheers,
Don


diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 70bf118..b1ea06c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -324,6 +324,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
 	if (touch_ts == 0) {
+		printk("%d: watchdog process kicked (reset)\n", smp_processor_id());
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
 			/*
 			 * If the time stamp was touched atomically
@@ -346,6 +347,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 * this is a good indication some task is hogging the cpu
 	 */
 	duration = is_softlockup(touch_ts);
+	printk("%d: watchdog process kicked (%d seconds since last)\n", smp_processor_id(), duration);
 	if (unlikely(duration)) {
 		/*
 		 * If a virtual machine is stopped by the host it can look to
@@ -477,6 +479,7 @@ static void watchdog(unsigned int cpu)
 	__this_cpu_write(soft_lockup_hrtimer_cnt,
 			 __this_cpu_read(hrtimer_interrupts));
 	__touch_watchdog();
+	printk("%d: watchdog run\n", cpu);
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
