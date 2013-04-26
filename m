Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab3DZUK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:10:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49075 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3DZUKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:10:24 -0400
Subject: Re: Preemptable Ticket Spinlock
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Jiannan Ouyang <ouyang@cs.pitt.edu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
In-Reply-To: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Apr 2013 15:10:09 -0500
Message-ID: <1367007009.13805.41.camel@oc2024037011.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042620-5406-0000-0000-000007F90FD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-20 at 18:12 -0400, Jiannan Ouyang wrote:
> Hello Everyone,
> 
> 
> I recently came up with a spinlock algorithm that can adapt to
> preemption, which you may be interested in. The intuition is to
> downgrade a fair lock to an unfair lock automatically upon preemption,
> and preserve the fairness otherwise. It is a guest side optimization,
> and can be used as a complementary technique to host side
> optimizations like co-scheduling and Pause-Loop Exiting.
> 
> 
> In my experiments, it improves VM performance by 5:32X on average,
> when running on a non paravirtual VMM, and by 7:91X when running on a
> VMM that supports a paravirtual locking interface (using a pv
> preemptable ticket spinlock), when executing a set of microbenchmarks
> as well as a realistic e-commerce benchmark.
> 
> 
> A detailed algorithm description can be found in my VEE 2013 paper,
> Preemptable Ticket Spinlocks: Improving Consolidated Performance in
> the Cloud
> Jiannan Ouyang, John R. Lange
> ouyang,jacklange@cs.pitt.edu
> University of Pittsburgh
> http://people.cs.pitt.edu/~ouyang/files/publication/preemptable_lock-ouyang-vee13.pdf
> 
> 
> The patch is based on stock Linux kernel 3.5.0, and tested on kernel
> 3.4.41 as well.
> http://www.cs.pitt.edu/~ouyang/files/preemptable_lock.tar.gz

Very nice paper.  I wanted to see how this would work on larger VMs on
the dbench workload.  Unfortunately, when I tried your patch on 3.9-rc8
+, I get a lot of CPU soft lockup messages from the VMs, to the point
where the test cannot complete in a reasonable amount of time:


> [ 2144.672812] BUG: soft lockup - CPU#16 stuck for 23s! [dbench:8618]
> [ 2144.672888] Modules linked in: bridge stp llc target_core_mod configfs autofs4 sunrpc af_packet ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod uinput rtc_cmos button crc32c_intel microcode pcspkr virtio_net i2c_piix4 i2c_core intel_agp intel_gtt ext4 mbcache jbd2 crc16 virtio_blk floppy aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul virtio_pci virtio_ring virtio uhci_hcd usbcore usb_common pata_acpi ata_generic piix ide_core ata_piix libata scsi_mod [last unloaded: mperf]
> [ 2144.672892] CPU 16
> [ 2144.672892] Pid: 8618, comm: dbench Not tainted 3.9.0-rc8-soft-ticket-0.27-default+ #3 Bochs Bochs
> [ 2144.672898] RIP: 0010:[<ffffffff814a0c93>]  [<ffffffff814a0c93>] _raw_spin_unlock_irqrestore+0x13/0x20
> [ 2144.672899] RSP: 0018:ffff8807c0203d68  EFLAGS: 00000202
> [ 2144.672901] RAX: 00000000ffffffff RBX: ffff8807c0203ce8 RCX: ffff8807bfe13244
> [ 2144.672902] RDX: 0000000000000001 RSI: 0000000000000202 RDI: 0000000000000202
> [ 2144.672903] RBP: ffff8807c0203d68 R08: 0000000000001774 R09: 0000000000001777
> [ 2144.672904] R10: 0000000000000001 R11: 0000000000ef2400 R12: ffff8807c0203cd8
> [ 2144.672906] R13: ffffffff814aa09d R14: ffff8807c0203d68 R15: 0000000000000000
> [ 2144.672907] FS:  00007f42edc22700(0000) GS:ffff8807c0200000(0000) knlGS:0000000000000000
> [ 2144.672908] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2144.672908] CR2: 00007f021f6bdc30 CR3: 000000079c63b000 CR4: 00000000000006e0
> [ 2144.673131] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2144.673182] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 2144.673184] Process dbench (pid: 8618, threadinfo ffff8807a0394000, task ffff880790c22340)
> [ 2144.673185] Stack:
> [ 2144.673189]  ffff8807c0203e68 ffffffff81086713 0000000000000092 0000000000013240
> [ 2144.673295]  0000000000013240 0000001000000092 0000000000000025 ffff8807c0203ea4
> [ 2144.673300]  ffff8807bf80a280 000000018108265b ffff8807a0c03c00 0000000000000001
> [ 2144.673300] Call Trace:
> [ 2144.673302]  <IRQ>
> [ 2144.673305]  [<ffffffff81086713>] load_balance+0x543/0x630
> [ 2144.673309]  [<ffffffff8108689d>] rebalance_domains+0x9d/0x180
> [ 2144.673311]  [<ffffffff81086b44>] run_rebalance_domains+0x44/0x60
> [ 2144.673315]  [<ffffffff81050376>] __do_softirq+0xd6/0x250
> [ 2144.673318]  [<ffffffff810505f5>] irq_exit+0xb5/0xc0
> [ 2144.673322]  [<ffffffff81027b89>] smp_apic_timer_interrupt+0x69/0xa0
> [ 2144.673325]  [<ffffffff814aa09d>] apic_timer_interrupt+0x6d/0x80
> [ 2144.673327]  <EOI>
> [ 2144.673329]  [<ffffffff814a10d6>] ? _raw_spin_lock+0x66/0x80
> [ 2144.673331]  [<ffffffff81170596>] path_get+0x26/0x40
> [ 2144.673334]  [<ffffffff8117070a>] unlazy_walk+0x10a/0x230
> [ 2144.673337]  [<ffffffff81170a59>] lookup_fast+0x229/0x2d0
> [ 2144.673340]  [<ffffffff81172e13>] path_lookupat+0x123/0x720
> [ 2144.673342]  [<ffffffff8116f663>] ? inode_permission+0x13/0x50
> [ 2144.673344]  [<ffffffff81172438>] ? link_path_walk+0x78/0x450
> [ 2144.673434]  [<ffffffff8117343f>] filename_lookup+0x2f/0xc0
> [ 2144.673438]  [<ffffffff811747d4>] user_path_at_empty+0x54/0xa0
> [ 2144.673441]  [<ffffffff8105c731>] ? group_send_sig_info+0x21/0x60
> [ 2144.673444]  [<ffffffff8105c7aa>] ? kill_pid_info+0x3a/0x60
> [ 2144.673523]  [<ffffffff8117482c>] user_path_at+0xc/0x10
> [ 2144.673529]  [<ffffffff81169c01>] vfs_fstatat+0x51/0xb0
> [ 2144.673532]  [<ffffffff81169d36>] vfs_stat+0x16/0x20
> [ 2144.673534]  [<ffffffff81169d5f>] sys_newstat+0x1f/0x50
> [ 2144.673538]  [<ffffffff810c8af6>] ? __audit_syscall_exit+0x246/0x2f0
> [ 2144.673541]  [<ffffffff810c79bc>] ? __audit_syscall_entry+0x8c/0xf0
> [ 2144.673543]  [<ffffffff814a9429>] system_call_fastpath+0x16/0x1b

This is on a 40 core / 80 thread Westmere-EX with 16 VMs, each VM having
20 vCPUs (so 4x over-commit).  All VMs run dbench in tmpfs, which is a
pretty good test for spinlock preempt problems.  I had PLE enabled for
the test.

When you re-base your patches I will try it again.

Thanks,

-Andrew Theurer



