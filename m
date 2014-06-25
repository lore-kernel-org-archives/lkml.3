Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaFYJkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:40:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:16101 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaFYJj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:39:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="log'?scan'208";a="552997288"
Date: Wed, 25 Jun 2014 17:39:50 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jet Chen <jet.chen@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [lockdep] BUG: 9 unexpected failures (out of 253) - debugging
 disabled!
Message-ID: <20140625093950.GA611@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git locking/core
commit b7e4888bad0c84db587a2beae72dcf1c40ec0e52
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Mon Jun 23 14:25:00 2014 -0400
Commit:     Peter Zijlstra <a.p.zijlstra@chello.nl>
CommitDate: Tue Jun 24 16:39:40 2014 +0200

    lockdep: restrict the use of recursive read_lock with qrwlock
    
    Unlike the original unfair rwlock implementation, queued rwlock
    will grant lock according to the chronological sequence of the lock
    requests except when the lock requester is in the interrupt context.
    Consequently, recursive read_lock calls will now hang the process if
    there is a write_lock call somewhere in between the read_lock calls.
    
    This patch updates the lockdep implementation to look for recursive
    read_lock calls when queued rwlock is being used. A new read state (3)
    is used to mark those read_lock call that cannot be recursively called
    except in the interrupt context. The new read state does exhaust the
    2 bits available in held_lock:read bit field. The addition of any new
    read state in the future may require a redesign of how all those bits
    are squeezed together in the held_lock structure.
    
    Cc: Scott J Norton <scott.norton@hp.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Signed-off-by: Waiman Long <Waiman.Long@hp.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1403547900-40658-2-git-send-email-Waiman.Long@hp.com

+----------------------------------------------------+------------+------------+------------+
|                                                    | 6cc620bc8e | b7e4888bad | 5fe00a37f7 |
+----------------------------------------------------+------------+------------+------------+
| boot_successes                                     | 60         | 0          | 0          |
| boot_failures                                      | 0          | 20         | 13         |
| BUG:unexpected_failures(out_of)-debugging_disabled | 0          | 20         | 13         |
+----------------------------------------------------+------------+------------+------------+

[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-gb7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c141248b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844800 c1633fc8
[    0.000000]  c121fe62 c15a01b7 c15a01aa 00000780 c1633fe8 c1688a0d 000000ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c121fe62>] locking_selftest+0xd4/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-gb7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c141248b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844800 c1633fc8
[    0.000000]  c121feeb c15a01b7 c15a01bd 00000780 c1633fe8 c1688a0d 000000ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c121feeb>] locking_selftest+0x15d/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-gb7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c141248b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844800 c1633fc8
[    0.000000]  c121ff74 c15a01b7 c15a01ce 00000780 c1633fe8 c1688a0d 000000ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c121ff74>] locking_selftest+0x1e6/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-gb7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c141248b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844800 c1633fc8
[    0.000000]  c121fffd c15a01b7 c15a01e3 00000780 c1633fe8 c1688a0d 000000ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c121fffd>] locking_selftest+0x26f/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-gb7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c141248b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844800 c1633fc8
[    0.000000]  c1220086 c15a01b7 c15a01f8 00000780 c1633fe8 c1688a0d 000000ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c1220086>] locking_selftest+0x2f8/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-gb7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c141248b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844800 c1633fc8
[    0.000000]  c122010f c15a01b7 c15a0211 00000780 c1633fe8 c1688a0d 000000ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c122010f>] locking_selftest+0x381/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-gb7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c141248b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844800 c1633fc8
[    0.000000]  c1220198 c15a01b7 c15a022a 00000780 c1633fe8 c1688a0d 000000ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c1220198>] locking_selftest+0x40a/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

git bisect start 5fe00a37f7eb81f306abdffbf4d7093da51b8ccc a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee --
git bisect  bad f07035a109af7964e8446cb7ffc1721a1c2ce43c  # 23:40      0-     20  Merge 'peterz-queue/locking/core' into devel-lkp-hsx01-i386-201406242318
git bisect good 4dda92923e85460ff9299b486176f09cc25ca104  # 23:56     20+      0  Merge 'amirv/for-net' into devel-lkp-hsx01-i386-201406242318
git bisect good 5054910c90f25564062e9a1c78e4d37a51077955  # 00:18     20+      0  Merge 'amirv/for-netdev' into devel-lkp-hsx01-i386-201406242318
git bisect good 88f2b4c15e561bb5c28709d666364f273bf54b98  # 00:51     20+      0  rtmutex: Simplify rtmutex_slowtrylock()
git bisect good a57594a13a446d1a6ab1dcd48339f799ce586843  # 01:01     20+      0  rtmutex: Clarify the boost/deboost part
git bisect good 6cc620bc8e9b521e61f04eefbec0c41c01fb03b9  # 01:09     20+      0  rtmutex: Make the rtmutex tester depend on BROKEN
git bisect  bad b7e4888bad0c84db587a2beae72dcf1c40ec0e52  # 01:13      0-     20  lockdep: restrict the use of recursive read_lock with qrwlock
# first bad commit: [b7e4888bad0c84db587a2beae72dcf1c40ec0e52] lockdep: restrict the use of recursive read_lock with qrwlock
git bisect good 6cc620bc8e9b521e61f04eefbec0c41c01fb03b9  # 01:16     60+      0  rtmutex: Make the rtmutex tester depend on BROKEN
git bisect  bad 5fe00a37f7eb81f306abdffbf4d7093da51b8ccc  # 01:16      0-     13  0day head guard for 'devel-lkp-hsx01-i386-201406242318'
git bisect good 8b8f5d9715845f9ae2b89ce406e71877965b29ca  # 01:20     60+      0  Merge tag 'compress-3.16-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
git bisect good 3ab63dc6b2912b76632e34889ec26355096aaead  # 01:21     60+     63  Add linux-next specific files for 20140624


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 
	-kernel $kernel
	-initrd $initrd
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Fengguang

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb42-96:20140625011304:i386-randconfig-ha3-0624:3.16.0-rc1-00024-gb7e4888:12"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.16.0-rc1-00024-gb7e4888 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #12 SMP Wed Jun 25 01:11:58 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02100000, 0x02100fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x02101000, 0x02101fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c16772b0, node_mem_map d2=
52b020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 332 pages/cpu @d2293000 s1336896 r0 d22976 =
u1359872
[    0.000000] pcpu-alloc: s1336896 r0 d22976 u1359872 alloc=3D332*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 122956c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha3-0624/linux-deve=
l:devel-lkp-hsx01-i386-201406242318:b7e4888bad0c84db587a2beae72dcf1c40ec0e5=
2:bisect-linux5/.vmlinuz-b7e4888bad0c84db587a2beae72dcf1c40ec0e52-201406250=
11213-3-ivb42 branch=3Dlinux-devel/devel-lkp-hsx01-i386-201406242318 BOOT_I=
MAGE=3D/kernel/i386-randconfig-ha3-0624/b7e4888bad0c84db587a2beae72dcf1c40e=
c0e52/vmlinuz-3.16.0-rc1-00024-gb7e4888 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 279280K/327280K available (4198K kernel code, 336K r=
wdata, 2140K rodata, 1740K init, 8920K bss, 48000K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc1688000 - 0xc183b000   (1740 kB)
[    0.000000]       .data : 0xc1419bef - 0xc1686390   (2481 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1419bef   (4198 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd1c0a000 soft=3Dd1c0c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.16.0-rc1-00024-gb7e4888 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #12 SMP Wed Jun 25 01:11:58 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02100000, 0x02100fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x02101000, 0x02101fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c16772b0, node_mem_map d2=
52b020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 332 pages/cpu @d2293000 s1336896 r0 d22976 =
u1359872
[    0.000000] pcpu-alloc: s1336896 r0 d22976 u1359872 alloc=3D332*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 122956c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha3-0624/linux-deve=
l:devel-lkp-hsx01-i386-201406242318:b7e4888bad0c84db587a2beae72dcf1c40ec0e5=
2:bisect-linux5/.vmlinuz-b7e4888bad0c84db587a2beae72dcf1c40ec0e52-201406250=
11213-3-ivb42 branch=3Dlinux-devel/devel-lkp-hsx01-i386-201406242318 BOOT_I=
MAGE=3D/kernel/i386-randconfig-ha3-0624/b7e4888bad0c84db587a2beae72dcf1c40e=
c0e52/vmlinuz-3.16.0-rc1-00024-gb7e4888 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 279280K/327280K available (4198K kernel code, 336K r=
wdata, 2140K rodata, 1740K init, 8920K bss, 48000K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc1688000 - 0xc183b000   (1740 kB)
[    0.000000]       .data : 0xc1419bef - 0xc1686390   (2481 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1419bef   (4198 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd1c0a000 soft=3Dd1c0c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 5167 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c121fe62 c15a01b7 c15a01aa 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c121fe62>] locking_selftest+0xd4/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c121feeb c15a01b7 c15a01bd 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c121feeb>] locking_selftest+0x15d/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c121ff74 c15a01b7 c15a01ce 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c121ff74>] locking_selftest+0x1e6/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c121fffd c15a01b7 c15a01e3 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c121fffd>] locking_selftest+0x26f/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c1220086 c15a01b7 c15a01f8 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c1220086>] locking_selftest+0x2f8/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c122010f c15a01b7 c15a0211 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c122010f>] locking_selftest+0x381/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c1220198 c15a01b7 c15a022a 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c1220198>] locking_selftest+0x40a/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]   ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c12203bb c15a0286 c15a0272 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c12203bb>] locking_selftest+0x62d/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]              |  ok  |
[    0.000000]            recursive read-lock #2:             |FAILED|
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-00024-g=
b7e4888 #12
[    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000]  00000000 00000000 c1633f8c c141223b 00000001 c1633fb4 c1412=
48b c159ffe8
[    0.000000]  c140fce6 00000000 00000004 00000002 c16bf390 00020800 c1844=
800 c1633fc8
[    0.000000]  c1220418 c15a0286 c15a0295 00000780 c1633fe8 c1688a0d 00000=
0ea ffffffff
[    0.000000] Call Trace:
[    0.000000]  [<c141223b>] dump_stack+0x48/0x60
[    0.000000]  [<c141248b>] dotest+0x58/0x4bc
[    0.000000]  [<c140fce6>] ? printk+0x38/0x3a
[    0.000000]  [<c1220418>] locking_selftest+0x68a/0x1ddb
[    0.000000]  [<c1688a0d>] start_kernel+0x2e5/0x3a1
[    0.000000]  [<c16884c5>] ? set_init_arg+0x49/0x49
[    0.000000]  [<c16882af>] i386_start_kernel+0x79/0x7d
[    0.000000]              |  ok  |
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
[    0.000000] ------------------------------------------------------------=
-----
[    0.000000] BUG:   9 unexpected failures (out of 253) - debugging disabl=
ed! |
[    0.000000] ------------------------------------------------------------=
-----
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.386 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5388.22 Bogo=
MIPS (lpj=3D8977953)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] ACPI: Core revision 20140424
[    0.008763] ACPI: All ACPI Tables successfully acquired
[    0.010131] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.011003] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.012344] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012344] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.012344] tlb_flushall_shift: 6
[    0.013769] Freeing SMP alternatives memory: 20K (c183b000 - c1840000)
[    0.019229] Getting VERSION: 50014
[    0.019763] Getting VERSION: 50014
[    0.020006] Getting ID: 0
[    0.020470] Getting ID: f000000
[    0.021001] Getting LVT0: 8700
[    0.021482] Getting LVT1: 8400
[    0.021982] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.022744] enabled ExtINT on CPU#0
[    0.024003] ENABLING IO-APIC IRQs
[    0.024517] init IO_APIC IRQs
[    0.025025]  apic 0 pin 0 not connected
[    0.025580] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.026685] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.027814] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.028967] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.030016] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.031147] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.032250] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.033350] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.034501] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.035650] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.036693] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.037824] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.038962] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.040016] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.041164] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.043349]  apic 0 pin 16 not connected
[    0.043937]  apic 0 pin 17 not connected
[    0.044530]  apic 0 pin 18 not connected
[    0.045115]  apic 0 pin 19 not connected
[    0.045693]  apic 0 pin 20 not connected
[    0.046272]  apic 0 pin 21 not connected
[    0.046670]  apic 0 pin 22 not connected
[    0.047270]  apic 0 pin 23 not connected
[    0.048001] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.048908] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.050505] Using local APIC timer interrupts.
[    0.050505] calibrating APIC timer ...
[    0.053333] ... lapic delta =3D 6249623
[    0.053333] ... PM-Timer delta =3D 357933
[    0.053333] ... PM-Timer result ok
[    0.053333] ..... delta 6249623
[    0.053333] ..... mult: 268419290
[    0.053333] ..... calibration result: 3333132
[    0.053333] ..... CPU clock speed is 2693.1886 MHz.
[    0.053333] ..... host bus clock speed is 1000.0132 MHz.
[    0.053391] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.056353] CPU 1 irqstacks, hard=3Dd1cb8000 soft=3Dd1cba000
[    0.056670] x86: Booting SMP configuration:
[    0.057379] .... node  #0, CPUs:      #1
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:13ffd021, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.073368] x86: Booted up 1 node, 2 CPUs
[    0.073362] KVM setup async PF for cpu 1
[    0.073366] kvm-stealtime: cpu 1, msr 123e16c0
[    0.075305] ----------------
[    0.075801] | NMI testsuite:
[    0.076669] --------------------
[    0.077157]   remote IPI:  ok  |
[    0.083704]    local IPI:  ok  |
[    0.096678] --------------------
[    0.097181] Good, all   2 testcases passed! |
[    0.097822] ---------------------------------
[    0.098466] smpboot: Total of 2 processors activated (10777.44 BogoMIPS)
[    0.100712] prandom: seed boundary self test passed
[    0.101503] prandom: 100 self tests passed
[    0.102320] NET: Registered protocol family 16
[    0.103854] cpuidle: using governor ladder
[    0.104473] cpuidle: using governor menu
[    0.105339] ACPI: bus type PCI registered
[    0.106137] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.106670] PCI: Using configuration type 1 for base access
[    0.113620] ACPI: Added _OSI(Module Device)
[    0.114231] ACPI: Added _OSI(Processor Device)
[    0.114850] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.115496] ACPI: Added _OSI(Processor Aggregator Device)
[    0.120828] ACPI: Interpreter enabled
[    0.121391] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140424/hwxface-580)
[    0.122762] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140424/hwxface-580)
[    0.123741] ACPI: (supports S0 S3 S5)
[    0.124308] ACPI: Using IOAPIC for interrupt routing
[    0.125010] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.132868] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.133341] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.134072] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.135082] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.136768] PCI host bridge to bus 0000:00
[    0.137369] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.138124] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.138918] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.140005] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.140880] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.141786] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.142961] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.143817] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.147297] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.148935] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.149824] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.150004] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.150867] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.151952] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.153608] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.154662] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.155836] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.158729] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.160550] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.166699] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.168044] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.169671] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.170809] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.176171] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.176945] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.178204] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.182292] pci_bus 0000:00: on NUMA node 0
[    0.183604] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.184784] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.185920] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.187052] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.188163] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.189584] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.190282] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.191427] vgaarb: loaded
[    0.191888] vgaarb: bridge control possible 0000:00:02.0
[    0.193685] SCSI subsystem initialized
[    0.194331] libata version 3.00 loaded.
[    0.194924] ACPI: bus type USB registered
[    0.195617] usbcore: registered new interface driver usbfs
[    0.196410] usbcore: registered new interface driver hub
[    0.196757] usbcore: registered new device driver usb
[    0.197515] pps_core: LinuxPPS API ver. 1 registered
[    0.198218] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.200119] Advanced Linux Sound Architecture Driver Initialized.
[    0.200876] PCI: Using ACPI for IRQ routing
[    0.201502] PCI: pci_cache_line_size set to 64 bytes
[    0.202261] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.203035] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.204112] Switched to clocksource kvm-clock
[    0.205029] FS-Cache: Loaded
[    0.205593] pnp: PnP ACPI init
[    0.205593] ACPI: bus type PNP registered
[    0.206025] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.207264] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.208125] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.209340] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.210221] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.211426] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.212328] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.213468] pnp 00:03: [dma 2]
[    0.214042] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.214945] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.216152] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.217059] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.218268] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.219149] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:3)
[    0.220371] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.221485] pnp: PnP ACPI: found 7 devices
[    0.222090] ACPI: bus type PNP unregistered
[    0.261677] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.262441] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.263196] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.264006] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.264876] NET: Registered protocol family 1
[    0.265520] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.266310] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.267107] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.267938] pci 0000:00:02.0: Boot video device
[    0.268592] PCI: CLS 0 bytes, default 64
[    0.269661] Unpacking initramfs...
[    1.037900] Freeing initrd memory: 24852K (d27ab000 - d3ff0000)
[    1.039325] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.040120] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.040965] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    1.043487] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    1.045251] futex hash table entries: 512 (order: 3, 32768 bytes)
[    1.046063] Initialise system trusted keyring
[    1.046801] Kprobe smoke test started
[    1.100103] Kprobe smoke test passed successfully
[    1.101825] ntfs: driver 2.1.30 [Flags: R/O DEBUG].
[    1.102621] QNX4 filesystem 0.2.3 registered.
[    1.103374] NILFS version 2 loaded
[    1.104039] msgmni has been set to 594
[    1.104623] Key type big_key registered
[    1.106988] Key type asymmetric registered
[    1.107582] Asymmetric key parser 'x509' registered
[    1.108288] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    1.109343] io scheduler noop registered
[    1.109921] io scheduler deadline registered (default)
[    1.110785] xz_dec_test: module loaded
[    1.111364] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
252 0' and write .xz files to it.
[    1.113189] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.114239] ACPI: Power Button [PWRF]
[    1.140889] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.166752] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.168775] serial: Freescale lpuart driver
[    1.169507] Non-volatile memory driver v1.3
[    1.170131] toshiba: not a supported Toshiba laptop
[    1.170862] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    1.171762] platform pc8736x_gpio.0: no device found
[    1.172465] nsc_gpio initializing
[    1.172993] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.173703] smapi::smapi_init, ERROR invalid usSmapiID
[    1.174393] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    1.175619] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    1.176649] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.177509] [drm] Initialized drm 1.1.0 20060810
[    1.178293] lkdtm: No crash points registered, enable through debugfs
[    1.179240] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.180440] usbcore: registered new interface driver rtsx_usb
[    1.181880] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    1.182930] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.183788] ehci-pci: EHCI PCI platform driver
[    1.184504] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    1.185354] usbcore: registered new interface driver cdc_wdm
[    1.186141] usbcore: registered new interface driver mdc800
[    1.192627] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.193753] usbcore: registered new interface driver microtekX6
[    1.194632] usbcore: registered new interface driver appledisplay
[    1.195456] usbcore: registered new interface driver cypress_cy7c63
[    1.196298] usbcore: registered new interface driver legousbtower
[    1.197137] usbcore: registered new interface driver usbtest
[    1.197917] usbcore: registered new interface driver usb_ehset_test
[    1.198758] usbcore: registered new interface driver trancevibrator
[    1.199590] usbcore: registered new interface driver usbsevseg
[    1.200391] usbcore: registered new interface driver yurex
[    1.201218] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.203025] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.203715] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.204745] mousedev: PS/2 mouse device common for all mice
[    1.205477] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    1.206926] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.208090] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    1.210365] usbcore: registered new interface driver synaptics_usb
[    1.211445] usbcore: registered new interface driver usbtouchscreen
[    1.212533] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    1.213324] cm109: Keymap for Komunikate KIP1000 phone loaded
[    1.214304] usbcore: registered new interface driver cm109
[    1.215032] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    1.216177] usbcore: registered new interface driver keyspan_remote
[    1.217352] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    1.218170] evbug: Connected device: input4 (PC Speaker at isa0061/input=
0)
[    1.219100] usbcore: registered new interface driver yealink
[    1.219840] i2c /dev entries driver
[    1.220466] usbcore: registered new interface driver i2c-diolan-u2c
[    1.221371] Driver for 1-wire Dallas network protocol.
[    1.223717] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.224846] usbcore: registered new interface driver line6usb
[    1.226301] oprofile: using NMI interrupt.
[    1.227168]=20
[    1.227168] printing PIC contents
[    1.227966] ... PIC  IMR: ffff
[    1.228446] ... PIC  IRR: 1013
[    1.228954] ... PIC  ISR: 0000
[    1.229434] ... PIC ELCR: 0c00
[    1.229947] printing local APIC contents on CPU#0/0:
[    1.230685] ... APIC ID:      00000000 (0)
[    1.231345] ... APIC VERSION: 00050014
[    1.231957] ... APIC TASKPRI: 00000000 (00)
[    1.232585] ... APIC PROCPRI: 00000000
[    1.233193] ... APIC LDR: 01000000
[    1.233276] ... APIC DFR: ffffffff
[    1.233276] ... APIC SPIV: 000001ff
[    1.233276] ... APIC ISR field:
[    1.233276] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.233276] ... APIC TMR field:
[    1.233276] 000000000200000000000000000000000000000000000000000000000000=
0000
[    1.233276] ... APIC IRR field:
[    1.233276] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.233276] ... APIC ESR: 00000000
[    1.233276] ... APIC ICR: 000008fd
[    1.233276] ... APIC ICR2: 02000000
[    1.233276] ... APIC LVTT: 000000ef
[    1.233276] ... APIC LVTPC: 00010000
[    1.233276] ... APIC LVT0: 00010700
[    1.233276] ... APIC LVT1: 00000400
[    1.233276] ... APIC LVTERR: 000000fe
[    1.233276] ... APIC TMICT: 0307c863
[    1.233276] ... APIC TMCCT: 02f517e3
[    1.233276] ... APIC TDCR: 00000003
[    1.233276]=20
[    1.247585] number of MP IRQ sources: 15.
[    1.248205] number of IO-APIC #0 registers: 24.
[    1.248869] testing the IO APIC.......................
[    1.249590] IO APIC #0......
[    1.250117] .... register #00: 00000000
[    1.250711] .......    : physical APIC id: 00
[    1.251369] .......    : Delivery Type: 0
[    1.251976] .......    : LTS          : 0
[    1.252572] .... register #01: 00170011
[    1.253169] .......     : max redirection entries: 17
[    1.253866] .......     : PRQ implemented: 0
[    1.254463] .......     : IO APIC version: 11
[    1.255098] .... register #02: 00000000
[    1.255690] .......     : arbitration: 00
[    1.256248] .... IRQ redirection table:
[    1.256850] 1    0    0   0   0    0    0    00
[    1.257484] 0    0    0   0   0    1    1    31
[    1.258114] 0    0    0   0   0    1    1    30
[    1.258766] 0    0    0   0   0    1    1    33
[    1.259398] 0    0    0   0   0    1    1    34
[    1.260063] 1    1    0   0   0    1    1    35
[    1.260734] 0    0    0   0   0    1    1    36
[    1.261368] 0    0    0   0   0    1    1    37
[    1.262023] 0    0    0   0   0    1    1    38
[    1.262695] 0    1    0   0   0    1    1    39
[    1.263318] 1    1    0   0   0    1    1    3A
[    1.263965] 1    1    0   0   0    1    1    3B
[    1.264600] 0    0    0   0   0    1    1    3C
[    1.265269] 0    0    0   0   0    1    1    3D
[    1.265921] 0    0    0   0   0    1    1    3E
[    1.266549] 0    0    0   0   0    1    1    3F
[    1.267189] 1    0    0   0   0    0    0    00
[    1.267844] 1    0    0   0   0    0    0    00
[    1.268473] 1    0    0   0   0    0    0    00
[    1.269118] 1    0    0   0   0    0    0    00
[    1.269758] 1    0    0   0   0    0    0    00
[    1.270444] 1    0    0   0   0    0    0    00
[    1.271080] 1    0    0   0   0    0    0    00
[    1.271735] 1    0    0   0   0    0    0    00
[    1.272392] IRQ to pin mappings:
[    1.272901] IRQ0 -> 0:2
[    1.273448] IRQ1 -> 0:1
[    1.273994] IRQ3 -> 0:3
[    1.274532] IRQ4 -> 0:4
[    1.275105] IRQ5 -> 0:5
[    1.275676] IRQ6 -> 0:6
[    1.276202] IRQ7 -> 0:7
[    1.276763] IRQ8 -> 0:8
[    1.277298] IRQ9 -> 0:9
[    1.277862] IRQ10 -> 0:10
[    1.278410] IRQ11 -> 0:11
[    1.278968] IRQ12 -> 0:12
[    1.279530] IRQ13 -> 0:13
[    1.280122] IRQ14 -> 0:14
[    1.280718] IRQ15 -> 0:15
[    1.281274] .................................... done.
[    1.281985] Using IPI No-Shortcut mode
[    1.282796] Loading compiled-in X.509 certificates
[    1.285068] Loaded X.509 cert 'Magrathea: Glacier signing key: fb9f5f609=
ddb47842de46f46141bbb3e2679ceff'
[    1.286945] Unregister pv shared memory for cpu 0
[    1.318610] CPU 0 is now offline
[    1.319187] ALSA device list:
[    1.319677]   No soundcards found.
[    1.321524] Freeing unused kernel memory: 1740K (c1688000 - c183b000)
[    1.322395] Write protecting the kernel text: 4200k
[    1.323117] Write protecting the kernel read-only data: 2144k
[    1.328648] random: init urandom read with 1 bits of entropy available
[    1.817756] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    1.819569] evbug: Connected device: input3 (ImExPS/2 Generic Explorer M=
ouse at isa0060/serio1/input0)
[    2.040066] tsc: Refined TSC clocksource calibration: 2693.467 MHz

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-h=
a3-0624/b7e4888bad0c84db587a2beae72dcf1c40ec0e52/vmlinuz-3.16.0-rc1-00024-g=
b7e4888 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuil=
d-tests/run-queue/kvm/i386-randconfig-ha3-0624/linux-devel:devel-lkp-hsx01-=
i386-201406242318:b7e4888bad0c84db587a2beae72dcf1c40ec0e52:bisect-linux5/.v=
mlinuz-b7e4888bad0c84db587a2beae72dcf1c40ec0e52-20140625011213-3-ivb42 bran=
ch=3Dlinux-devel/devel-lkp-hsx01-i386-201406242318 BOOT_IMAGE=3D/kernel/i38=
6-randconfig-ha3-0624/b7e4888bad0c84db587a2beae72dcf1c40ec0e52/vmlinuz-3.16=
=2E0-rc1-00024-gb7e4888 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd=
/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net u=
ser,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dloc=
altime -pidfile /dev/shm/kboot/pid-quantal-ivb42-96 -serial file:/dev/shm/k=
boot/serial-quantal-ivb42-96 -daemonize -display none -monitor null=20

