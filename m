Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3JEXou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 19:44:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:9379 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab3JEXoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 19:44:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1041,1371106800"; 
   d="log'?scan'208";a="405935498"
Date: Sun, 6 Oct 2013 07:44:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131005234430.GA22485@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 0c44c2d0f459cd7e275242b72f500137c4fa834d
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Sep 11 15:19:24 2013 +0200

    x86: Use asm goto to implement better modify_and_test() functions
    
    Linus suggested using asm goto to get rid of the typical SETcc + TEST
    instruction pair -- which also clobbers an extra register -- for our
    typical modify_and_test() functions.
    
    Because asm goto doesn't allow output fields it has to include an
    unconditinal memory clobber when it changes a memory variable to force
    a reload.
    
    Luckily all atomic ops already imply a compiler barrier to go along
    with their memory barrier semantics.
    
    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/n/tip-0mtn9siwbeo1d33bap1422se@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

[    3.336040] Write protecting the kernel read-only data: 2644k
[    3.336982] NX-protecting the kernel data: 6152k
[    3.375173] BUG: unable to handle kernel paging request at 00740060
[    3.376162] IP: [<81053fc4>] task_work_run+0x54/0xa0
[    3.376837] *pdpt = 00000000072e1001 *pde = 0000000000000000 
[    3.377579] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    3.378158] CPU: 0 PID: 85 Comm: hostname Not tainted 3.12.0-rc2-next-20130927-03100-ga0cf1ab #5
[    3.378206] task: 8730c000 ti: 8730e000 task.ti: 8730e000
[    3.378206] EIP: 0060:[<81053fc4>] EFLAGS: 00010206 CPU: 0
[    3.378206] EIP is at task_work_run+0x54/0xa0
[    3.378206] EAX: 00740060 EBX: 87309000 ECX: 00000000 EDX: 00740060
[    3.378206] ESI: 8730c388 EDI: 8730c000 EBP: 8730ff40 ESP: 8730ff34
[    3.378206]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.378206] CR0: 8005003b CR2: 00740060 CR3: 072d7000 CR4: 000006b0
[    3.378206] Stack:
[    3.378206]  ffffffff 87308058 8730c000 8730ff8c 81039315 77675fb8 8105af7b 00000000
[    3.378206]  8730ffac 00000001 6c0e41a5 61636f6c 736f686c 6f6c2e74 646c6163 8730c398
[    3.378206]  815fc8fe 81022f40 00000000 00000000 872f1880 8730c000 8730ffa4 81039a0a
[    3.378206] Call Trace:
[    3.378206]  [<81039315>] do_exit+0x2a5/0x910
[    3.378206]  [<8105af7b>] ? up_write+0x1b/0x30
[    3.378206]  [<815fc8fe>] ? restore_all+0xf/0xf
[    3.378206]  [<81022f40>] ? kvm_read_and_reset_pf_reason+0x40/0x40
[    3.378206]  [<81039a0a>] do_group_exit+0x4a/0xa0
[    3.378206]  [<81039a78>] SyS_exit_group+0x18/0x20
[    3.378206]  [<815fcf50>] sysenter_do_call+0x12/0x3c
[    3.378206] Code: 36 31 c9 89 d0 0f b1 0e 39 c2 75 eb 85 d2 74 5c 8d b4 26 00 00 00 00 f3 90 8b 87 c0 03 00 00 85 c0 74 f4 31 db eb 04 89 d3 89 c2 <8b> 02 89 1a 85 c0 75 f4 eb 16 66 90 f6 47 0c 04 74 c4 b9 f0 af
[    3.378206] EIP: [<81053fc4>] task_work_run+0x54/0xa0 SS:ESP 0068:8730ff34
[    3.378206] CR2: 0000000000740060
[    3.394549] ---[ end trace a6f697254c888db0 ]---

git bisect start 45c4ea0c4c1b8abffb575b865243fd1c69bbecd9 v3.11 --
git bisect good 39eda2aba6be642b71f2e0ad623dcb09fd9d79cf  # 22:41     20+  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect good bff157b3ad4b9f6be0af6987fcd62deaf0f2b799  # 22:47     20+  Merge branch 'slab/next' of git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux
git bisect good f659a4f17bbecdbad57dd5c63a1783e5ec5fd792  # 22:51     20+  Merge remote-tracking branch 'drm-intel/for-linux-next'
git bisect  bad 6405cd58ac5c0a6ed5f4f1308892147870b9d5cf  # 22:54      0-  Merge remote-tracking branch 'regmap/for-next'
git bisect good 5094001bc464c12d3e04eb73a5e0d5e8436f09f7  # 22:59     20+  Merge remote-tracking branch 'omap_dss2/for-next'
git bisect good 8f31410ee9917e8648c7cf7f45e22320c166998a  # 23:01     20+  Merge remote-tracking branch 'spi/for-next'
git bisect  bad 6f014a7ea91f80f765ba700dcd1728680ba5c58e  # 23:04      0-  Merge remote-tracking branch 'tip/auto-latest'
git bisect  bad bce56fbc0f165658f7e0715fedc8d39840bae31c  # 23:07      0-  Merge branch 'sched/core'
git bisect  bad c2daa3bed53a81171cf8c1a36db798e82b91afe8  # 23:10      0-  sched, x86: Provide a per-cpu preempt_count implementation
git bisect good 4314895165623879937f46d767673654662b570c  # 23:15     20+  sched: Micro-optimize by dropping unnecessary task_rq() calls
git bisect  bad 4a2b4b222743bb07fedf985b884550f2ca067ea9  # 23:18      0-  sched: Introduce preempt_count accessor functions
git bisect  bad b021fe3e25094fbec22d0eff846d2adeee1b9736  # 23:21      0-  sched, rcu: Make RCU use resched_cpu()
git bisect  bad 0c44c2d0f459cd7e275242b72f500137c4fa834d  # 23:22      0-  x86: Use asm goto to implement better modify_and_test() functions
git bisect good 4314895165623879937f46d767673654662b570c  # 23:25     60+  sched: Micro-optimize by dropping unnecessary task_rq() calls
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 23:25      0-  Add linux-next specific files for 20130927
git bisect good 7dee8dff47734ee52da2cd8b8ea9736e42c5062f  # 23:32     60+  Merge tag 'pm+acpi-3.12-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 23:32      0-  Add linux-next specific files for 20130927

Thanks,
Fengguang

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-athens-6:20131005211943:i386-randconfig-j1-10052106:3.12.0-rc2-next-20130927-03100-ga0cf1ab:5"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.12.0-rc2-next-20130927-03100-ga0cf1ab (kbuil=
d@jaketown) (gcc version 4.8.1 (Debian 4.8.1-8) ) #5 Sat Oct 5 21:18:12 CST=
 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x029fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e5fffff]
[    0.000000]  [mem 0x0e400000-0x0e5fffff] page 4k
[    0.000000] BRK [0x020b3000, 0x020b3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e3fffff]
[    0.000000]  [mem 0x0c000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x020b4000, 0x020b4fff] PGTABLE
[    0.000000] BRK [0x020b5000, 0x020b5fff] PGTABLE
[    0.000000] BRK [0x020b6000, 0x020b6fff] PGTABLE
[    0.000000] BRK [0x020b7000, 0x020b7fff] PGTABLE
[    0.000000] BRK [0x020b8000, 0x020b8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0fffdfff]
[    0.000000]  [mem 0x0e600000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128856(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   Normal zone: 576 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 18a8600
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j1-10052106/next:master/.vml=
inuz-a0cf1abc25ac197dd97b857c0f6341066a8cb1cf-20131005211923-7-athens branc=
h=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-j1-10052106/a0cf1abc25=
ac197dd97b857c0f6341066a8cb1cf/vmlinuz-3.12.0-rc2-next-20130927-03100-ga0cf=
1ab
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 205804K/261744K available (6135K kernel code, 2126K =
rwdata, 2640K rodata, 464K init, 5644K bss, 55940K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xfffe0000   (1783 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x81aa7000 - 0x81b1b000   ( 464 kB)
[    0.000000]       .data : 0x815fdf62 - 0x81aa6a80   (4770 kB)
[    0.000000]       .text : 0x81000000 - 0x815fdf62   (6135 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D80090000 soft=3D80092000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.018 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.03 Bogo=
MIPS (lpj=3D28930180)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: 6
[    0.020000] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.020000] ACPI: Core revision 20130823
[    0.023905] ACPI: All ACPI Tables successfully acquired
[    0.024452] ACPI: setting ELCR to 0200 (from 0c00)
[    0.024974] ftrace: allocating 23381 entries in 46 pages
[    0.030214] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.031733] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.034194] regulator-dummy: no parameters
[    0.034826] NET: Registered protocol family 16
[    0.035928] cpuidle: using governor ladder
[    0.036329] cpuidle: using governor menu
[    0.040218] ACPI: bus type PCI registered
[    0.040742] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.041433] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.042041] PCI: Using configuration type 1 for base access
[    0.051769] ACPI: Added _OSI(Module Device)
[    0.052189] ACPI: Added _OSI(Processor Device)
[    0.052615] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.053072] ACPI: Added _OSI(Processor Aggregator Device)
[    0.066279] ACPI: Interpreter enabled
[    0.066657] ACPI: (supports S0 S5)
[    0.066991] ACPI: Using PIC for interrupt routing
[    0.067485] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.086058] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.086916] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.087609] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.089215] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.090128] PCI host bridge to bus 0000:00
[    0.090742] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.091562] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.092468] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.093450] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.094604] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.095319] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.096689] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.098104] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.102195] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.104531] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.105499] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.106204] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.107441] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.109497] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.111401] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.118889] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.120715] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.122523] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.124254] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.130609] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.131916] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.133716] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.135530] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.141787] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.142972] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.144798] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    0.146521] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.154240] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.156073] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.157796] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    0.164824] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.166804] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.168833] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.176228] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.178282] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    0.180633] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.188030] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.190000] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    0.191585] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.200796] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.202834] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.204577] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.211889] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.213136] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    0.218180] pci_bus 0000:00: on NUMA node 0
[    0.220969] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.221963] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.222939] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.223956] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.224745] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.226588] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.227113] ACPI: \_SB_.PCI0: notify handler is installed
[    0.227836] Found 1 acpi root devices
[    0.228958] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.229723] vgaarb: loaded
[    0.230008] vgaarb: bridge control possible 0000:00:02.0
[    0.230969] ACPI: bus type USB registered
[    0.231418] usbcore: registered new interface driver usbfs
[    0.232005] usbcore: registered new interface driver hub
[    0.232619] usbcore: registered new device driver usb
[    0.233348] pps_core: LinuxPPS API ver. 1 registered
[    0.234141] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.235178] PTP clock support registered
[    0.235771] EDAC MC: Ver: 3.0.0
[    0.236594] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.237803] Advanced Linux Sound Architecture Driver Initialized.
[    0.238389] PCI: Using ACPI for IRQ routing
[    0.238801] PCI: pci_cache_line_size set to 64 bytes
[    0.239484] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.240014] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.241473] Switched to clocksource kvm-clock
[    0.242576] Warning: could not register annotated branches stats
[    0.256643] pnp: PnP ACPI init
[    0.256985] ACPI: bus type PNP registered
[    0.257655] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.258638] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.259615] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.260354] pnp 00:03: [dma 2]
[    0.260717] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.261578] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.262378] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.263686] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.265074] pnp: PnP ACPI: found 7 devices
[    0.265652] ACPI: bus type PNP unregistered
[    0.302038] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.302582] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.303121] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.303714] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.304326] NET: Registered protocol family 1
[    0.304784] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.305365] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.305930] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.306551] pci 0000:00:02.0: Boot video device
[    0.307074] PCI: CLS 0 bytes, default 64
[    0.307752] Unpacking initramfs...
[    1.450278] debug: unmapping init [mem 0x8e73f000-0x8ffeffff]
[    2.034182] DMA-API: preallocated 65536 debug entries
[    2.034695] DMA-API: debugging enabled by kernel config
[    2.037250] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    2.038516] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    2.039415] Scanning for low memory corruption every 60 seconds
[    2.040268] cryptomgr_test (14) used greatest stack depth: 7276 bytes le=
ft
[    2.041757] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.042725] NatSemi SCx200 Driver
[    2.046578] VFS: Disk quotas dquot_6.5.2
[    2.047032] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.048690] jffs2: version 2.2.=20
[    2.049448] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.049886] fuse init (API version 7.22)
[    2.051074] msgmni has been set to 401
[    2.054800] Key type asymmetric registered
[    2.055220] Asymmetric key parser 'x509' registered
[    2.059440] list_sort_test: start testing list_sort()
[    2.061491] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    2.062007] crc32: self tests passed, processed 225944 bytes in 264519 n=
sec
[    2.062978] crc32c: CRC_LE_BITS =3D 32
[    2.063352] crc32c: self tests passed, processed 225944 bytes in 132959 =
nsec
[    2.064045] rbtree testing -> 9026 cycles
[    2.424789] augmented rbtree testing -> 13482 cycles
[    2.954562] no IO addresses supplied
[    2.955134] hgafb: HGA card not detected.
[    2.955531] hgafb: probe of hgafb.0 failed with error -22
[    2.956188] usbcore: registered new interface driver udlfb
[    2.956787] ipmi message handler version 39.2
[    2.957227] ipmi device interface
[    2.957625] IPMI System Interface driver.
[    2.958104] ipmi_si: Adding default-specified kcs state machine
[    2.958764] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.959705] ipmi_si: Interface detection failed
[    2.960152] ipmi_si: Adding default-specified smic state machine
[    2.960735] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.961685] ipmi_si: Interface detection failed
[    2.962123] ipmi_si: Adding default-specified bt state machine
[    2.962687] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.963633] ipmi_si: Interface detection failed
[    2.964168] ipmi_si: Unable to find any System Interface(s)
[    2.964709] IPMI Watchdog: driver initialized
[    2.965128] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    2.965844] IPMI poweroff: Unable to register powercycle sysctl
[    2.967425] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.968154] ACPI: Power Button [PWRF]
[    2.970053] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.970576] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.992881] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.997201] lp: driver loaded but no devices found
[    2.997726] DoubleTalk PC - not found
[    2.998155] Non-volatile memory driver v1.3
[    2.998617] toshiba: not a supported Toshiba laptop
[    2.999137] ppdev: user-space parallel port driver
[    2.999592] scx200_gpio: no SCx200 gpio present
[    3.000291] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    3.001404] platform pc8736x_gpio.0: no device found
[    3.002183] nsc_gpio initializing
[    3.002643] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.003185] smapi::smapi_init, ERROR invalid usSmapiID
[    3.003687] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.004695] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.005749] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.006676] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.007744] Hangcheck: Using getrawmonotonic().
[    3.008704] dummy-irq: no IRQ given.  Use irq=3DN
[    3.010156] usbcore: registered new interface driver viperboard
[    3.012181] Failed to ioremap_nocache
[    3.012589] slram: not enough parameters.
[    3.049210] No valid DiskOnChip devices found
[    3.049672] tsc: Refined TSC clocksource calibration: 2892.945 MHz
[    3.050381] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.051318] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.052200] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.053113] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.054002] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.054904] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.055793] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    3.057319] flash size: 128 MiB
[    3.057740] page size: 512 bytes
[    3.058064] OOB area size: 16 bytes
[    3.058492] sector size: 16 KiB
[    3.058796] pages number: 262144
[    3.059173] pages per sector: 32
[    3.059547] bus width: 8
[    3.059792] bits in sector size: 14
[    3.060139] bits in page size: 9
[    3.060448] bits in OOB size: 4
[    3.060748] flash size with OOB: 135168 KiB
[    3.061226] page address bytes: 4
[    3.061546] sector address bytes: 3
[    3.061877] options: 0x42
[    3.062827] Scanning device for bad blocks
[    3.119046] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.119655] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.122799] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    3.123444] usbcore: registered new interface driver cdc_wdm
[    3.124021] usbcore: registered new interface driver mdc800
[    3.124604] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    3.126552] usbcore: registered new interface driver usbserial
[    3.127151] usbcore: registered new interface driver aircable
[    3.127787] usbserial: USB Serial support registered for aircable
[    3.128488] usbcore: registered new interface driver belkin_sa
[    3.129125] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    3.130019] usbcore: registered new interface driver ch341
[    3.130571] usbserial: USB Serial support registered for ch341-uart
[    3.131260] usbcore: registered new interface driver cyberjack
[    3.131850] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    3.132692] usbcore: registered new interface driver usb_debug
[    3.133679] usbserial: USB Serial support registered for debug
[    3.134562] usbcore: registered new interface driver digi_acceleport
[    3.135276] usbserial: USB Serial support registered for Digi 2 port USB=
 adapter
[    3.136017] usbserial: USB Serial support registered for Digi 4 port USB=
 adapter
[    3.136874] usbcore: registered new interface driver io_ti
[    3.137808] usbserial: USB Serial support registered for Edgeport TI 1 p=
ort adapter
[    3.138852] usbserial: USB Serial support registered for Edgeport TI 2 p=
ort adapter
[    3.139803] usbcore: registered new interface driver f81232
[    3.140439] usbserial: USB Serial support registered for f81232
[    3.141031] usbcore: registered new interface driver ftdi_sio
[    3.141605] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    3.142362] usbcore: registered new interface driver ipaq
[    3.143390] usbserial: USB Serial support registered for PocketPC PDA
[    3.144047] usbcore: registered new interface driver ir_usb
[    3.144600] usbserial: USB Serial support registered for IR Dongle
[    3.145220] usbcore: registered new interface driver iuu_phoenix
[    3.145813] usbserial: USB Serial support registered for iuu_phoenix
[    3.146452] usbcore: registered new interface driver keyspan
[    3.147073] usbserial: USB Serial support registered for Keyspan - (with=
out firmware)
[    3.147842] usbserial: USB Serial support registered for Keyspan 1 port =
adapter
[    3.148636] usbserial: USB Serial support registered for Keyspan 2 port =
adapter
[    3.149369] usbserial: USB Serial support registered for Keyspan 4 port =
adapter
[    3.150096] usbcore: registered new interface driver kl5kusb105
[    3.150739] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    3.152505] usbcore: registered new interface driver kobil_sct
[    3.153174] usbserial: USB Serial support registered for KOBIL USB smart=
 card terminal
