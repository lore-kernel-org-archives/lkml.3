Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaG3Pd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:33:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:2106 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbaG3Pd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:33:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="scan'208";a="569499495"
Date: Wed, 30 Jul 2014 23:33:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xenproject.org
Subject: Re: [x86_64,vsyscall] Kernel panic - not syncing: Attempted to kill
 init! exitcode=0x0000000b
Message-ID: <20140730153315.GA29233@localhost>
References: <20140730142923.GR16537@localhost>
 <CALCETrW2Pygpt8sFWuXtijtcZGxrHcLa8hSFk7ooKvPiU9-M3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CALCETrW2Pygpt8sFWuXtijtcZGxrHcLa8hSFk7ooKvPiU9-M3w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 07:58:13AM -0700, Andy Lutomirski wrote:
> On Wed, Jul 30, 2014 at 7:29 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Greetings,
> >
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/vsyscall
> > commit 442aba0c6131f0c41dfc5edb6bfb88335556523f
> > Author:     Andy Lutomirski <luto@amacapital.net>
> > AuthorDate: Mon Jun 16 18:50:12 2014 -0700
> > Commit:     Andy Lutomirski <luto@amacapital.net>
> > CommitDate: Mon Jun 30 14:32:44 2014 -0700
> 
> Was this a merge?

It's not a merge commit.

> Is there an easy way to see exactly what was tested? 

This script may reproduce the error. Note that it's not 100% reproducible.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
        qemu-system-x86_64
        -cpu kvm64
        -enable-kvm
        -kernel $kernel
        -initrd $initrd
        -m 320
        -smp 1
        -net nic,vlan=1,model=e1000
        -net user,vlan=1
        -boot order=nc
        -no-reboot
        -watchdog i6300esb
        -rtc base=localtime
        -serial stdio
        -display none
        -monitor null
)