--gKMricLos+KVdGMg
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-ha3-0624-5fe00a37f7eb81f306abdffbf4d7093da51b8ccc-BUG:----unexpected-failures----of------debugging-96781.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNWZlMDBhMy4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1s
a3AtaHN4MDEtaTM4Ni0yMDE0MDYyNDIzMTgnCmdpdCBjaGVja291dCBhNDk3YzNiYTFkOTdm
YzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtw
LWhzeDAxLWkzODYtMjAxNDA2MjQyMzE4OmE0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1
YmE4YzJjYjQyZWU6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNi0yNC0yMzozMDoxNiBhNDk3YzNi
YTFkOTdmYzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlIHJldXNlIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWhhMy0wNjI0L2E0OTdjM2JhMWQ5N2ZjNjljMWU3OGU3Yjk2NDM1YmE4YzJj
YjQyZWUvdm1saW51ei0zLjE2LjAtcmMyCgoyMDE0LTA2LTI0LTIzOjMwOjE2IGRldGVjdGlu
ZyBib290IHN0YXRlIC4uCTQJMjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCBhNDk3
YzNiYTFkOTdmYzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlCmdpdCBiaXNlY3Qgc3RhcnQg
NWZlMDBhMzdmN2ViODFmMzA2YWJkZmZiZjRkNzA5M2RhNTFiOGNjYyBhNDk3YzNiYTFkOTdm
YzY5YzFlNzhlN2I5NjQzNWJhOGMyY2I0MmVlIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXIt
YmlzZWN0OiBbIi1iIiwgIjVmZTAwYTM3ZjdlYjgxZjMwNmFiZGZmYmY0ZDcwOTNkYTUxYjhj
Y2MiLCAiLWciLCAiYTQ5N2MzYmExZDk3ZmM2OWMxZTc4ZTdiOTY0MzViYThjMmNiNDJlZSIs
ICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jv
b3QtYmlzZWN0L2xpbnV4NS9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAyMTEgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCltmMDcwMzVhMTA5
YWY3OTY0ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNjXSBNZXJnZSAncGV0ZXJ6LXF1ZXVlL2xv
Y2tpbmcvY29yZScgaW50byBkZXZlbC1sa3AtaHN4MDEtaTM4Ni0yMDE0MDYyNDIzMTgKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtw
LWhzeDAxLWkzODYtMjAxNDA2MjQyMzE4OmYwNzAzNWExMDlhZjc5NjRlODQ0NmNiN2ZmYzE3
MjFhMWMyY2U0M2M6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNi0yNC0yMzozMjoxOCBmMDcwMzVh
MTA5YWY3OTY0ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNjIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1o
YTMtMDYyNC1mMDcwMzVhMTA5YWY3OTY0ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNjCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvZjA3MDM1
YTEwOWFmNzk2NGU4NDQ2Y2I3ZmZjMTcyMWExYzJjZTQzYwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjI0LWYwNzAzNWExMDlhZjc5NjRlODQ0NmNiN2ZmYzE3MjFhMWMyY2U0M2MKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRj
b25maWctaGEzLTA2MjQtZjA3MDM1YTEwOWFmNzk2NGU4NDQ2Y2I3ZmZjMTcyMWExYzJjZTQz
YwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2YwNzAzNWExMDlh
Zjc5NjRlODQ0NmNiN2ZmYzE3MjFhMWMyY2U0M2Mvdm1saW51ei0zLjE2LjAtcmMyLTAwMTUy
LWdmMDcwMzVhCgoyMDE0LTA2LTI0LTIzOjQwOjE4IGRldGVjdGluZyBib290IHN0YXRlIC4g
VEVTVCBGQUlMVVJFClsgICAgMC4wMDAwMDBdICAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAg
ICAwLjAwMDAwMF0gICAgICAgICAgICAgICAgICAgICAgQS1BIGRlYWRsb2NrOiAgb2sgIHwg
IG9rICB8RkFJTEVEfApbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBw
ZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMyLTAwMTUyLWdmMDcwMzVhICM0MjcKWyAgICAw
LjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEv
MjAxMQpbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTI1
ZDUgMDAwMDAwMDEgYzE2MzNmYjQgYzE0MTI4MjUgYzE1YTAxZmMKWyAgICAwLjAwMDAwMF0g
IGMxNDEwMDgwIDAwMDAwMDAwIDAwMDAwMDA0IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAw
IGMxODQ1ODAwIGMxNjMzZmM4ClsgICAgMC4wMDAwMDBdICBjMTIxZmU4MiBjMTVhMDNjYiBj
MTVhMDNiZSAwMDAwMDc4MCBjMTYzM2ZlOCBjMTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpb
ICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjVkNT5d
IGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMC4wMDAwMDBdICBbPGMxNDEyODI1Pl0gZG90
ZXN0KzB4NTgvMHg0YmMKWyAgICAwLjAwMDAwMF0gIFs8YzE0MTAwODA+XSA/IHByaW50aysw
eDM4LzB4M2EKWyAgICAwLjAwMDAwMF0gIFs8YzEyMWZlODI+XSBsb2NraW5nX3NlbGZ0ZXN0
KzB4ZDQvMHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBkPl0gc3RhcnRfa2VybmVs
KzB4MmU1LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1Pl0gPyBzZXRfaW5pdF9h
cmcrMHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFmPl0gaTM4Nl9zdGFydF9r
ZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwgIG9rICB8ICBvayAgfApb
ICAgIDAuMDAwMDAwXSAgICAgICAgICAgICAgICAgIEEtQi1CLUEgZGVhZGxvY2s6ICBvayAg
fCAgb2sgIHxGQUlMRUR8ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dh
cHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzItMDAxNTItZ2YwNzAzNWEgIzQyNwpbICAg
IDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBjMTYzM2Y4YyBjMTQx
MjVkNSAwMDAwMDAwMSBjMTYzM2ZiNCBjMTQxMjgyNSBjMTVhMDFmYwpbICAgIDAuMDAwMDAw
XSAgYzE0MTAwODAgMDAwMDAwMDAgMDAwMDAwMDQgMDAwMDAwMDIgYzE2YmYzOTAgMDAwMjA4
MDAgYzE4NDU4MDAgYzE2MzNmYzgKWyAgICAwLjAwMDAwMF0gIGMxMjFmZjBiIGMxNWEwM2Ni
IGMxNWEwM2QxIDAwMDAwNzgwIGMxNjMzZmU4IGMxNjg4YTBkIDAwMDAwMGVhIGZmZmZmZmZm
ClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGMxNDEyNWQ1
Pl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAwLjAwMDAwMF0gIFs8YzE0MTI4MjU+XSBk
b3Rlc3QrMHg1OC8weDRiYwpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMDA4MD5dID8gcHJpbnRr
KzB4MzgvMHgzYQpbICAgIDAuMDAwMDAwXSAgWzxjMTIxZmYwYj5dIGxvY2tpbmdfc2VsZnRl
c3QrMHgxNWQvMHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBkPl0gc3RhcnRfa2Vy
bmVsKzB4MmU1LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1Pl0gPyBzZXRfaW5p
dF9hcmcrMHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFmPl0gaTM4Nl9zdGFy
dF9rZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwgIG9rICB8ICBvayAg
fApbICAgIDAuMDAwMDAwXSAgICAgICAgICAgICAgQS1CLUItQy1DLUEgZGVhZGxvY2s6ICBv
ayAgfCAgb2sgIHxGQUlMRUR8ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTog
c3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzItMDAxNTItZ2YwNzAzNWEgIzQyNwpb
ICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAw
MS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBjMTYzM2Y4YyBj
MTQxMjVkNSAwMDAwMDAwMSBjMTYzM2ZiNCBjMTQxMjgyNSBjMTVhMDFmYwpbICAgIDAuMDAw
MDAwXSAgYzE0MTAwODAgMDAwMDAwMDAgMDAwMDAwMDQgMDAwMDAwMDIgYzE2YmYzOTAgMDAw
MjA4MDAgYzE4NDU4MDAgYzE2MzNmYzgKWyAgICAwLjAwMDAwMF0gIGMxMjFmZjk0IGMxNWEw
M2NiIGMxNWEwM2UyIDAwMDAwNzgwIGMxNjMzZmU4IGMxNjg4YTBkIDAwMDAwMGVhIGZmZmZm
ZmZmClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGMxNDEy
NWQ1Pl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAwLjAwMDAwMF0gIFs8YzE0MTI4MjU+
XSBkb3Rlc3QrMHg1OC8weDRiYwpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMDA4MD5dID8gcHJp
bnRrKzB4MzgvMHgzYQpbICAgIDAuMDAwMDAwXSAgWzxjMTIxZmY5ND5dIGxvY2tpbmdfc2Vs
ZnRlc3QrMHgxZTYvMHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBkPl0gc3RhcnRf
a2VybmVsKzB4MmU1LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1Pl0gPyBzZXRf
aW5pdF9hcmcrMHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFmPl0gaTM4Nl9z
dGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwgIG9rICB8ICBv
ayAgfApbICAgIDAuMDAwMDAwXSAgICAgICAgICAgICAgQS1CLUMtQS1CLUMgZGVhZGxvY2s6
ICBvayAgfCAgb2sgIHxGQUlMRUR8ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29t
bTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzItMDAxNTItZ2YwNzAzNWEgIzQy
NwpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBjMTYzM2Y4
YyBjMTQxMjVkNSAwMDAwMDAwMSBjMTYzM2ZiNCBjMTQxMjgyNSBjMTVhMDFmYwpbICAgIDAu
MDAwMDAwXSAgYzE0MTAwODAgMDAwMDAwMDAgMDAwMDAwMDQgMDAwMDAwMDIgYzE2YmYzOTAg
MDAwMjA4MDAgYzE4NDU4MDAgYzE2MzNmYzgKWyAgICAwLjAwMDAwMF0gIGMxMjIwMDFkIGMx
NWEwM2NiIGMxNWEwM2Y3IDAwMDAwNzgwIGMxNjMzZmU4IGMxNjg4YTBkIDAwMDAwMGVhIGZm
ZmZmZmZmClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGMx
NDEyNWQ1Pl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAwLjAwMDAwMF0gIFs8YzE0MTI4
MjU+XSBkb3Rlc3QrMHg1OC8weDRiYwpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMDA4MD5dID8g
cHJpbnRrKzB4MzgvMHgzYQpbICAgIDAuMDAwMDAwXSAgWzxjMTIyMDAxZD5dIGxvY2tpbmdf
c2VsZnRlc3QrMHgyNmYvMHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBkPl0gc3Rh
cnRfa2VybmVsKzB4MmU1LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1Pl0gPyBz
ZXRfaW5pdF9hcmcrMHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFmPl0gaTM4
Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwgIG9rICB8
ICBvayAgfApbICAgIDAuMDAwMDAwXSAgICAgICAgICBBLUItQi1DLUMtRC1ELUEgZGVhZGxv
Y2s6ICBvayAgfCAgb2sgIHxGQUlMRUR8ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzItMDAxNTItZ2YwNzAzNWEg
IzQyNwpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBC
b2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBjMTYz
M2Y4YyBjMTQxMjVkNSAwMDAwMDAwMSBjMTYzM2ZiNCBjMTQxMjgyNSBjMTVhMDFmYwpbICAg
IDAuMDAwMDAwXSAgYzE0MTAwODAgMDAwMDAwMDAgMDAwMDAwMDQgMDAwMDAwMDIgYzE2YmYz
OTAgMDAwMjA4MDAgYzE4NDU4MDAgYzE2MzNmYzgKWyAgICAwLjAwMDAwMF0gIGMxMjIwMGE2
IGMxNWEwM2NiIGMxNWEwNDBjIDAwMDAwNzgwIGMxNjMzZmU4IGMxNjg4YTBkIDAwMDAwMGVh
IGZmZmZmZmZmClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBb
PGMxNDEyNWQ1Pl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAwLjAwMDAwMF0gIFs8YzE0
MTI4MjU+XSBkb3Rlc3QrMHg1OC8weDRiYwpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMDA4MD5d
ID8gcHJpbnRrKzB4MzgvMHgzYQpbICAgIDAuMDAwMDAwXSAgWzxjMTIyMDBhNj5dIGxvY2tp
bmdfc2VsZnRlc3QrMHgyZjgvMHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBkPl0g
c3RhcnRfa2VybmVsKzB4MmU1LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1Pl0g
PyBzZXRfaW5pdF9hcmcrMHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFmPl0g
aTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwgIG9r
ICB8ICBvayAgfApbICAgIDAuMDAwMDAwXSAgICAgICAgICBBLUItQy1ELUItRC1ELUEgZGVh
ZGxvY2s6ICBvayAgfCAgb2sgIHxGQUlMRUR8ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6
IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzItMDAxNTItZ2YwNzAz
NWEgIzQyNwpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBj
MTYzM2Y4YyBjMTQxMjVkNSAwMDAwMDAwMSBjMTYzM2ZiNCBjMTQxMjgyNSBjMTVhMDFmYwpb
ICAgIDAuMDAwMDAwXSAgYzE0MTAwODAgMDAwMDAwMDAgMDAwMDAwMDQgMDAwMDAwMDIgYzE2
YmYzOTAgMDAwMjA4MDAgYzE4NDU4MDAgYzE2MzNmYzgKWyAgICAwLjAwMDAwMF0gIGMxMjIw
MTJmIGMxNWEwM2NiIGMxNWEwNDI1IDAwMDAwNzgwIGMxNjMzZmU4IGMxNjg4YTBkIDAwMDAw
MGVhIGZmZmZmZmZmClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBd
ICBbPGMxNDEyNWQ1Pl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAwLjAwMDAwMF0gIFs8
YzE0MTI4MjU+XSBkb3Rlc3QrMHg1OC8weDRiYwpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMDA4
MD5dID8gcHJpbnRrKzB4MzgvMHgzYQpbICAgIDAuMDAwMDAwXSAgWzxjMTIyMDEyZj5dIGxv
Y2tpbmdfc2VsZnRlc3QrMHgzODEvMHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBk
Pl0gc3RhcnRfa2VybmVsKzB4MmU1LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1
Pl0gPyBzZXRfaW5pdF9hcmcrMHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFm
Pl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwg
IG9rICB8ICBvayAgfApbICAgIDAuMDAwMDAwXSAgICAgICAgICBBLUItQy1ELUItQy1ELUEg
ZGVhZGxvY2s6ICBvayAgfCAgb2sgIHxGQUlMRUR8ClsgICAgMC4wMDAwMDBdIENQVTogMCBQ
SUQ6IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTYuMC1yYzItMDAxNTItZ2Yw
NzAzNWEgIzQyNwpbICAgIDAuMDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2Nocywg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAw
MCBjMTYzM2Y4YyBjMTQxMjVkNSAwMDAwMDAwMSBjMTYzM2ZiNCBjMTQxMjgyNSBjMTVhMDFm
YwpbICAgIDAuMDAwMDAwXSAgYzE0MTAwODAgMDAwMDAwMDAgMDAwMDAwMDQgMDAwMDAwMDIg
YzE2YmYzOTAgMDAwMjA4MDAgYzE4NDU4MDAgYzE2MzNmYzgKWyAgICAwLjAwMDAwMF0gIGMx
MjIwMWI4IGMxNWEwM2NiIGMxNWEwNDNlIDAwMDAwNzgwIGMxNjMzZmU4IGMxNjg4YTBkIDAw
MDAwMGVhIGZmZmZmZmZmClsgICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAw
MDBdICBbPGMxNDEyNWQ1Pl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAwLjAwMDAwMF0g
IFs8YzE0MTI4MjU+XSBkb3Rlc3QrMHg1OC8weDRiYwpbICAgIDAuMDAwMDAwXSAgWzxjMTQx
MDA4MD5dID8gcHJpbnRrKzB4MzgvMHgzYQpbICAgIDAuMDAwMDAwXSAgWzxjMTIyMDFiOD5d
IGxvY2tpbmdfc2VsZnRlc3QrMHg0MGEvMHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4
YTBkPl0gc3RhcnRfa2VybmVsKzB4MmU1LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4
NGM1Pl0gPyBzZXRfaW5pdF9hcmcrMHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4
MmFmPl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sg
IHwgIG9rICB8ICBvayAgfApbICAgIDAuMDAwMDAwXSAgICAgICAgICAgICAgICAgICAgIGRv
dWJsZSB1bmxvY2s6ICBvayAgfCAgb2sgIHwgIG9rICB8ICBvayAgfCAgb2sgIHwgIG9rICB8
ClsgICAgMC4wMDAwMDBdICAgICAgICAgICAgICAgICAgIGluaXRpYWxpemUgaGVsZDogIG9r
ICB8ICBvayAgfCAgb2sgIHwgIG9rICB8ICBvayAgfCAgb2sgIHwKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaGEzLTA2MjQvZjA3MDM1YTEwOWFmNzk2NGU4NDQ2Y2I3ZmZjMTcyMWExYzJj
ZTQzYy9kbWVzZy1xdWFudGFsLWl2YjQxLTEwNToyMDE0MDYyNDIzNDAwMDppMzg2LXJhbmRj
b25maWctaGEzLTA2MjQ6My4xNi4wLXJjMi0wMDE1Mi1nZjA3MDM1YTo0MjcKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MjQvZjA3MDM1YTEwOWFmNzk2NGU4NDQ2Y2I3ZmZjMTcy
MWExYzJjZTQzYy9kbWVzZy1xdWFudGFsLWl2YjQxLTM2OjIwMTQwNjI0MjMzOTUzOmkzODYt
cmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAwMTUyLWdmMDcwMzVhOjQyNwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9mMDcwMzVhMTA5YWY3OTY0ZTg0NDZjYjdm
ZmMxNzIxYTFjMmNlNDNjL2RtZXNnLXF1YW50YWwtaXZiNDItNTU6MjAxNDA2MjQyMzM5NTk6
aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzItMDAxNTItZ2YwNzAzNWE6NDI3
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2YwNzAzNWExMDlhZjc5NjRlODQ0
NmNiN2ZmYzE3MjFhMWMyY2U0M2MvZG1lc2cteW9jdG8taXZiNDEtMjA6MjAxNDA2MjQyMzM5
NTU6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzItMDAxNTItZ2YwNzAzNWE6
NDI3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2YwNzAzNWExMDlhZjc5NjRl
ODQ0NmNiN2ZmYzE3MjFhMWMyY2U0M2MvZG1lc2cteW9jdG8taXZiNDItMzc6MjAxNDA2MjQy
MzM5NTg6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzItMDAxNTItZ2YwNzAz
NWE6NDI3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2YwNzAzNWExMDlhZjc5
NjRlODQ0NmNiN2ZmYzE3MjFhMWMyY2U0M2MvZG1lc2cteW9jdG8taXZiNDItNTQ6MjAxNDA2
MjQyMzQwMDE6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzItMDAxNTItZ2Yw
NzAzNWE6NDI3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2YwNzAzNWExMDlh
Zjc5NjRlODQ0NmNiN2ZmYzE3MjFhMWMyY2U0M2MvZG1lc2ctcXVhbnRhbC1pdmI0MS0xNjoy
MDE0MDYyNDIzNDAwNTppMzg2LXJhbmRjb25maWctaGEzLTA2MjQ6My4xNi4wLXJjMi0wMDE1
Mi1nZjA3MDM1YTo0MjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvZjA3MDM1
YTEwOWFmNzk2NGU4NDQ2Y2I3ZmZjMTcyMWExYzJjZTQzYy9kbWVzZy1xdWFudGFsLWl2YjQx
LTc4OjIwMTQwNjI0MjM0MDA1OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMy
LTAwMTUyLWdmMDcwMzVhOjQyNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9m
MDcwMzVhMTA5YWY3OTY0ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNjL2RtZXNnLXF1YW50YWwt
aXZiNDEtODA6MjAxNDA2MjQyMzQwMDM6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYu
MC1yYzItMDAxNTItZ2YwNzAzNWE6NDI3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjI0L2YwNzAzNWExMDlhZjc5NjRlODQ0NmNiN2ZmYzE3MjFhMWMyY2U0M2MvZG1lc2ctcXVh
bnRhbC1pdmI0MS04MToyMDE0MDYyNDIzNDAwMzppMzg2LXJhbmRjb25maWctaGEzLTA2MjQ6
My4xNi4wLXJjMi0wMDE1Mi1nZjA3MDM1YTo0MjcKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aGEzLTA2MjQvZjA3MDM1YTEwOWFmNzk2NGU4NDQ2Y2I3ZmZjMTcyMWExYzJjZTQzYy9kbWVz
Zy1xdWFudGFsLWl2YjQyLTE3OjIwMTQwNjI0MjM0MDEwOmkzODYtcmFuZGNvbmZpZy1oYTMt
MDYyNDozLjE2LjAtcmMyLTAwMTUyLWdmMDcwMzVhOjQyNwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1oYTMtMDYyNC9mMDcwMzVhMTA5YWY3OTY0ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNj
L2RtZXNnLXF1YW50YWwtaXZiNDItNDM6MjAxNDA2MjQyMzQwMDk6aTM4Ni1yYW5kY29uZmln
LWhhMy0wNjI0OjMuMTYuMC1yYzItMDAxNTItZ2YwNzAzNWE6NDI3Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWhhMy0wNjI0L2YwNzAzNWExMDlhZjc5NjRlODQ0NmNiN2ZmYzE3MjFhMWMy
Y2U0M2MvZG1lc2ctcXVhbnRhbC1pdmI0Mi01NToyMDE0MDYyNDIzNDAxMDppMzg2LXJhbmRj
b25maWctaGEzLTA2MjQ6My4xNi4wLXJjMi0wMDE1Mi1nZjA3MDM1YTo0MjcKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MjQvZjA3MDM1YTEwOWFmNzk2NGU4NDQ2Y2I3ZmZjMTcy
MWExYzJjZTQzYy9kbWVzZy1xdWFudGFsLWl2YjQyLTg1OjIwMTQwNjI0MjM0MDA5OmkzODYt
cmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAwMTUyLWdmMDcwMzVhOjQyNwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9mMDcwMzVhMTA5YWY3OTY0ZTg0NDZjYjdm
ZmMxNzIxYTFjMmNlNDNjL2RtZXNnLXlvY3RvLWl2YjQxLTQwOjIwMTQwNjI0MjM0MDAzOmkz
ODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAwMTUyLWdmMDcwMzVhOjQyNwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9mMDcwMzVhMTA5YWY3OTY0ZTg0NDZj
YjdmZmMxNzIxYTFjMmNlNDNjL2RtZXNnLXlvY3RvLWl2YjQxLTUyOjIwMTQwNjI0MjM0MDAy
OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAwMTUyLWdmMDcwMzVhOjQy
Nwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9mMDcwMzVhMTA5YWY3OTY0ZTg0
NDZjYjdmZmMxNzIxYTFjMmNlNDNjL2RtZXNnLXlvY3RvLWl2YjQxLTU0OjIwMTQwNjI0MjM0
MDAzOmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAwMTUyLWdmMDcwMzVh
OjQyNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9mMDcwMzVhMTA5YWY3OTY0
ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNjL2RtZXNnLXlvY3RvLWl2YjQxLTcyOjIwMTQwNjI0
MjM0MDA2OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAwMTUyLWdmMDcw
MzVhOjQyNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9mMDcwMzVhMTA5YWY3
OTY0ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNjL2RtZXNnLXlvY3RvLWl2YjQyLTM3OjIwMTQw
NjI0MjM0MDA5OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAwMTUyLWdm
MDcwMzVhOjQyNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9mMDcwMzVhMTA5
YWY3OTY0ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNjL2RtZXNnLXlvY3RvLWl2YjQyLTQzOjIw
MTQwNjI0MjM0MDA5OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAwMTUy
LWdmMDcwMzVhOjQyNwowOjIwOjIwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTsz
NW0yMDE0LTA2LTI0IDIzOjQwOjQ4IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNl
Y3QvbGludXg1L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMTUyIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbNGRkYTky
OTIzZTg1NDYwZmY5Mjk5YjQ4NjE3NmYwOWNjMjVjYTEwNF0gTWVyZ2UgJ2FtaXJ2L2Zvci1u
ZXQnIGludG8gZGV2ZWwtbGtwLWhzeDAxLWkzODYtMjAxNDA2MjQyMzE4CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eDUvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1p
Mzg2LTIwMTQwNjI0MjMxODo0ZGRhOTI5MjNlODU0NjBmZjkyOTliNDg2MTc2ZjA5Y2MyNWNh
MTA0OmJpc2VjdC1saW51eDUKCjIwMTQtMDYtMjQtMjM6NDA6NDkgNGRkYTkyOTIzZTg1NDYw
ZmY5Mjk5YjQ4NjE3NmYwOWNjMjVjYTEwNCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQt
NGRkYTkyOTIzZTg1NDYwZmY5Mjk5YjQ4NjE3NmYwOWNjMjVjYTEwNApDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LzRkZGE5MjkyM2U4NTQ2
MGZmOTI5OWI0ODYxNzZmMDljYzI1Y2ExMDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC00ZGRh
OTI5MjNlODU0NjBmZjkyOTliNDg2MTc2ZjA5Y2MyNWNhMTA0CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhh
My0wNjI0LTRkZGE5MjkyM2U4NTQ2MGZmOTI5OWI0ODYxNzZmMDljYzI1Y2ExMDQKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC80ZGRhOTI5MjNlODU0NjBmZjky
OTliNDg2MTc2ZjA5Y2MyNWNhMTA0L3ZtbGludXotMy4xNi4wLXJjMi0wMDA3OC1nNGRkYTky
OQoKMjAxNC0wNi0yNC0yMzo1NTo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTYJMjAgU1VD
Q0VTUwoKQmlzZWN0aW5nOiA3NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNyBzdGVwcykKWzUwNTQ5MTBjOTBmMjU1NjQwNjJlOWExYzc4ZTRkMzdhNTEw
Nzc5NTVdIE1lcmdlICdhbWlydi9mb3ItbmV0ZGV2JyBpbnRvIGRldmVsLWxrcC1oc3gwMS1p
Mzg2LTIwMTQwNjI0MjMxOApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg1L29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9s
aW51eC1kZXZlbDpkZXZlbC1sa3AtaHN4MDEtaTM4Ni0yMDE0MDYyNDIzMTg6NTA1NDkxMGM5
MGYyNTU2NDA2MmU5YTFjNzhlNGQzN2E1MTA3Nzk1NTpiaXNlY3QtbGludXg1CgoyMDE0LTA2
LTI0LTIzOjU2OjQ5IDUwNTQ5MTBjOTBmMjU1NjQwNjJlOWExYzc4ZTRkMzdhNTEwNzc5NTUg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LTUwNTQ5MTBjOTBmMjU1NjQwNjJlOWExYzc4
ZTRkMzdhNTEwNzc5NTUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1oYTMtMDYyNC81MDU0OTEwYzkwZjI1NTY0MDYyZTlhMWM3OGU0ZDM3YTUxMDc3OTU1
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MjQtNTA1NDkxMGM5MGYyNTU2NDA2MmU5YTFjNzhlNGQz
N2E1MTA3Nzk1NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC01MDU0OTEwYzkwZjI1NTY0MDYy
ZTlhMWM3OGU0ZDM3YTUxMDc3OTU1Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aGEzLTA2MjQvNTA1NDkxMGM5MGYyNTU2NDA2MmU5YTFjNzhlNGQzN2E1MTA3Nzk1NS92bWxp
bnV6LTMuMTYuMC1yYzItMDAxMzItZzUwNTQ5MTAKCjIwMTQtMDYtMjUtMDA6MTY6NDkgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgCTEJNgkxOAkyMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBi
YWQgYnJhbmNoIG1heSBiZSBwZXRlcnotcXVldWUvbG9ja2luZy9jb3JlCmxpbmVhci1iaXNl
Y3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2Vj
dCBzdGFydCBmMDcwMzVhMTA5YWY3OTY0ZTg0NDZjYjdmZmMxNzIxYTFjMmNlNDNjIDUwNTQ5
MTBjOTBmMjU1NjQwNjJlOWExYzc4ZTRkMzdhNTEwNzc5NTUgLS0KUHJldmlvdXMgSEVBRCBw
b3NpdGlvbiB3YXMgNTA1NDkxMC4uLiBNZXJnZSAnYW1pcnYvZm9yLW5ldGRldicgaW50byBk
ZXZlbC1sa3AtaHN4MDEtaTM4Ni0yMDE0MDYyNDIzMTgKSEVBRCBpcyBub3cgYXQgNTRhZjYx
ZC4uLiBNZXJnZSBicmFuY2ggJ2FrcG0tY3VycmVudC9jdXJyZW50JwpCaXNlY3Rpbmc6IDkg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltj
MDUxYjIxZjcxZDFmZmRmZDdhZDQwNmExZWY1ZWRlNWU1Zjk3NGM1XSBydG11dGV4OiBDb25m
aW5lIGRlYWRsb2NrIGxvZ2ljIHRvIGZ1dGV4CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qg
cnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXg1L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NS9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
aGEzLTA2MjQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAxLWkzODYtMjAxNDA2MjQyMzE4
OmMwNTFiMjFmNzFkMWZmZGZkN2FkNDA2YTFlZjVlZGU1ZTVmOTc0YzU6YmlzZWN0LWxpbnV4
NQoKMjAxNC0wNi0yNS0wMDoxODo1NCBjMDUxYjIxZjcxZDFmZmRmZDdhZDQwNmExZWY1ZWRl
NWU1Zjk3NGM1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC1jMDUxYjIxZjcxZDFmZmRm
ZDdhZDQwNmExZWY1ZWRlNWU1Zjk3NGM1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MjQvYzA1MWIyMWY3MWQxZmZkZmQ3YWQ0MDZhMWVmNWVk
ZTVlNWY5NzRjNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LWMwNTFiMjFmNzFkMWZmZGZkN2Fk
NDA2YTFlZjVlZGU1ZTVmOTc0YzUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtYzA1MWIyMWY3
MWQxZmZkZmQ3YWQ0MDZhMWVmNWVkZTVlNWY5NzRjNQobWzE7MzVtMjAxNC0wNi0yNSAwMDoy
NTo1NCBLZXJuZWwgYnVpbGQgZmFpbCBvciB0aW1lb3V0G1swbQoyMDE0LTA2LTI1LTAwOjI1
OjU0IGMwNTFiMjFmNzFkMWZmZGZkN2FkNDA2YTFlZjVlZGU1ZTVmOTc0YzUgU0tJUCBCUk9L
RU4gQlVJTEQKQ2hlY2sgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29u
ZmlnLWhhMy0wNjI0LWMwNTFiMjFmNzFkMWZmZGZkN2FkNDA2YTFlZjVlZGU1ZTVmOTc0YzUK
QmlzZWN0aW5nOiA5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAzIHN0ZXBzKQpbYWY1NGQ2YTFjM2FkNDc0YmJjOTg5M2M5OTA1MDIyNjQ2YmU2MDkyY10g
ZnV0ZXg6IFNpbXBsaWZ5IGZ1dGV4X2xvY2tfcGlfYXRvbWljKCkgYW5kIG1ha2UgaXQgbW9y
ZSByb2J1c3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvbGludXgtZGV2
ZWw6ZGV2ZWwtbGtwLWhzeDAxLWkzODYtMjAxNDA2MjQyMzE4OmFmNTRkNmExYzNhZDQ3NGJi
Yzk4OTNjOTkwNTAyMjY0NmJlNjA5MmM6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNi0yNS0wMDoy
NTo1NCBhZjU0ZDZhMWMzYWQ0NzRiYmM5ODkzYzk5MDUwMjI2NDZiZTYwOTJjIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1oYTMtMDYyNC1hZjU0ZDZhMWMzYWQ0NzRiYmM5ODkzYzk5MDUwMjI2NDZi
ZTYwOTJjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEz
LTA2MjQvYWY1NGQ2YTFjM2FkNDc0YmJjOTg5M2M5OTA1MDIyNjQ2YmU2MDkyYwp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjI0LWFmNTRkNmExYzNhZDQ3NGJiYzk4OTNjOTkwNTAyMjY0NmJlNjA5
MmMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
Ly5pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtYWY1NGQ2YTFjM2FkNDc0YmJjOTg5M2M5OTA1
MDIyNjQ2YmU2MDkyYwobWzE7MzVtMjAxNC0wNi0yNSAwMDoyODo1NCBLZXJuZWwgYnVpbGQg
ZmFpbCBvciB0aW1lb3V0G1swbQoyMDE0LTA2LTI1LTAwOjI4OjU0IGFmNTRkNmExYzNhZDQ3
NGJiYzk4OTNjOTkwNTAyMjY0NmJlNjA5MmMgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgL2ti
dWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LWFmNTRk
NmExYzNhZDQ3NGJiYzk4OTNjOTkwNTAyMjY0NmJlNjA5MmMKQmlzZWN0aW5nOiA5IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbODkzMGVk
ODBmOTcwYTkwYTc5NTIzOWU3NDE1YzliMGU2Zjk2NDY0OV0gcnRtdXRleDogQ2xlYW51cCBk
ZWFkbG9jayBkZXRlY3RvciBkZWJ1ZyBsb2dpYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg1L29iai1i
aXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1oYTMtMDYyNC9saW51eC1kZXZlbDpkZXZlbC1sa3AtaHN4MDEtaTM4Ni0yMDE0MDYyNDIz
MTg6ODkzMGVkODBmOTcwYTkwYTc5NTIzOWU3NDE1YzliMGU2Zjk2NDY0OTpiaXNlY3QtbGlu
dXg1CgoyMDE0LTA2LTI1LTAwOjI4OjU1IDg5MzBlZDgwZjk3MGE5MGE3OTUyMzllNzQxNWM5
YjBlNmY5NjQ2NDkgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LTg5MzBlZDgwZjk3MGE5
MGE3OTUyMzllNzQxNWM5YjBlNmY5NjQ2NDkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC84OTMwZWQ4MGY5NzBhOTBhNzk1MjM5ZTc0MTVj
OWIwZTZmOTY0NjQ5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtODkzMGVkODBmOTcwYTkwYTc5
NTIzOWU3NDE1YzliMGU2Zjk2NDY0OQobWzE7MzVtMjAxNC0wNi0yNSAwMDoyOTo1NSBLZXJu
ZWwgYnVpbGQgZmFpbCBvciB0aW1lb3V0G1swbQoyMDE0LTA2LTI1LTAwOjI5OjU1IDg5MzBl
ZDgwZjk3MGE5MGE3OTUyMzllNzQxNWM5YjBlNmY5NjQ2NDkgU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjI0LTg5MzBlZDgwZjk3MGE5MGE3OTUyMzllNzQxNWM5YjBlNmY5NjQ2NDkKQmlzZWN0aW5n
OiA5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBz
KQpbODhmMmI0YzE1ZTU2MWJiNWMyODcwOWQ2NjYzNjRmMjczYmY1NGI5OF0gcnRtdXRleDog
U2ltcGxpZnkgcnRtdXRleF9zbG93dHJ5bG9jaygpCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDUvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWhhMy0wNjI0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1pMzg2LTIwMTQwNjI0
MjMxODo4OGYyYjRjMTVlNTYxYmI1YzI4NzA5ZDY2NjM2NGYyNzNiZjU0Yjk4OmJpc2VjdC1s
aW51eDUKCjIwMTQtMDYtMjUtMDA6Mjk6NTUgODhmMmI0YzE1ZTU2MWJiNWMyODcwOWQ2NjYz
NjRmMjczYmY1NGI5OCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtODhmMmI0YzE1ZTU2
MWJiNWMyODcwOWQ2NjYzNjRmMjczYmY1NGI5OApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0Lzg4ZjJiNGMxNWU1NjFiYjVjMjg3MDlkNjY2
MzY0ZjI3M2JmNTRiOTgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC04OGYyYjRjMTVlNTYxYmI1
YzI4NzA5ZDY2NjM2NGYyNzNiZjU0Yjk4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LTg4ZjJi
NGMxNWU1NjFiYjVjMjg3MDlkNjY2MzY0ZjI3M2JmNTRiOTgKa2VybmVsOiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1oYTMtMDYyNC84OGYyYjRjMTVlNTYxYmI1YzI4NzA5ZDY2NjM2NGYy
NzNiZjU0Yjk4L3ZtbGludXotMy4xNi4wLXJjMS0wMDAwOS1nODhmMmI0YzEKCjIwMTQtMDYt
MjUtMDA6NDg6NTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgk1CTkJMTQJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAzIHN0ZXBzKQpbNjc3OTJlMmNhYmFkYmFkZDFhOTNmNjc5MGZhN2JjYmQ0N2VjYTdjM10g
cnRtdXRleDogQXZvaWQgcG9pbnRsZXNzIHJlcXVldWVpbmcgaW4gdGhlIGRlYWRsb2NrIGRl
dGVjdGlvbiBjaGFpbiB3YWxrCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDUvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0
L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1pMzg2LTIwMTQwNjI0MjMxODo2Nzc5MmUy
Y2FiYWRiYWRkMWE5M2Y2NzkwZmE3YmNiZDQ3ZWNhN2MzOmJpc2VjdC1saW51eDUKCjIwMTQt
MDYtMjUtMDA6NTE6MjYgNjc3OTJlMmNhYmFkYmFkZDFhOTNmNjc5MGZhN2JjYmQ0N2VjYTdj
MyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtNjc3OTJlMmNhYmFkYmFkZDFhOTNmNjc5
MGZhN2JjYmQ0N2VjYTdjMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjI0LzY3NzkyZTJjYWJhZGJhZGQxYTkzZjY3OTBmYTdiY2JkNDdlY2E3
YzMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC02Nzc5MmUyY2FiYWRiYWRkMWE5M2Y2NzkwZmE3
YmNiZDQ3ZWNhN2MzChtbMTszNW0yMDE0LTA2LTI1IDAwOjUzOjI2IEtlcm5lbCBidWlsZCBm
YWlsIG9yIHRpbWVvdXQbWzBtCjIwMTQtMDYtMjUtMDA6NTM6MjYgNjc3OTJlMmNhYmFkYmFk
ZDFhOTNmNjc5MGZhN2JjYmQ0N2VjYTdjMyBTS0lQIEJST0tFTiBCVUlMRApDaGVjayAva2J1
aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtNjc3OTJl
MmNhYmFkYmFkZDFhOTNmNjc5MGZhN2JjYmQ0N2VjYTdjMwpCaXNlY3Rpbmc6IDcgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltjY2Y5ZTZh
ODBkOWUxYjlkZjY5Yzk4ZTZiOTc0NWNmNDk4NjllZTE1XSBmdXRleDogTWFrZSB1bmxvY2tf
cGkgbW9yZSByb2J1c3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvbGlu
dXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAxLWkzODYtMjAxNDA2MjQyMzE4OmNjZjllNmE4MGQ5
ZTFiOWRmNjljOThlNmI5NzQ1Y2Y0OTg2OWVlMTU6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNi0y
NS0wMDo1MzoyNyBjY2Y5ZTZhODBkOWUxYjlkZjY5Yzk4ZTZiOTc0NWNmNDk4NjllZTE1IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC1jY2Y5ZTZhODBkOWUxYjlkZjY5Yzk4ZTZiOTc0
NWNmNDk4NjllZTE1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaGEzLTA2MjQvY2NmOWU2YTgwZDllMWI5ZGY2OWM5OGU2Yjk3NDVjZjQ5ODY5ZWUxNQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWhhMy0wNjI0LWNjZjllNmE4MGQ5ZTFiOWRmNjljOThlNmI5NzQ1Y2Y0
OTg2OWVlMTUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtY2NmOWU2YTgwZDllMWI5ZGY2OWM5
OGU2Yjk3NDVjZjQ5ODY5ZWUxNQobWzE7MzVtMjAxNC0wNi0yNSAwMDo1ODoyNyBLZXJuZWwg
YnVpbGQgZmFpbCBvciB0aW1lb3V0G1swbQoyMDE0LTA2LTI1LTAwOjU4OjI3IGNjZjllNmE4
MGQ5ZTFiOWRmNjljOThlNmI5NzQ1Y2Y0OTg2OWVlMTUgU0tJUCBCUk9LRU4gQlVJTEQKQ2hl
Y2sgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0
LWNjZjllNmE4MGQ5ZTFiOWRmNjljOThlNmI5NzQ1Y2Y0OTg2OWVlMTUKQmlzZWN0aW5nOiA3
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpb
YTU3NTk0YTEzYTQ0NmQxYTZhYjFkY2Q0ODMzOWY3OTljZTU4Njg0M10gcnRtdXRleDogQ2xh
cmlmeSB0aGUgYm9vc3QvZGVib29zdCBwYXJ0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDUvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWhhMy0wNjI0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1pMzg2LTIwMTQwNjI0MjMx
ODphNTc1OTRhMTNhNDQ2ZDFhNmFiMWRjZDQ4MzM5Zjc5OWNlNTg2ODQzOmJpc2VjdC1saW51
eDUKCjIwMTQtMDYtMjUtMDA6NTg6MjcgYTU3NTk0YTEzYTQ0NmQxYTZhYjFkY2Q0ODMzOWY3
OTljZTU4Njg0MyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtYTU3NTk0YTEzYTQ0NmQx
YTZhYjFkY2Q0ODMzOWY3OTljZTU4Njg0MwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2E1NzU5NGExM2E0NDZkMWE2YWIxZGNkNDgzMzlm
Nzk5Y2U1ODY4NDMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC1hNTc1OTRhMTNhNDQ2ZDFhNmFi
MWRjZDQ4MzM5Zjc5OWNlNTg2ODQzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LWE1NzU5NGEx
M2E0NDZkMWE2YWIxZGNkNDgzMzlmNzk5Y2U1ODY4NDMKa2VybmVsOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1oYTMtMDYyNC9hNTc1OTRhMTNhNDQ2ZDFhNmFiMWRjZDQ4MzM5Zjc5OWNl
NTg2ODQzL3ZtbGludXotMy4xNi4wLXJjMS0wMDAxMi1nYTU3NTk0YQoKMjAxNC0wNi0yNS0w
MTowMDoyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTE1CTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBzdGVw
cykKW2JkMWRiY2M2N2NkMmMxMTgxZTJjMDFkYWFjNTFlYWJmMWI5NjRkZDhdIGZ1dGV4OiBV
c2UgZnV0ZXhfdG9wX3dhaXRlcigpIGluIGxvb2t1cF9waV9zdGF0ZSgpCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eDUvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1p
Mzg2LTIwMTQwNjI0MjMxODpiZDFkYmNjNjdjZDJjMTE4MWUyYzAxZGFhYzUxZWFiZjFiOTY0
ZGQ4OmJpc2VjdC1saW51eDUKCjIwMTQtMDYtMjUtMDE6MDE6NTggYmQxZGJjYzY3Y2QyYzEx
ODFlMmMwMWRhYWM1MWVhYmYxYjk2NGRkOCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQt
YmQxZGJjYzY3Y2QyYzExODFlMmMwMWRhYWM1MWVhYmYxYjk2NGRkOApDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2JkMWRiY2M2N2NkMmMx
MTgxZTJjMDFkYWFjNTFlYWJmMWI5NjRkZDgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC1iZDFk
YmNjNjdjZDJjMTE4MWUyYzAxZGFhYzUxZWFiZjFiOTY0ZGQ4CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhh
My0wNjI0LWJkMWRiY2M2N2NkMmMxMTgxZTJjMDFkYWFjNTFlYWJmMWI5NjRkZDgKG1sxOzM1
bTIwMTQtMDYtMjUgMDE6MDM6NTggS2VybmVsIGJ1aWxkIGZhaWwgb3IgdGltZW91dBtbMG0K
MjAxNC0wNi0yNS0wMTowMzo1OCBiZDFkYmNjNjdjZDJjMTE4MWUyYzAxZGFhYzUxZWFiZjFi
OTY0ZGQ4IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2Vy
dmVkL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC1iZDFkYmNjNjdjZDJjMTE4MWUyYzAxZGFh
YzUxZWFiZjFiOTY0ZGQ4CkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzZjYzYyMGJjOGU5YjUyMWU2MWYwNGVlZmJl
YzBjNDFjMDFmYjAzYjldIHJ0bXV0ZXg6IE1ha2UgdGhlIHJ0bXV0ZXggdGVzdGVyIGRlcGVu
ZCBvbiBCUk9LRU4KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NS9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvbGludXgt
ZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAxLWkzODYtMjAxNDA2MjQyMzE4OjZjYzYyMGJjOGU5YjUy
MWU2MWYwNGVlZmJlYzBjNDFjMDFmYjAzYjk6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNi0yNS0w
MTowMzo1OCA2Y2M2MjBiYzhlOWI1MjFlNjFmMDRlZWZiZWMwYzQxYzAxZmIwM2I5IGNvbXBp
bGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy1oYTMtMDYyNC02Y2M2MjBiYzhlOWI1MjFlNjFmMDRlZWZiZWMwYzQx
YzAxZmIwM2I5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aGEzLTA2MjQvNmNjNjIwYmM4ZTliNTIxZTYxZjA0ZWVmYmVjMGM0MWMwMWZiMDNiOQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWhhMy0wNjI0LTZjYzYyMGJjOGU5YjUyMWU2MWYwNGVlZmJlYzBjNDFjMDFm
YjAzYjkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlLy5pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtNmNjNjIwYmM4ZTliNTIxZTYxZjA0ZWVm
YmVjMGM0MWMwMWZiMDNiOQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjI0LzZjYzYyMGJjOGU5YjUyMWU2MWYwNGVlZmJlYzBjNDFjMDFmYjAzYjkvdm1saW51ei0z
LjE2LjAtcmMxLTAwMDIzLWc2Y2M2MjBiCgoyMDE0LTA2LTI1LTAxOjA3OjU4IGRldGVjdGlu
ZyBib290IHN0YXRlIC4JMgkxNQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCltiN2U0ODg4YmFk
MGM4NGRiNTg3YTJiZWFlNzJkY2YxYzQwZWMwZTUyXSBsb2NrZGVwOiByZXN0cmljdCB0aGUg
dXNlIG9mIHJlY3Vyc2l2ZSByZWFkX2xvY2sgd2l0aCBxcndsb2NrCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9s
aW51eDUvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS1pMzg2
LTIwMTQwNjI0MjMxODpiN2U0ODg4YmFkMGM4NGRiNTg3YTJiZWFlNzJkY2YxYzQwZWMwZTUy
OmJpc2VjdC1saW51eDUKCjIwMTQtMDYtMjUtMDE6MDk6NTkgYjdlNDg4OGJhZDBjODRkYjU4
N2EyYmVhZTcyZGNmMWM0MGVjMGU1MiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQtYjdl
NDg4OGJhZDBjODRkYjU4N2EyYmVhZTcyZGNmMWM0MGVjMGU1MgpDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2I3ZTQ4ODhiYWQwYzg0ZGI1
ODdhMmJlYWU3MmRjZjFjNDBlYzBlNTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC1iN2U0ODg4
YmFkMGM4NGRiNTg3YTJiZWFlNzJkY2YxYzQwZWMwZTUyCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjI0LWI3ZTQ4ODhiYWQwYzg0ZGI1ODdhMmJlYWU3MmRjZjFjNDBlYzBlNTIKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9iN2U0ODg4YmFkMGM4NGRiNTg3YTJi
ZWFlNzJkY2YxYzQwZWMwZTUyL3ZtbGludXotMy4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4OAoK
MjAxNC0wNi0yNS0wMToxMjo1OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVS
RQpbICAgIDAuMDAwMDAwXSAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBd
ICAgICAgICAgICAgICAgICAgICAgIEEtQSBkZWFkbG9jazogIG9rICB8ICBvayAgfEZBSUxF
RHwKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRh
aW50ZWQgMy4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4OCAjMTIKWyAgICAwLjAwMDAwMF0gSGFy
ZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAu
MDAwMDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTIyM2IgMDAwMDAwMDEg
YzE2MzNmYjQgYzE0MTI0OGIgYzE1OWZmZTgKWyAgICAwLjAwMDAwMF0gIGMxNDBmY2U2IDAw
MDAwMDAwIDAwMDAwMDA0IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMxODQ0ODAwIGMx
NjMzZmM4ClsgICAgMC4wMDAwMDBdICBjMTIxZmU2MiBjMTVhMDFiNyBjMTVhMDFhYSAwMDAw
MDc4MCBjMTYzM2ZlOCBjMTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAgIDAuMDAwMDAw
XSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjIzYj5dIGR1bXBfc3RhY2sr
MHg0OC8weDYwClsgICAgMC4wMDAwMDBdICBbPGMxNDEyNDhiPl0gZG90ZXN0KzB4NTgvMHg0
YmMKWyAgICAwLjAwMDAwMF0gIFs8YzE0MGZjZTY+XSA/IHByaW50aysweDM4LzB4M2EKWyAg
ICAwLjAwMDAwMF0gIFs8YzEyMWZlNjI+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4ZDQvMHgxZGRi
ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBkPl0gc3RhcnRfa2VybmVsKzB4MmU1LzB4M2Ex
ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1Pl0gPyBzZXRfaW5pdF9hcmcrMHg0OS8weDQ5
ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFmPl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8w
eDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwgIG9rICB8ICBvayAgfApbICAgIDAuMDAwMDAw
XSAgICAgICAgICAgICAgICAgIEEtQi1CLUEgZGVhZGxvY2s6ICBvayAgfCAgb2sgIHxGQUlM
RUR8ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8wIE5vdCB0
YWludGVkIDMuMTYuMC1yYzEtMDAwMjQtZ2I3ZTQ4ODggIzEyClsgICAgMC4wMDAwMDBdIEhh
cmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAw
LjAwMDAwMF0gIDAwMDAwMDAwIDAwMDAwMDAwIGMxNjMzZjhjIGMxNDEyMjNiIDAwMDAwMDAx
IGMxNjMzZmI0IGMxNDEyNDhiIGMxNTlmZmU4ClsgICAgMC4wMDAwMDBdICBjMTQwZmNlNiAw
MDAwMDAwMCAwMDAwMDAwNCAwMDAwMDAwMiBjMTZiZjM5MCAwMDAyMDgwMCBjMTg0NDgwMCBj
MTYzM2ZjOApbICAgIDAuMDAwMDAwXSAgYzEyMWZlZWIgYzE1YTAxYjcgYzE1YTAxYmQgMDAw
MDA3ODAgYzE2MzNmZTggYzE2ODhhMGQgMDAwMDAwZWEgZmZmZmZmZmYKWyAgICAwLjAwMDAw
MF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAwMF0gIFs8YzE0MTIyM2I+XSBkdW1wX3N0YWNr
KzB4NDgvMHg2MApbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjQ4Yj5dIGRvdGVzdCsweDU4LzB4
NGJjClsgICAgMC4wMDAwMDBdICBbPGMxNDBmY2U2Pl0gPyBwcmludGsrMHgzOC8weDNhClsg
ICAgMC4wMDAwMDBdICBbPGMxMjFmZWViPl0gbG9ja2luZ19zZWxmdGVzdCsweDE1ZC8weDFk
ZGIKWyAgICAwLjAwMDAwMF0gIFs8YzE2ODhhMGQ+XSBzdGFydF9rZXJuZWwrMHgyZTUvMHgz
YTEKWyAgICAwLjAwMDAwMF0gIFs8YzE2ODg0YzU+XSA/IHNldF9pbml0X2FyZysweDQ5LzB4
NDkKWyAgICAwLjAwMDAwMF0gIFs8YzE2ODgyYWY+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDc5
LzB4N2QKWyAgICAwLjAwMDAwMF0gICBvayAgfCAgb2sgIHwgIG9rICB8ClsgICAgMC4wMDAw
MDBdICAgICAgICAgICAgICBBLUItQi1DLUMtQSBkZWFkbG9jazogIG9rICB8ICBvayAgfEZB
SUxFRHwKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90
IHRhaW50ZWQgMy4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4OCAjMTIKWyAgICAwLjAwMDAwMF0g
SGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAg
IDAuMDAwMDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTIyM2IgMDAwMDAw
MDEgYzE2MzNmYjQgYzE0MTI0OGIgYzE1OWZmZTgKWyAgICAwLjAwMDAwMF0gIGMxNDBmY2U2
IDAwMDAwMDAwIDAwMDAwMDA0IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMxODQ0ODAw
IGMxNjMzZmM4ClsgICAgMC4wMDAwMDBdICBjMTIxZmY3NCBjMTVhMDFiNyBjMTVhMDFjZSAw
MDAwMDc4MCBjMTYzM2ZlOCBjMTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAgIDAuMDAw
MDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjIzYj5dIGR1bXBfc3Rh
Y2srMHg0OC8weDYwClsgICAgMC4wMDAwMDBdICBbPGMxNDEyNDhiPl0gZG90ZXN0KzB4NTgv
MHg0YmMKWyAgICAwLjAwMDAwMF0gIFs8YzE0MGZjZTY+XSA/IHByaW50aysweDM4LzB4M2EK
WyAgICAwLjAwMDAwMF0gIFs8YzEyMWZmNzQ+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4MWU2LzB4
MWRkYgpbICAgIDAuMDAwMDAwXSAgWzxjMTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsweDJlNS8w
eDNhMQpbICAgIDAuMDAwMDAwXSAgWzxjMTY4ODRjNT5dID8gc2V0X2luaXRfYXJnKzB4NDkv
MHg0OQpbICAgIDAuMDAwMDAwXSAgWzxjMTY4ODJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4
NzkvMHg3ZApbICAgIDAuMDAwMDAwXSAgIG9rICB8ICBvayAgfCAgb2sgIHwKWyAgICAwLjAw
MDAwMF0gICAgICAgICAgICAgIEEtQi1DLUEtQi1DIGRlYWRsb2NrOiAgb2sgIHwgIG9rICB8
RkFJTEVEfApbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBO
b3QgdGFpbnRlZCAzLjE2LjAtcmMxLTAwMDI0LWdiN2U0ODg4ICMxMgpbICAgIDAuMDAwMDAw
XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
ICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBjMTYzM2Y4YyBjMTQxMjIzYiAwMDAw
MDAwMSBjMTYzM2ZiNCBjMTQxMjQ4YiBjMTU5ZmZlOApbICAgIDAuMDAwMDAwXSAgYzE0MGZj
ZTYgMDAwMDAwMDAgMDAwMDAwMDQgMDAwMDAwMDIgYzE2YmYzOTAgMDAwMjA4MDAgYzE4NDQ4
MDAgYzE2MzNmYzgKWyAgICAwLjAwMDAwMF0gIGMxMjFmZmZkIGMxNWEwMWI3IGMxNWEwMWUz
IDAwMDAwNzgwIGMxNjMzZmU4IGMxNjg4YTBkIDAwMDAwMGVhIGZmZmZmZmZmClsgICAgMC4w
MDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGMxNDEyMjNiPl0gZHVtcF9z
dGFjaysweDQ4LzB4NjAKWyAgICAwLjAwMDAwMF0gIFs8YzE0MTI0OGI+XSBkb3Rlc3QrMHg1
OC8weDRiYwpbICAgIDAuMDAwMDAwXSAgWzxjMTQwZmNlNj5dID8gcHJpbnRrKzB4MzgvMHgz
YQpbICAgIDAuMDAwMDAwXSAgWzxjMTIxZmZmZD5dIGxvY2tpbmdfc2VsZnRlc3QrMHgyNmYv
MHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBkPl0gc3RhcnRfa2VybmVsKzB4MmU1
LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1Pl0gPyBzZXRfaW5pdF9hcmcrMHg0
OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFmPl0gaTM4Nl9zdGFydF9rZXJuZWwr
MHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwgIG9rICB8ICBvayAgfApbICAgIDAu
MDAwMDAwXSAgICAgICAgICBBLUItQi1DLUMtRC1ELUEgZGVhZGxvY2s6ICBvayAgfCAgb2sg
IHxGQUlMRUR8ClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlci8w
IE5vdCB0YWludGVkIDMuMTYuMC1yYzEtMDAwMjQtZ2I3ZTQ4ODggIzEyClsgICAgMC4wMDAw
MDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEK
WyAgICAwLjAwMDAwMF0gIDAwMDAwMDAwIDAwMDAwMDAwIGMxNjMzZjhjIGMxNDEyMjNiIDAw
MDAwMDAxIGMxNjMzZmI0IGMxNDEyNDhiIGMxNTlmZmU4ClsgICAgMC4wMDAwMDBdICBjMTQw
ZmNlNiAwMDAwMDAwMCAwMDAwMDAwNCAwMDAwMDAwMiBjMTZiZjM5MCAwMDAyMDgwMCBjMTg0
NDgwMCBjMTYzM2ZjOApbICAgIDAuMDAwMDAwXSAgYzEyMjAwODYgYzE1YTAxYjcgYzE1YTAx
ZjggMDAwMDA3ODAgYzE2MzNmZTggYzE2ODhhMGQgMDAwMDAwZWEgZmZmZmZmZmYKWyAgICAw
LjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAwLjAwMDAwMF0gIFs8YzE0MTIyM2I+XSBkdW1w
X3N0YWNrKzB4NDgvMHg2MApbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjQ4Yj5dIGRvdGVzdCsw
eDU4LzB4NGJjClsgICAgMC4wMDAwMDBdICBbPGMxNDBmY2U2Pl0gPyBwcmludGsrMHgzOC8w
eDNhClsgICAgMC4wMDAwMDBdICBbPGMxMjIwMDg2Pl0gbG9ja2luZ19zZWxmdGVzdCsweDJm
OC8weDFkZGIKWyAgICAwLjAwMDAwMF0gIFs8YzE2ODhhMGQ+XSBzdGFydF9rZXJuZWwrMHgy
ZTUvMHgzYTEKWyAgICAwLjAwMDAwMF0gIFs8YzE2ODg0YzU+XSA/IHNldF9pbml0X2FyZysw
eDQ5LzB4NDkKWyAgICAwLjAwMDAwMF0gIFs8YzE2ODgyYWY+XSBpMzg2X3N0YXJ0X2tlcm5l
bCsweDc5LzB4N2QKWyAgICAwLjAwMDAwMF0gICBvayAgfCAgb2sgIHwgIG9rICB8ClsgICAg
MC4wMDAwMDBdICAgICAgICAgIEEtQi1DLUQtQi1ELUQtQSBkZWFkbG9jazogIG9rICB8ICBv
ayAgfEZBSUxFRHwKWyAgICAwLjAwMDAwMF0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVy
LzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4OCAjMTIKWyAgICAwLjAw
MDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTIyM2Ig
MDAwMDAwMDEgYzE2MzNmYjQgYzE0MTI0OGIgYzE1OWZmZTgKWyAgICAwLjAwMDAwMF0gIGMx
NDBmY2U2IDAwMDAwMDAwIDAwMDAwMDA0IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMx
ODQ0ODAwIGMxNjMzZmM4ClsgICAgMC4wMDAwMDBdICBjMTIyMDEwZiBjMTVhMDFiNyBjMTVh
MDIxMSAwMDAwMDc4MCBjMTYzM2ZlOCBjMTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAg
IDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjIzYj5dIGR1
bXBfc3RhY2srMHg0OC8weDYwClsgICAgMC4wMDAwMDBdICBbPGMxNDEyNDhiPl0gZG90ZXN0
KzB4NTgvMHg0YmMKWyAgICAwLjAwMDAwMF0gIFs8YzE0MGZjZTY+XSA/IHByaW50aysweDM4
LzB4M2EKWyAgICAwLjAwMDAwMF0gIFs8YzEyMjAxMGY+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4
MzgxLzB4MWRkYgpbICAgIDAuMDAwMDAwXSAgWzxjMTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsw
eDJlNS8weDNhMQpbICAgIDAuMDAwMDAwXSAgWzxjMTY4ODRjNT5dID8gc2V0X2luaXRfYXJn
KzB4NDkvMHg0OQpbICAgIDAuMDAwMDAwXSAgWzxjMTY4ODJhZj5dIGkzODZfc3RhcnRfa2Vy
bmVsKzB4NzkvMHg3ZApbICAgIDAuMDAwMDAwXSAgIG9rICB8ICBvayAgfCAgb2sgIHwKWyAg
ICAwLjAwMDAwMF0gICAgICAgICAgQS1CLUMtRC1CLUMtRC1BIGRlYWRsb2NrOiAgb2sgIHwg
IG9rICB8RkFJTEVEfApbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBw
ZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMxLTAwMDI0LWdiN2U0ODg4ICMxMgpbICAgIDAu
MDAwMDAwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8y
MDExClsgICAgMC4wMDAwMDBdICAwMDAwMDAwMCAwMDAwMDAwMCBjMTYzM2Y4YyBjMTQxMjIz
YiAwMDAwMDAwMSBjMTYzM2ZiNCBjMTQxMjQ4YiBjMTU5ZmZlOApbICAgIDAuMDAwMDAwXSAg
YzE0MGZjZTYgMDAwMDAwMDAgMDAwMDAwMDQgMDAwMDAwMDIgYzE2YmYzOTAgMDAwMjA4MDAg
YzE4NDQ4MDAgYzE2MzNmYzgKWyAgICAwLjAwMDAwMF0gIGMxMjIwMTk4IGMxNWEwMWI3IGMx
NWEwMjJhIDAwMDAwNzgwIGMxNjMzZmU4IGMxNjg4YTBkIDAwMDAwMGVhIGZmZmZmZmZmClsg
ICAgMC4wMDAwMDBdIENhbGwgVHJhY2U6ClsgICAgMC4wMDAwMDBdICBbPGMxNDEyMjNiPl0g
ZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAwLjAwMDAwMF0gIFs8YzE0MTI0OGI+XSBkb3Rl
c3QrMHg1OC8weDRiYwpbICAgIDAuMDAwMDAwXSAgWzxjMTQwZmNlNj5dID8gcHJpbnRrKzB4
MzgvMHgzYQpbICAgIDAuMDAwMDAwXSAgWzxjMTIyMDE5OD5dIGxvY2tpbmdfc2VsZnRlc3Qr
MHg0MGEvMHgxZGRiClsgICAgMC4wMDAwMDBdICBbPGMxNjg4YTBkPl0gc3RhcnRfa2VybmVs
KzB4MmU1LzB4M2ExClsgICAgMC4wMDAwMDBdICBbPGMxNjg4NGM1Pl0gPyBzZXRfaW5pdF9h
cmcrMHg0OS8weDQ5ClsgICAgMC4wMDAwMDBdICBbPGMxNjg4MmFmPl0gaTM4Nl9zdGFydF9r
ZXJuZWwrMHg3OS8weDdkClsgICAgMC4wMDAwMDBdICAgb2sgIHwgIG9rICB8ICBvayAgfApb
ICAgIDAuMDAwMDAwXSAgICAgICAgICAgICAgICAgICAgIGRvdWJsZSB1bmxvY2s6ICBvayAg
fCAgb2sgIHwgIG9rICB8ICBvayAgfCAgb2sgIHwgIG9rICB8ClsgICAgMC4wMDAwMDBdICAg
ICAgICAgICAgICAgICAgIGluaXRpYWxpemUgaGVsZDogIG9rICB8ICBvayAgfCAgb2sgIHwg
IG9rICB8ICBvayAgfCAgb2sgIHwKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQv
YjdlNDg4OGJhZDBjODRkYjU4N2EyYmVhZTcyZGNmMWM0MGVjMGU1Mi9kbWVzZy1xdWFudGFs
LWl2YjQyLTg0OjIwMTQwNjI1MDExMjI5OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2
LjAtcmMxLTAwMDI0LWdiN2U0ODg4OjEyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjI0L2I3ZTQ4ODhiYWQwYzg0ZGI1ODdhMmJlYWU3MmRjZjFjNDBlYzBlNTIvZG1lc2cteW9j
dG8taXZiNDItNTE6MjAxNDA2MjUwMTEyMjk6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMu
MTYuMC1yYzEtMDAwMjQtZ2I3ZTQ4ODg6MTIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEz
LTA2MjQvYjdlNDg4OGJhZDBjODRkYjU4N2EyYmVhZTcyZGNmMWM0MGVjMGU1Mi9kbWVzZy1x
dWFudGFsLWl2YjQxLTEwODoyMDE0MDYyNTAxMTIzNTppMzg2LXJhbmRjb25maWctaGEzLTA2
MjQ6My4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4ODoxMgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1oYTMtMDYyNC9iN2U0ODg4YmFkMGM4NGRiNTg3YTJiZWFlNzJkY2YxYzQwZWMwZTUyL2Rt
ZXNnLXF1YW50YWwtaXZiNDEtOToyMDE0MDYyNTAxMTIzNTppMzg2LXJhbmRjb25maWctaGEz
LTA2MjQ6My4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4ODoxMgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1oYTMtMDYyNC9iN2U0ODg4YmFkMGM4NGRiNTg3YTJiZWFlNzJkY2YxYzQwZWMwZTUy
L2RtZXNnLXlvY3RvLWl2YjQxLTIzOjIwMTQwNjI1MDExMjM1OmkzODYtcmFuZGNvbmZpZy1o
YTMtMDYyNDozLjE2LjAtcmMxLTAwMDI0LWdiN2U0ODg4OjEyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjI0L2I3ZTQ4ODhiYWQwYzg0ZGI1ODdhMmJlYWU3MmRjZjFjNDBlYzBl
NTIvZG1lc2ctcXVhbnRhbC1pdmI0Mi04NDoyMDE0MDYyNTAxMTIzOTppMzg2LXJhbmRjb25m
aWctaGEzLTA2MjQ6My4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4ODoxMgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1oYTMtMDYyNC9iN2U0ODg4YmFkMGM4NGRiNTg3YTJiZWFlNzJkY2YxYzQw
ZWMwZTUyL2RtZXNnLXF1YW50YWwtaXZiNDEtNTk6MjAxNDA2MjUwMTEyNTU6aTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzEtMDAwMjQtZ2I3ZTQ4ODg6MTIKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MjQvYjdlNDg4OGJhZDBjODRkYjU4N2EyYmVhZTcyZGNm
MWM0MGVjMGU1Mi9kbWVzZy1xdWFudGFsLWl2YjQxLTEwODoyMDE0MDYyNTAxMTI1OTppMzg2
LXJhbmRjb25maWctaGEzLTA2MjQ6My4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4ODoxMgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9iN2U0ODg4YmFkMGM4NGRiNTg3YTJiZWFl
NzJkY2YxYzQwZWMwZTUyL2RtZXNnLXF1YW50YWwtaXZiNDEtMTE5OjIwMTQwNjI1MDExMzA1
OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMxLTAwMDI0LWdiN2U0ODg4OjEy
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2I3ZTQ4ODhiYWQwYzg0ZGI1ODdh
MmJlYWU3MmRjZjFjNDBlYzBlNTIvZG1lc2ctcXVhbnRhbC1pdmI0MS0xOToyMDE0MDYyNTAx
MTMwMjppMzg2LXJhbmRjb25maWctaGEzLTA2MjQ6My4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4
ODoxMgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9iN2U0ODg4YmFkMGM4NGRi
NTg3YTJiZWFlNzJkY2YxYzQwZWMwZTUyL2RtZXNnLXF1YW50YWwtaXZiNDEtNTk6MjAxNDA2
MjUwMTEzMDU6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzEtMDAwMjQtZ2I3
ZTQ4ODg6MTIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvYjdlNDg4OGJhZDBj
ODRkYjU4N2EyYmVhZTcyZGNmMWM0MGVjMGU1Mi9kbWVzZy1xdWFudGFsLWl2YjQxLTU6MjAx
NDA2MjUwMTEzMDQ6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzEtMDAwMjQt
Z2I3ZTQ4ODg6MTIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvYjdlNDg4OGJh
ZDBjODRkYjU4N2EyYmVhZTcyZGNmMWM0MGVjMGU1Mi9kbWVzZy1xdWFudGFsLWl2YjQxLTc0
OjIwMTQwNjI1MDExMjU5OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMxLTAw
MDI0LWdiN2U0ODg4OjEyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2I3ZTQ4
ODhiYWQwYzg0ZGI1ODdhMmJlYWU3MmRjZjFjNDBlYzBlNTIvZG1lc2ctcXVhbnRhbC1pdmI0
Mi0xMTg6MjAxNDA2MjUwMTEzMDc6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1y
YzEtMDAwMjQtZ2I3ZTQ4ODg6MTIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQv
YjdlNDg4OGJhZDBjODRkYjU4N2EyYmVhZTcyZGNmMWM0MGVjMGU1Mi9kbWVzZy1xdWFudGFs
LWl2YjQyLTEzOjIwMTQwNjI1MDExMzA3OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2
LjAtcmMxLTAwMDI0LWdiN2U0ODg4OjEyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjI0L2I3ZTQ4ODhiYWQwYzg0ZGI1ODdhMmJlYWU3MmRjZjFjNDBlYzBlNTIvZG1lc2ctcXVh
bnRhbC1pdmI0Mi0yMzoyMDE0MDYyNTAxMTMwNDppMzg2LXJhbmRjb25maWctaGEzLTA2MjQ6
My4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4ODoxMgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1o
YTMtMDYyNC9iN2U0ODg4YmFkMGM4NGRiNTg3YTJiZWFlNzJkY2YxYzQwZWMwZTUyL2RtZXNn
LXF1YW50YWwtaXZiNDItNTM6MjAxNDA2MjUwMTEzMDI6aTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjI0OjMuMTYuMC1yYzEtMDAwMjQtZ2I3ZTQ4ODg6MTIKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaGEzLTA2MjQvYjdlNDg4OGJhZDBjODRkYjU4N2EyYmVhZTcyZGNmMWM0MGVjMGU1Mi9k
bWVzZy1xdWFudGFsLWl2YjQyLTg0OjIwMTQwNjI1MDExMzAzOmkzODYtcmFuZGNvbmZpZy1o
YTMtMDYyNDozLjE2LjAtcmMxLTAwMDI0LWdiN2U0ODg4OjEyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjI0L2I3ZTQ4ODhiYWQwYzg0ZGI1ODdhMmJlYWU3MmRjZjFjNDBlYzBl
NTIvZG1lc2ctcXVhbnRhbC1pdmI0Mi05NjoyMDE0MDYyNTAxMTMwNDppMzg2LXJhbmRjb25m
aWctaGEzLTA2MjQ6My4xNi4wLXJjMS0wMDAyNC1nYjdlNDg4ODoxMgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1oYTMtMDYyNC9iN2U0ODg4YmFkMGM4NGRiNTg3YTJiZWFlNzJkY2YxYzQw
ZWMwZTUyL2RtZXNnLXlvY3RvLWl2YjQxLTU5OjIwMTQwNjI1MDExMjU4OmkzODYtcmFuZGNv
bmZpZy1oYTMtMDYyNDozLjE2LjAtcmMxLTAwMDI0LWdiN2U0ODg4OjEyCjA6MjA6MjAgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDYtMjUgMDE6MTM6MjkgUkVQ
RUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDUvb2JqLWJpc2VjdC8ucmVw
ZWF0G1swbQoKYjdlNDg4OGJhZDBjODRkYjU4N2EyYmVhZTcyZGNmMWM0MGVjMGU1MiBpcyB0
aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQgYjdlNDg4OGJhZDBjODRkYjU4N2EyYmVhZTcy
ZGNmMWM0MGVjMGU1MgpBdXRob3I6IFdhaW1hbiBMb25nIDxXYWltYW4uTG9uZ0BocC5jb20+
CkRhdGU6ICAgTW9uIEp1biAyMyAxNDoyNTowMCAyMDE0IC0wNDAwCgogICAgbG9ja2RlcDog
cmVzdHJpY3QgdGhlIHVzZSBvZiByZWN1cnNpdmUgcmVhZF9sb2NrIHdpdGggcXJ3bG9jawog
ICAgCiAgICBVbmxpa2UgdGhlIG9yaWdpbmFsIHVuZmFpciByd2xvY2sgaW1wbGVtZW50YXRp
b24sIHF1ZXVlZCByd2xvY2sKICAgIHdpbGwgZ3JhbnQgbG9jayBhY2NvcmRpbmcgdG8gdGhl
IGNocm9ub2xvZ2ljYWwgc2VxdWVuY2Ugb2YgdGhlIGxvY2sKICAgIHJlcXVlc3RzIGV4Y2Vw
dCB3aGVuIHRoZSBsb2NrIHJlcXVlc3RlciBpcyBpbiB0aGUgaW50ZXJydXB0IGNvbnRleHQu
CiAgICBDb25zZXF1ZW50bHksIHJlY3Vyc2l2ZSByZWFkX2xvY2sgY2FsbHMgd2lsbCBub3cg
aGFuZyB0aGUgcHJvY2VzcyBpZgogICAgdGhlcmUgaXMgYSB3cml0ZV9sb2NrIGNhbGwgc29t
ZXdoZXJlIGluIGJldHdlZW4gdGhlIHJlYWRfbG9jayBjYWxscy4KICAgIAogICAgVGhpcyBw
YXRjaCB1cGRhdGVzIHRoZSBsb2NrZGVwIGltcGxlbWVudGF0aW9uIHRvIGxvb2sgZm9yIHJl
Y3Vyc2l2ZQogICAgcmVhZF9sb2NrIGNhbGxzIHdoZW4gcXVldWVkIHJ3bG9jayBpcyBiZWlu
ZyB1c2VkLiBBIG5ldyByZWFkIHN0YXRlICgzKQogICAgaXMgdXNlZCB0byBtYXJrIHRob3Nl
IHJlYWRfbG9jayBjYWxsIHRoYXQgY2Fubm90IGJlIHJlY3Vyc2l2ZWx5IGNhbGxlZAogICAg
ZXhjZXB0IGluIHRoZSBpbnRlcnJ1cHQgY29udGV4dC4gVGhlIG5ldyByZWFkIHN0YXRlIGRv
ZXMgZXhoYXVzdCB0aGUKICAgIDIgYml0cyBhdmFpbGFibGUgaW4gaGVsZF9sb2NrOnJlYWQg
Yml0IGZpZWxkLiBUaGUgYWRkaXRpb24gb2YgYW55IG5ldwogICAgcmVhZCBzdGF0ZSBpbiB0
aGUgZnV0dXJlIG1heSByZXF1aXJlIGEgcmVkZXNpZ24gb2YgaG93IGFsbCB0aG9zZSBiaXRz
CiAgICBhcmUgc3F1ZWV6ZWQgdG9nZXRoZXIgaW4gdGhlIGhlbGRfbG9jayBzdHJ1Y3R1cmUu
CiAgICAKICAgIENjOiBTY290dCBKIE5vcnRvbiA8c2NvdHQubm9ydG9uQGhwLmNvbT4KICAg
IENjOiBJbmdvIE1vbG5hciA8bWluZ29Aa2VybmVsLm9yZz4KICAgIFNpZ25lZC1vZmYtYnk6
IFdhaW1hbiBMb25nIDxXYWltYW4uTG9uZ0BocC5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBQ
ZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CiAgICBMaW5rOiBodHRwOi8v
bGttbC5rZXJuZWwub3JnL3IvMTQwMzU0NzkwMC00MDY1OC0yLWdpdC1zZW5kLWVtYWlsLVdh
aW1hbi5Mb25nQGhwLmNvbQoKOjA0MDAwMCAwNDAwMDAgZjE2MTAwNGU3MGFlMTU5MGQxN2Mw
MDY5OWY3NThhY2MyZGQxNTNjZCBmZmYwOThhMWRkNzEzZmU0NTE5MTJiNWY0Yzk5OWY4Yzkz
MTk4YTI0IE0JaW5jbHVkZQo6MDQwMDAwIDA0MDAwMCA1NzQxYjM4Y2MyOGQ2ZjBhOWMxNTVi
YTZmNTE4MDJkYzQxYzQwNDFkIDY5OTAxMWEzNTM0MDRjNDYyMjk1ZDM4YTVlODRmM2Y3NDAx
MDNjZjQgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNzClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIGI3ZTQ4ODguLi4gbG9ja2RlcDogcmVzdHJpY3QgdGhlIHVzZSBvZiByZWN1cnNp
dmUgcmVhZF9sb2NrIHdpdGggcXJ3bG9jawpIRUFEIGlzIG5vdyBhdCA2Y2M2MjBiLi4uIHJ0
bXV0ZXg6IE1ha2UgdGhlIHJ0bXV0ZXggdGVzdGVyIGRlcGVuZCBvbiBCUk9LRU4KbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9s
aW51eC1kZXZlbDpkZXZlbC1sa3AtaHN4MDEtaTM4Ni0yMDE0MDYyNDIzMTg6NmNjNjIwYmM4
ZTliNTIxZTYxZjA0ZWVmYmVjMGM0MWMwMWZiMDNiOTpiaXNlY3QtbGludXg1CgoyMDE0LTA2
LTI1LTAxOjEzOjMwIDZjYzYyMGJjOGU5YjUyMWU2MWYwNGVlZmJlYzBjNDFjMDFmYjAzYjkg
cmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvNmNjNjIwYmM4ZTliNTIx
ZTYxZjA0ZWVmYmVjMGM0MWMwMWZiMDNiOS92bWxpbnV6LTMuMTYuMC1yYzEtMDAwMjMtZzZj
YzYyMGIKCjIwMTQtMDYtMjUtMDE6MTM6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMzIJ
NTEJNjAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNmNjNjIwYi4uLiBy
dG11dGV4OiBNYWtlIHRoZSBydG11dGV4IHRlc3RlciBkZXBlbmQgb24gQlJPS0VOCkhFQUQg
aXMgbm93IGF0IDVmZTAwYTMuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtbGtwLWhz
eDAxLWkzODYtMjAxNDA2MjQyMzE4JwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gw
MS1pMzg2LTIwMTQwNjI0MjMxODo1ZmUwMGEzN2Y3ZWI4MWYzMDZhYmRmZmJmNGQ3MDkzZGE1
MWI4Y2NjOmJpc2VjdC1saW51eDUKIFRFU1QgRkFJTFVSRQpbICAgIDAuMDAwMDAwXSAgIC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tClsgICAgMC4wMDAwMDBdICAgICAgICAgICAgICAgICAgICAg
IEEtQSBkZWFkbG9jazogIG9rICB8ICBvayAgfEZBSUxFRHwKWyAgICAwLjAwMDAwMF0gQ1BV
OiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNi4wLXJjMi0wMDIx
MS1nNWZlMDBhMyAjNDI1ClsgICAgMC4wMDAwMDBdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJv
Y2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjAwMDAwMF0gIDAwMDAwMDAwIDAw
MDAwMDAwIGMxNjMzZjhjIGMxNDEyNzcxIDAwMDAwMDAxIGMxNjMzZmI0IGMxNDEyOWMxIGMx
NWEwMjVhClsgICAgMC4wMDAwMDBdICBjMTQxMDIxYyAwMDAwMDAwMCAwMDAwMDAwNCAwMDAw
MDAwMiBjMTZiZjM5MCAwMDAyMDgwMCBjMTg0NTgwMCBjMTYzM2ZjOApbICAgIDAuMDAwMDAw
XSAgYzEyMjAwMjIgYzE1YTA0MjkgYzE1YTA0MWMgMDAwMDA3ODAgYzE2MzNmZTggYzE2ODhh
MGQgMDAwMDAwZWEgZmZmZmZmZmYKWyAgICAwLjAwMDAwMF0gQ2FsbCBUcmFjZToKWyAgICAw
LjAwMDAwMF0gIFs8YzE0MTI3NzE+XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApbICAgIDAuMDAw
MDAwXSAgWzxjMTQxMjljMT5dIGRvdGVzdCsweDU4LzB4NGJjClsgICAgMC4wMDAwMDBdICBb
PGMxNDEwMjFjPl0gPyBwcmludGsrMHgzOC8weDNhClsgICAgMC4wMDAwMDBdICBbPGMxMjIw
MDIyPl0gbG9ja2luZ19zZWxmdGVzdCsweGQ0LzB4MWRkYgpbICAgIDAuMDAwMDAwXSAgWzxj
MTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsweDJlNS8weDNhMQpbICAgIDAuMDAwMDAwXSAgWzxj
MTY4ODRjNT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpbICAgIDAuMDAwMDAwXSAgWzxj
MTY4ODJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgIDAuMDAwMDAwXSAg
IG9rICB8ICBvayAgfCAgb2sgIHwKWyAgICAwLjAwMDAwMF0gICAgICAgICAgICAgICAgICBB
LUItQi1BIGRlYWRsb2NrOiAgb2sgIHwgIG9rICB8RkFJTEVEfApbICAgIDAuMDAwMDAwXSBD
UFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMyLTAw
MjExLWc1ZmUwMGEzICM0MjUKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9jaHMg
Qm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAwXSAgMDAwMDAwMDAg
MDAwMDAwMDAgYzE2MzNmOGMgYzE0MTI3NzEgMDAwMDAwMDEgYzE2MzNmYjQgYzE0MTI5YzEg
YzE1YTAyNWEKWyAgICAwLjAwMDAwMF0gIGMxNDEwMjFjIDAwMDAwMDAwIDAwMDAwMDA0IDAw
MDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMxODQ1ODAwIGMxNjMzZmM4ClsgICAgMC4wMDAw
MDBdICBjMTIyMDBhYiBjMTVhMDQyOSBjMTVhMDQyZiAwMDAwMDc4MCBjMTYzM2ZlOCBjMTY4
OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAg
IDAuMDAwMDAwXSAgWzxjMTQxMjc3MT5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMC4w
MDAwMDBdICBbPGMxNDEyOWMxPl0gZG90ZXN0KzB4NTgvMHg0YmMKWyAgICAwLjAwMDAwMF0g
IFs8YzE0MTAyMWM+XSA/IHByaW50aysweDM4LzB4M2EKWyAgICAwLjAwMDAwMF0gIFs8YzEy
MjAwYWI+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4MTVkLzB4MWRkYgpbICAgIDAuMDAwMDAwXSAg
WzxjMTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsweDJlNS8weDNhMQpbICAgIDAuMDAwMDAwXSAg
WzxjMTY4ODRjNT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpbICAgIDAuMDAwMDAwXSAg
WzxjMTY4ODJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgIDAuMDAwMDAw
XSAgIG9rICB8ICBvayAgfCAgb2sgIHwKWyAgICAwLjAwMDAwMF0gICAgICAgICAgICAgIEEt
Qi1CLUMtQy1BIGRlYWRsb2NrOiAgb2sgIHwgIG9rICB8RkFJTEVEfApbICAgIDAuMDAwMDAw
XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAtcmMy
LTAwMjExLWc1ZmUwMGEzICM0MjUKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAwXSAgMDAwMDAw
MDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTI3NzEgMDAwMDAwMDEgYzE2MzNmYjQgYzE0MTI5
YzEgYzE1YTAyNWEKWyAgICAwLjAwMDAwMF0gIGMxNDEwMjFjIDAwMDAwMDAwIDAwMDAwMDA0
IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMxODQ1ODAwIGMxNjMzZmM4ClsgICAgMC4w
MDAwMDBdICBjMTIyMDEzNCBjMTVhMDQyOSBjMTVhMDQ0MCAwMDAwMDc4MCBjMTYzM2ZlOCBj
MTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpb
ICAgIDAuMDAwMDAwXSAgWzxjMTQxMjc3MT5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAg
MC4wMDAwMDBdICBbPGMxNDEyOWMxPl0gZG90ZXN0KzB4NTgvMHg0YmMKWyAgICAwLjAwMDAw
MF0gIFs8YzE0MTAyMWM+XSA/IHByaW50aysweDM4LzB4M2EKWyAgICAwLjAwMDAwMF0gIFs8
YzEyMjAxMzQ+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4MWU2LzB4MWRkYgpbICAgIDAuMDAwMDAw
XSAgWzxjMTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsweDJlNS8weDNhMQpbICAgIDAuMDAwMDAw
XSAgWzxjMTY4ODRjNT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpbICAgIDAuMDAwMDAw
XSAgWzxjMTY4ODJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgIDAuMDAw
MDAwXSAgIG9rICB8ICBvayAgfCAgb2sgIHwKWyAgICAwLjAwMDAwMF0gICAgICAgICAgICAg
IEEtQi1DLUEtQi1DIGRlYWRsb2NrOiAgb2sgIHwgIG9rICB8RkFJTEVEfApbICAgIDAuMDAw
MDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2LjAt
cmMyLTAwMjExLWc1ZmUwMGEzICM0MjUKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFtZTog
Qm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAwXSAgMDAw
MDAwMDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTI3NzEgMDAwMDAwMDEgYzE2MzNmYjQgYzE0
MTI5YzEgYzE1YTAyNWEKWyAgICAwLjAwMDAwMF0gIGMxNDEwMjFjIDAwMDAwMDAwIDAwMDAw
MDA0IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMxODQ1ODAwIGMxNjMzZmM4ClsgICAg
MC4wMDAwMDBdICBjMTIyMDFiZCBjMTVhMDQyOSBjMTVhMDQ1NSAwMDAwMDc4MCBjMTYzM2Zl
OCBjMTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBDYWxsIFRyYWNl
OgpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjc3MT5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsg
ICAgMC4wMDAwMDBdICBbPGMxNDEyOWMxPl0gZG90ZXN0KzB4NTgvMHg0YmMKWyAgICAwLjAw
MDAwMF0gIFs8YzE0MTAyMWM+XSA/IHByaW50aysweDM4LzB4M2EKWyAgICAwLjAwMDAwMF0g
IFs8YzEyMjAxYmQ+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4MjZmLzB4MWRkYgpbICAgIDAuMDAw
MDAwXSAgWzxjMTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsweDJlNS8weDNhMQpbICAgIDAuMDAw
MDAwXSAgWzxjMTY4ODRjNT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpbICAgIDAuMDAw
MDAwXSAgWzxjMTY4ODJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgIDAu
MDAwMDAwXSAgIG9rICB8ICBvayAgfCAgb2sgIHwKWyAgICAwLjAwMDAwMF0gICAgICAgICAg
QS1CLUItQy1DLUQtRC1BIGRlYWRsb2NrOiAgb2sgIHwgIG9rICB8RkFJTEVEfApbICAgIDAu
MDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE2
LjAtcmMyLTAwMjExLWc1ZmUwMGEzICM0MjUKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAwXSAg
MDAwMDAwMDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTI3NzEgMDAwMDAwMDEgYzE2MzNmYjQg
YzE0MTI5YzEgYzE1YTAyNWEKWyAgICAwLjAwMDAwMF0gIGMxNDEwMjFjIDAwMDAwMDAwIDAw
MDAwMDA0IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMxODQ1ODAwIGMxNjMzZmM4Clsg
ICAgMC4wMDAwMDBdICBjMTIyMDI0NiBjMTVhMDQyOSBjMTVhMDQ2YSAwMDAwMDc4MCBjMTYz
M2ZlOCBjMTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBDYWxsIFRy
YWNlOgpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjc3MT5dIGR1bXBfc3RhY2srMHg0OC8weDYw
ClsgICAgMC4wMDAwMDBdICBbPGMxNDEyOWMxPl0gZG90ZXN0KzB4NTgvMHg0YmMKWyAgICAw
LjAwMDAwMF0gIFs8YzE0MTAyMWM+XSA/IHByaW50aysweDM4LzB4M2EKWyAgICAwLjAwMDAw
MF0gIFs8YzEyMjAyNDY+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4MmY4LzB4MWRkYgpbICAgIDAu
MDAwMDAwXSAgWzxjMTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsweDJlNS8weDNhMQpbICAgIDAu
MDAwMDAwXSAgWzxjMTY4ODRjNT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpbICAgIDAu
MDAwMDAwXSAgWzxjMTY4ODJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAg
IDAuMDAwMDAwXSAgIG9rICB8ICBvayAgfCAgb2sgIHwKWyAgICAwLjAwMDAwMF0gICAgICAg
ICAgQS1CLUMtRC1CLUQtRC1BIGRlYWRsb2NrOiAgb2sgIHwgIG9rICB8RkFJTEVEfApbICAg
IDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAz
LjE2LjAtcmMyLTAwMjExLWc1ZmUwMGEzICM0MjUKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAwMDAw
XSAgMDAwMDAwMDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTI3NzEgMDAwMDAwMDEgYzE2MzNm
YjQgYzE0MTI5YzEgYzE1YTAyNWEKWyAgICAwLjAwMDAwMF0gIGMxNDEwMjFjIDAwMDAwMDAw
IDAwMDAwMDA0IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMxODQ1ODAwIGMxNjMzZmM4
ClsgICAgMC4wMDAwMDBdICBjMTIyMDJjZiBjMTVhMDQyOSBjMTVhMDQ4MyAwMDAwMDc4MCBj
MTYzM2ZlOCBjMTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBDYWxs
IFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjc3MT5dIGR1bXBfc3RhY2srMHg0OC8w
eDYwClsgICAgMC4wMDAwMDBdICBbPGMxNDEyOWMxPl0gZG90ZXN0KzB4NTgvMHg0YmMKWyAg
ICAwLjAwMDAwMF0gIFs8YzE0MTAyMWM+XSA/IHByaW50aysweDM4LzB4M2EKWyAgICAwLjAw
MDAwMF0gIFs8YzEyMjAyY2Y+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4MzgxLzB4MWRkYgpbICAg
IDAuMDAwMDAwXSAgWzxjMTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsweDJlNS8weDNhMQpbICAg
IDAuMDAwMDAwXSAgWzxjMTY4ODRjNT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpbICAg
IDAuMDAwMDAwXSAgWzxjMTY4ODJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApb
ICAgIDAuMDAwMDAwXSAgIG9rICB8ICBvayAgfCAgb2sgIHwKWyAgICAwLjAwMDAwMF0gICAg
ICAgICAgQS1CLUMtRC1CLUMtRC1BIGRlYWRsb2NrOiAgb2sgIHwgIG9rICB8RkFJTEVEfApb
ICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRl
ZCAzLjE2LjAtcmMyLTAwMjExLWc1ZmUwMGEzICM0MjUKWyAgICAwLjAwMDAwMF0gSGFyZHdh
cmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuMDAw
MDAwXSAgMDAwMDAwMDAgMDAwMDAwMDAgYzE2MzNmOGMgYzE0MTI3NzEgMDAwMDAwMDEgYzE2
MzNmYjQgYzE0MTI5YzEgYzE1YTAyNWEKWyAgICAwLjAwMDAwMF0gIGMxNDEwMjFjIDAwMDAw
MDAwIDAwMDAwMDA0IDAwMDAwMDAyIGMxNmJmMzkwIDAwMDIwODAwIGMxODQ1ODAwIGMxNjMz
ZmM4ClsgICAgMC4wMDAwMDBdICBjMTIyMDM1OCBjMTVhMDQyOSBjMTVhMDQ5YyAwMDAwMDc4
MCBjMTYzM2ZlOCBjMTY4OGEwZCAwMDAwMDBlYSBmZmZmZmZmZgpbICAgIDAuMDAwMDAwXSBD
YWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxjMTQxMjc3MT5dIGR1bXBfc3RhY2srMHg0
OC8weDYwClsgICAgMC4wMDAwMDBdICBbPGMxNDEyOWMxPl0gZG90ZXN0KzB4NTgvMHg0YmMK
WyAgICAwLjAwMDAwMF0gIFs8YzE0MTAyMWM+XSA/IHByaW50aysweDM4LzB4M2EKWyAgICAw
LjAwMDAwMF0gIFs8YzEyMjAzNTg+XSBsb2NraW5nX3NlbGZ0ZXN0KzB4NDBhLzB4MWRkYgpb
ICAgIDAuMDAwMDAwXSAgWzxjMTY4OGEwZD5dIHN0YXJ0X2tlcm5lbCsweDJlNS8weDNhMQpb
ICAgIDAuMDAwMDAwXSAgWzxjMTY4ODRjNT5dID8gc2V0X2luaXRfYXJnKzB4NDkvMHg0OQpb
ICAgIDAuMDAwMDAwXSAgWzxjMTY4ODJhZj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3
ZApbICAgIDAuMDAwMDAwXSAgIG9rICB8ICBvayAgfCAgb2sgIHwKWyAgICAwLjAwMDAwMF0g
ICAgICAgICAgICAgICAgICAgICBkb3VibGUgdW5sb2NrOiAgb2sgIHwgIG9rICB8ICBvayAg
fCAgb2sgIHwgIG9rICB8ICBvayAgfApbICAgIDAuMDAwMDAwXSAgICAgICAgICAgICAgICAg
ICBpbml0aWFsaXplIGhlbGQ6ICBvayAgfCAgb2sgIHwgIG9rICB8ICBvayAgfCAgb2sgIHwg
IG9rICB8Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LzVmZTAwYTM3ZjdlYjgx
ZjMwNmFiZGZmYmY0ZDcwOTNkYTUxYjhjY2MvZG1lc2ctcXVhbnRhbC1pdmI0MS0zMToyMDE0
MDYyNDIzMjY0MDppMzg2LXJhbmRjb25maWctaGEzLTA2MjQ6My4xNi4wLXJjMi0wMDIxMS1n
NWZlMDBhMzo0MjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvNWZlMDBhMzdm
N2ViODFmMzA2YWJkZmZiZjRkNzA5M2RhNTFiOGNjYy9kbWVzZy1xdWFudGFsLWl2YjQxLTQy
OjIwMTQwNjI0MjMzMDA2OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYyNDozLjE2LjAtcmMyLTAw
MjExLWc1ZmUwMGEzOjQyNQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC81ZmUw
MGEzN2Y3ZWI4MWYzMDZhYmRmZmJmNGQ3MDkzZGE1MWI4Y2NjL2RtZXNnLXF1YW50YWwtaXZi
NDEtOTE6MjAxNDA2MjQyMzMwNDM6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1y
YzItMDAyMTEtZzVmZTAwYTM6NDI1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0
LzVmZTAwYTM3ZjdlYjgxZjMwNmFiZGZmYmY0ZDcwOTNkYTUxYjhjY2MvZG1lc2ctcXVhbnRh
bC1pdmI0Mi0zODoyMDE0MDYyNDIzMzA0MDppMzg2LXJhbmRjb25maWctaGEzLTA2MjQ6My4x
Ni4wLXJjMi0wMDIxMS1nNWZlMDBhMzo0MjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEz
LTA2MjQvNWZlMDBhMzdmN2ViODFmMzA2YWJkZmZiZjRkNzA5M2RhNTFiOGNjYy9kbWVzZy15
b2N0by1pdmI0MS05NToyMDE0MDYyNDIzMzAyODppMzg2LXJhbmRjb25maWctaGEzLTA2MjQ6
My4xNi4wLXJjMi0wMDIxMS1nNWZlMDBhMzo0MjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aGEzLTA2MjQvNWZlMDBhMzdmN2ViODFmMzA2YWJkZmZiZjRkNzA5M2RhNTFiOGNjYy9kbWVz
Zy15b2N0by1pdmI0Mi04NDoyMDE0MDYyNDIzMjY0MTppMzg2LXJhbmRjb25maWctaGEzLTA2
MjQ6My4xNi4wLXJjMi0wMDIxMS1nNWZlMDBhMzo0MjUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaGEzLTA2MjQvNWZlMDBhMzdmN2ViODFmMzA2YWJkZmZiZjRkNzA5M2RhNTFiOGNjYy9k
bWVzZy15b2N0by1pdmI0MS05NToyMDE0MDYyNDIzMzAxMzppMzg2LXJhbmRjb25maWctaGEz
LTA2MjQ6My4xNi4wLXJjMi0wMDIxMS1nNWZlMDBhMzo0MjUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaGEzLTA2MjQvNWZlMDBhMzdmN2ViODFmMzA2YWJkZmZiZjRkNzA5M2RhNTFiOGNj
Yy9kbWVzZy15b2N0by1pdmI0Mi00OToyMDE0MDYyNDIzMzA0MDppMzg2LXJhbmRjb25maWct
aGEzLTA2MjQ6My4xNi4wLXJjMi0wMDIxMS1nNWZlMDBhMzo0MjUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaGEzLTA2MjQvNWZlMDBhMzdmN2ViODFmMzA2YWJkZmZiZjRkNzA5M2RhNTFi
OGNjYy9kbWVzZy15b2N0by1pdmI0Mi0xMDg6MjAxNDA2MjQyMzMwNDc6aTM4Ni1yYW5kY29u
ZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzItMDAyMTEtZzVmZTAwYTM6NDI1Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWhhMy0wNjI0LzVmZTAwYTM3ZjdlYjgxZjMwNmFiZGZmYmY0ZDcwOTNk
YTUxYjhjY2MvZG1lc2cteW9jdG8taXZiNDItNDk6MjAxNDA2MjQyMzMwMTg6aTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzItMDAyMTEtZzVmZTAwYTM6NDI1Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LzVmZTAwYTM3ZjdlYjgxZjMwNmFiZGZmYmY0ZDcw
OTNkYTUxYjhjY2MvZG1lc2cteW9jdG8taXZiNDItMjQ6MjAxNDA2MjQyMzMwMzI6aTM4Ni1y
YW5kY29uZmlnLWhhMy0wNjI0OjMuMTYuMC1yYzItMDAyMTEtZzVmZTAwYTM6NDI1Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjI0LzVmZTAwYTM3ZjdlYjgxZjMwNmFiZGZmYmY0
ZDcwOTNkYTUxYjhjY2MvZG1lc2ctcXVhbnRhbC1pdmI0Mi03ODoyMDE0MDYyNDIzMjYzOTpp
Mzg2LXJhbmRjb25maWctaGEzLTA2MjQ6My4xNi4wLXJjMi0wMDIxMS1nNWZlMDBhMzo0MjUK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQvNWZlMDBhMzdmN2ViODFmMzA2YWJk
ZmZiZjRkNzA5M2RhNTFiOGNjYy9kbWVzZy15b2N0by1pdmI0MS05NToyMDE0MDYyNDIzMzA0
MzppMzg2LXJhbmRjb25maWctaGEzLTA2MjQ6My4xNi4wLXJjMi0wMDIxMS1nNWZlMDBhMzo0
MjUKMDoxMzoxMyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQg
NWZlMDBhMyAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1sa3AtaHN4MDEtaTM4Ni0yMDE0
MDYyNDIzMTgnCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09ClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIDVmZTAwYTMuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtbGtw
LWhzeDAxLWkzODYtMjAxNDA2MjQyMzE4JwpIRUFEIGlzIG5vdyBhdCA4YjhmNWQ5Li4uIE1l
cmdlIHRhZyAnY29tcHJlc3MtMy4xNi1yYzMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9ncmVna2gvZHJpdmVyLWNvcmUKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYyNC9saW51czpt
YXN0ZXI6OGI4ZjVkOTcxNTg0NWY5YWUyYjg5Y2U0MDZlNzE4Nzc5NjViMjljYTpiaXNlY3Qt
bGludXg1CgoyMDE0LTA2LTI1LTAxOjE2OjAzIDhiOGY1ZDk3MTU4NDVmOWFlMmI4OWNlNDA2
ZTcxODc3OTY1YjI5Y2EgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MjQv
OGI4ZjVkOTcxNTg0NWY5YWUyYjg5Y2U0MDZlNzE4Nzc5NjViMjljYS92bWxpbnV6LTMuMTYu
MC1yYzItMDAwMzUtZzhiOGY1ZDkKCjIwMTQtMDYtMjUtMDE6MTY6MDMgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4JOAkxOQkyMwkzMwk1OAk2MCBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4
LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDhiOGY1ZDkuLi4g
TWVyZ2UgdGFnICdjb21wcmVzcy0zLjE2LXJjMycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dyZWdraC9kcml2ZXItY29yZQpIRUFEIGlzIG5v
dyBhdCAzYWI2M2RjLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0
MDYyNApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWhhMy0wNjI0L25leHQ6bWFzdGVyOjNhYjYzZGM2YjI5MTJiNzY2MzJlMzQ4ODllYzI2MzU1
MDk2YWFlYWQ6YmlzZWN0LWxpbnV4NQoKMjAxNC0wNi0yNS0wMToyMDowNyAzYWI2M2RjNmIy
OTEyYjc2NjMyZTM0ODg5ZWMyNjM1NTA5NmFhZWFkIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjI0LzNhYjYzZGM2YjI5MTJiNzY2MzJlMzQ4ODllYzI2MzU1MDk2YWFl
YWQvdm1saW51ei0zLjE2LjAtcmMyLW5leHQtMjAxNDA2MjQKCjIwMTQtMDYtMjUtMDE6MjA6
MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTUJMjEJNjAgU1VDQ0VTUwoK

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.16.0-rc1-00024-gb7e4888"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.16.0-rc1 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
CONFIG_MODULE_SIG_SHA224=y
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha224"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_STA2X11 is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
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
# CONFIG_MWINCHIP3D is not set
CONFIG_MELAN=y
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
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
CONFIG_VM86=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
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
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
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
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

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
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
# CONFIG_TS5500 is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=m
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
# CONFIG_NET_PTP_CLASSIFY is not set
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
# CONFIG_HSR is not set
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
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=m
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TWL4030=m
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=m
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_DA9034=m
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_SUR40=m
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_BEEPER=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=m
CONFIG_INPUT_TWL4030_PWRBUTTON=m
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_I2C=m
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_SOC_BUTTON_ARRAY is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_GOLDFISH_TTY=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_MEN_Z135=m
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

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
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
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
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_F7188X=m
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_LP3943=m
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=m
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=m
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=m
CONFIG_BATTERY_TWL4030_MADC=m
CONFIG_CHARGER_PCF50633=m
CONFIG_BATTERY_RX51=m
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=m
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=m
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=m
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_PTN3460=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
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
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=m
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
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=m
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
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

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_USB is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
# CONFIG_SND_ATMEL_SOC is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_SAI=m
CONFIG_SND_SOC_FSL_SSI=m
CONFIG_SND_SOC_FSL_SPDIF=m
# CONFIG_SND_SOC_FSL_ESAI is not set
CONFIG_SND_SOC_IMX_AUDMUX=m
CONFIG_SND_SOC_INTEL_SST=m
CONFIG_SND_SOC_INTEL_SST_ACPI=m
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_AK4554 is not set
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK5386=m
CONFIG_SND_SOC_ALC5623=m
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
CONFIG_SND_SOC_CS42L73=m
CONFIG_SND_SOC_CS4270=m
# CONFIG_SND_SOC_CS4271 is not set
CONFIG_SND_SOC_CS42XX8=m
CONFIG_SND_SOC_CS42XX8_I2C=m
CONFIG_SND_SOC_HDMI_CODEC=m
# CONFIG_SND_SOC_PCM1681 is not set
CONFIG_SND_SOC_PCM512x=m
CONFIG_SND_SOC_PCM512x_I2C=m
# CONFIG_SND_SOC_SGTL5000 is not set
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_STA350=m
CONFIG_SND_SOC_TAS5086=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
# CONFIG_SND_SOC_WM8580 is not set
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8776 is not set
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_TPA6130A2=m
CONFIG_SND_SIMPLE_CARD=m
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=m
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=m
# CONFIG_SOUND_YM3812 is not set
CONFIG_SOUND_UART6850=m
# CONFIG_SOUND_AEDSP16 is not set
# CONFIG_SOUND_KAHLUA is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_RENESAS_USBHS_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set
CONFIG_USB_RENESAS_USBHS=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=m
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=m
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=m
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MXUPORT=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
CONFIG_USB_SERIAL_WISHBONE=m
CONFIG_USB_SERIAL_ZTE=m
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
CONFIG_SAMSUNG_USBPHY=m
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=m
CONFIG_USB_GPIO_VBUS=m
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=m
CONFIG_USB_FOTG210_UDC=m
CONFIG_USB_GR_UDC=m
CONFIG_USB_R8A66597=m
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
CONFIG_USB_MV_UDC=m
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_F_FS=m
# CONFIG_USB_CONFIGFS is not set
CONFIG_USB_ZERO=m
CONFIG_USB_ZERO_HNPTEST=y
CONFIG_USB_AUDIO=m
CONFIG_GADGET_UAC1=y
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
# CONFIG_USB_FUNCTIONFS_ETH is not set
# CONFIG_USB_FUNCTIONFS_RNDIS is not set
CONFIG_USB_FUNCTIONFS_GENERIC=y
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_GADGET_TARGET=m
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
CONFIG_USB_G_ACM_MS=m
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
# CONFIG_USB_G_DBGP_PRINTK is not set
CONFIG_USB_G_DBGP_SERIAL=y
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_USB=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_BOND=m
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
# CONFIG_COMEDI_SSV_DNP is not set
CONFIG_COMEDI_ISA_DRIVERS=y
CONFIG_COMEDI_PCL711=m
CONFIG_COMEDI_PCL724=m
CONFIG_COMEDI_PCL726=m
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
CONFIG_COMEDI_PCL818=m
# CONFIG_COMEDI_PCM3724 is not set
CONFIG_COMEDI_AMPLC_DIO200_ISA=m
# CONFIG_COMEDI_AMPLC_PC236_ISA is not set
CONFIG_COMEDI_AMPLC_PC263_ISA=m
CONFIG_COMEDI_RTI800=m
CONFIG_COMEDI_RTI802=m
CONFIG_COMEDI_DAC02=m
# CONFIG_COMEDI_DAS16M1 is not set
CONFIG_COMEDI_DAS08_ISA=m
CONFIG_COMEDI_DAS16=m
CONFIG_COMEDI_DAS800=m
# CONFIG_COMEDI_DAS1800 is not set
CONFIG_COMEDI_DAS6402=m
CONFIG_COMEDI_DT2801=m
# CONFIG_COMEDI_DT2811 is not set
# CONFIG_COMEDI_DT2814 is not set
# CONFIG_COMEDI_DT2815 is not set
CONFIG_COMEDI_DT2817=m
# CONFIG_COMEDI_DT282X is not set
# CONFIG_COMEDI_DMM32AT is not set
# CONFIG_COMEDI_UNIOXX5 is not set
# CONFIG_COMEDI_FL512 is not set
CONFIG_COMEDI_AIO_AIO12_8=m
CONFIG_COMEDI_AIO_IIRO_16=m
CONFIG_COMEDI_II_PCI20KC=m
# CONFIG_COMEDI_C6XDIGIO is not set
CONFIG_COMEDI_MPC624=m
# CONFIG_COMEDI_ADQ12B is not set
CONFIG_COMEDI_NI_AT_A2150=m
CONFIG_COMEDI_NI_AT_AO=m
CONFIG_COMEDI_NI_ATMIO=m
# CONFIG_COMEDI_NI_ATMIO16D is not set
CONFIG_COMEDI_NI_LABPC_ISA=m
# CONFIG_COMEDI_PCMAD is not set
CONFIG_COMEDI_PCMDA12=m
CONFIG_COMEDI_PCMMIO=m
CONFIG_COMEDI_PCMUIO=m
CONFIG_COMEDI_MULTIQ3=m
# CONFIG_COMEDI_S526 is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_USB_DRIVERS=y
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_USBDUX=m
# CONFIG_COMEDI_USBDUXFAST is not set
CONFIG_COMEDI_USBDUXSIGMA=m
# CONFIG_COMEDI_VMK80XX is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_LABPC_ISADMA=m
CONFIG_COMEDI_NI_TIO=m
# CONFIG_PANEL is not set
# CONFIG_RTS5208 is not set
# CONFIG_TRANZPORT is not set
CONFIG_LINE6_USB=y
# CONFIG_LINE6_USB_IMPULSE_RESPONSE is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7854=m
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=m
CONFIG_SPEAKUP_SYNTH_ACNTSA=m
# CONFIG_SPEAKUP_SYNTH_APOLLO is not set
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=m
CONFIG_SPEAKUP_SYNTH_DECTLK=m
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
CONFIG_SPEAKUP_SYNTH_LTLK=m
CONFIG_SPEAKUP_SYNTH_SOFT=m
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=m
CONFIG_SPEAKUP_SYNTH_DUMMY=m
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_CED1401 is not set
CONFIG_DGRP=y
CONFIG_GOLDFISH_AUDIO=m
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=m
CONFIG_GS_FPGABOOT=m
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_GOLDFISH_PIPE=y
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_CHROMEOS_PSTORE=y

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_MMA8452=m

#
# Analog to digital converters
#
CONFIG_AD799X=m
CONFIG_MAX1363=m
CONFIG_MCP3422=m
CONFIG_MEN_Z188_ADC=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
CONFIG_TWL4030_MADC=m
CONFIG_TWL6030_GPADC=m
CONFIG_VIPERBOARD_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5380=m
# CONFIG_AD5446 is not set
CONFIG_MAX517=m
CONFIG_MCP4725=m

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
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=m

#
# Humidity sensors
#
CONFIG_DHT11=m
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
# CONFIG_GP2AP020A00F is not set
# CONFIG_HID_SENSOR_ALS is not set
# CONFIG_HID_SENSOR_PROX is not set
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=m
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_MPL115 is not set
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Lightning sensors
#

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
CONFIG_TMP006=m
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=m
CONFIG_PHY_SAMSUNG_USB2=m
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=m
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=m
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
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
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_TEST_BPF is not set
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
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=m
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--gKMricLos+KVdGMg--
