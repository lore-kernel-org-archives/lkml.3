Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaJFAvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 20:51:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:15621 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaJFAvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 20:51:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,661,1406617200"; 
   d="log'?scan'208";a="583882110"
Date: Mon, 6 Oct 2014 08:51:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [x86, kaslr] Initramfs unpacking failed: junk in compressed
 archive
Message-ID: <20141006005118.GA3773@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20141006004803.GA4134@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kees,

Here is some less reproducible bugs that are bisected to

commit 6145cfe394a7f138f6b64491c5663f97dba12450
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu Oct 10 17:18:18 2013 -0700
Commit:     H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun Oct 13 03:13:13 2013 -0700

    x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
    
    On 64-bit, this raises the maximum location to -1 GiB (from -1.5 GiB),
    the upper limit currently, since the kernel fixmap page mappings need
    to be moved to use the other 1 GiB (which would be the theoretical
    limit when building with -mcmodel=kernel).
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Link: http://lkml.kernel.org/r/1381450698-28710-7-git-send-email-keescook@chromium.org
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

+--------------------------------+------------+------------+------------+
|                                | f32360ef66 | 6145cfe394 | a4c0475ac1 |
+--------------------------------+------------+------------+------------+
| boot_successes                 | 900        | 291        | 29         |
| boot_failures                  | 0          | 9          | 2          |
| Initramfs_unpacking_failed     | 0          | 7          | 2          |
| BUG:unable_to_handle_kernel    | 0          | 6          | 2          |
| Oops                           | 0          | 1          | 1          |
| EIP_is_at_debug_locks_off      | 0          | 1          | 1          |
| general_protection_fault       | 0          | 1          |            |
| backtrace:set_memory_np        | 0          | 1          |            |
| backtrace:free_init_pages      | 0          | 1          |            |
| backtrace:populate_rootfs      | 0          | 1          |            |
| backtrace:kernel_init_freeable | 0          | 1          |            |
| BUG:kernel_boot_hang           | 0          | 2          |            |
| BUG:unab                       | 0          | 0          | 1          |
+--------------------------------+------------+------------+------------+

[    0.378592] PCI: CLS 0 bytes, default 64
[    0.379897] Unpacking initramfs...
[    0.379897] Unpacking initramfs...
[    0.385074] Initramfs unpacking failed: junk in compressed archive
[    0.385074] Initramfs unpacking failed: junk in compressed archive
[    0.386848] debug: unmapping init [mem 0xd3ca5000-0xd3fd7fff]
[    0.386848] debug: unmapping init [mem 0xd3ca5000-0xd3fd7fff]

git bisect start v3.14 v3.13 --
git bisect  bad 494479038d97f1b9f76fc633a360a681acdf035c  # 03:49    164-      4  Merge tag 'pinctrl-v3.14-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect  bad 1b17366d695c8ab03f98d0155357e97a427e1dce  # 03:52      2-      3  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect  bad 60eaa0190f6b39dce18eb1975d9773ed8bc9a534  # 03:55     11-      4  Merge tag 'trace-3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good 74e8ee8262c3f93bbc41804037b43f07b95897bb  # 04:00    300+     46  Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 02d0a752460ea5dab34ce36c9ddc9c682e846a0d  # 04:03    152-      1  Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
git bisect  bad 82b51734b4f228c76b6064b6e899d9d3d4c17c1a  # 04:05     10-      4  Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
git bisect  bad f4bcd8ccddb02833340652e9f46f5127828eb79d  # 04:08     43-      2  Merge branch 'x86-kaslr-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good fab5669d556200c4dd119af705bff14085845d1e  # 04:14    300+      7  Merge branch 'x86-ras-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 7fe67a1180db49d41a3f764c379a08f8e31580ec  # 04:20    300+     20  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 6145cfe394a7f138f6b64491c5663f97dba12450  # 04:26      0-      2  x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
git bisect good 8ab3820fd5b2896d66da7bb2a906bc382e63e7bc  # 04:33    300+      0  x86, kaslr: Return location from decompress_kernel
git bisect good 82fa9637a2ba285bcc7c5050c73010b2c1b3d803  # 04:41    300+      0  x86, kaslr: Select random position from e820 maps
git bisect good f32360ef6608434a032dc7ad262d45e9693c27f3  # 04:46    300+      0  x86, kaslr: Report kernel offset on panic
# first bad commit: [6145cfe394a7f138f6b64491c5663f97dba12450] x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
git bisect good f32360ef6608434a032dc7ad262d45e9693c27f3  # 04:54    900+      0  x86, kaslr: Report kernel offset on panic
git bisect  bad a4c0475ac1eb67032e759327a40d8d4b2cf2b988  # 04:56      0-      2  ieee802154: 6lowpan: Drop PACKET_OTHERHOST skbs in 6lowpan
git bisect  bad bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9  # 05:18     69-      2  Linux 3.17
git bisect  bad 2e1d004b9645628c64a2db55ef6b81fadf5e6e91  # 05:24     41-      1  Add linux-next specific files for 20141003


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

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
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
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

Thanks,
Fengguang

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb41-10:20141006042747:i386-randconfig-hxb0-1006:3.12.0-rc4-00007-g6145cfe:138"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Linux version 3.12.0-rc4-00007-g6145cfe (kbuild@lkp-hsx02) (=
gcc version 4.9.1 (Debian 4.9.1-11) ) #138 SMP Mon Oct 6 04:25:19 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[c00f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x141fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13000000-0x131fffff]
[    0.000000]  [mem 0x13000000-0x131fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x10000000-0x12ffffff]
[    0.000000]  [mem 0x10000000-0x12ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13200000-0x13fdffff]
[    0.000000]  [mem 0x13200000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x13ca5000-0x13fd7fff]
[    0.000000] ACPI: RSDP 000f0cf0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13fe1854 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 13fe0b37 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 13fe0040 00AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACS 13fe0000 00040
[    0.000000] ACPI: SSDT 13fe0bab 00BF9 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 13fe17a4 00078 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 13fe181c 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, boot clock
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe0 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f00 pte phys: 13e40f00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe1 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f08 pte phys: 13e40f08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe2 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f10 pte phys: 13e40f10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe3 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f18 pte phys: 13e40f18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe4 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f20 pte phys: 13e40f20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe5 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f28 pte phys: 13e40f28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe6 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f30 pte phys: 13e40f30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe7 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f38 pte phys: 13e40f38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe8 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f40 pte phys: 13e40f40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe9 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f48 pte phys: 13e40f48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fea pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f50 pte phys: 13e40f50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13feb pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f58 pte phys: 13e40f58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fec pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f60 pte phys: 13e40f60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fed pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f68 pte phys: 13e40f68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fee pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f70 pte phys: 13e40f70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fef pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f78 pte phys: 13e40f78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff0 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f80 pte phys: 13e40f80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff1 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f88 pte phys: 13e40f88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff2 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f90 pte phys: 13e40f90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff3 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f98 pte phys: 13e40f98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff4 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fa0 pte phys: 13e40fa0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff5 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fa8 pte phys: 13e40fa8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff6 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fb0 pte phys: 13e40fb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff7 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fb8 pte phys: 13e40fb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff8 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fc0 pte phys: 13e40fc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff9 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fc8 pte phys: 13e40fc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffa pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fd0 pte phys: 13e40fd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffb pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fd8 pte phys: 13e40fd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffc pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fe0 pte phys: 13e40fe0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffd pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fe8 pte phys: 13e40fe8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffe pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40ff0 pte phys: 13e40ff0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fff pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40ff8 pte phys: 13e40ff8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14000 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41000 pte phys: 13e41000
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14001 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41008 pte phys: 13e41008
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14002 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41010 pte phys: 13e41010
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14003 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41018 pte phys: 13e41018
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14004 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41020 pte phys: 13e41020
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14005 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41028 pte phys: 13e41028
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14006 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41030 pte phys: 13e41030
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14007 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41038 pte phys: 13e41038
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14008 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41040 pte phys: 13e41040
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14009 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41048 pte phys: 13e41048
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41050 pte phys: 13e41050
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41058 pte phys: 13e41058
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41060 pte phys: 13e41060
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41068 pte phys: 13e41068
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41070 pte phys: 13e41070
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41078 pte phys: 13e41078
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14010 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41080 pte phys: 13e41080
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14011 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41088 pte phys: 13e41088
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14012 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41090 pte phys: 13e41090
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14013 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41098 pte phys: 13e41098
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14014 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410a0 pte phys: 13e410a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14015 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410a8 pte phys: 13e410a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14016 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410b0 pte phys: 13e410b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14017 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410b8 pte phys: 13e410b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14018 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410c0 pte phys: 13e410c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14019 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410c8 pte phys: 13e410c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410d0 pte phys: 13e410d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410d8 pte phys: 13e410d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410e0 pte phys: 13e410e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410e8 pte phys: 13e410e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410f0 pte phys: 13e410f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410f8 pte phys: 13e410f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14020 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41100 pte phys: 13e41100
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14021 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41108 pte phys: 13e41108
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14022 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41110 pte phys: 13e41110
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14023 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41118 pte phys: 13e41118
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14024 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41120 pte phys: 13e41120
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14025 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41128 pte phys: 13e41128
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14026 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41130 pte phys: 13e41130
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14027 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41138 pte phys: 13e41138
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14028 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41140 pte phys: 13e41140
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14029 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41148 pte phys: 13e41148
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41150 pte phys: 13e41150
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41158 pte phys: 13e41158
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41160 pte phys: 13e41160
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41168 pte phys: 13e41168
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41170 pte phys: 13e41170
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41178 pte phys: 13e41178
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14030 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41180 pte phys: 13e41180
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14031 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41188 pte phys: 13e41188
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14032 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41190 pte phys: 13e41190
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14033 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41198 pte phys: 13e41198
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14034 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411a0 pte phys: 13e411a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14035 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411a8 pte phys: 13e411a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14036 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411b0 pte phys: 13e411b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14037 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411b8 pte phys: 13e411b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14038 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411c0 pte phys: 13e411c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14039 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411c8 pte phys: 13e411c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411d0 pte phys: 13e411d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411d8 pte phys: 13e411d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411e0 pte phys: 13e411e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411e8 pte phys: 13e411e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411f0 pte phys: 13e411f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411f8 pte phys: 13e411f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14040 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41200 pte phys: 13e41200
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14041 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41208 pte phys: 13e41208
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14042 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41210 pte phys: 13e41210
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14043 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41218 pte phys: 13e41218
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14044 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41220 pte phys: 13e41220
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14045 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41228 pte phys: 13e41228
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14046 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41230 pte phys: 13e41230
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14047 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41238 pte phys: 13e41238
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14048 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41240 pte phys: 13e41240
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14049 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41248 pte phys: 13e41248
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41250 pte phys: 13e41250
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41258 pte phys: 13e41258
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41260 pte phys: 13e41260
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41268 pte phys: 13e41268
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41270 pte phys: 13e41270
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41278 pte phys: 13e41278
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14050 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41280 pte phys: 13e41280
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14051 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41288 pte phys: 13e41288
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14052 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41290 pte phys: 13e41290
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14053 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41298 pte phys: 13e41298
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14054 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412a0 pte phys: 13e412a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14055 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412a8 pte phys: 13e412a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14056 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412b0 pte phys: 13e412b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14057 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412b8 pte phys: 13e412b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14058 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412c0 pte phys: 13e412c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14059 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412c8 pte phys: 13e412c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412d0 pte phys: 13e412d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412d8 pte phys: 13e412d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412e0 pte phys: 13e412e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412e8 pte phys: 13e412e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412f0 pte phys: 13e412f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412f8 pte phys: 13e412f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14060 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41300 pte phys: 13e41300
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14061 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41308 pte phys: 13e41308
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14062 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41310 pte phys: 13e41310
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14063 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41318 pte phys: 13e41318
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14064 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41320 pte phys: 13e41320
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14065 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41328 pte phys: 13e41328
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14066 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41330 pte phys: 13e41330
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14067 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41338 pte phys: 13e41338
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14068 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41340 pte phys: 13e41340
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14069 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41348 pte phys: 13e41348
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41350 pte phys: 13e41350
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41358 pte phys: 13e41358
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41360 pte phys: 13e41360
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41368 pte phys: 13e41368
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41370 pte phys: 13e41370
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41378 pte phys: 13e41378
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14070 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41380 pte phys: 13e41380
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14071 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41388 pte phys: 13e41388
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14072 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41390 pte phys: 13e41390
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14073 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41398 pte phys: 13e41398
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14074 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413a0 pte phys: 13e413a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14075 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413a8 pte phys: 13e413a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14076 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413b0 pte phys: 13e413b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14077 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413b8 pte phys: 13e413b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14078 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413c0 pte phys: 13e413c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14079 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413c8 pte phys: 13e413c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413d0 pte phys: 13e413d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413d8 pte phys: 13e413d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413e0 pte phys: 13e413e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413e8 pte phys: 13e413e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413f0 pte phys: 13e413f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413f8 pte phys: 13e413f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14080 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41400 pte phys: 13e41400
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14081 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41408 pte phys: 13e41408
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14082 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41410 pte phys: 13e41410
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14083 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41418 pte phys: 13e41418
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14084 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41420 pte phys: 13e41420
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14085 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41428 pte phys: 13e41428
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14086 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41430 pte phys: 13e41430
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14087 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41438 pte phys: 13e41438
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14088 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41440 pte phys: 13e41440
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14089 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41448 pte phys: 13e41448
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41450 pte phys: 13e41450
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41458 pte phys: 13e41458
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41460 pte phys: 13e41460
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41468 pte phys: 13e41468
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41470 pte phys: 13e41470
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41478 pte phys: 13e41478
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14090 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41480 pte phys: 13e41480
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14091 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41488 pte phys: 13e41488
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14092 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41490 pte phys: 13e41490
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14093 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41498 pte phys: 13e41498
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14094 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414a0 pte phys: 13e414a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14095 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414a8 pte phys: 13e414a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14096 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414b0 pte phys: 13e414b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14097 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414b8 pte phys: 13e414b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14098 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414c0 pte phys: 13e414c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14099 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414c8 pte phys: 13e414c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414d0 pte phys: 13e414d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414d8 pte phys: 13e414d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414e0 pte phys: 13e414e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414e8 pte phys: 13e414e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414f0 pte phys: 13e414f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414f8 pte phys: 13e414f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41500 pte phys: 13e41500
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41508 pte phys: 13e41508
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41510 pte phys: 13e41510
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41518 pte phys: 13e41518
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41520 pte phys: 13e41520
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41528 pte phys: 13e41528
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41530 pte phys: 13e41530
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41538 pte phys: 13e41538
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41540 pte phys: 13e41540
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41548 pte phys: 13e41548
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140aa pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41550 pte phys: 13e41550
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ab pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41558 pte phys: 13e41558
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ac pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41560 pte phys: 13e41560
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ad pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41568 pte phys: 13e41568
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ae pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41570 pte phys: 13e41570
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140af pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41578 pte phys: 13e41578
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41580 pte phys: 13e41580
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41588 pte phys: 13e41588
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41590 pte phys: 13e41590
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41598 pte phys: 13e41598
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415a0 pte phys: 13e415a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415a8 pte phys: 13e415a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415b0 pte phys: 13e415b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415b8 pte phys: 13e415b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415c0 pte phys: 13e415c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415c8 pte phys: 13e415c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ba pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415d0 pte phys: 13e415d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140bb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415d8 pte phys: 13e415d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140bc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415e0 pte phys: 13e415e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140bd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415e8 pte phys: 13e415e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140be pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415f0 pte phys: 13e415f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140bf pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415f8 pte phys: 13e415f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41600 pte phys: 13e41600
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41608 pte phys: 13e41608
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41610 pte phys: 13e41610
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41618 pte phys: 13e41618
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41620 pte phys: 13e41620
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41628 pte phys: 13e41628
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41630 pte phys: 13e41630
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41638 pte phys: 13e41638
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41640 pte phys: 13e41640
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41648 pte phys: 13e41648
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ca pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41650 pte phys: 13e41650
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140cb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41658 pte phys: 13e41658
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140cc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41660 pte phys: 13e41660
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140cd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41668 pte phys: 13e41668
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ce pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41670 pte phys: 13e41670
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140cf pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41678 pte phys: 13e41678
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41680 pte phys: 13e41680
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41688 pte phys: 13e41688
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41690 pte phys: 13e41690
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41698 pte phys: 13e41698
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416a0 pte phys: 13e416a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416a8 pte phys: 13e416a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416b0 pte phys: 13e416b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416b8 pte phys: 13e416b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416c0 pte phys: 13e416c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416c8 pte phys: 13e416c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140da pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416d0 pte phys: 13e416d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140db pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416d8 pte phys: 13e416d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140dc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416e0 pte phys: 13e416e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140dd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416e8 pte phys: 13e416e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140de pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416f0 pte phys: 13e416f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140df pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416f8 pte phys: 13e416f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41700 pte phys: 13e41700
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41708 pte phys: 13e41708
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41710 pte phys: 13e41710
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41718 pte phys: 13e41718
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41720 pte phys: 13e41720
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41728 pte phys: 13e41728
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41730 pte phys: 13e41730
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41738 pte phys: 13e41738
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41740 pte phys: 13e41740
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41748 pte phys: 13e41748
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ea pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41750 pte phys: 13e41750
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140eb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41758 pte phys: 13e41758
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ec pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41760 pte phys: 13e41760
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ed pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41768 pte phys: 13e41768
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ee pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41770 pte phys: 13e41770
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ef pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41778 pte phys: 13e41778
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41780 pte phys: 13e41780
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41788 pte phys: 13e41788
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41790 pte phys: 13e41790
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41798 pte phys: 13e41798
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417a0 pte phys: 13e417a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417a8 pte phys: 13e417a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417b0 pte phys: 13e417b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417b8 pte phys: 13e417b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417c0 pte phys: 13e417c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417c8 pte phys: 13e417c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fa pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417d0 pte phys: 13e417d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417d8 pte phys: 13e417d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417e0 pte phys: 13e417e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417e8 pte phys: 13e417e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fe pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417f0 pte phys: 13e417f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ff pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417f8 pte phys: 13e417f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14100 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41800 pte phys: 13e41800
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14101 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41808 pte phys: 13e41808
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14102 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41810 pte phys: 13e41810
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14103 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41818 pte phys: 13e41818
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14104 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41820 pte phys: 13e41820
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14105 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41828 pte phys: 13e41828
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14106 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41830 pte phys: 13e41830
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14107 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41838 pte phys: 13e41838
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14108 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41840 pte phys: 13e41840
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14109 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41848 pte phys: 13e41848
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41850 pte phys: 13e41850
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41858 pte phys: 13e41858
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41860 pte phys: 13e41860
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41868 pte phys: 13e41868
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41870 pte phys: 13e41870
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41878 pte phys: 13e41878
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14110 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41880 pte phys: 13e41880
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14111 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41888 pte phys: 13e41888
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14112 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41890 pte phys: 13e41890
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14113 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41898 pte phys: 13e41898
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14114 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418a0 pte phys: 13e418a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14115 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418a8 pte phys: 13e418a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14116 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418b0 pte phys: 13e418b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14117 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418b8 pte phys: 13e418b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14118 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418c0 pte phys: 13e418c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14119 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418c8 pte phys: 13e418c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418d0 pte phys: 13e418d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418d8 pte phys: 13e418d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418e0 pte phys: 13e418e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418e8 pte phys: 13e418e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418f0 pte phys: 13e418f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418f8 pte phys: 13e418f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14120 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41900 pte phys: 13e41900
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14121 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41908 pte phys: 13e41908
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14122 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41910 pte phys: 13e41910
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14123 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41918 pte phys: 13e41918
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14124 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41920 pte phys: 13e41920
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14125 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41928 pte phys: 13e41928
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14126 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41930 pte phys: 13e41930
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14127 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41938 pte phys: 13e41938
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14128 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41940 pte phys: 13e41940
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14129 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41948 pte phys: 13e41948
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41950 pte phys: 13e41950
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41958 pte phys: 13e41958
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41960 pte phys: 13e41960
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41968 pte phys: 13e41968
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41970 pte phys: 13e41970
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41978 pte phys: 13e41978
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14130 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41980 pte phys: 13e41980
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14131 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41988 pte phys: 13e41988
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14132 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41990 pte phys: 13e41990
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14133 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41998 pte phys: 13e41998
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14134 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419a0 pte phys: 13e419a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14135 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419a8 pte phys: 13e419a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14136 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419b0 pte phys: 13e419b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14137 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419b8 pte phys: 13e419b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14138 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419c0 pte phys: 13e419c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14139 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419c8 pte phys: 13e419c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419d0 pte phys: 13e419d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419d8 pte phys: 13e419d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419e0 pte phys: 13e419e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419e8 pte phys: 13e419e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419f0 pte phys: 13e419f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419f8 pte phys: 13e419f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14140 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a00 pte phys: 13e41a00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14141 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a08 pte phys: 13e41a08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14142 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a10 pte phys: 13e41a10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14143 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a18 pte phys: 13e41a18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14144 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a20 pte phys: 13e41a20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14145 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a28 pte phys: 13e41a28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14146 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a30 pte phys: 13e41a30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14147 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a38 pte phys: 13e41a38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14148 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a40 pte phys: 13e41a40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14149 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a48 pte phys: 13e41a48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a50 pte phys: 13e41a50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a58 pte phys: 13e41a58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a60 pte phys: 13e41a60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a68 pte phys: 13e41a68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a70 pte phys: 13e41a70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a78 pte phys: 13e41a78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14150 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a80 pte phys: 13e41a80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14151 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a88 pte phys: 13e41a88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14152 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a90 pte phys: 13e41a90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14153 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a98 pte phys: 13e41a98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14154 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41aa0 pte phys: 13e41aa0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14155 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41aa8 pte phys: 13e41aa8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14156 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ab0 pte phys: 13e41ab0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14157 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ab8 pte phys: 13e41ab8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14158 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ac0 pte phys: 13e41ac0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14159 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ac8 pte phys: 13e41ac8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ad0 pte phys: 13e41ad0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ad8 pte phys: 13e41ad8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ae0 pte phys: 13e41ae0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ae8 pte phys: 13e41ae8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41af0 pte phys: 13e41af0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41af8 pte phys: 13e41af8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14160 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b00 pte phys: 13e41b00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14161 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b08 pte phys: 13e41b08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14162 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b10 pte phys: 13e41b10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14163 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b18 pte phys: 13e41b18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14164 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b20 pte phys: 13e41b20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14165 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b28 pte phys: 13e41b28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14166 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b30 pte phys: 13e41b30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14167 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b38 pte phys: 13e41b38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14168 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b40 pte phys: 13e41b40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14169 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b48 pte phys: 13e41b48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b50 pte phys: 13e41b50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b58 pte phys: 13e41b58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b60 pte phys: 13e41b60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b68 pte phys: 13e41b68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b70 pte phys: 13e41b70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b78 pte phys: 13e41b78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14170 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b80 pte phys: 13e41b80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14171 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b88 pte phys: 13e41b88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14172 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b90 pte phys: 13e41b90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14173 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b98 pte phys: 13e41b98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14174 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ba0 pte phys: 13e41ba0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14175 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ba8 pte phys: 13e41ba8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14176 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bb0 pte phys: 13e41bb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14177 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bb8 pte phys: 13e41bb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14178 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bc0 pte phys: 13e41bc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14179 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bc8 pte phys: 13e41bc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bd0 pte phys: 13e41bd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bd8 pte phys: 13e41bd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41be0 pte phys: 13e41be0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41be8 pte phys: 13e41be8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bf0 pte phys: 13e41bf0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bf8 pte phys: 13e41bf8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14180 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c00 pte phys: 13e41c00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14181 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c08 pte phys: 13e41c08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14182 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c10 pte phys: 13e41c10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14183 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c18 pte phys: 13e41c18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14184 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c20 pte phys: 13e41c20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14185 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c28 pte phys: 13e41c28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14186 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c30 pte phys: 13e41c30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14187 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c38 pte phys: 13e41c38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14188 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c40 pte phys: 13e41c40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14189 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c48 pte phys: 13e41c48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c50 pte phys: 13e41c50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c58 pte phys: 13e41c58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c60 pte phys: 13e41c60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c68 pte phys: 13e41c68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c70 pte phys: 13e41c70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c78 pte phys: 13e41c78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14190 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c80 pte phys: 13e41c80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14191 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c88 pte phys: 13e41c88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14192 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c90 pte phys: 13e41c90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14193 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c98 pte phys: 13e41c98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14194 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ca0 pte phys: 13e41ca0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14195 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ca8 pte phys: 13e41ca8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14196 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cb0 pte phys: 13e41cb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14197 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cb8 pte phys: 13e41cb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14198 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cc0 pte phys: 13e41cc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14199 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cc8 pte phys: 13e41cc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cd0 pte phys: 13e41cd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cd8 pte phys: 13e41cd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ce0 pte phys: 13e41ce0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ce8 pte phys: 13e41ce8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cf0 pte phys: 13e41cf0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cf8 pte phys: 13e41cf8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d00 pte phys: 13e41d00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d08 pte phys: 13e41d08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d10 pte phys: 13e41d10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d18 pte phys: 13e41d18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d20 pte phys: 13e41d20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d28 pte phys: 13e41d28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d30 pte phys: 13e41d30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d38 pte phys: 13e41d38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d40 pte phys: 13e41d40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d48 pte phys: 13e41d48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141aa pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d50 pte phys: 13e41d50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ab pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d58 pte phys: 13e41d58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ac pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d60 pte phys: 13e41d60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ad pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d68 pte phys: 13e41d68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ae pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d70 pte phys: 13e41d70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141af pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d78 pte phys: 13e41d78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d80 pte phys: 13e41d80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d88 pte phys: 13e41d88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d90 pte phys: 13e41d90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d98 pte phys: 13e41d98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41da0 pte phys: 13e41da0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41da8 pte phys: 13e41da8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41db0 pte phys: 13e41db0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41db8 pte phys: 13e41db8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41dc0 pte phys: 13e41dc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41dc8 pte phys: 13e41dc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ba pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41dd0 pte phys: 13e41dd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141bb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41dd8 pte phys: 13e41dd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141bc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41de0 pte phys: 13e41de0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141bd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41de8 pte phys: 13e41de8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141be pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41df0 pte phys: 13e41df0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141bf pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41df8 pte phys: 13e41df8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e00 pte phys: 13e41e00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e08 pte phys: 13e41e08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e10 pte phys: 13e41e10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e18 pte phys: 13e41e18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e20 pte phys: 13e41e20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e28 pte phys: 13e41e28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e30 pte phys: 13e41e30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e38 pte phys: 13e41e38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e40 pte phys: 13e41e40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e48 pte phys: 13e41e48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ca pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e50 pte phys: 13e41e50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141cb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e58 pte phys: 13e41e58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141cc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e60 pte phys: 13e41e60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141cd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e68 pte phys: 13e41e68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ce pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e70 pte phys: 13e41e70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141cf pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e78 pte phys: 13e41e78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e80 pte phys: 13e41e80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e88 pte phys: 13e41e88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e90 pte phys: 13e41e90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e98 pte phys: 13e41e98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ea0 pte phys: 13e41ea0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ea8 pte phys: 13e41ea8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41eb0 pte phys: 13e41eb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41eb8 pte phys: 13e41eb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ec0 pte phys: 13e41ec0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ec8 pte phys: 13e41ec8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141da pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ed0 pte phys: 13e41ed0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141db pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ed8 pte phys: 13e41ed8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141dc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ee0 pte phys: 13e41ee0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141dd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ee8 pte phys: 13e41ee8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141de pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ef0 pte phys: 13e41ef0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141df pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ef8 pte phys: 13e41ef8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f00 pte phys: 13e41f00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f08 pte phys: 13e41f08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f10 pte phys: 13e41f10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f18 pte phys: 13e41f18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f20 pte phys: 13e41f20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f28 pte phys: 13e41f28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f30 pte phys: 13e41f30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f38 pte phys: 13e41f38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f40 pte phys: 13e41f40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f48 pte phys: 13e41f48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ea pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f50 pte phys: 13e41f50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141eb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f58 pte phys: 13e41f58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ec pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f60 pte phys: 13e41f60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ed pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f68 pte phys: 13e41f68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ee pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f70 pte phys: 13e41f70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ef pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f78 pte phys: 13e41f78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f80 pte phys: 13e41f80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f88 pte phys: 13e41f88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f90 pte phys: 13e41f90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f98 pte phys: 13e41f98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fa0 pte phys: 13e41fa0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fa8 pte phys: 13e41fa8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fb0 pte phys: 13e41fb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fb8 pte phys: 13e41fb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fc0 pte phys: 13e41fc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fc8 pte phys: 13e41fc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fa pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fd0 pte phys: 13e41fd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fd8 pte phys: 13e41fd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fe0 pte phys: 13e41fe0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fe8 pte phys: 13e41fe8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fe pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ff0 pte phys: 13e41ff0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ff pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ff8 pte phys: 13e41ff8
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat d379db00, node_mem_map d2=
f30024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @d2de4000 s1338112 r0 d13568 =
u1351680
[    0.000000] pcpu-alloc: s1338112 r0 d13568 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12de65c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81070
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-hxb0-1006/bluetooth:master:6145cfe394a7f138f6b64491c5663f97dba124=
50:bisect-linux-4/.vmlinuz-6145cfe394a7f138f6b64491c5663f97dba12450-2014100=
6042522-5-ivb41 branch=3Dbluetooth/master BOOT_IMAGE=3D/kernel/i386-randcon=
fig-hxb0-1006/6145cfe394a7f138f6b64491c5663f97dba12450/vmlinuz-3.12.0-rc4-0=
0007-g6145cfe drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 308284K/327160K available (3281K kernel code, 512K r=
wdata, 1964K rodata, 1628K init, 4504K bss, 18876K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xffd33000   ( 693 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xd37a2000 - 0xd3939000   (1628 kB)
[    0.000000]       .data : 0xd3534a25 - 0xd37a1380   (2482 kB)
[    0.000000]       .text : 0xd3200000 - 0xd3534a25   (3282 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dd280a000 soft=3Dd280c000
[    0.000000] Linux version 3.12.0-rc4-00007-g6145cfe (kbuild@lkp-hsx02) (=
gcc version 4.9.1 (Debian 4.9.1-11) ) #138 SMP Mon Oct 6 04:25:19 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[c00f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x141fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13000000-0x131fffff]
[    0.000000]  [mem 0x13000000-0x131fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x10000000-0x12ffffff]
[    0.000000]  [mem 0x10000000-0x12ffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13200000-0x13fdffff]
[    0.000000]  [mem 0x13200000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x13ca5000-0x13fd7fff]
[    0.000000] ACPI: RSDP 000f0cf0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13fe1854 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 13fe0b37 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 13fe0040 00AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACS 13fe0000 00040
[    0.000000] ACPI: SSDT 13fe0bab 00BF9 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 13fe17a4 00078 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 13fe181c 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, boot clock
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe0 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f00 pte phys: 13e40f00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe1 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f08 pte phys: 13e40f08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe2 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f10 pte phys: 13e40f10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe3 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f18 pte phys: 13e40f18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe4 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f20 pte phys: 13e40f20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe5 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f28 pte phys: 13e40f28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe6 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f30 pte phys: 13e40f30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe7 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f38 pte phys: 13e40f38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe8 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f40 pte phys: 13e40f40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fe9 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f48 pte phys: 13e40f48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fea pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f50 pte phys: 13e40f50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13feb pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f58 pte phys: 13e40f58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fec pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f60 pte phys: 13e40f60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fed pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f68 pte phys: 13e40f68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fee pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f70 pte phys: 13e40f70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fef pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f78 pte phys: 13e40f78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff0 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f80 pte phys: 13e40f80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff1 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f88 pte phys: 13e40f88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff2 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f90 pte phys: 13e40f90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff3 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40f98 pte phys: 13e40f98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff4 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fa0 pte phys: 13e40fa0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff5 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fa8 pte phys: 13e40fa8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff6 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fb0 pte phys: 13e40fb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff7 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fb8 pte phys: 13e40fb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff8 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fc0 pte phys: 13e40fc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ff9 pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fc8 pte phys: 13e40fc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffa pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fd0 pte phys: 13e40fd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffb pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fd8 pte phys: 13e40fd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffc pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fe0 pte phys: 13e40fe0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffd pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40fe8 pte phys: 13e40fe8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13ffe pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40ff0 pte phys: 13e40ff0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 13fff pmd: d393=
b4f8 pmd phys: 1393b4f8 pte: d3e40ff8 pte phys: 13e40ff8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14000 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41000 pte phys: 13e41000
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14001 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41008 pte phys: 13e41008
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14002 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41010 pte phys: 13e41010
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14003 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41018 pte phys: 13e41018
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14004 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41020 pte phys: 13e41020
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14005 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41028 pte phys: 13e41028
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14006 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41030 pte phys: 13e41030
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14007 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41038 pte phys: 13e41038
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14008 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41040 pte phys: 13e41040
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14009 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41048 pte phys: 13e41048
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41050 pte phys: 13e41050
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41058 pte phys: 13e41058
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41060 pte phys: 13e41060
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41068 pte phys: 13e41068
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41070 pte phys: 13e41070
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1400f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41078 pte phys: 13e41078
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14010 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41080 pte phys: 13e41080
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14011 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41088 pte phys: 13e41088
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14012 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41090 pte phys: 13e41090
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14013 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41098 pte phys: 13e41098
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14014 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410a0 pte phys: 13e410a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14015 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410a8 pte phys: 13e410a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14016 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410b0 pte phys: 13e410b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14017 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410b8 pte phys: 13e410b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14018 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410c0 pte phys: 13e410c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14019 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410c8 pte phys: 13e410c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410d0 pte phys: 13e410d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410d8 pte phys: 13e410d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410e0 pte phys: 13e410e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410e8 pte phys: 13e410e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410f0 pte phys: 13e410f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1401f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e410f8 pte phys: 13e410f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14020 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41100 pte phys: 13e41100
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14021 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41108 pte phys: 13e41108
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14022 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41110 pte phys: 13e41110
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14023 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41118 pte phys: 13e41118
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14024 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41120 pte phys: 13e41120
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14025 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41128 pte phys: 13e41128
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14026 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41130 pte phys: 13e41130
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14027 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41138 pte phys: 13e41138
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14028 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41140 pte phys: 13e41140
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14029 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41148 pte phys: 13e41148
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41150 pte phys: 13e41150
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41158 pte phys: 13e41158
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41160 pte phys: 13e41160
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41168 pte phys: 13e41168
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41170 pte phys: 13e41170
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1402f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41178 pte phys: 13e41178
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14030 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41180 pte phys: 13e41180
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14031 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41188 pte phys: 13e41188
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14032 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41190 pte phys: 13e41190
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14033 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41198 pte phys: 13e41198
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14034 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411a0 pte phys: 13e411a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14035 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411a8 pte phys: 13e411a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14036 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411b0 pte phys: 13e411b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14037 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411b8 pte phys: 13e411b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14038 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411c0 pte phys: 13e411c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14039 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411c8 pte phys: 13e411c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411d0 pte phys: 13e411d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411d8 pte phys: 13e411d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411e0 pte phys: 13e411e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411e8 pte phys: 13e411e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411f0 pte phys: 13e411f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1403f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e411f8 pte phys: 13e411f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14040 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41200 pte phys: 13e41200
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14041 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41208 pte phys: 13e41208
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14042 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41210 pte phys: 13e41210
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14043 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41218 pte phys: 13e41218
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14044 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41220 pte phys: 13e41220
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14045 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41228 pte phys: 13e41228
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14046 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41230 pte phys: 13e41230
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14047 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41238 pte phys: 13e41238
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14048 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41240 pte phys: 13e41240
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14049 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41248 pte phys: 13e41248
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41250 pte phys: 13e41250
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41258 pte phys: 13e41258
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41260 pte phys: 13e41260
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41268 pte phys: 13e41268
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41270 pte phys: 13e41270
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1404f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41278 pte phys: 13e41278
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14050 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41280 pte phys: 13e41280
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14051 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41288 pte phys: 13e41288
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14052 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41290 pte phys: 13e41290
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14053 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41298 pte phys: 13e41298
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14054 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412a0 pte phys: 13e412a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14055 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412a8 pte phys: 13e412a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14056 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412b0 pte phys: 13e412b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14057 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412b8 pte phys: 13e412b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14058 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412c0 pte phys: 13e412c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14059 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412c8 pte phys: 13e412c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412d0 pte phys: 13e412d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412d8 pte phys: 13e412d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412e0 pte phys: 13e412e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412e8 pte phys: 13e412e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412f0 pte phys: 13e412f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1405f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e412f8 pte phys: 13e412f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14060 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41300 pte phys: 13e41300
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14061 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41308 pte phys: 13e41308
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14062 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41310 pte phys: 13e41310
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14063 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41318 pte phys: 13e41318
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14064 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41320 pte phys: 13e41320
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14065 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41328 pte phys: 13e41328
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14066 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41330 pte phys: 13e41330
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14067 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41338 pte phys: 13e41338
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14068 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41340 pte phys: 13e41340
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14069 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41348 pte phys: 13e41348
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41350 pte phys: 13e41350
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41358 pte phys: 13e41358
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41360 pte phys: 13e41360
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41368 pte phys: 13e41368
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41370 pte phys: 13e41370
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1406f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41378 pte phys: 13e41378
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14070 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41380 pte phys: 13e41380
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14071 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41388 pte phys: 13e41388
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14072 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41390 pte phys: 13e41390
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14073 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41398 pte phys: 13e41398
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14074 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413a0 pte phys: 13e413a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14075 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413a8 pte phys: 13e413a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14076 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413b0 pte phys: 13e413b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14077 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413b8 pte phys: 13e413b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14078 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413c0 pte phys: 13e413c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14079 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413c8 pte phys: 13e413c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413d0 pte phys: 13e413d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413d8 pte phys: 13e413d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413e0 pte phys: 13e413e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413e8 pte phys: 13e413e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413f0 pte phys: 13e413f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1407f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e413f8 pte phys: 13e413f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14080 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41400 pte phys: 13e41400
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14081 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41408 pte phys: 13e41408
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14082 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41410 pte phys: 13e41410
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14083 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41418 pte phys: 13e41418
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14084 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41420 pte phys: 13e41420
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14085 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41428 pte phys: 13e41428
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14086 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41430 pte phys: 13e41430
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14087 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41438 pte phys: 13e41438
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14088 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41440 pte phys: 13e41440
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14089 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41448 pte phys: 13e41448
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41450 pte phys: 13e41450
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41458 pte phys: 13e41458
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41460 pte phys: 13e41460
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41468 pte phys: 13e41468
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41470 pte phys: 13e41470
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1408f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41478 pte phys: 13e41478
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14090 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41480 pte phys: 13e41480
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14091 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41488 pte phys: 13e41488
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14092 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41490 pte phys: 13e41490
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14093 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41498 pte phys: 13e41498
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14094 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414a0 pte phys: 13e414a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14095 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414a8 pte phys: 13e414a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14096 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414b0 pte phys: 13e414b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14097 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414b8 pte phys: 13e414b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14098 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414c0 pte phys: 13e414c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14099 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414c8 pte phys: 13e414c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414d0 pte phys: 13e414d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414d8 pte phys: 13e414d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414e0 pte phys: 13e414e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414e8 pte phys: 13e414e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414f0 pte phys: 13e414f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1409f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e414f8 pte phys: 13e414f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41500 pte phys: 13e41500
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41508 pte phys: 13e41508
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41510 pte phys: 13e41510
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41518 pte phys: 13e41518
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41520 pte phys: 13e41520
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41528 pte phys: 13e41528
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41530 pte phys: 13e41530
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41538 pte phys: 13e41538
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41540 pte phys: 13e41540
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140a9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41548 pte phys: 13e41548
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140aa pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41550 pte phys: 13e41550
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ab pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41558 pte phys: 13e41558
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ac pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41560 pte phys: 13e41560
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ad pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41568 pte phys: 13e41568
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ae pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41570 pte phys: 13e41570
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140af pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41578 pte phys: 13e41578
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41580 pte phys: 13e41580
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41588 pte phys: 13e41588
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41590 pte phys: 13e41590
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41598 pte phys: 13e41598
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415a0 pte phys: 13e415a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415a8 pte phys: 13e415a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415b0 pte phys: 13e415b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415b8 pte phys: 13e415b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415c0 pte phys: 13e415c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140b9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415c8 pte phys: 13e415c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ba pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415d0 pte phys: 13e415d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140bb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415d8 pte phys: 13e415d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140bc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415e0 pte phys: 13e415e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140bd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415e8 pte phys: 13e415e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140be pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415f0 pte phys: 13e415f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140bf pmd: d393=
b500 pmd phys: 1393b500 pte: d3e415f8 pte phys: 13e415f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41600 pte phys: 13e41600
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41608 pte phys: 13e41608
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41610 pte phys: 13e41610
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41618 pte phys: 13e41618
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41620 pte phys: 13e41620
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41628 pte phys: 13e41628
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41630 pte phys: 13e41630
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41638 pte phys: 13e41638
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41640 pte phys: 13e41640
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140c9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41648 pte phys: 13e41648
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ca pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41650 pte phys: 13e41650
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140cb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41658 pte phys: 13e41658
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140cc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41660 pte phys: 13e41660
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140cd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41668 pte phys: 13e41668
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ce pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41670 pte phys: 13e41670
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140cf pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41678 pte phys: 13e41678
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41680 pte phys: 13e41680
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41688 pte phys: 13e41688
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41690 pte phys: 13e41690
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41698 pte phys: 13e41698
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416a0 pte phys: 13e416a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416a8 pte phys: 13e416a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416b0 pte phys: 13e416b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416b8 pte phys: 13e416b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416c0 pte phys: 13e416c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140d9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416c8 pte phys: 13e416c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140da pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416d0 pte phys: 13e416d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140db pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416d8 pte phys: 13e416d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140dc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416e0 pte phys: 13e416e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140dd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416e8 pte phys: 13e416e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140de pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416f0 pte phys: 13e416f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140df pmd: d393=
b500 pmd phys: 1393b500 pte: d3e416f8 pte phys: 13e416f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41700 pte phys: 13e41700
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41708 pte phys: 13e41708
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41710 pte phys: 13e41710
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41718 pte phys: 13e41718
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41720 pte phys: 13e41720
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41728 pte phys: 13e41728
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41730 pte phys: 13e41730
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41738 pte phys: 13e41738
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41740 pte phys: 13e41740
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140e9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41748 pte phys: 13e41748
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ea pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41750 pte phys: 13e41750
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140eb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41758 pte phys: 13e41758
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ec pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41760 pte phys: 13e41760
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ed pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41768 pte phys: 13e41768
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ee pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41770 pte phys: 13e41770
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ef pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41778 pte phys: 13e41778
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41780 pte phys: 13e41780
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41788 pte phys: 13e41788
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41790 pte phys: 13e41790
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41798 pte phys: 13e41798
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417a0 pte phys: 13e417a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417a8 pte phys: 13e417a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417b0 pte phys: 13e417b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417b8 pte phys: 13e417b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417c0 pte phys: 13e417c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140f9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417c8 pte phys: 13e417c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fa pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417d0 pte phys: 13e417d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417d8 pte phys: 13e417d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417e0 pte phys: 13e417e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417e8 pte phys: 13e417e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140fe pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417f0 pte phys: 13e417f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 140ff pmd: d393=
b500 pmd phys: 1393b500 pte: d3e417f8 pte phys: 13e417f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14100 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41800 pte phys: 13e41800
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14101 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41808 pte phys: 13e41808
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14102 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41810 pte phys: 13e41810
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14103 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41818 pte phys: 13e41818
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14104 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41820 pte phys: 13e41820
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14105 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41828 pte phys: 13e41828
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14106 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41830 pte phys: 13e41830
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14107 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41838 pte phys: 13e41838
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14108 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41840 pte phys: 13e41840
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14109 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41848 pte phys: 13e41848
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41850 pte phys: 13e41850
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41858 pte phys: 13e41858
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41860 pte phys: 13e41860
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41868 pte phys: 13e41868
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41870 pte phys: 13e41870
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1410f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41878 pte phys: 13e41878
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14110 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41880 pte phys: 13e41880
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14111 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41888 pte phys: 13e41888
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14112 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41890 pte phys: 13e41890
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14113 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41898 pte phys: 13e41898
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14114 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418a0 pte phys: 13e418a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14115 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418a8 pte phys: 13e418a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14116 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418b0 pte phys: 13e418b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14117 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418b8 pte phys: 13e418b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14118 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418c0 pte phys: 13e418c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14119 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418c8 pte phys: 13e418c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418d0 pte phys: 13e418d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418d8 pte phys: 13e418d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418e0 pte phys: 13e418e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418e8 pte phys: 13e418e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418f0 pte phys: 13e418f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1411f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e418f8 pte phys: 13e418f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14120 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41900 pte phys: 13e41900
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14121 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41908 pte phys: 13e41908
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14122 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41910 pte phys: 13e41910
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14123 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41918 pte phys: 13e41918
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14124 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41920 pte phys: 13e41920
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14125 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41928 pte phys: 13e41928
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14126 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41930 pte phys: 13e41930
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14127 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41938 pte phys: 13e41938
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14128 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41940 pte phys: 13e41940
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14129 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41948 pte phys: 13e41948
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41950 pte phys: 13e41950
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41958 pte phys: 13e41958
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41960 pte phys: 13e41960
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41968 pte phys: 13e41968
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41970 pte phys: 13e41970
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1412f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41978 pte phys: 13e41978
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14130 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41980 pte phys: 13e41980
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14131 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41988 pte phys: 13e41988
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14132 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41990 pte phys: 13e41990
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14133 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41998 pte phys: 13e41998
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14134 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419a0 pte phys: 13e419a0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14135 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419a8 pte phys: 13e419a8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14136 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419b0 pte phys: 13e419b0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14137 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419b8 pte phys: 13e419b8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14138 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419c0 pte phys: 13e419c0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14139 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419c8 pte phys: 13e419c8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419d0 pte phys: 13e419d0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419d8 pte phys: 13e419d8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419e0 pte phys: 13e419e0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419e8 pte phys: 13e419e8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419f0 pte phys: 13e419f0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1413f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e419f8 pte phys: 13e419f8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14140 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a00 pte phys: 13e41a00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14141 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a08 pte phys: 13e41a08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14142 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a10 pte phys: 13e41a10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14143 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a18 pte phys: 13e41a18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14144 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a20 pte phys: 13e41a20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14145 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a28 pte phys: 13e41a28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14146 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a30 pte phys: 13e41a30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14147 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a38 pte phys: 13e41a38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14148 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a40 pte phys: 13e41a40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14149 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a48 pte phys: 13e41a48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a50 pte phys: 13e41a50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a58 pte phys: 13e41a58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a60 pte phys: 13e41a60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a68 pte phys: 13e41a68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a70 pte phys: 13e41a70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1414f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a78 pte phys: 13e41a78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14150 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a80 pte phys: 13e41a80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14151 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a88 pte phys: 13e41a88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14152 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a90 pte phys: 13e41a90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14153 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41a98 pte phys: 13e41a98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14154 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41aa0 pte phys: 13e41aa0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14155 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41aa8 pte phys: 13e41aa8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14156 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ab0 pte phys: 13e41ab0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14157 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ab8 pte phys: 13e41ab8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14158 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ac0 pte phys: 13e41ac0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14159 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ac8 pte phys: 13e41ac8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ad0 pte phys: 13e41ad0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ad8 pte phys: 13e41ad8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ae0 pte phys: 13e41ae0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ae8 pte phys: 13e41ae8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41af0 pte phys: 13e41af0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1415f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41af8 pte phys: 13e41af8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14160 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b00 pte phys: 13e41b00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14161 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b08 pte phys: 13e41b08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14162 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b10 pte phys: 13e41b10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14163 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b18 pte phys: 13e41b18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14164 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b20 pte phys: 13e41b20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14165 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b28 pte phys: 13e41b28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14166 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b30 pte phys: 13e41b30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14167 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b38 pte phys: 13e41b38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14168 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b40 pte phys: 13e41b40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14169 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b48 pte phys: 13e41b48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b50 pte phys: 13e41b50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b58 pte phys: 13e41b58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b60 pte phys: 13e41b60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b68 pte phys: 13e41b68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b70 pte phys: 13e41b70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1416f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b78 pte phys: 13e41b78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14170 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b80 pte phys: 13e41b80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14171 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b88 pte phys: 13e41b88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14172 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b90 pte phys: 13e41b90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14173 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41b98 pte phys: 13e41b98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14174 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ba0 pte phys: 13e41ba0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14175 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ba8 pte phys: 13e41ba8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14176 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bb0 pte phys: 13e41bb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14177 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bb8 pte phys: 13e41bb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14178 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bc0 pte phys: 13e41bc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14179 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bc8 pte phys: 13e41bc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bd0 pte phys: 13e41bd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bd8 pte phys: 13e41bd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41be0 pte phys: 13e41be0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41be8 pte phys: 13e41be8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bf0 pte phys: 13e41bf0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1417f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41bf8 pte phys: 13e41bf8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14180 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c00 pte phys: 13e41c00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14181 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c08 pte phys: 13e41c08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14182 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c10 pte phys: 13e41c10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14183 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c18 pte phys: 13e41c18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14184 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c20 pte phys: 13e41c20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14185 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c28 pte phys: 13e41c28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14186 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c30 pte phys: 13e41c30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14187 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c38 pte phys: 13e41c38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14188 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c40 pte phys: 13e41c40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14189 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c48 pte phys: 13e41c48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c50 pte phys: 13e41c50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c58 pte phys: 13e41c58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c60 pte phys: 13e41c60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c68 pte phys: 13e41c68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c70 pte phys: 13e41c70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1418f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c78 pte phys: 13e41c78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14190 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c80 pte phys: 13e41c80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14191 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c88 pte phys: 13e41c88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14192 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c90 pte phys: 13e41c90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14193 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41c98 pte phys: 13e41c98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14194 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ca0 pte phys: 13e41ca0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14195 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ca8 pte phys: 13e41ca8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14196 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cb0 pte phys: 13e41cb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14197 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cb8 pte phys: 13e41cb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14198 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cc0 pte phys: 13e41cc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 14199 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cc8 pte phys: 13e41cc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419a pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cd0 pte phys: 13e41cd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419b pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cd8 pte phys: 13e41cd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419c pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ce0 pte phys: 13e41ce0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419d pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ce8 pte phys: 13e41ce8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419e pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cf0 pte phys: 13e41cf0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 1419f pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41cf8 pte phys: 13e41cf8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d00 pte phys: 13e41d00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d08 pte phys: 13e41d08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d10 pte phys: 13e41d10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d18 pte phys: 13e41d18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d20 pte phys: 13e41d20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d28 pte phys: 13e41d28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d30 pte phys: 13e41d30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d38 pte phys: 13e41d38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d40 pte phys: 13e41d40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141a9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d48 pte phys: 13e41d48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141aa pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d50 pte phys: 13e41d50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ab pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d58 pte phys: 13e41d58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ac pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d60 pte phys: 13e41d60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ad pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d68 pte phys: 13e41d68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ae pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d70 pte phys: 13e41d70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141af pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d78 pte phys: 13e41d78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d80 pte phys: 13e41d80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d88 pte phys: 13e41d88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d90 pte phys: 13e41d90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41d98 pte phys: 13e41d98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41da0 pte phys: 13e41da0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41da8 pte phys: 13e41da8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41db0 pte phys: 13e41db0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41db8 pte phys: 13e41db8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41dc0 pte phys: 13e41dc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141b9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41dc8 pte phys: 13e41dc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ba pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41dd0 pte phys: 13e41dd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141bb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41dd8 pte phys: 13e41dd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141bc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41de0 pte phys: 13e41de0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141bd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41de8 pte phys: 13e41de8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141be pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41df0 pte phys: 13e41df0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141bf pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41df8 pte phys: 13e41df8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e00 pte phys: 13e41e00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e08 pte phys: 13e41e08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e10 pte phys: 13e41e10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e18 pte phys: 13e41e18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e20 pte phys: 13e41e20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e28 pte phys: 13e41e28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e30 pte phys: 13e41e30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e38 pte phys: 13e41e38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e40 pte phys: 13e41e40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141c9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e48 pte phys: 13e41e48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ca pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e50 pte phys: 13e41e50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141cb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e58 pte phys: 13e41e58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141cc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e60 pte phys: 13e41e60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141cd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e68 pte phys: 13e41e68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ce pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e70 pte phys: 13e41e70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141cf pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e78 pte phys: 13e41e78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e80 pte phys: 13e41e80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e88 pte phys: 13e41e88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e90 pte phys: 13e41e90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41e98 pte phys: 13e41e98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ea0 pte phys: 13e41ea0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ea8 pte phys: 13e41ea8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41eb0 pte phys: 13e41eb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41eb8 pte phys: 13e41eb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ec0 pte phys: 13e41ec0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141d9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ec8 pte phys: 13e41ec8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141da pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ed0 pte phys: 13e41ed0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141db pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ed8 pte phys: 13e41ed8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141dc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ee0 pte phys: 13e41ee0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141dd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ee8 pte phys: 13e41ee8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141de pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ef0 pte phys: 13e41ef0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141df pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ef8 pte phys: 13e41ef8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f00 pte phys: 13e41f00
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f08 pte phys: 13e41f08
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f10 pte phys: 13e41f10
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f18 pte phys: 13e41f18
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f20 pte phys: 13e41f20
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f28 pte phys: 13e41f28
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f30 pte phys: 13e41f30
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f38 pte phys: 13e41f38
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f40 pte phys: 13e41f40
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141e9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f48 pte phys: 13e41f48
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ea pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f50 pte phys: 13e41f50
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141eb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f58 pte phys: 13e41f58
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ec pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f60 pte phys: 13e41f60
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ed pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f68 pte phys: 13e41f68
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ee pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f70 pte phys: 13e41f70
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ef pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f78 pte phys: 13e41f78
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f0 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f80 pte phys: 13e41f80
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f1 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f88 pte phys: 13e41f88
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f2 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f90 pte phys: 13e41f90
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f3 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41f98 pte phys: 13e41f98
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f4 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fa0 pte phys: 13e41fa0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f5 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fa8 pte phys: 13e41fa8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f6 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fb0 pte phys: 13e41fb0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f7 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fb8 pte phys: 13e41fb8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f8 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fc0 pte phys: 13e41fc0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141f9 pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fc8 pte phys: 13e41fc8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fa pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fd0 pte phys: 13e41fd0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fb pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fd8 pte phys: 13e41fd8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fc pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fe0 pte phys: 13e41fe0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fd pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41fe8 pte phys: 13e41fe8
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141fe pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ff0 pte phys: 13e41ff0
[    0.000000] clearing pte for ram above max_low_pfn: pfn: 141ff pmd: d393=
b500 pmd phys: 1393b500 pte: d3e41ff8 pte phys: 13e41ff8
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat d379db00, node_mem_map d2=
f30024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @d2de4000 s1338112 r0 d13568 =
u1351680
[    0.000000] pcpu-alloc: s1338112 r0 d13568 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12de65c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81070
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-hxb0-1006/bluetooth:master:6145cfe394a7f138f6b64491c5663f97dba124=
50:bisect-linux-4/.vmlinuz-6145cfe394a7f138f6b64491c5663f97dba12450-2014100=
6042522-5-ivb41 branch=3Dbluetooth/master BOOT_IMAGE=3D/kernel/i386-randcon=
fig-hxb0-1006/6145cfe394a7f138f6b64491c5663f97dba12450/vmlinuz-3.12.0-rc4-0=
0007-g6145cfe drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 308284K/327160K available (3281K kernel code, 512K r=
wdata, 1964K rodata, 1628K init, 4504K bss, 18876K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xffd33000   ( 693 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xd37a2000 - 0xd3939000   (1628 kB)
[    0.000000]       .data : 0xd3534a25 - 0xd37a1380   (2482 kB)
[    0.000000]       .text : 0xd3200000 - 0xd3534a25   (3282 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dd280a000 soft=3Dd280c000
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value..=20
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D10774032)
5387.01 BogoMIPS (lpj=3D10774032)
[    0.008009] pid_max: default: 32768 minimum: 301
[    0.008009] pid_max: default: 32768 minimum: 301
[    0.009241] Mount-cache hash table entries: 512
[    0.009241] Mount-cache hash table entries: 512
[    0.010767] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010767] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010767] tlb_flushall_shift: 6
[    0.010767] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010767] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010767] tlb_flushall_shift: 6
[    0.017720] debug: unmapping init [mem 0xd3939000-0xd393afff]
[    0.017720] debug: unmapping init [mem 0xd3939000-0xd393afff]
[    0.020626] ACPI: Core revision 20130725
[    0.020626] ACPI: Core revision 20130725
[    0.023906] ACPI:=20
[    0.023906] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.025083] Getting VERSION: 1050014
[    0.025083] Getting VERSION: 1050014
[    0.025986] Getting VERSION: 1050014
[    0.025986] Getting VERSION: 1050014
[    0.026872] Getting ID: 0
[    0.026872] Getting ID: 0
[    0.027529] Getting ID: f000000
[    0.027529] Getting ID: f000000
[    0.028015] Getting LVT0: 8700
[    0.028015] Getting LVT0: 8700
[    0.028776] Getting LVT1: 8400
[    0.028776] Getting LVT1: 8400
[    0.029530] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.029530] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.030868] enabled ExtINT on CPU#0
[    0.030868] enabled ExtINT on CPU#0
[    0.033108] ENABLING IO-APIC IRQs
[    0.033108] ENABLING IO-APIC IRQs
[    0.034023] init IO_APIC IRQs
[    0.034023] init IO_APIC IRQs
[    0.036009]  apic 0 pin 0 not connected
[    0.036009]  apic 0 pin 0 not connected
[    0.036968] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.036968] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.038932] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.038932] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.040034] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.040034] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.041997] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.041997] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.044033] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044033] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.045996] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.045996] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.048039] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.048039] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.052039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.052039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.053951] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.053951] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.056031] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.056031] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.058061] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.058061] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.060033] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.060033] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.064036] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.064036] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.066072] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.066072] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.068031] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.068031] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.070109]  apic 0 pin 16 not connected
[    0.070109]  apic 0 pin 16 not connected
[    0.071067]  apic 0 pin 17 not connected
[    0.071067]  apic 0 pin 17 not connected
[    0.072006]  apic 0 pin 18 not connected
[    0.072006]  apic 0 pin 18 not connected
[    0.073027]  apic 0 pin 19 not connected
[    0.073027]  apic 0 pin 19 not connected
[    0.074022]  apic 0 pin 20 not connected
[    0.074022]  apic 0 pin 20 not connected
[    0.075052]  apic 0 pin 21 not connected
[    0.075052]  apic 0 pin 21 not connected
[    0.076006]  apic 0 pin 22 not connected
[    0.076006]  apic 0 pin 22 not connected
[    0.077048]  apic 0 pin 23 not connected
[    0.077048]  apic 0 pin 23 not connected
[    0.078164] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.078164] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.080006] smpboot: CPU0:=20
[    0.080006] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.082064] Using local APIC timer interrupts.
[    0.082064] calibrating APIC timer ...
[    0.082064] Using local APIC timer interrupts.
[    0.082064] calibrating APIC timer ...
[    0.088000] ... lapic delta =3D 6250147
[    0.088000] ... lapic delta =3D 6250147
[    0.088000] ... PM-Timer delta =3D 357967
[    0.088000] ... PM-Timer delta =3D 357967
[    0.088000] ... PM-Timer result ok
[    0.088000] ... PM-Timer result ok
[    0.088000] ..... delta 6250147
[    0.088000] ..... delta 6250147
[    0.088000] ..... mult: 268441769
[    0.088000] ..... mult: 268441769
[    0.088000] ..... calibration result: 4000094
[    0.088000] ..... calibration result: 4000094
[    0.088000] ..... CPU clock speed is 2693.2402 MHz.
[    0.088000] ..... CPU clock speed is 2693.2402 MHz.
[    0.088000] ..... host bus clock speed is 1000.0094 MHz.
[    0.088000] ..... host bus clock speed is 1000.0094 MHz.
[    0.088066] Performance Events:=20
[    0.088066] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.091122] Brought up 1 CPUs
[    0.091122] Brought up 1 CPUs
[    0.091834] ----------------
[    0.091834] ----------------
[    0.092004] | NMI testsuite:
[    0.092004] | NMI testsuite:
[    0.092671] --------------------
[    0.092671] --------------------
[    0.093414]   remote IPI:
[    0.093414]   remote IPI:  ok  |  ok  |