append=(
        hung_task_panic=1
        earlyprintk=ttyS0,115200
        debug
        apic=debug
        sysrq_always_enabled
        rcupdate.rcu_cpu_stall_timeout=100
        panic=10
        softlockup_panic=1
        nmi_watchdog=panic
        prompt_ramdisk=0
        console=ttyS0,115200
        console=tty0
        vga=normal
        root=/dev/ram0
        rw
        drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

> I had a buggy
> commit called "x86: Split syscall_trace_enter
> into two phases" that could have caused this problem.
> 3f649f5658a163645e3ce15156176c325283762e was bad, but
> 714cf438762d342673b3b131d5c90bc69ca921a9 (the newer version of that
> commit) should be okay.  Neither is an ancestor of the commit that the
> bisect identified, though.

Yeah that patch lies in another branch "luto/x86/seccomp-fastpath",
so is not involved in this bug.

Thanks,
Fengguang

> >     x86_64,vsyscall: Make vsyscall emulation configurable
> >
> >     This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
> >     Turning it off completely disables vsyscall emulation, saving ~3.5k
> >     for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
> >     page), some tiny amount of core mm code that supports a gate area,
> >     and possibly 4k for a wasted pagetable.  The latter is because the
> >     vsyscall addresses are misaligned and fit poorly in the fixmap.
> >
> >     Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >
> > ===================================================
> > PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> > ===================================================
> > Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
> >
> > +-----------------------------------------------------------+------------+------------+------------------+
> > |                                                           | e1656ab2ad | 442aba0c61 | v3.16-rc4_071018 |
> > +-----------------------------------------------------------+------------+------------+------------------+
> > | boot_successes                                            | 1160       | 99         | 3                |
> > | boot_failures                                             | 160        | 231        | 8                |
> > | BUG:kernel_boot_hang                                      | 160        | 51         | 2                |
> > | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 0          | 180        | 6                |
> > | INFO:suspicious_RCU_usage                                 | 0          | 180        | 6                |
> > +-----------------------------------------------------------+------------+------------+------------------+
> >
> > mount: can't read '/proc/mounts': No such file or directory
> > [   33.736413] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 00007fff2894a8a8 error 15
> > [   33.737608] init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp 00007fff28949eb8 error 15
> > [   33.739046] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> > [   33.739046]
> > [   33.740015] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc3-00010-g442aba0 #4
> > [   33.740015]  0000000000000000 ffff880000033cc0 ffffffff81ff485f ffff880000033d38
> > [   33.740015]  ffffffff81ff1342 ffff880000000010 ffff880000033d48 ffff880000033ce8
> > [   33.740015]  ffffffff82c440c0 000000000000000b 8c6318c6318c6320 00000007db00a678
> > [   33.740015] Call Trace:
> > [   33.740015]  [<ffffffff81ff485f>] dump_stack+0x19/0x1b
> > [   33.740015]  [<ffffffff81ff1342>] panic+0xcb/0x1fb
> > [   33.740015]  [<ffffffff81093b2f>] do_exit+0x3dd/0x80f
> > [   33.740015]  [<ffffffff810b071d>] ? local_clock+0x14/0x1d
> > [   33.740015]  [<ffffffff81094002>] do_group_exit+0x75/0xb4
> > [   33.740015]  [<ffffffff8109c7e7>] get_signal_to_deliver+0x48a/0x4aa
> > [   33.740015]  [<ffffffff8100231a>] do_signal+0x43/0x5ba
> > [   33.740015]  [<ffffffff810b4b79>] ? lock_release_holdtime+0x6c/0x77
> > [   33.740015]  [<ffffffff810b83b5>] ? lock_release_non_nested+0xd0/0x21e
> > [   33.740015]  [<ffffffff810b0646>] ? sched_clock_cpu+0x4e/0x62
> > [   33.740015]  [<ffffffff810fd465>] ? might_fault+0x4f/0x9c
> > [   33.740015]  [<ffffffff810b6163>] ? trace_hardirqs_off_caller+0x36/0xa5
> > [   33.740015]  [<ffffffff82004298>] ? retint_signal+0x11/0x99
> > [   33.740015]  [<ffffffff810028b5>] do_notify_resume+0x24/0x53
> > [   33.740015]  [<ffffffff820042d4>] retint_signal+0x4d/0x99
> > [   33.740015] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> > [   33.740015] drm_kms_helper: panic occurred, switching back to text console
> > [   33.740015]
> > [   33.740015] ===============================
> > [   33.740015] [ INFO: suspicious RCU usage. ]
> > [   33.740015] 3.16.0-rc3-00010-g442aba0 #4 Not tainted
> > [   33.740015] -------------------------------
> > [   33.740015] include/linux/rcupdate.h:539 Illegal context switch in RCU read-side critical section!
> > [   33.740015]
> > [   33.740015] other info that might help us debug this:
> > [   33.740015]
> > [   33.740015]
> > [   33.740015] rcu_scheduler_active = 1, debug_locks = 0
> > [   33.740015] 3 locks held by init/1:
> > [   33.740015]  #0:  (panic_lock){....+.}, at: [<ffffffff81ff12ba>] panic+0x43/0x1fb
> > [   33.740015]  #1:  (rcu_read_lock){......}, at: [<ffffffff810ab879>] rcu_lock_acquire+0x0/0x23
> > [   33.740015]  #2:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff814a74d7>] drm_fb_helper_panic+0x5d/0xab
> > [   33.740015]
> > [   33.740015] stack backtrace:
> > [   33.740015] CPU: 0 PID: 1 Comm: init Not tainted 3.16.0-rc3-00010-g442aba0 #4
> > [   33.740015]  0000000000000000 ffff8800000339d0 ffffffff81ff485f ffff880000033a00
> > [   33.740015]  ffffffff810b8824 ffffffff82836248 000000000000024a 0000000000000000
> > [   33.740015]  ffff88001012e008 ffff880000033a10 ffffffff810adce3 ffff880000033a38
> > [   33.740015] Call Trace:
> > [   33.740015]  [<ffffffff81ff485f>] dump_stack+0x19/0x1b
> > [   33.740015]  [<ffffffff810b8824>] lockdep_rcu_suspicious+0xf6/0xff
> > [   33.740015]  [<ffffffff810adce3>] rcu_preempt_sleep_check+0x45/0x47
> > [   33.740015]  [<ffffffff810afedf>] __might_sleep+0x17/0x19a
> > [   33.740015]  [<ffffffff8200019e>] mutex_lock_nested+0x2e/0x369
> > [   33.740015]  [<ffffffff810b8657>] ? lock_release+0x154/0x185
> > [   33.740015]  [<ffffffff810b61df>] ? trace_hardirqs_off+0xd/0xf
> > [   33.740015]  [<ffffffff814b4ad3>] _object_find+0x25/0x6c
> > [   33.740015]  [<ffffffff814b5283>] drm_mode_object_find+0x38/0x53
> > [   33.740015]  [<ffffffff81593f6e>] cirrus_connector_best_encoder+0x21/0x2f
> > [   33.740015]  [<ffffffff814a5382>] drm_crtc_helper_set_config+0x38c/0x83c
> > [   33.740015]  [<ffffffff814b6c44>] drm_mode_set_config_internal+0x53/0xca
> > [   33.740015]  [<ffffffff814a731f>] restore_fbdev_mode+0x91/0xad
> > [   33.740015]  [<ffffffff814a74e3>] drm_fb_helper_panic+0x69/0xab
> > [   33.740015]  [<ffffffff810ab92c>] notifier_call_chain+0x61/0x8b
> > [   33.740015]  [<ffffffff810aba4f>] __atomic_notifier_call_chain+0x7e/0xe6
> > [   33.740015]  [<ffffffff810abac6>] atomic_notifier_call_chain+0xf/0x11
> > [   33.740015]  [<ffffffff81ff1367>] panic+0xf0/0x1fb
> > [   33.740015]  [<ffffffff81093b2f>] do_exit+0x3dd/0x80f
> > [   33.740015]  [<ffffffff810b071d>] ? local_clock+0x14/0x1d
> > [   33.740015]  [<ffffffff81094002>] do_group_exit+0x75/0xb4
> > [   33.740015]  [<ffffffff8109c7e7>] get_signal_to_deliver+0x48a/0x4aa
> > [   33.740015]  [<ffffffff8100231a>] do_signal+0x43/0x5ba
> > [   33.740015]  [<ffffffff810b4b79>] ? lock_release_holdtime+0x6c/0x77
> > [   33.740015]  [<ffffffff810b83b5>] ? lock_release_non_nested+0xd0/0x21e
> > [   33.740015]  [<ffffffff810b0646>] ? sched_clock_cpu+0x4e/0x62
> > [   33.740015]  [<ffffffff810fd465>] ? might_fault+0x4f/0x9c
> > [   33.740015]  [<ffffffff810b6163>] ? trace_hardirqs_off_caller+0x36/0xa5
> > [   33.740015]  [<ffffffff82004298>] ? retint_signal+0x11/0x99
> > [   33.740015]  [<ffffffff810028b5>] do_notify_resume+0x24/0x53
> > [   33.740015]  [<ffffffff820042d4>] retint_signal+0x4d/0x99
> > [   33.740015] Rebooting in 10 seconds..
> > Elapsed time: 40
> > qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb88335556523f/vmlinuz-3.16.0-rc3-00010-g442aba0 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa0-07110255/linux-devel:devel-hourly-2014071018:442aba0c6131f0c41dfc5edb6bfb88335556523f:bisect-linux9/.vmlinuz-442aba0c6131f0c41dfc5edb6bfb88335556523f-20140711073043-10-ivb41 branch=linux-devel/devel-hourly-2014071018 BOOT_IMAGE=/kernel/x86_64-randconfig-hsxa0-07110255/442aba0c6131f0c41dfc5edb6bfb88335556523f/vmlinuz-3.16.0-rc3-00010-g442aba0 drbd.minor_count=8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-yocto-ivb41-17 -serial file:/dev/shm/kboot/serial-yocto-ivb41-17 -daemonize -display none -monitor null
> >
> > git bisect start c80be3ae11770011071103d3e920864c275472a8 cd3de83f147601356395b57a8673e9c5ff1e59d1 --
> > git bisect  bad 6e36d433610a3ebfdef000f1fb283e3f218a8a32  # 20:54      0-     19  Merge 'omap/omap-for-v3.16/fixes' into devel-hourly-2014071018
> > git bisect  bad 14604ab36faba88a89cb2c9611509f5a1c1cac21  # 20:54      0-    222  Merge 'ulf.hansson-mmc/next' into devel-hourly-2014071018
> > git bisect good 9141a68d71aa193f78aac5306fc728fba8fb59f4  # 21:50    330+     94  Merge 'm68k/for-linus' into devel-hourly-2014071018
> > git bisect  bad 13987d1746951b727146fef187406b7be00a3fd0  # 22:12      0-      7  Merge 'luto/x86/vsyscall' into devel-hourly-2014071018
> > git bisect good 7104a2e08de8bddb52d4714fad63d8a7977ea7f2  # 23:19    330+     22  x86_64: Move getcpu code from vsyscall_64.c to vdso/vma.c
> > git bisect good e1656ab2adfd1891f62610abe3e85ad992ee0cbf  # 23:26    330+    113  arm64,ia64,ppc,s390,sh,tile,um,x86,mm: Remove default gate area
> > git bisect  bad 465c34985bb9823bb4536eb6751197f2d295ca32  # 23:29     54-     91  x86,vdso: Set VM_MAYREAD for the vvar vma
> > git bisect  bad 442aba0c6131f0c41dfc5edb6bfb88335556523f  # 23:31      0-     37  x86_64,vsyscall: Make vsyscall emulation configurable
> > # first bad commit: [442aba0c6131f0c41dfc5edb6bfb88335556523f] x86_64,vsyscall: Make vsyscall emulation configurable
> > git bisect good e1656ab2adfd1891f62610abe3e85ad992ee0cbf  # 12:09    990+    160  arm64,ia64,ppc,s390,sh,tile,um,x86,mm: Remove default gate area
> > git bisect  bad c80be3ae11770011071103d3e920864c275472a8  # 12:10      0-      8  0day head guard for 'devel-hourly-2014071018'
> > git bisect good 85d90faed31ec74fb28a450fbc368d982a785924  # 13:11    990+    518  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
> > git bisect good 47cf0ce945c8310228ff2d4bd756e5313f4659c1  # 13:21    990+    418  Add linux-next specific files for 20140710
> >
> >
> >
> > Thanks,
> > Fengguang
> >
> > _______________________________________________
> > LKP mailing list
> > LKP@linux.intel.com
> >
> 
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
