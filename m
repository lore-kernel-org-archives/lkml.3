Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbaBFMTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:19:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47445 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbaBFMTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:19:12 -0500
Date: Thu, 6 Feb 2014 13:19:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched/preempt] INFO: rcu_sched self-detected stall on CPU { 1}
Message-ID: <20140206121906.GJ4941@twins.programming.kicks-ass.net>
References: <20140206095646.GE17971@localhost>
 <20140206112731.GH4941@twins.programming.kicks-ass.net>
 <20140206114635.GA27429@localhost>
 <1391688533.8136.8.camel@po-d-abo-ubu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391688533.8136.8.camel@po-d-abo-ubu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 12:08:54PM +0000, Bockholdt Arne wrote:
> Hi all,
> 
> I've got the same problem with unpatched vanilla 3.13.x kernel on a KVM
> host. Here's a snippet from the dmesg output : 
> 
> 
> [ 3928.132061] INFO: rcu_sched self-detected stall on CPU { 0}  (t=15000 jiffies g=55807 c=55806 q=1257)
> [ 3928.132200] sending NMI to all CPUs:
> [ 3928.132206] NMI backtrace for cpu 0
> [ 3928.132211] CPU: 0 PID: 2218 Comm: qemu-system-x86 Tainted: GF            3.13.1 #24
> [ 3928.132304] Hardware name: Supermicro A1SAi/A1SRi, BIOS 1.0b 11/06/2013
> [ 3928.132384] task: e9889a00 ti: f758e000 task.ti: f758e000
> [ 3928.132449] EIP: 0060:[<c130abda>] EFLAGS: 00000086 CPU: 0
> [ 3928.132457] EIP is at __const_udelay+0xa/0x20
> [ 3928.132460] EAX: 00418958 EBX: 00002710 ECX: fffff000 EDX: 00931eac
> [ 3928.132462] ESI: c194da80 EDI: f7b7e900 EBP: f758fc6c ESP: f758fc6c
> [ 3928.132465]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [ 3928.132468] CR0: 80050033 CR2: b769f1d0 CR3: 35f16000 CR4: 001027f0
> [ 3928.132471] Stack:
> [ 3928.132496]  f758fc7c c103c375 c1834bdb c194da80 f758fcc4 c10acc18 c1844a64 00003a98
> [ 3928.132504]  0000d9ff 0000d9fe 000004e9 00000001 00000000 00000000 f758fcbc c19c1e0c
> [ 3928.132511]  c194da80 f7b7e900 00000000 e9889a00 00000000 00000000 f758fcd8 c1060bbc
> [ 3928.132519] Call Trace:
> [ 3928.132556]  [<c103c375>] arch_trigger_all_cpu_backtrace+0x55/0x70
> [ 3928.132562]  [<c10acc18>] rcu_check_callbacks+0x388/0x5a0
> [ 3928.132568]  [<c1060bbc>] update_process_times+0x3c/0x60
> [ 3928.132573]  [<c10b7a96>] tick_sched_handle.isra.12+0x26/0x60
> [ 3928.132577]  [<c10b7b07>] tick_sched_timer+0x37/0x70
> [ 3928.132583]  [<c1074da8>] ? __remove_hrtimer+0x38/0x90
> [ 3928.132587]  [<c1074fef>] __run_hrtimer+0x6f/0x190
> [ 3928.132591]  [<c10b7ad0>] ? tick_sched_handle.isra.12+0x60/0x60
> [ 3928.132595]  [<c1075c15>] hrtimer_interrupt+0x1f5/0x2b0
> [ 3928.132601]  [<c103a4ef>] local_apic_timer_interrupt+0x2f/0x60
> [ 3928.132605]  [<c1058af5>] ? irq_enter+0x15/0x70
> [ 3928.132611]  [<c165fa93>] smp_apic_timer_interrupt+0x33/0x50
> [ 3928.132617]  [<c16583cc>] apic_timer_interrupt+0x34/0x3c
> [ 3928.132632]  [<f95d00e0>] ? vmx_read_guest_seg_base+0x40/0x80 [kvm_intel]
> [ 3928.132636]  [<c10a9760>] ? __srcu_read_unlock+0x10/0x20
> [ 3928.132662]  [<f928c658>] kvm_arch_vcpu_ioctl_run+0x408/0x1080 [kvm]
> [ 3928.132680]  [<f92790eb>] kvm_vcpu_ioctl+0x43b/0x4e0 [kvm]
> [ 3928.132685]  [<c10ba7ad>] ? futex_wake+0x13d/0x160
> [ 3928.132689]  [<c10bb544>] ? do_futex+0xf4/0xae0
> [ 3928.132707]  [<f9278cb0>] ? vcpu_put+0x30/0x30 [kvm]
> [ 3928.132713]  [<c11855c2>] do_vfs_ioctl+0x2e2/0x4d0
> [ 3928.132717]  [<c165b597>] ? __do_page_fault+0x277/0x530
> [ 3928.132722]  [<c10bbfbc>] ? SyS_futex+0x8c/0x140
> [ 3928.132726]  [<c1185810>] SyS_ioctl+0x60/0x80
> [ 3928.132731]  [<c165f2cd>] sysenter_do_call+0x12/0x28
> [ 3928.132733] Code: 00 48 75 fd 48 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 3e 8d 74 26 00 ff 15 50 1f 97 c1 5d c3 55 89 e5 64 8b 15 5c 00 aa c1 <c1> e0 02 6b d2 3e f7 e2 8d 42 01 ff 15 50 1f 97 c1 5d c3 8d 76
> 
> 
> This on a a Intel Rangeley Silvermont Atom 8 core machine running kernel
> 3.13.1/i386 as KVM host with several KVM guests. Tested with the same
> configuration on kernel 3.12.9 and 3.11.6 without the stall. The stall
> is 100% reproducible when the KVM guests are under load.
> Kernel 3.13.1 does NOT contain the patch below AFAIK.

3.13 doesn't include 8cb75e0c4ec9786b81439761eac1d18d4a931af3 either.

can you try a recent linux.git? Also, can you test with a 64bit kernel
too?