[    3.153951] usbcore: registered new interface driver mos7720
[    3.154528] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    3.155259] usbcore: registered new interface driver mos7840
[    3.155873] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[    3.156710] usbcore: registered new interface driver navman
[    3.157286] usbserial: USB Serial support registered for navman
[    3.157870] usbcore: registered new interface driver omninet
[    3.158547] usbserial: USB Serial support registered for ZyXEL - omni.ne=
t lcd plus usb
[    3.159328] usbcore: registered new interface driver opticon
[    3.159933] usbserial: USB Serial support registered for opticon
[    3.160550] usbcore: registered new interface driver oti6858
[    3.161130] usbserial: USB Serial support registered for oti6858
[    3.161727] usbcore: registered new interface driver qcaux
[    3.162298] usbserial: USB Serial support registered for qcaux
[    3.162881] usbcore: registered new interface driver qcserial
[    3.163531] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    3.164522] usbcore: registered new interface driver quatech2
[    3.165449] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    3.166553] usbcore: registered new interface driver safe_serial
[    3.167167] usbserial: USB Serial support registered for safe_serial
[    3.167905] usbcore: registered new interface driver sierra
[    3.168580] usbserial: USB Serial support registered for Sierra USB modem
[    3.169728] usbcore: registered new interface driver usb_serial_simple
[    3.170644] usbserial: USB Serial support registered for zio
[    3.171517] usbserial: USB Serial support registered for funsoft
[    3.172131] usbserial: USB Serial support registered for flashloader
[    3.172794] usbserial: USB Serial support registered for vivopay
[    3.173675] usbserial: USB Serial support registered for moto_modem
[    3.174579] usbserial: USB Serial support registered for hp4x
[    3.175194] usbserial: USB Serial support registered for suunto
[    3.175786] usbserial: USB Serial support registered for siemens_mpi
[    3.176548] usbcore: registered new interface driver spcp8x5
[    3.177512] usbserial: USB Serial support registered for SPCP8x5
[    3.178411] usbcore: registered new interface driver symbolserial
[    3.179238] usbserial: USB Serial support registered for symbol
[    3.179934] usbcore: registered new interface driver visor
[    3.180640] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    3.181429] usbserial: USB Serial support registered for Sony Clie 5.0
[    3.182164] usbserial: USB Serial support registered for Sony Clie 3.5
[    3.183211] usbcore: registered new interface driver whiteheat
[    3.183925] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    3.184848] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    3.185598] usbcore: registered new interface driver keyspan_pda
[    3.186215] usbserial: USB Serial support registered for Keyspan PDA
[    3.186912] usbserial: USB Serial support registered for Xircom / Entreg=
ra PGS - (prerenumeration)
[    3.188180] usbcore: registered new interface driver xsens_mt
[    3.188852] usbserial: USB Serial support registered for xsens_mt
[    3.189466] usbcore: registered new interface driver zte_ev
[    3.190037] usbserial: USB Serial support registered for zte_ev
[    3.190630] usbcore: registered new interface driver adutux
[    3.192413] usbcore: registered new interface driver appledisplay
[    3.193261] usbcore: registered new interface driver cytherm
[    3.194211] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    3.195110] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.195810] usbcore: registered new interface driver idmouse
[    3.196703] usbcore: registered new interface driver iowarrior
[    3.197740] usbcore: registered new interface driver isight_firmware
[    3.198862] usbcore: registered new interface driver usbled
[    3.199844] usbcore: registered new interface driver rio500
[    3.200603] usbcore: registered new interface driver trancevibrator
[    3.201475] usbcore: registered new interface driver uss720
[    3.202253] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    3.203272] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    3.203950] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    3.205008] uss720: If you just want to connect to a printer, use usblp =
instead
[    3.206085] usbcore: registered new interface driver usbsevseg
[    3.207233] userial_init: registered 4 ttyGS* devices
[    3.207927] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.210253] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.210832] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.213808] usbcore: registered new interface driver appletouch
[    3.214566] usbcore: registered new interface driver bcm5974
[    3.215551] logibm.c: Didn't find Logitech busmouse at 0x23c
[    3.218703] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.226864] usbcore: registered new interface driver xpad
[    3.229104] usbcore: registered new interface driver ati_remote2
[    3.230181] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.232307] usbcore: registered new interface driver cm109
[    3.233225] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.234155] usbcore: registered new interface driver ims_pcu
[    3.237304] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    3.238641] usbcore: registered new interface driver powermate
[    3.240751] wistron_btns: System unknown
[    3.241444] ideapad_slidebar: DMI does not match
[    3.242244] i2c /dev entries driver
[    3.244190] i2c-parport-light: adapter type unspecified
[    3.245126] usbcore: registered new interface driver i2c-tiny-usb
[    3.247512] scx200_i2c: no SCx200 gpio pins available
[    3.248099] pps_ldisc: PPS line discipline registered
[    3.248701] pps_parport: parallel port PPS client
[    3.249204] Driver for 1-wire Dallas network protocol.
[    3.251314] usbcore: registered new interface driver DS9490R
[    3.252274] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    3.256978] applesmc: supported laptop not found!
[    3.257520] applesmc: driver init failed (ret=3D-19)!
[    3.263303] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    3.265610] mixcomwd: No card detected, or port not available
[    3.266243] usbcore: registered new interface driver pcwd_usb
[    3.267185] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    3.268138] acquirewdt: I/O address 0x0043 already in use
[    3.268773] acquirewdt: probe of acquirewdt failed with error -5
[    3.269370] sc1200wdt: build 20020303
[    3.269859] sc1200wdt: io parameter must be specified
[    3.270696] pc87413_wdt: Version 1.1 at io 0x2E
[    3.272777] pc87413_wdt: initialized. timeout=3D1 min
[    3.273471] pc87413_wdt: cannot request SWC region at 0xffff
[    3.275528] sbc8360: Timeout set at 60000 ms
[    3.276001] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    3.277184] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    3.277988] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    3.278788] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    3.280038] w83697ug_wdt: No W83697UG/UF could be found
[    3.280631] w83977f_wdt: driver v1.00
[    3.280998] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.281649] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    3.282229] machzwd: no ZF-Logic found
[    3.283723] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    3.284373] wbsd: Copyright(c) Pierre Ossman
[    3.284910] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    3.285841] usbcore: registered new interface driver vub300
[    3.287367] usbcore: registered new interface driver ushc
[    3.289158] ledtrig-cpu: registered to indicate activity on CPUs
[    3.291322] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.298049] usbcore: registered new interface driver usbhid
[    3.298942] usbhid: USB HID core driver
[    3.300589] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[    3.301367] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[    3.308390]  fake-fmc-carrier: mezzanine 0
[    3.309137]       Manufacturer: fake-vendor
[    3.309851]       Product name: fake-design-for-testing
[    3.310840] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    3.311914] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    3.313142] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    3.315324] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    3.320173] usbcore: registered new interface driver snd-usb-audio
[    3.321303] usbcore: registered new interface driver snd-ua101
[    3.322356] usbcore: registered new interface driver snd-usb-usx2y
[    3.323462] usbcore: registered new interface driver snd-usb-caiaq
[    3.324658] usbcore: registered new interface driver snd-usb-6fire
[    3.332107] ALSA device list:
[    3.332417]   No soundcards found.
[    3.334304] debug: unmapping init [mem 0x81aa7000-0x81b1afff]
[    3.335396] Write protecting the kernel text: 6136k
[    3.336040] Write protecting the kernel read-only data: 2644k
[    3.336982] NX-protecting the kernel data: 6152k
[    3.375173] BUG: unable to handle kernel paging request at 00740060
[    3.376162] IP: [<81053fc4>] task_work_run+0x54/0xa0
[    3.376837] *pdpt =3D 00000000072e1001 *pde =3D 0000000000000000=20
[    3.377579] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    3.378158] CPU: 0 PID: 85 Comm: hostname Not tainted 3.12.0-rc2-next-20=
130927-03100-ga0cf1ab #5
[    3.378206] task: 8730c000 ti: 8730e000 task.ti: 8730e000
[    3.378206] EIP: 0060:[<81053fc4>] EFLAGS: 00010206 CPU: 0
[    3.378206] EIP is at task_work_run+0x54/0xa0
[    3.378206] EAX: 00740060 EBX: 87309000 ECX: 00000000 EDX: 00740060
[    3.378206] ESI: 8730c388 EDI: 8730c000 EBP: 8730ff40 ESP: 8730ff34
[    3.378206]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    3.378206] CR0: 8005003b CR2: 00740060 CR3: 072d7000 CR4: 000006b0
[    3.378206] Stack:
[    3.378206]  ffffffff 87308058 8730c000 8730ff8c 81039315 77675fb8 8105a=
f7b 00000000
[    3.378206]  8730ffac 00000001 6c0e41a5 61636f6c 736f686c 6f6c2e74 646c6=
163 8730c398
[    3.378206]  815fc8fe 81022f40 00000000 00000000 872f1880 8730c000 8730f=
fa4 81039a0a
[    3.378206] Call Trace:
[    3.378206]  [<81039315>] do_exit+0x2a5/0x910
[    3.378206]  [<8105af7b>] ? up_write+0x1b/0x30
[    3.378206]  [<815fc8fe>] ? restore_all+0xf/0xf
[    3.378206]  [<81022f40>] ? kvm_read_and_reset_pf_reason+0x40/0x40
[    3.378206]  [<81039a0a>] do_group_exit+0x4a/0xa0
[    3.378206]  [<81039a78>] SyS_exit_group+0x18/0x20
[    3.378206]  [<815fcf50>] sysenter_do_call+0x12/0x3c
[    3.378206] Code: 36 31 c9 89 d0 0f b1 0e 39 c2 75 eb 85 d2 74 5c 8d b4 =
26 00 00 00 00 f3 90 8b 87 c0 03 00 00 85 c0 74 f4 31 db eb 04 89 d3 89 c2 =
<8b> 02 89 1a 85 c0 75 f4 eb 16 66 90 f6 47 0c 04 74 c4 b9 f0 af
[    3.378206] EIP: [<81053fc4>] task_work_run+0x54/0xa0 SS:ESP 0068:8730ff=
34
[    3.378206] CR2: 0000000000740060
[    3.394549] ---[ end trace a6f697254c888db0 ]---
[    3.395043] Fixing recursive fault but reboot is needed!

BUG: kernel boot oops
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-j=
1-10052106/a0cf1abc25ac197dd97b857c0f6341066a8cb1cf/vmlinuz-3.12.0-rc2-next=
-20130927-03100-ga0cf1ab -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall=
_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Dde=
bug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 cons=
ole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D=
/kernel-tests/run-queue/kvm/i386-randconfig-j1-10052106/next:master/.vmlinu=
z-a0cf1abc25ac197dd97b857c0f6341066a8cb1cf-20131005211923-7-athens branch=
=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-j1-10052106/a0cf1abc25a=
c197dd97b857c0f6341066a8cb1cf/vmlinuz-3.12.0-rc2-next-20130927-03100-ga0cf1=
ab'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -net=
 nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio -net user,vlan=3D0=
,hostfwd=3Dtcp::10661-:22 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D=
1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive file=3D/fs/LABEL=3D=
KVM/disk0-quantal-athens-6,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk1-quantal-athens-6,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LA=
BEL=3DKVM/disk2-quantal-athens-6,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk3-quantal-athens-6,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/LABEL=3DKVM/disk4-quantal-athens-6,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk5-quantal-athens-6,media=3Ddisk,if=3Dvirtio -pidfile=
 /dev/shm/kboot/pid-quantal-athens-6 -serial file:/dev/shm/kboot/serial-qua=
ntal-athens-6 -daemonize -display none -monitor null=20

