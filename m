Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3KGMNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:13:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:36492 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3KGMN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:13:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,651,1378882800"; 
   d="log'?scan'208";a="423716790"
Date: Thu, 7 Nov 2013 20:13:16 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [vfs] [ INFO: possible recursive locking detected ]
Message-ID: <20131107121316.GC10868@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <20131107121042.GB10868@localhost>
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

David,

Here is another bisect result.

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
9 /kernel/x86_64-randconfig-c9-1107/50235cd9727c20b09967b5c060025eac9d0c80bb

create /kernel/x86_64-randconfig-c9-1107/50235cd9727c20b09967b5c060025eac9d0c80bb/boot-error-ids
update /kernel/x86_64-randconfig-c9-1107/f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c/boot-error-ids
+-------------------------------------------------+--------------+--------------+
|                                                 | 50235cd9727c | f0e07fb6dd3d |
+-------------------------------------------------+--------------+--------------+
| good_boots                                      | 131          |              |
| has_kernel_error_warning                        | 9            | 19           |
| BUG:kernel_early_hang_without_any_printk_output | 9            |              |
| INFO:possible_recursive_locking_detected        | 0            | 19           |
| BUG:spinlock_lockup_suspected_on_CPU            | 0            | 19           |
+-------------------------------------------------+--------------+--------------+

[    0.020984] Mount-cache hash table entries: 256
[    0.022182] 
[    0.022487] =============================================
[    0.026992] [ INFO: possible recursive locking detected ]
[    0.027977] 3.12.0-00784-gf0e07fb #314 Not tainted
[    0.028845] ---------------------------------------------
[    0.030000] swapper/0 is trying to acquire lock:
[    0.030000]  (&sb->s_type->i_lock_key){+.+...}, at: [<ffffffff811bdb4c>] d_flags_for_inode+0x3c/0xd0
[    0.030000] 
[    0.030000] but task is already holding lock:
[    0.030000]  (&sb->s_type->i_lock_key){+.+...}, at: [<ffffffff811c04c4>] d_instantiate+0x34/0x70
[    0.030000] 
[    0.030000] other info that might help us debug this:
[    0.030000]  Possible unsafe locking scenario:
[    0.030000] 
[    0.030000]        CPU0
[    0.030000]        ----
[    0.030000]   lock(&sb->s_type->i_lock_key);
[    0.030000]   lock(&sb->s_type->i_lock_key);
[    0.030000] 
[    0.030000]  *** DEADLOCK ***
[    0.030000] 
[    0.030000]  May be due to missing lock nesting notation
[    0.030000] 
[    0.030000] 2 locks held by swapper/0:
[    0.030000]  #0:  (&type->s_umount_key/1){+.+...}, at: [<ffffffff811ab286>] sget+0x266/0x440
[    0.030000]  #1:  (&sb->s_type->i_lock_key){+.+...}, at: [<ffffffff811c04c4>] d_instantiate+0x34/0x70
[    0.030000] 
[    0.030000] stack backtrace:
[    0.030000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-00784-gf0e07fb #314
[    0.030000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.030000]  ffffffff82c998d0 ffffffff82401c18 ffffffff81c21540 ffffffff82401ce0
[    0.030000]  ffffffff81111fb7 ffffffff824134c0 0000000000000000 ffffffff82401c50
[    0.030000]  ffffffff82413af8 ffffffff00000000 00000000c406e037 ffffffff824134c0
[    0.030000] Call Trace:
[    0.030000]  [<ffffffff81c21540>] dump_stack+0x19/0x1b
[    0.030000]  [<ffffffff81111fb7>] __lock_acquire+0x12d7/0x1d60
[    0.030000]  [<ffffffff811129cc>] ? __lock_acquire+0x1cec/0x1d60
[    0.030000]  [<ffffffff81c2102f>] ? __slab_alloc.constprop.61+0x3dc/0x3fa
[    0.030000]  [<ffffffff8111394d>] lock_acquire+0x19d/0x220
[    0.030000]  [<ffffffff811bdb4c>] ? d_flags_for_inode+0x3c/0xd0
[    0.030000]  [<ffffffff81c34ccb>] _raw_spin_lock+0x3b/0x70
[    0.030000]  [<ffffffff811bdb4c>] ? d_flags_for_inode+0x3c/0xd0
[    0.030000]  [<ffffffff811bdb4c>] d_flags_for_inode+0x3c/0xd0
[    0.030000]  [<ffffffff811be44d>] __d_instantiate+0x1d/0xf0
[    0.030000]  [<ffffffff811c04cf>] d_instantiate+0x3f/0x70
[    0.030000]  [<ffffffff811c0662>] d_make_root+0x32/0x60
[    0.030000]  [<ffffffff811f3fe8>] sysfs_mount+0x178/0x220
[    0.030000]  [<ffffffff811ac0a3>] mount_fs+0x73/0x190
[    0.030000]  [<ffffffff811c98e5>] vfs_kern_mount+0x65/0xf0
[    0.030000]  [<ffffffff811cc4b4>] kern_mount_data+0x14/0x30
[    0.030000]  [<ffffffff827a9db2>] sysfs_init+0x54/0xb3
[    0.030000]  [<ffffffff827a8488>] mnt_init+0xcd/0x1d6
[    0.030000]  [<ffffffff827a8156>] vfs_caches_init+0x90/0x10e
[    0.030000]  [<ffffffff827abf74>] ? integrity_iintcache_init+0x23/0x38
[    0.030000]  [<ffffffff827aafe9>] ? security_init+0x35/0x47
[    0.030000]  [<ffffffff82784e98>] start_kernel+0x456/0x49e
[    0.030000]  [<ffffffff8278484a>] ? repair_env_string+0x5e/0x5e
[    0.030000]  [<ffffffff82784120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff82784543>] x86_64_start_reservations+0x2a/0x2c
[    0.030000]  [<ffffffff82784638>] x86_64_start_kernel+0xf3/0x102

git bisect start f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 --
git bisect good 2751f2b0a96446b2301a56dcf3b24128ffb4c7d7  # 09:25     20+      0  Merge 'ntb/ntb' into devel-cairo-x86_64-201311070512
git bisect good 4796e8af60ee7d2922386ef9fd4389d21e2c1665  # 10:26     20+      4  Bluetooth: Make mgmt_write_scan_failed() return void
git bisect good cca34b785a21d220176038c45071ffe842e99fd3  # 10:52     20+      2  Bluetooth: Remove link type check in hci_disconn_complete_evt()
git bisect good 004e8957280a32f7b54766531c064412bda45e48  # 11:36     20+      2  convert the rest of binfmt_elf_fdpic to dump_emit()
git bisect  bad b0d94facd7c81fae48e72f1e0b2a7e656ecde921  # 11:44      0-      2  exportfs: stop retrying once we race with rename/remove
git bisect good 50235cd9727c20b09967b5c060025eac9d0c80bb  # 12:05     20+      2  elf{,_fdpic} coredump: get rid of pointless if (siginfo->si_signo)
git bisect  bad 08196969532eee10cdeaa29fca37fa7a407b01ae  # 12:11      0-      1  dcache: use IS_ROOT to decide where dentry is hashed
git bisect  bad 7717bf21e4a5e1d371e313a4404635f4775961d9  # 12:16      1-      2  vfs: split out vfs_getattr_nosec
git bisect  bad 520ef078eabdbe7eb6a33c1f56a65ac55d41e6ed  # 12:24      2-      3  iget/iget5: don't bother with ->i_lock until we find a match
git bisect  bad 1247c74b4f3f3725a8bd8dc0bbd22baa2a9049ae  # 12:29      0-      4  VFS: Put a small type field into struct dentry::d_flags
git bisect good 50235cd9727c20b09967b5c060025eac9d0c80bb  # 13:06    120+      9  elf{,_fdpic} coredump: get rid of pointless if (siginfo->si_signo)
git bisect  bad f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c  # 13:06      0-     19  Merge 'vfs/for-next' into devel-cairo-x86_64-201311070512
git bisect good e6eb46b3eee2c7211a56423dd026b88b9ce30ed5  # 13:21    120+      9  Revert "VFS: Put a small type field into struct dentry::d_flags"
git bisect good be408cd3e1fef73e9408b196a79b9934697fe3b1  # 13:33    120+      3  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net

Thanks,
Fengguang

--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-bens-2:20131107062028:x86_64-randconfig-c9-1107:3.12.0-00784-gf0e07fb:314"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.12.0-00784-gf0e07fb (kbuild@cairo) (gcc vers=
ion 4.8.1 (Debian 4.8.1-8) ) #314 PREEMPT Thu Nov 7 05:52:48 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c9-1107/devel-cairo-x86_64-20131=
1070512/.vmlinuz-f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c-20131107055743-8-=
bens branch=3Dlinux-devel/devel-cairo-x86_64-201311070512 BOOT_IMAGE=3D/ker=
nel/x86_64-randconfig-c9-1107/f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c/vmli=
nuz-3.12.0-00784-gf0e07fb
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0334e000, 0x0334efff] PGTABLE
[    0.000000] BRK [0x0334f000, 0x0334ffff] PGTABLE
[    0.000000] BRK [0x03350000, 0x03350fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x03351000, 0x03351fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127596(97%)
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
[    0.000000] kvm-stealtime: cpu 0, msr 2433e00
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
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c9-1107/devel-cairo-x86_64=
-201311070512/.vmlinuz-f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c-20131107055=
743-8-bens branch=3Dlinux-devel/devel-cairo-x86_64-201311070512 BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c9-1107/f0e07fb6dd3d533b6ea2d91e721b68d696d4e6=
4c/vmlinuz-3.12.0-00784-gf0e07fb
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 188740K/261744K available (12518K kernel code, 3593K=
 rwdata, 5128K rodata, 1056K init, 11012K bss, 73004K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 9 of 9 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.772 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5333.54 Bogo=
MIPS (lpj=3D26667720)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020157] Security Framework initialized
[    0.020984] Mount-cache hash table entries: 256
[    0.022182]=20
[    0.022487] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.026992] [ INFO: possible recursive locking detected ]
[    0.027977] 3.12.0-00784-gf0e07fb #314 Not tainted
[    0.028845] ---------------------------------------------
[    0.030000] swapper/0 is trying to acquire lock:
[    0.030000]  (&sb->s_type->i_lock_key){+.+...}, at: [<ffffffff811bdb4c>]=
 d_flags_for_inode+0x3c/0xd0
[    0.030000]=20
[    0.030000] but task is already holding lock:
[    0.030000]  (&sb->s_type->i_lock_key){+.+...}, at: [<ffffffff811c04c4>]=
 d_instantiate+0x34/0x70
[    0.030000]=20
[    0.030000] other info that might help us debug this:
[    0.030000]  Possible unsafe locking scenario:
[    0.030000]=20
[    0.030000]        CPU0
[    0.030000]        ----
[    0.030000]   lock(&sb->s_type->i_lock_key);
[    0.030000]   lock(&sb->s_type->i_lock_key);
[    0.030000]=20
[    0.030000]  *** DEADLOCK ***
[    0.030000]=20
[    0.030000]  May be due to missing lock nesting notation
[    0.030000]=20
[    0.030000] 2 locks held by swapper/0:
[    0.030000]  #0:  (&type->s_umount_key/1){+.+...}, at: [<ffffffff811ab28=
6>] sget+0x266/0x440
[    0.030000]  #1:  (&sb->s_type->i_lock_key){+.+...}, at: [<ffffffff811c0=
4c4>] d_instantiate+0x34/0x70
[    0.030000]=20
[    0.030000] stack backtrace:
[    0.030000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-00784-gf0e07f=
b #314
[    0.030000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.030000]  ffffffff82c998d0 ffffffff82401c18 ffffffff81c21540 ffffffff=
82401ce0
[    0.030000]  ffffffff81111fb7 ffffffff824134c0 0000000000000000 ffffffff=
82401c50
[    0.030000]  ffffffff82413af8 ffffffff00000000 00000000c406e037 ffffffff=
824134c0
[    0.030000] Call Trace:
[    0.030000]  [<ffffffff81c21540>] dump_stack+0x19/0x1b
[    0.030000]  [<ffffffff81111fb7>] __lock_acquire+0x12d7/0x1d60
[    0.030000]  [<ffffffff811129cc>] ? __lock_acquire+0x1cec/0x1d60
[    0.030000]  [<ffffffff81c2102f>] ? __slab_alloc.constprop.61+0x3dc/0x3fa
[    0.030000]  [<ffffffff8111394d>] lock_acquire+0x19d/0x220
[    0.030000]  [<ffffffff811bdb4c>] ? d_flags_for_inode+0x3c/0xd0
[    0.030000]  [<ffffffff81c34ccb>] _raw_spin_lock+0x3b/0x70
[    0.030000]  [<ffffffff811bdb4c>] ? d_flags_for_inode+0x3c/0xd0
[    0.030000]  [<ffffffff811bdb4c>] d_flags_for_inode+0x3c/0xd0
[    0.030000]  [<ffffffff811be44d>] __d_instantiate+0x1d/0xf0
[    0.030000]  [<ffffffff811c04cf>] d_instantiate+0x3f/0x70
[    0.030000]  [<ffffffff811c0662>] d_make_root+0x32/0x60
[    0.030000]  [<ffffffff811f3fe8>] sysfs_mount+0x178/0x220
[    0.030000]  [<ffffffff811ac0a3>] mount_fs+0x73/0x190
[    0.030000]  [<ffffffff811c98e5>] vfs_kern_mount+0x65/0xf0
[    0.030000]  [<ffffffff811cc4b4>] kern_mount_data+0x14/0x30
[    0.030000]  [<ffffffff827a9db2>] sysfs_init+0x54/0xb3
[    0.030000]  [<ffffffff827a8488>] mnt_init+0xcd/0x1d6
[    0.030000]  [<ffffffff827a8156>] vfs_caches_init+0x90/0x10e
[    0.030000]  [<ffffffff827abf74>] ? integrity_iintcache_init+0x23/0x38
[    0.030000]  [<ffffffff827aafe9>] ? security_init+0x35/0x47
[    0.030000]  [<ffffffff82784e98>] start_kernel+0x456/0x49e
[    0.030000]  [<ffffffff8278484a>] ? repair_env_string+0x5e/0x5e
[    0.030000]  [<ffffffff82784120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff82784543>] x86_64_start_reservations+0x2a/0x2c
[    0.030000]  [<ffffffff82784638>] x86_64_start_kernel+0xf3/0x102
[  298.715031] BUG: spinlock lockup suspected on CPU#0, swapper/0
[  298.716133]  lock: 0xffff88000dc02078, .magic: dead4ead, .owner: swapper=
/0, .owner_cpu: 0
[  298.717583] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-00784-gf0e07f=
b #314
[  298.718850] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  298.719900]  ffff88000dc02078 ffffffff82401d00 ffffffff81c21540 ffffffff=
82401d20
[  298.720912]  ffffffff81c215c7 ffff88000dc02078 000000009ef3b620 ffffffff=
82401d48
[  298.722347]  ffffffff812bf668 ffff88000dc02078 ffff88000dc02090 ffff8800=
0dc04058
[  298.723770] Call Trace:
[  298.724225]  [<ffffffff81c21540>] dump_stack+0x19/0x1b
[  298.725130]  [<ffffffff81c215c7>] spin_dump+0x85/0x8a
[  298.726090]  [<ffffffff812bf668>] do_raw_spin_lock+0x88/0xf0
[  298.727080]  [<ffffffff81c34ceb>] _raw_spin_lock+0x5b/0x70
[  298.728081]  [<ffffffff811bdb4c>] ? d_flags_for_inode+0x3c/0xd0
[  298.729158]  [<ffffffff811bdb4c>] d_flags_for_inode+0x3c/0xd0
[  298.730008]  [<ffffffff811be44d>] __d_instantiate+0x1d/0xf0
[  298.730986]  [<ffffffff811c04cf>] d_instantiate+0x3f/0x70
[  298.732013]  [<ffffffff811c0662>] d_make_root+0x32/0x60
[  298.732933]  [<ffffffff811f3fe8>] sysfs_mount+0x178/0x220
[  298.733886]  [<ffffffff811ac0a3>] mount_fs+0x73/0x190
[  298.734776]  [<ffffffff811c98e5>] vfs_kern_mount+0x65/0xf0
[  298.735818]  [<ffffffff811cc4b4>] kern_mount_data+0x14/0x30
[  298.736792]  [<ffffffff827a9db2>] sysfs_init+0x54/0xb3
[  298.737697]  [<ffffffff827a8488>] mnt_init+0xcd/0x1d6
[  298.738633]  [<ffffffff827a8156>] vfs_caches_init+0x90/0x10e
[  298.740010]  [<ffffffff827abf74>] ? integrity_iintcache_init+0x23/0x38
[  298.741160]  [<ffffffff827aafe9>] ? security_init+0x35/0x47
[  298.742181]  [<ffffffff82784e98>] start_kernel+0x456/0x49e
[  298.743149]  [<ffffffff8278484a>] ? repair_env_string+0x5e/0x5e
[  298.744223]  [<ffffffff82784120>] ? early_idt_handlers+0x120/0x120
[  298.745345]  [<ffffffff82784543>] x86_64_start_reservations+0x2a/0x2c
[  298.746471]  [<ffffffff82784638>] x86_64_start_kernel+0xf3/0x102

Elapsed time: 305
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-c9-1107/f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c/vmlinuz-3.12.0-00784-gf0e=
07fb -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_b=
uf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk s=
ysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-qu=
eue/kvm/x86_64-randconfig-c9-1107/devel-cairo-x86_64-201311070512/.vmlinuz-=
f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c-20131107055743-8-bens branch=3Dlin=
ux-devel/devel-cairo-x86_64-201311070512 BOOT_IMAGE=3D/kernel/x86_64-randco=
nfig-c9-1107/f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c/vmlinuz-3.12.0-00784-=
gf0e07fb'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 256M -sm=
p 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no=
-reboot -watchdog i6300esb -drive file=3D/fs/sda7/disk0-quantal-bens-2,medi=
a=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk1-quantal-bens-2,media=3Ddi=
sk,if=3Dvirtio -drive file=3D/fs/sda7/disk2-quantal-bens-2,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/sda7/disk3-quantal-bens-2,media=3Ddisk,if=3Dvir=
tio -drive file=3D/fs/sda7/disk4-quantal-bens-2,media=3Ddisk,if=3Dvirtio -d=
rive file=3D/fs/sda7/disk5-quantal-bens-2,media=3Ddisk,if=3Dvirtio -pidfile=
 /dev/shm/kboot/pid-quantal-bens-2 -serial file:/dev/shm/kboot/serial-quant=
al-bens-2 -daemonize -display none -monitor null=20