[    0.094182]    local IPI:
[    0.094182]    local IPI:  ok  |  ok  |

[    0.094969] --------------------
[    0.094969] --------------------
[    0.096005] Good, all   2 testcases passed! |
[    0.096005] Good, all   2 testcases passed! |
[    0.097002] ---------------------------------
[    0.097002] ---------------------------------
[    0.097994] smpboot: Total of 1 processors activated (5387.01 BogoMIPS)
[    0.097994] smpboot: Total of 1 processors activated (5387.01 BogoMIPS)
[    0.100153] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.100153] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.103571] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.103571] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.104236] regulator-dummy: no parameters
[    0.104236] regulator-dummy: no parameters
[    0.105350] NET: Registered protocol family 16
[    0.105350] NET: Registered protocol family 16
[    0.108367] EISA bus registered
[    0.108367] EISA bus registered
[    0.109113] cpuidle: using governor ladder
[    0.109113] cpuidle: using governor ladder
[    0.110050] cpuidle: using governor menu
[    0.110050] cpuidle: using governor menu
[    0.111628] ACPI: bus type PCI registered
[    0.111628] ACPI: bus type PCI registered
[    0.112170] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.112170] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.113827] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.113827] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.116005] PCI: Using configuration type 1 for base access
[    0.116005] PCI: Using configuration type 1 for base access
[    0.128572] ACPI: Added _OSI(Module Device)
[    0.128572] ACPI: Added _OSI(Module Device)
[    0.129538] ACPI: Added _OSI(Processor Device)
[    0.129538] ACPI: Added _OSI(Processor Device)
[    0.130558] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.130558] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.131690] ACPI: Added _OSI(Processor Aggregator Device)
[    0.131690] ACPI: Added _OSI(Processor Aggregator Device)
[    0.134853] ACPI: EC: Look up EC in DSDT
[    0.134853] ACPI: EC: Look up EC in DSDT
[    0.141401] ACPI: Interpreter enabled
[    0.141401] ACPI: Interpreter enabled
[    0.142444] ACPI Exception: AE_NOT_FOUND,=20
[    0.142444] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
 (20130725/hwxface-571)
[    0.144631] ACPI Exception: AE_NOT_FOUND,=20
[    0.144631] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
 (20130725/hwxface-571)
[    0.148036] ACPI: (supports S0 S3 S5)
[    0.148036] ACPI: (supports S0 S3 S5)
[    0.149063] ACPI: Using IOAPIC for interrupt routing
[    0.149063] ACPI: Using IOAPIC for interrupt routing
[    0.150548] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.150548] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.163279] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.163279] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.164014] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.164014] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.166408] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.166408] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.168079] PCI host bridge to bus 0000:00
[    0.168079] PCI host bridge to bus 0000:00
[    0.169036] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.169036] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.172007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.172007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.173802] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.173802] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.176007] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.176007] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.177727] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.177727] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.180007] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.180007] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.182160] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.182160] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.184007] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.184007] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.185986] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.185986] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.188733] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.188733] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.191355] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.191355] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.197084] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.197084] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.200314] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.200314] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.202527] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.202527] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.204020] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.204020] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.206487] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.206487] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.210499] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.210499] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.213321] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.213321] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.222576] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.222576] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.224445] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.224445] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.228007] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.228007] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.230759] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.230759] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.237539] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.237539] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.239842] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.239842] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.240574] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.240574] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.247813] pci_bus 0000:00: on NUMA node 0
[    0.247813] pci_bus 0000:00: on NUMA node 0
[    0.250821] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.250821] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.252562] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.252562] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.254230] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.254230] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.256600] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.256600] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.258176] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.258176] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.260512] ACPI:=20
[    0.260512] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.261778] ACPI: \_SB_.PCI0: notify handler is installed
[    0.261778] ACPI: \_SB_.PCI0: notify handler is installed
[    0.263247] Found 1 acpi root devices
[    0.263247] Found 1 acpi root devices
[    0.264452] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.264452] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.266597] vgaarb: loaded
[    0.266597] vgaarb: loaded
[    0.267265] vgaarb: bridge control possible 0000:00:02.0
[    0.267265] vgaarb: bridge control possible 0000:00:02.0
[    0.268263] Linux video capture interface: v2.00
[    0.268263] Linux video capture interface: v2.00
[    0.269663] Advanced Linux Sound Architecture Driver Initialized.
[    0.269663] Advanced Linux Sound Architecture Driver Initialized.
[    0.272005] PCI: Using ACPI for IRQ routing
[    0.272005] PCI: Using ACPI for IRQ routing
[    0.273208] PCI: pci_cache_line_size set to 64 bytes
[    0.273208] PCI: pci_cache_line_size set to 64 bytes
[    0.274784] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.274784] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.276009] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.276009] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.280748] Switched to clocksource kvm-clock
[    0.280748] Switched to clocksource kvm-clock
[    0.282234] FS-Cache: Loaded
[    0.282234] FS-Cache: Loaded
[    0.283101] pnp: PnP ACPI init
[    0.283101] pnp: PnP ACPI init
[    0.283987] ACPI: bus type PNP registered
[    0.283987] ACPI: bus type PNP registered
[    0.284516] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.284516] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.286895] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.286895] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.288845] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.288845] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.291670] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.291670] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.293619] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.293619] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.295968] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.295968] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.297944] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.297944] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.300980] pnp 00:03: [dma 2]
[    0.300980] pnp 00:03: [dma 2]
[    0.301914] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.301914] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.303876] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.303876] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.306250] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.306250] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.308128] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.308128] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.310490] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.310490] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.312860] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.312860] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.315188] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.315188] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.317090] pnp: PnP ACPI: found 8 devices
[    0.317090] pnp: PnP ACPI: found 8 devices
[    0.318283] ACPI: bus type PNP unregistered
[    0.318283] ACPI: bus type PNP unregistered
[    0.319488] PnPBIOS: Disabled
[    0.319488] PnPBIOS: Disabled
[    0.356415] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.356415] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.358046] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.358046] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.361186] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.361186] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.362727] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.362727] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.364353] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.364353] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.365966] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.365966] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.367762] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.367762] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.369639] NET: Registered protocol family 1
[    0.369639] NET: Registered protocol family 1
[    0.370913] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.370913] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.372649] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.372649] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.375395] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.375395] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.377235] pci 0000:00:02.0: Boot video device
[    0.377235] pci 0000:00:02.0: Boot video device
[    0.378592] PCI: CLS 0 bytes, default 64
[    0.378592] PCI: CLS 0 bytes, default 64
[    0.379897] Unpacking initramfs...
[    0.379897] Unpacking initramfs...
[    0.385074] Initramfs unpacking failed: junk in compressed archive
[    0.385074] Initramfs unpacking failed: junk in compressed archive
[    0.386848] debug: unmapping init [mem 0xd3ca5000-0xd3fd7fff]
[    0.386848] debug: unmapping init [mem 0xd3ca5000-0xd3fd7fff]

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-h=
xb0-1006/6145cfe394a7f138f6b64491c5663f97dba12450/vmlinuz-3.12.0-rc4-00007-=
g6145cfe -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 =
prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-hxb0-100=
6/bluetooth:master:6145cfe394a7f138f6b64491c5663f97dba12450:bisect-linux-4/=
=2Evmlinuz-6145cfe394a7f138f6b64491c5663f97dba12450-20141006042522-5-ivb41 =
branch=3Dbluetooth/master BOOT_IMAGE=3D/kernel/i386-randconfig-hxb0-1006/61=
45cfe394a7f138f6b64491c5663f97dba12450/vmlinuz-3.12.0-rc4-00007-g6145cfe dr=
bd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m=
 320 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-yocto-ivb41-10 -serial file:/dev/shm/kboot/serial-yocto-ivb41-10=
 -daemonize -display none -monitor null=20