--LZvS9be/3tNcYl/X
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-a0cf1abc25ac197dd97b857c0f6341066a8cb1cf-i386-randconfig-j1-10052106-BUG:-unable-to-handle-kernel-paging-request-at-59612.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYTBjZjFhYi4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzA5MjcKSEVBRCBpcyBub3cgYXQgNDVjNGVhMC4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdsem8tdXBkYXRlL2x6by11cGRhdGUnCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajEtMTAw
NTIxMDYvbmV4dDptYXN0ZXI6NDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJi
ZWNkOTpiaXNlY3QtdXNiCgoyMDEzLTEwLTA1LTIxOjU2OjUzIDQ1YzRlYTBjNGMxYjhhYmZm
YjU3NWI4NjUyNDNmZDFjNjliYmVjZDkgY29tcGlsaW5nCjE3OCByZWFsICA4NjggdXNlciAg
OTQgc3lzICA1MzkuMjQlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2CgoyMDEz
LTEwLTA1LTIyOjAwOjA5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzItMDI4NDIt
ZzQ1YzRlYTAuLi4uIFRFU1QgRkFJTFVSRQpbICAgIDMuMDUzNDM4XSBXcml0ZSBwcm90ZWN0
aW5nIHRoZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDI2MjhrClsgICAgMy4wNTQwMTBdIE5Y
LXByb3RlY3RpbmcgdGhlIGtlcm5lbCBkYXRhOiA2MTU2awpbICAgIDMuMDg4NDUxXSBCVUc6
IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDA1YmEwMDhjClsg
ICAgMy4wODkxMzJdIElQOiBbPDgxMDUzZGU0Pl0gdGFza193b3JrX3J1bisweDU0LzB4YTAK
WyAgICAzLjA4OTYzOV0gKnBkcHQgPSAwMDAwMDAwMDA3MmUxMDAxICpwZGUgPSAwMDAwMDAw
MDAwMDAwMDAwIApbICAgIDMuMDkwMjM2XSBPb3BzOiAwMDAwIFsjMV0gREVCVUdfUEFHRUFM
TE9DClsgICAgMy4wOTA2NzddIENQVTogMCBQSUQ6IDg1IENvbW06IGhvc3RuYW1lIE5vdCB0
YWludGVkIDMuMTIuMC1yYzItMDI4NDItZzQ1YzRlYTAgIzQ4NQpbICAgIDMuMDkxNDM0XSB0
YXNrOiA4NzMwYzAwMCB0aTogODczMGUwMDAgdGFzay50aTogODczMGUwMDAKWyAgICAzLjA5
MjAzMV0gRUlQOiAwMDYwOls8ODEwNTNkZTQ+XSBFRkxBR1M6IDAwMDEwMjAyIENQVTogMApb
ICAgIDMuMDkyNDMzXSBFSVAgaXMgYXQgdGFza193b3JrX3J1bisweDU0LzB4YTAKWyAgICAz
LjA5MjQzM10gRUFYOiAwNWJhMDA4YyBFQlg6IDg3MmYxYTAwIEVDWDogMDAwMDAwMDAgRURY
OiAwNWJhMDA4YwpbICAgIDMuMDkyNDMzXSBFU0k6IDg3MzBjMzg4IEVESTogODczMGMwMDAg
RUJQOiA4NzMwZmY0MCBFU1A6IDg3MzBmZjM0ClsgICAgMy4wOTI0MzNdICBEUzogMDA3YiBF
UzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAgIDMuMDkyNDMzXSBDUjA6
IDgwMDUwMDNiIENSMjogMDViYTAwOGMgQ1IzOiAwNzJkNzAwMCBDUjQ6IDAwMDAwNmIwClsg
ICAgMy4wOTI0MzNdIFN0YWNrOgpbICAgIDMuMDkyNDMzXSAgZmZmZmZmZmYgODczMDgwNTgg
ODczMGMwMDAgODczMGZmOGMgODEwMzkzNjUgNzc2MWZmYjggODEwNWFjYmIgMDAwMDAwMDAK
WyAgICAzLjA5MjQzM10gIDg3MzBmZmFjIDAwMDAwMDAxIDZjMGUzYzI1IDYxNjM2ZjZjIDcz
NmY2ODZjIDZmNmMyZTc0IDY0NmM2MTYzIDg3MzBjMzk4ClsgICAgMy4wOTI0MzNdICA4MTVm
YWM3ZSA4MTAyMmZhMCAwMDAwMDAwMCAwMDAwMDAwMCA4NzJmMDg4MCA4NzMwYzAwMCA4NzMw
ZmZhNCA4MTAzOWE1YQpbICAgIDMuMDkyNDMzXSBDYWxsIFRyYWNlOgpbICAgIDMuMDkyNDMz
XSAgWzw4MTAzOTM2NT5dIGRvX2V4aXQrMHgyYTUvMHg5MTAKWyAgICAzLjA5MjQzM10gIFs8
ODEwNWFjYmI+XSA/IHVwX3dyaXRlKzB4MWIvMHgzMApbICAgIDMuMDkyNDMzXSAgWzw4MTVm
YWM3ZT5dID8gcmVzdG9yZV9hbGwrMHhmLzB4ZgpbICAgIDMuMDkyNDMzXSAgWzw4MTAyMmZh
MD5dID8ga3ZtX3JlYWRfYW5kX3Jlc2V0X3BmX3JlYXNvbisweDQwLzB4NDAKWyAgICAzLjA5
MjQzM10gIFs8ODEwMzlhNWE+XSBkb19ncm91cF9leGl0KzB4NGEvMHhhMApbICAgIDMuMDky
NDMzXSAgWzw4MTAzOWFjOD5dIFN5U19leGl0X2dyb3VwKzB4MTgvMHgyMApbICAgIDMuMDky
NDMzXSAgWzw4MTVmYjJkMD5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAgMy4w
OTI0MzNdIENvZGU6IDM2IDMxIGM5IDg5IGQwIDBmIGIxIDBlIDM5IGMyIDc1IGViIDg1IGQy
IDc0IDVjIDhkIGI0IDI2IDAwIDAwIDAwIDAwIGYzIDkwIDhiIDg3IGMwIDAzIDAwIDAwIDg1
IGMwIDc0IGY0IDMxIGRiIGViIDA0IDg5IGQzIDg5IGMyIDw4Yj4gMDIgODkgMWEgODUgYzAg
NzUgZjQgZWIgMTYgNjYgOTAgZjYgNDcgMGMgMDQgNzQgYzQgYjkgZjAgNGYKWyAgICAzLjA5
MjQzM10gRUlQOiBbPDgxMDUzZGU0Pl0gdGFza193b3JrX3J1bisweDU0LzB4YTAgU1M6RVNQ
IDAwNjg6ODczMGZmMzQKWyAgICAzLjA5MjQzM10gQ1IyOiAwMDAwMDAwMDA1YmEwMDhjClsg
ICAgMy4xMDQ5OTJdIC0tLVsgZW5kIHRyYWNlIDY3YzlhZTc1MTRhOWEzMTggXS0tLQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80NWM0ZWEwYzRjMWI4YWJmZmI1NzVi
ODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXF1YW50YWwtY2Fpcm8tMTQ6MjAxMzEwMDUyMjAw
MjA6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDI4NDItZzQ1YzRl
YTA6NDg1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzQ1YzRlYTBjNGMx
YjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1lc2ctcXVhbnRhbC1pbm4tMjQ6MjAx
MzEwMDUyMjAwMTc6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDI4
NDItZzQ1YzRlYTA6NDg1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzQ1
YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1lc2ctcXVhbnRhbC1s
a3Atc3QwMS0xMjoyMDEzMTAwNTIyMDAzNTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6
My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDo0ODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDYvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9k
bWVzZy1xdWFudGFsLXNuYi0xMToyMDEzMTAwNTIyMDAzMjppMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDY6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDo0ODUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2
OWJiZWNkOS9kbWVzZy1xdWFudGFsLXhpYW4tMjQ6MjAxMzEwMDUyMjAwMjc6aTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDI4NDItZzQ1YzRlYTA6NDg1Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4
NjUyNDNmZDFjNjliYmVjZDkvZG1lc2ctcXVhbnRhbC14aWFuLTMwOjIwMTMxMDA1MjIwMDI3
OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEw
OjQ4NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80NWM0ZWEwYzRjMWI4
YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXlvY3RvLWF0aGVucy0zNDoyMDEz
MTAwNTIyMDAyMTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjg0
Mi1nNDVjNGVhMDo0ODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNDVj
NGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy15b2N0by1hdGhl
bnMtMzY6MjAxMzEwMDUyMjAwMTU6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIu
MC1yYzItMDI4NDItZzQ1YzRlYTA6NDg1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEw
MDUyMTA2LzQ1YzRlYTBjNGMxYjhhYmZmYjU3NWI4NjUyNDNmZDFjNjliYmVjZDkvZG1lc2ct
eW9jdG8tYXRoZW5zLTM4OjIwMTMxMDA1MjIwMDE4OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNjozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEwOjQ4NQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qMS0xMDA1MjEwNi80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJl
Y2Q5L2RtZXNnLXlvY3RvLWF0aGVucy0zOjIwMTMxMDA1MjIwMDE1OmkzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEwOjQ4NQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQz
ZmQxYzY5YmJlY2Q5L2RtZXNnLXlvY3RvLWF0aGVucy00MzoyMDEzMTAwNTIyMDAyMDppMzg2
LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDo0ODUK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNDVjNGVhMGM0YzFiOGFiZmZi
NTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy15b2N0by1jYWlyby0xODoyMDEzMTAwNTIy
MDAyMDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjg0Mi1nNDVj
NGVhMDo0ODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNDVjNGVhMGM0
YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy15b2N0by1jYWlyby03OjIw
MTMxMDA1MjIwMDE5OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAy
ODQyLWc0NWM0ZWEwOjQ4NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80
NWM0ZWEwYzRjMWI4YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXlvY3RvLWlu
bi0yODoyMDEzMTAwNTIyMDAxNDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4w
LXJjMi0wMjg0Mi1nNDVjNGVhMDo0ODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAw
NTIxMDYvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy15
b2N0by1pbm4tNDoyMDEzMTAwNTIyMDAyMjppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6
My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDo0ODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDYvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9k
bWVzZy15b2N0by1pbm4tNzoyMDEzMTAwNTIyMDAxOTppMzg2LXJhbmRjb25maWctajEtMTAw
NTIxMDY6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDo0ODUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajEtMTAwNTIxMDYvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJi
ZWNkOS9kbWVzZy15b2N0by1sa3Atc3QwMS0xMDoyMDEzMTAwNTIyMDAyMTppMzg2LXJhbmRj
b25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjg0Mi1nNDVjNGVhMDo0ODUKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNDVjNGVhMGM0YzFiOGFiZmZiNTc1Yjg2
NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy15b2N0by1sa3AtdHQwMi05OjIwMTMxMDA1MTIyOTQw
OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAyODQyLWc0NWM0ZWEw
OjQ4NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80NWM0ZWEwYzRjMWI4
YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5L2RtZXNnLXlvY3RvLW5obTQtNToyMDEzMTAw
NTE0MDMyNTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjg0Mi1n
NDVjNGVhMDo0ODUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNDVjNGVh
MGM0YzFiOGFiZmZiNTc1Yjg2NTI0M2ZkMWM2OWJiZWNkOS9kbWVzZy15b2N0by13YWltZWEt
NjoyMDEzMTAwNjA1NTkwMjppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJj
Mi0wMjg0Mi1nNDVjNGVhMDo0ODUKCmJpc2VjdDogYmFkIGNvbW1pdCA0NWM0ZWEwYzRjMWI4
YWJmZmI1NzViODY1MjQzZmQxYzY5YmJlY2Q5CmdpdCBjaGVja291dCB2My4xMQpQcmV2aW91
cyBIRUFEIHBvc2l0aW9uIHdhcyA0NWM0ZWEwLi4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBi
cmFuY2ggJ2x6by11cGRhdGUvbHpvLXVwZGF0ZScKSEVBRCBpcyBub3cgYXQgNmU0NjY0NS4u
LiBMaW51eCAzLjExCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYvbmV4dDptYXN0ZXI6NmU0NjY0NTI1YjFkYjI4ZjhjNGUx
MTMwOTU3ZjcwYTk0YzE5MjEzZTpiaXNlY3QtdXNiCgoyMDEzLTEwLTA1LTIyOjAyOjE0IDZl
NDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UgY29tcGlsaW5nCjE1NSBy
ZWFsICA4MjkgdXNlciAgODYgc3lzICA1ODcuODYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWox
LTEwMDUyMTA2CgoyMDEzLTEwLTA1LTIyOjA1OjA0IGRldGVjdGluZyBib290IHN0YXRlIDMu
MTEuMC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29v
ZCBjb21taXQgdjMuMTEKZ2l0IGJpc2VjdCBzdGFydCA0NWM0ZWEwYzRjMWI4YWJmZmI1NzVi
ODY1MjQzZmQxYzY5YmJlY2Q5IHYzLjExIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDZlNDY2NDUuLi4gTGludXggMy4xMQpIRUFEIGlzIG5vdyBhdCBjMWJlNWE1Li4uIExpbnV4
IDMuOQpCaXNlY3Rpbmc6IDY2NDggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDEzIHN0ZXBzKQpbMzllZGEyYWJhNmJlNjQyYjcxZjJlMGFkNjIzZGNiMDlm
ZDlkNzljZl0gTWVyZ2UgYnJhbmNoICduZXh0JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmVuaC9wb3dlcnBjCmdpdCBiaXNlY3QgcnVuIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3Vz
Yi9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9uZXh0Om1hc3Rl
cjozOWVkYTJhYmE2YmU2NDJiNzFmMmUwYWQ2MjNkY2IwOWZkOWQ3OWNmOmJpc2VjdC11c2IK
CjIwMTMtMTAtMDUtMjI6MTg6NTMgMzllZGEyYWJhNmJlNjQyYjcxZjJlMGFkNjIzZGNiMDlm
ZDlkNzljZiBjb21waWxpbmcKMTQyIHJlYWwgIDg0NSB1c2VyICA5MiBzeXMgIDY1OS4yNyUg
Y3B1IAlpMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYKCjIwMTMtMTAtMDUtMjI6MjE6Mjkg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTA2NzM5LWczOWVkYTJhLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMz
MjMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBz
KQpbYmZmMTU3YjNhZDRiOWY2YmUwYWY2OTg3ZmNkNjJkZWFmMGYyYjc5OV0gTWVyZ2UgYnJh
bmNoICdzbGFiL25leHQnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9wZW5iZXJnL2xpbnV4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
Ni9uZXh0Om1hc3RlcjpiZmYxNTdiM2FkNGI5ZjZiZTBhZjY5ODdmY2Q2MmRlYWYwZjJiNzk5
OmJpc2VjdC11c2IKCjIwMTMtMTAtMDUtMjI6NDI6MDMgYmZmMTU3YjNhZDRiOWY2YmUwYWY2
OTg3ZmNkNjJkZWFmMGYyYjc5OSBjb21waWxpbmcKMTQ1IHJlYWwgIDg1OSB1c2VyICA5MSBz
eXMgIDY1MS4yNSUgY3B1IAlpMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYKCjIwMTMtMTAt
MDUtMjI6NDQ6NDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTEwMDY0LWdiZmYxNTdi
CTguCTE3CTE5CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTU5NSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCltmNjU5YTRmMTdiYmVjZGJh
ZDU3ZGQ1YzYzYTE3ODNlNWVjNWZkNzkyXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNo
ICdkcm0taW50ZWwvZm9yLWxpbnV4LW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi9uZXh0Om1hc3RlcjpmNjU5YTRmMTdiYmVjZGJhZDU3ZGQ1YzYzYTE3ODNlNWVjNWZk
NzkyOmJpc2VjdC11c2IKCjIwMTMtMTAtMDUtMjI6NDc6MTUgZjY1OWE0ZjE3YmJlY2RiYWQ1
N2RkNWM2M2ExNzgzZTVlYzVmZDc5MiBjb21waWxpbmcKMTQ3IHJlYWwgIDg2MyB1c2VyICA5
NiBzeXMgIDY1My4wOSUgY3B1IAlpMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYKCjIwMTMt
MTAtMDUtMjI6NDk6NTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMi0wMTI0Ni1n
ZjY1OWE0Zgk5LgkxNgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDc5OCByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCls2NDA1Y2Q1OGFjNWMw
YTZlZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJh
bmNoICdyZWdtYXAvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9u
ZXh0Om1hc3Rlcjo2NDA1Y2Q1OGFjNWMwYTZlZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmOmJp
c2VjdC11c2IKCjIwMTMtMTAtMDUtMjI6NTE6NTcgNjQwNWNkNThhYzVjMGE2ZWQ1ZjRmMTMw
ODg5MjE0Nzg3MGI5ZDVjZiBjb21waWxpbmcKMTM2IHJlYWwgIDg2NiB1c2VyICA5NCBzeXMg
IDcwMi43NiUgY3B1IAlpMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYKCjIwMTMtMTAtMDUt
MjI6NTQ6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMi0wMjA0My1nNjQwNWNk
NS4gVEVTVCBGQUlMVVJFClsgICAgMy4wNzE4NjBdIFdyaXRlIHByb3RlY3RpbmcgdGhlIGtl
cm5lbCByZWFkLW9ubHkgZGF0YTogMjYyMGsKWyAgICAzLjA3MjQxNl0gTlgtcHJvdGVjdGlu
ZyB0aGUga2VybmVsIGRhdGE6IDYxNjRrClsgICAgMy4xMDc1MzNdIEJVRzogdW5hYmxlIHRv
IGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgMDEwZTAwNjAKWyAgICAzLjEwODE3
OF0gSVA6IFs8ODEwNTNkZTQ+XSB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMApbICAgIDMuMTA4
Njg5XSAqcGRwdCA9IDAwMDAwMDAwMDcyZGUwMDEgKnBkZSA9IDAwMDAwMDAwMDAwMDAwMDAg
ClsgICAgMy4xMDkyNzRdIE9vcHM6IDAwMDAgWyMxXSBERUJVR19QQUdFQUxMT0MKWyAgICAz
LjEwOTcwNV0gQ1BVOiAwIFBJRDogODUgQ29tbTogaG9zdG5hbWUgTm90IHRhaW50ZWQgMy4x
Mi4wLXJjMi0wMjA0My1nNjQwNWNkNSAjNDkwClsgICAgMy4xMTA0MzZdIHRhc2s6IDg3MmZl
MDAwIHRpOiA4NzMwMDAwMCB0YXNrLnRpOiA4NzMwMDAwMApbICAgIDMuMTEwOTUwXSBFSVA6
IDAwNjA6Wzw4MTA1M2RlND5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsgICAgMy4xMTE0
ODFdIEVJUCBpcyBhdCB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMApbICAgIDMuMTExODk1XSBF
QVg6IDAxMGUwMDYwIEVCWDogODczMTYxMDAgRUNYOiAwMDAwMDAwMCBFRFg6IDAxMGUwMDYw
ClsgICAgMy4xMTI0OTJdIEVTSTogODcyZmUzODggRURJOiA4NzJmZTAwMCBFQlA6IDg3MzAx
ZjQwIEVTUDogODczMDFmMzQKWyAgICAzLjExMzA4Ml0gIERTOiAwMDdiIEVTOiAwMDdiIEZT
OiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgMy4xMTM1OThdIENSMDogODAwNTAwM2Ig
Q1IyOiAwMTBlMDA2MCBDUjM6IDA3MmRkMDAwIENSNDogMDAwMDA2YjAKWyAgICAzLjExNDE5
N10gU3RhY2s6ClsgICAgMy4xMTQyODFdICBmZmZmZmZmZiA4NzMwOTA1OCA4NzJmZTAwMCA4
NzMwMWY4YyA4MTAzOTM2NSA3NzVkZWZiOCA4MTA1YWNiYiAwMDAwMDAwMApbICAgIDMuMTE0
MjgxXSAgODczMDFmYWMgMDAwMDAwMDEgNmMwZTNjMjUgNjE2MzZmNmMgNzM2ZjY4NmMgNmY2
YzJlNzQgNjQ2YzYxNjMgODcyZmUzOTgKWyAgICAzLjExNDI4MV0gIDgxNWY4YjJlIDgxMDIy
ZmEwIDAwMDAwMDAwIDAwMDAwMDAwIDg3MmVlODgwIDg3MmZlMDAwIDg3MzAxZmE0IDgxMDM5
YTVhClsgICAgMy4xMTQyODFdIENhbGwgVHJhY2U6ClsgICAgMy4xMTQyODFdICBbPDgxMDM5
MzY1Pl0gZG9fZXhpdCsweDJhNS8weDkxMApbICAgIDMuMTE0MjgxXSAgWzw4MTA1YWNiYj5d
ID8gdXBfd3JpdGUrMHgxYi8weDMwClsgICAgMy4xMTQyODFdICBbPDgxNWY4YjJlPl0gPyBy
ZXN0b3JlX2FsbCsweGYvMHhmClsgICAgMy4xMTQyODFdICBbPDgxMDIyZmEwPl0gPyBrdm1f
cmVhZF9hbmRfcmVzZXRfcGZfcmVhc29uKzB4NDAvMHg0MApbICAgIDMuMTE0MjgxXSAgWzw4
MTAzOWE1YT5dIGRvX2dyb3VwX2V4aXQrMHg0YS8weGEwClsgICAgMy4xMTQyODFdICBbPDgx
MDM5YWM4Pl0gU3lTX2V4aXRfZ3JvdXArMHgxOC8weDIwClsgICAgMy4xMTQyODFdICBbPDgx
NWY5MTcwPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAgICAzLjExNDI4MV0gQ29k
ZTogMzYgMzEgYzkgODkgZDAgMGYgYjEgMGUgMzkgYzIgNzUgZWIgODUgZDIgNzQgNWMgOGQg
YjQgMjYgMDAgMDAgMDAgMDAgZjMgOTAgOGIgODcgYzAgMDMgMDAgMDAgODUgYzAgNzQgZjQg
MzEgZGIgZWIgMDQgODkgZDMgODkgYzIgPDhiPiAwMiA4OSAxYSA4NSBjMCA3NSBmNCBlYiAx
NiA2NiA5MCBmNiA0NyAwYyAwNCA3NCBjNCBiOSBmMCAwZgpbICAgIDMuMTE0MjgxXSBFSVA6
IFs8ODEwNTNkZTQ+XSB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMCBTUzpFU1AgMDA2ODo4NzMw
MWYzNApbICAgIDMuMTE0MjgxXSBDUjI6IDAwMDAwMDAwMDEwZTAwNjAKWyAgICAzLjEyMzkx
Ml0gLS0tWyBlbmQgdHJhY2UgZTgzNTJjZDY0NmVhNTViYiBdLS0tCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2LzY0MDVjZDU4YWM1YzBhNmVkNWY0ZjEzMDg4OTIxNDc4
NzBiOWQ1Y2YvZG1lc2ctcXVhbnRhbC1jYWlyby0xMToyMDEzMTAwNTIyNTQzMzppMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjA0My1nNjQwNWNkNTo0OTAKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNjQwNWNkNThhYzVjMGE2ZWQ1ZjRm
MTMwODg5MjE0Nzg3MGI5ZDVjZi9kbWVzZy1xdWFudGFsLWNhaXJvLTE3OjIwMTMxMDA1MjI1
NDM1OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAyMDQzLWc2NDA1
Y2Q1OjQ5MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi82NDA1Y2Q1OGFj
NWMwYTZlZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmL2RtZXNnLXF1YW50YWwtY2Fpcm8tMTg6
MjAxMzEwMDUyMjU0MzM6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzIt
MDIwNDMtZzY0MDVjZDU6NDkwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
LzY0MDVjZDU4YWM1YzBhNmVkNWY0ZjEzMDg4OTIxNDc4NzBiOWQ1Y2YvZG1lc2ctcXVhbnRh
bC1jYWlyby00OjIwMTMxMDA1MjI1NDMyOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjoz
LjEyLjAtcmMyLTAyMDQzLWc2NDA1Y2Q1OjQ5MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNi82NDA1Y2Q1OGFjNWMwYTZlZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmL2Rt
ZXNnLXF1YW50YWwtaW5uLTI5OjIwMTMxMDA1MjI1NDM2OmkzODYtcmFuZGNvbmZpZy1qMS0x
MDA1MjEwNjozLjEyLjAtcmMyLTAyMDQzLWc2NDA1Y2Q1OjQ5MAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1qMS0xMDA1MjEwNi82NDA1Y2Q1OGFjNWMwYTZlZDVmNGYxMzA4ODkyMTQ3ODcw
YjlkNWNmL2RtZXNnLXF1YW50YWwtaW5uLTM6MjAxMzEwMDUyMjU0MzI6aTM4Ni1yYW5kY29u
ZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDIwNDMtZzY0MDVjZDU6NDkwCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzY0MDVjZDU4YWM1YzBhNmVkNWY0ZjEzMDg4
OTIxNDc4NzBiOWQ1Y2YvZG1lc2ctcXVhbnRhbC1yb2FtLTE3OjIwMTMxMDA1MjI1NDMzOmkz
ODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAyMDQzLWc2NDA1Y2Q1OjQ5
MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi82NDA1Y2Q1OGFjNWMwYTZl
ZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmL2RtZXNnLXF1YW50YWwtc25iLTY6MjAxMzEwMDUy
MjU0Mzg6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDIwNDMtZzY0
MDVjZDU6NDkwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzY0MDVjZDU4
YWM1YzBhNmVkNWY0ZjEzMDg4OTIxNDc4NzBiOWQ1Y2YvZG1lc2ctcXVhbnRhbC14aWFuLTM2
OjIwMTMxMDA1MjI1NDM0OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMy
LTAyMDQzLWc2NDA1Y2Q1OjQ5MAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
Ni82NDA1Y2Q1OGFjNWMwYTZlZDVmNGYxMzA4ODkyMTQ3ODcwYjlkNWNmL2RtZXNnLXlvY3Rv
LWF0aGVucy0zMToyMDEzMTAwNTIyNTQzNDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6
My4xMi4wLXJjMi0wMjA0My1nNjQwNWNkNTo0OTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDYvNjQwNWNkNThhYzVjMGE2ZWQ1ZjRmMTMwODg5MjE0Nzg3MGI5ZDVjZi9k
bWVzZy15b2N0by1jYWlyby0yOjIwMTMxMDA1MjI1NDM0OmkzODYtcmFuZGNvbmZpZy1qMS0x
MDA1MjEwNjozLjEyLjAtcmMyLTAyMDQzLWc2NDA1Y2Q1OjQ5MAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1qMS0xMDA1MjEwNi82NDA1Y2Q1OGFjNWMwYTZlZDVmNGYxMzA4ODkyMTQ3ODcw
YjlkNWNmL2RtZXNnLXlvY3RvLXhpYW4tMTM6MjAxMzEwMDUyMjU0MzQ6aTM4Ni1yYW5kY29u
ZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDIwNDMtZzY0MDVjZDU6NDkwCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzY0MDVjZDU4YWM1YzBhNmVkNWY0ZjEzMDg4
OTIxNDc4NzBiOWQ1Y2YvZG1lc2ctcXVhbnRhbC1zbmItNDg6MjAxMzEwMDUyMjU0Mzk6aTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDIwNDMtZzY0MDVjZDU6NDkw
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzY0MDVjZDU4YWM1YzBhNmVk
NWY0ZjEzMDg4OTIxNDc4NzBiOWQ1Y2YvZG1lc2ctcXVhbnRhbC14cHMtMjoyMDEzMTAwNjA2
NTI1MTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjA0My1nNjQw
NWNkNTo0OTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNjQwNWNkNThh
YzVjMGE2ZWQ1ZjRmMTMwODg5MjE0Nzg3MGI5ZDVjZi9kbWVzZy15b2N0by1iYXktNDoyMDEz
MTAwNTIyNTQzOTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjA0
My1nNjQwNWNkNTo0OTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNjQw
NWNkNThhYzVjMGE2ZWQ1ZjRmMTMwODg5MjE0Nzg3MGI5ZDVjZi9kbWVzZy15b2N0by1qYWtl
dG93bi0xMzoyMDEzMTAwNTIyNTQzNzppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4x
Mi4wLXJjMi0wMjA0My1nNjQwNWNkNTo0OTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDYvNjQwNWNkNThhYzVjMGE2ZWQ1ZjRmMTMwODg5MjE0Nzg3MGI5ZDVjZi9kbWVz
Zy15b2N0by1sa3AtdHQwMi0yNDoyMDEzMTAwNTEzMjM1NzppMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDY6My4xMi4wLXJjMi0wMjA0My1nNjQwNWNkNTo0OTAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYvNjQwNWNkNThhYzVjMGE2ZWQ1ZjRmMTMwODg5MjE0Nzg3
MGI5ZDVjZi9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTEyOjIwMTMxMDA1MTMyNDA4OmkzODYt
cmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAyMDQzLWc2NDA1Y2Q1OjQ5MAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi82NDA1Y2Q1OGFjNWMwYTZlZDVm
NGYxMzA4ODkyMTQ3ODcwYjlkNWNmL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktMToyMDEzMTAw
NTIyNTQ0NDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMjA0My1n
NjQwNWNkNTo0OTAKCkJpc2VjdGluZzogMzU3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbNTA5NDAwMWJjNDY0YzEyZDNlMDRlYjczYTVl
MGQ1ZTg0MzZmMDlmN10gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnb21hcF9kc3My
L2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvbmV4dDptYXN0ZXI6
NTA5NDAwMWJjNDY0YzEyZDNlMDRlYjczYTVlMGQ1ZTg0MzZmMDlmNzpiaXNlY3QtdXNiCgoy
MDEzLTEwLTA1LTIyOjU1OjAwIDUwOTQwMDFiYzQ2NGMxMmQzZTA0ZWI3M2E1ZTBkNWU4NDM2
ZjA5ZjcgY29tcGlsaW5nCjEzMiByZWFsICA4NjAgdXNlciAgOTYgc3lzICA3MjMuMjAlIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2CgoyMDEzLTEwLTA1LTIyOjU3OjI0IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzItMDE2ODUtZzUwOTQwMDEJOAk5CTE4CTIw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMTU1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbOGYzMTQxMGVlOTkxN2U4NjQ4YzdjZjdmNDVlMjIz
MjBjMTY2OTk4YV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnc3BpL2Zvci1uZXh0
JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvbmV4dDptYXN0ZXI6OGYzMTQxMGVl
OTkxN2U4NjQ4YzdjZjdmNDVlMjIzMjBjMTY2OTk4YTpiaXNlY3QtdXNiCgoyMDEzLTEwLTA1
LTIyOjU5OjI1IDhmMzE0MTBlZTk5MTdlODY0OGM3Y2Y3ZjQ1ZTIyMzIwYzE2Njk5OGEgY29t
cGlsaW5nCjI1IHJlYWwgIDE3MCB1c2VyICAyMSBzeXMgIDc0Ny42OCUgY3B1IAlpMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYKCjIwMTMtMTAtMDUtMjM6MDA6MDEgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMi4wLXJjMi0wMTg4Ny1nOGYzMTQxMAk4CTkJMjAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiA4NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NiBzdGVwcykKWzZmMDE0YTdlYTkxZjgwZjc2NWJhNzAwZGNkMTcyODY4MGJhNWM1OGVdIE1l
cmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3RpcC9hdXRvLWxhdGVzdCcKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91
c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2L25leHQ6bWFzdGVyOjZmMDE0YTdlYTkxZjgwZjc2NWJh
NzAwZGNkMTcyODY4MGJhNWM1OGU6YmlzZWN0LXVzYgoKMjAxMy0xMC0wNS0yMzowMTozMiA2
ZjAxNGE3ZWE5MWY4MGY3NjViYTcwMGRjZDE3Mjg2ODBiYTVjNThlIGNvbXBpbGluZwoxNDAg
cmVhbCAgODYyIHVzZXIgIDkzIHN5cyAgNjgyLjczJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNgoKMjAxMy0xMC0wNS0yMzowNDowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtcmMyLTAxOTU3LWc2ZjAxNGE3LiBURVNUIEZBSUxVUkUKWyAgICAzLjA2OTY2N10g
V3JpdGUgcHJvdGVjdGluZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAyNjIwawpbICAg
IDMuMDcwMjExXSBOWC1wcm90ZWN0aW5nIHRoZSBrZXJuZWwgZGF0YTogNjE2NGsKWyAgICAz
LjEwMjk0OV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBh
dCAwNGZhMDA4YwpbICAgIDMuMTAzNTcxXSBJUDogWzw4MTA1M2QyND5dIHRhc2tfd29ya19y
dW4rMHg1NC8weGEwClsgICAgMy4xMDQwNDldICpwZHB0ID0gMDAwMDAwMDAwNzJkZTAwMSAq
cGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgICAzLjEwNDYwMV0gT29wczogMDAwMCBbIzFd
IERFQlVHX1BBR0VBTExPQwpbICAgIDMuMTA1MDE4XSBDUFU6IDAgUElEOiA4NSBDb21tOiBo
b3N0bmFtZSBOb3QgdGFpbnRlZCAzLjEyLjAtcmMyLTAxOTU3LWc2ZjAxNGE3ICM0OTMKWyAg
ICAzLjEwNTcxNV0gdGFzazogODcyZmUwMDAgdGk6IDg3MzAwMDAwIHRhc2sudGk6IDg3MzAw
MDAwClsgICAgMy4xMDYyMzNdIEVJUDogMDA2MDpbPDgxMDUzZDI0Pl0gRUZMQUdTOiAwMDAx
MDIwMiBDUFU6IDAKWyAgICAzLjEwNjcyOF0gRUlQIGlzIGF0IHRhc2tfd29ya19ydW4rMHg1
NC8weGEwClsgICAgMy4xMDcxNzZdIEVBWDogMDRmYTAwOGMgRUJYOiA4NzJmMTg4MCBFQ1g6
IDAwMDAwMDAwIEVEWDogMDRmYTAwOGMKWyAgICAzLjEwNzQ0MF0gRVNJOiA4NzJmZTM4OCBF
REk6IDg3MmZlMDAwIEVCUDogODczMDFmNDAgRVNQOiA4NzMwMWYzNApbICAgIDMuMTA3NDQw
XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAz
LjEwNzQ0MF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDA0ZmEwMDhjIENSMzogMDcyZGQwMDAgQ1I0
OiAwMDAwMDZiMApbICAgIDMuMTA3NDQwXSBTdGFjazoKWyAgICAzLjEwNzQ0MF0gIGZmZmZm
ZmZmIDg3MzA5MDU4IDg3MmZlMDAwIDg3MzAxZjhjIDgxMDM5MzY1IDc3NjMxZmI4IDgxMDVh
YmZiIDAwMDAwMDAwClsgICAgMy4xMDc0NDBdICA4NzMwMWZhYyAwMDAwMDAwMSA2YzBlM2I2
NSA2MTYzNmY2YyA3MzZmNjg2YyA2ZjZjMmU3NCA2NDZjNjE2MyA4NzJmZTM5OApbICAgIDMu
MTA3NDQwXSAgODE1ZjhhNGUgODEwMjJmYTAgMDAwMDAwMDAgMDAwMDAwMDAgODcyZWU4ODAg
ODcyZmUwMDAgODczMDFmYTQgODEwMzlhNWEKWyAgICAzLjEwNzQ0MF0gQ2FsbCBUcmFjZToK
WyAgICAzLjEwNzQ0MF0gIFs8ODEwMzkzNjU+XSBkb19leGl0KzB4MmE1LzB4OTEwClsgICAg
My4xMDc0NDBdICBbPDgxMDVhYmZiPl0gPyB1cF93cml0ZSsweDFiLzB4MzAKWyAgICAzLjEw
NzQ0MF0gIFs8ODE1ZjhhNGU+XSA/IHJlc3RvcmVfYWxsKzB4Zi8weGYKWyAgICAzLjEwNzQ0
MF0gIFs8ODEwMjJmYTA+XSA/IGt2bV9yZWFkX2FuZF9yZXNldF9wZl9yZWFzb24rMHg0MC8w
eDQwClsgICAgMy4xMDc0NDBdICBbPDgxMDM5YTVhPl0gZG9fZ3JvdXBfZXhpdCsweDRhLzB4
YTAKWyAgICAzLjEwNzQ0MF0gIFs8ODEwMzlhYzg+XSBTeVNfZXhpdF9ncm91cCsweDE4LzB4
MjAKWyAgICAzLjEwNzQ0MF0gIFs8ODE1ZjkwOTA+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIv
MHgzYwpbICAgIDMuMTA3NDQwXSBDb2RlOiAzNiAzMSBjOSA4OSBkMCAwZiBiMSAwZSAzOSBj
MiA3NSBlYiA4NSBkMiA3NCA1YyA4ZCBiNCAyNiAwMCAwMCAwMCAwMCBmMyA5MCA4YiA4NyBj
MCAwMyAwMCAwMCA4NSBjMCA3NCBmNCAzMSBkYiBlYiAwNCA4OSBkMyA4OSBjMiA8OGI+IDAy
IDg5IDFhIDg1IGMwIDc1IGY0IGViIDE2IDY2IDkwIGY2IDQ3IDBjIDA0IDc0IGM0IGI5IGYw
IDBmClsgICAgMy4xMDc0NDBdIEVJUDogWzw4MTA1M2QyND5dIHRhc2tfd29ya19ydW4rMHg1
NC8weGEwIFNTOkVTUCAwMDY4Ojg3MzAxZjM0ClsgICAgMy4xMDc0NDBdIENSMjogMDAwMDAw
MDAwNGZhMDA4YwpbICAgIDMuMTE4NTMxXSAtLS1bIGVuZCB0cmFjZSAwNjAwM2MzZWVkYzE1
YzcwIF0tLS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNmYwMTRhN2Vh
OTFmODBmNzY1YmE3MDBkY2QxNzI4NjgwYmE1YzU4ZS9kbWVzZy1xdWFudGFsLWF0aGVucy0z
NjoyMDEzMTAwNTIzMDQxNDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJj
Mi0wMTk1Ny1nNmYwMTRhNzo0OTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIx
MDYvNmYwMTRhN2VhOTFmODBmNzY1YmE3MDBkY2QxNzI4NjgwYmE1YzU4ZS9kbWVzZy1xdWFu
dGFsLWNhaXJvLTQxOjIwMTMxMDA1MjMwNDE0OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
NjozLjEyLjAtcmMyLTAxOTU3LWc2ZjAxNGE3OjQ5Mwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNi82ZjAxNGE3ZWE5MWY4MGY3NjViYTcwMGRjZDE3Mjg2ODBiYTVjNThl
L2RtZXNnLXF1YW50YWwtY2Fpcm8tNToyMDEzMTAwNTIzMDQxNDppMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMTk1Ny1nNmYwMTRhNzo0OTMKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajEtMTAwNTIxMDYvNmYwMTRhN2VhOTFmODBmNzY1YmE3MDBkY2QxNzI4
NjgwYmE1YzU4ZS9kbWVzZy1xdWFudGFsLWlubi0yNjoyMDEzMTAwNTIzMDQxNTppMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMTk1Ny1nNmYwMTRhNzo0OTMKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNmYwMTRhN2VhOTFmODBmNzY1YmE3
MDBkY2QxNzI4NjgwYmE1YzU4ZS9kbWVzZy1xdWFudGFsLXJvYW0tMTM6MjAxMzEwMDUyMzA0
MTQ6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDE5NTctZzZmMDE0
YTc6NDkzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzZmMDE0YTdlYTkx
ZjgwZjc2NWJhNzAwZGNkMTcyODY4MGJhNWM1OGUvZG1lc2ctcXVhbnRhbC1yb2FtLTMxOjIw
MTMxMDA1MjMwNDE0OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAx
OTU3LWc2ZjAxNGE3OjQ5Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi82
ZjAxNGE3ZWE5MWY4MGY3NjViYTcwMGRjZDE3Mjg2ODBiYTVjNThlL2RtZXNnLXlvY3RvLWJh
eS0yOjIwMTMxMDA1MjMwNDE3OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAt
cmMyLTAxOTU3LWc2ZjAxNGE3OjQ5Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi82ZjAxNGE3ZWE5MWY4MGY3NjViYTcwMGRjZDE3Mjg2ODBiYTVjNThlL2RtZXNnLXlv
Y3RvLWNhaXJvLTQwOjIwMTMxMDA1MjMwNDE2OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
NjozLjEyLjAtcmMyLTAxOTU3LWc2ZjAxNGE3OjQ5Mwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNi82ZjAxNGE3ZWE5MWY4MGY3NjViYTcwMGRjZDE3Mjg2ODBiYTVjNThl
L2RtZXNnLXlvY3RvLWlubi0yNzoyMDEzMTAwNTIzMDQxNTppMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDY6My4xMi4wLXJjMi0wMTk1Ny1nNmYwMTRhNzo0OTMKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYvNmYwMTRhN2VhOTFmODBmNzY1YmE3MDBkY2QxNzI4Njgw
YmE1YzU4ZS9kbWVzZy15b2N0by1pbm4tNzoyMDEzMTAwNTIzMDQxMzppMzg2LXJhbmRjb25m
aWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMTk1Ny1nNmYwMTRhNzo0OTMKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNmYwMTRhN2VhOTFmODBmNzY1YmE3MDBkY2Qx
NzI4NjgwYmE1YzU4ZS9kbWVzZy15b2N0by1sa3Atc3QwMS0xMjoyMDEzMTAwNTIzMDQxNzpp
Mzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMTk1Ny1nNmYwMTRhNzo0
OTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNmYwMTRhN2VhOTFmODBm
NzY1YmE3MDBkY2QxNzI4NjgwYmE1YzU4ZS9kbWVzZy15b2N0by1uaG00LTI6MjAxMzEwMDUx
NTA3MjI6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDE5NTctZzZm
MDE0YTc6NDkzCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzZmMDE0YTdl
YTkxZjgwZjc2NWJhNzAwZGNkMTcyODY4MGJhNWM1OGUvZG1lc2cteW9jdG8tcm9hbS0xMDoy
MDEzMTAwNTIzMDQxNjppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0w
MTk1Ny1nNmYwMTRhNzo0OTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYv
NmYwMTRhN2VhOTFmODBmNzY1YmE3MDBkY2QxNzI4NjgwYmE1YzU4ZS9kbWVzZy15b2N0by1z
bmItNjoyMDEzMTAwNTIzMDQxMzppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4w
LXJjMi0wMTk1Ny1nNmYwMTRhNzo0OTMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAw
NTIxMDYvNmYwMTRhN2VhOTFmODBmNzY1YmE3MDBkY2QxNzI4NjgwYmE1YzU4ZS9kbWVzZy1x
dWFudGFsLXNuYi0xOjIwMTMxMDA1MjMwNDIwOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
NjozLjEyLjAtcmMyLTAxOTU3LWc2ZjAxNGE3OjQ5Mwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNi82ZjAxNGE3ZWE5MWY4MGY3NjViYTcwMGRjZDE3Mjg2ODBiYTVjNThl
L2RtZXNnLXlvY3RvLWxrcC10dDAyLTQ6MjAxMzEwMDUxMzMzMzc6aTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDE5NTctZzZmMDE0YTc6NDkzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzZmMDE0YTdlYTkxZjgwZjc2NWJhNzAwZGNkMTcy
ODY4MGJhNWM1OGUvZG1lc2cteW9jdG8teHBzLTI6MjAxMzEwMDYwNzAyMzI6aTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDE5NTctZzZmMDE0YTc6NDkzCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzZmMDE0YTdlYTkxZjgwZjc2NWJhNzAw
ZGNkMTcyODY4MGJhNWM1OGUvZG1lc2cteW9jdG8teHBzLTY6MjAxMzEwMDYwNzAyMzI6aTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDE5NTctZzZmMDE0YTc6NDkz
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzZmMDE0YTdlYTkxZjgwZjc2
NWJhNzAwZGNkMTcyODY4MGJhNWM1OGUvZG1lc2ctcXVhbnRhbC1iZW5zLTQ6MjAxMzEwMDUy
MzA0MjY6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDE5NTctZzZm
MDE0YTc6NDkzCgpCaXNlY3Rpbmc6IDI0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbYmNlNTZmYmMwZjE2NTY1OGY3ZTA3MTVmZWRjOGQz
OTg0MGJhZTMxY10gTWVyZ2UgYnJhbmNoICdzY2hlZC9jb3JlJwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctajEtMTAwNTIxMDYvbmV4dDptYXN0ZXI6YmNlNTZmYmMwZjE2NTY1OGY3ZTA3MTVmZWRj
OGQzOTg0MGJhZTMxYzpiaXNlY3QtdXNiCgoyMDEzLTEwLTA1LTIzOjA0OjM5IGJjZTU2ZmJj
MGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4NDBiYWUzMWMgY29tcGlsaW5nCjE0NiByZWFsICA4
NTcgdXNlciAgOTAgc3lzICA2NDkuMzclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUy
MTA2CgoyMDEzLTEwLTA1LTIzOjA3OjE1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1y
YzItMDAwOTUtZ2JjZTU2ZmIuIFRFU1QgRkFJTFVSRQpbICAgIDMuMDQwNzkwXSBXcml0ZSBw
cm90ZWN0aW5nIHRoZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDI2MTZrClsgICAgMy4wNDEz
NTJdIE5YLXByb3RlY3RpbmcgdGhlIGtlcm5lbCBkYXRhOiA2MTY4awpbICAgIDMuMDcyODE4
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDAxYzgw
MDYwClsgICAgMy4wNzM0NTZdIElQOiBbPDgxMDU0MDk0Pl0gdGFza193b3JrX3J1bisweDU0
LzB4YTAKWyAgICAzLjA3Mzk0Nl0gKnBkcHQgPSAwMDAwMDAwMDA3MmY2MDAxICpwZGUgPSAw
MDAwMDAwMDAwMDAwMDAwIApbICAgIDMuMDc0NTEwXSBPb3BzOiAwMDAwIFsjMV0gREVCVUdf
UEFHRUFMTE9DClsgICAgMy4wNzUwMzVdIENQVTogMCBQSUQ6IDg1IENvbW06IGhvc3RuYW1l
IE5vdCB0YWludGVkIDMuMTIuMC1yYzItMDAwOTUtZ2JjZTU2ZmIgIzQ5NApbICAgIDMuMDc1
MzU3XSB0YXNrOiA4NzMwYzAwMCB0aTogODczMGUwMDAgdGFzay50aTogODczMGUwMDAKWyAg
ICAzLjA3NTM1N10gRUlQOiAwMDYwOls8ODEwNTQwOTQ+XSBFRkxBR1M6IDAwMDEwMjA2IENQ
VTogMApbICAgIDMuMDc1MzU3XSBFSVAgaXMgYXQgdGFza193b3JrX3J1bisweDU0LzB4YTAK
WyAgICAzLjA3NTM1N10gRUFYOiAwMWM4MDA2MCBFQlg6IDg3MzAwMjgwIEVDWDogMDAwMDAw
MDAgRURYOiAwMWM4MDA2MApbICAgIDMuMDc1MzU3XSBFU0k6IDg3MzBjMzg4IEVESTogODcz
MGMwMDAgRUJQOiA4NzMwZmY0MCBFU1A6IDg3MzBmZjM0ClsgICAgMy4wNzUzNTddICBEUzog
MDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAgIDMuMDc1MzU3
XSBDUjA6IDgwMDUwMDNiIENSMjogMDFjODAwNjAgQ1IzOiAwNzJlYzAwMCBDUjQ6IDAwMDAw
NmIwClsgICAgMy4wNzUzNTddIFN0YWNrOgpbICAgIDMuMDc1MzU3XSAgZmZmZmZmZmYgODcy
ZGM0NTggODczMGMwMDAgODczMGZmOGMgODEwMzk2ZDUgNzc2ODdmYjggODEwNWFmNmIgMDAw
MDAwMDAKWyAgICAzLjA3NTM1N10gIDg3MzBmZmFjIDAwMDAwMDAxIDZjMGU0M2Q1IDYxNjM2
ZjZjIDczNmY2ODZjIDZmNmMyZTc0IDY0NmM2MTYzIDg3MzBjMzk4ClsgICAgMy4wNzUzNTdd
ICA4MTVmNzlhZSA4MTAyMmY4MCAwMDAwMDAwMCAwMDAwMDAwMCA4NzJlZjg4MCA4NzMwYzAw
MCA4NzMwZmZhNCA4MTAzOWRjYQpbICAgIDMuMDc1MzU3XSBDYWxsIFRyYWNlOgpbICAgIDMu
MDc1MzU3XSAgWzw4MTAzOTZkNT5dIGRvX2V4aXQrMHgyYTUvMHg5MTAKWyAgICAzLjA3NTM1
N10gIFs8ODEwNWFmNmI+XSA/IHVwX3dyaXRlKzB4MWIvMHgzMApbICAgIDMuMDc1MzU3XSAg
Wzw4MTVmNzlhZT5dID8gcmVzdG9yZV9hbGwrMHhmLzB4ZgpbICAgIDMuMDc1MzU3XSAgWzw4
MTAyMmY4MD5dID8ga3ZtX3JlYWRfYW5kX3Jlc2V0X3BmX3JlYXNvbisweDQwLzB4NDAKWyAg
ICAzLjA3NTM1N10gIFs8ODEwMzlkY2E+XSBkb19ncm91cF9leGl0KzB4NGEvMHhhMApbICAg
IDMuMDc1MzU3XSAgWzw4MTAzOWUzOD5dIFN5U19leGl0X2dyb3VwKzB4MTgvMHgyMApbICAg
IDMuMDc1MzU3XSAgWzw4MTVmN2ZmMD5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsg
ICAgMy4wNzUzNTddIENvZGU6IDM2IDMxIGM5IDg5IGQwIDBmIGIxIDBlIDM5IGMyIDc1IGVi
IDg1IGQyIDc0IDVjIDhkIGI0IDI2IDAwIDAwIDAwIDAwIGYzIDkwIDhiIDg3IGMwIDAzIDAw
IDAwIDg1IGMwIDc0IGY0IDMxIGRiIGViIDA0IDg5IGQzIDg5IGMyIDw4Yj4gMDIgODkgMWEg
ODUgYzAgNzUgZjQgZWIgMTYgNjYgOTAgZjYgNDcgMGMgMDQgNzQgYzQgYjkgZjAgZGYKWyAg
ICAzLjA3NTM1N10gRUlQOiBbPDgxMDU0MDk0Pl0gdGFza193b3JrX3J1bisweDU0LzB4YTAg
U1M6RVNQIDAwNjg6ODczMGZmMzQKWyAgICAzLjA3NTM1N10gQ1IyOiAwMDAwMDAwMDAxYzgw
MDYwClsgICAgMy4wODg4MDZdIC0tLVsgZW5kIHRyYWNlIDk0OTUwOTc0ZTJhOGQ5MWMgXS0t
LQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9iY2U1NmZiYzBmMTY1NjU4
ZjdlMDcxNWZlZGM4ZDM5ODQwYmFlMzFjL2RtZXNnLXF1YW50YWwtcm9hbS0xNjoyMDEzMTAw
NTIzMDcyNDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMDA5NS1n
YmNlNTZmYjo0OTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYmNlNTZm
YmMwZjE2NTY1OGY3ZTA3MTVmZWRjOGQzOTg0MGJhZTMxYy9kbWVzZy15b2N0by1hdGhlbnMt
MTY6MjAxMzEwMDUyMzA3MjU6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1y
YzItMDAwOTUtZ2JjZTU2ZmI6NDk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUy
MTA2L2JjZTU2ZmJjMGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4NDBiYWUzMWMvZG1lc2cteW9j
dG8tYXRoZW5zLTI1OjIwMTMxMDA1MjMwNzIyOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
NjozLjEyLjAtcmMyLTAwMDk1LWdiY2U1NmZiOjQ5NAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNi9iY2U1NmZiYzBmMTY1NjU4ZjdlMDcxNWZlZGM4ZDM5ODQwYmFlMzFj
L2RtZXNnLXlvY3RvLXhpYW4tMTU6MjAxMzEwMDUyMzA3MjQ6aTM4Ni1yYW5kY29uZmlnLWox
LTEwMDUyMTA2OjMuMTIuMC1yYzItMDAwOTUtZ2JjZTU2ZmI6NDk0Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2L2JjZTU2ZmJjMGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4
NDBiYWUzMWMvZG1lc2ctcXVhbnRhbC1pbm4tMjc6MjAxMzEwMDUyMzA3MjY6aTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDAwOTUtZ2JjZTU2ZmI6NDk0Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2JjZTU2ZmJjMGYxNjU2NThmN2UwNzE1
ZmVkYzhkMzk4NDBiYWUzMWMvZG1lc2ctcXVhbnRhbC1yb2FtLTI4OjIwMTMxMDA1MjMwNzI2
OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAwMDk1LWdiY2U1NmZi
OjQ5NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9iY2U1NmZiYzBmMTY1
NjU4ZjdlMDcxNWZlZGM4ZDM5ODQwYmFlMzFjL2RtZXNnLXlvY3RvLWNhaXJvLTk6MjAxMzEw
MDUyMzA3MjU6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItMDAwOTUt
Z2JjZTU2ZmI6NDk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2JjZTU2
ZmJjMGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4NDBiYWUzMWMvZG1lc2ctcXVhbnRhbC1hdGhl
bnMtNDY6MjAxMzEwMDUyMzA3MzQ6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIu
MC1yYzItMDAwOTUtZ2JjZTU2ZmI6NDk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEw
MDUyMTA2L2JjZTU2ZmJjMGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4NDBiYWUzMWMvZG1lc2ct
cXVhbnRhbC1pbm4tMzE6MjAxMzEwMDUyMzA3MzQ6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUy
MTA2OjMuMTIuMC1yYzItMDAwOTUtZ2JjZTU2ZmI6NDk0Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWoxLTEwMDUyMTA2L2JjZTU2ZmJjMGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4NDBiYWUz
MWMvZG1lc2ctcXVhbnRhbC1yb2FtLTE3OjIwMTMxMDA1MjMwNzI5OmkzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLTAwMDk1LWdiY2U1NmZiOjQ5NAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9iY2U1NmZiYzBmMTY1NjU4ZjdlMDcxNWZlZGM4
ZDM5ODQwYmFlMzFjL2RtZXNnLXlvY3RvLWF0aGVucy0zMDoyMDEzMTAwNTIzMDczMTppMzg2
LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMDA5NS1nYmNlNTZmYjo0OTQK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYmNlNTZmYmMwZjE2NTY1OGY3
ZTA3MTVmZWRjOGQzOTg0MGJhZTMxYy9kbWVzZy15b2N0by1jYWlyby00ODoyMDEzMTAwNTIz
MDczMzppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMDA5NS1nYmNl
NTZmYjo0OTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYmNlNTZmYmMw
ZjE2NTY1OGY3ZTA3MTVmZWRjOGQzOTg0MGJhZTMxYy9kbWVzZy1xdWFudGFsLWpha2V0b3du
LTI1OjIwMTMxMDA1MjMwNzMzOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAt
cmMyLTAwMDk1LWdiY2U1NmZiOjQ5NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi9iY2U1NmZiYzBmMTY1NjU4ZjdlMDcxNWZlZGM4ZDM5ODQwYmFlMzFjL2RtZXNnLXF1
YW50YWwtamFrZXRvd24tNDA6MjAxMzEwMDUyMzA3Mzc6aTM4Ni1yYW5kY29uZmlnLWoxLTEw
MDUyMTA2OjMuMTIuMC1yYzItMDAwOTUtZ2JjZTU2ZmI6NDk0Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2L2JjZTU2ZmJjMGYxNjU2NThmN2UwNzE1ZmVkYzhkMzk4NDBi
YWUzMWMvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0xNzoyMDEzMTAwNTEzMzY1ODppMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMDA5NS1nYmNlNTZmYjo0OTQKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYmNlNTZmYmMwZjE2NTY1OGY3ZTA3
MTVmZWRjOGQzOTg0MGJhZTMxYy9kbWVzZy1xdWFudGFsLXNuYi0zMToyMDEzMTAwNTIzMDcz
NzppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMDA5NS1nYmNlNTZm
Yjo0OTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYmNlNTZmYmMwZjE2
NTY1OGY3ZTA3MTVmZWRjOGQzOTg0MGJhZTMxYy9kbWVzZy1xdWFudGFsLXNuYi00MToyMDEz
MTAwNTIzMDczNTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi0wMDA5
NS1nYmNlNTZmYjo0OTQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYmNl
NTZmYmMwZjE2NTY1OGY3ZTA3MTVmZWRjOGQzOTg0MGJhZTMxYy9kbWVzZy1xdWFudGFsLWxr
cC1zdDAxLTE6MjAxMzEwMDUyMzA3NDI6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMu
MTIuMC1yYzItMDAwOTUtZ2JjZTU2ZmI6NDk0CgpCaXNlY3Rpbmc6IDIyIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbYzJkYWEzYmVkNTNh
ODExNzFjZjhjMWEzNmRiNzk4ZTgyYjkxYWZlOF0gc2NoZWQsIHg4NjogUHJvdmlkZSBhIHBl
ci1jcHUgcHJlZW1wdF9jb3VudCBpbXBsZW1lbnRhdGlvbgpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDYvbmV4dDptYXN0ZXI6YzJkYWEzYmVkNTNhODExNzFjZjhjMWEzNmRiNzk4
ZTgyYjkxYWZlODpiaXNlY3QtdXNiCgoyMDEzLTEwLTA1LTIzOjA3OjQ4IGMyZGFhM2JlZDUz
YTgxMTcxY2Y4YzFhMzZkYjc5OGU4MmI5MWFmZTggY29tcGlsaW5nCjE0MiByZWFsICA4NTEg
dXNlciAgODkgc3lzICA2NjAuMTclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
CgoyMDEzLTEwLTA1LTIzOjEwOjIxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEt
MDAwNjAtZ2MyZGFhM2IuIFRFU1QgRkFJTFVSRQpbICAgIDMuMDgyNDk5XSBXcml0ZSBwcm90
ZWN0aW5nIHRoZSBrZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDI2MjBrClsgICAgMy4wODMwMzdd
IE5YLXByb3RlY3RpbmcgdGhlIGtlcm5lbCBkYXRhOiA2MTcyawpbICAgIDMuMTE3NDgzXSBC
VUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDA1MmEwMDgw
ClsgICAgMy4xMTgxMTZdIElQOiBbPDgxMDU0MGQ0Pl0gdGFza193b3JrX3J1bisweDU0LzB4
YTAKWyAgICAzLjExODU5Nl0gKnBkcHQgPSAwMDAwMDAwMDA3MmRmMDAxICpwZGUgPSAwMDAw
MDAwMDAwMDAwMDAwIApbICAgIDMuMTE5MTU3XSBPb3BzOiAwMDAwIFsjMV0gREVCVUdfUEFH
RUFMTE9DClsgICAgMy4xMTk1NzNdIENQVTogMCBQSUQ6IDg1IENvbW06IGhvc3RuYW1lIE5v
dCB0YWludGVkIDMuMTIuMC1yYzEtMDAwNjAtZ2MyZGFhM2IgIzQ5NQpbICAgIDMuMTIwMjgz
XSB0YXNrOiA4NzMwYzAwMCB0aTogODczMGUwMDAgdGFzay50aTogODczMGUwMDAKWyAgICAz
LjEyMDc3OV0gRUlQOiAwMDYwOls8ODEwNTQwZDQ+XSBFRkxBR1M6IDAwMDEwMjAyIENQVTog
MApbICAgIDMuMTIxMjgzXSBFSVAgaXMgYXQgdGFza193b3JrX3J1bisweDU0LzB4YTAKWyAg
ICAzLjEyMTY4NV0gRUFYOiAwNTJhMDA4MCBFQlg6IDg3MzE3ODgwIEVDWDogMDAwMDAwMDAg
RURYOiAwNTJhMDA4MApbICAgIDMuMTIyMjY0XSBFU0k6IDg3MzBjMzg4IEVESTogODczMGMw
MDAgRUJQOiA4NzMwZmY0MCBFU1A6IDg3MzBmZjM0ClsgICAgMy4xMjI4MzldICBEUzogMDA3
YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAgIDMuMTIzMzMzXSBD
UjA6IDgwMDUwMDNiIENSMjogMDUyYTAwODAgQ1IzOiAwNzJkNjAwMCBDUjQ6IDAwMDAwNmIw
ClsgICAgMy4xMjM5MTZdIFN0YWNrOgpbICAgIDMuMTI0MTA4XSAgZmZmZmZmZmYgODczMDcw
NTggODczMGMwMDAgODczMGZmOGMgODEwMzk3MTUgNzc2MWNmYjggODEwNWFmYWIgMDAwMDAw
MDAKWyAgICAzLjEyNDkyOV0gIDg3MzBmZmFjIDAwMDAwMDAxIDZjMGU0MmQ1IDYxNjM2ZjZj
IDczNmY2ODZjIDZmNmMyZTc0IDY0NmM2MTYzIDg3MzBjMzk4ClsgICAgMy4xMjU3NDBdICA4
MTVmNzY4ZSA4MTAyMmZjMCAwMDAwMDAwMCAwMDAwMDAwMCA4NzJlZjg4MCA4NzMwYzAwMCA4
NzMwZmZhNCA4MTAzOWUwYQpbICAgIDMuMTI1OTc5XSBDYWxsIFRyYWNlOgpbICAgIDMuMTI1
OTc5XSAgWzw4MTAzOTcxNT5dIGRvX2V4aXQrMHgyYTUvMHg5MTAKWyAgICAzLjEyNTk3OV0g
IFs8ODEwNWFmYWI+XSA/IHVwX3dyaXRlKzB4MWIvMHgzMApbICAgIDMuMTI1OTc5XSAgWzw4
MTVmNzY4ZT5dID8gcmVzdG9yZV9hbGwrMHhmLzB4ZgpbICAgIDMuMTI1OTc5XSAgWzw4MTAy
MmZjMD5dID8ga3ZtX3JlYWRfYW5kX3Jlc2V0X3BmX3JlYXNvbisweDQwLzB4NDAKWyAgICAz
LjEyNTk3OV0gIFs8ODEwMzllMGE+XSBkb19ncm91cF9leGl0KzB4NGEvMHhhMApbICAgIDMu
MTI1OTc5XSAgWzw4MTAzOWU3OD5dIFN5U19leGl0X2dyb3VwKzB4MTgvMHgyMApbICAgIDMu
MTI1OTc5XSAgWzw4MTVmN2NkMD5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAg
My4xMjU5NzldIENvZGU6IDM2IDMxIGM5IDg5IGQwIDBmIGIxIDBlIDM5IGMyIDc1IGViIDg1
IGQyIDc0IDVjIDhkIGI0IDI2IDAwIDAwIDAwIDAwIGYzIDkwIDhiIDg3IGMwIDAzIDAwIDAw
IDg1IGMwIDc0IGY0IDMxIGRiIGViIDA0IDg5IGQzIDg5IGMyIDw4Yj4gMDIgODkgMWEgODUg
YzAgNzUgZjQgZWIgMTYgNjYgOTAgZjYgNDcgMGMgMDQgNzQgYzQgYjkgZjAgY2YKWyAgICAz
LjEyNTk3OV0gRUlQOiBbPDgxMDU0MGQ0Pl0gdGFza193b3JrX3J1bisweDU0LzB4YTAgU1M6
RVNQIDAwNjg6ODczMGZmMzQKWyAgICAzLjEyNTk3OV0gQ1IyOiAwMDAwMDAwMDA1MmEwMDgw
ClsgICAgMy4xMzMxOThdIC0tLVsgZW5kIHRyYWNlIGIyNzBiNjgxMzg2YmM0NTIgXS0tLQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9jMmRhYTNiZWQ1M2E4MTE3MWNm
OGMxYTM2ZGI3OThlODJiOTFhZmU4L2RtZXNnLXF1YW50YWwtYXRoZW5zLTIzOjIwMTMxMDA1
MjMxMDMwOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDYwLWdj
MmRhYTNiOjQ5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9jMmRhYTNi
ZWQ1M2E4MTE3MWNmOGMxYTM2ZGI3OThlODJiOTFhZmU4L2RtZXNnLXF1YW50YWwtY2Fpcm8t
MTE6MjAxMzEwMDUyMzEwMjg6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1y
YzEtMDAwNjAtZ2MyZGFhM2I6NDk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUy
MTA2L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5OGU4MmI5MWFmZTgvZG1lc2ctcXVh
bnRhbC1jYWlyby0xNjoyMDEzMTAwNTIzMTAzMzppMzg2LXJhbmRjb25maWctajEtMTAwNTIx
MDY6My4xMi4wLXJjMS0wMDA2MC1nYzJkYWEzYjo0OTUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctajEtMTAwNTIxMDYvYzJkYWEzYmVkNTNhODExNzFjZjhjMWEzNmRiNzk4ZTgyYjkxYWZl
OC9kbWVzZy1xdWFudGFsLWNhaXJvLTM6MjAxMzEwMDUyMzEwMjk6aTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNjAtZ2MyZGFhM2I6NDk1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5
OGU4MmI5MWFmZTgvZG1lc2ctcXVhbnRhbC1yb2FtLTI0OjIwMTMxMDA1MjMxMDI5OmkzODYt
cmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDYwLWdjMmRhYTNiOjQ5NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9jMmRhYTNiZWQ1M2E4MTE3MWNm
OGMxYTM2ZGI3OThlODJiOTFhZmU4L2RtZXNnLXF1YW50YWwtcm9hbS0zMToyMDEzMTAwNTIz
MTAzMjppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMS0wMDA2MC1nYzJk
YWEzYjo0OTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYzJkYWEzYmVk
NTNhODExNzFjZjhjMWEzNmRiNzk4ZTgyYjkxYWZlOC9kbWVzZy1xdWFudGFsLXhpYW4tMTc6
MjAxMzEwMDUyMzEwMzI6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEt
MDAwNjAtZ2MyZGFhM2I6NDk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5OGU4MmI5MWFmZTgvZG1lc2ctcXVhbnRh
bC14aWFuLTMyOjIwMTMxMDA1MjMxMDI5OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjoz
LjEyLjAtcmMxLTAwMDYwLWdjMmRhYTNiOjQ5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNi9jMmRhYTNiZWQ1M2E4MTE3MWNmOGMxYTM2ZGI3OThlODJiOTFhZmU4L2Rt
ZXNnLXlvY3RvLWF0aGVucy0yMDoyMDEzMTAwNTIzMTAzMjppMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDY6My4xMi4wLXJjMS0wMDA2MC1nYzJkYWEzYjo0OTUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYvYzJkYWEzYmVkNTNhODExNzFjZjhjMWEzNmRiNzk4ZTgy
YjkxYWZlOC9kbWVzZy15b2N0by1pbm4tMzU6MjAxMzEwMDUyMzEwMzM6aTM4Ni1yYW5kY29u
ZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNjAtZ2MyZGFhM2I6NDk1Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZk
Yjc5OGU4MmI5MWFmZTgvZG1lc2cteW9jdG8taW5uLTM3OjIwMTMxMDA1MjMxMDMyOmkzODYt
cmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDYwLWdjMmRhYTNiOjQ5NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9jMmRhYTNiZWQ1M2E4MTE3MWNm
OGMxYTM2ZGI3OThlODJiOTFhZmU4L2RtZXNnLXlvY3RvLXJvYW0tMTg6MjAxMzEwMDUyMzEw
MzI6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNjAtZ2MyZGFh
M2I6NDk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2MyZGFhM2JlZDUz
YTgxMTcxY2Y4YzFhMzZkYjc5OGU4MmI5MWFmZTgvZG1lc2cteW9jdG8tc25iLTE1OjIwMTMx
MDA1MjMxMDMwOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDYw
LWdjMmRhYTNiOjQ5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9jMmRh
YTNiZWQ1M2E4MTE3MWNmOGMxYTM2ZGI3OThlODJiOTFhZmU4L2RtZXNnLXF1YW50YWwtc25i
LTQ4OjIwMTMxMDA1MjMxMDM0OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAt
cmMxLTAwMDYwLWdjMmRhYTNiOjQ5NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi9jMmRhYTNiZWQ1M2E4MTE3MWNmOGMxYTM2ZGI3OThlODJiOTFhZmU4L2RtZXNnLXF1
YW50YWwtc25iLTQ6MjAxMzEwMDUyMzEwMzc6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
OjMuMTIuMC1yYzEtMDAwNjAtZ2MyZGFhM2I6NDk1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5OGU4MmI5MWFmZTgv
ZG1lc2cteW9jdG8tbGtwLXR0MDItMTY6MjAxMzEwMDUxMzM5NTU6aTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNjAtZ2MyZGFhM2I6NDk1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2MyZGFhM2JlZDUzYTgxMTcxY2Y4YzFhMzZkYjc5
OGU4MmI5MWFmZTgvZG1lc2ctcXVhbnRhbC1qYWtldG93bi00ODoyMDEzMTAwNTIzMTA0NDpp
Mzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMS0wMDA2MC1nYzJkYWEzYjo0
OTUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYzJkYWEzYmVkNTNhODEx
NzFjZjhjMWEzNmRiNzk4ZTgyYjkxYWZlOC9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTM6MjAx
MzEwMDUxMzQwMDY6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAw
NjAtZ2MyZGFhM2I6NDk1CgpCaXNlY3Rpbmc6IDEwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbNDMxNDg5NTE2NTYyMzg3OTkzN2Y0NmQ3
Njc2NzM2NTQ2NjJiNTcwY10gc2NoZWQ6IE1pY3JvLW9wdGltaXplIGJ5IGRyb3BwaW5nIHVu
bmVjZXNzYXJ5IHRhc2tfcnEoKSBjYWxscwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajEtMTAwNTIx
MDYvbmV4dDptYXN0ZXI6NDMxNDg5NTE2NTYyMzg3OTkzN2Y0NmQ3Njc2NzM2NTQ2NjJiNTcw
YzpiaXNlY3QtdXNiCgoyMDEzLTEwLTA1LTIzOjEwOjUzIDQzMTQ4OTUxNjU2MjM4Nzk5Mzdm
NDZkNzY3NjczNjU0NjYyYjU3MGMgY29tcGlsaW5nCjE2NyByZWFsICA4NDIgdXNlciAgODMg
c3lzICA1NTIuODUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2CgoyMDEzLTEw
LTA1LTIzOjEzOjUzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNDktZzQz
MTQ4OTUJNAkxMAkxMQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDUgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCls0YTJiNGIyMjI3NDNiYjA3
ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3ZWE5XSBzY2hlZDogSW50cm9kdWNlIHByZWVtcHRfY291
bnQgYWNjZXNzb3IgZnVuY3Rpb25zCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9u
ZXh0Om1hc3Rlcjo0YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3ZWE5OmJp
c2VjdC11c2IKCjIwMTMtMTAtMDUtMjM6MTU6NTQgNGEyYjRiMjIyNzQzYmIwN2ZlZGY5ODVi
ODg0NTUwZjJjYTA2N2VhOSBjb21waWxpbmcKMTM1IHJlYWwgIDg0OSB1c2VyICA4NiBzeXMg
IDY5MS40NSUgY3B1IAlpMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYKCjIwMTMtMTAtMDUt
MjM6MTg6MTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0wMDA1NC1nNGEyYjRi
Mi4gVEVTVCBGQUlMVVJFClsgICAgOC44MTA3NjZdIFdyaXRlIHByb3RlY3RpbmcgdGhlIGtl
cm5lbCByZWFkLW9ubHkgZGF0YTogMjYyMGsKWyAgICA4LjgxMTY5Ml0gTlgtcHJvdGVjdGlu
ZyB0aGUga2VybmVsIGRhdGE6IDYxNjRrClsgICAgOC45NTI5NjZdIEJVRzogdW5hYmxlIHRv
IGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgMDU1MjAwNjAKWyAgICA4Ljk1NDA4
NF0gSVA6IFs8ODEwNTQ1MzQ+XSB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMApbICAgIDguOTU0
OTUwXSAqcGRwdCA9IDAwMDAwMDAwMDcyZjYwMDEgKnBkZSA9IDAwMDAwMDAwMDAwMDAwMDAg
ClsgICAgOC45NTU5MjZdIE9vcHM6IDAwMDAgWyMxXSBERUJVR19QQUdFQUxMT0MKWyAgICA4
Ljk1NjY1MV0gQ1BVOiAwIFBJRDogODUgQ29tbTogaG9zdG5hbWUgTm90IHRhaW50ZWQgMy4x
Mi4wLXJjMS0wMDA1NC1nNGEyYjRiMiAjNDk3ClsgICAgOC45NTc4OTZdIHRhc2s6IDg3MzBj
MDAwIHRpOiA4NzMwZTAwMCB0YXNrLnRpOiA4NzMwZTAwMApbICAgIDguOTU4ODk0XSBFSVA6
IDAwNjA6Wzw4MTA1NDUzND5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsgICAgOC45NTk5
NDBdIEVJUCBpcyBhdCB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMApbICAgIDguOTYwODk4XSBF
QVg6IDA1NTIwMDYwIEVCWDogODcyZGQ5ODAgRUNYOiAwMDAwMDAwMCBFRFg6IDA1NTIwMDYw
ClsgICAgOC45NjIyOThdIEVTSTogODczMGMzODggRURJOiA4NzMwYzAwMCBFQlA6IDg3MzBm
ZjQwIEVTUDogODczMGZmMzQKWyAgICA4Ljk2MjY3MV0gIERTOiAwMDdiIEVTOiAwMDdiIEZT
OiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgOC45NjI2NzFdIENSMDogODAwNTAwM2Ig
Q1IyOiAwNTUyMDA2MCBDUjM6IDA3MmVjMDAwIENSNDogMDAwMDA2YjAKWyAgICA4Ljk2MjY3
MV0gU3RhY2s6ClsgICAgOC45NjI2NzFdICBmZmZmZmZmZiA4NzJkYzQ1OCA4NzMwYzAwMCA4
NzMwZmY4YyA4MTAzOTk5NiA3NzY4NWZiOCA4MTA1YjQ3YiAwMDAwMDAwMApbICAgIDguOTYy
NjcxXSAgODczMGZmYWMgMDAwMDAwMDEgNmMwZTRiOGQgNjE2MzZmNmMgNzM2ZjY4NmMgNmY2
YzJlNzQgNjQ2YzYxNjMgODczMGMzOTgKWyAgICA4Ljk2MjY3MV0gIDgxNWY5MThlIDgxMDIz
MGYwIDAwMDAwMDAwIDAwMDAwMDAwIDg3MmVmODgwIDg3MzBjMDAwIDg3MzBmZmE0IDgxMDNh
MDhhClsgICAgOC45NjI2NzFdIENhbGwgVHJhY2U6ClsgICAgOC45NjI2NzFdICBbPDgxMDM5
OTk2Pl0gZG9fZXhpdCsweDJiNi8weDkyMApbICAgIDguOTYyNjcxXSAgWzw4MTA1YjQ3Yj5d
ID8gdXBfd3JpdGUrMHgxYi8weDMwClsgICAgOC45NjI2NzFdICBbPDgxNWY5MThlPl0gPyBy
ZXN0b3JlX2FsbCsweGYvMHhmClsgICAgOC45NjI2NzFdICBbPDgxMDIzMGYwPl0gPyBrdm1f
cmVhZF9hbmRfcmVzZXRfcGZfcmVhc29uKzB4NDAvMHg0MApbICAgIDguOTYyNjcxXSAgWzw4
MTAzYTA4YT5dIGRvX2dyb3VwX2V4aXQrMHg0YS8weGEwClsgICAgOC45NjI2NzFdICBbPDgx
MDNhMGY4Pl0gU3lTX2V4aXRfZ3JvdXArMHgxOC8weDIwClsgICAgOC45NjI2NzFdICBbPDgx
NWY5N2QwPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAgICA4Ljk2MjY3MV0gQ29k
ZTogMzYgMzEgYzkgODkgZDAgMGYgYjEgMGUgMzkgYzIgNzUgZWIgODUgZDIgNzQgNWMgOGQg
YjQgMjYgMDAgMDAgMDAgMDAgZjMgOTAgOGIgODcgYzAgMDMgMDAgMDAgODUgYzAgNzQgZjQg
MzEgZGIgZWIgMDQgODkgZDMgODkgYzIgPDhiPiAwMiA4OSAxYSA4NSBjMCA3NSBmNCBlYiAx
NiA2NiA5MCBmNiA0NyAwYyAwNCA3NCBjNCBiOSBmMCBlZgpbICAgIDguOTYyNjcxXSBFSVA6
IFs8ODEwNTQ1MzQ+XSB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMCBTUzpFU1AgMDA2ODo4NzMw
ZmYzNApbICAgIDguOTYyNjcxXSBDUjI6IDAwMDAwMDAwMDU1MjAwNjAKWyAgICA4Ljk4MjUy
MV0gLS0tWyBlbmQgdHJhY2UgYTY3NTM2YzU4YWQ0Njc2OSBdLS0tCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2LzRhMmI0YjIyMjc0M2JiMDdmZWRmOTg1Yjg4NDU1MGYy
Y2EwNjdlYTkvZG1lc2cteW9jdG8tbmhtNC0xOjIwMTMxMDA1MTUyMTQxOmkzODYtcmFuZGNv
bmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDU0LWc0YTJiNGIyOjQ5Nwova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4
ODQ1NTBmMmNhMDY3ZWE5L2RtZXNnLXlvY3RvLWxrcC10dDAyLTE5OjIwMTMxMDA1MTM0NzU0
OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDU0LWc0YTJiNGIy
OjQ5Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80YTJiNGIyMjI3NDNi
YjA3ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3ZWE5L2RtZXNnLXF1YW50YWwtYmVucy0yOjIwMTMx
MDA1MjMxODM3OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDU0
LWc0YTJiNGIyOjQ5Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80YTJi
NGIyMjI3NDNiYjA3ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3ZWE5L2RtZXNnLXF1YW50YWwtc3Rv
YWtsZXktMToyMDEzMTAwNTIzMTg0NDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4x
Mi4wLXJjMS0wMDA1NC1nNGEyYjRiMjo0OTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDYvNGEyYjRiMjIyNzQzYmIwN2ZlZGY5ODViODg0NTUwZjJjYTA2N2VhOS9kbWVz
Zy15b2N0by1qYWtldG93bi0xMDoyMDEzMTAwNTIzMTgzNzppMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDY6My4xMi4wLXJjMS0wMDA1NC1nNGEyYjRiMjo0OTcKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYvNGEyYjRiMjIyNzQzYmIwN2ZlZGY5ODViODg0NTUwZjJj
YTA2N2VhOS9kbWVzZy15b2N0by1qYWtldG93bi0yODoyMDEzMTAwNTIzMTg0MjppMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMS0wMDA1NC1nNGEyYjRiMjo0OTcKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNGEyYjRiMjIyNzQzYmIwN2ZlZGY5
ODViODg0NTUwZjJjYTA2N2VhOS9kbWVzZy15b2N0by1qYWtldG93bi00NzoyMDEzMTAwNTIz
MTgzNjppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMS0wMDA1NC1nNGEy
YjRiMjo0OTcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvNGEyYjRiMjIy
NzQzYmIwN2ZlZGY5ODViODg0NTUwZjJjYTA2N2VhOS9kbWVzZy15b2N0by13YWltZWEtMTI6
MjAxMzEwMDYwNzE3Mjg6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEt
MDAwNTQtZzRhMmI0YjI6NDk3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
LzRhMmI0YjIyMjc0M2JiMDdmZWRmOTg1Yjg4NDU1MGYyY2EwNjdlYTkvZG1lc2ctcXVhbnRh
bC1sa3Atc3QwMS03OjIwMTMxMDA1MjMxODQ4OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
NjozLjEyLjAtcmMxLTAwMDU0LWc0YTJiNGIyOjQ5Nwova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNi80YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3ZWE5
L2RtZXNnLXlvY3RvLWxrcC1zdDAxLTEyOjIwMTMxMDA1MjMxODQ1OmkzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDU0LWc0YTJiNGIyOjQ5Nwova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi80YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4ODQ1
NTBmMmNhMDY3ZWE5L2RtZXNnLXlvY3RvLXN0b2FrbGV5LTY6MjAxMzEwMDUyMzE4NDc6aTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNTQtZzRhMmI0YjI6NDk3
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzRhMmI0YjIyMjc0M2JiMDdm
ZWRmOTg1Yjg4NDU1MGYyY2EwNjdlYTkvZG1lc2ctcXVhbnRhbC1iZW5zLTQ6MjAxMzEwMDUy
MzE4NDg6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNTQtZzRh
MmI0YjI6NDk3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzRhMmI0YjIy
Mjc0M2JiMDdmZWRmOTg1Yjg4NDU1MGYyY2EwNjdlYTkvZG1lc2ctcXVhbnRhbC1sa3AtdHQw
Mi0zOjIwMTMxMDA1MTM0ODA2OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAt
cmMxLTAwMDU0LWc0YTJiNGIyOjQ5Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi80YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3ZWE5L2RtZXNnLXlv
Y3RvLWxrcC10dDAyLTE2OjIwMTMxMDA1MTM0ODA3OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNjozLjEyLjAtcmMxLTAwMDU0LWc0YTJiNGIyOjQ5Nwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qMS0xMDA1MjEwNi80YTJiNGIyMjI3NDNiYjA3ZmVkZjk4NWI4ODQ1NTBmMmNhMDY3
ZWE5L2RtZXNnLXlvY3RvLWxrcC10dDAyLTQ6MjAxMzEwMDUxMzQ4MDc6aTM4Ni1yYW5kY29u
ZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNTQtZzRhMmI0YjI6NDk3CgpCaXNlY3Rp
bmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3Rl
cCkKW2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQyYWRlZWUxYjk3MzZdIHNjaGVkLCBy
Y3U6IE1ha2UgUkNVIHVzZSByZXNjaGVkX2NwdSgpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0x
MDA1MjEwNi9uZXh0Om1hc3RlcjpiMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVl
MWI5NzM2OmJpc2VjdC11c2IKCjIwMTMtMTAtMDUtMjM6MTg6NTIgYjAyMWZlM2UyNTA5NGZi
ZWMyMmQwZWZmODQ2ZDJhZGVlZTFiOTczNiBjb21waWxpbmcKMTQyIHJlYWwgIDg0OSB1c2Vy
ICA4MyBzeXMgIDY1NS45NyUgY3B1IAlpMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYKCjIw
MTMtMTAtMDUtMjM6MjE6MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMS0wMDA1
MS1nYjAyMWZlMy4gVEVTVCBGQUlMVVJFClsgICAgOC4zMzM1ODddIFdyaXRlIHByb3RlY3Rp
bmcgdGhlIGtlcm5lbCByZWFkLW9ubHkgZGF0YTogMjYxNmsKWyAgICA4LjMzNDQ5MF0gTlgt
cHJvdGVjdGluZyB0aGUga2VybmVsIGRhdGE6IDYxNjBrClsgICAgOC40OTgwNTNdIEJVRzog
dW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgMDRiNDAwNjAKWyAg
ICA4LjQ5OTEzM10gSVA6IFs8ODEwNTQ1ZTQ+XSB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMApb
ICAgIDguNTAwMDA2XSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUz
ZjAwMGZmNTMgClsgICAgOC41MDA5NTddIE9vcHM6IDAwMDAgWyMxXSBERUJVR19QQUdFQUxM
T0MKWyAgICA4LjUwMTY3Ml0gQ1BVOiAwIFBJRDogODUgQ29tbTogaG9zdG5hbWUgTm90IHRh
aW50ZWQgMy4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMyAjNDk4ClsgICAgOC41MDI4ODBdIHRh
c2s6IDg3MzBjMDAwIHRpOiA4NzMwZTAwMCB0YXNrLnRpOiA4NzMwZTAwMApbICAgIDguNTAz
NzY3XSBFSVA6IDAwNjA6Wzw4MTA1NDVlND5dIEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsg
ICAgOC41MDQ2MDFdIEVJUCBpcyBhdCB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMApbICAgIDgu
NTA1Mjc3XSBFQVg6IDA0YjQwMDYwIEVCWDogODcyZmU4ODAgRUNYOiAwMDAwMDAwMCBFRFg6
IDA0YjQwMDYwClsgICAgOC41MDUzNThdIEVTSTogODczMGMzODggRURJOiA4NzMwYzAwMCBF
QlA6IDg3MzBmZjQwIEVTUDogODczMGZmMzQKWyAgICA4LjUwNTM1OF0gIERTOiAwMDdiIEVT
OiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNTOiAwMDY4ClsgICAgOC41MDUzNThdIENSMDog
ODAwNTAwM2IgQ1IyOiAwNGI0MDA2MCBDUjM6IDA3MzAxMDAwIENSNDogMDAwMDA2YjAKWyAg
ICA4LjUwNTM1OF0gU3RhY2s6ClsgICAgOC41MDUzNThdICBmZmZmZmZmZiA4NzJkZDQ1OCA4
NzMwYzAwMCA4NzMwZmY4YyA4MTAzOTlhNiA3NzY3N2ZiOCA4MTA1YjU5YiAwMDAwMDAwMApb
ICAgIDguNTA1MzU4XSAgODczMGZmYWMgMDAwMDAwMDEgNmMwZTRkOWQgNjE2MzZmNmMgNzM2
ZjY4NmMgNmY2YzJlNzQgNjQ2YzYxNjMgODczMGMzOTgKWyAgICA4LjUwNTM1OF0gIDgxNWY5
YTZlIDgxMDIzMGYwIDAwMDAwMDAwIDAwMDAwMDAwIDg3MmVmODgwIDg3MzBjMDAwIDg3MzBm
ZmE0IDgxMDNhMDlhClsgICAgOC41MDUzNThdIENhbGwgVHJhY2U6ClsgICAgOC41MDUzNThd
ICBbPDgxMDM5OWE2Pl0gZG9fZXhpdCsweDJiNi8weDkyMApbICAgIDguNTA1MzU4XSAgWzw4
MTA1YjU5Yj5dID8gdXBfd3JpdGUrMHgxYi8weDMwClsgICAgOC41MDUzNThdICBbPDgxNWY5
YTZlPl0gPyByZXN0b3JlX2FsbCsweGYvMHhmClsgICAgOC41MDUzNThdICBbPDgxMDIzMGYw
Pl0gPyBrdm1fcmVhZF9hbmRfcmVzZXRfcGZfcmVhc29uKzB4NDAvMHg0MApbICAgIDguNTA1
MzU4XSAgWzw4MTAzYTA5YT5dIGRvX2dyb3VwX2V4aXQrMHg0YS8weGEwClsgICAgOC41MDUz
NThdICBbPDgxMDNhMTA4Pl0gU3lTX2V4aXRfZ3JvdXArMHgxOC8weDIwClsgICAgOC41MDUz
NThdICBbPDgxNWZhMGIwPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAgICA4LjUw
NTM1OF0gQ29kZTogMzYgMzEgYzkgODkgZDAgMGYgYjEgMGUgMzkgYzIgNzUgZWIgODUgZDIg
NzQgNWMgOGQgYjQgMjYgMDAgMDAgMDAgMDAgZjMgOTAgOGIgODcgYzAgMDMgMDAgMDAgODUg
YzAgNzQgZjQgMzEgZGIgZWIgMDQgODkgZDMgODkgYzIgPDhiPiAwMiA4OSAxYSA4NSBjMCA3
NSBmNCBlYiAxNiA2NiA5MCBmNiA0NyAwYyAwNCA3NCBjNCBiOSBmMCBlZgpbICAgIDguNTA1
MzU4XSBFSVA6IFs8ODEwNTQ1ZTQ+XSB0YXNrX3dvcmtfcnVuKzB4NTQvMHhhMCBTUzpFU1Ag
MDA2ODo4NzMwZmYzNApbICAgIDguNTA1MzU4XSBDUjI6IDAwMDAwMDAwMDRiNDAwNjAKWyAg
ICA4LjUyNDk5Ml0gLS0tWyBlbmQgdHJhY2UgM2E1ZjZhYmY1YTE3MDlhNSBdLS0tCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVm
Zjg0NmQyYWRlZWUxYjk3MzYvZG1lc2cteW9jdG8tbGtwLXR0MDItMTk6MjAxMzEwMDUxMzUw
NTU6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNTEtZ2IwMjFm
ZTM6NDk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2IwMjFmZTNlMjUw
OTRmYmVjMjJkMGVmZjg0NmQyYWRlZWUxYjk3MzYvZG1lc2ctcXVhbnRhbC1sa3Atc3QwMS03
OjIwMTMxMDA1MjMyMTQ4OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMx
LTAwMDUxLWdiMDIxZmUzOjQ5OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
Ni9iMDIxZmUzZTI1MDk0ZmJlYzIyZDBlZmY4NDZkMmFkZWVlMWI5NzM2L2RtZXNnLXF1YW50
YWwtd2FpbWVhLTI6MjAxMzEwMDYwNzIwMzE6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
OjMuMTIuMC1yYzEtMDAwNTEtZ2IwMjFmZTM6NDk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2L2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQyYWRlZWUxYjk3MzYv
ZG1lc2cteW9jdG8tbGtwLXN0MDEtMTA6MjAxMzEwMDUyMzIxNTE6aTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2OjMuMTIuMC1yYzEtMDAwNTEtZ2IwMjFmZTM6NDk4Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2IwMjFmZTNlMjUwOTRmYmVjMjJkMGVmZjg0NmQy
YWRlZWUxYjk3MzYvZG1lc2cteW9jdG8tbGtwLXN0MDEtODoyMDEzMTAwNTIzMjE0MzppMzg2
LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMS0wMDA1MS1nYjAyMWZlMzo0OTgK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYjAyMWZlM2UyNTA5NGZiZWMy
MmQwZWZmODQ2ZDJhZGVlZTFiOTczNi9kbWVzZy15b2N0by1sa3AtdHQwMi0xOToyMDEzMTAw
NTEzNTExMjppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMS0wMDA1MS1n
YjAyMWZlMzo0OTgKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzBjNDRjMmQwZjQ1OWNkN2UyNzUyNDJiNzJmNTAw
MTM3YzRmYTgzNGRdIHg4NjogVXNlIGFzbSBnb3RvIHRvIGltcGxlbWVudCBiZXR0ZXIgbW9k
aWZ5X2FuZF90ZXN0KCkgZnVuY3Rpb25zCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
Ni9uZXh0Om1hc3RlcjowYzQ0YzJkMGY0NTljZDdlMjc1MjQyYjcyZjUwMDEzN2M0ZmE4MzRk
OmJpc2VjdC11c2IKCjIwMTMtMTAtMDUtMjM6MjE6NTYgMGM0NGMyZDBmNDU5Y2Q3ZTI3NTI0
MmI3MmY1MDAxMzdjNGZhODM0ZCBjb21waWxpbmcKMTMgcmVhbCAgMjggdXNlciAgMTEgc3lz
ICAyODYuMjAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2CgoyMDEzLTEwLTA1
LTIzOjIyOjE5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzEtMDAwNTAtZzBjNDRj
MmQuIFRFU1QgRkFJTFVSRQpbICAgIDIuODEyODA4XSBXcml0ZSBwcm90ZWN0aW5nIHRoZSBr
ZXJuZWwgcmVhZC1vbmx5IGRhdGE6IDI2MjBrClsgICAgMi44MTM1NzZdIE5YLXByb3RlY3Rp
bmcgdGhlIGtlcm5lbCBkYXRhOiA2MTY0awpbICAgIDIuODQ1MjcwXSBCVUc6IHVuYWJsZSB0
byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDAwODQwMDYwClsgICAgMi44NDYx
NjNdIElQOiBbPDgxMDU0NWU0Pl0gdGFza193b3JrX3J1bisweDU0LzB4YTAKWyAgICAyLjg0
NjgxMV0gKnBkcHQgPSAwMDAwMDAwMDA3MmUwMDAxICpwZGUgPSAwMDAwMDAwMDAwMDAwMDAw
IApbICAgIDIuODQ3NjMxXSBPb3BzOiAwMDAwIFsjMV0gREVCVUdfUEFHRUFMTE9DClsgICAg
Mi44NDgxODRdIENQVTogMCBQSUQ6IDg1IENvbW06IGhvc3RuYW1lIE5vdCB0YWludGVkIDMu
MTIuMC1yYzEtMDAwNTAtZzBjNDRjMmQgIzQ5OQpbICAgIDIuODQ5MTg2XSB0YXNrOiA4NzMw
YzAwMCB0aTogODczMGUwMDAgdGFzay50aTogODczMGUwMDAKWyAgICAyLjg0OTM2NV0gRUlQ
OiAwMDYwOls8ODEwNTQ1ZTQ+XSBFRkxBR1M6IDAwMDEwMjA2IENQVTogMApbICAgIDIuODQ5
MzY1XSBFSVAgaXMgYXQgdGFza193b3JrX3J1bisweDU0LzB4YTAKWyAgICAyLjg0OTM2NV0g
RUFYOiAwMDg0MDA2MCBFQlg6IDg3MzA1MDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDg0MDA2
MApbICAgIDIuODQ5MzY1XSBFU0k6IDg3MzBjMzg4IEVESTogODczMGMwMDAgRUJQOiA4NzMw
ZmY0MCBFU1A6IDg3MzBmZjM0ClsgICAgMi44NDkzNjVdICBEUzogMDA3YiBFUzogMDA3YiBG
UzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAgIDIuODQ5MzY1XSBDUjA6IDgwMDUwMDNi
IENSMjogMDA4NDAwNjAgQ1IzOiAwNzJkZjAwMCBDUjQ6IDAwMDAwNmIwClsgICAgMi44NDkz
NjVdIFN0YWNrOgpbICAgIDIuODQ5MzY1XSAgZmZmZmZmZmYgODczMDcwNTggODczMGMwMDAg
ODczMGZmOGMgODEwMzk5YTYgNzc2YTRmYjggODEwNWI1OWIgMDAwMDAwMDAKWyAgICAyLjg0
OTM2NV0gIDg3MzBmZmFjIDAwMDAwMDAxIDZjMGU0Y2NkIDYxNjM2ZjZjIDczNmY2ODZjIDZm
NmMyZTc0IDY0NmM2MTYzIDg3MzBjMzk4ClsgICAgMi44NDkzNjVdICA4MTVmOTk5ZSA4MTAy
MzBmMCAwMDAwMDAwMCAwMDAwMDAwMCA4NzJmMDg4MCA4NzMwYzAwMCA4NzMwZmZhNCA4MTAz
YTA5YQpbICAgIDIuODQ5MzY1XSBDYWxsIFRyYWNlOgpbICAgIDIuODQ5MzY1XSAgWzw4MTAz
OTlhNj5dIGRvX2V4aXQrMHgyYjYvMHg5MjAKWyAgICAyLjg0OTM2NV0gIFs8ODEwNWI1OWI+
XSA/IHVwX3dyaXRlKzB4MWIvMHgzMApbICAgIDIuODQ5MzY1XSAgWzw4MTVmOTk5ZT5dID8g
cmVzdG9yZV9hbGwrMHhmLzB4ZgpbICAgIDIuODQ5MzY1XSAgWzw4MTAyMzBmMD5dID8ga3Zt
X3JlYWRfYW5kX3Jlc2V0X3BmX3JlYXNvbisweDQwLzB4NDAKWyAgICAyLjg0OTM2NV0gIFs8
ODEwM2EwOWE+XSBkb19ncm91cF9leGl0KzB4NGEvMHhhMApbICAgIDIuODQ5MzY1XSAgWzw4
MTAzYTEwOD5dIFN5U19leGl0X2dyb3VwKzB4MTgvMHgyMApbICAgIDIuODQ5MzY1XSAgWzw4
MTVmOWZmMD5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAgMi44NDkzNjVdIENv
ZGU6IDM2IDMxIGM5IDg5IGQwIDBmIGIxIDBlIDM5IGMyIDc1IGViIDg1IGQyIDc0IDVjIDhk
IGI0IDI2IDAwIDAwIDAwIDAwIGYzIDkwIDhiIDg3IGMwIDAzIDAwIDAwIDg1IGMwIDc0IGY0
IDMxIGRiIGViIDA0IDg5IGQzIDg5IGMyIDw4Yj4gMDIgODkgMWEgODUgYzAgNzUgZjQgZWIg
MTYgNjYgOTAgZjYgNDcgMGMgMDQgNzQgYzQgYjkgZjAgZWYKWyAgICAyLjg0OTM2NV0gRUlQ
OiBbPDgxMDU0NWU0Pl0gdGFza193b3JrX3J1bisweDU0LzB4YTAgU1M6RVNQIDAwNjg6ODcz
MGZmMzQKWyAgICAyLjg0OTM2NV0gQ1IyOiAwMDAwMDAwMDAwODQwMDYwClsgICAgMi44Njcx
NTNdIC0tLVsgZW5kIHRyYWNlIDdkMzI5ZTc4NTY2ZjY3NmUgXS0tLQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMS0xMDA1MjEwNi8wYzQ0YzJkMGY0NTljZDdlMjc1MjQyYjcyZjUwMDEz
N2M0ZmE4MzRkL2RtZXNnLXF1YW50YWwtd2FpbWVhLTEwOjIwMTMxMDA2MDcyMTE3OmkzODYt
cmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDUwLWcwYzQ0YzJkOjQ5OQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi8wYzQ0YzJkMGY0NTljZDdlMjc1
MjQyYjcyZjUwMDEzN2M0ZmE4MzRkL2RtZXNnLXlvY3RvLWxrcC10dDAyLTE0OjIwMTMxMDA1
MTM1MTUxOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMxLTAwMDUwLWcw
YzQ0YzJkOjQ5OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi8wYzQ0YzJk
MGY0NTljZDdlMjc1MjQyYjcyZjUwMDEzN2M0ZmE4MzRkL2RtZXNnLXlvY3RvLWxrcC10dDAy
LTIxOjIwMTMxMDA1MTM1MTU2OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAt
cmMxLTAwMDUwLWcwYzQ0YzJkOjQ5OQoKMGM0NGMyZDBmNDU5Y2Q3ZTI3NTI0MmI3MmY1MDAx
MzdjNGZhODM0ZCBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgMGM0NGMyZDBmNDU5
Y2Q3ZTI3NTI0MmI3MmY1MDAxMzdjNGZhODM0ZApBdXRob3I6IFBldGVyIFppamxzdHJhIDxw
ZXRlcnpAaW5mcmFkZWFkLm9yZz4KRGF0ZTogICBXZWQgU2VwIDExIDE1OjE5OjI0IDIwMTMg
KzAyMDAKCiAgICB4ODY6IFVzZSBhc20gZ290byB0byBpbXBsZW1lbnQgYmV0dGVyIG1vZGlm
eV9hbmRfdGVzdCgpIGZ1bmN0aW9ucwogICAgCiAgICBMaW51cyBzdWdnZXN0ZWQgdXNpbmcg
YXNtIGdvdG8gdG8gZ2V0IHJpZCBvZiB0aGUgdHlwaWNhbCBTRVRjYyArIFRFU1QKICAgIGlu
c3RydWN0aW9uIHBhaXIgLS0gd2hpY2ggYWxzbyBjbG9iYmVycyBhbiBleHRyYSByZWdpc3Rl
ciAtLSBmb3Igb3VyCiAgICB0eXBpY2FsIG1vZGlmeV9hbmRfdGVzdCgpIGZ1bmN0aW9ucy4K
ICAgIAogICAgQmVjYXVzZSBhc20gZ290byBkb2Vzbid0IGFsbG93IG91dHB1dCBmaWVsZHMg
aXQgaGFzIHRvIGluY2x1ZGUgYW4KICAgIHVuY29uZGl0aW5hbCBtZW1vcnkgY2xvYmJlciB3
aGVuIGl0IGNoYW5nZXMgYSBtZW1vcnkgdmFyaWFibGUgdG8gZm9yY2UKICAgIGEgcmVsb2Fk
LgogICAgCiAgICBMdWNraWx5IGFsbCBhdG9taWMgb3BzIGFscmVhZHkgaW1wbHkgYSBjb21w
aWxlciBiYXJyaWVyIHRvIGdvIGFsb25nCiAgICB3aXRoIHRoZWlyIG1lbW9yeSBiYXJyaWVy
IHNlbWFudGljcy4KICAgIAogICAgU3VnZ2VzdGVkLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9y
dmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+CiAgICBTaWduZWQtb2ZmLWJ5OiBQZXRlciBa
aWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CiAgICBMaW5rOiBodHRwOi8vbGttbC5r
ZXJuZWwub3JnL24vdGlwLTBtdG45c2l3YmVvMWQzM2JhcDE0MjJzZUBnaXQua2VybmVsLm9y
ZwogICAgU2lnbmVkLW9mZi1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+Cgo6
MDQwMDAwIDA0MDAwMCA1MTJjNzk2NTg2NDIxOGVmNWE0MDU2OWY4MGRkNjE3ZmM3NWI2MGY5
IDIyYzUyODZjYzFhYTFlMzM2YzhiMGQ3ZWZiYTA4ZjNmM2VmZjA2NDAgTQlhcmNoCmJpc2Vj
dCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2L25leHQ6bWFzdGVyOjQzMTQ4OTUxNjU2MjM4Nzk5Mzdm
NDZkNzY3NjczNjU0NjYyYjU3MGM6YmlzZWN0LXVzYgoKMjAxMy0xMC0wNS0yMzoyMjo1MSA0
MzE0ODk1MTY1NjIzODc5OTM3ZjQ2ZDc2NzY3MzY1NDY2MmI1NzBjIHJldXNlIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2LzQzMTQ4OTUxNjU2MjM4Nzk5MzdmNDZkNzY3
NjczNjU0NjYyYjU3MGMvdm1saW51ei0zLjEyLjAtcmMxLTAwMDQ5LWc0MzE0ODk1CgoyMDEz
LTEwLTA1LTIzOjIyOjUxIGRldGVjdGluZyBib290IHN0YXRlIAkyNAk0MQk0Mwk1Ngk2MCBT
VUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWoxLTEwMDUyMTA2L25leHQ6bWFzdGVyOmEwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBm
NjM0MTA2NmE4Y2IxY2Y6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAgMy4wNjcyMjdd
IFdyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5lbCByZWFkLW9ubHkgZGF0YTogMjY0NGsKWyAg
ICAzLjA2Nzc2NF0gTlgtcHJvdGVjdGluZyB0aGUga2VybmVsIGRhdGE6IDYxNTJrClsgICAg
My4xMDI3NzZdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3Qg
YXQgMDQ0ZTAwNjAKWyAgICAzLjEwMzQyMF0gSVA6IFs8ODEwNTNmYzQ+XSB0YXNrX3dvcmtf
cnVuKzB4NTQvMHhhMApbICAgIDMuMTAzODkyXSAqcGRwdCA9IDAwMDAwMDAwMDcyZTEwMDEg
KnBkZSA9IDAwMDAwMDAwMDAwMDAwMDAgClsgICAgMy4xMDQ0OTRdIE9vcHM6IDAwMDAgWyMx
XSBERUJVR19QQUdFQUxMT0MKWyAgICAzLjEwNDkwOF0gQ1BVOiAwIFBJRDogODUgQ29tbTog
aG9zdG5hbWUgTm90IHRhaW50ZWQgMy4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdh
MGNmMWFiICM1ClsgICAgMy4xMDUzNTddIHRhc2s6IDg3MzBjMDAwIHRpOiA4NzMwZTAwMCB0
YXNrLnRpOiA4NzMwZTAwMApbICAgIDMuMTA1MzU3XSBFSVA6IDAwNjA6Wzw4MTA1M2ZjND5d
IEVGTEFHUzogMDAwMTAyMDYgQ1BVOiAwClsgICAgMy4xMDUzNTddIEVJUCBpcyBhdCB0YXNr
X3dvcmtfcnVuKzB4NTQvMHhhMApbICAgIDMuMTA1MzU3XSBFQVg6IDA0NGUwMDYwIEVCWDog
ODczMDI3ODAgRUNYOiAwMDAwMDAwMCBFRFg6IDA0NGUwMDYwClsgICAgMy4xMDUzNTddIEVT
STogODczMGMzODggRURJOiA4NzMwYzAwMCBFQlA6IDg3MzBmZjQwIEVTUDogODczMGZmMzQK
WyAgICAzLjEwNTM1N10gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMDAwIFNT
OiAwMDY4ClsgICAgMy4xMDUzNTddIENSMDogODAwNTAwM2IgQ1IyOiAwNDRlMDA2MCBDUjM6
IDA3MmRjMDAwIENSNDogMDAwMDA2YjAKWyAgICAzLjEwNTM1N10gU3RhY2s6ClsgICAgMy4x
MDUzNTddICBmZmZmZmZmZiA4NzMwOTA1OCA4NzMwYzAwMCA4NzMwZmY4YyA4MTAzOTMxNSA3
NzYwNWZiOCA4MTA1YWY3YiAwMDAwMDAwMApbICAgIDMuMTA1MzU3XSAgODczMGZmYWMgMDAw
MDAwMDEgNmMwZTQxYTUgNjE2MzZmNmMgNzM2ZjY4NmMgNmY2YzJlNzQgNjQ2YzYxNjMgODcz
MGMzOTgKWyAgICAzLjEwNTM1N10gIDgxNWZjOGZlIDgxMDIyZjQwIDAwMDAwMDAwIDAwMDAw
MDAwIDg3MmYxODgwIDg3MzBjMDAwIDg3MzBmZmE0IDgxMDM5YTBhClsgICAgMy4xMDUzNTdd
IENhbGwgVHJhY2U6ClsgICAgMy4xMDUzNTddICBbPDgxMDM5MzE1Pl0gZG9fZXhpdCsweDJh
NS8weDkxMApbICAgIDMuMTA1MzU3XSAgWzw4MTA1YWY3Yj5dID8gdXBfd3JpdGUrMHgxYi8w
eDMwClsgICAgMy4xMDUzNTddICBbPDgxNWZjOGZlPl0gPyByZXN0b3JlX2FsbCsweGYvMHhm
ClsgICAgMy4xMDUzNTddICBbPDgxMDIyZjQwPl0gPyBrdm1fcmVhZF9hbmRfcmVzZXRfcGZf
cmVhc29uKzB4NDAvMHg0MApbICAgIDMuMTA1MzU3XSAgWzw4MTAzOWEwYT5dIGRvX2dyb3Vw
X2V4aXQrMHg0YS8weGEwClsgICAgMy4xMDUzNTddICBbPDgxMDM5YTc4Pl0gU3lTX2V4aXRf
Z3JvdXArMHgxOC8weDIwClsgICAgMy4xMDUzNTddICBbPDgxNWZjZjUwPl0gc3lzZW50ZXJf
ZG9fY2FsbCsweDEyLzB4M2MKWyAgICAzLjEwNTM1N10gQ29kZTogMzYgMzEgYzkgODkgZDAg
MGYgYjEgMGUgMzkgYzIgNzUgZWIgODUgZDIgNzQgNWMgOGQgYjQgMjYgMDAgMDAgMDAgMDAg
ZjMgOTAgOGIgODcgYzAgMDMgMDAgMDAgODUgYzAgNzQgZjQgMzEgZGIgZWIgMDQgODkgZDMg
ODkgYzIgPDhiPiAwMiA4OSAxYSA4NSBjMCA3NSBmNCBlYiAxNiA2NiA5MCBmNiA0NyAwYyAw
NCA3NCBjNCBiOSBmMCBhZgpbICAgIDMuMTA1MzU3XSBFSVA6IFs8ODEwNTNmYzQ+XSB0YXNr
X3dvcmtfcnVuKzB4NTQvMHhhMCBTUzpFU1AgMDA2ODo4NzMwZmYzNApbICAgIDMuMTA1MzU3
XSBDUjI6IDAwMDAwMDAwMDQ0ZTAwNjAKWyAgICAzLjExODUyNF0gLS0tWyBlbmQgdHJhY2Ug
NzFiMGVmMmViNzAzYzFhYiBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUy
MTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVh
bnRhbC1hdGhlbnMtMzQ6MjAxMzEwMDUyMTU0MDQ6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUy
MTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBm
NjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1hdGhlbnMtNjoyMDEzMTAwNTIxMTk0Mzpp
Mzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAz
MTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBj
ZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWNh
aXJvLTE6MjAxMzEwMDUyMTU0MzE6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIu
MC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4
Y2IxY2YvZG1lc2ctcXVhbnRhbC1jYWlyby00MToyMDEzMTAwNTIxNTQwNjppMzg2LXJhbmRj
b25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNm
MWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFj
MTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWNhaXJvLTQ2OjIw
MTMxMDA1MjE1NDEwOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5l
eHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2Rt
ZXNnLXF1YW50YWwtaW5uLTE1OjIwMTMxMDA1MjE1NDE1OmkzODYtcmFuZGNvbmZpZy1qMS0x
MDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1
N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtaW5uLTI5OjIwMTMxMDA1MjE1NDEy
OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5Mjct
MDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9h
MGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwt
aW5uLTM6MjAxMzEwMDUyMTU0MTE6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIu
MC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4
Y2IxY2YvZG1lc2ctcXVhbnRhbC1pbm4tODoyMDEzMTAwNTIxMTkzNzppMzg2LXJhbmRjb25m
aWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFi
OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3
ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWlubi05OjIwMTMxMDA1
MjE1NDMxOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAx
MzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1
YW50YWwtbGtwLXN0MDEtMTI6MjAxMzEwMDUyMTE5NDg6aTM4Ni1yYW5kY29uZmlnLWoxLTEw
MDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3
YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi04OjIwMTMxMDA1MTE0
OTA4OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
Ni9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50
YWwtcm9hbS0xOjIwMTMxMDA1MjE1NDM0OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjoz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEw
NjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtcm9hbS02OjIwMTMxMDA1MjE1NDMxOmkzODYtcmFu
ZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2Ew
Y2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1
YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtcm9hbS04OjIw
MTMxMDA1MjE1NDMxOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5l
eHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2Rt
ZXNnLXF1YW50YWwtc25iLTExOjIwMTMxMDA1MjE1NDM0OmkzODYtcmFuZGNvbmZpZy1qMS0x
MDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1
N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtc25iLTEyOjIwMTMxMDA1MjE1NDIw
OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5Mjct
MDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9h
MGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwt
eGlhbi0xMjoyMDEzMTAwNTIxNTQyOTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4x
Mi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2
YThjYjFjZi9kbWVzZy1xdWFudGFsLXhpYW4tMjc6MjAxMzEwMDUyMTU0MzE6aTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBj
ZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVh
YzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC14aWFuLTM3OjIw
MTMxMDA1MjExOTQ0OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5l
eHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2Rt
ZXNnLXF1YW50YWwteGlhbi00MzoyMDEzMTAwNTIxNTQzMDppMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4
NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLXhpYW4tNDY6MjAxMzEwMDUyMTU0
MTY6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDky
Ny0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRh
bC14aWFuLTQ6MjAxMzEwMDUyMTU0MTQ6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMu
MTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2
NmE4Y2IxY2YvZG1lc2cteW9jdG8tYXRoZW5zLTMxOjIwMTMxMDA1MjE1NDA4OmkzODYtcmFu
ZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2Ew
Y2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1
YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWF0aGVucy00Mzoy
MDEzMTAwNTIxNTQxNDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1u
ZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9k
bWVzZy15b2N0by1hdGhlbnMtNzoyMDEzMTAwNTIxNTQzNTppMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4
NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1jYWlyby0xNjoyMDEzMTAwNTIxNTQz
NDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3
LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYv
YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1j
YWlyby0xOToyMDEzMTAwNTIxNTQzNDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4x
Mi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2
YThjYjFjZi9kbWVzZy15b2N0by1jYWlyby0xOjIwMTMxMDA1MjE1NDMyOmkzODYtcmFuZGNv
bmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2Yx
YWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMx
OTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWlubi0yODoyMDEzMTAw
NTIxMTkzMzppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIw
MTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAw
NTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15
b2N0by1sa3AtdHQwMi0xODoyMDEzMTAwNTEyMjMzNDppMzg2LXJhbmRjb25maWctajEtMTAw
NTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdj
MGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1sa3AtdHQwMi0yMjoyMDEzMTAwNTEyMjMz
NjppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3
LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYv
YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1y
b2FtLTc6MjAxMzEwMDUyMTU0MTQ6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIu
MC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4
Y2IxY2YvZG1lc2cteW9jdG8tcm9hbS04OjIwMTMxMDA1MjE1NDMzOmkzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdk
ZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXNuYi0xNjoyMDEzMTAwNTIx
NTQxMTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIx
MDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0
by1zbmItMTg6MjAxMzEwMDUyMTU0MDg6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMu
MTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2
NmE4Y2IxY2YvZG1lc2cteW9jdG8tc25iLTE4OjIwMTMxMDA1MjE1NDMyOmkzODYtcmFuZGNv
bmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2Yx
YWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMx
OTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXNuYi0xOjIwMTMxMDA1
MjE1NDI5OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAx
MzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlv
Y3RvLXNuYi0yMToyMDEzMTAwNTIxNTQyOTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6
My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQx
MDY2YThjYjFjZi9kbWVzZy15b2N0by1zbmItMjY6MjAxMzEwMDUyMTE5MzU6aTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBj
ZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVh
YzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tc25iLTQ3OjIwMTMx
MDA1MjExOTM5OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQt
MjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0x
MDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNn
LXlvY3RvLXN0b2FrbGV5LTQ6MjAxMzEwMDUyMTU0MTc6aTM4Ni1yYW5kY29uZmlnLWoxLTEw
MDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3
YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8td2FpbWVhLTM6MjAxMzEwMDYwNTE4MjM6
aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0w
MzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2Ew
Y2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8teGlh
bi0xMDoyMDEzMTAwNTIxNTQzMjppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4w
LXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThj
YjFjZi9kbWVzZy15b2N0by14aWFuLTI4OjIwMTMxMDA1MjE1NDI5OmkzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdk
ZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXhpYW4tNDM6MjAxMzEwMDUy
MTU0MTI6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEz
MDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUy
MTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9j
dG8teGlhbi00NDoyMDEzMTAwNTIxNTQxMTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6
My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQx
MDY2YThjYjFjZi9kbWVzZy15b2N0by14aWFuLTQ0OjIwMTMxMDA1MjE1NDMzOmkzODYtcmFu
ZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2Ew
Y2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1
YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXhpYW4tODoyMDEz
MTAwNTIxNTQwODppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0
LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKCltkZXRhY2hlZCBIRUFEIGZjMTY4ZmVdIFJl
dmVydCAieDg2OiBVc2UgYXNtIGdvdG8gdG8gaW1wbGVtZW50IGJldHRlciBtb2RpZnlfYW5k
X3Rlc3QoKSBmdW5jdGlvbnMiCiA1IGZpbGVzIGNoYW5nZWQsIDkyIGluc2VydGlvbnMoKyks
IDU4IGRlbGV0aW9ucygtKQogZGVsZXRlIG1vZGUgMTAwNjQ0IGFyY2gveDg2L2luY2x1ZGUv
YXNtL3Jtd2NjLmgKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1qMS0xMDA1MjEwNi9uZXh0Om1hc3RlcjpmYzE2OGZlNzJlOWY1NjU2ZThlYWQ0
MWUzYmM2MjFmNThkN2QwMTIwOmJpc2VjdC11c2IKCjIwMTMtMTAtMDUtMjM6MjU6MjcgZmMx
NjhmZTcyZTlmNTY1NmU4ZWFkNDFlM2JjNjIxZjU4ZDdkMDEyMCBjb21waWxpbmcKG1sxOzM1
bWkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjogbWFrZSBwcmVwYXJlIGZhaWxlZBtbMG0K
MjAxMy0xMC0wNS0yMzoyNTozNiBmYzE2OGZlNzJlOWY1NjU2ZThlYWQ0MWUzYmM2MjFmNThk
N2QwMTIwIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvdXNiLWJp
c2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2ZjMTY4
ZmU3MmU5ZjU2NTZlOGVhZDQxZTNiYzYyMWY1OGQ3ZDAxMjAKCj09PT09PT09PSB1cHN0cmVh
bSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9uZXh0Om1hc3Rlcjo3ZGVlOGRm
ZjQ3NzM0ZWU1MmRhMmNkOGI4ZWE5NzM2ZTQyYzUwNjJmOmJpc2VjdC11c2IKCjIwMTMtMTAt
MDUtMjM6MjU6MzggN2RlZThkZmY0NzczNGVlNTJkYTJjZDhiOGVhOTczNmU0MmM1MDYyZiBj
b21waWxpbmcKCjIwMTMtMTAtMDUtMjM6Mjg6MDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
Mi4wLXJjMy0wMDMxMy1nN2RlZThkZgkxLgk2CTE5CTQwLgk1OC4JNjAgU1VDQ0VTUwoKCj09
PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvbmV4
dDptYXN0ZXI6YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZjpiaXNl
Y3QtdXNiCiBURVNUIEZBSUxVUkUKWyAgICAzLjA2NzIyN10gV3JpdGUgcHJvdGVjdGluZyB0
aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAyNjQ0awpbICAgIDMuMDY3NzY0XSBOWC1wcm90
ZWN0aW5nIHRoZSBrZXJuZWwgZGF0YTogNjE1MmsKWyAgICAzLjEwMjc3Nl0gQlVHOiB1bmFi
bGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCAwNDRlMDA2MApbICAgIDMu
MTAzNDIwXSBJUDogWzw4MTA1M2ZjND5dIHRhc2tfd29ya19ydW4rMHg1NC8weGEwClsgICAg
My4xMDM4OTJdICpwZHB0ID0gMDAwMDAwMDAwNzJlMTAwMSAqcGRlID0gMDAwMDAwMDAwMDAw
MDAwMCAKWyAgICAzLjEwNDQ5NF0gT29wczogMDAwMCBbIzFdIERFQlVHX1BBR0VBTExPQwpb
ICAgIDMuMTA0OTA4XSBDUFU6IDAgUElEOiA4NSBDb21tOiBob3N0bmFtZSBOb3QgdGFpbnRl
ZCAzLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWIgIzUKWyAgICAzLjEw
NTM1N10gdGFzazogODczMGMwMDAgdGk6IDg3MzBlMDAwIHRhc2sudGk6IDg3MzBlMDAwClsg
ICAgMy4xMDUzNTddIEVJUDogMDA2MDpbPDgxMDUzZmM0Pl0gRUZMQUdTOiAwMDAxMDIwNiBD
UFU6IDAKWyAgICAzLjEwNTM1N10gRUlQIGlzIGF0IHRhc2tfd29ya19ydW4rMHg1NC8weGEw
ClsgICAgMy4xMDUzNTddIEVBWDogMDQ0ZTAwNjAgRUJYOiA4NzMwMjc4MCBFQ1g6IDAwMDAw
MDAwIEVEWDogMDQ0ZTAwNjAKWyAgICAzLjEwNTM1N10gRVNJOiA4NzMwYzM4OCBFREk6IDg3
MzBjMDAwIEVCUDogODczMGZmNDAgRVNQOiA4NzMwZmYzNApbICAgIDMuMTA1MzU3XSAgRFM6
IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwMDAgU1M6IDAwNjgKWyAgICAzLjEwNTM1
N10gQ1IwOiA4MDA1MDAzYiBDUjI6IDA0NGUwMDYwIENSMzogMDcyZGMwMDAgQ1I0OiAwMDAw
MDZiMApbICAgIDMuMTA1MzU3XSBTdGFjazoKWyAgICAzLjEwNTM1N10gIGZmZmZmZmZmIDg3
MzA5MDU4IDg3MzBjMDAwIDg3MzBmZjhjIDgxMDM5MzE1IDc3NjA1ZmI4IDgxMDVhZjdiIDAw
MDAwMDAwClsgICAgMy4xMDUzNTddICA4NzMwZmZhYyAwMDAwMDAwMSA2YzBlNDFhNSA2MTYz
NmY2YyA3MzZmNjg2YyA2ZjZjMmU3NCA2NDZjNjE2MyA4NzMwYzM5OApbICAgIDMuMTA1MzU3
XSAgODE1ZmM4ZmUgODEwMjJmNDAgMDAwMDAwMDAgMDAwMDAwMDAgODcyZjE4ODAgODczMGMw
MDAgODczMGZmYTQgODEwMzlhMGEKWyAgICAzLjEwNTM1N10gQ2FsbCBUcmFjZToKWyAgICAz
LjEwNTM1N10gIFs8ODEwMzkzMTU+XSBkb19leGl0KzB4MmE1LzB4OTEwClsgICAgMy4xMDUz
NTddICBbPDgxMDVhZjdiPl0gPyB1cF93cml0ZSsweDFiLzB4MzAKWyAgICAzLjEwNTM1N10g
IFs8ODE1ZmM4ZmU+XSA/IHJlc3RvcmVfYWxsKzB4Zi8weGYKWyAgICAzLjEwNTM1N10gIFs8
ODEwMjJmNDA+XSA/IGt2bV9yZWFkX2FuZF9yZXNldF9wZl9yZWFzb24rMHg0MC8weDQwClsg
ICAgMy4xMDUzNTddICBbPDgxMDM5YTBhPl0gZG9fZ3JvdXBfZXhpdCsweDRhLzB4YTAKWyAg
ICAzLjEwNTM1N10gIFs8ODEwMzlhNzg+XSBTeVNfZXhpdF9ncm91cCsweDE4LzB4MjAKWyAg
ICAzLjEwNTM1N10gIFs8ODE1ZmNmNTA+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzYwpb
ICAgIDMuMTA1MzU3XSBDb2RlOiAzNiAzMSBjOSA4OSBkMCAwZiBiMSAwZSAzOSBjMiA3NSBl
YiA4NSBkMiA3NCA1YyA4ZCBiNCAyNiAwMCAwMCAwMCAwMCBmMyA5MCA4YiA4NyBjMCAwMyAw
MCAwMCA4NSBjMCA3NCBmNCAzMSBkYiBlYiAwNCA4OSBkMyA4OSBjMiA8OGI+IDAyIDg5IDFh
IDg1IGMwIDc1IGY0IGViIDE2IDY2IDkwIGY2IDQ3IDBjIDA0IDc0IGM0IGI5IGYwIGFmClsg
ICAgMy4xMDUzNTddIEVJUDogWzw4MTA1M2ZjND5dIHRhc2tfd29ya19ydW4rMHg1NC8weGEw
IFNTOkVTUCAwMDY4Ojg3MzBmZjM0ClsgICAgMy4xMDUzNTddIENSMjogMDAwMDAwMDAwNDRl
MDA2MApbICAgIDMuMTE4NTI0XSAtLS1bIGVuZCB0cmFjZSA3MWIwZWYyZWI3MDNjMWFiIF0t
LS0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3
ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLWF0aGVucy0zNDoyMDEz
MTAwNTIxNTQwNDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0
LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVz
Zy1xdWFudGFsLWF0aGVucy02OjIwMTMxMDA1MjExOTQzOmkzODYtcmFuZGNvbmZpZy1qMS0x
MDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1
N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtY2Fpcm8tMToyMDEzMTAwNTIxNTQz
MTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3
LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYv
YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFs
LWNhaXJvLTQxOjIwMTMxMDA1MjE1NDA2OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjoz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEw
NjZhOGNiMWNmL2RtZXNnLXF1YW50YWwtY2Fpcm8tNDY6MjAxMzEwMDUyMTU0MTA6aTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1n
YTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJj
MjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1pbm4tMTU6
MjAxMzEwMDUyMTU0MTU6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzIt
bmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2Yv
ZG1lc2ctcXVhbnRhbC1pbm4tMjk6MjAxMzEwMDUyMTU0MTI6aTM4Ni1yYW5kY29uZmlnLWox
LTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdi
ODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1pbm4tMzoyMDEzMTAwNTIxNTQx
MTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3
LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYv
YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFs
LWlubi04OjIwMTMxMDA1MjExOTM3OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEy
LjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZh
OGNiMWNmL2RtZXNnLXF1YW50YWwtaW5uLTk6MjAxMzEwMDUyMTU0MzE6aTM4Ni1yYW5kY29u
ZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFh
Yjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5
N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1sa3Atc3QwMS0xMjoy
MDEzMTAwNTIxMTk0ODppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1u
ZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9k
bWVzZy1xdWFudGFsLWxrcC10dDAyLTg6MjAxMzEwMDUxMTQ5MDg6aTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2Rk
OTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1yb2FtLTE6MjAxMzEwMDUy
MTU0MzQ6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEz
MDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUy
MTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVh
bnRhbC1yb2FtLTY6MjAxMzEwMDUyMTU0MzE6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0
MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1yb2FtLTg6MjAxMzEwMDUyMTU0MzE6aTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1n
YTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJj
MjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC1zbmItMTE6
MjAxMzEwMDUyMTU0MzQ6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzIt
bmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2Yv
ZG1lc2ctcXVhbnRhbC1zbmItMTI6MjAxMzEwMDUyMTU0MjA6aTM4Ni1yYW5kY29uZmlnLWox
LTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdi
ODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC14aWFuLTEyOjIwMTMxMDA1MjE1
NDI5OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
Ni9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXF1YW50
YWwteGlhbi0yNzoyMDEzMTAwNTIxNTQzMTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6
My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQx
MDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLXhpYW4tMzc6MjAxMzEwMDUyMTE5NDQ6aTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1n
YTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJj
MjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2ctcXVhbnRhbC14aWFuLTQz
OjIwMTMxMDA1MjE1NDMwOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMy
LW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNm
L2RtZXNnLXF1YW50YWwteGlhbi00NjoyMDEzMTAwNTIxNTQxNjppMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5
N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy1xdWFudGFsLXhpYW4tNDoyMDEzMTAwNTIx
NTQxNDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIx
MDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0
by1hdGhlbnMtMzE6MjAxMzEwMDUyMTU0MDg6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0
MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tYXRoZW5zLTQzOjIwMTMxMDA1MjE1NDE0OmkzODYt
cmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAt
Z2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFi
YzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWF0aGVucy03
OjIwMTMxMDA1MjE1NDM1OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMy
LW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNm
L2RtZXNnLXlvY3RvLWNhaXJvLTE2OjIwMTMxMDA1MjE1NDM0OmkzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3
Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWNhaXJvLTE5OjIwMTMxMDA1MjE1
NDM0OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEw
Ni9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3Rv
LWNhaXJvLTE6MjAxMzEwMDUyMTU0MzI6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMu
MTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2
NmE4Y2IxY2YvZG1lc2cteW9jdG8taW5uLTI4OjIwMTMxMDA1MjExOTMzOmkzODYtcmFuZGNv
bmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2Yx
YWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMx
OTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTE4OjIw
MTMxMDA1MTIyMzM0OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5l
eHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2Rt
ZXNnLXlvY3RvLWxrcC10dDAyLTIyOjIwMTMxMDA1MTIyMzM2OmkzODYtcmFuZGNvbmZpZy1q
MS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6NQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3
Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXJvYW0tNzoyMDEzMTAwNTIxNTQx
NDppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3
LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYv
YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1y
b2FtLTg6MjAxMzEwMDUyMTU0MzM6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIu
MC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4
Y2IxY2YvZG1lc2cteW9jdG8tc25iLTE2OjIwMTMxMDA1MjE1NDExOmkzODYtcmFuZGNvbmZp
Zy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9hMGNmMWFiYzI1YWMxOTdk
ZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXNuYi0xODoyMDEzMTAwNTIx
NTQwODppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIx
MDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0
by1zbmItMTg6MjAxMzEwMDUyMTU0MzI6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMu
MTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2
NmE4Y2IxY2YvZG1lc2cteW9jdG8tc25iLTE6MjAxMzEwMDUyMTU0Mjk6aTM4Ni1yYW5kY29u
ZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFh
Yjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5
N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tc25iLTIxOjIwMTMxMDA1
MjE1NDI5OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAx
MzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlv
Y3RvLXNuYi0yNjoyMDEzMTAwNTIxMTkzNTppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6
My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQx
MDY2YThjYjFjZi9kbWVzZy15b2N0by1zbmItNDc6MjAxMzEwMDUyMTE5Mzk6aTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBj
ZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVh
YzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8tc3RvYWtsZXktNDoy
MDEzMTAwNTIxNTQxNzppMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1u
ZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9k
bWVzZy15b2N0by13YWltZWEtMzoyMDEzMTAwNjA1MTgyMzppMzg2LXJhbmRjb25maWctajEt
MTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjUKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4
NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by14aWFuLTEwOjIwMTMxMDA1MjE1NDMy
OmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5Mjct
MDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNi9h
MGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLXhp
YW4tMjg6MjAxMzEwMDUyMTU0Mjk6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2OjMuMTIu
MC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4
Y2IxY2YvZG1lc2cteW9jdG8teGlhbi00MzoyMDEzMTAwNTIxNTQxMjppMzg2LXJhbmRjb25m
aWctajEtMTAwNTIxMDY6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFi
OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajEtMTAwNTIxMDYvYTBjZjFhYmMyNWFjMTk3
ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by14aWFuLTQ0OjIwMTMxMDA1
MjE1NDExOmkzODYtcmFuZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAx
MzA5MjctMDMxMDAtZ2EwY2YxYWI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qMS0xMDA1
MjEwNi9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlv
Y3RvLXhpYW4tNDQ6MjAxMzEwMDUyMTU0MzM6aTM4Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2
OjMuMTIuMC1yYzItbmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjo1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWoxLTEwMDUyMTA2L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0
MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8teGlhbi04OjIwMTMxMDA1MjE1NDA4OmkzODYtcmFu
ZGNvbmZpZy1qMS0xMDA1MjEwNjozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2Ew
Y2YxYWI6NQoK

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc2-next-20130927-03100-ga0cf1ab"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0-rc2 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
CONFIG_X86_WANT_INTEL_MID=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
CONFIG_MWINCHIP3D=y
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_INPORT is not set
CONFIG_MOUSE_LOGIBM=y
CONFIG_MOUSE_PC110PAD=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_ARIZONA_HAPTICS=y
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
CONFIG_INPUT_POWERMATE=y
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_DA9055_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_ADXL34X_SPI=y
CONFIG_INPUT_IMS_PCU=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_GOLDFISH_TTY=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
# CONFIG_I2C_PCA_ISA is not set
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9052=y
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_WM8350_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_RDC321X_WDT=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_MEN_A21_WDT is not set

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_MFD_CROS_EC_SPI=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ARIZONA=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCAP=y
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_ISA is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
CONFIG_SND_USB_UA101=y
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
# CONFIG_SND_USB_CAIAQ_INPUT is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_USB_6FIRE=y
# CONFIG_SND_USB_HIFACE is not set
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SIMPLE_CARD=y
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_PRODIKEYS=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_HCD_BCMA=y
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_HCD_TEST_MODE=y
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y
# CONFIG_USB_DWC3_GADGET is not set
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
CONFIG_USB_DWC3_EXYNOS=y
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_SIMPLE=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
# CONFIG_USB_SERIAL_EDGEPORT is not set
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_F81232=y
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=y
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_R8A66597=y
CONFIG_USB_RENESAS_USBHS_UDC=y
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_ACM=y
CONFIG_USB_U_SERIAL=y
CONFIG_USB_CONFIGFS=y
# CONFIG_USB_CONFIGFS_SERIAL is not set
CONFIG_USB_CONFIGFS_ACM=y
# CONFIG_USB_CONFIGFS_OBEX is not set
# CONFIG_USB_CONFIGFS_NCM is not set
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_GOLDFISH=y
CONFIG_MMC_SPI=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ACPI=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_GOLDFISH_PIPE=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_ARIZONA=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
# CONFIG_KXSD9 is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
# CONFIG_AD7476 is not set
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7887=y
CONFIG_AD7923=y
# CONFIG_MAX1363 is not set
CONFIG_MCP320X=y
# CONFIG_MCP3422 is not set
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
CONFIG_AD5446=y
CONFIG_AD5449=y
CONFIG_AD5504=y
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
CONFIG_AD5755=y
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
# CONFIG_ADIS16130 is not set
CONFIG_ADIS16136=y
CONFIG_ADIS16260=y
# CONFIG_ADXRS450 is not set
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
CONFIG_GP2AP020A00F=y
CONFIG_HID_SENSOR_ALS=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_TSL4531 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_FTRACE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_PUBLIC_KEY_ALGO_RSA is not set
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
CONFIG_CRC64_ECMA=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--LZvS9be/3tNcYl/X--
