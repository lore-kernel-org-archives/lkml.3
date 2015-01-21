Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbbAULqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:46:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:54090 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbbAULqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:46:36 -0500
Date: Wed, 21 Jan 2015 12:46:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: aik@ozlabs.ru, shreyas@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, michael@ellerman.id.au,
        Anton Blanchard <anton@samba.org>, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V3] tick/broadcast: Make movement of broadcast hrtimer
 robust against hotplug
In-Reply-To: <20150120103559.8430.50933.stgit@preeti.in.ibm.com>
Message-ID: <alpine.DEB.2.11.1501211243270.5526@nanos>
References: <20150120103559.8430.50933.stgit@preeti.in.ibm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Preeti U Murthy wrote:
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 5544990..f3907c9 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -568,6 +568,7 @@ int clockevents_notify(unsigned long reason, void *arg)
>  
>  	case CLOCK_EVT_NOTIFY_CPU_DYING:
>  		tick_handover_do_timer(arg);
> +		tick_shutdown_broadcast_oneshot(arg);
>  		break;
>  
>  	case CLOCK_EVT_NOTIFY_SUSPEND:
> @@ -580,7 +581,6 @@ int clockevents_notify(unsigned long reason, void *arg)
>  		break;
>  
>  	case CLOCK_EVT_NOTIFY_CPU_DEAD:
> -		tick_shutdown_broadcast_oneshot(arg);
>  		tick_shutdown_broadcast(arg);
>  		tick_shutdown(arg);
>  		/*
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 066f0ec..f983983 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -675,8 +675,11 @@ static void broadcast_move_bc(int deadcpu)
>  
>  	if (!bc || !broadcast_needs_cpu(bc, deadcpu))
>  		return;
> -	/* This moves the broadcast assignment to this cpu */
> -	clockevents_program_event(bc, bc->next_event, 1);
> +	/* Since a cpu with the earliest wakeup is nominated as the 
> +	 * standby cpu, the next cpu to invoke BROADCAST_ENTER
> +	 * will now automatically take up the duty of broadcasting.
> +	 */
> +	bc->next_event.tv64 = KTIME_MAX;

So that relies on the fact, that cpu_down() currently forces ALL cpus
into stop_machine(). Of course this is not in any way obvious and any
change to this will cause even more hard to debug issues.

And to be honest, the clever 'set next_event to KTIME_MAX' is even
more nonobvious because it's only relevant for your hrtimer based
broadcasting magic. Any real broadcast device does not care about this
at all.

This whole random notifier driven hotplug business is just a
trainwreck. I'm still trying to convert this to a well documented
state machine, so I rather prefer to make this an explicit take over
rather than a completely undocumented 'works today' mechanism.

What about the patch below?

Thanks,

	tglx
----
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 5d220234b3ca..7a9b1ae4a945 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -16,6 +16,7 @@
 #include <linux/bug.h>
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
+#include <linux/clockchips.h>
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/suspend.h>
@@ -421,6 +422,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	while (!idle_cpu(cpu))
 		cpu_relax();
 
+	/*
+	 * Before waiting for the cpu to enter DEAD state, take over
+	 * any tick related duties
+	 */
+	clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
+
 	/* This actually kills the CPU. */
 	__cpu_die(cpu);
 
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 37e50aadd471..3c1bfd0f7074 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1721,11 +1721,8 @@ static int hrtimer_cpu_notify(struct notifier_block *self,
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-	{
-		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
 		migrate_hrtimers(scpu);
 		break;
-	}
 #endif
 
 	default:

