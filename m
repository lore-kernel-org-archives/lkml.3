Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3DUThO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 15:37:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43382 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab3DUThM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 15:37:12 -0400
Date: Sun, 21 Apr 2013 21:37:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sbw@mit.edu,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Olivier Baetz <olivier.baetz@novasparks.com>
Subject: Re: [PATCH documentation 2/2] kthread: Document ways of reducing OS
 jitter due to per-CPU kthreads
Message-ID: <20130421193705.GB5807@pd.tnic>
References: <20130416164036.GA27246@linux.vnet.ibm.com>
 <1366130490-27584-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1366130490-27584-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1366130490-27584-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 09:41:30AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The Linux kernel uses a number of per-CPU kthreads, any of which might
> contribute to OS jitter at any time.  The usual approach to normal
> kthreads, namely to bind them to a "housekeeping" CPU, does not work
> with these kthreads because they cannot operate correctly if moved to
> some other CPU.  This commit therefore lists ways of controlling OS
> jitter from the Linux kernel's per-CPU kthreads.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Olivier Baetz <olivier.baetz@novasparks.com>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  Documentation/kernel-per-CPU-kthreads.txt | 186 ++++++++++++++++++++++++++++++
>  1 file changed, 186 insertions(+)
>  create mode 100644 Documentation/kernel-per-CPU-kthreads.txt
> 
> diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
> new file mode 100644
> index 0000000..bfecc1c
> --- /dev/null
> +++ b/Documentation/kernel-per-CPU-kthreads.txt
> @@ -0,0 +1,186 @@
> +REDUCING OS JITTER DUE TO PER-CPU KTHREADS
> +
> +This document lists per-CPU kthreads in the Linux kernel and presents
> +options to control OS jitter due to these kthreads.  Note that kthreads

s/due to/which can be caused by/

> +that are not per-CPU are not listed here -- to reduce OS jitter from

one too many "that"s:

s/that/which/

> +non-per-CPU kthreads, bind them to a "housekeeping" CPU that is dedicated

s/that/which/

> +to such work.
> +
> +
> +REFERENCES
> +
> +o	Documentation/IRQ-affinity.txt:  Binding interrupts to sets of CPUs.
> +
> +o	Documentation/cgroups:  Using cgroups to bind tasks to sets of CPUs.
> +
> +o	man taskset:  Using the taskset command to bind tasks to sets
> +	of CPUs.
> +
> +o	man sched_setaffinity:  Using the sched_setaffinity() system
> +	call to bind tasks to sets of CPUs.
> +
> +
> +KTHREADS
> +
> +Name: ehca_comp/%u
> +Purpose: Periodically process Infiniband-related work.
> +To reduce corresponding OS jitter, do any of the following:
> +1.	Don't use EHCA Infiniband hardware.  This will prevent these

Sounds like this particular hardware is slow and its IRQ handler/softirq
needs a lot of time. Yes, no?

Can we have a reason why people shouldn't use that hw.

> +	kthreads from being created in the first place.  (This will
> +	work for most people, as this hardware, though important,
> +	is relatively old and is produced in relatively low unit
> +	volumes.)
> +2.	Do all EHCA-Infiniband-related work on other CPUs, including
> +	interrupts.
> +
> +
> +Name: irq/%d-%s
> +Purpose: Handle threaded interrupts.
> +To reduce corresponding OS jitter, do the following:

This sentence keeps repeating; maybe explain the purpose of this doc in
the beginning once and drop this sentence in the later sections.

> +1.	Use irq affinity to force the irq threads to execute on
> +	some other CPU.
> +
> +Name: kcmtpd_ctr_%d
> +Purpose: Handle Bluetooth work.
> +To reduce corresponding OS jitter, do one of the following:
> +1.	Don't use Bluetooth, in which case these kthreads won't be
> +	created in the first place.
> +2.	Use irq affinity to force Bluetooth-related interrupts to
> +	occur on some other CPU and furthermore initiate all
> +	Bluetooth activity on some other CPU.
> +
> +Name: ksoftirqd/%u
> +Purpose: Execute softirq handlers when threaded or when under heavy load.
> +To reduce corresponding OS jitter, each softirq vector must be handled
> +separately as follows:
> +TIMER_SOFTIRQ:  Do all of the following:
> +1.	To the extent possible, keep the CPU out of the kernel when it
> +	is non-idle, for example, by avoiding system calls and by forcing
> +	both kernel threads and interrupts to execute elsewhere.
> +2.	Build with CONFIG_HOTPLUG_CPU=y.  After boot completes, force
> +	the CPU offline, then bring it back online.  This forces
> +	recurring timers to migrate elsewhere.	If you are concerned

