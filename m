Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbaAVNPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:15:03 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:50117 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbaAVNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:15:00 -0500
Date: Wed, 22 Jan 2014 14:14:56 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122131456.GA389@x4>
References: <20131212140835.729222186@infradead.org>
 <20131212141655.362219382@infradead.org>
 <52DEF495.2020304@oracle.com>
 <20140122104532.GJ31570@twins.programming.kicks-ass.net>
 <20140122120048.GB389@x4>
 <20140122120757.GL31570@twins.programming.kicks-ass.net>
 <20140122122609.GA392@x4>
 <20140122123022.GN31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140122123022.GN31570@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.01.22 at 13:30 +0100, Peter Zijlstra wrote:
> On Wed, Jan 22, 2014 at 01:26:09PM +0100, Markus Trippelsdorf wrote:
> > On 2014.01.22 at 13:07 +0100, Peter Zijlstra wrote:
> > > On Wed, Jan 22, 2014 at 01:00:48PM +0100, Markus Trippelsdorf wrote:
> > > > FYI it happens on real hardware on my machine:
> > > > ...
> > > > [    0.000000] Hierarchical RCU implementation.
> > > > [    0.000000] NR_IRQS:4352 nr_irqs:712 16
> > > > [    0.000000] spurious 8259A interrupt: IRQ7.
> > > > [    0.000000] Console: colour VGA+ 80x25
> > > > [    0.000000] console [tty0] enabled
> > > > [    0.000000] hpet clockevent registered
> > > > [    0.000000] tsc: Fast TSC calibration using PIT
> > > > [    0.003333] tsc: Detected 3210.681 MHz processor
> > > > [   60.375238] Calibrating delay loop (skipped), value calculated using timer frequency.. 6423.91 BogoMIPS (lpj=10702270)
> > > > [   60.375240] pid_max: default: 32768 minimum: 301
> > > > [   60.375259] Mount-cache hash table entries: 256
> > > > [   60.375373] tseg: 0000000000
> > > > [   60.375377] CPU: Physical Processor ID: 0
> > > > [   60.375377] CPU: Processor Core ID: 0
> > > > [   60.375378] mce: CPU supports 6 MCE banks
> > > > [   60.375382] LVT offset 0 assigned for vector 0xf9
> > > > [   60.375384] process: using AMD E400 aware idle routine
> > > > [   60.375386] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
> > > 
> > > Should have always happened like that I think. From the log it looks
> > > like the moment we switch from jiffies to actual TSC in
> > > arch/x86/kernel/tsc.c:sched_clock().
> > > 
> > > I don't think I changed the logic there, just switched from a condition
> > > to a jump_label.
> > 
> > Well, v3.13 was fine. So it's definitely a regression. But it may be
> > another issue. I will try to bisect later.
> 
> OK, weird, I'll see if I can spot anything.

Unfortunately the issue is unbisectable (but the remaining commits are
all yours):

