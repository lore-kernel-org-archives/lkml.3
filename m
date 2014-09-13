Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaIMBKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 21:10:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34518 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaIMBKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 21:10:22 -0400
Message-ID: <5413997B.40301@infradead.org>
Date: Fri, 12 Sep 2014 18:10:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>, paulmck@linux.vnet.ibm.com
CC: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 2/9] locktorture: Add documentation
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net> <1410493224-3312-3-git-send-email-dave@stgolabs.net>
In-Reply-To: <1410493224-3312-3-git-send-email-dave@stgolabs.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/14 20:40, Davidlohr Bueso wrote:
> Just like Documentation/RCU/torture.txt, begin a document for the
> locktorture module. This module is still pretty green, so I have
> just added some specific sections to the doc (general desc, params,
> usage, etc.). Further development should update the file.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  Documentation/locking/locktorture.txt | 128 ++++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
>  create mode 100644 Documentation/locking/locktorture.txt
> 
> diff --git a/Documentation/locking/locktorture.txt b/Documentation/locking/locktorture.txt
> new file mode 100644
> index 0000000..c0ab969
> --- /dev/null
> +++ b/Documentation/locking/locktorture.txt
> @@ -0,0 +1,128 @@
> +Kernel Lock Torture Test Operation
> +
> +CONFIG_LOCK_TORTURE_TEST
> +
> +The CONFIG LOCK_TORTURE_TEST config option provides a kernel module
> +that runs torture tests on core kernel locking primitives. The kernel
> +module, 'locktorture', may be built after the fact on the running
> +kernel to be tested, if desired. The tests periodically outputs status

                                                           output

> +messages via printk(), which can be examined via the dmesg (perhaps
> +grepping for "torture").  The test is started when the module is loaded,
> +and stops when the module is unloaded. This program is based on how RCU
> +is tortured, via rcutorture.
> +
> +This torture test consists of creating a number of kernel threads which
> +acquires the lock and holds it for specific amount of time, thus simulating

   acquire               hold

> +different critical region behaviors. The amount of contention on the lock
> +can be simulated by either enlarging this critical region hold time and/or
> +creating more kthreads.
> +
> +
> +MODULE PARAMETERS
> +
> +This module has the following parameters:
> +
> +
> +	    ** Locktorture-specific **
> +
> +nwriters_stress   Number of kernel threads that will stress exclusive lock
> +		  ownership (writers). The default value is twice the amount

I would s/amount/number/ but that's minor.

> +		  of online CPUs.
> +
> +torture_type	  Type of lock to torture. By default, only spinlocks will
> +		  be tortured. This module can torture the following locks,
> +		  with string values as follows:
> +
> +		     o "lock_busted": Simulates a buggy lock implementation.
> +
> +		     o "spin_lock": spin_lock() and spin_unlock() pairs.
> +
> +		     o "spin_lock_irq": spin_lock_irq() and spin_unlock_irq()
> +					pairs.
> +
> +torture_runnable  Start locktorture at module init. By default it will begin
> +		  once the module is loaded.

What differences would that make?

> +
> +
> +	    ** Torture-framework (RCU + locking) **
> +
> +shutdown_secs	  The number of seconds to run the test before terminating
> +		  the test and powering off the system.  The default is
> +		  zero, which disables test termination and system shutdown.
> +		  This capability is useful for automated testing.
> +
> +onoff_holdoff	  The number of seconds between each attempt to execute a
> +		  randomly selected CPU-hotplug operation.  Defaults to
> +		  zero, which disables CPU hotplugging.  In HOTPLUG_CPU=n

s/HOTPLUG_CPU/CONFIG_HOTPLUG_CPU/ to be consistent.

> +		  kernels, locktorture will silently refuse to do any
> +		  CPU-hotplug operations regardless of what value is
> +		  specified for onoff_interval.

eh?  what is                    onoff_interval ?

Oh, the param name (in leftmost column) above should be onoff_interval since
onoff_holdoff is below.

> +
> +onoff_holdoff	  The number of seconds to wait until starting CPU-hotplug
> +		  operations.  This would normally only be used when
> +		  locktorture was built into the kernel and started
> +		  automatically at boot time, in which case it is useful
> +		  in order to avoid confusing boot-time code with CPUs
> +		  coming and going. This parameter is only useful if
> +		  CONFIG_HOTPLUG_CPU is enabled.
> +
> +stat_interval	  Number of seconds between statistics-related printk()s.
> +		  By default, locktorture will report stats every 60 seconds.
> +		  Setting the interval to zero causes the statistics to
> +		  be printed -only- when the module is unloaded, and this
> +		  is the default.
> +
> +stutter		  The length of time to run the test before pausing for this
> +		  same period of time.  Defaults to "stutter=5", so as
> +		  to run and pause for (roughly) five-second intervals.
> +		  Specifying "stutter=0" causes the test to run continuously
> +		  without pausing, which is the old default behavior.
> +
> +shuffle_interval  The number of seconds to keep the test threads affinitied
> +		  to a particular subset of the CPUs, defaults to 3 seconds.
> +		  Used in conjunction with test_no_idle_hz.
> +
> +verbose		  Enable verbose debugging printking, via printk(). Enabled

			                           printing

> +		  by default. This extra information is mostly related to
> +		  high-level errors and reports from the main 'torture'
> +		  framework.
> +
> +
> +STATISTICS
> +
> +Statistics are printed in the following format:
> +
> +spin_lock-torture: Writes:  Total: 93746064  Max/Min: 0/0   Fail: 0
> +   (A)				   (B)		  (C)	       (D)
> +
> +(A): Lock type that is being tortured -- torture_type parameter.
> +
> +(B): Number of times the lock was acquired.
> +
> +(C): Min and max number of times threads failed to acquire the lock.
> +
> +(D): true/false values if there were errors acquiring the lock. This should
> +     -only- be positive if there is a bug in the locking primitive's
> +     implementation. Otherwise a lock should never fail (ie: spin_lock()).

                                                           (i.e., spin_lock()).

> +     Of course, the same applies for (C), above. A dummy example of this is
> +     the "lock_busted" type.
> +
> +USAGE
> +
> +The following script may be used to torture locks:
> +
> +	#!/bin/sh
> +
> +	modprobe locktorture
> +	sleep 3600
> +	rmmod locktorture
> +	dmesg | grep torture:
> +
> +The output can be manually inspected for the error flag of "!!!".
> +One could of course create a more elaborate script that automatically
> +checked for such errors.  The "rmmod" command forces a "SUCCESS",
> +"FAILURE", or "RCU_HOTPLUG" indication to be printk()ed.  The first
> +two are self-explanatory, while the last indicates that while there
> +were no locking failures, CPU-hotplug problems were detected.
> +
> +Also see: Documentation/RCU/torture.txt
> 


-- 
~Randy