We don't migrate them back to that CPU when we online it again, do we?

> +	with multiple CPUs, force them all offline before bringing the
> +	first one back online.
> +NET_TX_SOFTIRQ and NET_RX_SOFTIRQ:  Do all of the following:
> +1.	Force networking interrupts onto other CPUs.
> +2.	Initiate any network I/O on other CPUs.
> +3.	Once your application has started, prevent CPU-hotplug operations
> +	from being initiated from tasks that might run on the CPU to
> +	be de-jittered.  (It is OK to force this CPU offline and then
> +	bring it back online before you start your application.)
> +BLOCK_SOFTIRQ:  Do all of the following:
> +1.	Force block-device interrupts onto some other CPU.
> +2.	Initiate any block I/O on other CPUs.
> +3.	Once your application has started, prevent CPU-hotplug operations
> +	from being initiated from tasks that might run on the CPU to
> +	be de-jittered.  (It is OK to force this CPU offline and then
> +	bring it back online before you start your application.)
> +BLOCK_IOPOLL_SOFTIRQ:  Do all of the following:
> +1.	Force block-device interrupts onto some other CPU.
> +2.	Initiate any block I/O and block-I/O polling on other CPUs.
> +3.	Once your application has started, prevent CPU-hotplug operations
> +	from being initiated from tasks that might run on the CPU to
> +	be de-jittered.  (It is OK to force this CPU offline and then
> +	bring it back online before you start your application.)

more repeated text in brackets, maybe a footnote somewhere instead...

> +TASKLET_SOFTIRQ: Do one or more of the following:
> +1.	Avoid use of drivers that use tasklets.
> +2.	Convert all drivers that you must use from tasklets to workqueues.
> +3.	Force interrupts for drivers using tasklets onto other CPUs,
> +	and also do I/O involving these drivers on other CPUs.

How do I check which drivers use tasklets?

> +SCHED_SOFTIRQ: Do all of the following:
> +1.	Avoid sending scheduler IPIs to the CPU to be de-jittered,
> +	for example, ensure that at most one runnable kthread is

To which sentence does "for example" belong to? Depending on the answer,
you can split that sentence.

> +	present on that CPU.  If a thread awakens that expects
> +	to run on the de-jittered CPU, the scheduler will send

"If a thread expecting to run ont the de-jittered CPU awakens, the
scheduler..."

> +	an IPI that can result in a subsequent SCHED_SOFTIRQ.
> +2.	Build with CONFIG_RCU_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_ALL=y,
> +	CONFIG_NO_HZ_FULL=y, and in addition ensure that the CPU

commas:

			  , and, in addition, ensure...


> +	to be de-jittered is marked as an adaptive-ticks CPU using the
> +	"nohz_full=" boot parameter.  This reduces the number of
> +	scheduler-clock interrupts that the de-jittered CPU receives,
> +	minimizing its chances of being selected to do load balancing,

I don't think there's a "," if the "which... " part refers to the
previous "load balancing" and not to the whole sentence.

> +	which happens in SCHED_SOFTIRQ context.
> +3.	To the extent possible, keep the CPU out of the kernel when it
> +	is non-idle, for example, by avoiding system calls and by
> +	forcing both kernel threads and interrupts to execute elsewhere.

This time "for example" reads ok.

> +	This further reduces the number of scheduler-clock interrupts
> +	that the de-jittered CPU receives.

s/that/which/ would suit better here IMHO.

> +HRTIMER_SOFTIRQ:  Do all of the following:
> +1.	To the extent possible, keep the CPU out of the kernel when it
> +	is non-idle, for example, by avoiding system calls and by forcing
> +	both kernel threads and interrupts to execute elsewhere.

Ok, I think I get your "for example" usage pattern.

"blabablabla. For example, do blabalbal."

I think that would be a bit more readable.

> +2.	Build with CONFIG_HOTPLUG_CPU=y.  Once boot completes, force the
> +	CPU offline, then bring it back online.  This forces recurring
> +	timers to migrate elsewhere.  If you are concerned with multiple
> +	CPUs, force them all offline before bringing the first one
> +	back online.

Same question: do the timers get migrated back when the CPU reappears
online?