git bisect start
# bad: [df32e43a54d04eda35d2859beaf90e3864d53288] Merge branch 'akpm' (incoming from Andrew)
git bisect bad df32e43a54d04eda35d2859beaf90e3864d53288
# good: [d8ec26d7f8287f5788a494f56e8814210f0e64be] Linux 3.13
git bisect good d8ec26d7f8287f5788a494f56e8814210f0e64be
# bad: [de4fe30af1620b5117d65489621a5037913e7a92] Merge tag 'staging-3.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect bad de4fe30af1620b5117d65489621a5037913e7a92
# good: [2783980525df12b9c49e8b4baaff06abc7f2f8f2] staging: comedi: usbduxsigma: removing unneccesay attached info
git bisect good 2783980525df12b9c49e8b4baaff06abc7f2f8f2
# good: [9326657abe1a83ed4b4f396b923ca1217fd50cba] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 9326657abe1a83ed4b4f396b923ca1217fd50cba
# bad: [82b51734b4f228c76b6064b6e899d9d3d4c17c1a] Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
git bisect bad 82b51734b4f228c76b6064b6e899d9d3d4c17c1a
# bad: [5d4863e4cc4dc12d1d5e42da3cb5d38c535e4ad6] Merge branch 'x86-cpu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 5d4863e4cc4dc12d1d5e42da3cb5d38c535e4ad6
# bad: [a0fa1dd3cdbccec9597fe53b6177a9aa6e20f2f8] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad a0fa1dd3cdbccec9597fe53b6177a9aa6e20f2f8
# good: [0aeeeebac8d8304501680f12862784341f4bee7b] sched: Remove unused parameter from nohz_balancer_kick()
git bisect good 0aeeeebac8d8304501680f12862784341f4bee7b
# bad: [c9c8986847d2f4fc474c10ee08afa57e7474096d] Merge branch 'x86/idle' into sched/core
git bisect bad c9c8986847d2f4fc474c10ee08afa57e7474096d
# skip: [20d1c86a57762f0a33a78988e3fc8818316badd4] sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs
git bisect skip 20d1c86a57762f0a33a78988e3fc8818316badd4
# skip: [35af99e646c7f7ea46dc2977601e9e71a51dadd5] sched/clock, x86: Use a static_key for sched_clock_stable
git bisect skip 35af99e646c7f7ea46dc2977601e9e71a51dadd5
# good: [7d590cca7cd2cce4ed7c47d221d6f90566653ba8] x86, idle: Add memory barriers around clflush in mwait_play_dead()
git bisect good 7d590cca7cd2cce4ed7c47d221d6f90566653ba8
# skip: [57c67da274f3fab38e08d2c9edf08b89e1d9c71d] sched/clock, x86: Move some cyc2ns() code around
git bisect skip 57c67da274f3fab38e08d2c9edf08b89e1d9c71d
# good: [c726099ec224be8078d91072207053ff9a1ad6fc] sched: Factor out the on_null_domain() checks in trigger_load_balance()
git bisect good c726099ec224be8078d91072207053ff9a1ad6fc
# skip: [ef08f0fff87630d4f67ceb09514d8b444df833f8] sched/clock: Remove local_irq_disable() from the clocks
git bisect skip ef08f0fff87630d4f67ceb09514d8b444df833f8
# skip: [62b94a08da1bae9d187d49dfcd6665af393750f8] sched/preempt: Take away preempt_enable_no_resched() from modules
git bisect skip 62b94a08da1bae9d187d49dfcd6665af393750f8
# skip: [5dd12c2152743747ca9f50ef80281e54cc416dc0] sched/clock, x86: Use mul_u64_u32_shr() for native_sched_clock()
git bisect skip 5dd12c2152743747ca9f50ef80281e54cc416dc0
# skip: [10b033d434c25a6c9e0f4f4dc2418af1b8236c63] sched/clock, x86: Avoid a runtime condition in native_sched_clock()
git bisect skip 10b033d434c25a6c9e0f4f4dc2418af1b8236c63
# skip: [6577e42a3e1633afe762f47da9e00061ee4b9a5e] sched/clock: Fix up clear_sched_clock_stable()
git bisect skip 6577e42a3e1633afe762f47da9e00061ee4b9a5e
# bad: [0bd3a173d711857fc9f583eb5825386cc08f3948] sched/preempt, locking: Rework local_bh_{dis,en}able()
git bisect bad 0bd3a173d711857fc9f583eb5825386cc08f3948
# skip: [9ea4c380066fbe23fe0da7f4abfabc444f2467f4] locking: Optimize lock_bh functions
git bisect skip 9ea4c380066fbe23fe0da7f4abfabc444f2467f4
# only skipped commits left to test
# possible first bad commit: [0bd3a173d711857fc9f583eb5825386cc08f3948] sched/preempt, locking: Rework local_bh_{dis,en}able()
# possible first bad commit: [10b033d434c25a6c9e0f4f4dc2418af1b8236c63] sched/clock, x86: Avoid a runtime condition in native_sched_clock()
# possible first bad commit: [6577e42a3e1633afe762f47da9e00061ee4b9a5e] sched/clock: Fix up clear_sched_clock_stable()
# possible first bad commit: [35af99e646c7f7ea46dc2977601e9e71a51dadd5] sched/clock, x86: Use a static_key for sched_clock_stable
# possible first bad commit: [ef08f0fff87630d4f67ceb09514d8b444df833f8] sched/clock: Remove local_irq_disable() from the clocks
# possible first bad commit: [20d1c86a57762f0a33a78988e3fc8818316badd4] sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs
# possible first bad commit: [57c67da274f3fab38e08d2c9edf08b89e1d9c71d] sched/clock, x86: Move some cyc2ns() code around
# possible first bad commit: [5dd12c2152743747ca9f50ef80281e54cc416dc0] sched/clock, x86: Use mul_u64_u32_shr() for native_sched_clock()
# possible first bad commit: [62b94a08da1bae9d187d49dfcd6665af393750f8] sched/preempt: Take away preempt_enable_no_resched() from modules
# possible first bad commit: [9ea4c380066fbe23fe0da7f4abfabc444f2467f4] locking: Optimize lock_bh functions