--LpQ9ahxlCli8rRTG
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-f0e07fb6dd3d533b6ea2d91e721b68d696d4e64c-x86_64-randconfig-c9-1107-INFO:-possible-recursive-locking-detected--91126.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZjBlMDdmYi4uLiBNZXJnZSAndmZzL2Zvci1u
ZXh0JyBpbnRvIGRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMTEwNzA1MTIKSEVBRCBpcyBub3cg
YXQgNWUwMWRjNy4uLiBMaW51eCAzLjEyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3L2xpbnV4LWRldmVsOmRldmVsLWNhaXJv
LXg4Nl82NC0yMDEzMTEwNzA1MTI6NWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2
YTVjZWI1MjpiaXNlY3QtdXNiCiBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDVlMDFk
YzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKZ2l0IGJpc2VjdCBzdGFydCBm
MGUwN2ZiNmRkM2Q1MzNiNmVhMmQ5MWU3MjFiNjhkNjk2ZDRlNjRjIDVlMDFkYzdiMjZkOWYy
NGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3
YXMgNWUwMWRjNy4uLiBMaW51eCAzLjEyCkhFQUQgaXMgbm93IGF0IDZlNDY2NDUuLi4gTGlu
dXggMy4xMQpCaXNlY3Rpbmc6IDQzNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgOSBzdGVwcykKWzI3NTFmMmIwYTk2NDQ2YjIzMDFhNTZkY2YzYjI0MTI4
ZmZiNGM3ZDddIE1lcmdlICdudGIvbnRiJyBpbnRvIGRldmVsLWNhaXJvLXg4Nl82NC0yMDEz
MTEwNzA1MTIKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctYzktMTEwNy9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzExMDcw
NTEyOjI3NTFmMmIwYTk2NDQ2YjIzMDFhNTZkY2YzYjI0MTI4ZmZiNGM3ZDc6YmlzZWN0LXVz
YgoKMjAxMy0xMS0wNy0wODoyMTowMSAyNzUxZjJiMGE5NjQ0NmIyMzAxYTU2ZGNmM2IyNDEy
OGZmYjRjN2Q3IGNvbXBpbGluZwozOTcgcmVhbCAgMTU5NSB1c2VyICAxNDcgc3lzICA0Mzku
MDQlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzktMTEwNwoKMjAxMy0xMS0wNy0wODozMzow
NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDAzNDctZzI3NTFmMmIuLi4uLi4uLi4u
Li4uLi4uLi4JMQkyLi4uCTMuLi4uLi4JNC4JNS4uLi4uLi4uLi4JNi4uLi4uLi4JNy4JOC4u
CTkuLi4uCTEwLi4JMTEuCTEyLi4uLi4uLi4uCTEzLi4uLgkxNC4uLgkxOC4uLi4uCTE5Li4u
Li4uLi4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMTggcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCls0Nzk2ZThhZjYwZWU3ZDI5MjIz
ODZlZjlmZDQzODlkMjFlMmMxNjY1XSBCbHVldG9vdGg6IE1ha2UgbWdtdF93cml0ZV9zY2Fu
X2ZhaWxlZCgpIHJldHVybiB2b2lkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvbGlu
dXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTA3MDUxMjo0Nzk2ZThhZjYwZWU3
ZDI5MjIzODZlZjlmZDQzODlkMjFlMmMxNjY1OmJpc2VjdC11c2IKCjIwMTMtMTEtMDctMDk6
MjU6MDkgNDc5NmU4YWY2MGVlN2QyOTIyMzg2ZWY5ZmQ0Mzg5ZDIxZTJjMTY2NSBjb21waWxp
bmcKMjQ1IHJlYWwgIDE2OTcgdXNlciAgMTU0IHN5cyAgNzU0LjMwJSBjcHUgCXg4Nl82NC1y
YW5kY29uZmlnLWM5LTExMDcKCjIwMTMtMTEtMDctMDk6Mjk6MzIgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMS4wLTA3OTgyLWc0Nzk2ZThhLi4uLi4uLi4JMQkyLi4uCTMuLi4uLi4uLi4u
Li4uLgk0Li4uLi4uCTUuLgk2Li4uLi4JNwk4Li4JOS4uLgkxMC4uLgkxMQkxMgkxNC4uLi4u
Li4uLi4uLi4uLi4uLi4JMTUuLi4uCTE2CTE3Li4uLi4uLi4uLi4uLgkxOC4JMTkuLi4uLi4u
Li4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMDkgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpCltjY2EzNGI3ODVhMjFkMjIwMTc2MDM4
YzQ1MDcxZmZlODQyZTk5ZmQzXSBCbHVldG9vdGg6IFJlbW92ZSBsaW5rIHR5cGUgY2hlY2sg
aW4gaGNpX2Rpc2Nvbm5fY29tcGxldGVfZXZ0KCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzkt
MTEwNy9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzExMDcwNTEyOmNjYTM0
Yjc4NWEyMWQyMjAxNzYwMzhjNDUwNzFmZmU4NDJlOTlmZDM6YmlzZWN0LXVzYgoKMjAxMy0x
MS0wNy0xMDoyNjozNCBjY2EzNGI3ODVhMjFkMjIwMTc2MDM4YzQ1MDcxZmZlODQyZTk5ZmQz
IGNvbXBpbGluZwo1MyByZWFsICA2MSB1c2VyICAxNiBzeXMgIDE0Ny43MCUgY3B1IAl4ODZf
NjQtcmFuZGNvbmZpZy1jOS0xMTA3CgoyMDEzLTExLTA3LTEwOjI3OjM3IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTEuMC0wODA5MS1nY2NhMzRiNy4uLgkxLi4uLi4uLi4uLi4uLi4uCTIu
CTMuLgk1Li4uCTYJNwk4CTkJMTAJMTIJMTMJMTQuLgkxNQkxNi4uCTE3CTE4CTE5Li4uCTIw
IFNVQ0NFU1MKCkJpc2VjdGluZzogNTQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDYgc3RlcHMpClswMDRlODk1NzI4MGEzMmY3YjU0NzY2NTMxYzA2NDQx
MmJkYTQ1ZTQ4XSBjb252ZXJ0IHRoZSByZXN0IG9mIGJpbmZtdF9lbGZfZmRwaWMgdG8gZHVt
cF9lbWl0KCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzktMTEwNy9saW51eC1kZXZlbDpkZXZl
bC1jYWlyby14ODZfNjQtMjAxMzExMDcwNTEyOjAwNGU4OTU3MjgwYTMyZjdiNTQ3NjY1MzFj
MDY0NDEyYmRhNDVlNDg6YmlzZWN0LXVzYgoKMjAxMy0xMS0wNy0xMDo1MjowOSAwMDRlODk1
NzI4MGEzMmY3YjU0NzY2NTMxYzA2NDQxMmJkYTQ1ZTQ4IGNvbXBpbGluZwoyNTMgcmVhbCAg
MTcwMCB1c2VyICAxNjUgc3lzICA3MzYuMzElIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzkt
MTEwNwoKMjAxMy0xMS0wNy0xMDo1NjozNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAt
cmM0LTAwMDU1LWcwMDRlODk1Li4uLi4uCTEJMi4uLi4uLi4uLgkzLi4uLi4uLi4JNC4uLgk1
Li4JNi4JNy4uCTguLi4uLi4JOS4uLi4uCTEyCTEzLi4uLi4uLi4uLgkxNC4uLi4JMTUuCTE2
LgkxNwkxOC4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyNyByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKW2IwZDk0ZmFjZDdjODFmYWU0
OGU3MmYxZTBiMmE3ZTY1NmVjZGU5MjFdIGV4cG9ydGZzOiBzdG9wIHJldHJ5aW5nIG9uY2Ug
d2UgcmFjZSB3aXRoIHJlbmFtZS9yZW1vdmUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzktMTEw
Ny9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzExMDcwNTEyOmIwZDk0ZmFj
ZDdjODFmYWU0OGU3MmYxZTBiMmE3ZTY1NmVjZGU5MjE6YmlzZWN0LXVzYgoKMjAxMy0xMS0w
Ny0xMTozNjowOCBiMGQ5NGZhY2Q3YzgxZmFlNDhlNzJmMWUwYjJhN2U2NTZlY2RlOTIxIGNv
bXBpbGluZwoyNzIgcmVhbCAgMTY0NiB1c2VyICAxNTkgc3lzICA2NjIuMDUlIGNwdSAJeDg2
XzY0LXJhbmRjb25maWctYzktMTEwNwoKMjAxMy0xMS0wNy0xMTo0MDo1NCBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjEyLjAtcmM0LTAwMDgyLWdiMGQ5NGZhLi4uLi4uLiBURVNUIEZBSUxV
UkUKWyAgICAwLjAyMDAwMF0gTW91bnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAyNTYK
WyAgICAwLjAyMDAwMF0gClsgICAgMC4wMjAwMDBdID09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQpbICAgIDAuMDIwMDAwXSBbIElORk86IHBvc3NpYmxl
IHJlY3Vyc2l2ZSBsb2NraW5nIGRldGVjdGVkIF0KWyAgICAwLjAyMDAwMF0gMy4xMi4wLXJj
NC0wMDA4Mi1nYjBkOTRmYSAjNzIxIE5vdCB0YWludGVkClsgICAgMC4wMjAwMDBdIC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgIDAuMDIwMDAw
XSBzd2FwcGVyLzAgaXMgdHJ5aW5nIHRvIGFjcXVpcmUgbG9jazoKWyAgICAwLjAyMDAwMF0g
ICgmc2ItPnNfdHlwZS0+aV9sb2NrX2tleSl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4MTFi
ZDVkYz5dIGRfZmxhZ3NfZm9yX2lub2RlKzB4M2MvMHhkMApbICAgIDAuMDIwMDAwXSAKWyAg
ICAwLjAyMDAwMF0gYnV0IHRhc2sgaXMgYWxyZWFkeSBob2xkaW5nIGxvY2s6ClsgICAgMC4w
MjAwMDBdICAoJnNiLT5zX3R5cGUtPmlfbG9ja19rZXkpeysuKy4uLn0sIGF0OiBbPGZmZmZm
ZmZmODExYzAzNzQ+XSBkX2luc3RhbnRpYXRlKzB4MzQvMHg3MApbICAgIDAuMDIwMDAwXSAK
WyAgICAwLjAyMDAwMF0gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhp
czoKWyAgICAwLjAyMDAwMF0gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5nIHNjZW5hcmlvOgpb
ICAgIDAuMDIwMDAwXSAKWyAgICAwLjAyMDAwMF0gICAgICAgIENQVTAKWyAgICAwLjAyMDAw
MF0gICAgICAgIC0tLS0KWyAgICAwLjAyMDAwMF0gICBsb2NrKCZzYi0+c190eXBlLT5pX2xv
Y2tfa2V5KTsKWyAgICAwLjAyMDAwMF0gICBsb2NrKCZzYi0+c190eXBlLT5pX2xvY2tfa2V5
KTsKWyAgICAwLjAyMDAwMF0gClsgICAgMC4wMjAwMDBdICAqKiogREVBRExPQ0sgKioqClsg
ICAgMC4wMjAwMDBdIApbICAgIDAuMDIwMDAwXSAgTWF5IGJlIGR1ZSB0byBtaXNzaW5nIGxv
Y2sgbmVzdGluZyBub3RhdGlvbgpbICAgIDAuMDIwMDAwXSAKWyAgICAwLjAyMDAwMF0gMiBs
b2NrcyBoZWxkIGJ5IHN3YXBwZXIvMDoKWyAgICAwLjAyMDAwMF0gICMwOiAgKCZ0eXBlLT5z
X3Vtb3VudF9rZXkvMSl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4MTFhYWVlNj5dIHNnZXQr
MHgyNjYvMHg0NDAKWyAgICAwLjAyMDAwMF0gICMxOiAgKCZzYi0+c190eXBlLT5pX2xvY2tf
a2V5KXsrLisuLi59LCBhdDogWzxmZmZmZmZmZjgxMWMwMzc0Pl0gZF9pbnN0YW50aWF0ZSsw
eDM0LzB4NzAKWyAgICAwLjAyMDAwMF0gClsgICAgMC4wMjAwMDBdIHN0YWNrIGJhY2t0cmFj
ZToKWyAgICAwLjAyMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWlu
dGVkIDMuMTIuMC1yYzQtMDAwODItZ2IwZDk0ZmEgIzcyMQpbICAgIDAuMDIwMDAwXSBIYXJk
d2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4w
MjAwMDBdICBmZmZmZmZmZjgyYzk4OGQwIGZmZmZmZmZmODI0MDFjMTggZmZmZmZmZmY4MWMy
MWMxOSBmZmZmZmZmZjgyNDAxY2UwClsgICAgMC4wMjAwMDBdICBmZmZmZmZmZjgxMTExZjE3
IGZmZmZmZmZmODI0MTM0YzAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgyNDAwMDM4Clsg
ICAgMC4wMjAwMDBdICBmZmZmZmZmZjgyNDEzYWY4IGZmZmZmZmZmMDAwMDAwMDAgMDAwMDAw
MDBjNDA2ZTAzNyBmZmZmZmZmZjgyNDEzNGMwClsgICAgMC4wMjAwMDBdIENhbGwgVHJhY2U6
ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODFjMjFjMTk+XSBkdW1wX3N0YWNrKzB4MTkv
MHgxYgpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxMTExZjE3Pl0gX19sb2NrX2FjcXVp
cmUrMHgxMmU3LzB4MWQ3MApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxMTEyOTJjPl0g
PyBfX2xvY2tfYWNxdWlyZSsweDFjZmMvMHgxZDcwClsgICAgMC4wMjAwMDBdICBbPGZmZmZm
ZmZmODFjMjE3MDg+XSA/IF9fc2xhYl9hbGxvYy5jb25zdHByb3AuNjErMHgzZGMvMHgzZmEK
WyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MTExMzhhZD5dIGxvY2tfYWNxdWlyZSsweDE5
ZC8weDIyMApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxMWJkNWRjPl0gPyBkX2ZsYWdz
X2Zvcl9pbm9kZSsweDNjLzB4ZDAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MWMzNTQz
Yj5dIF9yYXdfc3Bpbl9sb2NrKzB4M2IvMHg3MApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZm
ZjgxMWJkNWRjPl0gPyBkX2ZsYWdzX2Zvcl9pbm9kZSsweDNjLzB4ZDAKWyAgICAwLjAyMDAw
MF0gIFs8ZmZmZmZmZmY4MTFiZDVkYz5dIGRfZmxhZ3NfZm9yX2lub2RlKzB4M2MvMHhkMApb
ICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxMWJkZWRkPl0gX19kX2luc3RhbnRpYXRlKzB4
MWQvMHhmMApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxMWMwMzdmPl0gZF9pbnN0YW50
aWF0ZSsweDNmLzB4NzAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MTFjMDUxMj5dIGRf
bWFrZV9yb290KzB4MzIvMHg2MApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxMWYzYzM4
Pl0gc3lzZnNfbW91bnQrMHgxNzgvMHgyMjAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4
MTFhYmQwMz5dIG1vdW50X2ZzKzB4NzMvMHgxOTAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZm
ZmY4MTFjOTVlNT5dIHZmc19rZXJuX21vdW50KzB4NjUvMHhmMApbICAgIDAuMDIwMDAwXSAg
WzxmZmZmZmZmZjgxMWNjMWI0Pl0ga2Vybl9tb3VudF9kYXRhKzB4MTQvMHgzMApbICAgIDAu
MDIwMDAwXSAgWzxmZmZmZmZmZjgyN2E4ZDhmPl0gc3lzZnNfaW5pdCsweDU0LzB4YjMKWyAg
ICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjdhNzQ2NT5dIG1udF9pbml0KzB4Y2QvMHgxZDYK
WyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjdhNzEzMz5dIHZmc19jYWNoZXNfaW5pdCsw
eDkwLzB4MTBlClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI3YWFmNTE+XSA/IGludGVn
cml0eV9paW50Y2FjaGVfaW5pdCsweDIzLzB4MzgKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZm
ZmY4MjdhOWZjNj5dID8gc2VjdXJpdHlfaW5pdCsweDM1LzB4NDcKWyAgICAwLjAyMDAwMF0g
IFs8ZmZmZmZmZmY4Mjc4M2U5OD5dIHN0YXJ0X2tlcm5lbCsweDQ1Ni8weDQ5ZQpbICAgIDAu
MDIwMDAwXSAgWzxmZmZmZmZmZjgyNzgzODRhPl0gPyByZXBhaXJfZW52X3N0cmluZysweDVl
LzB4NWUKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4Mjc4MzEyMD5dID8gZWFybHlfaWR0
X2hhbmRsZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI3ODM1
NDM+XSB4ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4MmEvMHgyYwpbICAgIDAuMDIwMDAw
XSAgWzxmZmZmZmZmZjgyNzgzNjM4Pl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweGYzLzB4MTAy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzktMTEwNy9iMGQ5NGZhY2Q3YzgxZmFlNDhl
NzJmMWUwYjJhN2U2NTZlY2RlOTIxL2RtZXNnLXlvY3RvLXNuYi03OjIwMTMxMTA3MTE0MzUw
Ong4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4xMi4wLXJjNC0wMDA4Mi1nYjBkOTRmYTo3
MjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3L2IwZDk0ZmFjZDdjODFmYWU0
OGU3MmYxZTBiMmE3ZTY1NmVjZGU5MjEvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS0zOjIwMTMx
MTA3MTE0NDA3Ong4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4xMi4wLXJjNC0wMDA4Mi1n
YjBkOTRmYTo3MjEKMDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJF
UEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNl
Y3Rpbmc6IDEzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0
IHN0ZXBzKQpbNTAyMzVjZDk3MjdjMjBiMDk5NjdiNWMwNjAwMjVlYWM5ZDBjODBiYl0gZWxm
eyxfZmRwaWN9IGNvcmVkdW1wOiBnZXQgcmlkIG9mIHBvaW50bGVzcyBpZiAoc2lnaW5mby0+
c2lfc2lnbm8pCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvbGludXgtZGV2ZWw6ZGV2
ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTA3MDUxMjo1MDIzNWNkOTcyN2MyMGIwOTk2N2I1YzA2
MDAyNWVhYzlkMGM4MGJiOmJpc2VjdC11c2IKCjIwMTMtMTEtMDctMTE6NDQ6MjcgNTAyMzVj
ZDk3MjdjMjBiMDk5NjdiNWMwNjAwMjVlYWM5ZDBjODBiYiBjb21waWxpbmcKMTg5IHJlYWwg
IDE0MDQgdXNlciAgMTM2IHN5cyAgODExLjk2JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWM5
LTExMDcKCjIwMTMtMTEtMDctMTE6NDc6NDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4w
LXJjNC0wMDA2OC1nNTAyMzVjZC4uCTEuLi4JMgkzLi4uCTQuCTkJMTAuLgkxMS4JMTIuLi4u
LgkxMwkxNS4JMTYuLgkxNwkxOS4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNiByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzA4MTk2OTY5
NTMyZWVlMTBjZGVhYTI5ZmNhMzdmYTdhNDA3YjAxYWVdIGRjYWNoZTogdXNlIElTX1JPT1Qg
dG8gZGVjaWRlIHdoZXJlIGRlbnRyeSBpcyBoYXNoZWQKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
YzktMTEwNy9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzExMDcwNTEyOjA4
MTk2OTY5NTMyZWVlMTBjZGVhYTI5ZmNhMzdmYTdhNDA3YjAxYWU6YmlzZWN0LXVzYgoKMjAx
My0xMS0wNy0xMjowNTo0OCAwODE5Njk2OTUzMmVlZTEwY2RlYWEyOWZjYTM3ZmE3YTQwN2Iw
MWFlIGNvbXBpbGluZwoxOTggcmVhbCAgMTM5MSB1c2VyICAxMjUgc3lzICA3NjQuMDQlIGNw
dSAJeDg2XzY0LXJhbmRjb25maWctYzktMTEwNwoKMjAxMy0xMS0wNy0xMjowOToxOCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM0LTAwMDc1LWcwODE5Njk2Li4uLi4gVEVTVCBG
QUlMVVJFClsgICAgMC4wMjAwMDBdIE1vdW50LWNhY2hlIGhhc2ggdGFibGUgZW50cmllczog
MjU2ClsgICAgMC4wMjAwMDBdIApbICAgIDAuMDIwMDAwXSA9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAgICAwLjAyMDAwMF0gWyBJTkZPOiBwb3Nz
aWJsZSByZWN1cnNpdmUgbG9ja2luZyBkZXRlY3RlZCBdClsgICAgMC4wMjAwMDBdIDMuMTIu
MC1yYzQtMDAwNzUtZzA4MTk2OTYgIzcyMyBOb3QgdGFpbnRlZApbICAgIDAuMDIwMDAwXSAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgICAwLjAy
MDAwMF0gc3dhcHBlci8wIGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6ClsgICAgMC4wMjAw
MDBdICAoJnNiLT5zX3R5cGUtPmlfbG9ja19rZXkpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZm
ODExYmQ1ZGM+XSBkX2ZsYWdzX2Zvcl9pbm9kZSsweDNjLzB4ZDAKWyAgICAwLjAyMDAwMF0g
ClsgICAgMC4wMjAwMDBdIGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpbICAg
IDAuMDIwMDAwXSAgKCZzYi0+c190eXBlLT5pX2xvY2tfa2V5KXsrLisuLi59LCBhdDogWzxm
ZmZmZmZmZjgxMWMwMzg0Pl0gZF9pbnN0YW50aWF0ZSsweDM0LzB4NzAKWyAgICAwLjAyMDAw
MF0gClsgICAgMC4wMjAwMDBdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVn
IHRoaXM6ClsgICAgMC4wMjAwMDBdICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJp
bzoKWyAgICAwLjAyMDAwMF0gClsgICAgMC4wMjAwMDBdICAgICAgICBDUFUwClsgICAgMC4w
MjAwMDBdICAgICAgICAtLS0tClsgICAgMC4wMjAwMDBdICAgbG9jaygmc2ItPnNfdHlwZS0+
aV9sb2NrX2tleSk7ClsgICAgMC4wMjAwMDBdICAgbG9jaygmc2ItPnNfdHlwZS0+aV9sb2Nr
X2tleSk7ClsgICAgMC4wMjAwMDBdIApbICAgIDAuMDIwMDAwXSAgKioqIERFQURMT0NLICoq
KgpbICAgIDAuMDIwMDAwXSAKWyAgICAwLjAyMDAwMF0gIE1heSBiZSBkdWUgdG8gbWlzc2lu
ZyBsb2NrIG5lc3Rpbmcgbm90YXRpb24KWyAgICAwLjAyMDAwMF0gClsgICAgMC4wMjAwMDBd
IDIgbG9ja3MgaGVsZCBieSBzd2FwcGVyLzA6ClsgICAgMC4wMjAwMDBdICAjMDogICgmdHlw
ZS0+c191bW91bnRfa2V5LzEpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmODExYWFlZTY+XSBz
Z2V0KzB4MjY2LzB4NDQwClsgICAgMC4wMjAwMDBdICAjMTogICgmc2ItPnNfdHlwZS0+aV9s
b2NrX2tleSl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZmZmY4MTFjMDM4ND5dIGRfaW5zdGFudGlh
dGUrMHgzNC8weDcwClsgICAgMC4wMjAwMDBdIApbICAgIDAuMDIwMDAwXSBzdGFjayBiYWNr
dHJhY2U6ClsgICAgMC4wMjAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3Qg
dGFpbnRlZCAzLjEyLjAtcmM0LTAwMDc1LWcwODE5Njk2ICM3MjMKWyAgICAwLjAyMDAwMF0g
SGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAg
IDAuMDIwMDAwXSAgZmZmZmZmZmY4MmM5ODhkMCBmZmZmZmZmZjgyNDAxYzE4IGZmZmZmZmZm
ODFjMjFiZDkgZmZmZmZmZmY4MjQwMWNlMApbICAgIDAuMDIwMDAwXSAgZmZmZmZmZmY4MTEx
MWYxNyBmZmZmZmZmZjgyNDEzNGMwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MjQwMDAz
OApbICAgIDAuMDIwMDAwXSAgZmZmZmZmZmY4MjQxM2FmOCBmZmZmZmZmZjAwMDAwMDAwIDAw
MDAwMDAwYzQwNmUwMzcgZmZmZmZmZmY4MjQxMzRjMApbICAgIDAuMDIwMDAwXSBDYWxsIFRy
YWNlOgpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxYzIxYmQ5Pl0gZHVtcF9zdGFjaysw
eDE5LzB4MWIKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MTExMWYxNz5dIF9fbG9ja19h
Y3F1aXJlKzB4MTJlNy8weDFkNzAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MTExMjky
Yz5dID8gX19sb2NrX2FjcXVpcmUrMHgxY2ZjLzB4MWQ3MApbICAgIDAuMDIwMDAwXSAgWzxm
ZmZmZmZmZjgxYzIxNmM4Pl0gPyBfX3NsYWJfYWxsb2MuY29uc3Rwcm9wLjYxKzB4M2RjLzB4
M2ZhClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODExMTM4YWQ+XSBsb2NrX2FjcXVpcmUr
MHgxOWQvMHgyMjAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MTFiZDVkYz5dID8gZF9m
bGFnc19mb3JfaW5vZGUrMHgzYy8weGQwClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODFj
MzUzZmI+XSBfcmF3X3NwaW5fbG9jaysweDNiLzB4NzAKWyAgICAwLjAyMDAwMF0gIFs8ZmZm
ZmZmZmY4MTFiZDVkYz5dID8gZF9mbGFnc19mb3JfaW5vZGUrMHgzYy8weGQwClsgICAgMC4w
MjAwMDBdICBbPGZmZmZmZmZmODExYmQ1ZGM+XSBkX2ZsYWdzX2Zvcl9pbm9kZSsweDNjLzB4
ZDAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MTFiZGVkZD5dIF9fZF9pbnN0YW50aWF0
ZSsweDFkLzB4ZjAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MTFjMDM4Zj5dIGRfaW5z
dGFudGlhdGUrMHgzZi8weDcwClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODExYzA1MjI+
XSBkX21ha2Vfcm9vdCsweDMyLzB4NjAKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MTFm
M2M1OD5dIHN5c2ZzX21vdW50KzB4MTc4LzB4MjIwClsgICAgMC4wMjAwMDBdICBbPGZmZmZm
ZmZmODExYWJkMDM+XSBtb3VudF9mcysweDczLzB4MTkwClsgICAgMC4wMjAwMDBdICBbPGZm
ZmZmZmZmODExYzk2MDU+XSB2ZnNfa2Vybl9tb3VudCsweDY1LzB4ZjAKWyAgICAwLjAyMDAw
MF0gIFs8ZmZmZmZmZmY4MTFjYzFkND5dIGtlcm5fbW91bnRfZGF0YSsweDE0LzB4MzAKWyAg
ICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MjdhOGQ4Zj5dIHN5c2ZzX2luaXQrMHg1NC8weGIz
ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI3YTc0NjU+XSBtbnRfaW5pdCsweGNkLzB4
MWQ2ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI3YTcxMzM+XSB2ZnNfY2FjaGVzX2lu
aXQrMHg5MC8weDEwZQpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyN2FhZjUxPl0gPyBp
bnRlZ3JpdHlfaWludGNhY2hlX2luaXQrMHgyMy8weDM4ClsgICAgMC4wMjAwMDBdICBbPGZm
ZmZmZmZmODI3YTlmYzY+XSA/IHNlY3VyaXR5X2luaXQrMHgzNS8weDQ3ClsgICAgMC4wMjAw
MDBdICBbPGZmZmZmZmZmODI3ODNlOTg+XSBzdGFydF9rZXJuZWwrMHg0NTYvMHg0OWUKWyAg
ICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4Mjc4Mzg0YT5dID8gcmVwYWlyX2Vudl9zdHJpbmcr
MHg1ZS8weDVlClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI3ODMxMjA+XSA/IGVhcmx5
X2lkdF9oYW5kbGVycysweDEyMC8weDEyMApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgy
NzgzNTQzPl0geDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysweDJhLzB4MmMKWyAgICAwLjAy
MDAwMF0gIFs8ZmZmZmZmZmY4Mjc4MzYzOD5dIHg4Nl82NF9zdGFydF9rZXJuZWwrMHhmMy8w
eDEwMgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvMDgxOTY5Njk1MzJlZWUx
MGNkZWFhMjlmY2EzN2ZhN2E0MDdiMDFhZS9kbWVzZy15b2N0by1pbm4tMzg6MjAxMzExMDcx
MjExMzY6eDg2XzY0LXJhbmRjb25maWctYzktMTEwNzozLjEyLjAtcmM0LTAwMDc1LWcwODE5
Njk2OjcyMwowOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFU
IENPVU5UOiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGlu
ZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVw
cykKWzc3MTdiZjIxZTRhNWUxZDM3MWUzMTNhNDQwNDYzNWY0Nzc1OTYxZDldIHZmczogc3Bs
aXQgb3V0IHZmc19nZXRhdHRyX25vc2VjCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcv
bGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTA3MDUxMjo3NzE3YmYyMWU0
YTVlMWQzNzFlMzEzYTQ0MDQ2MzVmNDc3NTk2MWQ5OmJpc2VjdC11c2IKCjIwMTMtMTEtMDct
MTI6MTE6NDkgNzcxN2JmMjFlNGE1ZTFkMzcxZTMxM2E0NDA0NjM1ZjQ3NzU5NjFkOSBjb21w
aWxpbmcKNDUgcmVhbCAgNjcgdXNlciAgMTggc3lzICAxODguMDQlIGNwdSAJeDg2XzY0LXJh
bmRjb25maWctYzktMTEwNwoKMjAxMy0xMS0wNy0xMjoxMjo0NSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEyLjAtcmM0LTAwMDcxLWc3NzE3YmYyLi4uLi4JMS4uIFRFU1QgRkFJTFVSRQpC
VUc6IGtlcm5lbCBlYXJseSBoYW5nIHdpdGhvdXQgYW55IHByaW50ayBvdXRwdXQKQ29tbWFu
ZCBsaW5lOiBodW5nX3Rhc2tfcGFuaWM9MSByY3V0cmVlLnJjdV9jcHVfc3RhbGxfdGltZW91
dD0xMDAgbG9nX2J1Zl9sZW49OE0gaWdub3JlX2xvZ2xldmVsIGRlYnVnIHNjaGVkX2RlYnVn
IGFwaWM9ZGVidWcgZHluYW1pY19wcmludGsgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcGFuaWM9
MTAgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkw
IHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvbGludXgtZGV2ZWw6ZGV2ZWwt
Y2Fpcm8teDg2XzY0LTIwMTMxMTA3MDUxMjo3NzE3YmYyMWU0YTVlMWQzNzFlMzEzYTQ0MDQ2
MzVmNDc3NTk2MWQ5OmJpc2VjdC11c2IvLnZtbGludXotNzcxN2JmMjFlNGE1ZTFkMzcxZTMx
M2E0NDA0NjM1ZjQ3NzU5NjFkOS0yMDEzMTEwNzEyMTI0NC0xMi1hbnQgYnJhbmNoPWxpbnV4
LWRldmVsL2RldmVsLWNhaXJvLXg4Nl82NC0yMDEzMTEwNzA1MTIgQk9PVF9JTUFHRT0va2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvNzcxN2JmMjFlNGE1ZTFkMzcxZTMxM2E0
NDA0NjM1ZjQ3NzU5NjFkOS92bWxpbnV6LTMuMTIuMC1yYzQtMDAwNzEtZzc3MTdiZjIgbm9h
cGljIG5vbGFwaWMgbm9oej1vZmYKRWFybHkgaGFuZyBrZXJuZWw6IHZtbGludXotMy4xMi4w
LXJjNC0wMDA3MS1nNzcxN2JmMiAzLjEyLjAtcmM0LTAwMDcxLWc3NzE3YmYyICM3MjQKRWxh
cHNlZCB0aW1lOiAzNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvNzcxN2Jm
MjFlNGE1ZTFkMzcxZTMxM2E0NDA0NjM1ZjQ3NzU5NjFkOS9kbWVzZy1xdWFudGFsLWlubi0z
MjoyMDEzMTEwNzEyMTYxNDp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3OjMuMTIuMC1yYzQt
MDAwNzEtZzc3MTdiZjI6NzI0CjA6MToyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW1SRVBFQVQgQ09VTlQ6IDMwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1sw
bQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxIHN0ZXApCls1MjBlZjA3OGVhYmRiZTdlYjZhMzNjMWY1NmE2NWFjNTVkNDFlNmVk
XSBpZ2V0L2lnZXQ1OiBkb24ndCBib3RoZXIgd2l0aCAtPmlfbG9jayB1bnRpbCB3ZSBmaW5k
IGEgbWF0Y2gKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzktMTEwNy9saW51eC1kZXZlbDpkZXZl
bC1jYWlyby14ODZfNjQtMjAxMzExMDcwNTEyOjUyMGVmMDc4ZWFiZGJlN2ViNmEzM2MxZjU2
YTY1YWM1NWQ0MWU2ZWQ6YmlzZWN0LXVzYgoKMjAxMy0xMS0wNy0xMjoxNjo0NyA1MjBlZjA3
OGVhYmRiZTdlYjZhMzNjMWY1NmE2NWFjNTVkNDFlNmVkIGNvbXBpbGluZwoxODkgcmVhbCAg
MTM3OSB1c2VyICAxMjQgc3lzICA3OTIuMDAlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzkt
MTEwNwoKMjAxMy0xMS0wNy0xMjoyMDowOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAt
cmM0LTAwMDcwLWc1MjBlZjA3Li4uLi4uLgkyIFRFU1QgRkFJTFVSRQpCVUc6IGtlcm5lbCBl
YXJseSBoYW5nIHdpdGhvdXQgYW55IHByaW50ayBvdXRwdXQKQ29tbWFuZCBsaW5lOiBodW5n
X3Rhc2tfcGFuaWM9MSByY3V0cmVlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgbG9nX2J1
Zl9sZW49OE0gaWdub3JlX2xvZ2xldmVsIGRlYnVnIHNjaGVkX2RlYnVnIGFwaWM9ZGVidWcg
ZHluYW1pY19wcmludGsgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcGFuaWM9MTAgIHByb21wdF9y
YW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwg
IHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0
LTIwMTMxMTA3MDUxMjo1MjBlZjA3OGVhYmRiZTdlYjZhMzNjMWY1NmE2NWFjNTVkNDFlNmVk
OmJpc2VjdC11c2IvLnZtbGludXotNTIwZWYwNzhlYWJkYmU3ZWI2YTMzYzFmNTZhNjVhYzU1
ZDQxZTZlZC0yMDEzMTEwNzEyMjAwNi0xOC1hbnQgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVs
LWNhaXJvLXg4Nl82NC0yMDEzMTEwNzA1MTIgQk9PVF9JTUFHRT0va2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWM5LTExMDcvNTIwZWYwNzhlYWJkYmU3ZWI2YTMzYzFmNTZhNjVhYzU1ZDQx
ZTZlZC92bWxpbnV6LTMuMTIuMC1yYzQtMDAwNzAtZzUyMGVmMDcgbm9hcGljIG5vbGFwaWMg
bm9oej1vZmYKRWFybHkgaGFuZyBrZXJuZWw6IHZtbGludXotMy4xMi4wLXJjNC0wMDA3MC1n
NTIwZWYwNyAzLjEyLjAtcmM0LTAwMDcwLWc1MjBlZjA3ICM3MjUKRWxhcHNlZCB0aW1lOiAz
NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvNTIwZWYwNzhlYWJkYmU3ZWI2
YTMzYzFmNTZhNjVhYzU1ZDQxZTZlZC9kbWVzZy1xdWFudGFsLXhwcy02OjIwMTMxMTA3MjAy
MzM3Ong4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4xMi4wLXJjNC0wMDA3MC1nNTIwZWYw
Nzo3MjUKMDoxOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBD
T1VOVDogNDAgICMgL2NjL3dmZy91c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6
IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMp
ClsxMjQ3Yzc0YjRmM2YzNzI1YThiZDhkYzBiYmQyMmJhYTJhOTA0OWFlXSBWRlM6IFB1dCBh
IHNtYWxsIHR5cGUgZmllbGQgaW50byBzdHJ1Y3QgZGVudHJ5OjpkX2ZsYWdzCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
dXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWM5LTExMDcvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIw
MTMxMTA3MDUxMjoxMjQ3Yzc0YjRmM2YzNzI1YThiZDhkYzBiYmQyMmJhYTJhOTA0OWFlOmJp
c2VjdC11c2IKCjIwMTMtMTEtMDctMTI6MjQ6MTQgMTI0N2M3NGI0ZjNmMzcyNWE4YmQ4ZGMw
YmJkMjJiYWEyYTkwNDlhZSBjb21waWxpbmcKNDEgcmVhbCAgNTYgdXNlciAgMTYgc3lzICAx
NzQuMDIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzktMTEwNwoKMjAxMy0xMS0wNy0xMjoy
NjoxMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM0LTAwMDY5LWcxMjQ3Yzc0Li4u
Li4uIFRFU1QgRkFJTFVSRQpbICAgIDAuMDIwMDAwXSBNb3VudC1jYWNoZSBoYXNoIHRhYmxl
IGVudHJpZXM6IDI1NgpbICAgIDAuMDIwMDAwXSAKWyAgICAwLjAyMDAwMF0gPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAgMC4wMjAwMDBdIFsg
SU5GTzogcG9zc2libGUgcmVjdXJzaXZlIGxvY2tpbmcgZGV0ZWN0ZWQgXQpbICAgIDAuMDIw
MDAwXSAzLjEyLjAtcmM0LTAwMDY5LWcxMjQ3Yzc0ICM3MjYgTm90IHRhaW50ZWQKWyAgICAw
LjAyMDAwMF0gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
ClsgICAgMC4wMjAwMDBdIHN3YXBwZXIvMCBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpb
ICAgIDAuMDIwMDAwXSAgKCZzYi0+c190eXBlLT5pX2xvY2tfa2V5KXsrLisuLi59LCBhdDog
WzxmZmZmZmZmZjgxMWJkNWRjPl0gZF9mbGFnc19mb3JfaW5vZGUrMHgzYy8weGQwClsgICAg
MC4wMjAwMDBdIApbICAgIDAuMDIwMDAwXSBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcg
bG9jazoKWyAgICAwLjAyMDAwMF0gICgmc2ItPnNfdHlwZS0+aV9sb2NrX2tleSl7Ky4rLi4u
fSwgYXQ6IFs8ZmZmZmZmZmY4MTFjMDM4ND5dIGRfaW5zdGFudGlhdGUrMHgzNC8weDcwClsg
ICAgMC4wMjAwMDBdIApbICAgIDAuMDIwMDAwXSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVs
cCB1cyBkZWJ1ZyB0aGlzOgpbICAgIDAuMDIwMDAwXSAgUG9zc2libGUgdW5zYWZlIGxvY2tp
bmcgc2NlbmFyaW86ClsgICAgMC4wMjAwMDBdIApbICAgIDAuMDIwMDAwXSAgICAgICAgQ1BV
MApbICAgIDAuMDIwMDAwXSAgICAgICAgLS0tLQpbICAgIDAuMDIwMDAwXSAgIGxvY2soJnNi
LT5zX3R5cGUtPmlfbG9ja19rZXkpOwpbICAgIDAuMDIwMDAwXSAgIGxvY2soJnNiLT5zX3R5
cGUtPmlfbG9ja19rZXkpOwpbICAgIDAuMDIwMDAwXSAKWyAgICAwLjAyMDAwMF0gICoqKiBE
RUFETE9DSyAqKioKWyAgICAwLjAyMDAwMF0gClsgICAgMC4wMjAwMDBdICBNYXkgYmUgZHVl
IHRvIG1pc3NpbmcgbG9jayBuZXN0aW5nIG5vdGF0aW9uClsgICAgMC4wMjAwMDBdIApbICAg
IDAuMDIwMDAwXSAyIGxvY2tzIGhlbGQgYnkgc3dhcHBlci8wOgpbICAgIDAuMDIwMDAwXSAg
IzA6ICAoJnR5cGUtPnNfdW1vdW50X2tleS8xKXsrLisuLi59LCBhdDogWzxmZmZmZmZmZjgx
MWFhZWU2Pl0gc2dldCsweDI2Ni8weDQ0MApbICAgIDAuMDIwMDAwXSAgIzE6ICAoJnNiLT5z
X3R5cGUtPmlfbG9ja19rZXkpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmODExYzAzODQ+XSBk
X2luc3RhbnRpYXRlKzB4MzQvMHg3MApbICAgIDAuMDIwMDAwXSAKWyAgICAwLjAyMDAwMF0g
c3RhY2sgYmFja3RyYWNlOgpbICAgIDAuMDIwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3
YXBwZXIgTm90IHRhaW50ZWQgMy4xMi4wLXJjNC0wMDA2OS1nMTI0N2M3NCAjNzI2ClsgICAg
MC4wMjAwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgICAwLjAyMDAwMF0gIGZmZmZmZmZmODJjOTg4ZDAgZmZmZmZmZmY4MjQwMWMx
OCBmZmZmZmZmZjgxYzIxYmE5IGZmZmZmZmZmODI0MDFjZTAKWyAgICAwLjAyMDAwMF0gIGZm
ZmZmZmZmODExMTFmMTcgZmZmZmZmZmY4MjQxMzRjMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmZm
ZmZmODI0MDAwMzgKWyAgICAwLjAyMDAwMF0gIGZmZmZmZmZmODI0MTNhZjggZmZmZmZmZmYw
MDAwMDAwMCAwMDAwMDAwMGM0MDZlMDM3IGZmZmZmZmZmODI0MTM0YzAKWyAgICAwLjAyMDAw
MF0gQ2FsbCBUcmFjZToKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4MWMyMWJhOT5dIGR1
bXBfc3RhY2srMHgxOS8weDFiClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODExMTFmMTc+
XSBfX2xvY2tfYWNxdWlyZSsweDEyZTcvMHgxZDcwClsgICAgMC4wMjAwMDBdICBbPGZmZmZm
ZmZmODExMTI5MmM+XSA/IF9fbG9ja19hY3F1aXJlKzB4MWNmYy8weDFkNzAKWyAgICAwLjAy
MDAwMF0gIFs8ZmZmZmZmZmY4MWMyMTY5OD5dID8gX19zbGFiX2FsbG9jLmNvbnN0cHJvcC42
MSsweDNkYy8weDNmYQpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxMTEzOGFkPl0gbG9j
a19hY3F1aXJlKzB4MTlkLzB4MjIwClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODExYmQ1
ZGM+XSA/IGRfZmxhZ3NfZm9yX2lub2RlKzB4M2MvMHhkMApbICAgIDAuMDIwMDAwXSAgWzxm
ZmZmZmZmZjgxYzM1M2NiPl0gX3Jhd19zcGluX2xvY2srMHgzYi8weDcwClsgICAgMC4wMjAw
MDBdICBbPGZmZmZmZmZmODExYmQ1ZGM+XSA/IGRfZmxhZ3NfZm9yX2lub2RlKzB4M2MvMHhk
MApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgxMWJkNWRjPl0gZF9mbGFnc19mb3JfaW5v
ZGUrMHgzYy8weGQwClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODExYmRlZGQ+XSBfX2Rf
aW5zdGFudGlhdGUrMHgxZC8weGYwClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODExYzAz
OGY+XSBkX2luc3RhbnRpYXRlKzB4M2YvMHg3MApbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZm
ZjgxMWMwNTIyPl0gZF9tYWtlX3Jvb3QrMHgzMi8weDYwClsgICAgMC4wMjAwMDBdICBbPGZm
ZmZmZmZmODExZjNjNTg+XSBzeXNmc19tb3VudCsweDE3OC8weDIyMApbICAgIDAuMDIwMDAw
XSAgWzxmZmZmZmZmZjgxMWFiZDAzPl0gbW91bnRfZnMrMHg3My8weDE5MApbICAgIDAuMDIw
MDAwXSAgWzxmZmZmZmZmZjgxMWM5NjA1Pl0gdmZzX2tlcm5fbW91bnQrMHg2NS8weGYwClsg
ICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODExY2MxZDQ+XSBrZXJuX21vdW50X2RhdGErMHgx
NC8weDMwClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI3YThkOGY+XSBzeXNmc19pbml0
KzB4NTQvMHhiMwpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyN2E3NDY1Pl0gbW50X2lu
aXQrMHhjZC8weDFkNgpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyN2E3MTMzPl0gdmZz
X2NhY2hlc19pbml0KzB4OTAvMHgxMGUKWyAgICAwLjAyMDAwMF0gIFs8ZmZmZmZmZmY4Mjdh
YWY1MT5dID8gaW50ZWdyaXR5X2lpbnRjYWNoZV9pbml0KzB4MjMvMHgzOApbICAgIDAuMDIw
MDAwXSAgWzxmZmZmZmZmZjgyN2E5ZmM2Pl0gPyBzZWN1cml0eV9pbml0KzB4MzUvMHg0Nwpb
ICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyNzgzZTk4Pl0gc3RhcnRfa2VybmVsKzB4NDU2
LzB4NDllClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI3ODM4NGE+XSA/IHJlcGFpcl9l
bnZfc3RyaW5nKzB4NWUvMHg1ZQpbICAgIDAuMDIwMDAwXSAgWzxmZmZmZmZmZjgyNzgzMTIw
Pl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjAyMDAwMF0gIFs8
ZmZmZmZmZmY4Mjc4MzU0Mz5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHgyYS8weDJj
ClsgICAgMC4wMjAwMDBdICBbPGZmZmZmZmZmODI3ODM2Mzg+XSB4ODZfNjRfc3RhcnRfa2Vy
bmVsKzB4ZjMvMHgxMDIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3LzEyNDdj
NzRiNGYzZjM3MjVhOGJkOGRjMGJiZDIyYmFhMmE5MDQ5YWUvZG1lc2ctcXVhbnRhbC1hdGhl
bnMtNzoyMDEzMTEwNzEyMjgzODp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3OjMuMTIuMC1y
YzQtMDAwNjktZzEyNDdjNzQ6NzI2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzktMTEw
Ny8xMjQ3Yzc0YjRmM2YzNzI1YThiZDhkYzBiYmQyMmJhYTJhOTA0OWFlL2RtZXNnLXF1YW50
YWwtc3RvYWtsZXktMToyMDEzMTEwNzEyMjg0MDp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3
OjMuMTIuMC1yYzQtMDAwNjktZzEyNDdjNzQ6NzI2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzktMTEwNy8xMjQ3Yzc0YjRmM2YzNzI1YThiZDhkYzBiYmQyMmJhYTJhOTA0OWFlL2Rt
ZXNnLXlvY3RvLXN0b2FrbGV5LTM6MjAxMzExMDcxMjI4MzQ6eDg2XzY0LXJhbmRjb25maWct
YzktMTEwNzozLjEyLjAtcmM0LTAwMDY5LWcxMjQ3Yzc0OjcyNgova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWM5LTExMDcvMTI0N2M3NGI0ZjNmMzcyNWE4YmQ4ZGMwYmJkMjJiYWEyYTkw
NDlhZS9kbWVzZy1xdWFudGFsLXN0b2FrbGV5LTY6MjAxMzExMDcxMjI4NTA6eDg2XzY0LXJh
bmRjb25maWctYzktMTEwNzozLjEyLjAtcmM0LTAwMDY5LWcxMjQ3Yzc0OjcyNgowOjQ6NCBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKMTI0N2M3NGI0ZjNmMzcyNWE4YmQ4ZGMwYmJk
MjJiYWEyYTkwNDlhZSBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgMTI0N2M3NGI0
ZjNmMzcyNWE4YmQ4ZGMwYmJkMjJiYWEyYTkwNDlhZQpBdXRob3I6IERhdmlkIEhvd2VsbHMg
PGRob3dlbGxzQHJlZGhhdC5jb20+CkRhdGU6ICAgVGh1IFNlcCAxMiAxOToyMjo1MyAyMDEz
ICswMTAwCgogICAgVkZTOiBQdXQgYSBzbWFsbCB0eXBlIGZpZWxkIGludG8gc3RydWN0IGRl
bnRyeTo6ZF9mbGFncwogICAgCiAgICBQdXQgYSB0eXBlIGZpZWxkIGludG8gc3RydWN0IGRl
bnRyeTo6ZF9mbGFncyB0byBpbmRpY2F0ZSBpZiB0aGUgZGVudHJ5IGlzIG9uZQogICAgb2Yg
dGhlIGZvbGxvd2luZyB0eXBlcyB0aGF0IHJlbGF0ZSBwYXJ0aWN1bGFybHkgdG8gcGF0aHdh
bGs6CiAgICAKICAgIAlNaXNzIChuZWdhdGl2ZSBkZW50cnkpCiAgICAJRGlyZWN0b3J5CiAg
ICAJIkF1dG9tb3VudCIgZGlyZWN0b3J5IChkZWZlY3RpdmUgLSBubyBpX29wLT5sb29rdXAo
KSkKICAgIAlTeW1saW5rCiAgICAJT3RoZXIgKHJlZ3VsYXIsIHNvY2tldCwgZmlmbywgZGV2
aWNlKQogICAgCiAgICBUaGUgdHlwZSBmaWVsZCBpcyBzZXQgdG8gb25lIG9mIHRoZSBmaXJz
dCBmaXZlIHR5cGVzIG9uIGEgZGVudHJ5IGJ5IGNhbGxzIHRvCiAgICBfX2RfaW5zdGFudGlh
dGUoKSBhbmQgZF9vYnRhaW5fYWxpYXMoKSBmcm9tIGluZm9ybWF0aW9uIGluIHRoZSBpbm9k
ZSAoaWYgb25lIGlzCiAgICBnaXZlbikuCiAgICAKICAgIFRoZSB0eXBlIGlzIGNsZWFyZWQg
YnkgZGVudHJ5X3VubGlua19pbm9kZSgpIHdoZW4gaXQgcmVjb25zdGl0dXRlcyBhbiBleGlz
dGluZwogICAgZGVudHJ5IGFzIGEgbmVnYXRpdmUgZGVudHJ5LgogICAgCiAgICBBY2Nlc3Nv
cnMgcHJvdmlkZWQgYXJlOgogICAgCiAgICAJZF9zZXRfdHlwZShkZW50cnksIHR5cGUpCiAg
ICAJZF9pc19kaXJlY3RvcnkoZGVudHJ5KQogICAgCWRfaXNfYXV0b2RpcihkZW50cnkpCiAg
ICAJZF9pc19zeW1saW5rKGRlbnRyeSkKICAgIAlkX2lzX2ZpbGUoZGVudHJ5KQogICAgCWRf
aXNfbmVnYXRpdmUoZGVudHJ5KQogICAgCWRfaXNfcG9zaXRpdmUoZGVudHJ5KQogICAgCiAg
ICBBIGJ1bmNoIG9mIGNoZWNrcyBpbiBwYXRobmFtZSByZXNvbHV0aW9uIHN3aXRjaGVkIHRv
IHRob3NlLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxs
c0ByZWRoYXQuY29tPgogICAgU2lnbmVkLW9mZi1ieTogQWwgVmlybyA8dmlyb0B6ZW5pdi5s
aW51eC5vcmcudWs+Cgo6MDQwMDAwIDA0MDAwMCAwMDlmMDJlODE1YjliNThjMTg5Mzg0NjUw
MzE0YWMwNzhkMjU3YjlmIGZiMTNlZDdlYTJkYjZjZmRiNThiODIzODFlMTgzM2Y4ZWFjMDJl
OWUgTQlmcwo6MDQwMDAwIDA0MDAwMCAyZTEwZWIxYWQzOWY2OWI4ZGQzOTYyNGJiMDAwMDE5
NzMzZTRkYTIwIGVjMGU1MzIzMTRkNjFmY2Y1OWVkN2ZhNjk3ZjQ3NjRhYzc3ODYzYjkgTQlp
bmNsdWRlCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzktMTEwNy9saW51eC1kZXZlbDpkZXZlbC1jYWly
by14ODZfNjQtMjAxMzExMDcwNTEyOjUwMjM1Y2Q5NzI3YzIwYjA5OTY3YjVjMDYwMDI1ZWFj
OWQwYzgwYmI6YmlzZWN0LXVzYgoKMjAxMy0xMS0wNy0xMjoyOToxNCA1MDIzNWNkOTcyN2My
MGIwOTk2N2I1YzA2MDAyNWVhYzlkMGM4MGJiIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctYzktMTEwNy81MDIzNWNkOTcyN2MyMGIwOTk2N2I1YzA2MDAyNWVhYzlkMGM4MGJi
L3ZtbGludXotMy4xMi4wLXJjNC0wMDA2OC1nNTAyMzVjZAoKMjAxMy0xMS0wNy0xMjoyOTox
NCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLgkxCTIJMy4uCTUJNi4uCTcuCTExCTEzCTE0
Li4JMTUJMTkJMjAJMjEJMjMJMjQJMjUJMjgJMzAJMzEuCTM0LgkzNwkzOS4uCTQzCTQ0CTQ1
Li4JNDgJNTAJNTIJNTQJNTYJNTkJNjAJNjEuLgk2NAk2NQk2OAk2OS4JNzIJNzUJNzcJODIJ
ODMJODcuCTkwCTk1CTk3CTk5CTEwMAkxMDMJMTEyCTExNgkxMTkJMTIwIFNVQ0NFU1MKCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jOS0x
MTA3L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMTEwNzA1MTI6ZjBlMDdm
YjZkZDNkNTMzYjZlYTJkOTFlNzIxYjY4ZDY5NmQ0ZTY0YzpiaXNlY3QtdXNiCiBURVNUIEZB
SUxVUkUKWyAgICAwLjAyMDk4NF0gTW91bnQtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAy
NTYKWyAgICAwLjAyMjE4Ml0gClsgICAgMC4wMjI0ODddID09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQpbICAgIDAuMDI2OTkyXSBbIElORk86IHBvc3Np
YmxlIHJlY3Vyc2l2ZSBsb2NraW5nIGRldGVjdGVkIF0KWyAgICAwLjAyNzk3N10gMy4xMi4w
LTAwNzg0LWdmMGUwN2ZiICMzMTQgTm90IHRhaW50ZWQKWyAgICAwLjAyODg0NV0gLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMC4wMzAwMDBd
IHN3YXBwZXIvMCBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgIDAuMDMwMDAwXSAg
KCZzYi0+c190eXBlLT5pX2xvY2tfa2V5KXsrLisuLi59LCBhdDogWzxmZmZmZmZmZjgxMWJk
YjRjPl0gZF9mbGFnc19mb3JfaW5vZGUrMHgzYy8weGQwClsgICAgMC4wMzAwMDBdIApbICAg
IDAuMDMwMDAwXSBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoKWyAgICAwLjAz
MDAwMF0gICgmc2ItPnNfdHlwZS0+aV9sb2NrX2tleSl7Ky4rLi4ufSwgYXQ6IFs8ZmZmZmZm
ZmY4MTFjMDRjND5dIGRfaW5zdGFudGlhdGUrMHgzNC8weDcwClsgICAgMC4wMzAwMDBdIApb
ICAgIDAuMDMwMDAwXSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlz
OgpbICAgIDAuMDMwMDAwXSAgUG9zc2libGUgdW5zYWZlIGxvY2tpbmcgc2NlbmFyaW86Clsg
ICAgMC4wMzAwMDBdIApbICAgIDAuMDMwMDAwXSAgICAgICAgQ1BVMApbICAgIDAuMDMwMDAw
XSAgICAgICAgLS0tLQpbICAgIDAuMDMwMDAwXSAgIGxvY2soJnNiLT5zX3R5cGUtPmlfbG9j
a19rZXkpOwpbICAgIDAuMDMwMDAwXSAgIGxvY2soJnNiLT5zX3R5cGUtPmlfbG9ja19rZXkp
OwpbICAgIDAuMDMwMDAwXSAKWyAgICAwLjAzMDAwMF0gICoqKiBERUFETE9DSyAqKioKWyAg
ICAwLjAzMDAwMF0gClsgICAgMC4wMzAwMDBdICBNYXkgYmUgZHVlIHRvIG1pc3NpbmcgbG9j
ayBuZXN0aW5nIG5vdGF0aW9uClsgICAgMC4wMzAwMDBdIApbICAgIDAuMDMwMDAwXSAyIGxv
Y2tzIGhlbGQgYnkgc3dhcHBlci8wOgpbICAgIDAuMDMwMDAwXSAgIzA6ICAoJnR5cGUtPnNf
dW1vdW50X2tleS8xKXsrLisuLi59LCBhdDogWzxmZmZmZmZmZjgxMWFiMjg2Pl0gc2dldCsw
eDI2Ni8weDQ0MApbICAgIDAuMDMwMDAwXSAgIzE6ICAoJnNiLT5zX3R5cGUtPmlfbG9ja19r
ZXkpeysuKy4uLn0sIGF0OiBbPGZmZmZmZmZmODExYzA0YzQ+XSBkX2luc3RhbnRpYXRlKzB4
MzQvMHg3MApbICAgIDAuMDMwMDAwXSAKWyAgICAwLjAzMDAwMF0gc3RhY2sgYmFja3RyYWNl
OgpbICAgIDAuMDMwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50
ZWQgMy4xMi4wLTAwNzg0LWdmMGUwN2ZiICMzMTQKWyAgICAwLjAzMDAwMF0gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDMwMDAw
XSAgZmZmZmZmZmY4MmM5OThkMCBmZmZmZmZmZjgyNDAxYzE4IGZmZmZmZmZmODFjMjE1NDAg
ZmZmZmZmZmY4MjQwMWNlMApbICAgIDAuMDMwMDAwXSAgZmZmZmZmZmY4MTExMWZiNyBmZmZm
ZmZmZjgyNDEzNGMwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MjQwMWM1MApbICAgIDAu
MDMwMDAwXSAgZmZmZmZmZmY4MjQxM2FmOCBmZmZmZmZmZjAwMDAwMDAwIDAwMDAwMDAwYzQw
NmUwMzcgZmZmZmZmZmY4MjQxMzRjMApbICAgIDAuMDMwMDAwXSBDYWxsIFRyYWNlOgpbICAg
IDAuMDMwMDAwXSAgWzxmZmZmZmZmZjgxYzIxNTQwPl0gZHVtcF9zdGFjaysweDE5LzB4MWIK
WyAgICAwLjAzMDAwMF0gIFs8ZmZmZmZmZmY4MTExMWZiNz5dIF9fbG9ja19hY3F1aXJlKzB4
MTJkNy8weDFkNjAKWyAgICAwLjAzMDAwMF0gIFs8ZmZmZmZmZmY4MTExMjljYz5dID8gX19s
b2NrX2FjcXVpcmUrMHgxY2VjLzB4MWQ2MApbICAgIDAuMDMwMDAwXSAgWzxmZmZmZmZmZjgx
YzIxMDJmPl0gPyBfX3NsYWJfYWxsb2MuY29uc3Rwcm9wLjYxKzB4M2RjLzB4M2ZhClsgICAg
MC4wMzAwMDBdICBbPGZmZmZmZmZmODExMTM5NGQ+XSBsb2NrX2FjcXVpcmUrMHgxOWQvMHgy
MjAKWyAgICAwLjAzMDAwMF0gIFs8ZmZmZmZmZmY4MTFiZGI0Yz5dID8gZF9mbGFnc19mb3Jf
aW5vZGUrMHgzYy8weGQwClsgICAgMC4wMzAwMDBdICBbPGZmZmZmZmZmODFjMzRjY2I+XSBf
cmF3X3NwaW5fbG9jaysweDNiLzB4NzAKWyAgICAwLjAzMDAwMF0gIFs8ZmZmZmZmZmY4MTFi
ZGI0Yz5dID8gZF9mbGFnc19mb3JfaW5vZGUrMHgzYy8weGQwClsgICAgMC4wMzAwMDBdICBb
PGZmZmZmZmZmODExYmRiNGM+XSBkX2ZsYWdzX2Zvcl9pbm9kZSsweDNjLzB4ZDAKWyAgICAw
LjAzMDAwMF0gIFs8ZmZmZmZmZmY4MTFiZTQ0ZD5dIF9fZF9pbnN0YW50aWF0ZSsweDFkLzB4
ZjAKWyAgICAwLjAzMDAwMF0gIFs8ZmZmZmZmZmY4MTFjMDRjZj5dIGRfaW5zdGFudGlhdGUr
MHgzZi8weDcwClsgICAgMC4wMzAwMDBdICBbPGZmZmZmZmZmODExYzA2NjI+XSBkX21ha2Vf
cm9vdCsweDMyLzB4NjAKWyAgICAwLjAzMDAwMF0gIFs8ZmZmZmZmZmY4MTFmM2ZlOD5dIHN5
c2ZzX21vdW50KzB4MTc4LzB4MjIwClsgICAgMC4wMzAwMDBdICBbPGZmZmZmZmZmODExYWMw
YTM+XSBtb3VudF9mcysweDczLzB4MTkwClsgICAgMC4wMzAwMDBdICBbPGZmZmZmZmZmODEx
Yzk4ZTU+XSB2ZnNfa2Vybl9tb3VudCsweDY1LzB4ZjAKWyAgICAwLjAzMDAwMF0gIFs8ZmZm
ZmZmZmY4MTFjYzRiND5dIGtlcm5fbW91bnRfZGF0YSsweDE0LzB4MzAKWyAgICAwLjAzMDAw
MF0gIFs8ZmZmZmZmZmY4MjdhOWRiMj5dIHN5c2ZzX2luaXQrMHg1NC8weGIzClsgICAgMC4w
MzAwMDBdICBbPGZmZmZmZmZmODI3YTg0ODg+XSBtbnRfaW5pdCsweGNkLzB4MWQ2ClsgICAg
MC4wMzAwMDBdICBbPGZmZmZmZmZmODI3YTgxNTY+XSB2ZnNfY2FjaGVzX2luaXQrMHg5MC8w
eDEwZQpbICAgIDAuMDMwMDAwXSAgWzxmZmZmZmZmZjgyN2FiZjc0Pl0gPyBpbnRlZ3JpdHlf
aWludGNhY2hlX2luaXQrMHgyMy8weDM4ClsgICAgMC4wMzAwMDBdICBbPGZmZmZmZmZmODI3
YWFmZTk+XSA/IHNlY3VyaXR5X2luaXQrMHgzNS8weDQ3ClsgICAgMC4wMzAwMDBdICBbPGZm
ZmZmZmZmODI3ODRlOTg+XSBzdGFydF9rZXJuZWwrMHg0NTYvMHg0OWUKWyAgICAwLjAzMDAw
MF0gIFs8ZmZmZmZmZmY4Mjc4NDg0YT5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHg1ZS8weDVl
ClsgICAgMC4wMzAwMDBdICBbPGZmZmZmZmZmODI3ODQxMjA+XSA/IGVhcmx5X2lkdF9oYW5k
bGVycysweDEyMC8weDEyMApbICAgIDAuMDMwMDAwXSAgWzxmZmZmZmZmZjgyNzg0NTQzPl0g
eDg2XzY0X3N0YXJ0X3Jlc2VydmF0aW9ucysweDJhLzB4MmMKWyAgICAwLjAzMDAwMF0gIFs8
ZmZmZmZmZmY4Mjc4NDYzOD5dIHg4Nl82NF9zdGFydF9rZXJuZWwrMHhmMy8weDEwMgova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvZjBlMDdmYjZkZDNkNTMzYjZlYTJkOTFl
NzIxYjY4ZDY5NmQ0ZTY0Yy9kbWVzZy1xdWFudGFsLWJlbnMtMjoyMDEzMTEwNzA2MjAyODp4
ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3OjMuMTIuMC0wMDc4NC1nZjBlMDdmYjozMTQKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3L2YwZTA3ZmI2ZGQzZDUzM2I2ZWEyZDkx
ZTcyMWI2OGQ2OTZkNGU2NGMvZG1lc2cteW9jdG8tbGtwLXR0MDItNzoyMDEzMTEwNjIzMjgw
MDp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3OjMuMTIuMC0wMDc4NC1nZjBlMDdmYjozMTQK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3L2YwZTA3ZmI2ZGQzZDUzM2I2ZWEy
ZDkxZTcyMWI2OGQ2OTZkNGU2NGMvZG1lc2cteW9jdG8teGlhbi0yNToyMDEzMTEwNzA4NDI0
OTp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3OjMuMTIuMC0wMDc4NC1nZjBlMDdmYjozMTQK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3L2YwZTA3ZmI2ZGQzZDUzM2I2ZWEy
ZDkxZTcyMWI2OGQ2OTZkNGU2NGMvZG1lc2cteW9jdG8tamFrZXRvd24tNDoyMDEzMTEwNzA4
MzIyNTp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3OjMuMTIuMC0wMDc4NC1nZjBlMDdmYjoz
MTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3L2YwZTA3ZmI2ZGQzZDUzM2I2
ZWEyZDkxZTcyMWI2OGQ2OTZkNGU2NGMvZG1lc2cteW9jdG8td2FpbWVhLTEyOjIwMTMxMTA3
MTQwODQzOng4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4xMi4wLTAwNzg0LWdmMGUwN2Zi
OjMxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvZjBlMDdmYjZkZDNkNTMz
YjZlYTJkOTFlNzIxYjY4ZDY5NmQ0ZTY0Yy9kbWVzZy15b2N0by1zdG9ha2xleS00OjIwMTMx
MTA3MDYzNTQ2Ong4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4xMi4wLTAwNzg0LWdmMGUw
N2ZiOjMxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvZjBlMDdmYjZkZDNk
NTMzYjZlYTJkOTFlNzIxYjY4ZDY5NmQ0ZTY0Yy9kbWVzZy15b2N0by1sa3AtdHQwMi01OjIw
MTMxMTA2MjA1NjIwOng4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4xMi4wLTAwNzg0LWdm
MGUwN2ZiOjMxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvZjBlMDdmYjZk
ZDNkNTMzYjZlYTJkOTFlNzIxYjY4ZDY5NmQ0ZTY0Yy9kbWVzZy15b2N0by14cHMtNzoyMDEz
MTEwNzE2MTg1Njp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3OjMuMTIuMC0wMDc4NC1nZjBl
MDdmYjozMTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3L2YwZTA3ZmI2ZGQz
ZDUzM2I2ZWEyZDkxZTcyMWI2OGQ2OTZkNGU2NGMvZG1lc2ctcXVhbnRhbC13YWltZWEtMTM6
MjAxMzExMDcxNjE5MDc6eDg2XzY0LXJhbmRjb25maWctYzktMTEwNzozLjEyLjAtMDA3ODQt
Z2YwZTA3ZmI6MzE0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzktMTEwNy9mMGUwN2Zi
NmRkM2Q1MzNiNmVhMmQ5MWU3MjFiNjhkNjk2ZDRlNjRjL2RtZXNnLXF1YW50YWwtbGtwLXR0
MDItOToyMDEzMTEwNjIzMzEzMDp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3OjMuMTIuMC0w
MDc4NC1nZjBlMDdmYjozMTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3L2Yw
ZTA3ZmI2ZGQzZDUzM2I2ZWEyZDkxZTcyMWI2OGQ2OTZkNGU2NGMvZG1lc2ctcXVhbnRhbC1y
b2FtLTIwOjIwMTMxMTA3MDYyMDM1Ong4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4xMi4w
LTAwNzg0LWdmMGUwN2ZiOjMxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcv
ZjBlMDdmYjZkZDNkNTMzYjZlYTJkOTFlNzIxYjY4ZDY5NmQ0ZTY0Yy9kbWVzZy15b2N0by1s
a3Atc3QwMS0xOjIwMTMxMTA3MTYzMjU0Ong4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4x
Mi4wLTAwNzg0LWdmMGUwN2ZiOjMxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTEx
MDcvZjBlMDdmYjZkZDNkNTMzYjZlYTJkOTFlNzIxYjY4ZDY5NmQ0ZTY0Yy9kbWVzZy15b2N0
by1yb2FtLTM2OjIwMTMxMTA3MDYzOTA2Ong4Nl82NC1yYW5kY29uZmlnLWM5LTExMDc6My4x
Mi4wLTAwNzg0LWdmMGUwN2ZiOjMxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWM5LTEx
MDcvZjBlMDdmYjZkZDNkNTMzYjZlYTJkOTFlNzIxYjY4ZDY5NmQ0ZTY0Yy9kbWVzZy15b2N0
by1sa3Atc3QwMS0xMToyMDEzMTEwNzE0MzM1OTp4ODZfNjQtcmFuZGNvbmZpZy1jOS0xMTA3
OjMuMTIuMC0wMDc4NC1nZjBlMDdmYjozMTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1j
OS0xMTA3L2YwZTA3ZmI2ZGQzZDUzM2I2ZWEyZDkxZTcyMWI2OGQ2OTZkNGU2NGMvZG1lc2ct
cXVhbnRhbC1sa3Atc3QwMS0xOjIwMTMxMTA3MTYzNjMxOng4Nl82NC1yYW5kY29uZmlnLWM5
LTExMDc6My4xMi4wLTAwNzg0LWdmMGUwN2ZiOjMxNAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWM5LTExMDcvZjBlMDdmYjZkZDNkNTMzYjZlYTJkOTFlNzIxYjY4ZDY5NmQ0ZTY0Yy9k
bWVzZy1xdWFudGFsLWlubi0zNzoyMDEzMTEwNzA2MDI1NTp4ODZfNjQtcmFuZGNvbmZpZy1j
OS0xMTA3OjMuMTIuMC0wMDc4NC1nZjBlMDdmYjozMTQKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jOS0xMTA3L2YwZTA3ZmI2ZGQzZDUzM2I2ZWEyZDkxZTcyMWI2OGQ2OTZkNGU2NGMv
ZG1lc2ctcXVhbnRhbC13YWltZWEtMTQ6MjAxMzExMDcxNjMwMzM6eDg2XzY0LXJhbmRjb25m
aWctYzktMTEwNzozLjEyLjAtMDA3ODQtZ2YwZTA3ZmI6MzE0Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzktMTEwNy9mMGUwN2ZiNmRkM2Q1MzNiNmVhMmQ5MWU3MjFiNjhkNjk2ZDRl
NjRjL2RtZXNnLXF1YW50YWwtcm9hbS0zMToyMDEzMTEwNzA2Mzk0Njp4ODZfNjQtcmFuZGNv
bmZpZy1jOS0xMTA3OjMuMTIuMC0wMDc4NC1nZjBlMDdmYjozMTQKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jOS0xMTA3L2YwZTA3ZmI2ZGQzZDUzM2I2ZWEyZDkxZTcyMWI2OGQ2OTZk
NGU2NGMvZG1lc2ctcXVhbnRhbC1zbmItNDoyMDEzMTEwNzA4MzkyODp4ODZfNjQtcmFuZGNv
bmZpZy1jOS0xMTA3OjMuMTIuMC0wMDc4NC1nZjBlMDdmYjozMTQKMDoxOToxOSBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKW2RldGFjaGVkIEhFQUQgZTZlYjQ2Yl0gUmV2ZXJ0ICJW
RlM6IFB1dCBhIHNtYWxsIHR5cGUgZmllbGQgaW50byBzdHJ1Y3QgZGVudHJ5OjpkX2ZsYWdz
IgogMyBmaWxlcyBjaGFuZ2VkLCA4MiBpbnNlcnRpb25zKCspLCAxNjQgZGVsZXRpb25zKC0p
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1j
OS0xMTA3L2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMTEwNzA1MTI6ZTZl
YjQ2YjNlZWUyYzcyMTFhNTY0MjNkZDAyNmI4OGI5Y2UzMGVkNTpiaXNlY3QtdXNiCgoyMDEz
LTExLTA3LTEzOjA2OjUwIGU2ZWI0NmIzZWVlMmM3MjExYTU2NDIzZGQwMjZiODhiOWNlMzBl
ZDUgY29tcGlsaW5nCgoyMDEzLTExLTA3LTEzOjEwOjU5IGRldGVjdGluZyBib290IHN0YXRl
IDMuMTIuMC0wMDc4NS1nZTZlYjQ2Yi4uLi4JMQkxMgkxNgkyMgkyNgkzMgkzNy4JNDkJNjMJ
NzEJNzkJODYJODgJOTkJMTA4CTEyMCBTVUNDRVNTCgoKPT09PT09PT09IHVwc3RyZWFtID09
PT09PT09PQpGZXRjaGluZyBsaW51cwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctYzktMTEwNy9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14
ODZfNjQtMjAxMzExMDcwNTEyOmJlNDA4Y2QzZTFmZWY3M2U5NDA4YjE5NmE3OWI5OTM0Njk3
ZmUzYjE6YmlzZWN0LXVzYgoKMjAxMy0xMS0wNy0xMzoyMTozNCBiZTQwOGNkM2UxZmVmNzNl
OTQwOGIxOTZhNzliOTkzNDY5N2ZlM2IxIGNvbXBpbGluZwoKMjAxMy0xMS0wNy0xMzoyNzoy
NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDAwNDgtZ2JlNDA4Y2QuLi4JNgkxNQky
MQkzMwkzOAk0Mgk4NQkxMTIJMTE5CTEyMCBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5l
eHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWM5LTExMDcvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fp
cm8teDg2XzY0LTIwMTMxMTA3MDUxMjo3ZTgyZWE0MjJjNDJkYjZiOWMwMTg4ZmFlYjk4ZDZl
YzljY2ZlZjhmOmJpc2VjdC11c2IKCjIwMTMtMTEtMDctMTM6MzQ6MzAgN2U4MmVhNDIyYzQy
ZGI2YjljMDE4OGZhZWI5OGQ2ZWM5Y2NmZWY4ZiBjb21waWxpbmcKMjAxMy0xMS0wNy0xMzoz
ODoyMCA3ZTgyZWE0MjJjNDJkYjZiOWMwMTg4ZmFlYjk4ZDZlYzljY2ZlZjhmIFNLSVAgQlJP
S0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9jYy93ZmcvdXNiLWJpc2VjdCBhbmQgL3RtcC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzktMTEwNy83ZTgyZWE0MjJjNDJkYjZiOWMwMTg4
ZmFlYjk4ZDZlYzljY2ZlZjhmCg==