--sdtB3X0nJg68CQEu
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-hxb0-1006-a4c0475ac1eb67032e759327a40d8d4b2cf2b988-Initramfs-unpacking-failed:-69473.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgYTRjMDQ3NS4uLiBpZWVlODAyMTU0OiA2bG93cGFuOiBEcm9wIFBB
Q0tFVF9PVEhFUkhPU1Qgc2ticyBpbiA2bG93cGFuCmdpdCBjaGVja291dCA5YzIzOGNhOGVj
NzljMzhhYjIyNzYyYjQ0YWVhZjdhNDJmYzk3YjE4CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2JsdWV0b290aDptYXN0ZXI6
OWMyMzhjYThlYzc5YzM4YWIyMjc2MmI0NGFlYWY3YTQyZmM5N2IxODpiaXNlY3QtbGludXgt
NAoKMjAxNC0xMC0wNiAwMzoyMzoyOCA5YzIzOGNhOGVjNzljMzhhYjIyNzYyYjQ0YWVhZjdh
NDJmYzk3YjE4IHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi85YzIz
OGNhOGVjNzljMzhhYjIyNzYyYjQ0YWVhZjdhNDJmYzk3YjE4L3ZtbGludXotMy4xNy4wLXJj
MS0wMDQ4NC1nOWMyMzhjYQoKMjAxNC0xMC0wNiAwMzoyMzoyOCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLi4JMy4gVEVTVCBGQUlMVVJFClsgICAgMC40NjExNTJdIFBDSTogQ0xTIDAgYnl0
ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjQ2MjQ1Ml0gVW5wYWNraW5nIGluaXRyYW1mcy4uLgpb
ICAgIDAuNDYyNDUyXSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMC40NjM0NjldIElu
aXRyYW1mcyB1bnBhY2tpbmcgZmFpbGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2ZQpb
ICAgIDAuNDYzNDY5XSBJbml0cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVuayBpbiBjb21w
cmVzc2VkIGFyY2hpdmUKWyAgICAwLjQ2NTEzM10gZGVidWc6IHVubWFwcGluZyBpbml0IFtt
ZW0gMHhkMjc5MzAwMC0weGQzZmQ3ZmZmXQpbICAgIDAuNDY1MTMzXSBkZWJ1ZzogdW5tYXBw
aW5nIGluaXQgW21lbSAweGQyNzkzMDAwLTB4ZDNmZDdmZmZdCgova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1oeGIwLTEwMDYvOWMyMzhjYThlYzc5YzM4YWIyMjc2MmI0NGFlYWY3YTQyZmM5
N2IxOC9kbWVzZy15b2N0by1pdmI0MS0xMjQ6MjAxNDEwMDYwMzI1MzA6aTM4Ni1yYW5kY29u
ZmlnLWh4YjAtMTAwNjozLjE3LjAtcmMxLTAwNDg0LWc5YzIzOGNhOjEyMQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvOWMyMzhjYThlYzc5YzM4YWIyMjc2MmI0NGFlYWY3
YTQyZmM5N2IxOC9kbWVzZy1xdWFudGFsLWl2YjQxLTQ4OjIwMTQxMDA2MDMyNTQ4OmkzODYt
cmFuZGNvbmZpZy1oeGIwLTEwMDY6My4xNy4wLXJjMS0wMDQ4NC1nOWMyMzhjYToxMjEKMzoy
OjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCA5YzIz
OGNhOGVjNzljMzhhYjIyNzYyYjQ0YWVhZjdhNDJmYzk3YjE4CmdpdCBjaGVja291dCB2My4x
NgpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWh4
YjAtMTAwNi9ibHVldG9vdGg6bWFzdGVyOjE5NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2MTNk
ZmFlYWRjZGM0YTY6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMTAtMDYgMDM6MjY6MDQgMTk1ODNj
YTU4NGQ2ZjU3NDM4NGUxN2ZlNzYxM2RmYWVhZGNkYzRhNiBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIvaTM4Ni1y
YW5kY29uZmlnLWh4YjAtMTAwNi0xOTU4M2NhNTg0ZDZmNTc0Mzg0ZTE3ZmU3NjEzZGZhZWFk
Y2RjNGE2CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhi
MC0xMDA2LzE5NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2MTNkZmFlYWRjZGM0YTYKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gw
Mi9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LTE5NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2
MTNkZmFlYWRjZGM0YTYKG1sxOzM1bTIwMTQtMTAtMDYgMDM6Mjg6MDUgTm8gYnVpbGQgc2Vy
dmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWh4
YjAtMTAwNi0xOTU4M2NhNTg0ZDZmNTc0Mzg0ZTE3ZmU3NjEzZGZhZWFkY2RjNGE2G1swbQpS
ZXRyeSBidWlsZCAuLgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAw
Ni8xOTU4M2NhNTg0ZDZmNTc0Mzg0ZTE3ZmU3NjEzZGZhZWFkY2RjNGE2L3ZtbGludXotMy4x
Ni4wCgoyMDE0LTEwLTA2IDAzOjI5OjA1IGRldGVjdGluZyBib290IHN0YXRlIAk4IFRFU1Qg
RkFJTFVSRQpbICAgIDAuMjk2MTI0XSBQQ0k6IENMUyAwIGJ5dGVzLCBkZWZhdWx0IDY0Clsg
ICAgMC4yOTcyMDNdIFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAwLjI5NzIwM10gVW5w
YWNraW5nIGluaXRyYW1mcy4uLgpbICAgIDAuMzAxMTA4XSBJbml0cmFtZnMgdW5wYWNraW5n
IGZhaWxlZDoganVuayBpbiBjb21wcmVzc2VkIGFyY2hpdmUKWyAgICAwLjMwMTEwOF0gSW5p
dHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlClsg
ICAgMC4zMDIxNTBdIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4ZDNjYTUwMDAtMHhk
M2ZkN2ZmZl0KWyAgICAwLjMwMjE1MF0gZGVidWc6IHVubWFwcGluZyBpbml0IFttZW0gMHhk
M2NhNTAwMC0weGQzZmQ3ZmZmXQoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2
LzE5NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2MTNkZmFlYWRjZGM0YTYvZG1lc2cteW9jdG8t
aXZiNDEtMzU6MjAxNDEwMDYwMzI4MTQ6aTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNjozLjE2
LjA6MTI0CjIwOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0x
MC0wNiAwMzoyOTozNSBSRVBFQVQgQ09VTlQ6IDIyMCAgIyAvYy9ib290LWJpc2VjdC9saW51
eC00L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xNgpn
aXQgY2hlY2tvdXQgdjMuMTUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvYmx1ZXRvb3RoOm1hc3RlcjoxODYwZTM3OTg3NWRm
ZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkOmJpc2VjdC1saW51eC00CgoyMDE0LTEwLTA2
IDAzOjI5OjQzIDE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
bGtwLWhzeDAyL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYtMTg2MGUzNzk4NzVkZmU3Mjcx
YzY0OTA1OGFlZGRmZmU1YWZkOWQwZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZm
ZTVhZmQ5ZDBkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaHN4MDItaTM4Ni9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LTE4NjBl
Mzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKa2VybmVsOiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRm
ZmU1YWZkOWQwZC92bWxpbnV6LTMuMTUuMAoKMjAxNC0xMC0wNiAwMzozMjo0MyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAJODggVEVTVCBGQUlMVVJFClsgICAgOS41ODU2OTVdIHdhZmVyNTgy
M3dkdDogSS9PIGFkZHJlc3MgMHgwNDQzIGFscmVhZHkgaW4gdXNlClsgICAgOS41ODY5NDRd
IHBjODc0MTNfd2R0OiBWZXJzaW9uIDEuMSBhdCBpbyAweDJFClsgICAgOS41ODY5NDRdIHBj
ODc0MTNfd2R0OiBWZXJzaW9uIDEuMSBhdCBpbyAweDJFClsgICAzNi4wOTIwMzhdIEJVRzog
c29mdCBsb2NrdXAgLSBDUFUjMCBzdHVjayBmb3IgMjJzISBbc3dhcHBlci8wOjFdClsgICAz
Ni4wOTIwMzhdIEJVRzogc29mdCBsb2NrdXAgLSBDUFUjMCBzdHVjayBmb3IgMjJzISBbc3dh
cHBlci8wOjFdClsgICAzNi4wOTIwMzhdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8w
IE5vdCB0YWludGVkIDMuMTUuMCAjMTI1ClsgICAzNi4wOTIwMzhdIENQVTogMCBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTUuMCAjMTI1ClsgICAzNi4wOTIwMzhd
IHRhc2s6IGQwYzU0ZDcwIHRpOiBkMGM1NjAwMCB0YXNrLnRpOiBkMGM1NjAwMApbICAgMzYu
MDkyMDM4XSB0YXNrOiBkMGM1NGQ3MCB0aTogZDBjNTYwMDAgdGFzay50aTogZDBjNTYwMDAK
WyAgIDM2LjA5MjAzOF0gRUlQOiAwMDYwOls8ZDEyNGE1Yjk+XSBFRkxBR1M6IDAwMDAwMjg2
IENQVTogMApbICAgMzYuMDkyMDM4XSBFSVA6IDAwNjA6WzxkMTI0YTViOT5dIEVGTEFHUzog
MDAwMDAyODYgQ1BVOiAwClsgICAzNi4wOTIwMzhdIEVJUCBpcyBhdCBub3RpZmllcl9jaGFp
bl9yZWdpc3RlcisweGQvMHgyMQpbICAgMzYuMDkyMDM4XSBFSVAgaXMgYXQgbm90aWZpZXJf
Y2hhaW5fcmVnaXN0ZXIrMHhkLzB4MjEKWyAgIDM2LjA5MjAzOF0gRUFYOiBkMTc2OGNjNCBF
Qlg6IDAwMDAwMDAwIEVDWDogZDE3NjhjYzAgRURYOiBkMTdiODQ1MApbICAgMzYuMDkyMDM4
XSBFQVg6IGQxNzY4Y2M0IEVCWDogMDAwMDAwMDAgRUNYOiBkMTc2OGNjMCBFRFg6IGQxN2I4
NDUwClsgICAzNi4wOTIwMzhdIEVTSTogZDE3NjNhODAgRURJOiBkMTgxY2NjYyBFQlA6IGQw
YzU3ZjAwIEVTUDogZDBjNTdlZmMKWyAgIDM2LjA5MjAzOF0gRVNJOiBkMTc2M2E4MCBFREk6
IGQxODFjY2NjIEVCUDogZDBjNTdmMDAgRVNQOiBkMGM1N2VmYwpbICAgMzYuMDkyMDM4XSAg
RFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDM2LjA5
MjAzOF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4Clsg
ICAzNi4wOTIwMzhdIENSMDogODAwNTAwM2IgQ1IyOiBmZmZmZmZmZiBDUjM6IDExOTcxMDAw
IENSNDogMDAwMDA2YjAKWyAgIDM2LjA5MjAzOF0gQ1IwOiA4MDA1MDAzYiBDUjI6IGZmZmZm
ZmZmIENSMzogMTE5NzEwMDAgQ1I0OiAwMDAwMDZiMApbICAgMzYuMDkyMDM4XSBTdGFjazoK
WyAgIDM2LjA5MjAzOF0gU3RhY2s6ClsgICAzNi4wOTIwMzhdICBkMTc2M2FjYwpbICAgMzYu
MDkyMDM4XSAgZDE3NjNhY2MgZDBjNTdmMTQgZDBjNTdmMTQgZDEyNGE3NjggZDEyNGE3Njgg
MDAwMDAwMDAgMDAwMDAwMDAgZmZmZmZmZjAgZmZmZmZmZjAgMDAwMDAwMDAgMDAwMDAwMDAg
ZDBjNTdmMWMgZDBjNTdmMWMgZDEyNGIwODkgZDEyNGIwODkKClsgICAzNi4wOTIwMzhdICBk
MGM1N2YzMApbICAgMzYuMDkyMDM4XSAgZDBjNTdmMzAgZDE3ZmYzNjkgZDE3ZmYzNjkgMDAw
MDAwMDAgMDAwMDAwMDAgZDE3ZmYzMTYgZDE3ZmYzMTYgMDAwMDAwMDAgMDAwMDAwMDAgZDBj
NTdmOTAgZDBjNTdmOTAgZDE3ZDNhMzUgZDE3ZDNhMzUgZDE3NGE0ZDQgZDE3NGE0ZDQKClsg
ICAzNi4wOTIwMzhdICBkMTc0YTRjNApbICAgMzYuMDkyMDM4XSAgZDE3NGE0YzQgZDBjNTdm
MDAgZDBjNTdmMDAgZDE3ZDM0NjcgZDE3ZDM0NjcgZDNmZDg3ZGEgZDNmZDg3ZGEgZDE3NGE0
ZDQgZDE3NGE0ZDQgZDBjNTdmODAgZDBjNTdmODAgZDEyNDYwMjAgZDEyNDYwMjAgMDAwMDAy
NzIgMDAwMDAyNzIKClsgICAzNi4wOTIwMzhdIENhbGwgVHJhY2U6ClsgICAzNi4wOTIwMzhd
IENhbGwgVHJhY2U6ClsgICAzNi4wOTIwMzhdICBbPGQxMjRhNzY4Pl0gYmxvY2tpbmdfbm90
aWZpZXJfY2hhaW5fcmVnaXN0ZXIrMHgxYi8weDNmClsgICAzNi4wOTIwMzhdICBbPGQxMjRh
NzY4Pl0gYmxvY2tpbmdfbm90aWZpZXJfY2hhaW5fcmVnaXN0ZXIrMHgxYi8weDNmClsgICAz
Ni4wOTIwMzhdICBbPGQxMjRiMDg5Pl0gcmVnaXN0ZXJfcmVib290X25vdGlmaWVyKzB4Zi8w
eDExClsgICAzNi4wOTIwMzhdICBbPGQxMjRiMDg5Pl0gcmVnaXN0ZXJfcmVib290X25vdGlm
aWVyKzB4Zi8weDExClsgICAzNi4wOTIwMzhdICBbPGQxN2ZmMzY5Pl0gcGM4NzQxM19pbml0
KzB4NTMvMHgyMGEKWyAgIDM2LjA5MjAzOF0gIFs8ZDE3ZmYzNjk+XSBwYzg3NDEzX2luaXQr
MHg1My8weDIwYQpbICAgMzYuMDkyMDM4XSAgWzxkMTdmZjMxNj5dID8ga2VtcGxkX3dkdF9k
cml2ZXJfaW5pdCsweDExLzB4MTEKWyAgIDM2LjA5MjAzOF0gIFs8ZDE3ZmYzMTY+XSA/IGtl
bXBsZF93ZHRfZHJpdmVyX2luaXQrMHgxMS8weDExClsgICAzNi4wOTIwMzhdICBbPGQxN2Qz
YTM1Pl0gZG9fb25lX2luaXRjYWxsKzB4NzkvMHgxMDMKWyAgIDM2LjA5MjAzOF0gIFs8ZDE3
ZDNhMzU+XSBkb19vbmVfaW5pdGNhbGwrMHg3OS8weDEwMwpbICAgMzYuMDkyMDM4XSAgWzxk
MTdkMzQ2Nz5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDU0ClsgICAzNi4wOTIwMzhd
ICBbPGQxN2QzNDY3Pl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTQKWyAgIDM2LjA5
MjAzOF0gIFs8ZDEyNDYwMjA+XSA/IHBhcnNlX2FyZ3MrMHgxNzEvMHgyNWUKWyAgIDM2LjA5
MjAzOF0gIFs8ZDEyNDYwMjA+XSA/IHBhcnNlX2FyZ3MrMHgxNzEvMHgyNWUKWyAgIDM2LjA5
MjAzOF0gIFs8ZDE3ZDNiYzA+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDEwMS8weDE3OQpb
ICAgMzYuMDkyMDM4XSAgWzxkMTdkM2JjMD5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTAx
LzB4MTc5ClsgICAzNi4wOTIwMzhdICBbPGQxNTQ4Njg1Pl0ga2VybmVsX2luaXQrMHg4LzB4
YjgKWyAgIDM2LjA5MjAzOF0gIFs8ZDE1NDg2ODU+XSBrZXJuZWxfaW5pdCsweDgvMHhiOApb
ICAgMzYuMDkyMDM4XSAgWzxkMTU1MTMwMT5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgy
MS8weDMwClsgICAzNi4wOTIwMzhdICBbPGQxNTUxMzAxPl0gcmV0X2Zyb21fa2VybmVsX3Ro
cmVhZCsweDIxLzB4MzAKWyAgIDM2LjA5MjAzOF0gIFs8ZDE1NDg2N2Q+XSA/IHJlc3RfaW5p
dCsweGE1LzB4YTUKWyAgIDM2LjA5MjAzOF0gIFs8ZDE1NDg2N2Q+XSA/IHJlc3RfaW5pdCsw
eGE1LzB4YTUKWyAgIDM2LjA5MjAzOF0gQ29kZToKWyAgIDM2LjA5MjAzOF0gQ29kZTogZmYg
ZmYgZWIgZWIgMGEgMGEgOGIgOGIgNDUgNDUgZjAgZjAgODkgODkgZmEgZmEgZTggZTggMWIg
MWIgZmYgZmYgZmYgZmYgZmYgZmYgODkgODkgZjAgZjAgZTggZTggYzcgYzcgYWQgYWQgMDYg
MDYgMDAgMDAgODkgODkgZDggZDggOGQgOGQgNjUgNjUgZjQgZjQgNWIgNWIgNWUgNWUgNWYg
NWYgNWQgNWQgYzMgYzMgNTUgNTUgODkgODkgZTUgZTUgNTMgNTMgOGIgOGIgMDggMDggODUg
ODUgYzkgYzkgNzQgNzQgMGQgMGQgOGIgOGIgNTkgNTkgMDggMDggPDM5PiA8Mzk+IDVhIDVh
IDA4IDA4IDdmIDdmIDA1IDA1IDhkIDhkIDQxIDQxIDA0IDA0IGViIGViIGVkIGVkIDg5IDg5
IDRhIDRhIDA0IDA0IDg5IDg5IDEwIDEwIDMxIDMxIGMwIGMwIDViIDViIDVkIDVkIGMzIGMz
IDU1IDU1CgpbICAgMzYuMDkyMDM4XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogc29m
dGxvY2t1cDogaHVuZyB0YXNrcwpbICAgMzYuMDkyMDM4XSBLZXJuZWwgcGFuaWMgLSBub3Qg
c3luY2luZzogc29mdGxvY2t1cDogaHVuZyB0YXNrcwpbICAgMzYuMDkyMDM4XSBDUFU6IDAg
UElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE1LjAgIzEyNQpbICAgMzYu
MDkyMDM4XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE1
LjAgIzEyNQpbICAgMzYuMDkyMDM4XSAgMDAwMDAwMDAKWyAgIDM2LjA5MjAzOF0gIDAwMDAw
MDAwIDAwMDAwMDAwIDAwMDAwMDAwIGQwYzU3ZTA0IGQwYzU3ZTA0IGQxNTRiZTI1IGQxNTRi
ZTI1IDAwMDAwMDE2IDAwMDAwMDE2IGQwYzU3ZTFjIGQwYzU3ZTFjIGQxNTRhZWFhIGQxNTRh
ZWFhIGQwYzU3ZWMwIGQwYzU3ZWMwCgpbICAgMzYuMDkyMDM4XSAgMDAwMDAwMTYKWyAgIDM2
LjA5MjAzOF0gIDAwMDAwMDE2IGQwYzU3ZWMwIGQwYzU3ZWMwIDAwMDAwMDAwIDAwMDAwMDAw
IGQwYzU3ZTNjIGQwYzU3ZTNjIGQxMjgwN2Y5IGQxMjgwN2Y5IGQxNmU0N2ViIGQxNmU0N2Vi
IGVlNmIyODAwIGVlNmIyODAwIDAwMDAwMDAwIDAwMDAwMDAwCgpbICAgMzYuMDkyMDM4XSAg
ZDIxZDYwM2MKWyAgIDM2LjA5MjAzOF0gIGQyMWQ2MDNjIGQyMDk1NzU0IGQyMDk1NzU0IGQy
MDk1NzAwIGQyMDk1NzAwIGQwYzU3ZTU4IGQwYzU3ZTU4IGQxMjQ5Mzg5IGQxMjQ5Mzg5IDAw
MDAwMDAwIDAwMDAwMDAwIGQxMjgwNmY2IGQxMjgwNmY2IGQyMDk1NzAwIGQyMDk1NzAwCgpb
ICAgMzYuMDkyMDM4XSBDYWxsIFRyYWNlOgpbICAgMzYuMDkyMDM4XSBDYWxsIFRyYWNlOgpb
ICAgMzYuMDkyMDM4XSAgWzxkMTU0YmUyNT5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAz
Ni4wOTIwMzhdICBbPGQxNTRiZTI1Pl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgIDM2LjA5
MjAzOF0gIFs8ZDE1NGFlYWE+XSBwYW5pYysweDgxLzB4MThjClsgICAzNi4wOTIwMzhdICBb
PGQxNTRhZWFhPl0gcGFuaWMrMHg4MS8weDE4YwpbICAgMzYuMDkyMDM4XSAgWzxkMTI4MDdm
OT5dIHdhdGNoZG9nX3RpbWVyX2ZuKzB4MTAzLzB4MTIyClsgICAzNi4wOTIwMzhdICBbPGQx
MjgwN2Y5Pl0gd2F0Y2hkb2dfdGltZXJfZm4rMHgxMDMvMHgxMjIKWyAgIDM2LjA5MjAzOF0g
IFs8ZDEyNDkzODk+XSBfX3J1bl9ocnRpbWVyKzB4NGIvMHg5ZgpbICAgMzYuMDkyMDM4XSAg
WzxkMTI0OTM4OT5dIF9fcnVuX2hydGltZXIrMHg0Yi8weDlmClsgICAzNi4wOTIwMzhdICBb
PGQxMjgwNmY2Pl0gPyBfX3RvdWNoX3dhdGNoZG9nKzB4MTQvMHgxNApbICAgMzYuMDkyMDM4
XSAgWzxkMTI4MDZmNj5dID8gX190b3VjaF93YXRjaGRvZysweDE0LzB4MTQKWyAgIDM2LjA5
MjAzOF0gIFs8ZDEyNDljMTA+XSBocnRpbWVyX2ludGVycnVwdCsweDEwMC8weDFmOApbICAg
MzYuMDkyMDM4XSAgWzxkMTI0OWMxMD5dIGhydGltZXJfaW50ZXJydXB0KzB4MTAwLzB4MWY4
ClsgICAzNi4wOTIwMzhdICBbPGQxMjFkMGU3Pl0gbG9jYWxfYXBpY190aW1lcl9pbnRlcnJ1
cHQrMHg0MS8weDQ2ClsgICAzNi4wOTIwMzhdICBbPGQxMjFkMGU3Pl0gbG9jYWxfYXBpY190
aW1lcl9pbnRlcnJ1cHQrMHg0MS8weDQ2ClsgICAzNi4wOTIwMzhdICBbPGQxMjFkNTEzPl0g
c21wX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4MjAvMHgyZgpbICAgMzYuMDkyMDM4XSAgWzxk
MTIxZDUxMz5dIHNtcF9hcGljX3RpbWVyX2ludGVycnVwdCsweDIwLzB4MmYKWyAgIDM2LjA5
MjAzOF0gIFs8ZDE1NTBlNjQ+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDM0LzB4NDAKWyAg
IDM2LjA5MjAzOF0gIFs8ZDE1NTBlNjQ+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDM0LzB4
NDAKWyAgIDM2LjA5MjAzOF0gIFs8ZDEyNGE1Yjk+XSA/IG5vdGlmaWVyX2NoYWluX3JlZ2lz
dGVyKzB4ZC8weDIxClsgICAzNi4wOTIwMzhdICBbPGQxMjRhNWI5Pl0gPyBub3RpZmllcl9j
aGFpbl9yZWdpc3RlcisweGQvMHgyMQpbICAgMzYuMDkyMDM4XSAgWzxkMTI0YTc2OD5dIGJs
b2NraW5nX25vdGlmaWVyX2NoYWluX3JlZ2lzdGVyKzB4MWIvMHgzZgpbICAgMzYuMDkyMDM4
XSAgWzxkMTI0YTc2OD5dIGJsb2NraW5nX25vdGlmaWVyX2NoYWluX3JlZ2lzdGVyKzB4MWIv
MHgzZgpbICAgMzYuMDkyMDM4XSAgWzxkMTI0YjA4OT5dIHJlZ2lzdGVyX3JlYm9vdF9ub3Rp
ZmllcisweGYvMHgxMQpbICAgMzYuMDkyMDM4XSAgWzxkMTI0YjA4OT5dIHJlZ2lzdGVyX3Jl
Ym9vdF9ub3RpZmllcisweGYvMHgxMQpbICAgMzYuMDkyMDM4XSAgWzxkMTdmZjM2OT5dIHBj
ODc0MTNfaW5pdCsweDUzLzB4MjBhClsgICAzNi4wOTIwMzhdICBbPGQxN2ZmMzY5Pl0gcGM4
NzQxM19pbml0KzB4NTMvMHgyMGEKWyAgIDM2LjA5MjAzOF0gIFs8ZDE3ZmYzMTY+XSA/IGtl
bXBsZF93ZHRfZHJpdmVyX2luaXQrMHgxMS8weDExClsgICAzNi4wOTIwMzhdICBbPGQxN2Zm
MzE2Pl0gPyBrZW1wbGRfd2R0X2RyaXZlcl9pbml0KzB4MTEvMHgxMQpbICAgMzYuMDkyMDM4
XSAgWzxkMTdkM2EzNT5dIGRvX29uZV9pbml0Y2FsbCsweDc5LzB4MTAzClsgICAzNi4wOTIw
MzhdICBbPGQxN2QzYTM1Pl0gZG9fb25lX2luaXRjYWxsKzB4NzkvMHgxMDMKWyAgIDM2LjA5
MjAzOF0gIFs8ZDE3ZDM0Njc+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1NApbICAg
MzYuMDkyMDM4XSAgWzxkMTdkMzQ2Nz5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDU0
ClsgICAzNi4wOTIwMzhdICBbPGQxMjQ2MDIwPl0gPyBwYXJzZV9hcmdzKzB4MTcxLzB4MjVl
ClsgICAzNi4wOTIwMzhdICBbPGQxMjQ2MDIwPl0gPyBwYXJzZV9hcmdzKzB4MTcxLzB4MjVl
ClsgICAzNi4wOTIwMzhdICBbPGQxN2QzYmMwPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgx
MDEvMHgxNzkKWyAgIDM2LjA5MjAzOF0gIFs8ZDE3ZDNiYzA+XSBrZXJuZWxfaW5pdF9mcmVl
YWJsZSsweDEwMS8weDE3OQpbICAgMzYuMDkyMDM4XSAgWzxkMTU0ODY4NT5dIGtlcm5lbF9p
bml0KzB4OC8weGI4ClsgICAzNi4wOTIwMzhdICBbPGQxNTQ4Njg1Pl0ga2VybmVsX2luaXQr
MHg4LzB4YjgKWyAgIDM2LjA5MjAzOF0gIFs8ZDE1NTEzMDE+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MjEvMHgzMApbICAgMzYuMDkyMDM4XSAgWzxkMTU1MTMwMT5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsgICAzNi4wOTIwMzhdICBbPGQxNTQ4NjdkPl0g
PyByZXN0X2luaXQrMHhhNS8weGE1ClsgICAzNi4wOTIwMzhdICBbPGQxNTQ4NjdkPl0gPyBy
ZXN0X2luaXQrMHhhNS8weGE1ClsgICAzNi4wOTIwMzhdIEtlcm5lbCBPZmZzZXQ6IDB4MTAy
MDAwMDAgZnJvbSAweGMxMDAwMDAwIChyZWxvY2F0aW9uIHJhbmdlOiAweGMwMDAwMDAwLTB4
ZDQ3ZGZmZmYpClsgICAzNi4wOTIwMzhdIEtlcm5lbCBPZmZzZXQ6IDB4MTAyMDAwMDAgZnJv
bSAweGMxMDAwMDAwIChyZWxvY2F0aW9uIHJhbmdlOiAweGMwMDAwMDAwLTB4ZDQ3ZGZmZmYp
Cgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvMTg2MGUzNzk4NzVkZmU3Mjcx
YzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy1xdWFudGFsLWl2YjQxLTI6MjAxNDEwMDYw
MzMxNTk6aTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNjozLjE1LjA6MTI1CjA6MTo4OSBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0xMC0wNiAwMzozMzoxNCBSRVBF
QVQgQ09VTlQ6IDMwMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QvLnJl
cGVhdBtbMG0KCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xNQpnaXQgY2hlY2tvdXQgdjMuMTQK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oeGIw
LTEwMDYvYmx1ZXRvb3RoOm1hc3Rlcjo0NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlk
NmQ3M2RlMTFjOmJpc2VjdC1saW51eC00CgoyMDE0LTEwLTA2IDAzOjMzOjE4IDQ1NWM2ZmRi
ZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL2kzODYtcmFu
ZGNvbmZpZy1oeGIwLTEwMDYtNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNk
ZTExYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAt
MTAwNi80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIt
aTM4Ni9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LTQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2
NWYxMTY5OWQ2ZDczZGUxMWMKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIw
LTEwMDYvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy92bWxpbnV6
LTMuMTQuMAoKMjAxNC0xMC0wNiAwMzozNToxOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNCBU
RVNUIEZBSUxVUkUKWyAgICAwLjMwNTg0N10gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2
NApbICAgIDAuMzA2NjkyXSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMC4zMDY2OTJd
IFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAwLjMxMDg4NV0gSW5pdHJhbWZzIHVucGFj
a2luZyBmYWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlClsgICAgMC4zMTA4ODVd
IEluaXRyYW1mcyB1bnBhY2tpbmcgZmFpbGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2
ZQpbICAgIDAuMzExODcxXSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGQzY2JkMDAw
LTB4ZDNmZWZmZmZdClsgICAgMC4zMTE4NzFdIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVt
IDB4ZDNjYmQwMDAtMHhkM2ZlZmZmZl0KCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAt
MTAwNi80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjL2RtZXNnLXlv
Y3RvLXZwLTU3OjIwMTQxMDA2MDMzNDM1OmkzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDY6My4x
NC4wOjEyNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvNDU1YzZmZGJkMjE5
MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9kbWVzZy15b2N0by12cC01NDoyMDE0MTAw
NjAzMzU0MTppMzg2LXJhbmRjb25maWctaHhiMC0xMDA2OjMuMTQuMDoxMjYKNDoyOjIgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xNApnaXQg
Y2hlY2tvdXQgdjMuMTMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1oeGIwLTEwMDYvYmx1ZXRvb3RoOm1hc3RlcjpkOGVjMjZkN2Y4Mjg3ZjU3
ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlOmJpc2VjdC1saW51eC00CgoyMDE0LTEwLTA2IDAz
OjM1OjUzIGQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtw
LWhzeDAyL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5
NGY1NmU4ODE0MjEwZjBlNjRiZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWh4YjAtMTAwNi9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBm
MGU2NGJlCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2Q4ZWMy
NmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvdm1saW51ei0zLjEzLjAKCjIw
MTQtMTAtMDYgMDM6MzY6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLgk1Ngk2My4JMTAy
CTEyOAkxNDAJMjUzCTI3My4JMzAwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMu
MTMKZ2l0IGJpc2VjdCBzdGFydCB2My4xNCB2My4xMyAtLQovYy9rZXJuZWwtdGVzdHMvbGlu
ZWFyLWJpc2VjdDogWyItYiIsICJ2My4xNCIsICItZyIsICJ2My4xMyIsICIvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xp
bnV4LTQvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogMTM0MTUgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpbNDk0NDc5MDM4ZDk3ZjFiOWY3
NmZjNjMzYTM2MGE2ODFhY2RmMDM1Y10gTWVyZ2UgdGFnICdwaW5jdHJsLXYzLjE0LTInIG9m
IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9saW51c3cv
bGludXgtcGluY3RybApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2Js
dWV0b290aDptYXN0ZXI6NDk0NDc5MDM4ZDk3ZjFiOWY3NmZjNjMzYTM2MGE2ODFhY2RmMDM1
YzpiaXNlY3QtbGludXgtNAoKMjAxNC0xMC0wNiAwMzo0Mzo1NyA0OTQ0NzkwMzhkOTdmMWI5
Zjc2ZmM2MzNhMzYwYTY4MWFjZGYwMzVjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi9pMzg2LXJhbmRjb25maWct
aHhiMC0xMDA2LTQ5NDQ3OTAzOGQ5N2YxYjlmNzZmYzYzM2EzNjBhNjgxYWNkZjAzNWMKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvNDk0
NDc5MDM4ZDk3ZjFiOWY3NmZjNjMzYTM2MGE2ODFhY2RmMDM1Ywp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLWkzODYvaTM4
Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi00OTQ0NzkwMzhkOTdmMWI5Zjc2ZmM2MzNhMzYwYTY4
MWFjZGYwMzVjCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzQ5
NDQ3OTAzOGQ5N2YxYjlmNzZmYzYzM2EzNjBhNjgxYWNkZjAzNWMvdm1saW51ei0zLjE0LjAt
cmMxLTAwMTY4LWc0OTQ0NzkwCgoyMDE0LTEwLTA2IDAzOjQ2OjU3IGRldGVjdGluZyBib290
IHN0YXRlIAkxCTI0CTg5CTk3CTExNAkxNjQgVEVTVCBGQUlMVVJFClsgICAxNS44MTg3OTJd
IHJhbmRvbTogaW5pdCB1cmFuZG9tIHJlYWQgd2l0aCAzIGJpdHMgb2YgZW50cm9weSBhdmFp
bGFibGUKWyAgIDE1LjgzNTQ5NF0gaG9zdG5hbWUgKDExMCkgdXNlZCBncmVhdGVzdCBzdGFj
ayBkZXB0aDogNjg3NiBieXRlcyBsZWZ0ClsgICAxNS44NTgxODNdIGh3Y2xvY2sgKDExMikg
dXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNjcwOCBieXRlcyBsZWZ0ClsgICAxNS45Mjkw
NDhdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJl
bmNlIGF0ICAgKG51bGwpClsgICAxNS45MzAwNThdIElQOiBbPCAgKG51bGwpPl0gICAobnVs
bCkKWyAgIDE1LjkzMDU3NF0gKnBkcHQgPSAwMDAwMDAwMDBiNTA1MDAxICpwZGUgPSAwMDAw
MDAwMDAwMDAwMDAwIApbICAgMTUuOTMxMjk0XSBPb3BzOiAwMDEwIFsjMV0gU01QIERFQlVH
X1BBR0VBTExPQwpbICAgMTUuOTMxODU1XSBDUFU6IDEgUElEOiAxMjMgQ29tbTogdHJpbml0
eSBOb3QgdGFpbnRlZCAzLjE0LjAtcmMxLTAwMTY4LWc0OTQ0NzkwICMxMjkKWyAgIDE1Ljkz
MjAxNl0gdGFzazogY2I4Mzg0NTAgdGk6IGNiNTQwMDAwIHRhc2sudGk6IGNiNTQwMDAwClsg
ICAxNS45MzIwMTZdIEVJUDogMDA2MDpbPDAwMDAwMDAwPl0gRUZMQUdTOiAwMDAxMDI4NiBD
UFU6IDEKWyAgIDE1LjkzMjAxNl0gRUlQIGlzIGF0IDB4MApbICAgMTUuOTMyMDE2XSBFQVg6
IDAwMDAwMDAwIEVCWDogY2I0ZDMwMDAgRUNYOiBjYjRkMzAwMCBFRFg6IGQxOTRkNDEwClsg
ICAxNS45MzIwMTZdIEVTSTogZDE5NGQ0MTAgRURJOiBkMTViNDM1MSBFQlA6IGNiNTQxZWM0
IEVTUDogY2I1NDFlYjgKWyAgIDE1LjkzMjAxNl0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAw
MGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICAxNS45MzIwMTZdIENSMDogODAwNTAwMzMgQ1Iy
OiAwMDAwMDAwMCBDUjM6IDBiODQ2MDAwIENSNDogMDAwNDA2YjAKWyAgIDE1LjkzMjAxNl0g
U3RhY2s6ClsgICAxNS45MzIwMTZdICBkMTQwZGVkNyBkMTk0ZDQxMCBkMTQwZGVjNSBjYjU0
MWVkNCBkMTViNDM2NCBkMTAwOTJjMCBkMTdlNjE0YyBjYjU0MWVmMApbICAgMTUuOTMyMDE2
XSAgZDE0ZTZmYTkgY2JmNzAwMDggY2I0ZDMwMDAgY2I1MTcwODAgMDAwMDAwMDEgMDAwMDAw
MDEgY2I1NDFmMDAgZDE0ZTkxYzQKWyAgIDE1LjkzMjAxNl0gIGQxMDA5MmMwIDAwMDAwMDAx
IGNiNTQxZjQwIGQxNGM4MGUyIGNiNTQxZjI0IGQxMDA5MmVjIGI3NGM0MDAwIGNkYjViZTQw
ClsgICAxNS45MzIwMTZdIENhbGwgVHJhY2U6ClsgICAxNS45MzIwMTZdICBbPGQxNDBkZWQ3
Pl0gPyBldmVudHNfc3lzZnNfc2hvdysweDEyLzB4M2QKWyAgIDE1LjkzMjAxNl0gIFs8ZDE0
MGRlYzU+XSA/IGJhY2t0cmFjZV9zdGFjaysweDcvMHg3ClsgICAxNS45MzIwMTZdICBbPGQx
NWI0MzY0Pl0gZGV2X2F0dHJfc2hvdysweDEzLzB4MzYKWyAgIDE1LjkzMjAxNl0gIFs8ZDE0
ZTZmYTk+XSBzeXNmc19rZl9zZXFfc2hvdysweDY0LzB4YTcKWyAgIDE1LjkzMjAxNl0gIFs8
ZDE0ZTkxYzQ+XSBrZXJuZnNfc2VxX3Nob3crMHgxYi8weDFmClsgICAxNS45MzIwMTZdICBb
PGQxNGM4MGUyPl0gc2VxX3JlYWQrMHgxOTQvMHgzNjIKWyAgIDE1LjkzMjAxNl0gIFs8ZDE0
NWRmYWM+XSA/IGxvY2tfcmVsZWFzZSsweDE3OC8weDE4ZgpbICAgMTUuOTMyMDE2XSAgWzxk
MTRlOTRlZD5dID8ga2VybmZzX3ZtYV9wYWdlX21rd3JpdGUrMHg2MC8weDYwClsgICAxNS45
MzIwMTZdICBbPGQxNGU5NTE4Pl0ga2VybmZzX2ZvcF9yZWFkKzB4MmIvMHhmZgpbICAgMTUu
OTMyMDE2XSAgWzxkMTRlOTRlZD5dID8ga2VybmZzX3ZtYV9wYWdlX21rd3JpdGUrMHg2MC8w
eDYwClsgICAxNS45MzIwMTZdICBbPGQxNGIyMGI4Pl0gdmZzX3JlYWQrMHg2OS8weDhmClsg
ICAxNS45MzIwMTZdICBbPGQxNGIyMmMyPl0gU3lTX3JlYWQrMHg0NC8weDZiClsgICAxNS45
MzIwMTZdICBbPGQxNzQ3MTlkPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4MzcKWyAgIDE1
LjkzMjAxNl0gQ29kZTogIEJhZCBFSVAgdmFsdWUuClsgICAxNS45MzIwMTZdIEVJUDogWzww
MDAwMDAwMD5dIDB4MCBTUzpFU1AgMDA2ODpjYjU0MWViOApbICAgMTUuOTMyMDE2XSBDUjI6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDE1Ljk4NjE2Nl0gLS0tWyBlbmQgdHJhY2UgNmI1MGYz
YWVlMzMzZmM1OCBdLS0tClsgICAxNS45ODY3NDldIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5j
aW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2
LzQ5NDQ3OTAzOGQ5N2YxYjlmNzZmYzYzM2EzNjBhNjgxYWNkZjAzNWMvZG1lc2cteW9jdG8t
aXZiNDEtODoyMDE0MTAwNjAzNDk0MzppMzg2LXJhbmRjb25maWctaHhiMC0xMDA2OjMuMTQu
MC1yYzEtMDAxNjgtZzQ5NDQ3OTA6MTI5CjE2MToxOjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKG1sxOzM1bTIwMTQtMTAtMDYgMDM6NDk6NTggUkVQRUFUIENPVU5UOiAzMDAgICMg
L2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rp
bmc6IDExNTQ5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAx
NCBzdGVwcykKWzFiMTczNjZkNjk1YzhhYjAzZjk4ZDAxNTUzNTdlOTdhNDI3ZTFkY2VdIE1l
cmdlIGJyYW5jaCAnbmV4dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2JlbmgvcG93ZXJwYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
aHhiMC0xMDA2L2JsdWV0b290aDptYXN0ZXI6MWIxNzM2NmQ2OTVjOGFiMDNmOThkMDE1NTM1
N2U5N2E0MjdlMWRjZTpiaXNlY3QtbGludXgtNAoKMjAxNC0xMC0wNiAwMzo1MDowMCAxYjE3
MzY2ZDY5NWM4YWIwM2Y5OGQwMTU1MzU3ZTk3YTQyN2UxZGNlIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi9pMzg2
LXJhbmRjb25maWctaHhiMC0xMDA2LTFiMTczNjZkNjk1YzhhYjAzZjk4ZDAxNTUzNTdlOTdh
NDI3ZTFkY2UKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1o
eGIwLTEwMDYvMWIxNzM2NmQ2OTVjOGFiMDNmOThkMDE1NTM1N2U5N2E0MjdlMWRjZQprZXJu
ZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi8xYjE3MzY2ZDY5NWM4YWIw
M2Y5OGQwMTU1MzU3ZTk3YTQyN2UxZGNlL3ZtbGludXotMy4xMy4wLTA4NjY0LWcxYjE3MzY2
CgoyMDE0LTEwLTA2IDAzOjUxOjAwIGRldGVjdGluZyBib290IHN0YXRlIC4JMiBURVNUIEZB
SUxVUkUKS2VybmVsIHRlc3RzOiBCb290IE9LIQpbICAgMTcuMzgyNzY4XSByYW5kb206IHRy
aW5pdHkgdXJhbmRvbSByZWFkIHdpdGggNiBiaXRzIG9mIGVudHJvcHkgYXZhaWxhYmxlCltp
bml0XSBNYXJraW5nIHN5c2NhbGwgZ2V0X3JvYnVzdF9saXN0ICgzMTIpIGFzIHRvIGJlIGRp
c2FibGVkLgpbICAgMTcuMzk5NTUzXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5V
TEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxsKQpbICAgMTcuNDAwNjk3XSBJUDog
WzwgIChudWxsKT5dICAgKG51bGwpClsgICAxNy40MDEyODRdICpwZHB0ID0gMDAwMDAwMDAx
MWI5NjAwMSAqcGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDE3LjQwMjAwMl0gT29wczog
MDAxMCBbIzFdIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgIDE3LjQwMjAwMl0gQ1BVOiAwIFBJ
RDogNDY1IENvbW06IHRyaW5pdHkgTm90IHRhaW50ZWQgMy4xMy4wLTA4NjY0LWcxYjE3MzY2
ICMxMzAKWyAgIDE3LjQwMjAwMl0gdGFzazogZDI2OThmNTAgdGk6IGQxYjYwMDAwIHRhc2su
dGk6IGQxYjYwMDAwClsgICAxNy40MDIwMDJdIEVJUDogMDA2MDpbPDAwMDAwMDAwPl0gRUZM
QUdTOiAwMDAxMDI4NiBDUFU6IDAKWyAgIDE3LjQwMjAwMl0gRUlQIGlzIGF0IDB4MApbICAg
MTcuNDAyMDAyXSBFQVg6IDAwMDAwMDAwIEVCWDogZDFjMDAwMDAgRUNYOiBkMWMwMDAwMCBF
RFg6IGM5NTRiNDEwClsgICAxNy40MDIwMDJdIEVTSTogYzk1NGI0MTAgRURJOiBjOTFiMzcx
NiBFQlA6IGQxYjYxZWM0IEVTUDogZDFiNjFlYjgKWyAgIDE3LjQwMjAwMl0gIERTOiAwMDdi
IEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICAxNy40MDIwMDJdIENS
MDogODAwNTAwMzMgQ1IyOiAwMDAwMDAwMCBDUjM6IDExYjdmMDAwIENSNDogMDAwNDA2YjAK
WyAgIDE3LjQwMjAwMl0gU3RhY2s6ClsgICAxNy40MDIwMDJdICBjOTAwZGRjOSBjOTU0YjQx
MCBjOTAwZGRiNyBkMWI2MWVkNCBjOTFiMzcyOSBkMjNmODg0MCBjOTNlNTE4YyBkMWI2MWVm
MApbICAgMTcuNDAyMDAyXSAgYzkwZTY0MDEgZDI2OTJjMDggZDFjMDAwMDAgZDFjMDEwODAg
MDAwMDAwMDEgMDAwMDAwMDEgZDFiNjFmMDAgYzkwZTg2MDkKWyAgIDE3LjQwMjAwMl0gIGQy
M2Y4ODQwIDAwMDAwMDAxIGQxYjYxZjQwIGM5MGM3NTQ0IGQxYjYxZjI0IGQyM2Y4ODZjIGI3
NmVmMDAwIGQxZTQzNjgwClsgICAxNy40MDIwMDJdIENhbGwgVHJhY2U6ClsgICAxNy40MDIw
MDJdICBbPGM5MDBkZGM5Pl0gPyBldmVudHNfc3lzZnNfc2hvdysweDEyLzB4M2QKWyAgIDE3
LjQwMjAwMl0gIFs8YzkwMGRkYjc+XSA/IGJhY2t0cmFjZV9zdGFjaysweDcvMHg3ClsgICAx
Ny40MDIwMDJdICBbPGM5MWIzNzI5Pl0gZGV2X2F0dHJfc2hvdysweDEzLzB4MzYKWyAgIDE3
LjQwMjAwMl0gIFs8YzkwZTY0MDE+XSBzeXNmc19rZl9zZXFfc2hvdysweDY0LzB4YTcKWyAg
IDE3LjQwMjAwMl0gIFs8YzkwZTg2MDk+XSBrZXJuZnNfc2VxX3Nob3crMHgxYi8weDFmClsg
ICAxNy40MDIwMDJdICBbPGM5MGM3NTQ0Pl0gc2VxX3JlYWQrMHgxOTQvMHgzNjIKWyAgIDE3
LjQwMjAwMl0gIFs8YzkwNWRlNTc+XSA/IGxvY2tfcmVsZWFzZSsweDE3OC8weDE4ZgpbICAg
MTcuNDAyMDAyXSAgWzxjOTBlODkzMj5dID8ga2VybmZzX3ZtYV9wYWdlX21rd3JpdGUrMHg2
MC8weDYwClsgICAxNy40MDIwMDJdICBbPGM5MGU4OTVkPl0ga2VybmZzX2ZvcF9yZWFkKzB4
MmIvMHhmZgpbICAgMTcuNDAyMDAyXSAgWzxjOTBlODkzMj5dID8ga2VybmZzX3ZtYV9wYWdl
X21rd3JpdGUrMHg2MC8weDYwClsgICAxNy40MDIwMDJdICBbPGM5MGIxNGZjPl0gdmZzX3Jl
YWQrMHg2OS8weDhmClsgICAxNy40MDIwMDJdICBbPGM5MGIxNmZmPl0gU3lTX3JlYWQrMHg0
NC8weDZiClsgICAxNy40MDIwMDJdICBbPGM5MzQ1ODRmPl0gc3lzY2FsbF9jYWxsKzB4Ny8w
eGIKWyAgIDE3LjQwMjAwMl0gQ29kZTogIEJhZCBFSVAgdmFsdWUuClsgICAxNy40MDIwMDJd
IEVJUDogWzwwMDAwMDAwMD5dIDB4MCBTUzpFU1AgMDA2ODpkMWI2MWViOApbICAgMTcuNDAy
MDAyXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDE3LjQ0NjEyNl0gLS0tWyBlbmQgdHJh
Y2UgNzM2ZDA0YjMzODkyYjE0YSBdLS0tClsgICAxNy40NDY4MzFdIEtlcm5lbCBwYW5pYyAt
IG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aHhiMC0xMDA2LzFiMTczNjZkNjk1YzhhYjAzZjk4ZDAxNTUzNTdlOTdhNDI3ZTFkY2UvZG1l
c2cteW9jdG8ta2J1aWxkLTk6MjAxNDEwMDYwMzQ4MjA6aTM4Ni1yYW5kY29uZmlnLWh4YjAt
MTAwNjozLjEzLjAtMDg2NjQtZzFiMTczNjY6MTMwCjA6MTozIGFsbF9nb29kOmJhZDphbGxf
YmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDg3NTcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpbNjBlYWEwMTkwZjZiMzlkY2UxOGViMTk3NWQ5
NzczZWQ4YmM5YTUzNF0gTWVyZ2UgdGFnICd0cmFjZS0zLjE0JyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvcm9zdGVkdC9saW51eC10cmFjZQpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2JsdWV0b290aDptYXN0ZXI6
NjBlYWEwMTkwZjZiMzlkY2UxOGViMTk3NWQ5NzczZWQ4YmM5YTUzNDpiaXNlY3QtbGludXgt
NAoKMjAxNC0xMC0wNiAwMzo1MjowNCA2MGVhYTAxOTBmNmIzOWRjZTE4ZWIxOTc1ZDk3NzNl
ZDhiYzlhNTM0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LTYwZWFh
MDE5MGY2YjM5ZGNlMThlYjE5NzVkOTc3M2VkOGJjOWE1MzQKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvNjBlYWEwMTkwZjZiMzlkY2Ux
OGViMTk3NWQ5NzczZWQ4YmM5YTUzNAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLWkzODYvaTM4Ni1yYW5kY29uZmlnLWh4
YjAtMTAwNi02MGVhYTAxOTBmNmIzOWRjZTE4ZWIxOTc1ZDk3NzNlZDhiYzlhNTM0Cmtlcm5l
bDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzYwZWFhMDE5MGY2YjM5ZGNl
MThlYjE5NzVkOTc3M2VkOGJjOWE1MzQvdm1saW51ei0zLjEzLjAtMDM1MTYtZzYwZWFhMDEK
CjIwMTQtMTAtMDYgMDM6NTQ6MDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTMJMTEgVEVTVCBG
QUlMVVJFClsgICAgNS44ODgwNDJdIFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAg
ICA1Ljg4OTIzMF0gVW5wYWNraW5nIGluaXRyYW1mcy4uLgpbICAgIDUuODg5MjMwXSBVbnBh
Y2tpbmcgaW5pdHJhbWZzLi4uClsgICAgNS44OTAzODRdIEluaXRyYW1mcyB1bnBhY2tpbmcg
ZmFpbGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2ZQpbICAgIDUuODkwMzg0XSBJbml0
cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVuayBpbiBjb21wcmVzc2VkIGFyY2hpdmUKWyAg
ICA1Ljg5MTk0OF0gZGVidWc6IHVubWFwcGluZyBpbml0IFttZW0gMHhkMjc5MzAwMC0weGQz
ZmQ3ZmZmXQpbICAgIDUuODkxOTQ4XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGQy
NzkzMDAwLTB4ZDNmZDdmZmZdClsgICAgNS44OTM1MTNdIEJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgCkVsYXBzZWQgdGltZTogNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02
NCAtZW5hYmxlLWt2bSAta2VybmVsIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAw
Ni82MGVhYTAxOTBmNmIzOWRjZTE4ZWIxOTc1ZDk3NzNlZDhiYzlhNTM0L3ZtbGludXotMy4x
My4wLTAzNTE2LWc2MGVhYTAxIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJp
bnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVk
IHJjdXBkYXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgcGFuaWM9LTEgc29mdGxvY2t1
cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyBvb3BzPXBhbmljIGxvYWRfcmFtZGlzaz0y
IHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZn
YT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvYmx1ZXRvb3RoOm1hc3Rlcjo2MGVh
YTAxOTBmNmIzOWRjZTE4ZWIxOTc1ZDk3NzNlZDhiYzlhNTM0OmJpc2VjdC1saW51eC00Ly52
bWxpbnV6LTYwZWFhMDE5MGY2YjM5ZGNlMThlYjE5NzVkOTc3M2VkOGJjOWE1MzQtMjAxNDEw
MDYwMzUzMDYtMTU5LWl2YjQxIGJyYW5jaD1ibHVldG9vdGgvbWFzdGVyIEJPT1RfSU1BR0U9
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzYwZWFhMDE5MGY2YjM5ZGNlMThl
YjE5NzVkOTc3M2VkOGJjOWE1MzQvdm1saW51ei0zLjEzLjAtMDM1MTYtZzYwZWFhMDEgZHJi
ZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFs
LWNvcmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEw
MDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRv
ZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290
L3BpZC1xdWFudGFsLWl2YjQxLTEyNiAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2Vy
aWFsLXF1YW50YWwtaXZiNDEtMTI2IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRv
ciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvNjBlYWEwMTkwZjZi
MzlkY2UxOGViMTk3NWQ5NzczZWQ4YmM5YTUzNC9kbWVzZy1xdWFudGFsLWl2YjQxLTEyNjoy
MDE0MTAwNjAzNTQ1MDppMzg2LXJhbmRjb25maWctaHhiMC0xMDA2OjMuMTMuMC0wMzUxNi1n
NjBlYWEwMToxMzEKODoxOjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGlu
ZzogMzUxNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIg
c3RlcHMpCls3NGU4ZWU4MjYyYzNmOTNiYmM0MTgwNDAzN2I0M2YwN2I5NTg5N2JiXSBNZXJn
ZSBicmFuY2ggJ3g4Ni1wbGF0Zm9ybS1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eC00L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1oeGIwLTEwMDYvYmx1ZXRvb3RoOm1hc3Rlcjo3NGU4ZWU4MjYyYzNmOTNi
YmM0MTgwNDAzN2I0M2YwN2I5NTg5N2JiOmJpc2VjdC1saW51eC00CgoyMDE0LTEwLTA2IDAz
OjU1OjA2IDc0ZThlZTgyNjJjM2Y5M2JiYzQxODA0MDM3YjQzZjA3Yjk1ODk3YmIgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtw
LWhzeDAyL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYtNzRlOGVlODI2MmMzZjkzYmJjNDE4
MDQwMzdiNDNmMDdiOTU4OTdiYgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWh4YjAtMTAwNi83NGU4ZWU4MjYyYzNmOTNiYmM0MTgwNDAzN2I0M2YwN2I5
NTg5N2JiCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2Lzc0ZThl
ZTgyNjJjM2Y5M2JiYzQxODA0MDM3YjQzZjA3Yjk1ODk3YmIvdm1saW51ei0zLjEzLjAtMDA3
MTktZzc0ZThlZTgKCjIwMTQtMTAtMDYgMDM6NTY6MDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
CTEJOQk0Mwk5MgkxMTEJMTc2CTIyNQkyODYJMzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjc5
NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMp
ClswMmQwYTc1MjQ2MGVhNWRhYjM0Y2UzNmM5ZGRjOWM2ODJlODQ2YTBkXSBNZXJnZSBicmFu
Y2ggJ2kyYy9mb3ItbmV4dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3dzYS9saW51eApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0
CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaHhi
MC0xMDA2L2JsdWV0b290aDptYXN0ZXI6MDJkMGE3NTI0NjBlYTVkYWIzNGNlMzZjOWRkYzlj
NjgyZTg0NmEwZDpiaXNlY3QtbGludXgtNAoKMjAxNC0xMC0wNiAwNDowMDozOSAwMmQwYTc1
MjQ2MGVhNWRhYjM0Y2UzNmM5ZGRjOWM2ODJlODQ2YTBkIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi9pMzg2LXJh
bmRjb25maWctaHhiMC0xMDA2LTAyZDBhNzUyNDYwZWE1ZGFiMzRjZTM2YzlkZGM5YzY4MmU4
NDZhMGQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIw
LTEwMDYvMDJkMGE3NTI0NjBlYTVkYWIzNGNlMzZjOWRkYzljNjgyZTg0NmEwZAprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi8wMmQwYTc1MjQ2MGVhNWRhYjM0
Y2UzNmM5ZGRjOWM2ODJlODQ2YTBkL3ZtbGludXotMy4xMy4wLTAyNTczLWcwMmQwYTc1Cgoy
MDE0LTEwLTA2IDA0OjAxOjQwIGRldGVjdGluZyBib290IHN0YXRlIC4JODEJMTUyIFRFU1Qg
RkFJTFVSRQpbICAgIDMuODA5OTU1XSBQQ0k6IENMUyAwIGJ5dGVzLCBkZWZhdWx0IDY0Clsg
ICAgMy44MTA3ODRdIFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAzLjgxMDc4NF0gVW5w
YWNraW5nIGluaXRyYW1mcy4uLgpbICAgIDMuODE5NzIyXSBJbml0cmFtZnMgdW5wYWNraW5n
IGZhaWxlZDoganVuayBpbiBjb21wcmVzc2VkIGFyY2hpdmUKWyAgICAzLjgxOTcyMl0gSW5p
dHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlClsg
ICAgMy44MjA3MDVdIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4ZDI3YWIwMDAtMHhk
M2ZlZmZmZl0KWyAgICAzLjgyMDcwNV0gZGVidWc6IHVubWFwcGluZyBpbml0IFttZW0gMHhk
MjdhYjAwMC0weGQzZmVmZmZmXQpbICAgIDMuODIxNzA3XSBCVUc6IHVuYWJsZSB0byBoYW5k
bGUga2VybmVsIApbICAgIDMuODIxNzA3XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVs
IHBhZ2luZyByZXF1ZXN0cGFnaW5nIHJlcXVlc3QgYXQgZDI5OWVlNDAKIGF0IGQyOTllZTQw
ClsgICAgMy44MjI3NDBdIElQOgpbICAgIDMuODIyNzQwXSBJUDoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaHhiMC0xMDA2LzAyZDBhNzUyNDYwZWE1ZGFiMzRjZTM2YzlkZGM5YzY4MmU4
NDZhMGQvZG1lc2ctcXVhbnRhbC12cC05OjIwMTQxMDA2MDQwMjQxOmkzODYtcmFuZGNvbmZp
Zy1oeGIwLTEwMDY6My4xMy4wLTAyNTczLWcwMmQwYTc1OjEzMwoxNTI6MToxIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTEwLTA2IDA0OjAzOjEwIFJFUEVBVCBD
T1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdC8ucmVwZWF0
G1swbQoKQmlzZWN0aW5nOiAxODU0IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMSBzdGVwcykKWzgyYjUxNzM0YjRmMjI4Yzc2YjYwNjRiNmU4OTlkOWQz
ZDRjMTdjMWFdIE1lcmdlIHRhZyAnYXJtNjQtdXBzdHJlYW0nIG9mIGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9hcm02NC9saW51eApydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2JsdWV0b290aDptYXN0ZXI6ODJiNTE3MzRi
NGYyMjhjNzZiNjA2NGI2ZTg5OWQ5ZDNkNGMxN2MxYTpiaXNlY3QtbGludXgtNAoKMjAxNC0x
MC0wNiAwNDowMzoxMSA4MmI1MTczNGI0ZjIyOGM3NmI2MDY0YjZlODk5ZDlkM2Q0YzE3YzFh
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2xrcC1oc3gwMi9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LTgyYjUxNzM0YjRmMjI4
Yzc2YjYwNjRiNmU4OTlkOWQzZDRjMTdjMWEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvODJiNTE3MzRiNGYyMjhjNzZiNjA2NGI2ZTg5
OWQ5ZDNkNGMxN2MxYQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvbGtwLWhzeDAyLWkzODYvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi04
MmI1MTczNGI0ZjIyOGM3NmI2MDY0YjZlODk5ZDlkM2Q0YzE3YzFhCmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzgyYjUxNzM0YjRmMjI4Yzc2YjYwNjRiNmU4
OTlkOWQzZDRjMTdjMWEvdm1saW51ei0zLjEzLjAtMDA4MDYtZzgyYjUxNzMKCjIwMTQtMTAt
MDYgMDQ6MDU6MTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEwIFRFU1QgRkFJTFVSRQpbICAg
MjYuODE0ODc4XSBob3N0bmFtZSAoMTEwKSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA2
ODcyIGJ5dGVzIGxlZnQKWyAgIDI2Ljg1MDk2N10gaHdjbG9jayAoMTEyKSB1c2VkIGdyZWF0
ZXN0IHN0YWNrIGRlcHRoOiA2ODA0IGJ5dGVzIGxlZnQKWyAgIDI2LjkzMDUxM10gbW91bnRh
bGwgKDExNikgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNjc4MCBieXRlcyBsZWZ0Clsg
ICAyNi45NTE3NzFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVy
IGRlcmVmZXJlbmNlIGF0ICAgKG51bGwpClsgICAyNi45NTY4OTVdIElQOiBbPCAgKG51bGwp
Pl0gICAobnVsbCkKWyAgIDI2Ljk1NzM1NV0gKnBkcHQgPSAwMDAwMDAwMDBjMTE3MDAxICpw
ZGUgPSAwMDAwMDAwMDAwMDAwMDAwIApbICAgMjYuOTU4MTIxXSBPb3BzOiAwMDEwIFsjMV0g
U01QIERFQlVHX1BBR0VBTExPQwpbICAgMjYuOTYzNjk5XSBDUFU6IDEgUElEOiAxMjQgQ29t
bTogdHJpbml0eSBOb3QgdGFpbnRlZCAzLjEzLjAtMDA4MDYtZzgyYjUxNzMgIzEzNApbICAg
MjYuOTY0NjYzXSB0YXNrOiBjY2I4NjM5MCB0aTogY2MxNDYwMDAgdGFzay50aTogY2MxNDYw
MDAKWyAgIDI2Ljk2NTM4Ml0gRUlQOiAwMDYwOls8MDAwMDAwMDA+XSBFRkxBR1M6IDAwMDEw
Mjg2IENQVTogMQpbICAgMjYuOTY4NTUzXSBFSVAgaXMgYXQgMHgwClsgICAyNi45Njg4OTZd
IEVBWDogMDAwMDAwMDAgRUJYOiBkMWNiYTAwMCBFQ1g6IGQxY2JhMDAwIEVEWDogYzdkM2Yz
OTAKWyAgIDI2Ljk3MDM0MV0gRVNJOiBjN2QzZjM5MCBFREk6IGM3OWFiNWM2IEVCUDogY2Mx
NDdlZjQgRVNQOiBjYzE0N2VlOApbICAgMjYuOTcxMTQ5XSAgRFM6IDAwN2IgRVM6IDAwN2Ig
RlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgIDI2Ljk3MTkxOV0gQ1IwOiA4MDA1MDAz
MyBDUjI6IDAwMDAwMDAwIENSMzogMGMxMjAwMDAgQ1I0OiAwMDA0MDZiMApbICAgMjYuOTc2
MTUxXSBTdGFjazoKWyAgIDI2Ljk3NjQ2Ml0gIGM3ODBkZGM5IGM3ZDNmMzkwIGM3ODBkZGI3
IGNjMTQ3ZjA0IGM3OWFiNWQ5IGQxYzA5MjAwIGNjMGVhMjgwIGNjMTQ3ZjI4ClsgICAyNi45
Nzc1ODJdICBjNzhlMTc2OSBjY2JjMzYwOCBkMWNiYTAwMCBjN2JkYzRjYyBjYzBlYTI4OCBk
MWMwOTIwMCAwMDAwMDAwMSAwMDAwMDAwMQpbICAgMjYuOTgzNzE1XSAgY2MxNDdmNjggYzc4
YzE5YzggY2MxNDdmNGMgZDFjMDkyMmMgYjc0YjEwMDAgZDFkNTBiNDAgMDAwMDEwMDAgMDAw
MDAwMDAKWyAgIDI2Ljk4NDk0MF0gQ2FsbCBUcmFjZToKWyAgIDI2Ljk4NTI5MV0gIFs8Yzc4
MGRkYzk+XSA/IGV2ZW50c19zeXNmc19zaG93KzB4MTIvMHgzZApbICAgMjYuOTg1OTE0XSAg
WzxjNzgwZGRiNz5dID8gYmFja3RyYWNlX3N0YWNrKzB4Ny8weDcKWyAgIDI2Ljk4NjYyOV0g
IFs8Yzc5YWI1ZDk+XSBkZXZfYXR0cl9zaG93KzB4MTMvMHgzNgpbICAgMjYuOTg3MTg5XSAg
WzxjNzhlMTc2OT5dIHN5c2ZzX3NlcV9zaG93KzB4OWIvMHhmMApbICAgMjYuOTg3NzgzXSAg
WzxjNzhjMTljOD5dIHNlcV9yZWFkKzB4MTk0LzB4MzYyClsgICAyNi45OTI4MjVdICBbPGM3
ODkwM2RmPl0gPyB2bV9tbWFwX3Bnb2ZmKzB4NDkvMHg2OApbICAgMjYuOTkzNDAyXSAgWzxj
NzhjMTgzND5dID8gc2VxX29wZW4rMHg3Yy8weDdjClsgICAyNi45OTM5MzRdICBbPGM3OGFi
OTIxPl0gdmZzX3JlYWQrMHg2OS8weDhmClsgICAyNi45OTQ0ODBdICBbPGM3OGFiYjI0Pl0g
U3lTX3JlYWQrMHg0NC8weDZiClsgICAyNi45OTUwOTZdICBbPGM3YjNkN2RkPl0gc3lzZW50
ZXJfZG9fY2FsbCsweDEyLzB4MzcKWyAgIDI2Ljk5NTcxOF0gQ29kZTogIEJhZCBFSVAgdmFs
dWUuClsgICAyNi45OTg2NzBdIEVJUDogWzwwMDAwMDAwMD5dIDB4MCBTUzpFU1AgMDA2ODpj
YzE0N2VlOApbICAgMjcuMDAzMzAxXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDI3LjAw
MzgzMF0gLS0tWyBlbmQgdHJhY2UgZTA2ZDJhMjc1ZjEyMTkwZCBdLS0tClsgICAyNy4wMDQ0
MDhdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzgyYjUxNzM0YjRmMjI4Yzc2YjYwNjRiNmU4
OTlkOWQzZDRjMTdjMWEvZG1lc2cteW9jdG8taXZiNDEtNjY6MjAxNDEwMDYwNDA0NTQ6aTM4
Ni1yYW5kY29uZmlnLWh4YjAtMTAwNjozLjEzLjAtMDA4MDYtZzgyYjUxNzM6MTM0Cjc6MTo0
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDg3IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbZjRiY2Q4Y2NkZGIw
MjgzMzM0MDY1MmU5ZjQ2ZjUxMjc4MjhlYjc5ZF0gTWVyZ2UgYnJhbmNoICd4ODYta2FzbHIt
Zm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvdGlwL3RpcApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2Js
dWV0b290aDptYXN0ZXI6ZjRiY2Q4Y2NkZGIwMjgzMzM0MDY1MmU5ZjQ2ZjUxMjc4MjhlYjc5
ZDpiaXNlY3QtbGludXgtNAoKMjAxNC0xMC0wNiAwNDowNTo0MyBmNGJjZDhjY2RkYjAyODMz
MzQwNjUyZTlmNDZmNTEyNzgyOGViNzlkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi9pMzg2LXJhbmRjb25maWct
aHhiMC0xMDA2LWY0YmNkOGNjZGRiMDI4MzMzNDA2NTJlOWY0NmY1MTI3ODI4ZWI3OWQKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvZjRi
Y2Q4Y2NkZGIwMjgzMzM0MDY1MmU5ZjQ2ZjUxMjc4MjhlYjc5ZAprZXJuZWw6IC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi9mNGJjZDhjY2RkYjAyODMzMzQwNjUyZTlmNDZm
NTEyNzgyOGViNzlkL3ZtbGludXotMy4xMy4wLTAwNzUyLWdmNGJjZDhjCgoyMDE0LTEwLTA2
IDA0OjA2OjQzIGRldGVjdGluZyBib290IHN0YXRlIC4uCTQzLiBURVNUIEZBSUxVUkUKWyAg
ICA2LjUyMzM2Nl0gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2NApbICAgIDYuNTI0NTQ0
XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgNi41MjQ1NDRdIFVucGFja2luZyBpbml0
cmFtZnMuLi4KWyAgICA2LjUyNTQzOV0gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1
bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlClsgICAgNi41MjU0MzldIEluaXRyYW1mcyB1bnBh
Y2tpbmcgZmFpbGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2ZQpbICAgIDYuNTI3MDkw
XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGQyNzkzMDAwLTB4ZDNmZDdmZmZdClsg
ICAgNi41MjcwOTBdIGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4ZDI3OTMwMDAtMHhk
M2ZkN2ZmZl0KWyAgICA2LjUyODc2NF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAK
WyAgICA2LjUyODc2NF0gQlVHOiB1bmFibGUgdG8gaGFuZGwKRWxhcHNlZCB0aW1lOiAxMApx
ZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAta2VybmVsIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi9mNGJjZDhjY2RkYjAyODMzMzQwNjUyZTlm
NDZmNTEyNzgyOGViNzlkL3ZtbGludXotMy4xMy4wLTAwNzUyLWdmNGJjZDhjIC1hcHBlbmQg
J2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGlj
PWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9jcHVfc3RhbGxfdGlt
ZW91dD0xMDAgcGFuaWM9LTEgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5p
YyBvb3BzPXBhbmljIGxvYWRfcmFtZGlzaz0yIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10
dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3
IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oeGIw
LTEwMDYvYmx1ZXRvb3RoOm1hc3RlcjpmNGJjZDhjY2RkYjAyODMzMzQwNjUyZTlmNDZmNTEy
NzgyOGViNzlkOmJpc2VjdC1saW51eC00Ly52bWxpbnV6LWY0YmNkOGNjZGRiMDI4MzMzNDA2
NTJlOWY0NmY1MTI3ODI4ZWI3OWQtMjAxNDEwMDYwNDA2MjYtMTYzLWl2YjQxIGJyYW5jaD1i
bHVldG9vdGgvbWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhi
MC0xMDA2L2Y0YmNkOGNjZGRiMDI4MzMzNDA2NTJlOWY0NmY1MTI3ODI4ZWI3OWQvdm1saW51
ei0zLjEzLjAtMDA3NTItZ2Y0YmNkOGMgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAv
a2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAg
MiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBv
cmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0
aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWl2YjQxLTQzIC1zZXJp
YWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1pdmI0MS00MyAtZGFlbW9u
aXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaHhiMC0xMDA2L2Y0YmNkOGNjZGRiMDI4MzMzNDA2NTJlOWY0NmY1MTI3ODI4ZWI3OWQv
ZG1lc2ctcXVhbnRhbC1pdmI0MS00MzoyMDE0MTAwNjA0MDgwNzppMzg2LXJhbmRjb25maWct
aHhiMC0xMDA2OjMuMTMuMC0wMDc1Mi1nZjRiY2Q4YzoxMzUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaHhiMC0xMDA2L2Y0YmNkOGNjZGRiMDI4MzMzNDA2NTJlOWY0NmY1MTI3ODI4ZWI3
OWQvZG1lc2ctcXVhbnRhbC12cC0zMjoyMDE0MTAwNjA0MDgyNjppMzg2LXJhbmRjb25maWct
aHhiMC0xMDA2OjMuMTMuMC0wMDc1Mi1nZjRiY2Q4YzoxMzUKNDM6MjoyIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDMzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbZmFiNTY2OWQ1NTYyMDBjNGRkMTE5YWY3
MDViZmYxNDA4NTg0NWQxZV0gTWVyZ2UgYnJhbmNoICd4ODYtcmFzLWZvci1saW51cycgb2Yg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi9ibHVldG9vdGg6bWFzdGVy
OmZhYjU2NjlkNTU2MjAwYzRkZDExOWFmNzA1YmZmMTQwODU4NDVkMWU6YmlzZWN0LWxpbnV4
LTQKCjIwMTQtMTAtMDYgMDQ6MDg6NDQgZmFiNTY2OWQ1NTYyMDBjNGRkMTE5YWY3MDViZmYx
NDA4NTg0NWQxZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi1mYWI1
NjY5ZDU1NjIwMGM0ZGQxMTlhZjcwNWJmZjE0MDg1ODQ1ZDFlCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2ZhYjU2NjlkNTU2MjAwYzRk
ZDExOWFmNzA1YmZmMTQwODU4NDVkMWUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi1pMzg2L2kzODYtcmFuZGNvbmZpZy1o
eGIwLTEwMDYtZmFiNTY2OWQ1NTYyMDBjNGRkMTE5YWY3MDViZmYxNDA4NTg0NWQxZQprZXJu
ZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi9mYWI1NjY5ZDU1NjIwMGM0
ZGQxMTlhZjcwNWJmZjE0MDg1ODQ1ZDFlL3ZtbGludXotMy4xMy4wLTAwNzM0LWdmYWI1NjY5
CgoyMDE0LTEwLTA2IDA0OjEwOjQ0IGRldGVjdGluZyBib290IHN0YXRlIAkyMQk2Mgk3Mgk4
MgkyMjMJMjM1CTIzNgkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxOCByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzdmZTY3YTExODBkYjQ5
ZDQxYTNmNzY0YzM3OWEwOGY4ZTMxNTgwZWNdIE1lcmdlIGJyYW5jaCAneDg2LXVyZ2VudC1m
b3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvYmx1
ZXRvb3RoOm1hc3Rlcjo3ZmU2N2ExMTgwZGI0OWQ0MWEzZjc2NGMzNzlhMDhmOGUzMTU4MGVj
OmJpc2VjdC1saW51eC00CgoyMDE0LTEwLTA2IDA0OjE0OjQ1IDdmZTY3YTExODBkYjQ5ZDQx
YTNmNzY0YzM3OWEwOGY4ZTMxNTgwZWMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL2kzODYtcmFuZGNvbmZpZy1o
eGIwLTEwMDYtN2ZlNjdhMTE4MGRiNDlkNDFhM2Y3NjRjMzc5YTA4ZjhlMzE1ODBlYwpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi83ZmU2
N2ExMTgwZGI0OWQ0MWEzZjc2NGMzNzlhMDhmOGUzMTU4MGVjCmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzdmZTY3YTExODBkYjQ5ZDQxYTNmNzY0YzM3OWEw
OGY4ZTMxNTgwZWMvdm1saW51ei0zLjEzLjAtMDA3MzctZzdmZTY3YTEKCjIwMTQtMTAtMDYg
MDQ6MTU6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTgJNzkJMTUyCTE1NgkxNjIJMjk5CTMw
MCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBicmFuY2ggJ3g4
Ni1rYXNsci1mb3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC90aXAvdGlwCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdp
dCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCBmNGJjZDhjY2RkYjAy
ODMzMzQwNjUyZTlmNDZmNTEyNzgyOGViNzlkIDdmZTY3YTExODBkYjQ5ZDQxYTNmNzY0YzM3
OWEwOGY4ZTMxNTgwZWMgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgN2ZlNjdhMS4u
LiBNZXJnZSBicmFuY2ggJ3g4Ni11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApIRUFEIGlzIG5vdyBh
dCAxNzFjMDYyLi4uIE1lcmdlIHRhZyAnbW1jLXYzLjE2LTInIG9mIGdpdDovL2dpdC5saW5h
cm8ub3JnL3Blb3BsZS91bGYuaGFuc3Nvbi9tbWMKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNjE0NWNmZTM5NGE3
ZjEzOGY2YjY0NDkxYzU2NjNmOTdkYmExMjQ1MF0geDg2LCBrYXNscjogUmFpc2UgdGhlIG1h
eGltdW0gdmlydHVhbCBhZGRyZXNzIHRvIC0xIEdpQiBvbiB4ODZfNjQKbGluZWFyLWJpc2Vj
dDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4LTQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi9ibHVldG9vdGg6bWFzdGVyOjYxNDVjZmUzOTRh
N2YxMzhmNmI2NDQ5MWM1NjYzZjk3ZGJhMTI0NTA6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMTAt
MDYgMDQ6MjQ6MTUgNjE0NWNmZTM5NGE3ZjEzOGY2YjY0NDkxYzU2NjNmOTdkYmExMjQ1MCBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9sa3AtaHN4MDIvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi02MTQ1Y2ZlMzk0YTdmMTM4
ZjZiNjQ0OTFjNTY2M2Y5N2RiYTEyNDUwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzYxNDVjZmUzOTRhN2YxMzhmNmI2NDQ5MWM1NjYz
Zjk3ZGJhMTI0NTAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2xrcC1oc3gwMi1pMzg2L2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYtNjE0
NWNmZTM5NGE3ZjEzOGY2YjY0NDkxYzU2NjNmOTdkYmExMjQ1MAprZXJuZWw6IC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi82MTQ1Y2ZlMzk0YTdmMTM4ZjZiNjQ0OTFjNTY2
M2Y5N2RiYTEyNDUwL3ZtbGludXotMy4xMi4wLXJjNC0wMDAwNy1nNjE0NWNmZQoKMjAxNC0x
MC0wNiAwNDoyNjoxNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAg
IDAuNzYxNzg1XSBQQ0k6IENMUyAwIGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMC43NjM5MTFd
IFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAwLjc2MzkxMV0gVW5wYWNraW5nIGluaXRy
YW1mcy4uLgpbICAgIDAuNzY3MDEzXSBJbml0cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVu
ayBpbiBjb21wcmVzc2VkIGFyY2hpdmUKWyAgICAwLjc2NzAxM10gSW5pdHJhbWZzIHVucGFj
a2luZyBmYWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlClsgICAgMC43Njk3MDdd
IGRlYnVnOiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4ZDI3OTMwMDAtMHhkM2ZkN2ZmZl0KWyAg
ICAwLjc2OTcwN10gZGVidWc6IHVubWFwcGluZyBpbml0IFttZW0gMHhkMjc5MzAwMC0weGQz
ZmQ3ZmZmXQpbICAgIDAuNzczMDczXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIApF
bGFwc2VkIHRpbWU6IDEwCnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUt
a3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzYxNDVjZmUz
OTRhN2YxMzhmNmI2NDQ5MWM1NjYzZjk3ZGJhMTI0NTAvdm1saW51ei0zLjEyLjAtcmM0LTAw
MDA3LWc2MTQ1Y2ZlIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0
eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHJjdXBk
YXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgcGFuaWM9LTEgc29mdGxvY2t1cF9wYW5p
Yz0xIG5taV93YXRjaGRvZz1wYW5pYyBvb3BzPXBhbmljIGxvYWRfcmFtZGlzaz0yIHByb21w
dF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3Jt
YWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvYmx1ZXRvb3RoOm1hc3Rlcjo2MTQ1Y2ZlMzk0
YTdmMTM4ZjZiNjQ0OTFjNTY2M2Y5N2RiYTEyNDUwOmJpc2VjdC1saW51eC00Ly52bWxpbnV6
LTYxNDVjZmUzOTRhN2YxMzhmNmI2NDQ5MWM1NjYzZjk3ZGJhMTI0NTAtMjAxNDEwMDYwNDI1
MjItMS1pdmI0MSBicmFuY2g9Ymx1ZXRvb3RoL21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi82MTQ1Y2ZlMzk0YTdmMTM4ZjZiNjQ0OTFjNTY2
M2Y5N2RiYTEyNDUwL3ZtbGludXotMy4xMi4wLXJjNC0wMDAwNy1nNjE0NWNmZSBkcmJkLm1p
bm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29y
ZS1pMzg2LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAt
bmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2
MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlk
LXF1YW50YWwtaXZiNDEtNDggLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1x
dWFudGFsLWl2YjQxLTQ4IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxs
IAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvNjE0NWNmZTM5NGE3ZjEzOGY2
YjY0NDkxYzU2NjNmOTdkYmExMjQ1MC9kbWVzZy1xdWFudGFsLWl2YjQxLTQ4OjIwMTQxMDA2
MDQyNTQ3OmkzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDY6My4xMi4wLXJjNC0wMDAwNy1nNjE0
NWNmZToxMzgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzYxNDVjZmUzOTRh
N2YxMzhmNmI2NDQ5MWM1NjYzZjk3ZGJhMTI0NTAvZG1lc2ctcXVhbnRhbC1pdmI0MS05ODoy
MDE0MTAwNjA0MjU1MTppMzg2LXJhbmRjb25maWctaHhiMC0xMDA2OjMuMTIuMC1yYzQtMDAw
MDctZzYxNDVjZmU6MTM4CjA6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNl
Y3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIg
c3RlcHMpCls4YWIzODIwZmQ1YjI4OTZkNjZkYTdiYjJhOTA2YmMzODJlNjNlN2JjXSB4ODYs
IGthc2xyOiBSZXR1cm4gbG9jYXRpb24gZnJvbSBkZWNvbXByZXNzX2tlcm5lbApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2JsdWV0b290aDptYXN0ZXI6OGFiMzgy
MGZkNWIyODk2ZDY2ZGE3YmIyYTkwNmJjMzgyZTYzZTdiYzpiaXNlY3QtbGludXgtNAoKMjAx
NC0xMC0wNiAwNDoyNjo0NiA4YWIzODIwZmQ1YjI4OTZkNjZkYTdiYjJhOTA2YmMzODJlNjNl
N2JjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2xrcC1oc3gwMi9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LThhYjM4MjBmZDVi
Mjg5NmQ2NmRhN2JiMmE5MDZiYzM4MmU2M2U3YmMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvOGFiMzgyMGZkNWIyODk2ZDY2ZGE3YmIy
YTkwNmJjMzgyZTYzZTdiYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLWkzODYvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAw
Ni04YWIzODIwZmQ1YjI4OTZkNjZkYTdiYjJhOTA2YmMzODJlNjNlN2JjCmtlcm5lbDogL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzhhYjM4MjBmZDViMjg5NmQ2NmRhN2Ji
MmE5MDZiYzM4MmU2M2U3YmMvdm1saW51ei0zLjEyLjAtcmM0LTAwMDAzLWc4YWIzODIwCgoy
MDE0LTEwLTA2IDA0OjI4OjQ2IGRldGVjdGluZyBib290IHN0YXRlIAkxMwkzMi4uCTExMAkx
ODgJMTkxCTI1OQkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzgyZmE5NjM3YTJiYTI4NWJjYzdj
NTA1MGM3MzAxMGIyYzFiM2Q4MDNdIHg4Niwga2FzbHI6IFNlbGVjdCByYW5kb20gcG9zaXRp
b24gZnJvbSBlODIwIG1hcHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAw
Ni9ibHVldG9vdGg6bWFzdGVyOjgyZmE5NjM3YTJiYTI4NWJjYzdjNTA1MGM3MzAxMGIyYzFi
M2Q4MDM6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMTAtMDYgMDQ6MzM6MTcgODJmYTk2MzdhMmJh
Mjg1YmNjN2M1MDUwYzczMDEwYjJjMWIzZDgwMyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIvaTM4Ni1yYW5kY29u
ZmlnLWh4YjAtMTAwNi04MmZhOTYzN2EyYmEyODViY2M3YzUwNTBjNzMwMTBiMmMxYjNkODAz
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2
LzgyZmE5NjM3YTJiYTI4NWJjYzdjNTA1MGM3MzAxMGIyYzFiM2Q4MDMKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi1pMzg2
L2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYtODJmYTk2MzdhMmJhMjg1YmNjN2M1MDUwYzcz
MDEwYjJjMWIzZDgwMwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAw
Ni84MmZhOTYzN2EyYmEyODViY2M3YzUwNTBjNzMwMTBiMmMxYjNkODAzL3ZtbGludXotMy4x
Mi4wLXJjNC0wMDAwNS1nODJmYTk2MwoKMjAxNC0xMC0wNiAwNDozNzoxNyBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAuCTI1CTEzMAkxNzMJMTkyCTE5NAkyOTYJMzAwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBz
dGVwcykKW2YzMjM2MGVmNjYwODQzNGEwMzJkYzdhZDI2MmQ0NWU5NjkzYzI3ZjNdIHg4Niwg
a2FzbHI6IFJlcG9ydCBrZXJuZWwgb2Zmc2V0IG9uIHBhbmljCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eC00L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1oeGIwLTEwMDYvYmx1ZXRvb3RoOm1hc3RlcjpmMzIzNjBlZjY2MDg0MzRh
MDMyZGM3YWQyNjJkNDVlOTY5M2MyN2YzOmJpc2VjdC1saW51eC00CgoyMDE0LTEwLTA2IDA0
OjQxOjE4IGYzMjM2MGVmNjYwODQzNGEwMzJkYzdhZDI2MmQ0NWU5NjkzYzI3ZjMgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtw
LWhzeDAyL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYtZjMyMzYwZWY2NjA4NDM0YTAzMmRj
N2FkMjYyZDQ1ZTk2OTNjMjdmMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWh4YjAtMTAwNi9mMzIzNjBlZjY2MDg0MzRhMDMyZGM3YWQyNjJkNDVlOTY5
M2MyN2YzCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2YzMjM2
MGVmNjYwODQzNGEwMzJkYzdhZDI2MmQ0NWU5NjkzYzI3ZjMvdm1saW51ei0zLjEyLjAtcmM0
LTAwMDA2LWdmMzIzNjBlCgoyMDE0LTEwLTA2IDA0OjQyOjE4IGRldGVjdGluZyBib290IHN0
YXRlIC4JNAk2NgkxNTcJMTYwCTI2MAkzMDAgU1VDQ0VTUwoKNjE0NWNmZTM5NGE3ZjEzOGY2
YjY0NDkxYzU2NjNmOTdkYmExMjQ1MCBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQg
NjE0NWNmZTM5NGE3ZjEzOGY2YjY0NDkxYzU2NjNmOTdkYmExMjQ1MApBdXRob3I6IEtlZXMg
Q29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPgpEYXRlOiAgIFRodSBPY3QgMTAgMTc6MTg6
MTggMjAxMyAtMDcwMAoKICAgIHg4Niwga2FzbHI6IFJhaXNlIHRoZSBtYXhpbXVtIHZpcnR1
YWwgYWRkcmVzcyB0byAtMSBHaUIgb24geDg2XzY0CiAgICAKICAgIE9uIDY0LWJpdCwgdGhp
cyByYWlzZXMgdGhlIG1heGltdW0gbG9jYXRpb24gdG8gLTEgR2lCIChmcm9tIC0xLjUgR2lC
KSwKICAgIHRoZSB1cHBlciBsaW1pdCBjdXJyZW50bHksIHNpbmNlIHRoZSBrZXJuZWwgZml4
bWFwIHBhZ2UgbWFwcGluZ3MgbmVlZAogICAgdG8gYmUgbW92ZWQgdG8gdXNlIHRoZSBvdGhl
ciAxIEdpQiAod2hpY2ggd291bGQgYmUgdGhlIHRoZW9yZXRpY2FsCiAgICBsaW1pdCB3aGVu
IGJ1aWxkaW5nIHdpdGggLW1jbW9kZWw9a2VybmVsKS4KICAgIAogICAgU2lnbmVkLW9mZi1i
eTogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+CiAgICBMaW5rOiBodHRwOi8v
bGttbC5rZXJuZWwub3JnL3IvMTM4MTQ1MDY5OC0yODcxMC03LWdpdC1zZW5kLWVtYWlsLWtl
ZXNjb29rQGNocm9taXVtLm9yZwogICAgU2lnbmVkLW9mZi1ieTogSC4gUGV0ZXIgQW52aW4g
PGhwYUBsaW51eC5pbnRlbC5jb20+Cgo6MDQwMDAwIDA0MDAwMCBhNDhhNjM1NWUzY2NkNjc2
MDI3MzE5ZmY1MjBiZjk1M2NiMDdhMGJiIDdiZWIxZmRkNzQ3OGI2YmVjMjU1NWEzNjRmYmZh
YzI5ZDdhNWEzYzQgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpIRUFEIGlzIG5vdyBhdCBm
MzIzNjBlLi4uIHg4Niwga2FzbHI6IFJlcG9ydCBrZXJuZWwgb2Zmc2V0IG9uIHBhbmljCmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaHhiMC0x
MDA2L2JsdWV0b290aDptYXN0ZXI6ZjMyMzYwZWY2NjA4NDM0YTAzMmRjN2FkMjYyZDQ1ZTk2
OTNjMjdmMzpiaXNlY3QtbGludXgtNAoKMjAxNC0xMC0wNiAwNDo0NjoyMyBmMzIzNjBlZjY2
MDg0MzRhMDMyZGM3YWQyNjJkNDVlOTY5M2MyN2YzIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWh4YjAtMTAwNi9mMzIzNjBlZjY2MDg0MzRhMDMyZGM3YWQyNjJkNDVlOTY5M2My
N2YzL3ZtbGludXotMy4xMi4wLXJjNC0wMDAwNi1nZjMyMzYwZQoKMjAxNC0xMC0wNiAwNDo0
NjoyNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMzI0CTM2MwkzNzUJNDI0CTQ5NAk1MTMJ
NTIwCTU3Mgk2NDIJNzA2CTcxMgk3OTcJOTAwIFNVQ0NFU1MKClByZXZpb3VzIEhFQUQgcG9z
aXRpb24gd2FzIGYzMjM2MGUuLi4geDg2LCBrYXNscjogUmVwb3J0IGtlcm5lbCBvZmZzZXQg
b24gcGFuaWMKSEVBRCBpcyBub3cgYXQgYTRjMDQ3NS4uLiBpZWVlODAyMTU0OiA2bG93cGFu
OiBEcm9wIFBBQ0tFVF9PVEhFUkhPU1Qgc2ticyBpbiA2bG93cGFuCmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2JsdWV0b290
aDptYXN0ZXI6YTRjMDQ3NWFjMWViNjcwMzJlNzU5MzI3YTQwZDhkNGIyY2YyYjk4ODpiaXNl
Y3QtbGludXgtNAogVEVTVCBGQUlMVVJFClsgICAgMC41MzM4ODhdIFBDSTogQ0xTIDAgYnl0
ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjUzNTExN10gVW5wYWNraW5nIGluaXRyYW1mcy4uLgpb
ICAgIDAuNTM1MTE3XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMC41MzYxOTVdIElu
aXRyYW1mcyB1bnBhY2tpbmcgZmFpbGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2ZQpb
ICAgIDAuNTM2MTk1XSBJbml0cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVuayBpbiBjb21w
cmVzc2VkIGFyY2hpdmUKWyAgICAwLjUzNzYyN10gZGVidWc6IHVubWFwcGluZyBpbml0IFtt
ZW0gMHhkMjc5MzAwMC0weGQzZmQ3ZmZmXQpbICAgIDAuNTM3NjI3XSBkZWJ1ZzogdW5tYXBw
aW5nIGluaXQgW21lbSAweGQyNzkzMDAwLTB4ZDNmZDdmZmZdClsgICAgMC41MzkzNTFdIEJV
RzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgClsgICAgMC41MzkzNTFdIEJVRzogdW5hYgpF
bGFwc2VkIHRpbWU6IDEwCnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUt
a3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2E0YzA0NzVh
YzFlYjY3MDMyZTc1OTMyN2E0MGQ4ZDRiMmNmMmI5ODgvdm1saW51ei0zLjE3LjAtcmMxLTAw
NDg2LWdhNGMwNDc1IC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0
eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHJjdXBk
YXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgcGFuaWM9LTEgc29mdGxvY2t1cF9wYW5p
Yz0xIG5taV93YXRjaGRvZz1wYW5pYyBvb3BzPXBhbmljIGxvYWRfcmFtZGlzaz0yIHByb21w
dF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3Jt
YWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvYmx1ZXRvb3RoOm1hc3RlcjphNGMwNDc1YWMx
ZWI2NzAzMmU3NTkzMjdhNDBkOGQ0YjJjZjJiOTg4OmJpc2VjdC1saW51eC00Ly52bWxpbnV6
LWE0YzA0NzVhYzFlYjY3MDMyZTc1OTMyN2E0MGQ4ZDRiMmNmMmI5ODgtMjAxNDEwMDYwMzIy
MjYtMS1pdmI0MSBicmFuY2g9Ymx1ZXRvb3RoL21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi9hNGMwNDc1YWMxZWI2NzAzMmU3NTkzMjdhNDBk
OGQ0YjJjZjJiOTg4L3ZtbGludXotMy4xNy4wLXJjMS0wMDQ4Ni1nYTRjMDQ3NSBkcmJkLm1p
bm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJkL3F1YW50YWwtY29y
ZS1pMzg2LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAt
bmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2
MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlk
LXF1YW50YWwtaXZiNDEtNjMgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1x
dWFudGFsLWl2YjQxLTYzIC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxs
IAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDYvYTRjMDQ3NWFjMWViNjcwMzJl
NzU5MzI3YTQwZDhkNGIyY2YyYjk4OC9kbWVzZy1xdWFudGFsLWl2YjQxLTYzOjIwMTQxMDA2
MDMyMzA5OmkzODYtcmFuZGNvbmZpZy1oeGIwLTEwMDY6My4xNy4wLXJjMS0wMDQ4Ni1nYTRj
MDQ3NToxMjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2E0YzA0NzVhYzFl
YjY3MDMyZTc1OTMyN2E0MGQ4ZDRiMmNmMmI5ODgvZG1lc2ctcXVhbnRhbC12cC0xMzoyMDE0
MTAwNjAzMTQxNTppMzg2LXJhbmRjb25maWctaHhiMC0xMDA2OjMuMTcuMC1yYzEtMDA0ODYt
Z2E0YzA0NzU6MTIyCjI5OjI6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBp
cyBub3cgYXQgYTRjMDQ3NSBpZWVlODAyMTU0OiA2bG93cGFuOiBEcm9wIFBBQ0tFVF9PVEhF
UkhPU1Qgc2ticyBpbiA2bG93cGFuCgo9PT09PT09PT0gbGludXMvbWFzdGVyID09PT09PT09
PQpGcm9tIGdpdDovL2dpdG1pcnJvci9saW51cwogICBlZjBhNTk5Li5iZmUwMWE1ICBtYXN0
ZXIgICAgIC0+IGxpbnVzL21hc3RlcgpGcm9tIGdpdDovL2dpdG1pcnJvci9saW51cwogKiBb
bmV3IHRhZ10gICAgICAgICB2My4xNyAgICAgIC0+IHYzLjE3Ck5vdGU6IGNoZWNraW5nIG91
dCAnbGludXMvbWFzdGVyJy4KCllvdSBhcmUgaW4gJ2RldGFjaGVkIEhFQUQnIHN0YXRlLiBZ
b3UgY2FuIGxvb2sgYXJvdW5kLCBtYWtlIGV4cGVyaW1lbnRhbApjaGFuZ2VzIGFuZCBjb21t
aXQgdGhlbSwgYW5kIHlvdSBjYW4gZGlzY2FyZCBhbnkgY29tbWl0cyB5b3UgbWFrZSBpbiB0
aGlzCnN0YXRlIHdpdGhvdXQgaW1wYWN0aW5nIGFueSBicmFuY2hlcyBieSBwZXJmb3JtaW5n
IGFub3RoZXIgY2hlY2tvdXQuCgpJZiB5b3Ugd2FudCB0byBjcmVhdGUgYSBuZXcgYnJhbmNo
IHRvIHJldGFpbiBjb21taXRzIHlvdSBjcmVhdGUsIHlvdSBtYXkKZG8gc28gKG5vdyBvciBs
YXRlcikgYnkgdXNpbmcgLWIgd2l0aCB0aGUgY2hlY2tvdXQgY29tbWFuZCBhZ2Fpbi4gRXhh
bXBsZToKCiAgZ2l0IGNoZWNrb3V0IC1iIG5ld19icmFuY2hfbmFtZQoKSEVBRCBpcyBub3cg
YXQgYmZlMDFhNS4uLiBMaW51eCAzLjE3CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2xpbnVzOm1hc3RlcjpiZmUwMWE1YmEy
NDkwZjI5OWUxZDJkNTUwOGNiYmJhZGQ4OTdiYmU5OmJpc2VjdC1saW51eC00CgoyMDE0LTEw
LTA2IDA0OjU2OjUyIGJmZTAxYTViYTI0OTBmMjk5ZTFkMmQ1NTA4Y2JiYmFkZDg5N2JiZTkg
cmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2L2JmZTAxYTViYTI0OTBm
Mjk5ZTFkMmQ1NTA4Y2JiYmFkZDg5N2JiZTkvdm1saW51ei0zLjE3LjAKCjIwMTQtMTAtMDYg
MDQ6NTY6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLgkxNi4JMjEJMjYJMjcJMzUuLi4u
CTM2Li4uLgkzOC4JMzkuLi4JNDAuLi4JNDEuLgk0Mgk0Ny4JNDkuCTY0Li4JNjcJNjkgVEVT
VCBGQUlMVVJFClsgICAgMC4zODEyNzJdIFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQK
WyAgICAwLjM4MjEzMF0gVW5wYWNraW5nIGluaXRyYW1mcy4uLgpbICAgIDAuMzgyMTMwXSBV
bnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMC4zODI2ODBdIEluaXRyYW1mcyB1bnBhY2tp
bmcgZmFpbGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2ZQpbICAgIDAuMzgyNjgwXSBJ
bml0cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVuayBpbiBjb21wcmVzc2VkIGFyY2hpdmUK
WyAgICAwLjM4MzY0MF0gZGVidWc6IHVubWFwcGluZyBpbml0IFttZW0gMHhkMjdhYjAwMC0w
eGQzZmVmZmZmXQpbICAgIDAuMzgzNjQwXSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAw
eGQyN2FiMDAwLTB4ZDNmZWZmZmZdClsgICAgMC4zODQ2MjldIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgClsgICAgMC4zODQ2MjldIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJu
ZWwgcGFnaW5nIHJlcXVlc3RwYWdpbmcgcmVxdWVzdCBhdCBkMjgzNTAwMAogYXQgZDI4MzUw
MDAKWyAgICAwLjM4NTYyM10gSVA6ClsgICAgMC4zODU2MjNdIElQOiBbPGQxYTI1N2MzPl0g
X19jaGFuZ2VfcGFnZV9hdHRyX3NldF9jbHIrMHhiZC8weDViOAogWzxkMWEyNTdjMz5dIF9f
Y2hhbmdlX3BhZ2VfYXR0cl9zZXRfY2xyKzB4YmQvMHg1YjgKWyAgICAwLjM4NjU5MF0gKnBk
cHQgPSAwMDAwMDAwMDEyMThiMDAxIApbICAgIDAuMzg2NTkwXSAqcGRwdCA9IDAwMDAwMDAw
MTIxOGIwMDEgKnBkZSA9IDAwMDAwMDAwMTI4MzQwNjMgKnBkZSA9IDAwMDAwMDAwMTI4MzQw
NjMgKnB0ZSA9IDgwMDAwMDAwMTI4MzUwNjIgKnB0ZSA9IDgwMDAwMDAwMTI4MzUwNjIgCgpb
ICAgIDAuMzg3ODI1XSBPb3BzOiAwMDAwIFsjMV0gClsgICAgMC4zODc4MjVdIE9vcHM6IDAw
MDAgWyMxXSBTTVAgU01QIERFQlVHX1BBR0VBTExPQ0RFQlVHX1BBR0VBTExPQwoKWyAgICAw
LjM4ODUyMV0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4x
Ny4wICMxMjgKWyAgICAwLjM4ODUyMV0gQ1BVOiAxIFBJRDogMSBDb21tOiBzd2FwcGVyLzAg
Tm90IHRhaW50ZWQgMy4xNy4wICMxMjgKWyAgICAwLjM4ODUyMV0gdGFzazogZDEwNThkNzAg
dGk6IGQxMDVhMDAwIHRhc2sudGk6IGQxMDVhMDAwClsgICAgMC4zODg1MjFdIHRhc2s6IGQx
MDU4ZDcwIHRpOiBkMTA1YTAwMCB0YXNrLnRpOiBkMTA1YTAwMApbICAgIDAuMzg4NTIxXSBF
SVA6IDAwNjA6WzxkMWEyNTdjMz5dIEVGTEFHUzogMDAwMTAyODYgQ1BVOiAxClsgICAgMC4z
ODg1MjFdIEVJUDogMDA2MDpbPGQxYTI1N2MzPl0gRUZMQUdTOiAwMDAxMDI4NiBDUFU6IDEK
WyAgICAwLjM4ODUyMV0gRUlQIGlzIGF0IF9fY2hhbmdlX3BhZ2VfYXR0cl9zZXRfY2xyKzB4
YmQvMHg1YjgKWyAgICAwLjM4ODUyMV0gRUlQIGlzIGF0IF9fY2hhbmdlX3BhZ2VfYXR0cl9z
ZXRfY2xyKzB4YmQvMHg1YjgKWyAgICAwLjM4ODUyMV0gRUFYOiBkMjgzNTAwMCBFQlg6IGQx
MDViZTcwIEVDWDogZDEwNWJlMDggRURYOiAwMDAwMDAwMApbICAgIDAuMzg4NTIxXSBFQVg6
IGQyODM1MDAwIEVCWDogZDEwNWJlNzAgRUNYOiBkMTA1YmUwOCBFRFg6IDAwMDAwMDAwClsg
ICAgMC4zODg1MjFdIEVTSTogMTI5ZmYxNjMgRURJOiBkMmEwMDAwMCBFQlA6IGQxMDViZTQ4
IEVTUDogZDEwNWJkYjgKWyAgICAwLjM4ODUyMV0gRVNJOiAxMjlmZjE2MyBFREk6IGQyYTAw
MDAwIEVCUDogZDEwNWJlNDggRVNQOiBkMTA1YmRiOApbICAgIDAuMzg4NTIxXSAgRFM6IDAw
N2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwZTAgU1M6IDAwNjgKWyAgICAwLjM4ODUyMV0g
IERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICAgMC4z
ODg1MjFdIENSMDogODAwNTAwM2IgQ1IyOiBkMjgzNTAwMCBDUjM6IDEyMThlMDAwIENSNDog
MDAwMDA2YjAKWyAgICAwLjM4ODUyMV0gQ1IwOiA4MDA1MDAzYiBDUjI6IGQyODM1MDAwIENS
MzogMTIxOGUwMDAgQ1I0OiAwMDAwMDZiMApbICAgIDAuMzg4NTIxXSBTdGFjazoKWyAgICAw
LjM4ODUyMV0gU3RhY2s6ClsgICAgMC4zODg1MjFdICBkMmMwMDAwMApbICAgIDAuMzg4NTIx
XSAgZDJjMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgZDFmODQ2ODAgZDFmODQ2ODAgZDEwNWJk
ZjggZDEwNWJkZjggZDFmODQ2ODAgZDFmODQ2ODAgZDEwNWJkZDggZDEwNWJkZDggZDFkNWUx
N2UgZDFkNWUxN2UgMDAwMDAwMDAgMDAwMDAwMDAKClsgICAgMC4zODg1MjFdICBkMTA1YmUx
NApbICAgIDAuMzg4NTIxXSAgZDEwNWJlMTQgMDAwMDAyMDAgMDAwMDAyMDAgZDJhMDAwMDAg
ZDJhMDAwMDAgMDAwMDAwMDEgMDAwMDAwMDEgZDEwNWJlMzQgZDEwNWJlMzQgZDEwNWJlMzAg
ZDEwNWJlMzAgMTI5ZmYwNjIgMTI5ZmYwNjIgODAwMDAwMDAgODAwMDAwMDAKClsgICAgMC4z
ODg1MjFdICA4MDAwMDAwMApbICAgIDAuMzg4NTIxXSAgODAwMDAwMDAgMDAwMDE1ZjAgMDAw
MDE1ZjAgMTI5ZmYxNjMgMTI5ZmYxNjMgZDI4MzUwMDAgZDI4MzUwMDAgMDAwMDAwMDEgMDAw
MDAwMDEgMDAwMDAwMjAgMDAwMDAwMjAgZDIxODUxMjggZDIxODUxMjggZDEwNWJlNDggZDEw
NWJlNDgKClsgICAgMC4zODg1MjFdIENhbGwgVHJhY2U6ClsgICAgMC4zODg1MjFdIENhbGwg
VHJhY2U6ClsgICAgMC4zODg1MjFdICBbPGQxZDVlMTdlPl0gPyBfcmF3X3NwaW5fdW5sb2Nr
KzB4MWQvMHgyNwpbICAgIDAuMzg4NTIxXSAgWzxkMWQ1ZTE3ZT5dID8gX3Jhd19zcGluX3Vu
bG9jaysweDFkLzB4MjcKWyAgICAwLjM4ODUyMV0gIFs8ZDFhYWRmMTE+XSA/IHZtX3VubWFw
X2FsaWFzZXMrMHgxMGQvMHgxMTYKWyAgICAwLjM4ODUyMV0gIFs8ZDFhYWRmMTE+XSA/IHZt
X3VubWFwX2FsaWFzZXMrMHgxMGQvMHgxMTYKWyAgICAwLjM4ODUyMV0gIFs8ZDFhMjVlM2Q+
XSBjaGFuZ2VfcGFnZV9hdHRyX3NldF9jbHIrMHgxN2YvMHgzMDIKWyAgICAwLjM4ODUyMV0g
IFs8ZDFhMjVlM2Q+XSBjaGFuZ2VfcGFnZV9hdHRyX3NldF9jbHIrMHgxN2YvMHgzMDIKWyAg
ICAwLjM4ODUyMV0gIFs8ZDFhMjYwZTY+XSBjaGFuZ2VfcGFnZV9hdHRyX2NsZWFyKzB4MjIv
MHgyNApbICAgIDAuMzg4NTIxXSAgWzxkMWEyNjBlNj5dIGNoYW5nZV9wYWdlX2F0dHJfY2xl
YXIrMHgyMi8weDI0ClsgICAgMC4zODg1MjFdICBbPGQxYTI2NDRkPl0gc2V0X21lbW9yeV9u
cCsweDE1LzB4MTcKWyAgICAwLjM4ODUyMV0gIFs8ZDFhMjY0NGQ+XSBzZXRfbWVtb3J5X25w
KzB4MTUvMHgxNwpbICAgIDAuMzg4NTIxXSAgWzxkMWEyMzZiNT5dIGZyZWVfaW5pdF9wYWdl
cysweDVmLzB4NmEKWyAgICAwLjM4ODUyMV0gIFs8ZDFhMjM2YjU+XSBmcmVlX2luaXRfcGFn
ZXMrMHg1Zi8weDZhClsgICAgMC4zODg1MjFdICBbPGQxZmZmNjk4Pl0gZnJlZV9pbml0cmRf
bWVtKzB4MjYvMHgyYQpbICAgIDAuMzg4NTIxXSAgWzxkMWZmZjY5OD5dIGZyZWVfaW5pdHJk
X21lbSsweDI2LzB4MmEKWyAgICAwLjM4ODUyMV0gIFs8ZDFmZjFjMDA+XSBwb3B1bGF0ZV9y
b290ZnMrMHhjNi8weGU5ClsgICAgMC4zODg1MjFdICBbPGQxZmYxYzAwPl0gcG9wdWxhdGVf
cm9vdGZzKzB4YzYvMHhlOQpbICAgIDAuMzg4NTIxXSAgWzxkMWZmMWIzYT5dID8gbWF5YmVf
bGluaysweGRkLzB4ZGQKWyAgICAwLjM4ODUyMV0gIFs8ZDFmZjFiM2E+XSA/IG1heWJlX2xp
bmsrMHhkZC8weGRkClsgICAgMC4zODg1MjFdICBbPGQxZmYwYzI3Pl0gZG9fb25lX2luaXRj
YWxsKzB4MTVkLzB4MTZjClsgICAgMC4zODg1MjFdICBbPGQxZmYwYzI3Pl0gZG9fb25lX2lu
aXRjYWxsKzB4MTVkLzB4MTZjClsgICAgMC4zODg1MjFdICBbPGQxZmYwNGUzPl0gPyByZXBh
aXJfZW52X3N0cmluZysweDEyLzB4NTQKWyAgICAwLjM4ODUyMV0gIFs8ZDFmZjA0ZTM+XSA/
IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1NApbICAgIDAuMzg4NTIxXSAgWzxkMWE0NTFi
Zj5dID8gcGFyc2VfYXJncysweDE4YS8weDI2OQpbICAgIDAuMzg4NTIxXSAgWzxkMWE0NTFi
Zj5dID8gcGFyc2VfYXJncysweDE4YS8weDI2OQpbICAgIDAuMzg4NTIxXSAgWzxkMWZmMGQz
Nz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTAxLzB4MTc5ClsgICAgMC4zODg1MjFdICBb
PGQxZmYwZDM3Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMDEvMHgxNzkKWyAgICAwLjM4
ODUyMV0gIFs8ZDFkNTcyYTU+XSBrZXJuZWxfaW5pdCsweDgvMHhiOApbICAgIDAuMzg4NTIx
XSAgWzxkMWQ1NzJhNT5dIGtlcm5lbF9pbml0KzB4OC8weGI4ClsgICAgMC4zODg1MjFdICBb
PGQxZDVlYTQxPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICAwLjM4
ODUyMV0gIFs8ZDFkNWVhNDE+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjEvMHgzMApb
ICAgIDAuMzg4NTIxXSAgWzxkMWQ1NzI5ZD5dID8gcmVzdF9pbml0KzB4YTUvMHhhNQpbICAg
IDAuMzg4NTIxXSAgWzxkMWQ1NzI5ZD5dID8gcmVzdF9pbml0KzB4YTUvMHhhNQpbICAgIDAu
Mzg4NTIxXSBDb2RlOgpbICAgIDAuMzg4NTIxXSBDb2RlOiBmOCBmOCAyNSAyNSAwMCAwMCAw
MCAwMCBlMCBlMCBmZiBmZiA4OSA4OSA0NSA0NSA5OCA5OCAwNSAwNSAwMCAwMCAwMCAwMCAy
MCAyMCAwMCAwMCA4OSA4OSA4NSA4NSA3MCA3MCBmZiBmZiBmZiBmZiBmZiBmZiA4YiA4YiA0
MyA0MyAwNCAwNCA4ZCA4ZCA0ZCA0ZCBjMCBjMCA4OSA4OSBmYSBmYSBlOCBlOCAyOCAyOCBm
ZiBmZiBmZiBmZiBmZiBmZiA4NSA4NSBjMCBjMCA4OSA4OSA0NSA0NSBiYyBiYyA3NCA3NCAy
MCAyMCA4YiA4YiA0NSA0NSBiYyBiYyA8OGI+IDw4Yj4gMDAgMDAgODkgODkgNDUgNDUgYjgg
YjggOGIgOGIgNDUgNDUgYmMgYmMgOGIgOGIgNDAgNDAgMDQgMDQgODkgODkgNDUgNDUgYjAg
YjAgOGIgOGIgNDUgNDUgYjggYjggOGIgOGIgNTUgNTUgYjAgYjAgZTggZTgKClsgICAgMC4z
ODg1MjFdIEVJUDogWzxkMWEyNTdjMz5dIApbICAgIDAuMzg4NTIxXSBFSVA6IFs8ZDFhMjU3
YzM+XSBfX2NoYW5nZV9wYWdlX2F0dHJfc2V0X2NscisweGJkLzB4NWI4X19jaGFuZ2VfcGFn
ZV9hdHRyX3NldF9jbHIrMHhiZC8weDViOCBTUzpFU1AgMDA2ODpkMTA1YmRiOAogU1M6RVNQ
IDAwNjg6ZDEwNWJkYjgKWyAgICAwLjM4ODUyMV0gQ1IyOiAwMDAwMDAwMGQyODM1MDAwClsg
ICAgMC4zODg1MjFdIENSMjogMDAwMDAwMDBkMjgzNTAwMApbICAgIDAuMzg4NTIxXSAtLS1b
IGVuZCB0cmFjZSBiZDZhM2EyM2YzM2I1NzEyIF0tLS0KWyAgICAwLjM4ODUyMV0gLS0tWyBl
bmQgdHJhY2UgYmQ2YTNhMjNmMzNiNTcxMiBdLS0tCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWh4YjAtMTAwNi9iZmUwMWE1YmEyNDkwZjI5OWUxZDJkNTUwOGNiYmJhZGQ4OTdiYmU5L2Rt
ZXNnLXF1YW50YWwtdnAtODoyMDE0MTAwNjA1MTc1MzppMzg2LXJhbmRjb25maWctaHhiMC0x
MDA2OjMuMTcuMDoxMjgKNjk6MToyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgoKPT09
PT09PT09IG5leHQvbWFzdGVyID09PT09PT09PQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0
CiArIDRkZWNkMjQuLi5kZGY2NzhiIGFrcG0gICAgICAgLT4gbmV4dC9ha3BtICAoZm9yY2Vk
IHVwZGF0ZSkKICsgNmZlNjc2Yi4uLjcwODZlNzggYWtwbS1iYXNlICAtPiBuZXh0L2FrcG0t
YmFzZSAgKGZvcmNlZCB1cGRhdGUpCiArIDdmNzZhODEuLi4yZTFkMDA0IG1hc3RlciAgICAg
LT4gbmV4dC9tYXN0ZXIgIChmb3JjZWQgdXBkYXRlKQogICBhNDRmODY3Li5iNjAxY2UwICBz
dGFibGUgICAgIC0+IG5leHQvc3RhYmxlCkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICog
W25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MTAwMyAtPiBuZXh0LTIwMTQxMDAzClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIGJmZTAxYTUuLi4gTGludXggMy4xNwpIRUFEIGlzIG5v
dyBhdCAyZTFkMDA0Li4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0
MTAwMwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWh4YjAtMTAwNi9uZXh0Om1hc3RlcjoyZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFm
YWRmNWU2ZTkxOmJpc2VjdC1saW51eC00CgoyMDE0LTEwLTA2IDA1OjE5OjE4IDJlMWQwMDRi
OTY0NTYyOGM2NGEyZGI1NWVmNmI4MWZhZGY1ZTZlOTEgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL2kzODYtcmFu
ZGNvbmZpZy1oeGIwLTEwMDYtMmUxZDAwNGI5NjQ1NjI4YzY0YTJkYjU1ZWY2YjgxZmFkZjVl
NmU5MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAt
MTAwNi8yZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFmYWRmNWU2ZTkxCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIt
aTM4Ni9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LTJlMWQwMDRiOTY0NTYyOGM2NGEyZGI1
NWVmNmI4MWZhZGY1ZTZlOTEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oeGIw
LTEwMDYvMmUxZDAwNGI5NjQ1NjI4YzY0YTJkYjU1ZWY2YjgxZmFkZjVlNmU5MS92bWxpbnV6
LTMuMTcuMC1yYzctbmV4dC0yMDE0MTAwMwoKMjAxNC0xMC0wNiAwNToyMzoxOCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAJMQk0MSBURVNUIEZBSUxVUkUKWyAgICAwLjM2MzQxMF0gUENJOiBD
TFMgMCBieXRlcywgZGVmYXVsdCA2NApbICAgIDAuMzY0NDgxXSBVbnBhY2tpbmcgaW5pdHJh
bWZzLi4uClsgICAgMC4zNjQ0ODFdIFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAwLjM2
NTMwOF0gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBh
cmNoaXZlClsgICAgMC4zNjUzMDhdIEluaXRyYW1mcyB1bnBhY2tpbmcgZmFpbGVkOiBqdW5r
IGluIGNvbXByZXNzZWQgYXJjaGl2ZQpbICAgIDAuMzY2NjY3XSBkZWJ1ZzogdW5tYXBwaW5n
IGluaXQgW21lbSAweGQyNzkzMDAwLTB4ZDNmZDdmZmZdClsgICAgMC4zNjY2NjddIGRlYnVn
OiB1bm1hcHBpbmcgaW5pdCBbbWVtIDB4ZDI3OTMwMDAtMHhkM2ZkN2ZmZl0KWyAgICAwLjM2
ODAxMF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKRWxhcHNlZCB0aW1lOiA1CnFl
bXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaHhiMC0xMDA2LzJlMWQwMDRiOTY0NTYyOGM2NGEyZGI1NWVm
NmI4MWZhZGY1ZTZlOTEvdm1saW51ei0zLjE3LjAtcmM3LW5leHQtMjAxNDEwMDMgLWFwcGVu
ZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFw
aWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90
aW1lb3V0PTEwMCBwYW5pYz0tMSBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBh
bmljIG9vcHM9cGFuaWMgbG9hZF9yYW1kaXNrPTIgcHJvbXB0X3JhbWRpc2s9MCBjb25zb2xl
PXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAg
cncgbGluaz0va2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWh4
YjAtMTAwNi9uZXh0Om1hc3RlcjoyZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFmYWRm
NWU2ZTkxOmJpc2VjdC1saW51eC00Ly52bWxpbnV6LTJlMWQwMDRiOTY0NTYyOGM2NGEyZGI1
NWVmNmI4MWZhZGY1ZTZlOTEtMjAxNDEwMDYwNTIyMTAtMTg1LWl2YjQyIGJyYW5jaD1uZXh0
L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4YjAtMTAwNi8y
ZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFmYWRmNWU2ZTkxL3ZtbGludXotMy4xNy4w
LXJjNy1uZXh0LTIwMTQxMDAzIGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0cmQgL2tlcm5l
bC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDMyMCAtc21wIDIgLW5l
dCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9
bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAt
cGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1pdmI0Mi05NiAtc2VyaWFsIGZp
bGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtaXZiNDItOTYgLWRhZW1vbml6ZSAt
ZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWh4
YjAtMTAwNi8yZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFmYWRmNWU2ZTkxL2RtZXNn
LXF1YW50YWwtaXZiNDItOTY6MjAxNDEwMDYwNTIzNDM6aTM4Ni1yYW5kY29uZmlnLWh4YjAt
MTAwNjozLjE3LjAtcmM3LW5leHQtMjAxNDEwMDM6MTU2CjQ1OjE6MSBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwoK

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc4-00007-g6145cfe"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0-rc4 Kernel Configuration
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
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
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
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
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_SECCOMP_FILTER=y
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_MWINCHIPC6=y
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

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
CONFIG_HT_IRQ=y
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
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
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
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

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
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
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
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
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
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
# CONFIG_MTD_CFI_GEOMETRY is not set
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
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
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
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

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
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
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
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
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
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
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
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
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
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
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
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_FSL_DSPI is not set
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

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

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set

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
CONFIG_WM8350_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

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
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_DA903X=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TWL4030 is not set
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_SH_VEU=y
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_V4L_RADIO_ISA_DRIVERS=y
CONFIG_RADIO_ISA=y
CONFIG_RADIO_CADET=y
CONFIG_RADIO_RTRACK=y
CONFIG_RADIO_RTRACK_PORT=30f
# CONFIG_RADIO_RTRACK2 is not set
CONFIG_RADIO_AZTECH=y
CONFIG_RADIO_AZTECH_PORT=350
CONFIG_RADIO_GEMTEK=y
CONFIG_RADIO_GEMTEK_PORT=34c
CONFIG_RADIO_GEMTEK_PROBE=y
# CONFIG_RADIO_MIROPCM20 is not set
# CONFIG_RADIO_SF16FMI is not set
CONFIG_RADIO_SF16FMR2=y
CONFIG_RADIO_TERRATEC=y
CONFIG_RADIO_TRUST=y
CONFIG_RADIO_TRUST_PORT=350
# CONFIG_RADIO_TYPHOON is not set
CONFIG_RADIO_ZOLTRIX=y
CONFIG_RADIO_ZOLTRIX_PORT=20c

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
CONFIG_SND_OPL4_LIB_SEQ=y
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=y
CONFIG_SND_AD1816A=y
CONFIG_SND_AD1848=y
CONFIG_SND_ALS100=y
CONFIG_SND_AZT1605=y
# CONFIG_SND_AZT2316 is not set
CONFIG_SND_AZT2320=y
CONFIG_SND_CMI8328=y
CONFIG_SND_CMI8330=y
# CONFIG_SND_CS4231 is not set
CONFIG_SND_CS4236=y
CONFIG_SND_ES1688=y
CONFIG_SND_ES18XX=y
# CONFIG_SND_SC6000 is not set
CONFIG_SND_GUSCLASSIC=y
CONFIG_SND_GUSEXTREME=y
CONFIG_SND_GUSMAX=y
# CONFIG_SND_INTERWAVE is not set
CONFIG_SND_INTERWAVE_STB=y
# CONFIG_SND_JAZZ16 is not set
CONFIG_SND_OPL3SA2=y
CONFIG_SND_OPTI92X_AD1848=y
# CONFIG_SND_OPTI92X_CS4231 is not set
CONFIG_SND_OPTI93X=y
# CONFIG_SND_MIRO is not set
CONFIG_SND_SB8=y
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SSCAPE is not set
CONFIG_SND_WAVEFRONT=y
# CONFIG_SND_MSND_PINNACLE is not set
CONFIG_SND_MSND_CLASSIC=y
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
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

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
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
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
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
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
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
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
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
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
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
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
# CONFIG_CRYPTO_HW is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--sdtB3X0nJg68CQEu--