I've skipped the commits because of compile errors:

make[1]: Nothing to be done for 'all'.
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
make[1]: Nothing to be done for 'relocs'.
  CHK     include/generated/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from include/linux/spinlock.h:271:0,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets.c:8:
include/linux/spinlock_api_smp.h: In function ‘__raw_spin_lock_bh’:
include/linux/spinlock_api_smp.h:134:2: error: implicit declaration of function ‘__local_bh_disable_ip’ [-Werror=implicit-function-declaration]
  __local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
  ^
include/linux/spinlock_api_smp.h:134:34: error: ‘SOFTIRQ_LOCK_OFFSET’ undeclared (first use in this function)
  __local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
                                  ^
include/linux/spinlock_api_smp.h:134:34: note: each undeclared identifier is reported only once for each function it appears in
include/linux/spinlock_api_smp.h: In function ‘__raw_spin_unlock_bh’:
include/linux/spinlock_api_smp.h:176:2: error: implicit declaration of function ‘__local_bh_enable_ip’ [-Werror=implicit-function-declaration]
  __local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
  ^
include/linux/spinlock_api_smp.h:176:33: error: ‘SOFTIRQ_LOCK_OFFSET’ undeclared (first use in this function)
  __local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
                                 ^
include/linux/spinlock_api_smp.h: In function ‘__raw_spin_trylock_bh’:
include/linux/spinlock_api_smp.h:181:34: error: ‘SOFTIRQ_LOCK_OFFSET’ undeclared (first use in this function)
  __local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
                                  ^
In file included from include/linux/spinlock_api_smp.h:190:0,
                 from include/linux/spinlock.h:271,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets.c:8:
include/linux/rwlock_api_smp.h: In function ‘__raw_read_lock_bh’:
include/linux/rwlock_api_smp.h:175:34: error: ‘SOFTIRQ_LOCK_OFFSET’ undeclared (first use in this function)
  __local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
                                  ^
include/linux/rwlock_api_smp.h: In function ‘__raw_write_lock_bh’:
include/linux/rwlock_api_smp.h:202:34: error: ‘SOFTIRQ_LOCK_OFFSET’ undeclared (first use in this function)
  __local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
                                  ^
include/linux/rwlock_api_smp.h: In function ‘__raw_read_unlock_bh’:
include/linux/rwlock_api_smp.h:251:33: error: ‘SOFTIRQ_LOCK_OFFSET’ undeclared (first use in this function)
  __local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
                                 ^
include/linux/rwlock_api_smp.h: In function ‘__raw_write_unlock_bh’:
include/linux/rwlock_api_smp.h:275:33: error: ‘SOFTIRQ_LOCK_OFFSET’ undeclared (first use in this function)
  __local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
                                 ^
cc1: some warnings being treated as errors
/usr/src/linux/./Kbuild:81: recipe for target 'arch/x86/kernel/asm-offsets.s' failed
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
Makefile:859: recipe for target 'prepare0' failed
make: *** [prepare0] Error 2

-- 
Markus
