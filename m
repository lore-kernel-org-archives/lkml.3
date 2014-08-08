Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaHHSgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:36:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaHHSf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:35:59 -0400
Date: Sat, 9 Aug 2014 00:04:24 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140808183424.GB13483@grmbl.mre>
References: <20140707224841.GA10101@linux.vnet.ibm.com>
 <1405085703-14822-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53E48D18.8080007@redhat.com>
 <20140808162502.GX5821@linux.vnet.ibm.com>
 <20140808173710.GA13483@grmbl.mre>
 <20140808181835.GD5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808181835.GD5821@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 08 Aug 2014 [11:18:35], Paul E. McKenney wrote:
> On Fri, Aug 08, 2014 at 11:07:10PM +0530, Amit Shah wrote:
> > On (Fri) 08 Aug 2014 [09:25:02], Paul E. McKenney wrote:
> > > On Fri, Aug 08, 2014 at 02:10:56PM +0530, Amit Shah wrote:
> > > > On Friday 11 July 2014 07:05 PM, Paul E. McKenney wrote:
> > > > >From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > >
> > > > >An 80-CPU system with a context-switch-heavy workload can require so
> > > > >many NOCB kthread wakeups that the RCU grace-period kthreads spend several
> > > > >tens of percent of a CPU just awakening things.  This clearly will not
> > > > >scale well: If you add enough CPUs, the RCU grace-period kthreads would
> > > > >get behind, increasing grace-period latency.
> > > > >
> > > > >To avoid this problem, this commit divides the NOCB kthreads into leaders
> > > > >and followers, where the grace-period kthreads awaken the leaders each of
> > > > >whom in turn awakens its followers.  By default, the number of groups of
> > > > >kthreads is the square root of the number of CPUs, but this default may
> > > > >be overridden using the rcutree.rcu_nocb_leader_stride boot parameter.
> > > > >This reduces the number of wakeups done per grace period by the RCU
> > > > >grace-period kthread by the square root of the number of CPUs, but of
> > > > >course by shifting those wakeups to the leaders.  In addition, because
> > > > >the leaders do grace periods on behalf of their respective followers,
> > > > >the number of wakeups of the followers decreases by up to a factor of two.
> > > > >Instead of being awakened once when new callbacks arrive and again
> > > > >at the end of the grace period, the followers are awakened only at
> > > > >the end of the grace period.
> > > > >
> > > > >For a numerical example, in a 4096-CPU system, the grace-period kthread
> > > > >would awaken 64 leaders, each of which would awaken its 63 followers
> > > > >at the end of the grace period.  This compares favorably with the 79
> > > > >wakeups for the grace-period kthread on an 80-CPU system.
> > > > >
> > > > >Reported-by: Rik van Riel <riel@redhat.com>
> > > > >Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > This patch causes KVM guest boot to not proceed after a while.
> > > > .config is attached, and boot messages are appeneded.  This commit
> > > > was pointed to by bisect, and reverting on current master (while
> > > > addressing a trivial conflict) makes the boot work again.
> > > > 
> > > > The qemu cmdline is
> > > > 
> > > > ./x86_64-softmmu/qemu-system-x86_64 -m 512 -smp 2 -cpu
> > > > host,+kvmclock,+x2apic -enable-kvm  -kernel
> > > > ~/src/linux/arch/x86/boot/bzImage /guests/f11-auto.qcow2  -append
> > > > 'root=/dev/sda2 console=ttyS0 console=tty0' -snapshot -serial stdio
> > > 
> > > I cannot reproduce this.  I am at commit a7d7a143d0b4c, in case that
> > > makes a difference.
> > 
> > Yea; I'm at that commit too.  And the version of qemu doesn't matter;
> > happens on F20's qemu-kvm-1.6.2-7.fc20.x86_64 as well as qemu.git
> > compiled locally.
> > 
> > > There are some things in your dmesg that look quite strange to me, though.
> > > 
> > > You have "--smp 2" above, but in your dmesg I see the following:
> > > 
> > > 	[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4
> > > 	nr_cpu_ids:1 nr_node_ids:1
> > > 
> > > So your run somehow only has one CPU.  RCU agrees that there is only
> > > one CPU:
> > 
> > Yea; indeed.  There are MTRR warnings too; attaching the boot log of
> > failed run and diff to the successful run (rcu-good-notime.txt).
> 
> My qemu runs don't have those MTRR warnings, for whatever that is worth.
> 
> > The failed run is on commit a7d7a143d0b4cb1914705884ca5c25e322dba693
> > and the successful run has these reverted on top:
> > 
> > 187497fa5e9e9383820d33e48b87f8200a747c2a
> > b58cc46c5f6b57f1c814e374dbc47176e6b4938e
> > fbce7497ee5af800a1c350c73f3c3f103cb27a15
> 
> OK.  Strange set of commits.

The last one is the one that causes the failure, the above two are
just the context fixups needed for a clean revert of the last one.

> > That is rcu-bad-notime.txt.
> > 
> > > 	[    0.000000] Preemptible hierarchical RCU implementation.
> > > 	[    0.000000] 	RCU debugfs-based tracing is enabled.
> > > 	[    0.000000] 	RCU lockdep checking is enabled.
> > > 	[    0.000000] 	Additional per-CPU info printed with stalls.
> > > 	[    0.000000] 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
> > > 	[    0.000000] 	Offload RCU callbacks from all CPUs
> > > 	[    0.000000] 	Offload RCU callbacks from CPUs: 0.
> > > 	[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
> > > 	[    0.000000] NO_HZ: Full dynticks CPUs: 1-3.
> > > 
> > > But NO_HZ thinks that there are four.  This appears to be due to NO_HZ
> > > looking at the compile-time constants, and I doubt that this would cause
> > > a problem.  But if there really is a CPU 1 that RCU doesn't know about,
> > > and it queues a callback, that callback will never be invoked, and you
> > > could easily see hangs.
> > > 
> > > Give that your .config says CONFIG_NR_CPUS=4 and your qemu says "--smp 2",
> > > why does nr_cpu_ids think that there is only one CPU?  Are you running
> > > this on a non-x86_64 CPU so that qemu only does UP or some such?
> > 
> > No; this is "Intel(R) Core(TM) i7-2640M CPU @ 2.80GHz" on a ThinkPad
> > T420s.
> 
> Running in 64-bit mode, right?

Yep.  3.15.7-200.fc20.x86_64 on the host.

> > In my attached boot logs, RCU does detect two cpus.  Here's the diff
> > between them.  I recompiled to remove the timing info so the diffs are
> > comparable:

<snip>

> >  mtrr: your CPUs had inconsistent MTRRdefType settings
> >  mtrr: probably your BIOS does not setup all CPUs.
> >  mtrr: corrected configuration.
> > +ACPI: Added _OSI(Module Device)
> > +ACPI: Added _OSI(Processor Device)
> > +ACPI: Added _OSI(3.0 _SCP Extensions)
> > +ACPI: Added _OSI(Processor Aggregator Device)
> > +ACPI: Interpreter enabled
> > +ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
> > +ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
> > +ACPI: (supports S0 S3 S4 S5)
> > +ACPI: Using IOAPIC for interrupt routing
> > +PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> > +ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> > +acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
> > +acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> > 
> > <followed by more bootup messages>
> 
> Hmmm... What happens if you boot a7d7a143d0b4cb1914705884ca5c25e322dba693
> with the kernel parameter "acpi=off"?

That doesn't change anything - still hangs.

I intend to look at this more on Monday, though - turning in for
today.  In the meantime, if there's anything else you'd like me to
try, please let me know.

Thanks,
		Amit