> +RCU_SOFTIRQ:  Do at least one of the following:
> +1.	Offload callbacks and keep the CPU in either dyntick-idle or
> +	adaptive-ticks state by doing all of the following:
> +	a.	Build with CONFIG_RCU_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_ALL=y,
> +		CONFIG_NO_HZ_FULL=y, and in addition ensure that the CPU

				   , and, in addition, 

> +		to be de-jittered is marked as an adaptive-ticks CPU
> +		using the "nohz_full=" boot parameter.	Bind the rcuo
> +		kthreads to housekeeping CPUs that can tolerate OS jitter.

					      which

> +	b.	To the extent possible, keep the CPU out of the kernel
> +		when it is non-idle, for example, by avoiding system
> +		calls and by forcing both kernel threads and interrupts
> +		to execute elsewhere.
> +2.	Enable RCU to do its processing remotely via dyntick-idle by
> +	doing all of the following:
> +	a.	Build with CONFIG_NO_HZ=y and CONFIG_RCU_FAST_NO_HZ=y.
> +	b.	Ensure that the CPU goes idle frequently, allowing other

I'm ensuring that by selecting the proper workload which has idle
breathers?

> +		CPUs to detect that it has passed through an RCU quiescent
> +		state.	If the kernel is built with CONFIG_NO_HZ_FULL=y,
> +		userspace execution also allows other CPUs to detect that
> +		the CPU in question has passed through a quiescent state.
> +	c.	To the extent possible, keep the CPU out of the kernel
> +		when it is non-idle, for example, by avoiding system
> +		calls and by forcing both kernel threads and interrupts
> +		to execute elsewhere.
> +
> +Name: rcuc/%u
> +Purpose: Execute RCU callbacks in CONFIG_RCU_BOOST=y kernels.
> +To reduce corresponding OS jitter, do at least one of the following:
> +1.	Build the kernel with CONFIG_PREEMPT=n.  This prevents these
> +	kthreads from being created in the first place, and also prevents
> +	RCU priority boosting from ever being required.  This approach

"... this obviates the need for RCU priority boosting."

> +	is feasible for workloads that do not require high degrees of
> +	responsiveness.
> +2.	Build the kernel with CONFIG_RCU_BOOST=n.  This prevents these
> +	kthreads from being created in the first place.  This approach
> +	is feasible only if your workload never requires RCU priority
> +	boosting, for example, if you ensure frequent idle time on all
> +	CPUs that might execute within the kernel.
> +3.	Build with CONFIG_RCU_NOCB_CPU=y and CONFIG_RCU_NOCB_CPU_ALL=y,
> +	which offloads all RCU callbacks to kthreads that can be moved
> +	off of CPUs susceptible to OS jitter.  This approach prevents the
> +	rcuc/%u kthreads from having any work to do, so that they are
> +	never awakened.
> +4.	Ensure that the CPU never enters the kernel and in particular

						   , and, in particular, 

> +	avoid initiating any CPU hotplug operations on this CPU.  This is
> +	another way of preventing any callbacks from being queued on the
> +	CPU, again preventing the rcuc/%u kthreads from having any work
> +	to do.
> +
> +Name: rcuob/%d, rcuop/%d, and rcuos/%d
> +Purpose: Offload RCU callbacks from the corresponding CPU.
> +To reduce corresponding OS jitter, do at least one of the following:
> +1.	Use affinity, cgroups, or other mechanism to force these kthreads
> +	to execute on some other CPU.
> +2.	Build with CONFIG_RCU_NOCB_CPUS=n, which will prevent these
> +	kthreads from being created in the first place.  However,
> +	please note that this will not eliminate the corresponding

can we drop "corresponding" here?

> +	OS jitter, but will instead shift it to RCU_SOFTIRQ.
> +
> +Name: watchdog/%u
> +Purpose: Detect software lockups on each CPU.
> +To reduce corresponding OS jitter, do at least one of the following:

ditto.

> +1.	Build with CONFIG_LOCKUP_DETECTOR=n, which will prevent these
> +	kthreads from being created in the first place.
> +2.	Echo a zero to /proc/sys/kernel/watchdog to disable the
> +	watchdog timer.
> +3.	Echo a large number of /proc/sys/kernel/watchdog_thresh in
> +	order to reduce the frequency of OS jitter due to the watchdog
> +	timer down to a level that is acceptable for your workload.


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
