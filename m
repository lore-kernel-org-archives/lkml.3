Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3KGMLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:11:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:57839 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab3KGMLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:11:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,651,1378882800"; 
   d="log'?scan'208";a="423715853"
Date: Thu, 7 Nov 2013 20:10:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [vfs] BUG: spinlock trylock failure on UP on CPU#0, swapper/0
Message-ID: <20131107121042.GB10868@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit seems to be

commit 1247c74b4f3f3725a8bd8dc0bbd22baa2a9049ae
Author: David Howells <dhowells@redhat.com>
Date:   Thu Sep 12 19:22:53 2013 +0100

    VFS: Put a small type field into struct dentry::d_flags
    
    Put a type field into struct dentry::d_flags to indicate if the dentry is one
    of the following types that relate particularly to pathwalk:
    
    	Miss (negative dentry)
    	Directory
    	"Automount" directory (defective - no i_op->lookup())
    	Symlink
    	Other (regular, socket, fifo, device)
    
    The type field is set to one of the first five types on a dentry by calls to
    __d_instantiate() and d_obtain_alias() from information in the inode (if one is
    given).
    
    The type is cleared by dentry_unlink_inode() when it reconstitutes an existing
    dentry as a negative dentry.
    
    Accessors provided are:
    
    	d_set_type(dentry, type)
    	d_is_directory(dentry)
    	d_is_autodir(dentry)
    	d_is_symlink(dentry)
    	d_is_file(dentry)
    	d_is_negative(dentry)
    	d_is_positive(dentry)
    
    A bunch of checks in pathname resolution switched to those.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+-------------------------------------------------+--------------+--------------+
|                                                 | 50235cd9727c | 44a40fd21fcf |
+-------------------------------------------------+--------------+--------------+
| has_kernel_error_warning                        | 110          | 19           |
| BUG:kernel_early_hang_without_any_printk_output | 4            | 1            |
| WARNING:CPU:PID:at_fs/dcache.c:d_lru_del()      | 106          |              |
| BUG:spinlock_trylock_failure_on_UP_on_CPU       | 0            | 18           |
+-------------------------------------------------+--------------+--------------+

[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.62 BogoMIPS (lpj=8978600)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006717] Mount-cache hash table entries: 256
[    0.007513] BUG: spinlock trylock failure on UP on CPU#0, swapper/0
[    0.008374]  lock: 0xffff88000d801c78, .magic: dead4ead, .owner: swapper/0, .owner_cpu: 0
[    0.009584] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-00775-g44a40fd #9
[    0.010008]  ffffffff81095ffb ffffffff82401d28 ffffffff81bf07d0 ffffffff82401d48
[    0.011188]  ffffffff81bf0fff 0000000000000000 ffff88000d801c78 ffffffff82401d68
[    0.012431]  ffffffff81bf102a ffff88000d801c78 ffffffff82230ff4 ffffffff82401d80
[    0.014144] Call Trace:
[    0.014544]  [<ffffffff81095ffb>] ? up+0xf/0x39
[    0.015260]  [<ffffffff81bf07d0>] dump_stack+0x19/0x1b
[    0.016063]  [<ffffffff81bf0fff>] spin_dump+0x85/0x8a
[    0.016677]  [<ffffffff81bf102a>] spin_bug+0x26/0x28
[    0.017452]  [<ffffffff813a05c5>] do_raw_spin_trylock+0x37/0x3c
[    0.018379]  [<ffffffff81c00c68>] _raw_spin_lock+0x45/0x70
[    0.019200]  [<ffffffff81112651>] ? d_flags_for_inode+0x48/0xa9
[    0.020010]  [<ffffffff81112651>] d_flags_for_inode+0x48/0xa9
[    0.020865]  [<ffffffff811126cf>] __d_instantiate+0x1d/0xdf
[    0.021709]  [<ffffffff811143d1>] d_instantiate+0x35/0x4b
[    0.022469]  [<ffffffff811144f8>] d_make_root+0x32/0x49
[    0.023344]  [<ffffffff81152469>] sysfs_mount+0x162/0x1db
[    0.024154]  [<ffffffff81104a66>] mount_fs+0x10/0xac
[    0.024921]  [<ffffffff8111adb8>] vfs_kern_mount+0x5f/0xf3
[    0.025743]  [<ffffffff8111d12c>] kern_mount_data+0x14/0x29
[    0.026677]  [<ffffffff827a0abd>] sysfs_init+0x54/0xb3
[    0.027380]  [<ffffffff8279f3e2>] mnt_init+0xcb/0x1c7
[    0.028091]  [<ffffffff8279f0a7>] vfs_caches_init+0x90/0x107
[    0.028895]  [<ffffffff810e3d11>] ? kmem_cache_create+0x23/0x25
[    0.030011]  [<ffffffff82782d55>] start_kernel+0x431/0x482
[    0.030776]  [<ffffffff82782732>] ? repair_env_string+0x58/0x58
[    0.031632]  [<ffffffff82782120>] ? early_idt_handlers+0x120/0x120
[    0.032560]  [<ffffffff8278244c>] x86_64_start_reservations+0x2a/0x2c
[    0.033345]  [<ffffffff8278252a>] x86_64_start_kernel+0xdc/0xe9

git bisect start 44a40fd21fcf04ed24396657e381da1b7412590f 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 --
git bisect good 6a05cedf89640bae8e10aa6ee726a4986c484750  # 09:04     20+      1  Merge 'oleg/uprobes/core' into devel-xian-x86_64-201311070514
git bisect good 4796e8af60ee7d2922386ef9fd4389d21e2c1665  # 09:55     20+      1  Bluetooth: Make mgmt_write_scan_failed() return void
git bisect good cca34b785a21d220176038c45071ffe842e99fd3  # 10:34     20+      1  Bluetooth: Remove link type check in hci_disconn_complete_evt()
git bisect good 004e8957280a32f7b54766531c064412bda45e48  # 10:59     20+     20  convert the rest of binfmt_elf_fdpic to dump_emit()
git bisect  bad b0d94facd7c81fae48e72f1e0b2a7e656ecde921  # 11:04      0-      1  exportfs: stop retrying once we race with rename/remove
git bisect good 50235cd9727c20b09967b5c060025eac9d0c80bb  # 11:28     20+     20  elf{,_fdpic} coredump: get rid of pointless if (siginfo->si_signo)
git bisect  bad 08196969532eee10cdeaa29fca37fa7a407b01ae  # 11:33      0-      1  dcache: use IS_ROOT to decide where dentry is hashed
git bisect  bad 7717bf21e4a5e1d371e313a4404635f4775961d9  # 11:38      1-      2  vfs: split out vfs_getattr_nosec
git bisect  bad 520ef078eabdbe7eb6a33c1f56a65ac55d41e6ed  # 11:46      0-      1  iget/iget5: don't bother with ->i_lock until we find a match
git bisect  bad 1247c74b4f3f3725a8bd8dc0bbd22baa2a9049ae  # 11:49      0-      1  VFS: Put a small type field into struct dentry::d_flags
git bisect good 50235cd9727c20b09967b5c060025eac9d0c80bb  # 12:21     90+    110  elf{,_fdpic} coredump: get rid of pointless if (siginfo->si_signo)
git bisect  bad 44a40fd21fcf04ed24396657e381da1b7412590f  # 12:21      0-     19  Merge 'vfs/for-next' into devel-xian-x86_64-201311070514
git bisect good 840dc9962cdca607c3b121fe8784866ecf169b64  # 12:59     90+     90  Revert "VFS: Put a small type field into struct dentry::d_flags"
git bisect good be408cd3e1fef73e9408b196a79b9934697fe3b1  # 13:17     90+      3  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 7e82ea422c42db6b9c0188faeb98d6ec9ccfef8f  # 13:29     90+     29  Add linux-next specific files for 20131106