--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-00784-gf0e07fb"

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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_CONSTRUCTORS=y
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
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
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
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
# CONFIG_X86_X2APIC is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
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
CONFIG_MEMTEST=y
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
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
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
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ_CPB is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
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
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
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
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CONNTRACK_SECMARK is not set
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
# CONFIG_NF_NAT_AMANDA is not set
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_SIP=y
# CONFIG_NF_NAT_TFTP is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_NETMAP=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_REDIRECT is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_IPV6 is not set
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
# CONFIG_IP_VS_SH is not set
# CONFIG_IP_VS_SED is not set
# CONFIG_IP_VS_NQ is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=y
CONFIG_IP_VS_NFCT=y

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT_IPV4=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_RAW=y

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
# CONFIG_IP6_NF_FILTER is not set
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP6_NF_RAW is not set
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
# CONFIG_BRIDGE_EBT_T_FILTER is not set
# CONFIG_BRIDGE_EBT_T_NAT is not set
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_IP6=y
# CONFIG_BRIDGE_EBT_LIMIT is not set
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
# CONFIG_BRIDGE_EBT_STP is not set
CONFIG_BRIDGE_EBT_VLAN=y
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
# CONFIG_NET_EMATCH_META is not set
CONFIG_NET_EMATCH_TEXT=y
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
# CONFIG_OPENVSWITCH_GRE is not set
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
# CONFIG_SIGMATEL_FIR is not set
CONFIG_VLSI_FIR=y
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_MLME_DEBUG=y
CONFIG_MAC80211_STA_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_PS_DEBUG is not set
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_RDMA=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
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
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=y
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_DENALI_DT is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_ATMEL_PWM=y
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NET=y
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

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
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_SAMSUNG=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
# CONFIG_MOUSE_PS2_CYPRESS is not set
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_W90X900=y
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
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
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
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
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
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_PINMUX is not set
# CONFIG_PINCONF is not set
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_MAX8998 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_CPU_THERMAL=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_GEODE_WDT=y
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
CONFIG_KEMPLD_WDT=y
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_DA9063 is not set
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
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
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
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
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_ATMEL_PWM is not set
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=y
# CONFIG_SND_USB_6FIRE is not set
CONFIG_SND_USB_HIFACE=y
# CONFIG_SND_FIREWIRE is not set
CONFIG_SND_SOC=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_DESIGNWARE_I2S=y
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SIMPLE_CARD=y
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

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
# CONFIG_USB_DWC3 is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

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
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_SDHCI_PXAV3 is not set
CONFIG_MMC_SDHCI_PXAV2=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_ATMEL_PWM=y
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_DELL_NETBOOKS=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_QIB=y
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_NES=y
# CONFIG_INFINIBAND_NES_DEBUG is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_INTEL_MENLOW=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
# CONFIG_ASUS_NB_WMI is not set
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_DEBUG=y
# CONFIG_COMMON_CLK_WM831X is not set
# CONFIG_COMMON_CLK_MAX77686 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_S2MPS11 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
# CONFIG_INTEL_IOMMU is not set
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
CONFIG_MAX1363=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
# CONFIG_AD5446 is not set
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_APDS9300 is not set
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_UBIFS_FS=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
CONFIG_LOGFS=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
CONFIG_EFIVAR_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
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
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
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
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_PUBLIC_KEY_ALGO_RSA is not set
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_KVM_MMU_AUDIT is not set
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
CONFIG_PERCPU_RWSEM=y
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
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--LpQ9ahxlCli8rRTG--
