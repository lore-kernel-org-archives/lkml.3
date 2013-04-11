Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005Ab3DKRSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:18:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33446
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934405Ab3DKRSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:18:34 -0400
Message-ID: <5166F062.2090007@infradead.org>
Date: Thu, 11 Apr 2013 10:18:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 2/2] kthread: Document ways of reducing
 OS jitter due to per-CPU kthreads
References: <20130411160524.GA30384@linux.vnet.ibm.com> <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com> <1365696359-30958-2-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1365696359-30958-2-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 09:05 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>
> The Linux kernel uses a number of per-CPU kthreads, any of which might
> contribute to OS jitter at any time.  The usual approach to normal
> kthreads, namely to affinity them to a "housekeeping" CPU, does not

ugh.               to affine them

> work with these kthreads because they cannot operate correctly if moved
> to some other CPU.  This commit therefore lists ways of controlling OS
> jitter from the Linux kernel's per-CPU kthreads.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Christoph Lameter <cl@linux.com>
> ---
>   Documentation/kernel-per-CPU-kthreads.txt | 159 ++++++++++++++++++++++++++++++
>   1 file changed, 159 insertions(+)
>   create mode 100644 Documentation/kernel-per-CPU-kthreads.txt
>
> diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
> new file mode 100644
> index 0000000..495dacf
> --- /dev/null
> +++ b/Documentation/kernel-per-CPU-kthreads.txt
> @@ -0,0 +1,159 @@
> +REDUCING OS JITTER DUE TO PER-CPU KTHREADS
> +
> +This document lists per-CPU kthreads in the Linux kernel and presents
> +options to control OS jitter due to these kthreads.  Note that kthreads
> +that are not per-CPU are not listed here -- to reduce OS jitter from
> +non-per-CPU kthreads, bind them to a "housekeeping" CPU that is dedicated
> +to such work.
> +
> +
> +Name: ehca_comp/%u
> +Purpose: Periodically process Infiniband-related work.
> +To reduce corresponding OS jitter, do any of the following:
> +1.	Don't use EHCA Infiniband hardware.  This will prevent these
> +	kthreads from being created in the first place.  (This will
> +	work for most people, as this hardware, though important,
> +	is relatively old as is produced in relatively low unit
> +	volumes.)
> +2.	Do all EHCA-Infiniband-related work on other CPUs, including
> +	interrupts.
> +
> +
> +Name: irq/%d-%s
> +Purpose: Handle threaded interrupts.
> +To reduce corresponding OS jitter, do the following:
> +1.	Use irq affinity to force the irq threads to execute on
> +	some other CPU.

It would be very nice to explain here how that is done.

> +
> +Name: kcmtpd_ctr_%d
> +Purpose: Handle Bluetooth work.
> +To reduce corresponding OS jitter, do one of the following:
> +1.	Don't use Bluetooth, in cwhich case these kthreads won't be

	                        which

> +	created in the first place.
> +2.	Use irq affinity to force Bluetooth-related interrupts to
> +	occur on some other CPU and furthermore initiate all
> +	Bluetooth activity from some other CPU.
> +
> +Name: ksoftirqd/%u
> +Purpose: Execute softirq handlers when threaded or when under heavy load.
> +To reduce corresponding OS jitter, each softirq vector must be handled
> +separately as follows:
> +TIMER_SOFTIRQ:
> +1.	Build with CONFIG_HOTPLUG_CPU=y.
> +2.	To the extent possible, keep the CPU out of the kernel when it

I guess I have a different viewpoint.  I would say:  keep the kernel
off of that CPU ....

> +	is non-idle, for example, by forcing user and kernel threads as
> +	well as interrupts to execute elsewhere.
> +3.	Force the CPU offline, then bring it back online.  This forces
> +	recurring timers to migrate elsewhere.  If you are concerned
> +	with multiple CPUs, force them all offline before bringing the
> +	first one back online.
> +NET_TX_SOFTIRQ and NET_RX_SOFTIRQ:  Do all of the following:
> +1.	Force networking interrupts onto other CPUs.
> +2.	Initiate any network I/O on other CPUs.
> +3.	Prevent CPU-hotplug operations from being initiated from tasks
> +	that might run on the CPU to be de-jittered.
> +BLOCK_SOFTIRQ:  Do all of the following:
> +1.	Force block-device interrupts onto some other CPU.
> +2.	Initiate any block I/O on other CPUs.
> +3.	Prevent CPU-hotplug operations from being initiated from tasks
> +	that might run on the CPU to be de-jittered.
> +BLOCK_IOPOLL_SOFTIRQ:  Do all of the following:
> +1.	Force block-device interrupts onto some other CPU.
> +2.	Initiate any block I/O and block-I/O polling on other CPUs.
> +3.	Prevent CPU-hotplug operations from being initiated from tasks
> +	that might run on the CPU to be de-jittered.
> +TASKLET_SOFTIRQ: Do one or more of the following:
> +1.	Avoid use of drivers that use tasklets.
> +2.	Convert all drivers that you must use from tasklets to workqueues.
> +3.	Force interrupts for drivers using tasklets onto other CPUs,
> +	and also do I/O involving these drivers on other CPUs.
> +SCHED_SOFTIRQ: Do all of the following:
> +1.	Avoid sending scheduler IPIs to the CPU to be de-jittered,
> +	for example, ensure that at most one runnable kthread is
> +	present on that CPU.  If a thread awakens that expects
> +	to run on the de-jittered CPU, the scheduler will send
> +	an IPI that can result in a subsequent SCHED_SOFTIRQ.
> +2.	Build with CONFIG_RCU_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_ALL=y,
> +	CONFIG_NO_HZ_EXTENDED=y, and in addition ensure that the CPU
> +	to be de-jittered is marked as an adaptive-ticks CPU using the
> +	"nohz_extended=" boot parameter.  This reduces the number of
> +	scheduler-clock interrupts that the de-jittered CPU receives,
> +	minimizing its chances of being selected to do load balancing,
> +	which happens in SCHED_SOFTIRQ context.
> +3.	To the extent possible, keep the CPU out of the kernel when it