Thanks,
Fengguang

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-inn-1:20131107060149:x86_64-randconfig-x0-1106:3.12.0-00775-g44a40fd:9"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-00775-g44a40fd (kbuild@xian) (gcc versi=
on 4.8.1 (Debian 4.8.1-8) ) #9 Thu Nov 7 05:27:35 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-x0-1106/devel-xian-x86_64-201311=
070514/.vmlinuz-44a40fd21fcf04ed24396657e381da1b7412590f-20131107052926-4-i=
nn branch=3Dlinux-devel/devel-xian-x86_64-201311070514 BOOT_IMAGE=3D/kernel=
/x86_64-randconfig-x0-1106/44a40fd21fcf04ed24396657e381da1b7412590f/vmlinuz=
-3.12.0-00775-g44a40fd
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
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03203000, 0x03203fff] PGTABLE
[    0.000000] BRK [0x03204000, 0x03204fff] PGTABLE
[    0.000000] BRK [0x03205000, 0x03205fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x03206000, 0x03206fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x03207000, 0x03207fff] PGTABLE
[    0.000000] BRK [0x03208000, 0x03208fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127352(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 242bdc0
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-x0-1106/devel-xian-x86_64-=
201311070514/.vmlinuz-44a40fd21fcf04ed24396657e381da1b7412590f-201311070529=
26-4-inn branch=3Dlinux-devel/devel-xian-x86_64-201311070514 BOOT_IMAGE=3D/=
kernel/x86_64-randconfig-x0-1106/44a40fd21fcf04ed24396657e381da1b7412590f/v=
mlinuz-3.12.0-00775-g44a40fd
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 189900K/261744K available (12302K kernel code, 3584K=
 rwdata, 5520K rodata, 852K init, 9904K bss, 71844K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ODEBUG: 3 of 3 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.580 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.62 Bogo=
MIPS (lpj=3D8978600)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006717] Mount-cache hash table entries: 256
[    0.007513] BUG: spinlock trylock failure on UP on CPU#0, swapper/0
[    0.008374]  lock: 0xffff88000d801c78, .magic: dead4ead, .owner: swapper=
/0, .owner_cpu: 0
[    0.009584] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-00775-g44a40f=
d #9
[    0.010008]  ffffffff81095ffb ffffffff82401d28 ffffffff81bf07d0 ffffffff=
82401d48
[    0.011188]  ffffffff81bf0fff 0000000000000000 ffff88000d801c78 ffffffff=
82401d68
[    0.012431]  ffffffff81bf102a ffff88000d801c78 ffffffff82230ff4 ffffffff=
82401d80
[    0.014144] Call Trace:
[    0.014544]  [<ffffffff81095ffb>] ? up+0xf/0x39
[    0.015260]  [<ffffffff81bf07d0>] dump_stack+0x19/0x1b
[    0.016063]  [<ffffffff81bf0fff>] spin_dump+0x85/0x8a
[    0.016677]  [<ffffffff81bf102a>] spin_bug+0x26/0x28
[    0.017452]  [<ffffffff813a05c5>] do_raw_spin_trylock+0x37/0x3c
[    0.018379]  [<ffffffff81c00c68>] _raw_spin_lock+0x45/0x70
[    0.019200]  [<ffffffff81112651>] ? d_flags_for_inode+0x48/0xa9
[    0.020010]  [<ffffffff81112651>] d_flags_for_inode+0x48/0xa9
[    0.020865]  [<ffffffff811126cf>] __d_instantiate+0x1d/0xdf
[    0.021709]  [<ffffffff811143d1>] d_instantiate+0x35/0x4b
[    0.022469]  [<ffffffff811144f8>] d_make_root+0x32/0x49
[    0.023344]  [<ffffffff81152469>] sysfs_mount+0x162/0x1db
[    0.024154]  [<ffffffff81104a66>] mount_fs+0x10/0xac
[    0.024921]  [<ffffffff8111adb8>] vfs_kern_mount+0x5f/0xf3
[    0.025743]  [<ffffffff8111d12c>] kern_mount_data+0x14/0x29
[    0.026677]  [<ffffffff827a0abd>] sysfs_init+0x54/0xb3
[    0.027380]  [<ffffffff8279f3e2>] mnt_init+0xcb/0x1c7
[    0.028091]  [<ffffffff8279f0a7>] vfs_caches_init+0x90/0x107
[    0.028895]  [<ffffffff810e3d11>] ? kmem_cache_create+0x23/0x25
[    0.030011]  [<ffffffff82782d55>] start_kernel+0x431/0x482
[    0.030776]  [<ffffffff82782732>] ? repair_env_string+0x58/0x58
[    0.031632]  [<ffffffff82782120>] ? early_idt_handlers+0x120/0x120
[    0.032560]  [<ffffffff8278244c>] x86_64_start_reservations+0x2a/0x2c
[    0.033345]  [<ffffffff8278252a>] x86_64_start_kernel+0xdc/0xe9

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-x0-1106/44a40fd21fcf04ed24396657e381da1b7412590f/vmlinuz-3.12.0-00775-g44a=
40fd -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_b=
uf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk s=
ysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-qu=
eue/kvm/x86_64-randconfig-x0-1106/devel-xian-x86_64-201311070514/.vmlinuz-4=
4a40fd21fcf04ed24396657e381da1b7412590f-20131107052926-4-inn branch=3Dlinux=
-devel/devel-xian-x86_64-201311070514 BOOT_IMAGE=3D/kernel/x86_64-randconfi=
g-x0-1106/44a40fd21fcf04ed24396657e381da1b7412590f/vmlinuz-3.12.0-00775-g44=
a40fd'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 256M -smp 2=
 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-re=
boot -watchdog i6300esb -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-inn-1,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-inn-1,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-inn-1,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-inn-1,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-inn-1,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-inn-1,m=
edia=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-inn-1 -serial f=
ile:/dev/shm/kboot/serial-quantal-inn-1 -daemonize -display none -monitor n=
ull=20

--2oS5YaxWCcQjTEyO
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-44a40fd21fcf04ed24396657e381da1b7412590f-x86_64-randconfig-x0-1106-BUG:-spinlock-trylock-failure-on-UP-on-CPU-108212.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNDRhNDBmZC4uLiBNZXJnZSAndmZzL2Zvci1u
ZXh0JyBpbnRvIGRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUxNApIRUFEIGlzIG5vdyBh
dCA1ZTAxZGM3Li4uIExpbnV4IDMuMTIKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvbGludXgtZGV2ZWw6ZGV2ZWwteGlhbi14
ODZfNjQtMjAxMzExMDcwNTE0OjVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1
Y2ViNTI6YmlzZWN0LW5ldAogU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCA1ZTAxZGM3
YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCmdpdCBiaXNlY3Qgc3RhcnQgNDRh
NDBmZDIxZmNmMDRlZDI0Mzk2NjU3ZTM4MWRhMWI3NDEyNTkwZiA1ZTAxZGM3YjI2ZDlmMjRm
MzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDVlMDFkYzcuLi4gTGludXggMy4xMgpTd2l0Y2hlZCB0byBicmFuY2ggJ21hc3RlcicKWW91
ciBicmFuY2ggaXMgYmVoaW5kICdvcmlnaW4vbWFzdGVyJyBieSA0MTIxMyBjb21taXRzLCBh
bmQgY2FuIGJlIGZhc3QtZm9yd2FyZGVkLgogICh1c2UgImdpdCBwdWxsIiB0byB1cGRhdGUg
eW91ciBsb2NhbCBicmFuY2gpCkJpc2VjdGluZzogNDM2IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbNmEwNWNlZGY4OTY0MGJhZThlMTBh
YTZlZTcyNmE0OTg2YzQ4NDc1MF0gTWVyZ2UgJ29sZWcvdXByb2Jlcy9jb3JlJyBpbnRvIGRl
dmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUxNApnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJp
c2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2L2xpbnV4LWRldmVsOmRldmVsLXhp
YW4teDg2XzY0LTIwMTMxMTA3MDUxNDo2YTA1Y2VkZjg5NjQwYmFlOGUxMGFhNmVlNzI2YTQ5
ODZjNDg0NzUwOmJpc2VjdC1uZXQKCjIwMTMtMTEtMDctMDg6MTk6NDAgNmEwNWNlZGY4OTY0
MGJhZThlMTBhYTZlZTcyNmE0OTg2YzQ4NDc1MCBjb21waWxpbmcKNDQ4IHJlYWwgIDE3OTIg
dXNlciAgMTY1IHN5cyAgNDM2Ljc0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYK
CjIwMTMtMTEtMDctMDg6Mjc6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTAwMzM4
LWc2YTA1Y2VkLi4uLi4uCTEuLgkzLgk0Li4JNQk2Li4uLi4uCTcuLi4uLi4uCTkuLi4uLi4u
Li4uLgkxMC4uLi4uLgkxMgkxMwkxNS4uLi4uCTE2Li4uLi4JMTcuLi4JMTguLgkxOS4uCTIw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMjE4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbNDc5NmU4YWY2MGVlN2QyOTIyMzg2ZWY5ZmQ0Mzg5
ZDIxZTJjMTY2NV0gQmx1ZXRvb3RoOiBNYWtlIG1nbXRfd3JpdGVfc2Nhbl9mYWlsZWQoKSBy
ZXR1cm4gdm9pZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2L2xpbnV4LWRldmVsOmRl
dmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUxNDo0Nzk2ZThhZjYwZWU3ZDI5MjIzODZlZjlm
ZDQzODlkMjFlMmMxNjY1OmJpc2VjdC1uZXQKCjIwMTMtMTEtMDctMDk6MDQ6NTkgNDc5NmU4
YWY2MGVlN2QyOTIyMzg2ZWY5ZmQ0Mzg5ZDIxZTJjMTY2NSBjb21waWxpbmcKMjQzIHJlYWwg
IDE4MjEgdXNlciAgMTY0IHN5cyAgODE2LjEyJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgw
LTExMDYKCjIwMTMtMTEtMDctMDk6MDk6MTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4w
LTA3OTgyLWc0Nzk2ZThhLi4uLi4uLi4uLgkxLi4uLi4uLi4uLi4uLi4uLi4JMi4JMy4uLgk0
Li4uLi4uLi4uLi4uLi4uLi4uCTUJNgk3Li4uLi4uLi4uLi4uCTkJMTEJMTIuLi4uCTEzLi4u
LgkxNQkxNy4JMTguCTE5Li4uLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTA5IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbY2NhMzRi
Nzg1YTIxZDIyMDE3NjAzOGM0NTA3MWZmZTg0MmU5OWZkM10gQmx1ZXRvb3RoOiBSZW1vdmUg
bGluayB0eXBlIGNoZWNrIGluIGhjaV9kaXNjb25uX2NvbXBsZXRlX2V2dCgpCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
bmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXgwLTExMDYvbGludXgtZGV2ZWw6ZGV2ZWwteGlhbi14ODZfNjQtMjAx
MzExMDcwNTE0OmNjYTM0Yjc4NWEyMWQyMjAxNzYwMzhjNDUwNzFmZmU4NDJlOTlmZDM6Ymlz
ZWN0LW5ldAoKMjAxMy0xMS0wNy0wOTo1NTo0NyBjY2EzNGI3ODVhMjFkMjIwMTc2MDM4YzQ1
MDcxZmZlODQyZTk5ZmQzIGNvbXBpbGluZwozMyByZWFsICA1NyB1c2VyICAxMiBzeXMgIDIx
Mi4wMiUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2CgoyMDEzLTExLTA3LTA5OjU2
OjMwIGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC0wODA5MS1nY2NhMzRiNy4uLi4JMQky
CTMuLgk0Lgk1CTYuLi4uLi4uCTcJOC4uLi4uLi4uLi4JOS4uLgkxMC4uCTEyLi4uLgkxMy4u
LgkxNC4JMTUuCTE2LgkxNy4JMTguLi4uLi4uLgkxOS4uLi4uLi4uCTIwIFNVQ0NFU1MKCkJp
c2VjdGluZzogNTQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDYgc3RlcHMpClswMDRlODk1NzI4MGEzMmY3YjU0NzY2NTMxYzA2NDQxMmJkYTQ1ZTQ4XSBj
b252ZXJ0IHRoZSByZXN0IG9mIGJpbmZtdF9lbGZfZmRwaWMgdG8gZHVtcF9lbWl0KCkKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21l
L3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWcteDAtMTEwNi9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82
NC0yMDEzMTEwNzA1MTQ6MDA0ZTg5NTcyODBhMzJmN2I1NDc2NjUzMWMwNjQ0MTJiZGE0NWU0
ODpiaXNlY3QtbmV0CgoyMDEzLTExLTA3LTEwOjM0OjAyIDAwNGU4OTU3MjgwYTMyZjdiNTQ3
NjY1MzFjMDY0NDEyYmRhNDVlNDggY29tcGlsaW5nCjI0NyByZWFsICAxODUzIHVzZXIgIDE3
MCBzeXMgIDgxNi43OCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2CgoyMDEzLTEx
LTA3LTEwOjM4OjI1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzQtMDAwNTUtZzAw
NGU4OTUuLi4uLgkxCTIuLi4uLi4uCTMuCTQuLi4uCTUuLi4uCTYJNy4uCTkJMTAuCTEyCTE1
Li4JMTYJMTguCTE5LgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI3IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbYjBkOTRmYWNkN2M4MWZh
ZTQ4ZTcyZjFlMGIyYTdlNjU2ZWNkZTkyMV0gZXhwb3J0ZnM6IHN0b3AgcmV0cnlpbmcgb25j
ZSB3ZSByYWNlIHdpdGggcmVuYW1lL3JlbW92ZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MC0x
MTA2L2xpbnV4LWRldmVsOmRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUxNDpiMGQ5NGZh
Y2Q3YzgxZmFlNDhlNzJmMWUwYjJhN2U2NTZlY2RlOTIxOmJpc2VjdC1uZXQKCjIwMTMtMTEt
MDctMTA6NTk6NTYgYjBkOTRmYWNkN2M4MWZhZTQ4ZTcyZjFlMGIyYTdlNjU2ZWNkZTkyMSBj
b21waWxpbmcKMjIwIHJlYWwgIDE4MTYgdXNlciAgMTYyIHN5cyAgODk3LjU4JSBjcHUgCXg4
Nl82NC1yYW5kY29uZmlnLXgwLTExMDYKCjIwMTMtMTEtMDctMTE6MDM6NDYgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xMi4wLXJjNC0wMDA4Mi1nYjBkOTRmYS4gVEVTVCBGQUlMVVJFClsg
ICAgMC4wMDY2NjZdIENhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpIHByZXNldCB2
YWx1ZS4uIDUzMzUuNzcgQm9nb01JUFMgKGxwaj04ODg5MjQwKQpbICAgIDAuMDA2NjY2XSBw
aWRfbWF4OiBkZWZhdWx0OiAzMjc2OCBtaW5pbXVtOiAzMDEKWyAgICAwLjAwNzA3NV0gTW91
bnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAyNTYKWyAgICAwLjAwODMzOF0gQlVHOiBz
cGlubG9jayB0cnlsb2NrIGZhaWx1cmUgb24gVVAgb24gQ1BVIzAsIHN3YXBwZXIvMApbICAg
IDAuMDEwMDIyXSAgbG9jazogMHhmZmZmODgwMDBlYzAxYzc4LCAubWFnaWM6IGRlYWQ0ZWFk
LCAub3duZXI6IHN3YXBwZXIvMCwgLm93bmVyX2NwdTogMApbICAgIDAuMDExNTExXSBDUFU6
IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMi4wLXJjNC0wMDA4Mi1n
YjBkOTRmYSAjNTYxClsgICAgMC4wMTI4NzRdICBmZmZmZmZmZjgxMDk1ZmZiIGZmZmZmZmZm
ODIyMDFkMjggZmZmZmZmZmY4MWJlNDA3NyBmZmZmZmZmZjgyMjAxZDQ4ClsgICAgMC4wMTQy
NjNdICBmZmZmZmZmZjgxYmU0OGE2IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZWMwMWM3
OCBmZmZmZmZmZjgyMjAxZDY4ClsgICAgMC4wMTU2OTldICBmZmZmZmZmZjgxYmU0OGQxIGZm
ZmY4ODAwMGVjMDFjNzggZmZmZmZmZmY4MjAyOTQ1MyBmZmZmZmZmZjgyMjAxZDgwClsgICAg
MC4wMTc2MDFdIENhbGwgVHJhY2U6ClsgICAgMC4wMTgxMzddICBbPGZmZmZmZmZmODEwOTVm
ZmI+XSA/IHVwKzB4Zi8weDM5ClsgICAgMC4wMTkwMDVdICBbPGZmZmZmZmZmODFiZTQwNzc+
XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpbICAgIDAuMDIwMDE2XSAgWzxmZmZmZmZmZjgxYmU0
OGE2Pl0gc3Bpbl9kdW1wKzB4ODUvMHg4YQpbICAgIDAuMDIwOTQwXSAgWzxmZmZmZmZmZjgx
YmU0OGQxPl0gc3Bpbl9idWcrMHgyNi8weDI4ClsgICAgMC4wMjE4NzZdICBbPGZmZmZmZmZm
ODEzYTA0MTk+XSBkb19yYXdfc3Bpbl90cnlsb2NrKzB4MzcvMHgzYwpbICAgIDAuMDIyOTYx
XSAgWzxmZmZmZmZmZjgxYmY0MTU4Pl0gX3Jhd19zcGluX2xvY2srMHg0NS8weDcwClsgICAg
MC4wMjMzNjJdICBbPGZmZmZmZmZmODExMTIyMDU+XSA/IGRfZmxhZ3NfZm9yX2lub2RlKzB4
NDgvMHhhOQpbICAgIDAuMDI0NDM4XSAgWzxmZmZmZmZmZjgxMTEyMjA1Pl0gZF9mbGFnc19m
b3JfaW5vZGUrMHg0OC8weGE5ClsgICAgMC4wMjU0ODNdICBbPGZmZmZmZmZmODExMTIyODM+
XSBfX2RfaW5zdGFudGlhdGUrMHgxZC8weGRmClsgICAgMC4wMjY2ODFdICBbPGZmZmZmZmZm
ODExMTQwYmI+XSBkX2luc3RhbnRpYXRlKzB4MzUvMHg0YgpbICAgIDAuMDI3NjY2XSAgWzxm
ZmZmZmZmZjgxMTE0MWUyPl0gZF9tYWtlX3Jvb3QrMHgzMi8weDQ5ClsgICAgMC4wMjg2NDRd
ICBbPGZmZmZmZmZmODExNTFmNjY+XSBzeXNmc19tb3VudCsweDE2Mi8weDFkYgpbICAgIDAu
MDMwMDE1XSAgWzxmZmZmZmZmZjgxMTA0ODA3Pl0gbW91bnRfZnMrMHgxMC8weGFjClsgICAg
MC4wMzA5MjRdICBbPGZmZmZmZmZmODExMWE4ZmQ+XSB2ZnNfa2Vybl9tb3VudCsweDVmLzB4
ZjMKWyAgICAwLjAzMTkxN10gIFs8ZmZmZmZmZmY4MTExY2M3MT5dIGtlcm5fbW91bnRfZGF0
YSsweDE0LzB4MjkKWyAgICAwLjAzMjk2N10gIFs8ZmZmZmZmZmY4MjU5ZGFiOD5dIHN5c2Zz
X2luaXQrMHg1NC8weGIzClsgICAgMC4wMzMzNDhdICBbPGZmZmZmZmZmODI1OWMzZGQ+XSBt
bnRfaW5pdCsweGNiLzB4MWM3ClsgICAgMC4wMzQyNzZdICBbPGZmZmZmZmZmODI1OWMwYTI+
XSB2ZnNfY2FjaGVzX2luaXQrMHg5MC8weDEwNwpbICAgIDAuMDM1MzA4XSAgWzxmZmZmZmZm
ZjgxMGUzYjc4Pl0gPyBrbWVtX2NhY2hlX2NyZWF0ZSsweDIzLzB4MjUKWyAgICAwLjAzNjY4
NF0gIFs8ZmZmZmZmZmY4MjU3ZmQ1NT5dIHN0YXJ0X2tlcm5lbCsweDQzMS8weDQ4MgpbICAg
IDAuMDM3NjkwXSAgWzxmZmZmZmZmZjgyNTdmNzMyPl0gPyByZXBhaXJfZW52X3N0cmluZysw
eDU4LzB4NTgKWyAgICAwLjAzODc2MF0gIFs8ZmZmZmZmZmY4MjU3ZjEyMD5dID8gZWFybHlf
aWR0X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wNDAwMTVdICBbPGZmZmZmZmZmODI1
N2Y0NGM+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4MmEvMHgyYwpbICAgIDAuMDQx
MTc5XSAgWzxmZmZmZmZmZjgyNTdmNTJhPl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweGRjLzB4
ZTkKCkVsYXBzZWQgdGltZTogMTAKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVu
YWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvYjBk
OTRmYWNkN2M4MWZhZTQ4ZTcyZjFlMGIyYTdlNjU2ZWNkZTkyMS92bWxpbnV6LTMuMTIuMC1y
YzQtMDAwODItZ2IwZDk0ZmEgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgcmN1dHJlZS5y
Y3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIGxvZ19idWZfbGVuPThNIGlnbm9yZV9sb2dsZXZl
bCBkZWJ1ZyBzY2hlZF9kZWJ1ZyBhcGljPWRlYnVnIGR5bmFtaWNfcHJpbnRrIHN5c3JxX2Fs
d2F5c19lbmFibGVkIHBhbmljPTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAs
MTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5r
PS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2
L2xpbnV4LWRldmVsOmRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUxNDpiMGQ5NGZhY2Q3
YzgxZmFlNDhlNzJmMWUwYjJhN2U2NTZlY2RlOTIxOmJpc2VjdC1uZXQvLnZtbGludXotYjBk
OTRmYWNkN2M4MWZhZTQ4ZTcyZjFlMGIyYTdlNjU2ZWNkZTkyMS0yMDEzMTEwNzExMDM0NC0y
LWJlbnMgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUx
NCBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAtMTEwNi9iMGQ5NGZh
Y2Q3YzgxZmFlNDhlNzJmMWUwYjJhN2U2NTZlY2RlOTIxL3ZtbGludXotMy4xMi4wLXJjNC0w
MDA4Mi1nYjBkOTRmYScgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQveW9jdG8tbWlu
aW1hbC14ODZfNjQuY2d6IC1tIDI1Nk0gLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1l
MTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNo
ZG9nIGk2MzAwZXNiIC1kcml2ZSBmaWxlPS9mcy9zZGE3L2Rpc2swLXlvY3RvLWJlbnMtMixt
ZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvc2RhNy9kaXNrMS15b2N0by1i
ZW5zLTIsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL3NkYTcvZGlzazIt
eW9jdG8tYmVucy0yLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9zZGE3
L2Rpc2szLXlvY3RvLWJlbnMtMixtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0v
ZnMvc2RhNy9kaXNrNC15b2N0by1iZW5zLTIsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZl
IGZpbGU9L2ZzL3NkYTcvZGlzazUteW9jdG8tYmVucy0yLG1lZGlhPWRpc2ssaWY9dmlydGlv
IC1waWRmaWxlIC9kZXYvc2htL2tib290L3BpZC15b2N0by1iZW5zLTIgLXNlcmlhbCBmaWxl
Oi9kZXYvc2htL2tib290L3NlcmlhbC15b2N0by1iZW5zLTIgLWRhZW1vbml6ZSAtZGlzcGxh
eSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDAtMTEw
Ni9iMGQ5NGZhY2Q3YzgxZmFlNDhlNzJmMWUwYjJhN2U2NTZlY2RlOTIxL2RtZXNnLXlvY3Rv
LWJlbnMtMjoyMDEzMTEwNzExMDQwNDp4ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2OjMuMTIu
MC1yYzQtMDAwODItZ2IwZDk0ZmE6NTYxCjA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbmV0LWJpc2VjdC8ucmVw
ZWF0G1swbQoKQmlzZWN0aW5nOiAxMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgNCBzdGVwcykKWzUwMjM1Y2Q5NzI3YzIwYjA5OTY3YjVjMDYwMDI1ZWFj
OWQwYzgwYmJdIGVsZnssX2ZkcGljfSBjb3JlZHVtcDogZ2V0IHJpZCBvZiBwb2ludGxlc3Mg
aWYgKHNpZ2luZm8tPnNpX3NpZ25vKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2L2xp
bnV4LWRldmVsOmRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUxNDo1MDIzNWNkOTcyN2My
MGIwOTk2N2I1YzA2MDAyNWVhYzlkMGM4MGJiOmJpc2VjdC1uZXQKCjIwMTMtMTEtMDctMTE6
MDQ6MTcgNTAyMzVjZDk3MjdjMjBiMDk5NjdiNWMwNjAwMjVlYWM5ZDBjODBiYiBjb21waWxp
bmcKMTg0IHJlYWwgIDE1MjIgdXNlciAgMTM2IHN5cyAgOTAwLjI3JSBjcHUgCXg4Nl82NC1y
YW5kY29uZmlnLXgwLTExMDYKCjIwMTMtMTEtMDctMTE6MDc6MzAgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMi4wLXJjNC0wMDA2OC1nNTAyMzVjZC4uLi4uLi4uLi4JMS4uLi4JMgkzLgk0
CTUuLgk3Li4uCTguCTkuCTExLi4JMTMJMTQJMTUuLi4uCTE4CTIwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBz
dGVwcykKWzA4MTk2OTY5NTMyZWVlMTBjZGVhYTI5ZmNhMzdmYTdhNDA3YjAxYWVdIGRjYWNo
ZTogdXNlIElTX1JPT1QgdG8gZGVjaWRlIHdoZXJlIGRlbnRyeSBpcyBoYXNoZWQKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWcteDAtMTEwNi9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0y
MDEzMTEwNzA1MTQ6MDgxOTY5Njk1MzJlZWUxMGNkZWFhMjlmY2EzN2ZhN2E0MDdiMDFhZTpi
aXNlY3QtbmV0CgoyMDEzLTExLTA3LTExOjI4OjMxIDA4MTk2OTY5NTMyZWVlMTBjZGVhYTI5
ZmNhMzdmYTdhNDA3YjAxYWUgY29tcGlsaW5nCjE4MyByZWFsICAxNTQwIHVzZXIgIDEzNiBz
eXMgIDkxNC4zOCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2CgoyMDEzLTExLTA3
LTExOjMxOjQyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzQtMDAwNzUtZzA4MTk2
OTYuLi4uIFRFU1QgRkFJTFVSRQpbICAgIDAuMDA5OTk5XSBDYWxpYnJhdGluZyBkZWxheSBs
b29wIChza2lwcGVkKSBwcmVzZXQgdmFsdWUuLiAzMjAxLjQ0IEJvZ29NSVBTIChscGo9NTMz
MzUxNikKWyAgICAwLjAxMTM0NF0gcGlkX21heDogZGVmYXVsdDogMzI3NjggbWluaW11bTog
MzAxClsgICAgMC4wMTM1NjJdIE1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMjU2
ClsgICAgMC4wMTY5NjldIEJVRzogc3BpbmxvY2sgdHJ5bG9jayBmYWlsdXJlIG9uIFVQIG9u
IENQVSMwLCBzd2FwcGVyLzAKWyAgICAwLjAyMDAyM10gIGxvY2s6IDB4ZmZmZjg4MDAwZWMw
MWM3OCwgLm1hZ2ljOiBkZWFkNGVhZCwgLm93bmVyOiBzd2FwcGVyLzAsIC5vd25lcl9jcHU6
IDAKWyAgICAwLjAyMzM1Nl0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWlu
dGVkIDMuMTIuMC1yYzQtMDAwNzUtZzA4MTk2OTYgIzU2MwpbICAgIDAuMDI2Njg1XSAgZmZm
ZmZmZmY4MTA5NWZmYiBmZmZmZmZmZjgyMjAxZDI4IGZmZmZmZmZmODFiZTNmZjcgZmZmZmZm
ZmY4MjIwMWQ0OApbICAgIDAuMDMwODcyXSAgZmZmZmZmZmY4MWJlNDgyNiAwMDAwMDAwMDAw
MDAwMDAwIGZmZmY4ODAwMGVjMDFjNzggZmZmZmZmZmY4MjIwMWQ2OApbICAgIDAuMDM0OTYx
XSAgZmZmZmZmZmY4MWJlNDg1MSBmZmZmODgwMDBlYzAxYzc4IGZmZmZmZmZmODIwMjk0Njgg
ZmZmZmZmZmY4MjIwMWQ4MApbICAgIDAuMDM5MDEzXSBDYWxsIFRyYWNlOgpbICAgIDAuMDQw
MDI5XSAgWzxmZmZmZmZmZjgxMDk1ZmZiPl0gPyB1cCsweGYvMHgzOQpbICAgIDAuMDQyMDc3
XSAgWzxmZmZmZmZmZjgxYmUzZmY3Pl0gZHVtcF9zdGFjaysweDE5LzB4MWIKWyAgICAwLjA0
MzM2MF0gIFs8ZmZmZmZmZmY4MWJlNDgyNj5dIHNwaW5fZHVtcCsweDg1LzB4OGEKWyAgICAw
LjA0NjY5MV0gIFs8ZmZmZmZmZmY4MWJlNDg1MT5dIHNwaW5fYnVnKzB4MjYvMHgyOApbICAg
IDAuMDQ5MDI3XSAgWzxmZmZmZmZmZjgxM2EwMzk5Pl0gZG9fcmF3X3NwaW5fdHJ5bG9jaysw
eDM3LzB4M2MKWyAgICAwLjA1MDAyOF0gIFs8ZmZmZmZmZmY4MWJmNDBkOD5dIF9yYXdfc3Bp
bl9sb2NrKzB4NDUvMHg3MApbICAgIDAuMDUzMzYxXSAgWzxmZmZmZmZmZjgxMTEyMjA1Pl0g
PyBkX2ZsYWdzX2Zvcl9pbm9kZSsweDQ4LzB4YTkKWyAgICAwLjA1NjY5MF0gIFs8ZmZmZmZm
ZmY4MTExMjIwNT5dIGRfZmxhZ3NfZm9yX2lub2RlKzB4NDgvMHhhOQpbICAgIDAuMDYwMDIz
XSAgWzxmZmZmZmZmZjgxMTEyMjgzPl0gX19kX2luc3RhbnRpYXRlKzB4MWQvMHhkZgpbICAg
IDAuMDYyMjU3XSAgWzxmZmZmZmZmZjgxMTE0MGMzPl0gZF9pbnN0YW50aWF0ZSsweDM1LzB4
NGIKWyAgICAwLjA2MzM1OF0gIFs8ZmZmZmZmZmY4MTExNDFlYT5dIGRfbWFrZV9yb290KzB4
MzIvMHg0OQpbICAgIDAuMDY2NjkzXSAgWzxmZmZmZmZmZjgxMTUxZjczPl0gc3lzZnNfbW91
bnQrMHgxNjIvMHgxZGIKWyAgICAwLjA3MDAyNl0gIFs8ZmZmZmZmZmY4MTEwNDgwNz5dIG1v
dW50X2ZzKzB4MTAvMHhhYwpbICAgIDAuMDcyMTg1XSAgWzxmZmZmZmZmZjgxMTFhOTBhPl0g
dmZzX2tlcm5fbW91bnQrMHg1Zi8weGYzClsgICAgMC4wNzMzNTldICBbPGZmZmZmZmZmODEx
MWNjN2U+XSBrZXJuX21vdW50X2RhdGErMHgxNC8weDI5ClsgICAgMC4wNzY2OTJdICBbPGZm
ZmZmZmZmODI1OWRhYjg+XSBzeXNmc19pbml0KzB4NTQvMHhiMwpbICAgIDAuMDgwMDI1XSAg
WzxmZmZmZmZmZjgyNTljM2RkPl0gbW50X2luaXQrMHhjYi8weDFjNwpbICAgIDAuMDgyNDA4
XSAgWzxmZmZmZmZmZjgyNTljMGEyPl0gdmZzX2NhY2hlc19pbml0KzB4OTAvMHgxMDcKWyAg
ICAwLjA4MzM1OF0gIFs8ZmZmZmZmZmY4MTBlM2I3OD5dID8ga21lbV9jYWNoZV9jcmVhdGUr
MHgyMy8weDI1ClsgICAgMC4wODY3MTNdICBbPGZmZmZmZmZmODI1N2ZkNTU+XSBzdGFydF9r
ZXJuZWwrMHg0MzEvMHg0ODIKWyAgICAwLjA5MDAyMl0gIFs8ZmZmZmZmZmY4MjU3ZjczMj5d
ID8gcmVwYWlyX2Vudl9zdHJpbmcrMHg1OC8weDU4ClsgICAgMC4wOTMzNTldICBbPGZmZmZm
ZmZmODI1N2YxMjA+XSA/IGVhcmx5X2lkdF9oYW5kbGVycysweDEyMC8weDEyMApbICAgIDAu
MDk2NjkzXSAgWzxmZmZmZmZmZjgyNTdmNDRjPl0geDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9u
cysweDJhLzB4MmMKWyAgICAwLjA5OTY4OF0gIFs8ZmZmZmZmZmY4MjU3ZjUyYT5dIHg4Nl82
NF9zdGFydF9rZXJuZWwrMHhkYy8weGU5CgpFbGFwc2VkIHRpbWU6IDEwCnFlbXUtc3lzdGVt
LXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy14MC0xMTA2LzA4MTk2OTY5NTMyZWVlMTBjZGVhYTI5ZmNhMzdmYTdhNDA3
YjAxYWUvdm1saW51ei0zLjEyLjAtcmM0LTAwMDc1LWcwODE5Njk2IC1hcHBlbmQgJ2h1bmdf
dGFza19wYW5pYz0xIHJjdXRyZWUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBsb2dfYnVm
X2xlbj04TSBpZ25vcmVfbG9nbGV2ZWwgZGVidWcgc2NoZWRfZGVidWcgYXBpYz1kZWJ1ZyBk
eW5hbWljX3ByaW50ayBzeXNycV9hbHdheXNfZW5hYmxlZCBwYW5pYz0xMCAgcHJvbXB0X3Jh
bWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAg
cm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWcteDAtMTEwNi9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0y
MDEzMTEwNzA1MTQ6MDgxOTY5Njk1MzJlZWUxMGNkZWFhMjlmY2EzN2ZhN2E0MDdiMDFhZTpi
aXNlY3QtbmV0Ly52bWxpbnV6LTA4MTk2OTY5NTMyZWVlMTBjZGVhYTI5ZmNhMzdmYTdhNDA3
YjAxYWUtMjAxMzExMDcxMTMxNDAtNy1qYWtldG93biBicmFuY2g9bGludXgtZGV2ZWwvZGV2
ZWwteGlhbi14ODZfNjQtMjAxMzExMDcwNTE0IEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy14MC0xMTA2LzA4MTk2OTY5NTMyZWVlMTBjZGVhYTI5ZmNhMzdmYTdhNDA3
YjAxYWUvdm1saW51ei0zLjEyLjAtcmM0LTAwMDc1LWcwODE5Njk2JyAgLWluaXRyZCAva2Vy
bmVsLXRlc3RzL2luaXRyZC95b2N0by1taW5pbWFsLXg4Nl82NC5jZ3ogLW0gMjU2TSAtc21w
IDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEgLWJvb3Qg
b3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXBpZGZpbGUgL2Rldi9z
aG0va2Jvb3QvcGlkLXlvY3RvLWpha2V0b3duLTUgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2ti
b290L3NlcmlhbC15b2N0by1qYWtldG93bi01IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAt
bW9uaXRvciBudWxsIAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvMDgxOTY5
Njk1MzJlZWUxMGNkZWFhMjlmY2EzN2ZhN2E0MDdiMDFhZS9kbWVzZy15b2N0by1qYWtldG93
bi01OjIwMTMxMTA3MTEzMzI0Ong4Nl82NC1yYW5kY29uZmlnLXgwLTExMDY6My4xMi4wLXJj
NC0wMDA3NS1nMDgxOTY5Njo1NjMKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
G1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy9uZXQtYmlzZWN0Ly5yZXBlYXQb
WzBtCgpCaXNlY3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDIgc3RlcHMpCls3NzE3YmYyMWU0YTVlMWQzNzFlMzEzYTQ0MDQ2MzVmNDc3NTk2
MWQ5XSB2ZnM6IHNwbGl0IG91dCB2ZnNfZ2V0YXR0cl9ub3NlYwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy14MC0xMTA2L2xpbnV4LWRldmVsOmRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUx
NDo3NzE3YmYyMWU0YTVlMWQzNzFlMzEzYTQ0MDQ2MzVmNDc3NTk2MWQ5OmJpc2VjdC1uZXQK
CjIwMTMtMTEtMDctMTE6MzM6NDQgNzcxN2JmMjFlNGE1ZTFkMzcxZTMxM2E0NDA0NjM1ZjQ3
NzU5NjFkOSBjb21waWxpbmcKMjUgcmVhbCAgNDUgdXNlciAgMTMgc3lzICAyMzMuMTIlIGNw
dSAJeDg2XzY0LXJhbmRjb25maWcteDAtMTEwNgoKMjAxMy0xMS0wNy0xMTozNDoxOSBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM0LTAwMDcxLWc3NzE3YmYyLi4uLi4JMS4uIFRF
U1QgRkFJTFVSRQpbICAgIDAuMDA2NjY2XSBDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lw
cGVkKSBwcmVzZXQgdmFsdWUuLiA1MzIyLjg3IEJvZ29NSVBTIChscGo9ODg2NzAwNikKWyAg
ICAwLjAwNjY2Nl0gcGlkX21heDogZGVmYXVsdDogMzI3NjggbWluaW11bTogMzAxClsgICAg
MC4wMDcwMTFdIE1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMjU2ClsgICAgMC4w
MDgxMjddIEJVRzogc3BpbmxvY2sgdHJ5bG9jayBmYWlsdXJlIG9uIFVQIG9uIENQVSMwLCBz
d2FwcGVyLzAKWyAgICAwLjAxMDAwOF0gIGxvY2s6IDB4ZmZmZjg4MDAwZDgwMWM3OCwgLm1h
Z2ljOiBkZWFkNGVhZCwgLm93bmVyOiBzd2FwcGVyLzAsIC5vd25lcl9jcHU6IDAKWyAgICAw
LjAxMzM0M10gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTIu
MC1yYzQtMDAwNzEtZzc3MTdiZjIgIzU2NApbICAgIDAuMDE0NTcyXSAgZmZmZmZmZmY4MTA5
NWZmYiBmZmZmZmZmZjgyMjAxZDI4IGZmZmZmZmZmODFiZTNmZDcgZmZmZmZmZmY4MjIwMWQ0
OApbICAgIDAuMDE1ODYwXSAgZmZmZmZmZmY4MWJlNDgwNiAwMDAwMDAwMDAwMDAwMDAwIGZm
ZmY4ODAwMGQ4MDFjNzggZmZmZmZmZmY4MjIwMWQ2OApbICAgIDAuMDE3MjU2XSAgZmZmZmZm
ZmY4MWJlNDgzMSBmZmZmODgwMDBkODAxYzc4IGZmZmZmZmZmODIwMjk0NzcgZmZmZmZmZmY4
MjIwMWQ4MApbICAgIDAuMDE4NTU2XSBDYWxsIFRyYWNlOgpbICAgIDAuMDE4OTcwXSAgWzxm
ZmZmZmZmZjgxMDk1ZmZiPl0gPyB1cCsweGYvMHgzOQpbICAgIDAuMDE5NzI0XSAgWzxmZmZm
ZmZmZjgxYmUzZmQ3Pl0gZHVtcF9zdGFjaysweDE5LzB4MWIKWyAgICAwLjAyMDAwN10gIFs8
ZmZmZmZmZmY4MWJlNDgwNj5dIHNwaW5fZHVtcCsweDg1LzB4OGEKWyAgICAwLjAyMDg0N10g
IFs8ZmZmZmZmZmY4MWJlNDgzMT5dIHNwaW5fYnVnKzB4MjYvMHgyOApbICAgIDAuMDIxNjcy
XSAgWzxmZmZmZmZmZjgxM2EwMzc5Pl0gZG9fcmF3X3NwaW5fdHJ5bG9jaysweDM3LzB4M2MK
WyAgICAwLjAyMzM1MF0gIFs8ZmZmZmZmZmY4MWJmNDBiOD5dIF9yYXdfc3Bpbl9sb2NrKzB4
NDUvMHg3MApbICAgIDAuMDI0MjY5XSAgWzxmZmZmZmZmZjgxMTEyMjA1Pl0gPyBkX2ZsYWdz
X2Zvcl9pbm9kZSsweDQ4LzB4YTkKWyAgICAwLjAyNjY3NF0gIFs8ZmZmZmZmZmY4MTExMjIw
NT5dIGRfZmxhZ3NfZm9yX2lub2RlKzB4NDgvMHhhOQpbICAgIDAuMDI4NjE5XSAgWzxmZmZm
ZmZmZjgxMTEyMjgzPl0gX19kX2luc3RhbnRpYXRlKzB4MWQvMHhkZgpbICAgIDAuMDI5NTQx
XSAgWzxmZmZmZmZmZjgxMTE0MGMzPl0gZF9pbnN0YW50aWF0ZSsweDM1LzB4NGIKWyAgICAw
LjAzMDAwOV0gIFs8ZmZmZmZmZmY4MTExNDFlYT5dIGRfbWFrZV9yb290KzB4MzIvMHg0OQpb
ICAgIDAuMDMwOTQ1XSAgWzxmZmZmZmZmZjgxMTUxZjczPl0gc3lzZnNfbW91bnQrMHgxNjIv
MHgxZGIKWyAgICAwLjAzMTgzNF0gIFs8ZmZmZmZmZmY4MTEwNDgwNz5dIG1vdW50X2ZzKzB4
MTAvMHhhYwpbICAgIDAuMDMzMzQxXSAgWzxmZmZmZmZmZjgxMTFhOTBhPl0gdmZzX2tlcm5f
bW91bnQrMHg1Zi8weGYzClsgICAgMC4wMzY2ODRdICBbPGZmZmZmZmZmODExMWNjN2U+XSBr
ZXJuX21vdW50X2RhdGErMHgxNC8weDI5ClsgICAgMC4wMzc2MDBdICBbPGZmZmZmZmZmODI1
OWRhYjg+XSBzeXNmc19pbml0KzB4NTQvMHhiMwpbICAgIDAuMDM4NDQ3XSAgWzxmZmZmZmZm
ZjgyNTljM2RkPl0gbW50X2luaXQrMHhjYi8weDFjNwpbICAgIDAuMDM5MjgxXSAgWzxmZmZm
ZmZmZjgyNTljMGEyPl0gdmZzX2NhY2hlc19pbml0KzB4OTAvMHgxMDcKWyAgICAwLjA0MDAw
OF0gIFs8ZmZmZmZmZmY4MTBlM2I3OD5dID8ga21lbV9jYWNoZV9jcmVhdGUrMHgyMy8weDI1
ClsgICAgMC4wNDA5OTVdICBbPGZmZmZmZmZmODI1N2ZkNTU+XSBzdGFydF9rZXJuZWwrMHg0
MzEvMHg0ODIKWyAgICAwLjA0MTg5Nl0gIFs8ZmZmZmZmZmY4MjU3ZjczMj5dID8gcmVwYWly
X2Vudl9zdHJpbmcrMHg1OC8weDU4ClsgICAgMC4wNDMzNDBdICBbPGZmZmZmZmZmODI1N2Yx
MjA+XSA/IGVhcmx5X2lkdF9oYW5kbGVycysweDEyMC8weDEyMApbICAgIDAuMDQ0MzUyXSAg
WzxmZmZmZmZmZjgyNTdmNDRjPl0geDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysweDJhLzB4
MmMKWyAgICAwLjA0NTQzNl0gIFs8ZmZmZmZmZmY4MjU3ZjUyYT5dIHg4Nl82NF9zdGFydF9r
ZXJuZWwrMHhkYy8weGU5CgpFbGFwc2VkIHRpbWU6IDEwCnFlbXUtc3lzdGVtLXg4Nl82NCAt
Y3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MC0xMTA2Lzc3MTdiZjIxZTRhNWUxZDM3MWUzMTNhNDQwNDYzNWY0Nzc1OTYxZDkvdm1s
aW51ei0zLjEyLjAtcmM0LTAwMDcxLWc3NzE3YmYyIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5p
Yz0xIHJjdXRyZWUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBsb2dfYnVmX2xlbj04TSBp
Z25vcmVfbG9nbGV2ZWwgZGVidWcgc2NoZWRfZGVidWcgYXBpYz1kZWJ1ZyBkeW5hbWljX3By
aW50ayBzeXNycV9hbHdheXNfZW5hYmxlZCBwYW5pYz0xMCAgcHJvbXB0X3JhbWRpc2s9MCBj
b25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2
L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWcteDAtMTEwNi9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwNzA1
MTQ6NzcxN2JmMjFlNGE1ZTFkMzcxZTMxM2E0NDA0NjM1ZjQ3NzU5NjFkOTpiaXNlY3QtbmV0
Ly52bWxpbnV6LTc3MTdiZjIxZTRhNWUxZDM3MWUzMTNhNDQwNDYzNWY0Nzc1OTYxZDktMjAx
MzExMDcxMTM0MTctNC1sa3Atc3QwMSBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwteGlhbi14
ODZfNjQtMjAxMzExMDcwNTE0IEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MC0xMTA2Lzc3MTdiZjIxZTRhNWUxZDM3MWUzMTNhNDQwNDYzNWY0Nzc1OTYxZDkvdm1s
aW51ei0zLjEyLjAtcmM0LTAwMDcxLWc3NzE3YmYyJyAgLWluaXRyZCAva2VybmVsLXRlc3Rz
L2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAtbSAyNTZNIC1zbXAgMiAtbmV0IG5p
Yyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAt
bm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZN
L2Rpc2swLXF1YW50YWwtbGtwLXN0MDEtOCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUg
ZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2sxLXF1YW50YWwtbGtwLXN0MDEtOCxtZWRpYT1kaXNr
LGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2syLXF1YW50YWwtbGtw
LXN0MDEtOCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZN
L2Rpc2szLXF1YW50YWwtbGtwLXN0MDEtOCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUg
ZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s0LXF1YW50YWwtbGtwLXN0MDEtOCxtZWRpYT1kaXNr
LGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s1LXF1YW50YWwtbGtw
LXN0MDEtOCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9w
aWQtcXVhbnRhbC1sa3Atc3QwMS04IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJp
YWwtcXVhbnRhbC1sa3Atc3QwMS04IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRv
ciBudWxsIAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvNzcxN2JmMjFlNGE1
ZTFkMzcxZTMxM2E0NDA0NjM1ZjQ3NzU5NjFkOS9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTg6
MjAxMzExMDcxOTM0NDM6eDg2XzY0LXJhbmRjb25maWcteDAtMTEwNjozLjEyLjAtcmM0LTAw
MDcxLWc3NzE3YmYyOjU2NAowOjE6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7
MzVtUkVQRUFUIENPVU5UOiAzMCAgIyAvY2Mvd2ZnL25ldC1iaXNlY3QvLnJlcGVhdBtbMG0K
CkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMSBzdGVwKQpbNTIwZWYwNzhlYWJkYmU3ZWI2YTMzYzFmNTZhNjVhYzU1ZDQxZTZlZF0g
aWdldC9pZ2V0NTogZG9uJ3QgYm90aGVyIHdpdGggLT5pX2xvY2sgdW50aWwgd2UgZmluZCBh
IG1hdGNoCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvbGludXgtZGV2ZWw6ZGV2ZWwt
eGlhbi14ODZfNjQtMjAxMzExMDcwNTE0OjUyMGVmMDc4ZWFiZGJlN2ViNmEzM2MxZjU2YTY1
YWM1NWQ0MWU2ZWQ6YmlzZWN0LW5ldAoKMjAxMy0xMS0wNy0xMTozODoyMiA1MjBlZjA3OGVh
YmRiZTdlYjZhMzNjMWY1NmE2NWFjNTVkNDFlNmVkIGNvbXBpbGluZwoxOTAgcmVhbCAgMTU0
MCB1c2VyICAxNDYgc3lzICA4ODQuNzQlIGNwdSAJeDg2XzY0LXJhbmRjb25maWcteDAtMTEw
NgoKMjAxMy0xMS0wNy0xMTo0MzowMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM0
LTAwMDcwLWc1MjBlZjA3Li4uLi4uIFRFU1QgRkFJTFVSRQpbICAgIDAuMDA2NjY2XSBDYWxp
YnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBwcmVzZXQgdmFsdWUuLiA1Nzg4LjEwIEJv
Z29NSVBTIChscGo9OTY0MzM2MCkKWyAgICAwLjAwNzIxOV0gcGlkX21heDogZGVmYXVsdDog
MzI3NjggbWluaW11bTogMzAxClsgICAgMC4wMDgxNjBdIE1vdW50LWNhY2hlIGhhc2ggdGFi
bGUgZW50cmllczogMjU2ClsgICAgMC4wMDkxNDldIEJVRzogc3BpbmxvY2sgdHJ5bG9jayBm
YWlsdXJlIG9uIFVQIG9uIENQVSMwLCBzd2FwcGVyLzAKWyAgICAwLjAxMDAxMV0gIGxvY2s6
IDB4ZmZmZjg4MDAwZWMwMWM3OCwgLm1hZ2ljOiBkZWFkNGVhZCwgLm93bmVyOiBzd2FwcGVy
LzAsIC5vd25lcl9jcHU6IDAKWyAgICAwLjAxMTQ2Nl0gQ1BVOiAwIFBJRDogMCBDb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuMTIuMC1yYzQtMDAwNzAtZzUyMGVmMDcgIzU2NQpbICAg
IDAuMDEzMzQyXSAgZmZmZmZmZmY4MTA5NWZmYiBmZmZmZmZmZjgyMjAxZDI4IGZmZmZmZmZm
ODFiZTNmYzcgZmZmZmZmZmY4MjIwMWQ0OApbICAgIDAuMDE0ODA1XSAgZmZmZmZmZmY4MWJl
NDdmNiAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGVjMDFjNzggZmZmZmZmZmY4MjIwMWQ2
OApbICAgIDAuMDE2Mjc2XSAgZmZmZmZmZmY4MWJlNDgyMSBmZmZmODgwMDBlYzAxYzc4IGZm
ZmZmZmZmODIwMjk0NGYgZmZmZmZmZmY4MjIwMWQ4MApbICAgIDAuMDE3NTg2XSBDYWxsIFRy
YWNlOgpbICAgIDAuMDE4MDU0XSAgWzxmZmZmZmZmZjgxMDk1ZmZiPl0gPyB1cCsweGYvMHgz
OQpbICAgIDAuMDE4ODc3XSAgWzxmZmZmZmZmZjgxYmUzZmM3Pl0gZHVtcF9zdGFjaysweDE5
LzB4MWIKWyAgICAwLjAyMDAxM10gIFs8ZmZmZmZmZmY4MWJlNDdmNj5dIHNwaW5fZHVtcCsw
eDg1LzB4OGEKWyAgICAwLjAyMDkyOV0gIFs8ZmZmZmZmZmY4MWJlNDgyMT5dIHNwaW5fYnVn
KzB4MjYvMHgyOApbICAgIDAuMDIxODI5XSAgWzxmZmZmZmZmZjgxM2EwMzY5Pl0gZG9fcmF3
X3NwaW5fdHJ5bG9jaysweDM3LzB4M2MKWyAgICAwLjAyMzM0OF0gIFs8ZmZmZmZmZmY4MWJm
NDBhOD5dIF9yYXdfc3Bpbl9sb2NrKzB4NDUvMHg3MApbICAgIDAuMDI0MjkxXSAgWzxmZmZm
ZmZmZjgxMTEyMWZhPl0gPyBkX2ZsYWdzX2Zvcl9pbm9kZSsweDQ4LzB4YTkKWyAgICAwLjAy
NTM1N10gIFs8ZmZmZmZmZmY4MTExMjFmYT5dIGRfZmxhZ3NfZm9yX2lub2RlKzB4NDgvMHhh
OQpbICAgIDAuMDI2Mzk4XSAgWzxmZmZmZmZmZjgxMTEyMjc4Pl0gX19kX2luc3RhbnRpYXRl
KzB4MWQvMHhkZgpbICAgIDAuMDI2NjgxXSAgWzxmZmZmZmZmZjgxMTE0MGI4Pl0gZF9pbnN0
YW50aWF0ZSsweDM1LzB4NGIKWyAgICAwLjAyNzY3N10gIFs8ZmZmZmZmZmY4MTExNDFkZj5d
IGRfbWFrZV9yb290KzB4MzIvMHg0OQpbICAgIDAuMDI4NjExXSAgWzxmZmZmZmZmZjgxMTUx
ZjY4Pl0gc3lzZnNfbW91bnQrMHgxNjIvMHgxZGIKWyAgICAwLjAzMDAxM10gIFs8ZmZmZmZm
ZmY4MTEwNDgwNz5dIG1vdW50X2ZzKzB4MTAvMHhhYwpbICAgIDAuMDMwOTA5XSAgWzxmZmZm
ZmZmZjgxMTFhOGZmPl0gdmZzX2tlcm5fbW91bnQrMHg1Zi8weGYzClsgICAgMC4wMzE4OTNd
ICBbPGZmZmZmZmZmODExMWNjNzM+XSBrZXJuX21vdW50X2RhdGErMHgxNC8weDI5ClsgICAg
MC4wMzMzNDhdICBbPGZmZmZmZmZmODI1OWRhYjg+XSBzeXNmc19pbml0KzB4NTQvMHhiMwpb
ICAgIDAuMDM0Mjg3XSAgWzxmZmZmZmZmZjgyNTljM2RkPl0gbW50X2luaXQrMHhjYi8weDFj
NwpbICAgIDAuMDM1MTkxXSAgWzxmZmZmZmZmZjgyNTljMGEyPl0gdmZzX2NhY2hlc19pbml0
KzB4OTAvMHgxMDcKWyAgICAwLjAzNjIwM10gIFs8ZmZmZmZmZmY4MTBlM2I3OD5dID8ga21l
bV9jYWNoZV9jcmVhdGUrMHgyMy8weDI1ClsgICAgMC4wMzY2ODNdICBbPGZmZmZmZmZmODI1
N2ZkNTU+XSBzdGFydF9rZXJuZWwrMHg0MzEvMHg0ODIKWyAgICAwLjAzNzY4Nl0gIFs8ZmZm
ZmZmZmY4MjU3ZjczMj5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHg1OC8weDU4ClsgICAgMC4w
Mzg3NTBdICBbPGZmZmZmZmZmODI1N2YxMjA+XSA/IGVhcmx5X2lkdF9oYW5kbGVycysweDEy
MC8weDEyMApbICAgIDAuMDQwMDEyXSAgWzxmZmZmZmZmZjgyNTdmNDRjPl0geDg2XzY0X3N0
YXJ0X3Jlc2VydmF0aW9ucysweDJhLzB4MmMKWyAgICAwLjA0MTE5N10gIFs8ZmZmZmZmZmY4
MjU3ZjUyYT5dIHg4Nl82NF9zdGFydF9rZXJuZWwrMHhkYy8weGU5CgpFbGFwc2VkIHRpbWU6
IDUKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvNTIwZWYwNzhlYWJkYmU3ZWI2YTMz
YzFmNTZhNjVhYzU1ZDQxZTZlZC92bWxpbnV6LTMuMTIuMC1yYzQtMDAwNzAtZzUyMGVmMDcg
LWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgcmN1dHJlZS5yY3VfY3B1X3N0YWxsX3RpbWVv
dXQ9MTAwIGxvZ19idWZfbGVuPThNIGlnbm9yZV9sb2dsZXZlbCBkZWJ1ZyBzY2hlZF9kZWJ1
ZyBhcGljPWRlYnVnIGR5bmFtaWNfcHJpbnRrIHN5c3JxX2Fsd2F5c19lbmFibGVkIHBhbmlj
PTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5
MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2L2xpbnV4LWRldmVsOmRldmVs
LXhpYW4teDg2XzY0LTIwMTMxMTA3MDUxNDo1MjBlZjA3OGVhYmRiZTdlYjZhMzNjMWY1NmE2
NWFjNTVkNDFlNmVkOmJpc2VjdC1uZXQvLnZtbGludXotNTIwZWYwNzhlYWJkYmU3ZWI2YTMz
YzFmNTZhNjVhYzU1ZDQxZTZlZC0yMDEzMTEwNzExNDI1OC05LWNhaXJvIGJyYW5jaD1saW51
eC1kZXZlbC9kZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwNzA1MTQgQk9PVF9JTUFHRT0va2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvNTIwZWYwNzhlYWJkYmU3ZWI2YTMzYzFm
NTZhNjVhYzU1ZDQxZTZlZC92bWxpbnV6LTMuMTIuMC1yYzQtMDAwNzAtZzUyMGVmMDcnICAt
aW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3lvY3RvLW1pbmltYWwteDg2XzY0LmNneiAt
bSAyNTZNIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZs
YW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtZHJp
dmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2swLXlvY3RvLWNhaXJvLTIwLG1lZGlhPWRpc2ss
aWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazEteW9jdG8tY2Fpcm8t
MjAsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNr
Mi15b2N0by1jYWlyby0yMCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMv
TEFCRUw9S1ZNL2Rpc2szLXlvY3RvLWNhaXJvLTIwLG1lZGlhPWRpc2ssaWY9dmlydGlvIC1k
cml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazQteW9jdG8tY2Fpcm8tMjAsbWVkaWE9ZGlz
ayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrNS15b2N0by1jYWly
by0yMCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQt
eW9jdG8tY2Fpcm8tMjAgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC15b2N0
by1jYWlyby0yMCAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2LzUyMGVmMDc4ZWFiZGJlN2ViNmEzM2Mx
ZjU2YTY1YWM1NWQ0MWU2ZWQvZG1lc2cteW9jdG8tY2Fpcm8tMjA6MjAxMzExMDcxMTQ1NDE6
eDg2XzY0LXJhbmRjb25maWcteDAtMTEwNjozLjEyLjAtcmM0LTAwMDcwLWc1MjBlZjA3OjU2
NQowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAwIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbMTI0N2M3
NGI0ZjNmMzcyNWE4YmQ4ZGMwYmJkMjJiYWEyYTkwNDlhZV0gVkZTOiBQdXQgYSBzbWFsbCB0
eXBlIGZpZWxkIGludG8gc3RydWN0IGRlbnRyeTo6ZF9mbGFncwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy14MC0xMTA2L2xpbnV4LWRldmVsOmRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUx
NDoxMjQ3Yzc0YjRmM2YzNzI1YThiZDhkYzBiYmQyMmJhYTJhOTA0OWFlOmJpc2VjdC1uZXQK
CjIwMTMtMTEtMDctMTE6NDY6MDIgMTI0N2M3NGI0ZjNmMzcyNWE4YmQ4ZGMwYmJkMjJiYWEy
YTkwNDlhZSBjb21waWxpbmcKMjYgcmVhbCAgNDggdXNlciAgMTIgc3lzICAyMzQuNDYlIGNw
dSAJeDg2XzY0LXJhbmRjb25maWcteDAtMTEwNgoKMjAxMy0xMS0wNy0xMTo0Nzo0NiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM0LTAwMDY5LWcxMjQ3Yzc0Li4uIFRFU1QgRkFJ
TFVSRQpbICAgIDAuMDA2NjY2XSBDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSBw
cmVzZXQgdmFsdWUuLiA0NjAyLjA2IEJvZ29NSVBTIChscGo9NzY2NzMwNikKWyAgICAwLjAw
NjY3Nl0gcGlkX21heDogZGVmYXVsdDogMzI3NjggbWluaW11bTogMzAxClsgICAgMC4wMDc4
MzNdIE1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczogMjU2ClsgICAgMC4wMDkwMTVd
IEJVRzogc3BpbmxvY2sgdHJ5bG9jayBmYWlsdXJlIG9uIFVQIG9uIENQVSMwLCBzd2FwcGVy
LzAKWyAgICAwLjAxMDAxMV0gIGxvY2s6IDB4ZmZmZjg4MDAwZWMwMWM3OCwgLm1hZ2ljOiBk
ZWFkNGVhZCwgLm93bmVyOiBzd2FwcGVyLzAsIC5vd25lcl9jcHU6IDAKWyAgICAwLjAxMTg2
MV0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTIuMC1yYzQt
MDAwNjktZzEyNDdjNzQgIzU2NgpbICAgIDAuMDEzMzQyXSAgZmZmZmZmZmY4MTA5NWZmYiBm
ZmZmZmZmZjgyMjAxZDI4IGZmZmZmZmZmODFiZTNmZDcgZmZmZmZmZmY4MjIwMWQ0OApbICAg
IDAuMDE1MTI2XSAgZmZmZmZmZmY4MWJlNDgwNiAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAw
MGVjMDFjNzggZmZmZmZmZmY4MjIwMWQ2OApbICAgIDAuMDE3ODIyXSAgZmZmZmZmZmY4MWJl
NDgzMSBmZmZmODgwMDBlYzAxYzc4IGZmZmZmZmZmODIwMjk0NGYgZmZmZmZmZmY4MjIwMWQ4
MApbICAgIDAuMDIwMDgyXSBDYWxsIFRyYWNlOgpbICAgIDAuMDIwNjM1XSAgWzxmZmZmZmZm
ZjgxMDk1ZmZiPl0gPyB1cCsweGYvMHgzOQpbICAgIDAuMDIxNjgxXSAgWzxmZmZmZmZmZjgx
YmUzZmQ3Pl0gZHVtcF9zdGFjaysweDE5LzB4MWIKWyAgICAwLjAyMjg3OV0gIFs8ZmZmZmZm
ZmY4MWJlNDgwNj5dIHNwaW5fZHVtcCsweDg1LzB4OGEKWyAgICAwLjAyMzM0NF0gIFs8ZmZm
ZmZmZmY4MWJlNDgzMT5dIHNwaW5fYnVnKzB4MjYvMHgyOApbICAgIDAuMDI0NDgzXSAgWzxm
ZmZmZmZmZjgxM2EwMzc5Pl0gZG9fcmF3X3NwaW5fdHJ5bG9jaysweDM3LzB4M2MKWyAgICAw
LjAyNTgyMF0gIFs8ZmZmZmZmZmY4MWJmNDBiOD5dIF9yYXdfc3Bpbl9sb2NrKzB4NDUvMHg3
MApbICAgIDAuMDI2NjgwXSAgWzxmZmZmZmZmZjgxMTEyMWZhPl0gPyBkX2ZsYWdzX2Zvcl9p
bm9kZSsweDQ4LzB4YTkKWyAgICAwLjAyODAyNl0gIFs8ZmZmZmZmZmY4MTExMjFmYT5dIGRf
ZmxhZ3NfZm9yX2lub2RlKzB4NDgvMHhhOQpbICAgIDAuMDMwMDExXSAgWzxmZmZmZmZmZjgx
MTEyMjc4Pl0gX19kX2luc3RhbnRpYXRlKzB4MWQvMHhkZgpbICAgIDAuMDMxMjc0XSAgWzxm
ZmZmZmZmZjgxMTE0MGI4Pl0gZF9pbnN0YW50aWF0ZSsweDM1LzB4NGIKWyAgICAwLjAzMjUx
NV0gIFs8ZmZmZmZmZmY4MTExNDFkZj5dIGRfbWFrZV9yb290KzB4MzIvMHg0OQpbICAgIDAu
MDMzMzQ3XSAgWzxmZmZmZmZmZjgxMTUxZjdiPl0gc3lzZnNfbW91bnQrMHgxNjIvMHgxZGIK
WyAgICAwLjAzNDU1NV0gIFs8ZmZmZmZmZmY4MTEwNDgwNz5dIG1vdW50X2ZzKzB4MTAvMHhh
YwpbICAgIDAuMDM1NjkxXSAgWzxmZmZmZmZmZjgxMTFhOTEyPl0gdmZzX2tlcm5fbW91bnQr
MHg1Zi8weGYzClsgICAgMC4wMzY2NzhdICBbPGZmZmZmZmZmODExMWNjODY+XSBrZXJuX21v
dW50X2RhdGErMHgxNC8weDI5ClsgICAgMC4wMzc5NTJdICBbPGZmZmZmZmZmODI1OWRhYjg+
XSBzeXNmc19pbml0KzB4NTQvMHhiMwpbICAgIDAuMDQwMDExXSAgWzxmZmZmZmZmZjgyNTlj
M2RkPl0gbW50X2luaXQrMHhjYi8weDFjNwpbICAgIDAuMDQxMTU3XSAgWzxmZmZmZmZmZjgy
NTljMGEyPl0gdmZzX2NhY2hlc19pbml0KzB4OTAvMHgxMDcKWyAgICAwLjA0MjQzNl0gIFs8
ZmZmZmZmZmY4MTBlM2I3OD5dID8ga21lbV9jYWNoZV9jcmVhdGUrMHgyMy8weDI1ClsgICAg
MC4wNDMzNDZdICBbPGZmZmZmZmZmODI1N2ZkNTU+XSBzdGFydF9rZXJuZWwrMHg0MzEvMHg0
ODIKWyAgICAwLjA0NDU5MV0gIFs8ZmZmZmZmZmY4MjU3ZjczMj5dID8gcmVwYWlyX2Vudl9z
dHJpbmcrMHg1OC8weDU4ClsgICAgMC4wNDY2NzldICBbPGZmZmZmZmZmODI1N2YxMjA+XSA/
IGVhcmx5X2lkdF9oYW5kbGVycysweDEyMC8weDEyMApbICAgIDAuMDQ4MDgwXSAgWzxmZmZm
ZmZmZjgyNTdmNDRjPl0geDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysweDJhLzB4MmMKWyAg
ICAwLjA0OTUxOF0gIFs8ZmZmZmZmZmY4MjU3ZjUyYT5dIHg4Nl82NF9zdGFydF9rZXJuZWwr
MHhkYy8weGU5CgpFbGFwc2VkIHRpbWU6IDUKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3Zt
NjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgwLTEx
MDYvMTI0N2M3NGI0ZjNmMzcyNWE4YmQ4ZGMwYmJkMjJiYWEyYTkwNDlhZS92bWxpbnV6LTMu
MTIuMC1yYzQtMDAwNjktZzEyNDdjNzQgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgcmN1
dHJlZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIGxvZ19idWZfbGVuPThNIGlnbm9yZV9s
b2dsZXZlbCBkZWJ1ZyBzY2hlZF9kZWJ1ZyBhcGljPWRlYnVnIGR5bmFtaWNfcHJpbnRrIHN5
c3JxX2Fsd2F5c19lbmFibGVkIHBhbmljPTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9
dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBy
dyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14
MC0xMTA2L2xpbnV4LWRldmVsOmRldmVsLXhpYW4teDg2XzY0LTIwMTMxMTA3MDUxNDoxMjQ3
Yzc0YjRmM2YzNzI1YThiZDhkYzBiYmQyMmJhYTJhOTA0OWFlOmJpc2VjdC1uZXQvLnZtbGlu
dXotMTI0N2M3NGI0ZjNmMzcyNWE4YmQ4ZGMwYmJkMjJiYWEyYTkwNDlhZS0yMDEzMTEwNzEx
NDc0NS03LXNuYiBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwteGlhbi14ODZfNjQtMjAxMzEx
MDcwNTE0IEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2LzEy
NDdjNzRiNGYzZjM3MjVhOGJkOGRjMGJiZDIyYmFhMmE5MDQ5YWUvdm1saW51ei0zLjEyLjAt
cmM0LTAwMDY5LWcxMjQ3Yzc0JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC95b2N0
by1taW5pbWFsLXg4Nl82NC5jZ3ogLW0gMjU2TSAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1v
ZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAt
d2F0Y2hkb2cgaTYzMDBlc2IgLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMC15b2N0
by1zbmItMjEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtW
TS9kaXNrMS15b2N0by1zbmItMjEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9
L2ZzL0xBQkVMPUtWTS9kaXNrMi15b2N0by1zbmItMjEsbWVkaWE9ZGlzayxpZj12aXJ0aW8g
LWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMy15b2N0by1zbmItMjEsbWVkaWE9ZGlz
ayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrNC15b2N0by1zbmIt
MjEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNr
NS15b2N0by1zbmItMjEsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLXBpZGZpbGUgL2Rldi9zaG0v
a2Jvb3QvcGlkLXlvY3RvLXNuYi0yMSAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2Vy
aWFsLXlvY3RvLXNuYi0yMSAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVs
bCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MC0xMTA2LzEyNDdjNzRiNGYzZjM3MjVh
OGJkOGRjMGJiZDIyYmFhMmE5MDQ5YWUvZG1lc2cteW9jdG8tc25iLTIxOjIwMTMxMTA3MTE0
ODU0Ong4Nl82NC1yYW5kY29uZmlnLXgwLTExMDY6My4xMi4wLXJjNC0wMDA2OS1nMTI0N2M3
NDo1NjYKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCjEyNDdjNzRiNGYzZjM3
MjVhOGJkOGRjMGJiZDIyYmFhMmE5MDQ5YWUgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29t
bWl0IDEyNDdjNzRiNGYzZjM3MjVhOGJkOGRjMGJiZDIyYmFhMmE5MDQ5YWUKQXV0aG9yOiBE
YXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpEYXRlOiAgIFRodSBTZXAgMTIg
MTk6MjI6NTMgMjAxMyArMDEwMAoKICAgIFZGUzogUHV0IGEgc21hbGwgdHlwZSBmaWVsZCBp
bnRvIHN0cnVjdCBkZW50cnk6OmRfZmxhZ3MKICAgIAogICAgUHV0IGEgdHlwZSBmaWVsZCBp
bnRvIHN0cnVjdCBkZW50cnk6OmRfZmxhZ3MgdG8gaW5kaWNhdGUgaWYgdGhlIGRlbnRyeSBp
cyBvbmUKICAgIG9mIHRoZSBmb2xsb3dpbmcgdHlwZXMgdGhhdCByZWxhdGUgcGFydGljdWxh
cmx5IHRvIHBhdGh3YWxrOgogICAgCiAgICAJTWlzcyAobmVnYXRpdmUgZGVudHJ5KQogICAg
CURpcmVjdG9yeQogICAgCSJBdXRvbW91bnQiIGRpcmVjdG9yeSAoZGVmZWN0aXZlIC0gbm8g
aV9vcC0+bG9va3VwKCkpCiAgICAJU3ltbGluawogICAgCU90aGVyIChyZWd1bGFyLCBzb2Nr
ZXQsIGZpZm8sIGRldmljZSkKICAgIAogICAgVGhlIHR5cGUgZmllbGQgaXMgc2V0IHRvIG9u
ZSBvZiB0aGUgZmlyc3QgZml2ZSB0eXBlcyBvbiBhIGRlbnRyeSBieSBjYWxscyB0bwogICAg
X19kX2luc3RhbnRpYXRlKCkgYW5kIGRfb2J0YWluX2FsaWFzKCkgZnJvbSBpbmZvcm1hdGlv
biBpbiB0aGUgaW5vZGUgKGlmIG9uZSBpcwogICAgZ2l2ZW4pLgogICAgCiAgICBUaGUgdHlw
ZSBpcyBjbGVhcmVkIGJ5IGRlbnRyeV91bmxpbmtfaW5vZGUoKSB3aGVuIGl0IHJlY29uc3Rp
dHV0ZXMgYW4gZXhpc3RpbmcKICAgIGRlbnRyeSBhcyBhIG5lZ2F0aXZlIGRlbnRyeS4KICAg
IAogICAgQWNjZXNzb3JzIHByb3ZpZGVkIGFyZToKICAgIAogICAgCWRfc2V0X3R5cGUoZGVu
dHJ5LCB0eXBlKQogICAgCWRfaXNfZGlyZWN0b3J5KGRlbnRyeSkKICAgIAlkX2lzX2F1dG9k
aXIoZGVudHJ5KQogICAgCWRfaXNfc3ltbGluayhkZW50cnkpCiAgICAJZF9pc19maWxlKGRl
bnRyeSkKICAgIAlkX2lzX25lZ2F0aXZlKGRlbnRyeSkKICAgIAlkX2lzX3Bvc2l0aXZlKGRl
bnRyeSkKICAgIAogICAgQSBidW5jaCBvZiBjaGVja3MgaW4gcGF0aG5hbWUgcmVzb2x1dGlv
biBzd2l0Y2hlZCB0byB0aG9zZS4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogRGF2aWQgSG93
ZWxscyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4KICAgIFNpZ25lZC1vZmYtYnk6IEFsIFZpcm8g
PHZpcm9AemVuaXYubGludXgub3JnLnVrPgoKOjA0MDAwMCAwNDAwMDAgMDA5ZjAyZTgxNWI5
YjU4YzE4OTM4NDY1MDMxNGFjMDc4ZDI1N2I5ZiBmYjEzZWQ3ZWEyZGI2Y2ZkYjU4YjgyMzgx
ZTE4MzNmOGVhYzAyZTllIE0JZnMKOjA0MDAwMCAwNDAwMDAgMmUxMGViMWFkMzlmNjliOGRk
Mzk2MjRiYjAwMDAxOTczM2U0ZGEyMCBlYzBlNTMyMzE0ZDYxZmNmNTllZDdmYTY5N2Y0NzY0
YWM3Nzg2M2I5IE0JaW5jbHVkZQpiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvbGludXgtZGV2
ZWw6ZGV2ZWwteGlhbi14ODZfNjQtMjAxMzExMDcwNTE0OjUwMjM1Y2Q5NzI3YzIwYjA5OTY3
YjVjMDYwMDI1ZWFjOWQwYzgwYmI6YmlzZWN0LW5ldAoKMjAxMy0xMS0wNy0xMTo0OToxOCA1
MDIzNWNkOTcyN2MyMGIwOTk2N2I1YzA2MDAyNWVhYzlkMGM4MGJiIHJldXNlIC9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWcteDAtMTEwNi81MDIzNWNkOTcyN2MyMGIwOTk2N2I1YzA2MDAy
NWVhYzlkMGM4MGJiL3ZtbGludXotMy4xMi4wLXJjNC0wMDA2OC1nNTAyMzVjZAoKMjAxMy0x
MS0wNy0xMTo0OToxOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMQkzCTQJNgk3CTguCTEw
LgkxMQkxMwkxNC4uLgkxNy4JMTkJMjAuCTIxCTI0LgkyNQkyNgkyNwkzMC4JMzMJMzguCTQw
CTQ3CTQ4CTUxCTU2CTU4CTU5CTYyLgk2My4JNjUJNzAuLgk3MQk3Mgk3NAk3NQk3Ni4uCTc5
Lgk4MAk4Mgk4My4JODkJOTAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgwLTExMDYvbGludXgtZGV2ZWw6ZGV2ZWwteGlh
bi14ODZfNjQtMjAxMzExMDcwNTE0OjQ0YTQwZmQyMWZjZjA0ZWQyNDM5NjY1N2UzODFkYTFi
NzQxMjU5MGY6YmlzZWN0LW5ldAogVEVTVCBGQUlMVVJFCkJVRzoga2VybmVsIGVhcmx5IGhh
bmcgd2l0aG91dCBhbnkgcHJpbnRrIG91dHB1dApDb21tYW5kIGxpbmU6IGh1bmdfdGFza19w
YW5pYz0xIHJjdXRyZWUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBsb2dfYnVmX2xlbj04
TSBpZ25vcmVfbG9nbGV2ZWwgZGVidWcgc2NoZWRfZGVidWcgYXBpYz1kZWJ1ZyBkeW5hbWlj
X3ByaW50ayBzeXNycV9hbHdheXNfZW5hYmxlZCBwYW5pYz0xMCAgcHJvbXB0X3JhbWRpc2s9
MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0v
ZGV2L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWcteDAtMTEwNi9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEw
NzA1MTQ6NDRhNDBmZDIxZmNmMDRlZDI0Mzk2NjU3ZTM4MWRhMWI3NDEyNTkwZjpiaXNlY3Qt
bmV0Ly52bWxpbnV6LTQ0YTQwZmQyMWZjZjA0ZWQyNDM5NjY1N2UzODFkYTFiNzQxMjU5MGYt
MjAxMzExMDcwODE2MzgtOS1hbnQgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLXhpYW4teDg2
XzY0LTIwMTMxMTA3MDUxNCBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
eDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1OTBmL3ZtbGlu
dXotMy4xMi4wLTAwNzc1LWc0NGE0MGZkIG5vYXBpYyBub2xhcGljIG5vaHo9b2ZmCkVhcmx5
IGhhbmcga2VybmVsOiB2bWxpbnV6LTMuMTIuMC0wMDc3NS1nNDRhNDBmZCAzLjEyLjAtMDA3
NzUtZzQ0YTQwZmQgIzkKRWxhcHNlZCB0aW1lOiAzNQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXgwLTExMDYvNDRhNDBmZDIxZmNmMDRlZDI0Mzk2NjU3ZTM4MWRhMWI3NDEyNTkwZi9k
bWVzZy1xdWFudGFsLXdhaW1lYS03OjIwMTMxMTA3MTYxODE2Ong4Nl82NC1yYW5kY29uZmln
LXgwLTExMDY6My4xMi4wLTAwNzc1LWc0NGE0MGZkOjkKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy14MC0xMTA2LzQ0YTQwZmQyMWZjZjA0ZWQyNDM5NjY1N2UzODFkYTFiNzQxMjU5MGYv
ZG1lc2ctcXVhbnRhbC1pbm4tMToyMDEzMTEwNzA2MDE0OTp4ODZfNjQtcmFuZGNvbmZpZy14
MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1OTBmL2Rt
ZXNnLXF1YW50YWwtc3RvYWtsZXktNjoyMDEzMTEwNzA2MDIwMzp4ODZfNjQtcmFuZGNvbmZp
Zy14MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1OTBm
L2RtZXNnLXF1YW50YWwteHBzLTU6MjAxMzExMDcxNDEyMzA6eDg2XzY0LXJhbmRjb25maWct
eDAtMTEwNjozLjEyLjAtMDA3NzUtZzQ0YTQwZmQ6OQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXgwLTExMDYvNDRhNDBmZDIxZmNmMDRlZDI0Mzk2NjU3ZTM4MWRhMWI3NDEyNTkwZi9k
bWVzZy15b2N0by1jYWlyby0zMToyMDEzMTEwNzA4MjMzODp4ODZfNjQtcmFuZGNvbmZpZy14
MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1OTBmL2Rt
ZXNnLXlvY3RvLWF0aGVucy0xOToyMDEzMTEwNzA4MTc1Njp4ODZfNjQtcmFuZGNvbmZpZy14
MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1OTBmL2Rt
ZXNnLXlvY3RvLWF0aGVucy0yNjoyMDEzMTEwNzA1NDA0Nzp4ODZfNjQtcmFuZGNvbmZpZy14
MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1OTBmL2Rt
ZXNnLXF1YW50YWwteHBzLTU6MjAxMzExMDcxNDA4MTA6eDg2XzY0LXJhbmRjb25maWcteDAt
MTEwNjozLjEyLjAtMDA3NzUtZzQ0YTQwZmQ6OQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXgwLTExMDYvNDRhNDBmZDIxZmNmMDRlZDI0Mzk2NjU3ZTM4MWRhMWI3NDEyNTkwZi9kbWVz
Zy15b2N0by1sa3AtdHQwMi03OjIwMTMxMTA2MjA0NTI5Ong4Nl82NC1yYW5kY29uZmlnLXgw
LTExMDY6My4xMi4wLTAwNzc1LWc0NGE0MGZkOjkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MC0xMTA2LzQ0YTQwZmQyMWZjZjA0ZWQyNDM5NjY1N2UzODFkYTFiNzQxMjU5MGYvZG1l
c2ctcXVhbnRhbC1sa3AtdHQwMi0yMDoyMDEzMTEwNjIwMzY0OTp4ODZfNjQtcmFuZGNvbmZp
Zy14MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1OTBm
L2RtZXNnLXF1YW50YWwtaW5uLTQ2OjIwMTMxMTA3MDg1NjQyOng4Nl82NC1yYW5kY29uZmln
LXgwLTExMDY6My4xMi4wLTAwNzc1LWc0NGE0MGZkOjkKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy14MC0xMTA2LzQ0YTQwZmQyMWZjZjA0ZWQyNDM5NjY1N2UzODFkYTFiNzQxMjU5MGYv
ZG1lc2cteW9jdG8tbGtwLXR0MDItMTE6MjAxMzExMDYyMzQ3MjI6eDg2XzY0LXJhbmRjb25m
aWcteDAtMTEwNjozLjEyLjAtMDA3NzUtZzQ0YTQwZmQ6OQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXgwLTExMDYvNDRhNDBmZDIxZmNmMDRlZDI0Mzk2NjU3ZTM4MWRhMWI3NDEyNTkw
Zi9kbWVzZy1xdWFudGFsLXdhaW1lYS04OjIwMTMxMTA3MTM1ODUyOng4Nl82NC1yYW5kY29u
ZmlnLXgwLTExMDY6My4xMi4wLTAwNzc1LWc0NGE0MGZkOjkKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy14MC0xMTA2LzQ0YTQwZmQyMWZjZjA0ZWQyNDM5NjY1N2UzODFkYTFiNzQxMjU5
MGYvZG1lc2ctcXVhbnRhbC1yb2FtLTM2OjIwMTMxMTA3MDgyMzAzOng4Nl82NC1yYW5kY29u
ZmlnLXgwLTExMDY6My4xMi4wLTAwNzc1LWc0NGE0MGZkOjkKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy14MC0xMTA2LzQ0YTQwZmQyMWZjZjA0ZWQyNDM5NjY1N2UzODFkYTFiNzQxMjU5
MGYvZG1lc2cteW9jdG8teGlhbi00OjIwMTMxMTA3MDg0MTA3Ong4Nl82NC1yYW5kY29uZmln
LXgwLTExMDY6My4xMi4wLTAwNzc1LWc0NGE0MGZkOjkKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy14MC0xMTA2LzQ0YTQwZmQyMWZjZjA0ZWQyNDM5NjY1N2UzODFkYTFiNzQxMjU5MGYv
ZG1lc2cteW9jdG8tc3RvYWtsZXktNDoyMDEzMTEwNzA4MzI1Njp4ODZfNjQtcmFuZGNvbmZp
Zy14MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWcteDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1OTBm
L2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNToyMDEzMTEwNzA4MTk0Nzp4ODZfNjQtcmFuZGNv
bmZpZy14MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWcteDAtMTEwNi80NGE0MGZkMjFmY2YwNGVkMjQzOTY2NTdlMzgxZGExYjc0MTI1
OTBmL2RtZXNnLXlvY3RvLXNuYi0yMDoyMDEzMTEwNzA2MjEyNTp4ODZfNjQtcmFuZGNvbmZp
Zy14MC0xMTA2OjMuMTIuMC0wMDc3NS1nNDRhNDBmZDo5CjA6MTg6MTkgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBIRUFEIDg0MGRjOTldIFJldmVydCAiVkZTOiBQ
dXQgYSBzbWFsbCB0eXBlIGZpZWxkIGludG8gc3RydWN0IGRlbnRyeTo6ZF9mbGFncyIKIDMg
ZmlsZXMgY2hhbmdlZCwgODIgaW5zZXJ0aW9ucygrKSwgMTY0IGRlbGV0aW9ucygtKQpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDAtMTEw
Ni9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwNzA1MTQ6ODQwZGM5OTYy
Y2RjYTYwN2MzYjEyMWZlODc4NDg2NmVjZjE2OWI2NDpiaXNlY3QtbmV0CgoyMDEzLTExLTA3
LTEyOjIxOjI1IDg0MGRjOTk2MmNkY2E2MDdjM2IxMjFmZTg3ODQ4NjZlY2YxNjliNjQgY29t
cGlsaW5nCgoyMDEzLTExLTA3LTEyOjI1OjQ3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIu
MC0wMDc3Ni1nODQwZGM5OS4JMS4JMwk3CTgJMTEJMTIJMTMuCTE1CTE3LgkxOAkxOS4JMjAJ
MjEJMjMJMjQuLgkyNi4JMjcJMjkJMzIJMzQJMzUJMzgJMzkJNDAuCTQxLi4uLgk0NQk0Ny4J
NTEJNTUuLi4JNTkuLi4JNjQJNjUJNjYJNjkJNzEJNzQJNzUJNzYJNzcJNzgJODAJODIuLgk4
NQk4OAk5MCBTVUNDRVNTCgoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpGZXRjaGlu
ZyBsaW51cwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWcteDAtMTEwNi9saW51eC1kZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwNzA1
MTQ6YmU0MDhjZDNlMWZlZjczZTk0MDhiMTk2YTc5Yjk5MzQ2OTdmZTNiMTpiaXNlY3QtbmV0
CgoyMDEzLTExLTA3LTEyOjU5OjIyIGJlNDA4Y2QzZTFmZWY3M2U5NDA4YjE5NmE3OWI5OTM0
Njk3ZmUzYjEgY29tcGlsaW5nCgoyMDEzLTExLTA3LTEzOjAzOjQzIGRldGVjdGluZyBib290
IHN0YXRlIDMuMTIuMC0wMDA0OC1nYmU0MDhjZC4uLgkzCTYJOAkxMwkxNAkxOQkyNC4JMjcu
CTMwCTM0CTQzLi4uCTUwCTYwCTY1CTcxCTc2CTc5CTgyCTg5CTkwIFNVQ0NFU1MKCgo9PT09
PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDAtMTEwNi9saW51eC1k
ZXZlbDpkZXZlbC14aWFuLXg4Nl82NC0yMDEzMTEwNzA1MTQ6N2U4MmVhNDIyYzQyZGI2Yjlj
MDE4OGZhZWI5OGQ2ZWM5Y2NmZWY4ZjpiaXNlY3QtbmV0CgoyMDEzLTExLTA3LTEzOjE4OjIx
IDdlODJlYTQyMmM0MmRiNmI5YzAxODhmYWViOThkNmVjOWNjZmVmOGYgY29tcGlsaW5nCgoy
MDEzLTExLTA3LTEzOjI0OjE4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1uZXh0LTIw
MTMxMTA2LTEwMTc1LWc3ZTgyZWE0Lgk2CTEzCTI1CTQ1CTY5CTgwCTg0CTg3CTkwIFNVQ0NF
U1MKCg==

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-00775-g44a40fd"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
# CONFIG_ACPI_APEI_EINJ is not set
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
CONFIG_CAN_MCP251X=y
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_PCH_CAN=y
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
CONFIG_CAN_C_CAN_PCI=y
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
CONFIG_CAN_CC770_PLATFORM=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
# CONFIG_BT_WILINK is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_NCI_SPI is not set
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_WILINK is not set
CONFIG_NFC_SIM=y
CONFIG_NFC_PN544=y
CONFIG_NFC_MICROREAD=y
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
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
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
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
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECS=y
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=y
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_SX4=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_MPIIX=y
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=y
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
# CONFIG_MD_RAID1 is not set
CONFIG_MD_RAID10=y
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CACHE=y
# CONFIG_DM_CACHE_MQ is not set
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
CONFIG_DM_LOG_USERSPACE=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
CONFIG_DM_SWITCH=y
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
# CONFIG_CAIF_SPI_SLAVE is not set
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_NET_VENDOR_ALTEON is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ARC=y
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
# CONFIG_KS8851 is not set
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_ENC28J60=y
# CONFIG_ENC28J60_WRITEVERIFY is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_SH_ETH is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MICREL_KS8995MA=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
CONFIG_IEEE802154_FAKELB=y
CONFIG_IEEE802154_AT86RF230=y
CONFIG_IEEE802154_MRF24J40=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set
# CONFIG_ISDN_X25 is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DRV_LOOP=y
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
# CONFIG_HISAX_NO_LLC is not set
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_3 is not set
# CONFIG_HISAX_TELESPCI is not set
CONFIG_HISAX_S0BOX=y
# CONFIG_HISAX_FRITZPCI is not set
# CONFIG_HISAX_AVM_A1_PCMCIA is not set
# CONFIG_HISAX_ELSA is not set
# CONFIG_HISAX_DIEHLDIVA is not set
# CONFIG_HISAX_SEDLBAUER is not set
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
# CONFIG_HISAX_BKM_A4T is not set
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
# CONFIG_HISAX_HFC_PCI is not set
CONFIG_HISAX_W6692=y
# CONFIG_HISAX_HFC_SX is not set
# CONFIG_HISAX_ENTERNOW_PCI is not set
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_AVM_A1_CS=y

#
# HiSax sub driver modules
#
CONFIG_HISAX_HFC4S8S=y
CONFIG_HISAX_FRITZ_PCIPNP=y

#
# Active cards
#
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
CONFIG_MISDN_L1OIP=y

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
CONFIG_MISDN_AVMFRITZ=y
CONFIG_MISDN_SPEEDFAX=y
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
CONFIG_MISDN_NETJET=y
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y
CONFIG_ISDN_HDLC=y

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
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TWL4030=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_PCAP is not set
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MRST_MAX3110=y
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_ST_ASC=y
CONFIG_SERIAL_ST_ASC_CONSOLE=y
CONFIG_TTY_PRINTK=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
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
CONFIG_SPI_ATMEL=y
# CONFIG_SPI_BCM2835 is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_EP93XX=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_IMX=y
# CONFIG_SPI_FSL_DSPI is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_OMAP24XX=y
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_TEGRA114=y
# CONFIG_SPI_TEGRA20_SFLASH is not set
CONFIG_SPI_TEGRA20_SLINK=y
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_TXX9 is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
CONFIG_SPI_DW_MID_DMA=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

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
# CONFIG_GPIO_JANZ_TTL is not set
# CONFIG_GPIO_TPS6586X is not set
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_BATTERY_TWL4030_MADC=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_MFD_CROS_EC_SPI=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77686=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_V4L2_INT_DEVICE=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_I2C_SI470X=y
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_TIMBERDALE=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=y
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
CONFIG_VIDEO_TCM825X=y
CONFIG_VIDEO_SR030PC30=y

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
# CONFIG_MEDIA_TUNER_TDA9887 is not set
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=y
# CONFIG_MEDIA_TUNER_MT2063 is not set
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
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
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_PANDORA=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_AT73C213=y
CONFIG_SND_AT73C213_TARGET_BITRATE=48000
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=y
# CONFIG_INFINIBAND_QIB is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_MLX5_INFINIBAND=y
CONFIG_INFINIBAND_OCRDMA=y
CONFIG_INFINIBAND_SRP=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=y
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WMI=y
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
# CONFIG_IDEAPAD_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
CONFIG_ASUS_NB_WMI=y
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_ACPI_TOSHIBA=y
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
# CONFIG_EFI_VARS_PSTORE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
# CONFIG_IOMMU_LEAK is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
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
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_UCS2_STRING=y

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--2oS5YaxWCcQjTEyO--