same viewpoint point.

> +	is non-idle, for example, by forcing user and kernel threads as
> +	well as interrupts to execute elsewhere.  This further reduces
> +	the number of scheduler-clock interrupts that the de-jittered
> +	CPU receives.
> +HRTIMER_SOFTIRQ:  Do all of the following:
> +1.	Build with CONFIG_HOTPLUG_CPU=y.
> +2.	To the extent possible, keep the CPU out of the kernel when it
> +	is non-idle, for example, by forcing user and kernel threads as
> +	well as interrupts to execute elsewhere.
> +3.	Force the CPU offline, then bring it back online.  This forces
> +	recurring timers to migrate elsewhere.  If you are concerned
> +	with multiple CPUs, force them all offline before bringing the
> +	first one back online.
> +RCU_SOFTIRQ:  Do at least one of the following:
> +1.	Offload callbacks and keep the CPU in either dyntick-idle or
> +	adaptive-ticks state by doing all of the following:
> +	a.	Build with CONFIG_RCU_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_ALL=y,
> +		CONFIG_NO_HZ_EXTENDED=y, and in addition ensure that
> +		the CPU to be de-jittered is marked as an adaptive-ticks CPU
> +		using the "nohz_extended=" boot parameter.
> +	b.	To the extent possible, keep the CPU out of the kernel

viewpoint?

> +		when it is non-idle, for example, by forcing user and
> +		kernel threads as well as interrupts to execute elsewhere.
> +2.	Enable RCU to do its processing remotely via dyntick-idle by
> +	doing all of the following:
> +	a.	Build with CONFIG_NO_HZ=y and CONFIG_RCU_FAST_NO_HZ=y.
> +	b.	To the extent possible, keep the CPU out of the kernel

viewpoint?

> +		when it is non-idle, for example, by forcing user and
> +		kernel threads as well as interrupts to execute elsewhere.
> +	c.	Ensure that the CPU goes idle frequently, allowing other
> +		CPUs to detect that it has passed through an RCU
> +		quiescent state.
> +
> +Name: rcuc/%u
> +Purpose: Execute RCU callbacks in CONFIG_RCU_BOOST=y kernels.
> +To reduce corresponding OS jitter, do at least one of the following:
> +1.	Build the kernel with CONFIG_PREEMPT=n.  This prevents these
> +	kthreads from being created in the first place, and also prevents
> +	RCU priority boosting from ever being required.  This approach
> +	is feasible for workloads that do not require high degrees of
> +	responsiveness.
> +2.	Build the kernel with CONFIG_RCU_BOOST=n.  This prevents these
> +	kthreads from being created in the first place.  This approach
> +	is feasible only if your workload never requires RCU priority
> +	boosting, for example, if you ensure ample idle time on all CPUs
> +	that might execute within the kernel.
> +3.	Build with CONFIG_RCU_NOCB_CPU=y and CONFIG_RCU_NOCB_CPU_ALL=y,
> +	which offloads all RCU callbacks to kthreads that can be moved
> +	off of CPUs susceptible to OS jitter.  This approach prevents the
> +	rcuc/%u kthreads from having any work to do, and are therefore
> +	never awakened.
> +4.	Ensure that then CPU never enters the kernel and avoid any

	            the
viewpoint?

> +	CPU hotplug operations.  This is another way of preventing any
> +	callbacks from being queued on the CPU, again preventing the
> +	rcuc/%u kthreads from having any work to do.
> +
> +Name: rcuob/%d, rcuop/%d, and rcuos/%d
> +Purpose: Offload RCU callbacks from the corresponding CPU.
> +To reduce corresponding OS jitter, do at least one of the following:
> +1.	Use affinity, cgroups, or other mechanism to force these kthreads
> +	to execute on some other CPU.
> +2.	Build with CONFIG_RCU_NOCB_CPUS=n, which will prevent these
> +	kthreads from being created in the first place.  However,
> +	please note that this will not eliminate the corresponding
> +	OS jitter, but will instead merely shift it to softirq.
> +
> +Name: watchdog/%u
> +Purpose: Detect software lockups on each CPU.
> +To reduce corresponding OS jitter, do at least one of the following:
> +1.	Build with CONFIG_LOCKUP_DETECTOR=n, which will prevent these
> +	kthreads from being created in the first place.
> +2.	Echo a zero to /proc/sys/kernel/watchdog to disable the
> +	watchdog timer.
> +3.	Echo a large number of /proc/sys/kernel/watchdog_thresh in
> +	order to reduce the frequency of OS jitter due to the watchdog
> +	timer down to a level that is acceptable for your workload.
>


Reviewed-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
