Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaAVI2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:28:07 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50248 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaAVI17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:27:59 -0500
Message-ID: <52DF8101.6020903@linux.vnet.ibm.com>
Date: Wed, 22 Jan 2014 16:27:45 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] sched: tip/master show soft lockup while running multiple VM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012208-1396-0000-0000-0000042C969E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Folks

I've try to run two VMs on 12-cpus X86 server:

qemu-kvm -smp 12 -m 8G ./fedora_1.img
qemu-kvm -smp 12 -m 8G ./fedora_2.img

Using the latest tip/master, but got soft-lockup immediately:

BUG: soft lockup - CPU#7 stuck for 23s! [qemu-kvm:2589]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 7 PID: 2589 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933bfce00 ti: ffff880079bbe000 task.ti: ffff880079bbe000
RIP: 0010:[<ffffffffa097e2a0>]  [<ffffffffa097e2a0>] vmx_inject_irq+0xa0/0x130 [kvm_intel]
RSP: 0018:ffff880079bbfc98  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: ffffe8ffffae0ee0 RSI: 00000000800000ef RDI: 0000000000004016
RBP: ffff880079bbfcc8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880957b59200
R13: ffff880079bbfc88 R14: ffffffff8155eba2 R15: ffff880079bbfc48
FS:  00007f0ac7fff700(0000) GS:ffff88097f2e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 00000000800000ef ffff880079aa8040 0000000000000000 0000000000000001
 ffff880079bbffd8 ffff880933bfce00 ffff880079bbfd18 ffffffffa081ab29
 ffff880079bbfcf8 ffffffffa083f131 ffff880079bbfcf8 ffff880079aa8040
Call Trace:
 [<ffffffffa081ab29>] inject_pending_event+0xf9/0x1b0 [kvm]
 [<ffffffffa083f131>] ? kvm_lapic_find_highest_irr+0x41/0xa0 [kvm]
 [<ffffffffa0825814>] vcpu_enter_guest+0x284/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b

Bisect locate this commit:

commit a0fa1dd3cdbccec9597fe53b6177a9aa6e20f2f8
Merge: 9326657 eaad451
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jan 20 10:42:08 2014 -0800

    Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

Below is the dmesg and config, any ideas?

Regards,
Michael Wang



Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Initializing cgroup subsys cpuacct
Linux version 3.13.0+ (root@localhost.localdomain) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #374 SMP Wed Jan 22 12:44:51 CST 2014
Command line: ro root=UUID=03c50e18-696f-4559-915c-b9b2b4f8fadc rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8 rd_NO_MD quiet SYSFONT=latarcyrheb-sun16 rhgb crashkernel=auto  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM console=tty0 console=ttyS1,115200 memtest numa=fake=4 sched_debug
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000006bfff] usable
BIOS-e820: [mem 0x000000000006c000-0x000000000006cfff] ACPI NVS
BIOS-e820: [mem 0x000000000006d000-0x000000000009efff] usable
BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] ACPI NVS
BIOS-e820: [mem 0x0000000000100000-0x000000007d1b4fff] usable
BIOS-e820: [mem 0x000000007d1b5000-0x000000007d1dffff] reserved
BIOS-e820: [mem 0x000000007d1e0000-0x000000007d20afff] usable
BIOS-e820: [mem 0x000000007d20b000-0x000000007d235fff] reserved
BIOS-e820: [mem 0x000000007d236000-0x000000007d60efff] usable
BIOS-e820: [mem 0x000000007d60f000-0x000000007d6befff] reserved
BIOS-e820: [mem 0x000000007d6bf000-0x000000007f5eefff] usable
BIOS-e820: [mem 0x000000007f5ef000-0x000000007f6defff] reserved
BIOS-e820: [mem 0x000000007f6df000-0x000000007f7defff] ACPI NVS
BIOS-e820: [mem 0x000000007f7df000-0x000000007f7fefff] ACPI data
BIOS-e820: [mem 0x000000007f7ff000-0x000000007f7fffff] usable
BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000097fffffff] usable
NX (Execute Disable) protection: active
efi: EFI v2.10 by IBM
efi:  ACPI 2.0=0x7f7fe014  SMBIOS=0x7f6be000 
efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
efi: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x000000000001e000) (0MB)
efi: mem02: type=2, attr=0xf, range=[0x000000000001e000-0x0000000000020000) (0MB)
efi: mem03: type=3, attr=0xf, range=[0x0000000000020000-0x000000000006c000) (0MB)
efi: mem04: type=10, attr=0xf, range=[0x000000000006c000-0x000000000006d000) (0MB)
efi: mem05: type=4, attr=0xf, range=[0x000000000006d000-0x000000000006e000) (0MB)
efi: mem06: type=3, attr=0xf, range=[0x000000000006e000-0x000000000009f000) (0MB)
efi: mem07: type=10, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)
efi: mem08: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000800000) (7MB)
efi: mem09: type=3, attr=0xf, range=[0x0000000000800000-0x0000000001000000) (8MB)
efi: mem10: type=7, attr=0xf, range=[0x0000000001000000-0x00000000797a8000) (1927MB)
efi: mem11: type=2, attr=0xf, range=[0x00000000797a8000-0x000000007b237000) (26MB)
efi: mem12: type=4, attr=0xf, range=[0x000000007b237000-0x000000007bc39000) (10MB)
efi: mem13: type=2, attr=0xf, range=[0x000000007bc39000-0x000000007c039000) (4MB)
efi: mem14: type=1, attr=0xf, range=[0x000000007c039000-0x000000007c079000) (0MB)
efi: mem15: type=2, attr=0xf, range=[0x000000007c079000-0x000000007c0b6000) (0MB)
efi: mem16: type=4, attr=0xf, range=[0x000000007c0b6000-0x000000007c0cc000) (0MB)
efi: mem17: type=2, attr=0xf, range=[0x000000007c0cc000-0x000000007c2a1000) (1MB)
efi: mem18: type=4, attr=0xf, range=[0x000000007c2a1000-0x000000007c486000) (1MB)
efi: mem19: type=3, attr=0xf, range=[0x000000007c486000-0x000000007c488000) (0MB)
efi: mem20: type=4, attr=0xf, range=[0x000000007c488000-0x000000007d17f000) (12MB)
efi: mem21: type=3, attr=0xf, range=[0x000000007d17f000-0x000000007d18c000) (0MB)
efi: mem22: type=4, attr=0xf, range=[0x000000007d18c000-0x000000007d18f000) (0MB)
efi: mem23: type=2, attr=0xf, range=[0x000000007d18f000-0x000000007d190000) (0MB)
efi: mem24: type=4, attr=0xf, range=[0x000000007d190000-0x000000007d197000) (0MB)
efi: mem25: type=2, attr=0xf, range=[0x000000007d197000-0x000000007d199000) (0MB)
efi: mem26: type=4, attr=0xf, range=[0x000000007d199000-0x000000007d1b5000) (0MB)
efi: mem27: type=5, attr=0x800000000000000f, range=[0x000000007d1b5000-0x000000007d1e0000) (0MB)
efi: mem28: type=4, attr=0xf, range=[0x000000007d1e0000-0x000000007d208000) (0MB)
efi: mem29: type=2, attr=0xf, range=[0x000000007d208000-0x000000007d209000) (0MB)
efi: mem30: type=3, attr=0xf, range=[0x000000007d209000-0x000000007d20b000) (0MB)
efi: mem31: type=5, attr=0x800000000000000f, range=[0x000000007d20b000-0x000000007d236000) (0MB)
efi: mem32: type=4, attr=0xf, range=[0x000000007d236000-0x000000007d239000) (0MB)
efi: mem33: type=3, attr=0xf, range=[0x000000007d239000-0x000000007d23a000) (0MB)
efi: mem34: type=4, attr=0xf, range=[0x000000007d23a000-0x000000007d2ea000) (0MB)
efi: mem35: type=3, attr=0xf, range=[0x000000007d2ea000-0x000000007d2f5000) (0MB)
efi: mem36: type=4, attr=0xf, range=[0x000000007d2f5000-0x000000007d5de000) (2MB)
efi: mem37: type=3, attr=0xf, range=[0x000000007d5de000-0x000000007d5e4000) (0MB)
efi: mem38: type=4, attr=0xf, range=[0x000000007d5e4000-0x000000007d60f000) (0MB)
efi: mem39: type=0, attr=0xf, range=[0x000000007d60f000-0x000000007d6bf000) (0MB)
efi: mem40: type=4, attr=0xf, range=[0x000000007d6bf000-0x000000007d6c0000) (0MB)
efi: mem41: type=3, attr=0xf, range=[0x000000007d6c0000-0x000000007d6c8000) (0MB)
efi: mem42: type=4, attr=0xf, range=[0x000000007d6c8000-0x000000007d722000) (0MB)
efi: mem43: type=3, attr=0xf, range=[0x000000007d722000-0x000000007d73c000) (0MB)
efi: mem44: type=4, attr=0xf, range=[0x000000007d73c000-0x000000007d752000) (0MB)
efi: mem45: type=3, attr=0xf, range=[0x000000007d752000-0x000000007d759000) (0MB)
efi: mem46: type=4, attr=0xf, range=[0x000000007d759000-0x000000007d75e000) (0MB)
efi: mem47: type=3, attr=0xf, range=[0x000000007d75e000-0x000000007d760000) (0MB)
efi: mem48: type=4, attr=0xf, range=[0x000000007d760000-0x000000007d8a1000) (1MB)
efi: mem49: type=3, attr=0xf, range=[0x000000007d8a1000-0x000000007d8b8000) (0MB)
efi: mem50: type=4, attr=0xf, range=[0x000000007d8b8000-0x000000007d8c1000) (0MB)
efi: mem51: type=3, attr=0xf, range=[0x000000007d8c1000-0x000000007d8d1000) (0MB)
efi: mem52: type=4, attr=0xf, range=[0x000000007d8d1000-0x000000007d8d8000) (0MB)
efi: mem53: type=3, attr=0xf, range=[0x000000007d8d8000-0x000000007d8e9000) (0MB)
efi: mem54: type=4, attr=0xf, range=[0x000000007d8e9000-0x000000007d8ec000) (0MB)
efi: mem55: type=3, attr=0xf, range=[0x000000007d8ec000-0x000000007d8f4000) (0MB)
efi: mem56: type=2, attr=0xf, range=[0x000000007d8f4000-0x000000007dac7000) (1MB)
efi: mem57: type=4, attr=0xf, range=[0x000000007dac7000-0x000000007dc9e000) (1MB)
efi: mem58: type=3, attr=0xf, range=[0x000000007dc9e000-0x000000007dcfd000) (0MB)
efi: mem59: type=4, attr=0xf, range=[0x000000007dcfd000-0x000000007dcfe000) (0MB)
efi: mem60: type=3, attr=0xf, range=[0x000000007dcfe000-0x000000007dd1a000) (0MB)
efi: mem61: type=4, attr=0xf, range=[0x000000007dd1a000-0x000000007dd1c000) (0MB)
efi: mem62: type=3, attr=0xf, range=[0x000000007dd1c000-0x000000007dd28000) (0MB)
efi: mem63: type=4, attr=0xf, range=[0x000000007dd28000-0x000000007dd2d000) (0MB)
efi: mem64: type=3, attr=0xf, range=[0x000000007dd2d000-0x000000007dd38000) (0MB)
efi: mem65: type=4, attr=0xf, range=[0x000000007dd38000-0x000000007dd3b000) (0MB)
efi: mem66: type=3, attr=0xf, range=[0x000000007dd3b000-0x000000007dd51000) (0MB)
efi: mem67: type=4, attr=0xf, range=[0x000000007dd51000-0x000000007dd52000) (0MB)
efi: mem68: type=3, attr=0xf, range=[0x000000007dd52000-0x000000007dd56000) (0MB)
efi: mem69: type=4, attr=0xf, range=[0x000000007dd56000-0x000000007dd5a000) (0MB)
efi: mem70: type=3, attr=0xf, range=[0x000000007dd5a000-0x000000007dd5c000) (0MB)
efi: mem71: type=4, attr=0xf, range=[0x000000007dd5c000-0x000000007e069000) (3MB)
efi: mem72: type=3, attr=0xf, range=[0x000000007e069000-0x000000007e06a000) (0MB)
efi: mem73: type=4, attr=0xf, range=[0x000000007e06a000-0x000000007e070000) (0MB)
efi: mem74: type=3, attr=0xf, range=[0x000000007e070000-0x000000007e07d000) (0MB)
efi: mem75: type=4, attr=0xf, range=[0x000000007e07d000-0x000000007e187000) (1MB)
efi: mem76: type=3, attr=0xf, range=[0x000000007e187000-0x000000007e189000) (0MB)
efi: mem77: type=4, attr=0xf, range=[0x000000007e189000-0x000000007e18d000) (0MB)
efi: mem78: type=3, attr=0xf, range=[0x000000007e18d000-0x000000007e19e000) (0MB)
efi: mem79: type=4, attr=0xf, range=[0x000000007e19e000-0x000000007e19f000) (0MB)
efi: mem80: type=3, attr=0xf, range=[0x000000007e19f000-0x000000007e1aa000) (0MB)
efi: mem81: type=4, attr=0xf, range=[0x000000007e1aa000-0x000000007e1ad000) (0MB)
efi: mem82: type=3, attr=0xf, range=[0x000000007e1ad000-0x000000007e1b1000) (0MB)
efi: mem83: type=4, attr=0xf, range=[0x000000007e1b1000-0x000000007e1b2000) (0MB)
efi: mem84: type=3, attr=0xf, range=[0x000000007e1b2000-0x000000007e1b9000) (0MB)
efi: mem85: type=4, attr=0xf, range=[0x000000007e1b9000-0x000000007e1ba000) (0MB)
efi: mem86: type=3, attr=0xf, range=[0x000000007e1ba000-0x000000007e1be000) (0MB)
efi: mem87: type=4, attr=0xf, range=[0x000000007e1be000-0x000000007e1c3000) (0MB)
efi: mem88: type=3, attr=0xf, range=[0x000000007e1c3000-0x000000007e1c7000) (0MB)
efi: mem89: type=4, attr=0xf, range=[0x000000007e1c7000-0x000000007e1c9000) (0MB)
efi: mem90: type=3, attr=0xf, range=[0x000000007e1c9000-0x000000007e1d6000) (0MB)
efi: mem91: type=4, attr=0xf, range=[0x000000007e1d6000-0x000000007e1d7000) (0MB)
efi: mem92: type=3, attr=0xf, range=[0x000000007e1d7000-0x000000007e1e2000) (0MB)
efi: mem93: type=4, attr=0xf, range=[0x000000007e1e2000-0x000000007e1e3000) (0MB)
efi: mem94: type=3, attr=0xf, range=[0x000000007e1e3000-0x000000007e1fa000) (0MB)
efi: mem95: type=4, attr=0xf, range=[0x000000007e1fa000-0x000000007e302000) (1MB)
efi: mem96: type=3, attr=0xf, range=[0x000000007e302000-0x000000007e308000) (0MB)
efi: mem97: type=4, attr=0xf, range=[0x000000007e308000-0x000000007e309000) (0MB)
efi: mem98: type=3, attr=0xf, range=[0x000000007e309000-0x000000007e31f000) (0MB)
efi: mem99: type=4, attr=0xf, range=[0x000000007e31f000-0x000000007e322000) (0MB)
efi: mem100: type=3, attr=0xf, range=[0x000000007e322000-0x000000007e32a000) (0MB)
efi: mem101: type=4, attr=0xf, range=[0x000000007e32a000-0x000000007e32d000) (0MB)
efi: mem102: type=3, attr=0xf, range=[0x000000007e32d000-0x000000007e32f000) (0MB)
efi: mem103: type=4, attr=0xf, range=[0x000000007e32f000-0x000000007e330000) (0MB)
efi: mem104: type=3, attr=0xf, range=[0x000000007e330000-0x000000007e332000) (0MB)
efi: mem105: type=4, attr=0xf, range=[0x000000007e332000-0x000000007e336000) (0MB)
efi: mem106: type=3, attr=0xf, range=[0x000000007e336000-0x000000007e33b000) (0MB)
efi: mem107: type=4, attr=0xf, range=[0x000000007e33b000-0x000000007e33c000) (0MB)
efi: mem108: type=3, attr=0xf, range=[0x000000007e33c000-0x000000007e343000) (0MB)
efi: mem109: type=4, attr=0xf, range=[0x000000007e343000-0x000000007e344000) (0MB)
efi: mem110: type=3, attr=0xf, range=[0x000000007e344000-0x000000007e347000) (0MB)
efi: mem111: type=4, attr=0xf, range=[0x000000007e347000-0x000000007e34d000) (0MB)
efi: mem112: type=3, attr=0xf, range=[0x000000007e34d000-0x000000007e351000) (0MB)
efi: mem113: type=4, attr=0xf, range=[0x000000007e351000-0x000000007e357000) (0MB)
efi: mem114: type=3, attr=0xf, range=[0x000000007e357000-0x000000007e358000) (0MB)
efi: mem115: type=4, attr=0xf, range=[0x000000007e358000-0x000000007e359000) (0MB)
efi: mem116: type=3, attr=0xf, range=[0x000000007e359000-0x000000007e35b000) (0MB)
efi: mem117: type=4, attr=0xf, range=[0x000000007e35b000-0x000000007e37e000) (0MB)
efi: mem118: type=3, attr=0xf, range=[0x000000007e37e000-0x000000007e37f000) (0MB)
efi: mem119: type=4, attr=0xf, range=[0x000000007e37f000-0x000000007e380000) (0MB)
efi: mem120: type=3, attr=0xf, range=[0x000000007e380000-0x000000007e381000) (0MB)
efi: mem121: type=4, attr=0xf, range=[0x000000007e381000-0x000000007e391000) (0MB)
efi: mem122: type=3, attr=0xf, range=[0x000000007e391000-0x000000007e396000) (0MB)
efi: mem123: type=4, attr=0xf, range=[0x000000007e396000-0x000000007e398000) (0MB)
efi: mem124: type=3, attr=0xf, range=[0x000000007e398000-0x000000007e39a000) (0MB)
efi: mem125: type=4, attr=0xf, range=[0x000000007e39a000-0x000000007e4a4000) (1MB)
efi: mem126: type=3, attr=0xf, range=[0x000000007e4a4000-0x000000007e4a6000) (0MB)
efi: mem127: type=4, attr=0xf, range=[0x000000007e4a6000-0x000000007e4aa000) (0MB)
efi: mem128: type=3, attr=0xf, range=[0x000000007e4aa000-0x000000007e4ab000) (0MB)
efi: mem129: type=4, attr=0xf, range=[0x000000007e4ab000-0x000000007e4ac000) (0MB)
efi: mem130: type=3, attr=0xf, range=[0x000000007e4ac000-0x000000007e4ad000) (0MB)
efi: mem131: type=4, attr=0xf, range=[0x000000007e4ad000-0x000000007e4ae000) (0MB)
efi: mem132: type=3, attr=0xf, range=[0x000000007e4ae000-0x000000007e4b0000) (0MB)
efi: mem133: type=4, attr=0xf, range=[0x000000007e4b0000-0x000000007e4e8000) (0MB)
efi: mem134: type=3, attr=0xf, range=[0x000000007e4e8000-0x000000007e4f9000) (0MB)
efi: mem135: type=4, attr=0xf, range=[0x000000007e4f9000-0x000000007e54d000) (0MB)
efi: mem136: type=3, attr=0xf, range=[0x000000007e54d000-0x000000007e570000) (0MB)
efi: mem137: type=4, attr=0xf, range=[0x000000007e570000-0x000000007e581000) (0MB)
efi: mem138: type=3, attr=0xf, range=[0x000000007e581000-0x000000007e585000) (0MB)
efi: mem139: type=4, attr=0xf, range=[0x000000007e585000-0x000000007e5d0000) (0MB)
efi: mem140: type=3, attr=0xf, range=[0x000000007e5d0000-0x000000007e5ed000) (0MB)
efi: mem141: type=4, attr=0xf, range=[0x000000007e5ed000-0x000000007e5fa000) (0MB)
efi: mem142: type=3, attr=0xf, range=[0x000000007e5fa000-0x000000007e5fb000) (0MB)
efi: mem143: type=4, attr=0xf, range=[0x000000007e5fb000-0x000000007e605000) (0MB)
efi: mem144: type=3, attr=0xf, range=[0x000000007e605000-0x000000007e610000) (0MB)
efi: mem145: type=4, attr=0xf, range=[0x000000007e610000-0x000000007e615000) (0MB)
efi: mem146: type=3, attr=0xf, range=[0x000000007e615000-0x000000007e61b000) (0MB)
efi: mem147: type=4, attr=0xf, range=[0x000000007e61b000-0x000000007e621000) (0MB)
efi: mem148: type=3, attr=0xf, range=[0x000000007e621000-0x000000007e627000) (0MB)
efi: mem149: type=4, attr=0xf, range=[0x000000007e627000-0x000000007e629000) (0MB)
efi: mem150: type=3, attr=0xf, range=[0x000000007e629000-0x000000007e63d000) (0MB)
efi: mem151: type=4, attr=0xf, range=[0x000000007e63d000-0x000000007e641000) (0MB)
efi: mem152: type=3, attr=0xf, range=[0x000000007e641000-0x000000007e643000) (0MB)
efi: mem153: type=4, attr=0xf, range=[0x000000007e643000-0x000000007e645000) (0MB)
efi: mem154: type=3, attr=0xf, range=[0x000000007e645000-0x000000007e64a000) (0MB)
efi: mem155: type=4, attr=0xf, range=[0x000000007e64a000-0x000000007e64c000) (0MB)
efi: mem156: type=3, attr=0xf, range=[0x000000007e64c000-0x000000007e64d000) (0MB)
efi: mem157: type=4, attr=0xf, range=[0x000000007e64d000-0x000000007e64f000) (0MB)
efi: mem158: type=3, attr=0xf, range=[0x000000007e64f000-0x000000007e650000) (0MB)
efi: mem159: type=4, attr=0xf, range=[0x000000007e650000-0x000000007e653000) (0MB)
efi: mem160: type=3, attr=0xf, range=[0x000000007e653000-0x000000007e65c000) (0MB)
efi: mem161: type=4, attr=0xf, range=[0x000000007e65c000-0x000000007e68c000) (0MB)
efi: mem162: type=3, attr=0xf, range=[0x000000007e68c000-0x000000007e68f000) (0MB)
efi: mem163: type=4, attr=0xf, range=[0x000000007e68f000-0x000000007f5ef000) (15MB)
efi: mem164: type=6, attr=0x800000000000000f, range=[0x000000007f5ef000-0x000000007f5f1000) (0MB)
efi: mem165: type=6, attr=0x800000000000000f, range=[0x000000007f5f1000-0x000000007f600000) (0MB)
efi: mem166: type=5, attr=0x800000000000000f, range=[0x000000007f600000-0x000000007f60d000) (0MB)
efi: mem167: type=6, attr=0x800000000000000f, range=[0x000000007f60d000-0x000000007f63f000) (0MB)
efi: mem168: type=5, attr=0x800000000000000f, range=[0x000000007f63f000-0x000000007f68f000) (0MB)
efi: mem169: type=0, attr=0xf, range=[0x000000007f68f000-0x000000007f6bd000) (0MB)
efi: mem170: type=0, attr=0xf, range=[0x000000007f6bd000-0x000000007f6df000) (0MB)
efi: mem171: type=10, attr=0xf, range=[0x000000007f6df000-0x000000007f6ec000) (0MB)
efi: mem172: type=10, attr=0xf, range=[0x000000007f6ec000-0x000000007f7df000) (0MB)
efi: mem173: type=9, attr=0xf, range=[0x000000007f7df000-0x000000007f7ec000) (0MB)
efi: mem174: type=9, attr=0xf, range=[0x000000007f7ec000-0x000000007f7ff000) (0MB)
efi: mem175: type=4, attr=0xf, range=[0x000000007f7ff000-0x000000007f800000) (0MB)
efi: mem176: type=11, attr=0x8000000000000001, range=[0x00000000ff800000-0x0000000100000000) (8MB)
efi: mem177: type=7, attr=0xf, range=[0x0000000100000000-0x0000000980000000) (34816MB)
efi: mem178: type=11, attr=0x8000000000000001, range=[0x0000000080000000-0x0000000090000000) (256MB)
efi: mem179: type=11, attr=0x8000000000000000, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
SMBIOS 2.5 present.
DMI: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x980000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 base 0100000000 mask FF00000000 write-back
  2 base 0200000000 mask FE00000000 write-back
  3 base 0400000000 mask FC00000000 write-back
  4 base 0800000000 mask F800000000 write-back
  5 disabled
  6 disabled
  7 disabled
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820: update [mem 0x80000000-0xffffffff] usable ==> reserved
e820: last_pfn = 0x7f800 max_arch_pfn = 0x400000000
Base memory trampoline at [ffff880000097000] 97000 size 24576
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
BRK [0x01f4f000, 0x01f4ffff] PGTABLE
BRK [0x01f50000, 0x01f50fff] PGTABLE
BRK [0x01f51000, 0x01f51fff] PGTABLE
init_memory_mapping: [mem 0x97fe00000-0x97fffffff]
 [mem 0x97fe00000-0x97fffffff] page 1G
init_memory_mapping: [mem 0x97c000000-0x97fdfffff]
 [mem 0x97c000000-0x97fdfffff] page 1G
init_memory_mapping: [mem 0x900000000-0x97bffffff]
 [mem 0x900000000-0x97bffffff] page 1G
init_memory_mapping: [mem 0x00100000-0x7d1b4fff]
 [mem 0x00100000-0x001fffff] page 4k
 [mem 0x00200000-0x7cffffff] page 2M
 [mem 0x7d000000-0x7d1b4fff] page 4k
init_memory_mapping: [mem 0x7d1e0000-0x7d20afff]
 [mem 0x7d1e0000-0x7d20afff] page 4k
BRK [0x01f52000, 0x01f52fff] PGTABLE
init_memory_mapping: [mem 0x7d236000-0x7d60efff]
 [mem 0x7d236000-0x7d3fffff] page 4k
 [mem 0x7d400000-0x7d5fffff] page 2M
 [mem 0x7d600000-0x7d60efff] page 4k
BRK [0x01f53000, 0x01f53fff] PGTABLE
init_memory_mapping: [mem 0x7d6bf000-0x7f5eefff]
 [mem 0x7d6bf000-0x7d7fffff] page 4k
 [mem 0x7d800000-0x7f3fffff] page 2M
 [mem 0x7f400000-0x7f5eefff] page 4k
BRK [0x01f54000, 0x01f54fff] PGTABLE
init_memory_mapping: [mem 0x7f7ff000-0x7f7fffff]
 [mem 0x7f7ff000-0x7f7fffff] page 4k
init_memory_mapping: [mem 0x100000000-0x8ffffffff]
 [mem 0x100000000-0x8ffffffff] page 1G
RAMDISK: [mem 0x797a8000-0x7a52afff]
ACPI: RSDP 000000007f7fe014 000024 (v02 IBM   )
ACPI: XSDT 000000007f7fe120 00007C (v01 IBM    THURLEY  00000000      01000013)
ACPI: FACP 000000007f7fb000 0000F4 (v04 IBM    THURLEY  00000000 IBM  01000013)
ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20131115/tbfadt-653)
ACPI: DSDT 000000007f7f8000 002C3E (v01 IBM    THURLEY  00000003 IBM  01000013)
ACPI: FACS 000000007f6ec000 000040
ACPI: TCPA 000000007f7fd000 000064 (v00                 00000000      00000000)
ACPI: APIC 000000007f7f7000 00011E (v02 IBM    THURLEY  00000000 IBM  01000013)
ACPI: MCFG 000000007f7f6000 00003C (v01 IBM    THURLEY  00000001 IBM  01000013)
ACPI: SLIC 000000007f7f5000 000176 (v01 IBM    THURLEY  00000000 IBM  01000013)
ACPI: HPET 000000007f7f4000 000038 (v01 IBM    THURLEY  00000001 IBM  01000013)
ACPI: SSDT 000000007f7f3000 000183 (v02 IBM    CPUSCOPE 00004000 IBM  01000013)
ACPI: SSDT 000000007f7f2000 000699 (v02 IBM    CPUWYVRN 00004000 IBM  01000013)
ACPI: SSDT 000000007f7ee000 0036A4 (v02 IBM    PSTATEPM 00004000 IBM  01000013)
ACPI: ERST 000000007f7ed000 000230 (v01 IBM    THURLEY  00000001 IBM  01000013)
ACPI: DMAR 000000007f7ec000 0000D8 (v01 IBM    THURLEY  00000001 IBM  01000013)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at [mem 0x0000000000000000-0x000000097fffffff]
Initmem setup node 0 [mem 0x00000000-0x97fffffff]
  NODE_DATA [mem 0x97ffd6000-0x97fffcfff]
crashkernel: memory value expected
 [ffffea0000000000-ffffea00213fffff] PMD -> [ffff88095b600000-ffff88097adfffff] on node 0
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x97fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0006bfff]
  node   0: [mem 0x0006d000-0x0009efff]
  node   0: [mem 0x00100000-0x7d1b4fff]
  node   0: [mem 0x7d1e0000-0x7d20afff]
  node   0: [mem 0x7d236000-0x7d60efff]
  node   0: [mem 0x7d6bf000-0x7f5eefff]
  node   0: [mem 0x7f7ff000-0x7f7fffff]
  node   0: [mem 0x100000000-0x97fffffff]
On node 0 totalpages: 9434247
  DMA zone: 56 pages used for memmap
  DMA zone: 2148 pages reserved
  DMA zone: 3997 pages, LIFO batch:0
  DMA32 zone: 7074 pages used for memmap
  DMA32 zone: 517354 pages, LIFO batch:31
  Normal zone: 121856 pages used for memmap
  Normal zone: 8912896 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x588
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x20] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x22] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x24] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x30] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x32] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x34] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x15] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x21] disabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] disabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x25] disabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x31] disabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x33] disabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x35] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
smpboot: Allowing 24 CPUs, 12 hotplug CPUs
nr_irqs_gsi: 64
PM: Registered nosave memory: [mem 0x0006c000-0x0006cfff]
PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
PM: Registered nosave memory: [mem 0x7d1b5000-0x7d1dffff]
PM: Registered nosave memory: [mem 0x7d20b000-0x7d235fff]
PM: Registered nosave memory: [mem 0x7d60f000-0x7d6befff]
PM: Registered nosave memory: [mem 0x7f5ef000-0x7f6defff]
PM: Registered nosave memory: [mem 0x7f6df000-0x7f7defff]
PM: Registered nosave memory: [mem 0x7f7df000-0x7f7fefff]
PM: Registered nosave memory: [mem 0x7f800000-0x7fffffff]
PM: Registered nosave memory: [mem 0x80000000-0x8fffffff]
PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
setup_percpu: NR_CPUS:8192 nr_cpumask_bits:24 nr_cpu_ids:24 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff88097f200000 s80448 r8192 d21952 u131072
pcpu-alloc: s80448 r8192 d21952 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
pcpu-alloc: [0] 16 17 18 19 20 21 22 23 -- -- -- -- -- -- -- -- 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 9303113
Policy zone: Normal
Kernel command line: ro root=UUID=03c50e18-696f-4559-915c-b9b2b4f8fadc rd_NO_LUKS rd_NO_LVM LANG=en_US.UTF-8 rd_NO_MD quiet SYSFONT=latarcyrheb-sun16 rhgb crashkernel=auto  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM console=tty0 console=ttyS1,115200 memtest numa=fake=4 sched_debug
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 37053728K/37736988K available (5559K kernel code, 1176K rwdata, 2688K rodata, 1816K init, 2408K bss, 683260K reserved)
Hierarchical RCU implementation.
	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=24.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=24
NR_IRQS:524544 nr_irqs:1280 16
Console: colour dummy device 80x25
console [tty0] enabled
console [ttyS1] enabled
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 3466.770 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 6933.54 BogoMIPS (lpj=3466770)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 6
Freeing SMP alternatives memory: 20K (ffffffff81cee000 - ffffffff81cf3000)
ACPI: Core revision 20131115
ACPI: All ACPI Tables successfully acquired
ftrace: allocating 24009 entries in 94 pages
Switched APIC routing to physical flat.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel(R) Xeon(R) CPU           X5690  @ 3.47GHz (fam: 06, model: 2c, stepping: 02)
Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
perf_event_intel: CPUID marked event: 'bus cycles' unavailable
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
x86: Booting SMP configuration:
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
.... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8  #9 #10 #11
x86: Booted up 1 node, 12 CPUs
smpboot: Total of 12 processors activated (83202.48 BogoMIPS)
CPU0 attaching sched-domain:
 domain 0: span 0,6 level SIBLING
  groups: 0 (cpu_power = 588) 6 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178)
CPU1 attaching sched-domain:
 domain 0: span 1,7 level SIBLING
  groups: 1 (cpu_power = 588) 7 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177)
CPU2 attaching sched-domain:
 domain 0: span 2,8 level SIBLING
  groups: 2 (cpu_power = 589) 8 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177)
CPU3 attaching sched-domain:
 domain 0: span 3,9 level SIBLING
  groups: 3 (cpu_power = 589) 9 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178)
CPU4 attaching sched-domain:
 domain 0: span 4,10 level SIBLING
  groups: 4 (cpu_power = 589) 10 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178)
CPU5 attaching sched-domain:
 domain 0: span 5,11 level SIBLING
  groups: 5 (cpu_power = 589) 11 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178)
CPU6 attaching sched-domain:
 domain 0: span 0,6 level SIBLING
  groups: 6 (cpu_power = 589) 0 (cpu_power = 588)
  domain 1: span 0-11 level MC
   groups: 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178)
CPU7 attaching sched-domain:
 domain 0: span 1,7 level SIBLING
  groups: 7 (cpu_power = 589) 1 (cpu_power = 588)
  domain 1: span 0-11 level MC
   groups: 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177)
CPU8 attaching sched-domain:
 domain 0: span 2,8 level SIBLING
  groups: 8 (cpu_power = 589) 2 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177)
CPU9 attaching sched-domain:
 domain 0: span 3,9 level SIBLING
  groups: 9 (cpu_power = 589) 3 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178)
CPU10 attaching sched-domain:
 domain 0: span 4,10 level SIBLING
  groups: 10 (cpu_power = 589) 4 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 4,10 (cpu_power = 1178) 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178)
CPU11 attaching sched-domain:
 domain 0: span 5,11 level SIBLING
  groups: 11 (cpu_power = 589) 5 (cpu_power = 589)
  domain 1: span 0-11 level MC
   groups: 5,11 (cpu_power = 1178) 0,6 (cpu_power = 1177) 1,7 (cpu_power = 1177) 2,8 (cpu_power = 1178) 3,9 (cpu_power = 1178) 4,10 (cpu_power = 1178)
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0x0006c000-0x0006cfff] (4096 bytes)
PM: Registering ACPI NVS region [mem 0x0009f000-0x0009ffff] (4096 bytes)
PM: Registering ACPI NVS region [mem 0x7f6df000-0x7f7defff] (1048576 bytes)
regulator-dummy: no parameters
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131115/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20131115/hwxface-580)
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME AER PCIeCapability]
acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
acpi PNP0A08:00: _OSC: platform willing to grant []
acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
acpi PNP0A08:00: host bridge window [0x7f00000000-0x7f00000000] (ignored, not CPU addressable)
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x90000000-0xfdffffff]
pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: System wakeup disabled by ACPI
pci 0000:00:02.0: [8086:3409] type 01 class 0x060400
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: System wakeup disabled by ACPI
pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: System wakeup disabled by ACPI
pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: System wakeup disabled by ACPI
pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
pci 0000:00:15.0: [8086:342f] type 00 class 0x080020
pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
pci 0000:00:16.0: reg 0x10: [mem 0x97a00000-0x97a03fff 64bit]
pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
pci 0000:00:16.1: reg 0x10: [mem 0x97a04000-0x97a07fff 64bit]
pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
pci 0000:00:16.2: reg 0x10: [mem 0x97a08000-0x97a0bfff 64bit]
pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
pci 0000:00:16.3: reg 0x10: [mem 0x97a0c000-0x97a0ffff 64bit]
pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
pci 0000:00:16.4: reg 0x10: [mem 0x97a10000-0x97a13fff 64bit]
pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
pci 0000:00:16.5: reg 0x10: [mem 0x97a14000-0x97a17fff 64bit]
pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
pci 0000:00:16.6: reg 0x10: [mem 0x97a18000-0x97a1bfff 64bit]
pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
pci 0000:00:16.7: reg 0x10: [mem 0x97a1c000-0x97a1ffff 64bit]
pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
pci 0000:00:1a.0: reg 0x20: [io  0x20a0-0x20bf]
pci 0000:00:1a.0: System wakeup disabled by ACPI
pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
pci 0000:00:1a.1: reg 0x20: [io  0x2080-0x209f]
pci 0000:00:1a.1: System wakeup disabled by ACPI
pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
pci 0000:00:1a.7: reg 0x10: [mem 0x97a21000-0x97a213ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: System wakeup disabled by ACPI
pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 0x20: [io  0x2060-0x207f]
pci 0000:00:1d.0: System wakeup disabled by ACPI
pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 0x20: [io  0x2040-0x205f]
pci 0000:00:1d.1: System wakeup disabled by ACPI
pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 0x20: [io  0x2020-0x203f]
pci 0000:00:1d.2: System wakeup disabled by ACPI
pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 0x10: [mem 0x97a20000-0x97a203ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: System wakeup disabled by ACPI
pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
pci 0000:00:1f.0: [8086:3a18] type 00 class 0x060100
pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
pci 0000:00:1f.2: reg 0x10: [io  0x2118-0x211f]
pci 0000:00:1f.2: reg 0x14: [io  0x212c-0x212f]
pci 0000:00:1f.2: reg 0x18: [io  0x2110-0x2117]
pci 0000:00:1f.2: reg 0x1c: [io  0x2128-0x212b]
pci 0000:00:1f.2: reg 0x20: [io  0x20f0-0x20ff]
pci 0000:00:1f.2: reg 0x24: [io  0x20e0-0x20ef]
pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 0x10: [mem 0x97a22000-0x97a220ff 64bit]
pci 0000:00:1f.3: reg 0x20: [io  0x2000-0x201f]
pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
pci 0000:00:1f.5: reg 0x10: [io  0x2108-0x210f]
pci 0000:00:1f.5: reg 0x14: [io  0x2124-0x2127]
pci 0000:00:1f.5: reg 0x18: [io  0x2100-0x2107]
pci 0000:00:1f.5: reg 0x1c: [io  0x2120-0x2123]
pci 0000:00:1f.5: reg 0x20: [io  0x20d0-0x20df]
pci 0000:00:1f.5: reg 0x24: [io  0x20c0-0x20cf]
pci 0000:0b:00.0: [14e4:1639] type 00 class 0x020000
pci 0000:0b:00.0: reg 0x10: [mem 0x92000000-0x93ffffff 64bit]
pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0b:00.1: [14e4:1639] type 00 class 0x020000
pci 0000:0b:00.1: reg 0x10: [mem 0x94000000-0x95ffffff 64bit]
pci 0000:0b:00.1: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PCI bridge to [bus 0b-0f]
pci 0000:00:01.0:   bridge window [mem 0x92000000-0x95ffffff]
pci 0000:00:02.0: PCI bridge to [bus 10-14]
pci 0000:00:03.0: PCI bridge to [bus 15-19]
pci 0000:00:05.0: PCI bridge to [bus 1a-1e]
pci 0000:00:07.0: PCI bridge to [bus 1f-23]
pci 0000:00:09.0: PCI bridge to [bus 24-28]
pci 0000:01:00.0: [1000:0079] type 00 class 0x010400
pci 0000:01:00.0: reg 0x10: [io  0x1000-0x10ff]
pci 0000:01:00.0: reg 0x14: [mem 0x97940000-0x97943fff 64bit]
pci 0000:01:00.0: reg 0x1c: [mem 0x97900000-0x9793ffff 64bit]
pci 0000:01:00.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:1c.0: PCI bridge to [bus 01-05]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0x97900000-0x979fffff]
pci 0000:06:00.0: [101b:0452] type 01 class 0x060400
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PCI bridge to [bus 06-0a]
pci 0000:00:1c.4:   bridge window [mem 0x97000000-0x978fffff]
pci 0000:00:1c.4:   bridge window [mem 0x96000000-0x96ffffff 64bit pref]
pci 0000:07:00.0: [102b:0530] type 00 class 0x030000
pci 0000:07:00.0: reg 0x10: [mem 0x96000000-0x96ffffff pref]
pci 0000:07:00.0: reg 0x14: [mem 0x97800000-0x97803fff]
pci 0000:07:00.0: reg 0x18: [mem 0x97000000-0x977fffff]
pci 0000:06:00.0: PCI bridge to [bus 07]
pci 0000:06:00.0:   bridge window [mem 0x97000000-0x978fffff]
pci 0000:06:00.0:   bridge window [mem 0x96000000-0x96ffffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 29-2d] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xfdffffff] (subtractive decode)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: \_SB_.PCI0: notify handler is installed
Found 1 acpi root devices
vgaarb: device added: PCI:0000:07:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:07:00.0
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: Discovered peer bus ff
PCI: root bus ff: using default resources
PCI: Probing PCI hardware (bus ff)
PCI host bridge to bus 0000:ff
pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000
pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000
pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000
pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000
pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000
pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000
pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000
pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000
pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000
pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000
pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000
pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000
pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000
pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000
pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000
pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000
pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000
pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000
pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000
pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000
pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000
pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000
pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000
pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000
pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0006c000-0x0006ffff]
e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
e820: reserve RAM buffer [mem 0x7d1b5000-0x7fffffff]
e820: reserve RAM buffer [mem 0x7d20b000-0x7fffffff]
e820: reserve RAM buffer [mem 0x7d60f000-0x7fffffff]
e820: reserve RAM buffer [mem 0x7f5ef000-0x7fffffff]
e820: reserve RAM buffer [mem 0x7f800000-0x7fffffff]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switched to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type PNP registered
pnp 00:00: [dma 4]
pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:04: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
system 00:05: [io  0x0400-0x043f] has been reserved
system 00:05: [io  0x0440-0x045f] has been reserved
system 00:05: [io  0x0460-0x047f] has been reserved
system 00:05: [io  0x0580-0x05ff] has been reserved
system 00:05: [io  0x05e0-0x05ff] has been reserved
system 00:05: [io  0x0cf9] could not be reserved
system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0c31 (active)
system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
system 00:09: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:09: [mem 0x80000000-0x8fffffff] has been reserved
system 00:09: [mem 0xffc00000-0xffffffff] has been reserved
system 00:09: [mem 0xfeb00000-0xfebfffff] has been reserved
system 00:09: [mem 0xfe710000-0xfe711fff] has been reserved
system 00:09: [mem 0xfe800000-0xfe9fffff] has been reserved
system 00:09: [mem 0xfc000000-0xfcffffff] has been reserved
system 00:09: [mem 0xfea00000-0xfeafffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:0a: [io  0x0ca0-0x0ca1] has been reserved
system 00:0a: [io  0x0ca4-0x0ca9] has been reserved
system 00:0a: [io  0x0caa-0x0cab] has been reserved
system 00:0a: [io  0x0cac-0x0ccb] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:0b: [io  0x0ca2] has been reserved
system 00:0b: [io  0x0ca3] has been reserved
system 00:0b: Plug and Play ACPI device, IDs IPI0001 PNP0c02 (active)
pnp: PnP ACPI: found 12 devices
ACPI: bus type PNP unregistered
pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
pci 0000:00:1c.0: bridge window [mem 0x00100000-0x001fffff pref] to [bus 01-05] add_size 200000
pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
pci 0000:00:1c.0: BAR 15: assigned [mem 0x90000000-0x902fffff pref]
pci 0000:00:01.0: PCI bridge to [bus 0b-0f]
pci 0000:00:01.0:   bridge window [mem 0x92000000-0x95ffffff]
pci 0000:00:02.0: PCI bridge to [bus 10-14]
pci 0000:00:03.0: PCI bridge to [bus 15-19]
pci 0000:00:05.0: PCI bridge to [bus 1a-1e]
pci 0000:00:07.0: PCI bridge to [bus 1f-23]
pci 0000:00:09.0: PCI bridge to [bus 24-28]
pci 0000:01:00.0: BAR 6: assigned [mem 0x90000000-0x9001ffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 01-05]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0x97900000-0x979fffff]
pci 0000:00:1c.0:   bridge window [mem 0x90000000-0x902fffff pref]
pci 0000:06:00.0: PCI bridge to [bus 07]
pci 0000:06:00.0:   bridge window [mem 0x97000000-0x978fffff]
pci 0000:06:00.0:   bridge window [mem 0x96000000-0x96ffffff pref]
pci 0000:00:1c.4: PCI bridge to [bus 06-0a]
pci 0000:00:1c.4:   bridge window [mem 0x97000000-0x978fffff]
pci 0000:00:1c.4:   bridge window [mem 0x96000000-0x96ffffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 29-2d]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x90000000-0xfdffffff]
pci_bus 0000:0b: resource 1 [mem 0x92000000-0x95ffffff]
pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:01: resource 1 [mem 0x97900000-0x979fffff]
pci_bus 0000:01: resource 2 [mem 0x90000000-0x902fffff pref]
pci_bus 0000:06: resource 1 [mem 0x97000000-0x978fffff]
pci_bus 0000:06: resource 2 [mem 0x96000000-0x96ffffff 64bit pref]
pci_bus 0000:07: resource 1 [mem 0x97000000-0x978fffff]
pci_bus 0000:07: resource 2 [mem 0x96000000-0x96ffffff pref]
pci_bus 0000:29: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:29: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:29: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:29: resource 7 [mem 0x90000000-0xfdffffff]
pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
NET: Registered protocol family 2
TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP: reno registered
UDP hash table entries: 32768 (order: 8, 1048576 bytes)
UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
NET: Registered protocol family 1
pci 0000:07:00.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 13836K (ffff8800797a8000 - ffff88007a52b000)
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0x757a8000-0x797a8000] (64MB) mapped at [ffff8800757a8000-ffff8800797a7fff]
futex hash table entries: 8192 (order: 7, 524288 bytes)
Initialise system trusted keyring
audit: initializing netlink socket (disabled)
type=2000 audit(1390368107.489:1): initialized
bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32768
SELinux:  Registering netfilter hooks
Key type asymmetric registered
Asymmetric key parser 'x509' registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: irq 64 for MSI/MSI-X
pcieport 0000:00:1c.4: irq 65 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
efifb: probing for efifb
efifb: framebuffer at 0x96000000, mapped to 0xffffc90016880000, using 10240k, total 16384k
efifb: mode is 1280x1024x32, linelength=5120, pages=1
efifb: scrolling: redraw
efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Console: switching to colour frame buffer device 160x64
fb0: EFI VGA frame buffer device
intel_idle: MWAIT substates: 0x1120
intel_idle: v0.4 model 0x2C
intel_idle: lapic_timer_reliable_states 0xffffffff
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
ERST: Can not request [mem 0x7f6f0000-0x7f6f1bff] for ERST.
GHES: HEST is not enabled!
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
00:07: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
tpm_tis 00:08: 1.2 TPM (device-id 0xFE, rev-id 70)
brd: module loaded
loop: module loaded
libphy: Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1a.7: EHCI Host Controller
ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:1a.7: debug port 1
ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
ehci-pci 0000:00:1a.7: irq 19, io mem 0x97a21000
ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.13.0+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci-pci 0000:00:1d.7: EHCI Host Controller
ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci-pci 0000:00:1d.7: debug port 1
ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
ehci-pci 0000:00:1d.7: irq 17, io mem 0x97a20000
ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.13.0+ ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 17, io base 0x000020a0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.13.0+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 18, io base 0x00002080
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.13.0+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 17, io base 0x00002060
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.13.0+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 18, io base 0x00002040
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.13.0+ uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 19, io base 0x00002020
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 3.13.0+ uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:01: RTC can wake from S4
rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
EFI Variables Facility v0.08 2004-May-17
tsc: Refined TSC clocksource calibration: 3466.785 MHz
usb 5-2: new full-speed USB device number 2 using uhci_hcd
usb 5-2: New USB device found, idVendor=04b3, idProduct=4010
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: RNDIS/CDC ETHER
usb 5-2: Manufacturer: IBM
pstore: Registered efi as persistent store backend
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
drop_monitor: Initializing network drop monitor service
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Loading compiled-in X.509 certificates
Loaded X.509 cert 'Magrathea: Glacier signing key: d0bc4d0cc3cd461d964d736982ef99e234f63db3'
registered taskstats version 1
rtc_cmos 00:01: setting system clock to 2014-01-22 05:21:49 UTC (1390368109)
Freeing unused kernel memory: 1816K (ffffffff81b28000 - ffffffff81cee000)
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 572K (ffff880001571000 - ffff880001600000)
Freeing unused kernel memory: 1408K (ffff8800018a0000 - ffff880001a00000)
dracut: dracut-018-60.git20120927.fc16
udevd[149]: starting version 173
dracut: Starting plymouth daemon
ata_piix 0000:00:1f.2: version 2.13
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x2118 ctl 0x212c bmdma 0x20f0 irq 16
ata2: SATA max UDMA/133 cmd 0x2110 ctl 0x2128 bmdma 0x20f8 irq 16
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
scsi2 : ata_piix
scsi3 : ata_piix
megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
ata3: SATA max UDMA/133 cmd 0x2108 ctl 0x2124 bmdma 0x20d0 irq 21
ata4: SATA max UDMA/133 cmd 0x2100 ctl 0x2120 bmdma 0x20d8 irq 21
megasas: 0x1000:0x0079:0x1014:0x03b2: bus 1:slot 0:func 0
megasas: FW now in Ready state
megaraid_sas 0000:01:00.0: irq 66 for MSI/MSI-X
megaraid_sas 0000:01:00.0: [scsi4]: FW supports<0> MSIX vector,Online CPUs: <12>,Current MSIX <1>
megasas_init_mfi: fw_support_ieee=0
megasas: INIT adapter done
megaraid_sas 0000:01:00.0: Controller type: MR,Memory size is: 512MB
scsi4 : LSI SAS based MegaRAID driver
scsi 4:0:10:0: Direct-Access     IBM-ESXS ST9600204SS      B548 PQ: 0 ANSI: 5
scsi 4:0:11:0: Direct-Access     IBM-ESXS ST9600204SS      B548 PQ: 0 ANSI: 5
scsi 4:0:12:0: Direct-Access     IBM-ESXS ST9600204SS      B548 PQ: 0 ANSI: 5
scsi 4:2:0:0: Direct-Access     IBM      ServeRAID M5015  2.12 PQ: 0 ANSI: 5
Switched to clocksource tsc
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata2.00: SATA link down (SStatus 0 SControl 300)
ata2.01: SATA link down (SStatus 0 SControl 300)
ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.01: SATA link down (SStatus 0 SControl 300)
ata1.01: link offline, clearing class 3 to NONE
ata1.00: ATAPI: MATSHITADVD-RAM UJ8A0, SA82, max UDMA/100
ata1.00: configured for UDMA/100
scsi 0:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ8A0    SA82 PQ: 0 ANSI: 5
sd 4:2:0:0: [sda] 3509760000 512-byte logical blocks: (1.79 TB/1.63 TiB)
sd 4:2:0:0: [sda] Write Protect is off
sd 4:2:0:0: [sda] Mode Sense: 1f 00 00 08
sd 4:2:0:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
 sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 sda16 sda17 sda18
sd 4:2:0:0: [sda] Attached SCSI disk
random: nonblocking pool is initialized
EXT3-fs (sda6): recovery required on readonly filesystem
EXT3-fs (sda6): write access will be enabled during recovery
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda6): orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 1030208
ext3_orphan_cleanup: deleting unreferenced inode 1030179
ext3_orphan_cleanup: deleting unreferenced inode 1030175
ext3_orphan_cleanup: deleting unreferenced inode 1264894
ext3_orphan_cleanup: deleting unreferenced inode 1264965
ext3_orphan_cleanup: deleting unreferenced inode 1264973
ext3_orphan_cleanup: deleting unreferenced inode 1215902
ext3_orphan_cleanup: deleting unreferenced inode 1216036
EXT3-fs (sda6): 8 orphan inodes deleted
EXT3-fs (sda6): recovery complete
EXT3-fs (sda6): mounted filesystem with ordered data mode
dracut: Checking ext3: /dev/disk/by-uuid/03c50e18-696f-4559-915c-b9b2b4f8fadc
dracut: issuing e2fsck -a  /dev/disk/by-uuid/03c50e18-696f-4559-915c-b9b2b4f8fadc
dracut: /dev/disk/by-uuid/03c50e18-696f-4559-915c-b9b2b4f8fadc: clean, 506479/1281120 files, 3685876/5120000 blocks
dracut: Remounting /dev/disk/by-uuid/03c50e18-696f-4559-915c-b9b2b4f8fadc with -o ro
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda6): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/sda6
dracut: Switching root
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1390368112.175:2): selinux=0 auid=4294967295 ses=4294967295
systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
NET: Registered protocol family 10
systemd[1]: Set hostname to <localhost.localdomain>.
systemd-readahead-replay[485]: Bumped block_nr parameter of 8:0 to 16384. This is a temporary hack and should be removed one day.
systemd-readahead-collect[486]: Failed to create fanotify object: Function not implemented
systemd[1]: systemd-readahead-collect.service: main process exited, code=exited, status=1
udevd[497]: starting version 173
EXT3-fs (sda6): using internal journal
sd 4:2:0:0: Attached scsi generic sg0 type 0
sr 0:0:0:0: Attached scsi generic sg1 type 5
input: PC Speaker as /devices/platform/pcspkr/input/input3
microcode: CPU0 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU1 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU2 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU3 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU4 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU5 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU6 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU7 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU8 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU9 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU10 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: CPU11 sig=0x206c2, pf=0x1, revision=0x14
platform microcode: Direct firmware load failed with error -2
platform microcode: Falling back to user helper
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
EDAC MC: Ver: 3.0.0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
dca service started, version 1.12.1
ipmi message handler version 39.2
IPMI System Interface driver.
ipmi_si: probing via SMBIOS
ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
ipmi_si: Adding SMBIOS-specified kcs state machine
ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
i801_smbus 0000:00:1f.3: enabling device (0140 -> 0143)
i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
ioatdma: Intel(R) QuickData Technology Driver 4.00
ioatdma 0000:00:16.0: enabling device (0000 -> 0002)
ioatdma 0000:00:16.0: irq 67 for MSI/MSI-X
ioatdma 0000:00:16.1: enabling device (0000 -> 0002)
ioatdma 0000:00:16.1: irq 68 for MSI/MSI-X
ioatdma 0000:00:16.2: enabling device (0000 -> 0002)
ioatdma 0000:00:16.2: irq 69 for MSI/MSI-X
ioatdma 0000:00:16.3: enabling device (0000 -> 0002)
ioatdma 0000:00:16.3: irq 70 for MSI/MSI-X
ioatdma 0000:00:16.4: enabling device (0000 -> 0002)
ioatdma 0000:00:16.4: irq 71 for MSI/MSI-X
ioatdma 0000:00:16.5: enabling device (0000 -> 0002)
ioatdma 0000:00:16.5: irq 72 for MSI/MSI-X
ioatdma 0000:00:16.6: enabling device (0000 -> 0002)
ioatdma 0000:00:16.6: irq 73 for MSI/MSI-X
ioatdma 0000:00:16.7: enabling device (0000 -> 0002)
ioatdma 0000:00:16.7: irq 74 for MSI/MSI-X
kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.2.4 (Aug 05, 2013)
bnx2 0000:0b:00.0 eth0: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem 92000000, IRQ 28, node addr 5c:f3:fc:e7:46:f4
bnx2 0000:0b:00.1 eth1: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem 94000000, IRQ 40, node addr 5c:f3:fc:e7:46:f6
EDAC MC0: Giving out device to module i7core_edac.c controller i7 core #0: DEV 0000:ff:03.0 (POLLED)
EDAC PCI0: Giving out device to module i7core_edac controller EDAC PCI controller: DEV 0000:ff:03.0 (POLLED)
EDAC i7core: Driver loaded, 1 memory controller(s) found.
ACPI Warning: 0x00000000000005a8-0x00000000000005af SystemIO conflicts with Region \_SB_.PCI0.LPC0.GPE0 1 (20131115/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
ACPI Warning: 0x0000000000000430-0x000000000000043f SystemIO conflicts with Region \_SB_.PCI0.RIL_ 1 (20131115/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
ACPI Warning: 0x0000000000000400-0x000000000000042f SystemIO conflicts with Region \_SB_.PCI0.RIT_ 1 (20131115/utaddress-251)
ACPI Warning: 0x0000000000000400-0x000000000000042f SystemIO conflicts with Region \_SB_.PCI0.RTY_ 2 (20131115/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
lpc_ich: Resource conflict(s) found affecting gpio_ich
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
iTCO_wdt: Found a ICH10 TCO device (Version=2, TCOBASE=0x05e0)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ipmi_si ipmi_si.0: Found new BMC (man_id: 0x000002, prod_id: 0x00dc, dev_id: 0x20)
ipmi_si ipmi_si.0: IPMI kcs interface initialized
cdc_ether 5-2:1.0 usb0: register 'cdc_ether' at usb-0000:00:1d.0-2, CDC Ethernet Device, 5e:f3:fc:df:46:f7
usbcore: registered new interface driver cdc_ether
Adding 36863996k swap on /dev/sda3.  Priority:0 extents:1 across:36863996k 
md: bind<sda16>
md: raid1 personality registered for level 1
md/raid1:md0: active with 1 out of 2 mirrors
created bitmap (1 pages) for device md0
md0: bitmap initialized from disk: read 1 pages, set 0 of 149 bits
md0: detected capacity change from 0 to 9998098432
 md0: unknown partition table
rmmod[1008]: ERROR: Module scsi_wait_scan does not exist in /proc/modules
modprobe[1011]: FATAL: Module scsi_wait_scan not found.
rmmod[1013]: ERROR: Module scsi_wait_scan does not exist in /proc/modules
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
systemd-fsck[999]: /dev/sda5: recovering journal
systemd-fsck[999]: /dev/sda5: clean, 16/1281120 files, 3862030/5120000 blocks
bio: create slab <bio-1> at 1
fedora-storage-init[1016]: Setting up Logical Volume Management:   3 logical volume(s) in volume group "vg_labserver" now active
fedora-storage-init[1016]: [  OK  ]
systemd-fsck[987]: /dev/sda12: recovering journal
systemd-fsck[987]: /dev/sda12: clean, 66673/18317312 files, 48832514/73242112 blocks
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda12): using internal journal
EXT3-fs (sda12): mounted filesystem with ordered data mode
systemd-fsck[1007]: /dev/sda8: recovering journal
systemd-fsck[1007]: /dev/sda8: clean, 287015/2564096 files, 7795421/10240000 blocks
EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
systemd-fsck[1076]: /dev/sda2: recovering journal
systemd-fsck[1076]: /dev/sda2: clean, 571/320000 files, 501678/1280000 blocks
fedora-storage-init[1059]: Setting up Logical Volume Management:   3 logical volume(s) in volume group "vg_labserver" now active
fedora-storage-init[1059]: [  OK  ]
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
lvm[1096]: 3 logical volume(s) in volume group "vg_labserver" monitored
avahi-daemon[1114]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
avahi-daemon[1114]: Successfully dropped root privileges.
avahi-daemon[1114]: avahi-daemon 0.6.30 starting up.
avahi-daemon[1114]: WARNING: No NSS support for mDNS detected, consider installing nss-mdns!
auditctl[1118]: No rules
auditctl[1118]: AUDIT_STATUS: enabled=0 flag=1 pid=0 rate_limit=0 backlog_limit=320 lost=0 backlog=0
auditd[1117]: Started dispatcher: /sbin/audispd pid: 1125
audispd[1125]: priority_boost_parser called with: 4
audispd[1125]: max_restarts_parser called with: 10
audispd[1125]: No plugins found, exiting
abrtd[1119]: Init complete, entering main loop
auditd[1117]: Init complete, auditd 2.1.3 listening for events (startup state enable)
/usr/sbin/gpm[1175]: *** info [daemon/startup.c(136)]:
/usr/sbin/gpm[1175]: Started gpm successfully. Entered daemon mode.
NetworkManager[1196]: <info> NetworkManager (version 0.9.1.90-5.git20110927.fc16) is starting...
NetworkManager[1196]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
NetworkManager[1196]: NetworkManager[1196]: <info> NetworkManager (version 0.9.1.90-5.git20110927.fc16) is starting...
NetworkManager[1196]: NetworkManager[1196]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
acpid[1204]: starting up with netlink and the input layer
acpid[1204]: skipping incomplete file /etc/acpi/events/videoconf
acpid[1204]: 1 rule loaded
acpid[1204]: waiting for events: event logging is off
chronyd[1208]: chronyd version 1.26-20110831gitb088b7 starting
chronyd[1208]: Linux kernel major=3 minor=13 patch=0
chronyd[1208]: hz=100 shift_hz=7 freq_scale=1.00000000 nominal_tick=10000 slew_delta_tick=833 max_tick_bias=1000
mcelog[1206]: mcelog: Unsupported new Family 6 Model 2c CPU: only decoding architectural errors
chronyd[1208]: Frequency -9.249 +- 0.917 ppm read from /var/lib/chrony/drift
avahi-daemon[1114]: Successfully called chroot().
avahi-daemon[1114]: Successfully dropped remaining capabilities.
avahi-daemon[1114]: Loading service file /services/ssh.service.
avahi-daemon[1114]: Loading service file /services/udisks.service.
avahi-daemon[1114]: System host name is set to 'localhost'. This is not a suitable mDNS host name, looking for alternatives.
systemd-logind[1197]: New seat seat0.
avahi-daemon[1114]: Network interface enumeration completed.
avahi-daemon[1114]: Registering HINFO record with values 'X86_64'/'LINUX'.
avahi-daemon[1114]: Server startup complete. Host name is linux.local. Local service cookie is 1448239152.
avahi-daemon[1114]: Service "linux" (/services/udisks.service) successfully established.
avahi-daemon[1114]: Service "linux" (/services/ssh.service) successfully established.
/usr/sbin/crond[1216]: (CRON) INFO (running with inotify support)
NetworkManager[1196]: <info> VPN: loaded org.freedesktop.NetworkManager.openconnect
NetworkManager[1196]: <info> VPN: loaded org.freedesktop.NetworkManager.pptp
NetworkManager[1196]: NetworkManager[1196]: <info> VPN: loaded org.freedesktop.NetworkManager.openconnect
NetworkManager[1196]: NetworkManager[1196]: <info> VPN: loaded org.freedesktop.NetworkManager.pptp
NetworkManager[1196]: <info> VPN: loaded org.freedesktop.NetworkManager.vpnc
NetworkManager[1196]: NetworkManager[1196]: <info> VPN: loaded org.freedesktop.NetworkManager.vpnc
NetworkManager[1196]: <info> VPN: loaded org.freedesktop.NetworkManager.openvpn
NetworkManager[1196]: NetworkManager[1196]: <info> VPN: loaded org.freedesktop.NetworkManager.openvpn
dbus[1219]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
dbus-daemon[1219]: dbus[1219]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
polkitd[1227]: started daemon version 0.102 using authority implementation `local' version `0.102'
dbus[1219]: [system] Successfully activated service 'org.freedesktop.PolicyKit1'
dbus-daemon[1219]: dbus[1219]: [system] Successfully activated service 'org.freedesktop.PolicyKit1'
NetworkManager[1196]: ifcfg-rh: Acquired D-Bus service com.redhat.ifcfgrh1
NetworkManager[1196]: <info> Loaded plugin ifcfg-rh: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
NetworkManager[1196]: NetworkManager[1196]:    ifcfg-rh: Acquired D-Bus service com.redhat.ifcfgrh1
NetworkManager[1196]: NetworkManager[1196]: <info> Loaded plugin ifcfg-rh: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
NetworkManager[1196]: <info> Loaded plugin keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
NetworkManager[1196]: NetworkManager[1196]: <info> Loaded plugin keyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the NetworkManager mailing list.
NetworkManager[1196]: ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-eth0 ...
NetworkManager[1196]: NetworkManager[1196]:    ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-eth0 ...
NetworkManager[1196]: ifcfg-rh:     read connection 'System eth0'
NetworkManager[1196]: ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-eth1 ...
NetworkManager[1196]: NetworkManager[1196]:    ifcfg-rh:     read connection 'System eth0'
NetworkManager[1196]: NetworkManager[1196]:    ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-eth1 ...
NetworkManager[1196]: ifcfg-rh:     read connection 'System eth1'
NetworkManager[1196]: ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-lo ...
NetworkManager[1196]: ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-usb0 ...
NetworkManager[1196]: NetworkManager[1196]:    ifcfg-rh:     read connection 'System eth1'
NetworkManager[1196]: NetworkManager[1196]:    ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-lo ...
NetworkManager[1196]: NetworkManager[1196]:    ifcfg-rh: parsing /etc/sysconfig/network-scripts/ifcfg-usb0 ...
NetworkManager[1196]: ifcfg-rh:     read connection 'System usb0'
NetworkManager[1196]: NetworkManager[1196]:    ifcfg-rh:     read connection 'System usb0'
NetworkManager[1196]: <info> trying to start the modem manager...
NetworkManager[1196]: NetworkManager[1196]: <info> trying to start the modem manager...
NetworkManager[1196]: <info> monitoring kernel firmware directory '/lib/firmware'.
dbus[1219]: [system] Activating service name='org.freedesktop.ModemManager' (using servicehelper)
NetworkManager[1196]: NetworkManager[1196]: <info> monitoring kernel firmware directory '/lib/firmware'.
dbus-daemon[1219]: dbus[1219]: [system] Activating service name='org.freedesktop.ModemManager' (using servicehelper)
dbus[1219]: [system] Activating systemd to hand-off: service name='org.bluez' unit='dbus-org.bluez.service'
dbus-daemon[1219]: dbus[1219]: [system] Activating systemd to hand-off: service name='org.bluez' unit='dbus-org.bluez.service'
NetworkManager[1196]: <info> WiFi enabled by radio killswitch; enabled by state file
NetworkManager[1196]: <info> WWAN enabled by radio killswitch; enabled by state file
NetworkManager[1196]: <info> WiMAX enabled by radio killswitch; enabled by state file
NetworkManager[1196]: <info> Networking is enabled by state file
NetworkManager[1196]: NetworkManager[1196]: <info> WiFi enabled by radio killswitch; enabled by state file
NetworkManager[1196]: NetworkManager[1196]: <info> WWAN enabled by radio killswitch; enabled by state file
NetworkManager[1196]: NetworkManager[1196]: <info> WiMAX enabled by radio killswitch; enabled by state file
NetworkManager[1196]: NetworkManager[1196]: <info> Networking is enabled by state file
modem-manager[1233]: <info>  ModemManager (version 0.4.998-1.git20110706.fc16) starting...
NetworkManager[1196]: <info> (eth0): carrier is OFF
dbus-daemon[1219]: modem-manager[1233]: <info>  ModemManager (version 0.4.998-1.git20110706.fc16) starting...
NetworkManager[1196]: NetworkManager[1196]: <info> (eth0): carrier is OFF
NetworkManager[1196]: <info> (eth0): new Ethernet device (driver: 'bnx2' ifindex: 2)
NetworkManager[1196]: NetworkManager[1196]: <info> (eth0): new Ethernet device (driver: 'bnx2' ifindex: 2)
NetworkManager[1196]: <info> (eth0): exported as /org/freedesktop/NetworkManager/Devices/0
NetworkManager[1196]: NetworkManager[1196]: <info> (eth0): exported as /org/freedesktop/NetworkManager/Devices/0
NetworkManager[1196]: <info> (eth0): now managed
NetworkManager[1196]: NetworkManager[1196]: <info> (eth0): now managed
NetworkManager[1196]: <info> (eth0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
NetworkManager[1196]: NetworkManager[1196]: <info> (eth0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
NetworkManager[1196]: <info> (eth0): bringing up device.
NetworkManager[1196]: NetworkManager[1196]: <info> (eth0): bringing up device.
dbus[1219]: [system] Successfully activated service 'org.freedesktop.ModemManager'
dbus-daemon[1219]: dbus[1219]: [system] Successfully activated service 'org.freedesktop.ModemManager'
modem-manager[1233]: <info>  Loaded plugin MotoC
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin MotoC
modem-manager[1233]: <info>  Loaded plugin X22X
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin X22X
modem-manager[1233]: <info>  Loaded plugin Option
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Option
modem-manager[1233]: <info>  Loaded plugin Linktop
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Linktop
modem-manager[1233]: <info>  Loaded plugin Generic
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Generic
modem-manager[1233]: <info>  Loaded plugin Samsung
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Samsung
modem-manager[1233]: <info>  Loaded plugin Option High-Speed
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Option High-Speed
modem-manager[1233]: <info>  Loaded plugin Sierra
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Sierra
modem-manager[1233]: <info>  Loaded plugin Wavecom
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Wavecom
modem-manager[1233]: <info>  Loaded plugin Longcheer
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Longcheer
modem-manager[1233]: <info>  Loaded plugin ZTE
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin ZTE
modem-manager[1233]: <info>  Loaded plugin Gobi
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Gobi
modem-manager[1233]: <info>  Loaded plugin Ericsson MBM
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Ericsson MBM
modem-manager[1233]: <info>  Loaded plugin Nokia
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Nokia
modem-manager[1233]: <info>  Loaded plugin Huawei
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Huawei
modem-manager[1233]: <info>  Loaded plugin SimTech
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin SimTech
modem-manager[1233]: <info>  Loaded plugin Novatel
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin Novatel
modem-manager[1233]: <info>  Loaded plugin AnyData
dbus-daemon[1219]: modem-manager[1233]: <info>  Loaded plugin AnyData
bnx2 0000:0b:00.0: irq 75 for MSI/MSI-X
bnx2 0000:0b:00.0: irq 76 for MSI/MSI-X
bnx2 0000:0b:00.0: irq 77 for MSI/MSI-X
bnx2 0000:0b:00.0: irq 78 for MSI/MSI-X
bnx2 0000:0b:00.0: irq 79 for MSI/MSI-X
bnx2 0000:0b:00.0: irq 80 for MSI/MSI-X
bnx2 0000:0b:00.0: irq 81 for MSI/MSI-X
bnx2 0000:0b:00.0: irq 82 for MSI/MSI-X
bnx2 0000:0b:00.0: irq 83 for MSI/MSI-X
dbus[1219]: [system] Successfully activated service 'org.freedesktop.systemd1'
dbus-daemon[1219]: dbus[1219]: [system] Successfully activated service 'org.freedesktop.systemd1'
bnx2 0000:0b:00.0 eth0: using MSIX
IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
bnx2 0000:0b:00.1: irq 84 for MSI/MSI-X
bnx2 0000:0b:00.1: irq 85 for MSI/MSI-X
bnx2 0000:0b:00.1: irq 86 for MSI/MSI-X
bnx2 0000:0b:00.1: irq 87 for MSI/MSI-X
bnx2 0000:0b:00.1: irq 88 for MSI/MSI-X
bnx2 0000:0b:00.1: irq 89 for MSI/MSI-X
bnx2 0000:0b:00.1: irq 90 for MSI/MSI-X
bnx2 0000:0b:00.1: irq 91 for MSI/MSI-X
bnx2 0000:0b:00.1: irq 92 for MSI/MSI-X
bnx2 0000:0b:00.1 eth1: using MSIX
IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
pci 0000:07:00.0: Invalid ROM contents
pci 0000:07:00.0: Invalid ROM contents
pci 0000:07:00.0: Invalid ROM contents
pci 0000:07:00.0: Invalid ROM contents
pci 0000:07:00.0: Invalid ROM contents
pci 0000:07:00.0: Invalid ROM contents
pci 0000:07:00.0: Invalid ROM contents
pci 0000:07:00.0: Invalid ROM contents
pci 0000:07:00.0: Invalid ROM contents
Bridge firewalling registered
device virbr0-nic entered promiscuous mode
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
device virbr0-nic left promiscuous mode
virbr0: port 1(virbr0-nic) entered disabled state
Ebtables v2.0 registered
ip6_tables: (C) 2000-2006 Netfilter Core Team
bnx2 0000:0b:00.0 eth0: NIC Copper Link is Up, 100 Mbps full duplex
, receive & transmit flow control ON
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
EXT4-fs (sda11): warning: maximal mount count reached, running e2fsck is recommended
EXT4-fs (sda11): recovery complete
EXT4-fs (sda11): mounted filesystem with ordered data mode. Opts: (null)
md0: detected capacity change from 9998098432 to 0
md: md0 stopped.
md: unbind<sda16>
md: export_rdev(sda16)
fuse init (API version 7.22)
EXT4-fs (sda13): mounted filesystem with ordered data mode. Opts: (null)
device tap1 entered promiscuous mode
device tap2 entered promiscuous mode
device tap3 entered promiscuous mode
device tap4 entered promiscuous mode
device tap5 entered promiscuous mode
device tap6 entered promiscuous mode
device tap7 entered promiscuous mode
IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
IPv6: ADDRCONF(NETDEV_UP): tap1: link is not ready
IPv6: ADDRCONF(NETDEV_UP): tap2: link is not ready
br0: port 2(tap2) entered forwarding state
br0: port 2(tap2) entered forwarding state
IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
IPv6: ADDRCONF(NETDEV_UP): tap3: link is not ready
br0: port 3(tap3) entered forwarding state
br0: port 3(tap3) entered forwarding state
IPv6: ADDRCONF(NETDEV_UP): tap4: link is not ready
br0: port 4(tap4) entered forwarding state
br0: port 4(tap4) entered forwarding state
IPv6: ADDRCONF(NETDEV_UP): tap5: link is not ready
br0: port 5(tap5) entered forwarding state
br0: port 5(tap5) entered forwarding state
IPv6: ADDRCONF(NETDEV_UP): tap6: link is not ready
br0: port 6(tap6) entered forwarding state
br0: port 6(tap6) entered forwarding state
IPv6: ADDRCONF(NETDEV_UP): tap7: link is not ready
br0: port 7(tap7) entered forwarding state
br0: port 7(tap7) entered forwarding state
br0: port 2(tap2) entered disabled state
br0: port 3(tap3) entered disabled state
br0: port 4(tap4) entered disabled state
br0: port 5(tap5) entered disabled state
br0: port 6(tap6) entered disabled state
br0: port 7(tap7) entered disabled state
IPv6: ADDRCONF(NETDEV_CHANGE): tap1: link becomes ready
br0: port 1(tap1) entered forwarding state
br0: port 1(tap1) entered forwarding state
br0: port 1(tap1) entered forwarding state
BUG: soft lockup - CPU#4 stuck for 22s! [qemu-kvm:2590]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 4 PID: 2590 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809358d84d0 ti: ffff88007ecf0000 task.ti: ffff88007ecf0000
RIP: 0010:[<ffffffffa083ffc4>]  [<ffffffffa083ffc4>] kvm_apic_has_interrupt+0xb4/0x110 [kvm]
RSP: 0018:ffff88007ecf1ce8  EFLAGS: 00000202
RAX: 00000000000000ef RBX: ffffffffffffff10 RCX: 00000000ffffffff
RDX: 0000000000008000 RSI: ffff88007f20f000 RDI: 000000000000000f
RBP: ffff88007ecf1cf8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff8802121abfd8 R12: 00000000800000ef
R13: 0000000000004016 R14: 0000000000000000 R15: 00000000800000ef
FS:  00007f0ac77fe700(0000) GS:ffff88097f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff88007ecf1cf8 ffff880079aac080 ffff88007ecf1d18 ffffffffa083d67e
 ffff88007ecf1fd8 ffff880079aac080 ffff88007ecf1da8 ffffffffa0825b25
 ffff8802121abfd8 000000ef00000001 00000000800000ef ffff88093145e180
Call Trace:
 [<ffffffffa083d67e>] kvm_cpu_has_injectable_intr+0x5e/0x80 [kvm]
 [<ffffffffa0825b25>] vcpu_enter_guest+0x595/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 63 d2 8b 14 11 85 d2 75 16 83 e8 20 83 f8 e0 75 e6 b0 ff 48 83 c4 08 5b 5d c3 0f 1f 44 00 00 b9 ff ff ff ff 89 cf 0f bd fa 01 f8 <39> c8 74 e4 89 c2 81 e2 f0 00 00 00 3b 96 a0 00 00 00 0f 46 c1 
BUG: soft lockup - CPU#5 stuck for 22s! [qemu-kvm:2591]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 5 PID: 2591 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809546f4110 ti: ffff880935a34000 task.ti: ffff880935a34000
RIP: 0010:[<ffffffffa08258f6>]  [<ffffffffa08258f6>] vcpu_enter_guest+0x366/0x7e0 [kvm]
RSP: 0018:ffff880935a35d28  EFLAGS: 00000246
RAX: ffffffffa0993ea0 RBX: ffff88093157c0c0 RCX: 0000000000000000
RDX: 000000000000401c RSI: 0000000000000000 RDI: ffff8809359c0000
RBP: ffff880935a35da8 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffa097e2a5
R13: ffff880935a35cc8 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f0ac6ffd700(0000) GS:ffff88097f2a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 0000000000000001 000000ef00000001 00000000800000fd ffff88093145e280
 ffff8809359c0040 0000000000000001 ffff880935a35fd8 ffff8809546f4110
 ffff880935a35d78 ffffffffa083fdb1 ffff880935a35d98 ffff88093157c0c0
Call Trace:
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 74 23 44 8b 73 78 45 85 f6 75 1a 48 8b 83 78 08 00 00 31 c9 48 89 c2 48 c1 ea 20 0f 01 d1 c7 43 78 01 00 00 00 48 8b 3b 8b 73 28 <c7> 43 2c 01 00 00 00 48 83 c7 40 e8 ba 37 88 e0 fa 83 7b 2c 02 
BUG: soft lockup - CPU#6 stuck for 22s! [qemu-kvm:2592]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 6 PID: 2592 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff88093157a450 ti: ffff880954d4e000 task.ti: ffff880954d4e000
RIP: 0010:[<ffffffffa080bc15>]  [<ffffffffa080bc15>] kvm_resched+0x5/0x30 [kvm]
RSP: 0018:ffff880954d4fdb0  EFLAGS: 00000246
RAX: 000060f680800ee0 RBX: 000000ef00000001 RCX: ffff880931576000
RDX: ffff88093145e380 RSI: 000060f680800ee0 RDI: ffff88093592c100
RBP: ffff880954d4fdf8 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa0825aaf
R13: ffff880954d4fda8 R14: ffffffffa097d774 R15: ffff880954d4fd18
FS:  00007f0ac67fc700(0000) GS:ffff88097f2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa0825f8e ffff880954d4fdd8 ffff88093592c130 ffff88093592c100
 ffff88093592c100 0000000000000000 ffff880954891000 0000000000000000
 0000000000000000 ffff880954d4fe38 ffffffffa082603d ffff88093592c100
Call Trace:
 [<ffffffffa0825f8e>] ? __vcpu_run+0x21e/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 7a 08 48 39 ce 73 a7 bb a1 ff ff ff 89 d8 5b 41 5c 41 5d 41 5e 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 <55> 65 48 8b 04 25 b0 b8 00 00 48 8b 80 38 e0 ff ff 48 89 e5 a8 
BUG: soft lockup - CPU#7 stuck for 22s! [qemu-kvm:2589]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 7 PID: 2589 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933bfce00 ti: ffff880079bbe000 task.ti: ffff880079bbe000
RIP: 0010:[<ffffffffa0825f8e>]  [<ffffffffa0825f8e>] __vcpu_run+0x21e/0x230 [kvm]
RSP: 0018:ffff880079bbfdb8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 000000ef00000001 RCX: ffff88007ec2a000
RDX: ffff88093145e080 RSI: 000060f680800ee0 RDI: ffff880079aa8040
RBP: ffff880079bbfdf8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa0825aaf
R13: ffff880079bbfda8 R14: ffffffffa097d774 R15: ffff880079bbfd18
FS:  00007f0ac7fff700(0000) GS:ffff88097f2e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880079bbfdd8 ffff880079aa8070 ffff880079aa8040 ffff880079aa8040
 0000000000000000 ffff88007a374000 0000000000000000 0000000000000000
 ffff880079bbfe38 ffffffffa082603d ffff880079aa8040 fffffffe7ffbfeff
Call Trace:
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: bd fc ff ff ff c7 40 08 0a 00 00 00 83 83 cc 00 00 00 01 e9 68 fe ff ff 8b 73 28 4c 89 e7 e8 3a 31 88 e0 48 89 df e8 82 5c fe ff <4c> 89 e7 e8 da 30 88 e0 89 43 28 e9 54 fe ff ff 66 90 66 66 66 
BUG: soft lockup - CPU#10 stuck for 23s! [qemu-kvm:2593]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 10 PID: 2593 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880954f9af40 ti: ffff880931674000 task.ti: ffff880931674000
RIP: 0010:[<ffffffffa081aa45>]  [<ffffffffa081aa45>] inject_pending_event+0x15/0x1b0 [kvm]
RSP: 0018:ffff880931675cd8  EFLAGS: 00000286
RAX: 0000000000000001 RBX: ffffffffffffff10 RCX: 0000000000000002
RDX: ffffe8ffffb40ee0 RSI: 000000000bdb7aa9 RDI: ffff880931668040
RBP: ffff880931675d18 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212217fd8 R12: 00000000800000ef
R13: 0000000000004016 R14: 0000000000000002 R15: 00000000800000ef
FS:  00007f0ac5ffb700(0000) GS:ffff88097f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880931675cf8 ffffffffa083f131 ffff880931675cf8 ffff880931668040
 0000000000000000 0000000000000000 ffff880931668040 0000000000000000
 ffff880931675da8 ffffffffa0825814 ffff880931675df8 000000ef00000001
Call Trace:
 [<ffffffffa083f131>] ? kvm_lapic_find_highest_irr+0x41/0xa0 [kvm]
 [<ffffffffa0825814>] vcpu_enter_guest+0x284/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 19 52 04 00 01 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 48 83 ec 40 48 89 5d d8 4c 89 65 e0 <48> 89 fb 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 80 bf b4 08 00 00 
BUG: soft lockup - CPU#4 stuck for 23s! [qemu-kvm:2590]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 4 PID: 2590 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809358d84d0 ti: ffff88007ecf0000 task.ti: ffff88007ecf0000
RIP: 0010:[<ffffffffa081aa30>]  [<ffffffffa081aa30>] inject_pending_event+0x0/0x1b0 [kvm]
RSP: 0018:ffff88007ecf1d20  EFLAGS: 00000293
RAX: 0000000000000001 RBX: ffff880079aac080 RCX: 0000000000000002
RDX: ffffe8ffffa80ee0 RSI: 000000001c692250 RDI: ffff880079aac080
RBP: ffff88007ecf1da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff8802121abfd8 R12: ffffffffa097e2a5
R13: ffff88007ecf1cc8 R14: 0000000000000000 R15: 00000000800000ef
FS:  00007f0ac77fe700(0000) GS:ffff88097f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa0825814 ffff8802121abfd8 000000ef00000001 00000000800000ef
 ffff88093145e180 ffff8809359c0040 0000000000000001 ffff88007ecf1fd8
 ffff8809358d84d0 ffff88007ecf1d78 ffffffffa083fdb1 ffff88007ecf1d98
Call Trace:
 [<ffffffffa0825814>] ? vcpu_enter_guest+0x284/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 8d b0 e0 f6 ff ff 75 a3 c7 05 c9 52 04 00 00 00 00 00 66 83 05 19 52 04 00 01 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 <66> 66 66 66 90 55 48 89 e5 48 83 ec 40 48 89 5d d8 4c 89 65 e0 
BUG: soft lockup - CPU#5 stuck for 23s! [qemu-kvm:2591]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 5 PID: 2591 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809546f4110 ti: ffff880935a34000 task.ti: ffff880935a34000
RIP: 0010:[<ffffffffa0825e84>]  [<ffffffffa0825e84>] __vcpu_run+0x114/0x230 [kvm]
RSP: 0018:ffff880935a35db8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 000000ef00000001 RCX: ffff8809559b7000
RDX: ffff88093145e280 RSI: 0000000000000000 RDI: ffff88093157c0c0
RBP: ffff880935a35df8 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffa0825aaf
R13: ffff880935a35da8 R14: ffffffffa097d774 R15: ffff880935a35d18
FS:  00007f0ac6ffd700(0000) GS:ffff88097f2a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935a35dd8 ffff88093157c0f0 ffff88093157c0c0 ffff88093157c0c0
 0000000000000000 ffff880935396000 0000000000000000 0000000000000000
 ffff880935a35e38 ffffffffa082603d ffff88093157c0c0 fffffffe7ffbfeff
Call Trace:
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 02 74 1c 83 fa 03 0f 84 e3 00 00 00 85 d2 0f 85 b3 00 00 00 c6 83 f0 37 00 00 00 0f 1f 40 00 f0 80 20 df 48 89 df e8 1c 77 01 00 <85> c0 0f 84 2c ff ff ff 48 89 df e8 bc 76 01 00 48 8b 03 48 8b 
BUG: soft lockup - CPU#6 stuck for 23s! [qemu-kvm:2592]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 6 PID: 2592 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff88093157a450 ti: ffff880954d4e000 task.ti: ffff880954d4e000
RIP: 0010:[<ffffffffa097d741>]  [<ffffffffa097d741>] vmx_cancel_injection+0x11/0x50 [kvm_intel]
RSP: 0018:ffff880954d4fd18  EFLAGS: 00000202
RAX: 00000000800000fd RBX: ffffffffa097e2a5 RCX: 0000000000000002
RDX: 0000000000004016 RSI: 000000002867d67f RDI: ffff88093592c100
RBP: ffff880954d4fd18 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 00000000800000fd R14: 0000000000000000 R15: 0000000000000000
FS:  00007f0ac67fc700(0000) GS:ffff88097f2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880954d4fda8 ffffffffa0825aaf 00000000800000fd 000000ef00000001
 ffff880953c8ac40 ffff88093145e380 ffff8809359c0040 0000000000000001
 ffff880954d4ffd8 ffff88093157a450 ffff880954d4fd78 ffffffffa083fdb1
Call Trace:
 [<ffffffffa0825aaf>] vcpu_enter_guest+0x51f/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 5d c3 0f 1f 84 00 00 00 00 00 41 0f b6 f1 e8 77 22 ea ff 5d c3 0f 1f 44 00 00 66 66 66 66 90 55 ba 16 40 00 00 48 89 e5 0f 78 d0 <85> c0 c6 87 e0 20 00 00 00 c6 87 b4 08 00 00 00 c6 87 bc 08 00 
BUG: soft lockup - CPU#7 stuck for 23s! [qemu-kvm:2589]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 7 PID: 2589 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933bfce00 ti: ffff880079bbe000 task.ti: ffff880079bbe000
RIP: 0010:[<ffffffff810a90cc>]  [<ffffffff810a90cc>] __srcu_read_unlock+0xc/0x20
RSP: 0018:ffff880079bbfda8  EFLAGS: 00000202
RAX: 0000000000000888 RBX: ffffffffa0825aaf RCX: ffff88007ec2a000
RDX: ffff88093145e080 RSI: 0000000000000000 RDI: ffff8809359c0040
RBP: ffff880079bbfda8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa097d774
R13: ffff880079bbfd18 R14: 0000000000000000 R15: ffff880079aa8040
FS:  00007f0ac7fff700(0000) GS:ffff88097f2e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880079bbfdf8 ffffffffa0825f86 ffff880079bbfdd8 ffff880079aa8070
 ffff880079aa8040 ffff880079aa8040 0000000000000000 ffff88007a374000
 0000000000000000 0000000000000000 ffff880079bbfe38 ffffffffa082603d
Call Trace:
 [<ffffffffa0825f86>] __vcpu_run+0x216/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 65 48 03 14 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca 48 83 c6 01 48 89 34 ca 5d c3 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 0f ae f0 <48> 8b 47 08 48 63 f6 48 8d 34 f0 65 48 ff 0e 5d c3 0f 1f 00 66 
BUG: soft lockup - CPU#10 stuck for 23s! [qemu-kvm:2593]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 10 PID: 2593 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880954f9af40 ti: ffff880931674000 task.ti: ffff880931674000
RIP: 0010:[<ffffffff810a90cc>]  [<ffffffff810a90cc>] __srcu_read_unlock+0xc/0x20
RSP: 0018:ffff880931675da8  EFLAGS: 00000202
RAX: 0000000000000888 RBX: ffffffffa0825aaf RCX: ffff880934df5000
RDX: ffff88093145e480 RSI: 0000000000000000 RDI: ffff8809359c0040
RBP: ffff880931675da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212217fd8 R12: ffffffffa097d774
R13: ffff880931675d18 R14: 0000000000000000 R15: ffff880931668040
FS:  00007f0ac5ffb700(0000) GS:ffff88097f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880931675df8 ffffffffa0825f86 ffff880931675dd8 ffff880931668070
 ffff880931668040 ffff880931668040 0000000000000000 ffff880931497000
 0000000000000000 0000000000000000 ffff880931675e38 ffffffffa082603d
Call Trace:
 [<ffffffffa0825f86>] __vcpu_run+0x216/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 65 48 03 14 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca 48 83 c6 01 48 89 34 ca 5d c3 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 0f ae f0 <48> 8b 47 08 48 63 f6 48 8d 34 f0 65 48 ff 0e 5d c3 0f 1f 00 66 
BUG: soft lockup - CPU#2 stuck for 23s! [qemu-kvm:2588]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 2 PID: 2588 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880955780fc0 ti: ffff880935c92000 task.ti: ffff880935c92000
RIP: 0010:[<ffffffff810a9092>]  [<ffffffff810a9092>] __srcu_read_lock+0x22/0x50
RSP: 0018:ffff880935c93da8  EFLAGS: 00000282
RAX: 0000000000000000 RBX: ffffffffa0825aaf RCX: 0000000000000000
RDX: ffffe8ffffa40ee0 RSI: 0000000000000000 RDI: ffff8809359c0040
RBP: ffff880935c93da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff88021217bfd8 R12: ffffffffa097d774
R13: ffff880935c93d18 R14: 0000000000000000 R15: ffff880935c84100
FS:  00007f0ad4c67700(0000) GS:ffff88097f240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935c93df8 ffffffffa0825f96 ffff880935c93dd8 ffffffff8105dcef
 ffff880935c84100 ffff880935c84100 0000000000000000 ffff880931715000
 0000000000000000 0000000000000000 ffff880935c93e38 ffffffffa082603d
Call Trace:
 [<ffffffffa0825f96>] __vcpu_run+0x226/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 90 90 90 90 90 90 90 90 90 66 66 66 66 90 8b 07 55 48 89 e5 83 e0 01 48 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 63 c8 48 8b 34 ca <48> 83 c6 01 48 89 34 ca 0f ae f0 48 8b 57 08 65 48 03 14 25 a8 
BUG: soft lockup - CPU#4 stuck for 23s! [qemu-kvm:2590]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 4 PID: 2590 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809358d84d0 ti: ffff88007ecf0000 task.ti: ffff88007ecf0000
RIP: 0010:[<ffffffff810a90a1>]  [<ffffffff810a90a1>] __srcu_read_lock+0x31/0x50
RSP: 0018:ffff88007ecf1da8  EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffffffffa0825aaf RCX: 0000000000000000
RDX: 000060f680800ee0 RSI: 0000000000000001 RDI: ffff8809359c0040
RBP: ffff88007ecf1da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff8802121abfd8 R12: ffffffffa097d774
R13: ffff88007ecf1d18 R14: 0000000000000000 R15: ffff880079aac080
FS:  00007f0ac77fe700(0000) GS:ffff88097f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff88007ecf1df8 ffffffffa0825f96 ffff88007ecf1dd8 ffff880079aac0b0
 ffff880079aac080 ffff880079aac080 0000000000000000 ffff880079a2b000
 0000000000000000 0000000000000000 ffff88007ecf1e38 ffffffffa082603d
Call Trace:
 [<ffffffffa0825f96>] __vcpu_run+0x226/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 07 55 48 89 e5 83 e0 01 48 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 63 c8 48 8b 34 ca 48 83 c6 01 48 89 34 ca 0f ae f0 48 8b 57 08 <65> 48 03 14 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca 48 83 c6 01 
BUG: soft lockup - CPU#5 stuck for 23s! [qemu-kvm:2591]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 5 PID: 2591 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809546f4110 ti: ffff880935a34000 task.ti: ffff880935a34000
RIP: 0010:[<ffffffff810a909d>]  [<ffffffff810a909d>] __srcu_read_lock+0x2d/0x50
RSP: 0018:ffff880935a35d18  EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffffffffa097e2a5 RCX: 0000000000000000
RDX: ffffe8ffffaa0ee0 RSI: 0000000000000001 RDI: ffff8809359c0040
RBP: ffff880935a35d18 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
R13: 0000000000000001 R14: 0000000000000000 R15: 00000000800000fd
FS:  00007f0ac6ffd700(0000) GS:ffff88097f2a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935a35da8 ffffffffa0825a94 0000000000000001 000000ef00000001
 00000000800000fd ffff88093145e280 ffff8809359c0040 0000000000000001
 ffff880935a35fd8 ffff8809546f4110 ffff880935a35d78 ffffffffa083fdb1
Call Trace:
 [<ffffffffa0825a94>] vcpu_enter_guest+0x504/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 66 66 90 8b 07 55 48 89 e5 83 e0 01 48 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 63 c8 48 8b 34 ca 48 83 c6 01 48 89 34 ca 0f ae f0 <48> 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca 
BUG: soft lockup - CPU#6 stuck for 23s! [qemu-kvm:2592]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 6 PID: 2592 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff88093157a450 ti: ffff880954d4e000 task.ti: ffff880954d4e000
RIP: 0010:[<ffffffffa097d6e8>]  [<ffffffffa097d6e8>] __vmx_complete_interrupts.part.33+0x88/0xd0 [kvm_intel]
RSP: 0018:ffff880954d4fd08  EFLAGS: 00000287
RAX: 00000000800000fd RBX: 0000000000000000 RCX: 0000000000004018
RDX: 000000000000401a RSI: 00000000800000fd RDI: ffff88093592c100
RBP: ffff880954d4fd08 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffffffffff10 R15: ffff880954d4fd18
FS:  00007f0ac67fc700(0000) GS:ffff88097f2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880954d4fd18 ffffffffa097d768 ffff880954d4fda8 ffffffffa0825aaf
 0000000000000000 000000ef00000001 00000000800000fd ffff88093145e380
 ffff8809359c0040 0000000000000001 ffff880954d4ffd8 ffff88093157a450
Call Trace:
 [<ffffffffa097d768>] vmx_cancel_injection+0x38/0x50 [kvm_intel]
 [<ffffffffa0825aaf>] vcpu_enter_guest+0x51f/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: c3 66 90 48 63 d2 0f 78 d0 88 87 b0 08 00 00 41 81 f8 00 04 00 00 c6 87 bc 08 00 00 01 44 88 8f be 08 00 00 0f 94 87 bd 08 00 00 <5d> c3 66 0f 1f 44 00 00 48 63 d2 0f 78 d0 88 87 b0 08 00 00 81 
BUG: soft lockup - CPU#7 stuck for 23s! [qemu-kvm:2589]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 7 PID: 2589 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933bfce00 ti: ffff880079bbe000 task.ti: ffff880079bbe000
RIP: 0010:[<ffffffffa083d634>]  [<ffffffffa083d634>] kvm_cpu_has_injectable_intr+0x14/0x80 [kvm]
RSP: 0018:ffff880079bbfd08  EFLAGS: 00000292
RAX: ffff8809359c0000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000004016 RSI: 00000000800000ef RDI: ffff880079aa8040
RBP: ffff880079bbfd18 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffffffffff10 R15: ffff880079bbfcf8
FS:  00007f0ac7fff700(0000) GS:ffff88097f2e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880079bbffd8 ffff880079aa8040 ffff880079bbfda8 ffffffffa0825b25
 0000000000000000 000000ef00000001 00000000800000ef ffff88093145e080
 ffff8809359c0040 0000000000000001 ffff880079bbffd8 ffff880933bfce00
Call Trace:
 [<ffffffffa0825b25>] vcpu_enter_guest+0x595/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 0f 1f 80 00 00 00 00 0f b6 97 bc 08 00 00 48 83 c4 08 5b 5d 89 d0 c3 66 66 66 66 90 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 8b 07 <48> 8b 80 50 2a 00 00 48 85 c0 74 50 e8 1b ff ff ff 85 c0 ba 01 
BUG: soft lockup - CPU#9 stuck for 22s! [qemu-kvm:2586]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 9 PID: 2586 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933e48390 ti: ffff8809568fe000 task.ti: ffff8809568fe000
RIP: 0010:[<ffffffffa08405e0>]  [<ffffffffa08405e0>] kvm_lapic_sync_to_vapic+0x0/0x190 [kvm]
RSP: 0018:ffff8809568ffd20  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff8809339dc080 RCX: 0000000000000000
RDX: 000000000000401c RSI: 0000000000000000 RDI: ffff8809339dc080
RBP: ffff8809568ffda8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212123fd8 R12: ffffffffa097e2a5
R13: ffff8809568ffcc8 R14: ffffffffffffff10 R15: ffff8809568ffd08
FS:  00007f0ad5c69700(0000) GS:ffff88097f320000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa082589c ffff880953c8ac40 000000ef00000001 ffff880931754b40
 ffff880931754b40 ffff8809359c0040 0000000000000001 ffff8809568fffd8
 ffff880933e48390 ffff8809568ffd78 ffffffffa083fdb1 ffff8809568ffd98
Call Trace:
 [<ffffffffa082589c>] ? vcpu_enter_guest+0x30c/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff810ba4b5>] ? futex_wake+0xa5/0x150
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 00 00 00 89 90 80 00 00 00 e8 ed d8 ff ff 48 83 c4 18 5b 5d c3 66 0f 1f 44 00 00 48 8b b7 70 02 00 00 e8 d4 dd ff ff eb 9e 66 90 <66> 66 66 66 90 55 48 89 e5 48 83 ec 30 48 89 5d e0 4c 89 65 e8 
BUG: soft lockup - CPU#3 stuck for 23s! [qemu-kvm:2596]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 3 PID: 2596 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880935a26350 ti: ffff880934038000 task.ti: ffff880934038000
RIP: 0010:[<ffffffffa081aaa3>]  [<ffffffffa081aaa3>] inject_pending_event+0x73/0x1b0 [kvm]
RSP: 0018:ffff880934039cd8  EFLAGS: 00000246
RAX: 00000000800000ef RBX: 00000000800000ef RCX: 0000000000000000
RDX: 0000000000004016 RSI: 00000000800000ef RDI: 0000000000004016
RBP: ffff880934039d18 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212295fd8 R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000000 R15: 00000000800000ef
FS:  00007f0aa3fff700(0000) GS:ffff88097f260000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880934039cf8 ffffffffa083f131 ffff880934039cf8 ffff8809358d4100
 0000000000000000 0000000000000001 ffff880934039fd8 ffff880935a26350
 ffff880934039da8 ffffffffa0825814 00000000800000ef 000000ef00000001
Call Trace:
 [<ffffffffa083f131>] ? kvm_lapic_find_highest_irr+0x41/0xa0 [kvm]
 [<ffffffffa0825814>] vcpu_enter_guest+0x284/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff810ba4b5>] ? futex_wake+0xa5/0x150
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 00 00 85 c0 0f 8f e6 00 00 00 48 8b 05 07 52 04 00 44 0f b6 83 b6 08 00 00 44 89 f1 44 89 ea 44 89 e6 48 89 df ff 90 88 01 00 00 <48> 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 
BUG: soft lockup - CPU#10 stuck for 23s! [qemu-kvm:2593]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 10 PID: 2593 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880954f9af40 ti: ffff880931674000 task.ti: ffff880931674000
RIP: 0010:[<ffffffffa0978be2>]  [<ffffffffa0978be2>] vmcs_writel+0x12/0x30 [kvm_intel]
RSP: 0018:ffff880931675ce8  EFLAGS: 00000202
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 000000000000000f
RDX: 000000000000401c RSI: 0000000000000000 RDI: 000000000000401c
RBP: ffff880931675ce8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212217fd8 R12: ffffffffffffff10
R13: ffff880931675d18 R14: 00000000800000ef R15: 0000000000004016
FS:  00007f0ac5ffb700(0000) GS:ffff88097f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880931675cf8 ffffffffa097bd9c ffff880931675d18 ffffffffa081a672
 ffff880931668040 0000000000000000 ffff880931675da8 ffffffffa0825894
 ffff880212217fd8 000000ef00000001 00000000800000ef ffff88093145e480
Call Trace:
 [<ffffffffa097bd9c>] update_cr8_intercept+0x2c/0x30 [kvm_intel]
 [<ffffffffa081a672>] update_cr8_intercept+0x62/0x90 [kvm]
 [<ffffffffa0825894>] vcpu_enter_guest+0x304/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 48 c7 c7 40 32 99 a0 e8 fd 70 bd e0 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 f0 48 89 fa 48 89 e5 0f 79 d0 <0f> 96 c1 84 c9 75 02 5d c3 e8 7d b3 00 00 5d c3 66 66 66 66 66 
BUG: soft lockup - CPU#2 stuck for 23s! [qemu-kvm:2588]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 2 PID: 2588 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880955780fc0 ti: ffff880935c92000 task.ti: ffff880935c92000
RIP: 0010:[<ffffffff810a90b2>]  [<ffffffff810a90b2>] __srcu_read_lock+0x42/0x50
RSP: 0018:ffff880935c93d18  EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffffffffa097e2a5 RCX: 0000000000000002
RDX: ffffe8ffffa40ee0 RSI: 000000001f52807b RDI: ffff8809359c0040
RBP: ffff880935c93d18 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff88021217bfd8 R12: 0000000000000000
R13: 00000000800000ef R14: 0000000000000001 R15: ffff88021217bfd8
FS:  00007f0ad4c67700(0000) GS:ffff88097f240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935c93da8 ffffffffa0825a94 ffff88021217bfd8 000000ef00000001
 00000000800000ef ffff880954b9f740 ffff8809359c0040 0000000000000001
 ffff880935c93fd8 ffff880955780fc0 ffff880935c93d78 ffffffffa083fdb1
Call Trace:
 [<ffffffffa0825a94>] vcpu_enter_guest+0x504/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: a8 cd 00 00 48 63 c8 48 8b 34 ca 48 83 c6 01 48 89 34 ca 0f ae f0 48 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca <48> 83 c6 01 48 89 34 ca 5d c3 0f 1f 40 00 66 66 66 66 90 55 48 
BUG: soft lockup - CPU#4 stuck for 23s! [qemu-kvm:2590]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 4 PID: 2590 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809358d84d0 ti: ffff88007ecf0000 task.ti: ffff88007ecf0000
RIP: 0010:[<ffffffffa097d66e>]  [<ffffffffa097d66e>] __vmx_complete_interrupts.part.33+0xe/0xd0 [kvm_intel]
RSP: 0018:ffff88007ecf1d08  EFLAGS: 00000202
RAX: 00000000800000ef RBX: ffffffffffffff10 RCX: 0000000000004018
RDX: 000000000000401a RSI: 00000000800000ef RDI: ffff880079aac080
RBP: ffff88007ecf1d08 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff8802121abfd8 R12: 00000000800000ef
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f0ac77fe700(0000) GS:ffff88097f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff88007ecf1d18 ffffffffa097d768 ffff88007ecf1da8 ffffffffa0825aaf
 ffff88007ecf1df8 000000ef00000001 ffff8802121abfd8 ffff88093145e180
 ffff8809359c0040 0000000000000001 ffff88007ecf1fd8 ffff8809358d84d0
Call Trace:
 [<ffffffffa097d768>] vmx_cancel_injection+0x38/0x50 [kvm_intel]
 [<ffffffffa0825aaf>] vcpu_enter_guest+0x51f/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: f0 80 4b 31 08 48 83 c4 08 b8 01 00 00 00 5b 5d c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 f0 80 4f 31 08 <41> 89 f0 41 89 f1 41 81 e0 00 07 00 00 41 81 f8 00 03 00 00 74 
BUG: soft lockup - CPU#5 stuck for 23s! [qemu-kvm:2591]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 5 PID: 2591 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809546f4110 ti: ffff880935a34000 task.ti: ffff880935a34000
RIP: 0010:[<ffffffffa0825a8b>]  [<ffffffffa0825a8b>] vcpu_enter_guest+0x4fb/0x7e0 [kvm]
RSP: 0018:ffff880935a35d28  EFLAGS: 00000202
RAX: 0000000000000888 RBX: ffff88093157c0c0 RCX: 0000000000000000
RDX: 000000000000401c RSI: 000060f680800ee0 RDI: ffff8809359c0000
RBP: ffff880935a35da8 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffa097e2a5
R13: ffff880935a35cc8 R14: 0000000000000000 R15: 00000000800000fd
FS:  00007f0ac6ffd700(0000) GS:ffff88097f2a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935a35df8 000000ef00000001 0000000000000001 ffff88093145e280
 ffff8809359c0040 0000000000000001 ffff880935a35fd8 ffff8809546f4110
 ffff880935a35d78 ffffffffa083fdb1 ffff880935a35d98 ffff88093157c0c0
Call Trace:
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 5e 41 5f 5d c3 0f 1f 00 45 31 ed 45 84 e4 0f 84 28 fe ff ff e9 79 fd ff ff 0f 1f 80 00 00 00 00 c7 43 2c 00 00 00 00 fb 48 8b 3b <48> 83 c7 40 e8 dc 35 88 e0 89 43 28 b8 01 00 00 00 48 8b 15 ed 
BUG: soft lockup - CPU#6 stuck for 23s! [qemu-kvm:2592]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 6 PID: 2592 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff88093157a450 ti: ffff880954d4e000 task.ti: ffff880954d4e000
RIP: 0010:[<ffffffffa097c6c0>]  [<ffffffffa097c6c0>] vmx_save_host_state+0x0/0x20 [kvm_intel]
RSP: 0018:ffff880954d4fd20  EFLAGS: 00000213
RAX: ffffffffa0993ea0 RBX: ffff88093592c100 RCX: 0000000000000000
RDX: 000000000000401c RSI: 0000000000000000 RDI: ffff88093592c100
RBP: ffff880954d4fda8 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa097e2a5
R13: ffff880954d4fcc8 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f0ac67fc700(0000) GS:ffff88097f2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa08258b7 00000000800000fd 000000ef00000001 ffff880953c8ac40
 ffff88093145e380 ffff8809359c0040 0000000000000001 ffff880954d4ffd8
 ffff88093157a450 ffff880954d4fd78 ffffffffa083fdb1 ffff880954d4fd98
Call Trace:
 [<ffffffffa08258b7>] ? vcpu_enter_guest+0x327/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 00 e9 1e ff ff ff 0f 1f 44 00 00 31 f6 bf 08 0c 00 00 e8 24 c5 ff ff c7 83 34 3c 00 00 01 00 00 00 e9 dd fe ff ff 0f 1f 44 00 00 <66> 66 66 66 90 8b b7 20 3c 00 00 55 48 89 e5 85 f6 75 05 e8 68 
BUG: soft lockup - CPU#7 stuck for 23s! [qemu-kvm:2589]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 7 PID: 2589 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933bfce00 ti: ffff880079bbe000 task.ti: ffff880079bbe000
RIP: 0010:[<ffffffffa083ffd6>]  [<ffffffffa083ffd6>] kvm_apic_has_interrupt+0xc6/0x110 [kvm]
RSP: 0018:ffff880079bbfce8  EFLAGS: 00000246
RAX: 00000000000000ef RBX: 0000000000000000 RCX: 00000000ffffffff
RDX: 00000000000000e0 RSI: ffff88007ec2a000 RDI: 000000000000000f
RBP: ffff880079bbfcf8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 00000000800000ef R14: 0000000000000000 R15: 0000000000000000
FS:  00007f0ac7fff700(0000) GS:ffff88097f2e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880079bbfcf8 ffff880079aa8040 ffff880079bbfd18 ffffffffa083d67e
 ffff880079bbffd8 ffff880079aa8040 ffff880079bbfda8 ffffffffa0825b25
 0000000000000000 000000ef00000001 00000000800000ef ffff88093145e080
Call Trace:
 [<ffffffffa083d67e>] kvm_cpu_has_injectable_intr+0x5e/0x80 [kvm]
 [<ffffffffa0825b25>] vcpu_enter_guest+0x595/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: ff 48 83 c4 08 5b 5d c3 0f 1f 44 00 00 b9 ff ff ff ff 89 cf 0f bd fa 01 f8 39 c8 74 e4 89 c2 81 e2 f0 00 00 00 3b 96 a0 00 00 00 <0f> 46 c1 48 83 c4 08 5b 5d c3 48 8b 93 a8 00 00 00 83 c8 ff f6 
BUG: soft lockup - CPU#8 stuck for 23s! [qemu-kvm:2595]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 8 PID: 2595 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809317403d0 ti: ffff880935518000 task.ti: ffff880935518000
RIP: 0010:[<ffffffffa08257fa>]  [<ffffffffa08257fa>] vcpu_enter_guest+0x26a/0x7e0 [kvm]
RSP: 0018:ffff880935519d28  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff880933bf80c0 RCX: 0000000000000002
RDX: ffffe8ffffb00ee0 RSI: 000000000e7dc6b7 RDI: ffff880933bf80c0
RBP: ffff880935519da8 R08: 0000000000000000 R09: 00000000800000ef
R10: ffff880957b59278 R11: 0000000000000001 R12: ffffffffa097e2a5
R13: ffff880935519cc8 R14: 0000000000000000 R15: ffff880935519d18
FS:  00007f0ac4ff9700(0000) GS:ffff88097f300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000c30008 CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935519df8 000000ef00000001 0000000000000001 ffff880957b59278
 00000000800000ef 0000000000000000 ffff880933bf80f0 0000000000004000
 0000000000004016 0000000000000000 0000000000004016 ffff880933bf80c0
Call Trace:
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 90 e8 01 00 00 48 8d 75 b0 48 89 df e8 e0 99 01 00 48 8b 43 30 f6 c4 08 0f 84 7b 02 00 00 f0 80 63 31 f7 48 89 df e8 e6 b2 01 00 <83> bb 84 02 00 00 02 b8 01 00 00 00 0f 84 cd fe ff ff 48 89 df 
BUG: soft lockup - CPU#9 stuck for 22s! [qemu-kvm:2586]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 9 PID: 2586 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933e48390 ti: ffff8809568fe000 task.ti: ffff8809568fe000
RIP: 0010:[<ffffffffa0978bd6>]  [<ffffffffa0978bd6>] vmcs_writel+0x6/0x30 [kvm_intel]
RSP: 0018:ffff8809568ffce8  EFLAGS: 00000246
RAX: ffffffffa0993ea0 RBX: ffffffffffffff10 RCX: 000000000000000f
RDX: 000000000000000e RSI: 0000000000000000 RDI: 000000000000401c
RBP: ffff8809568ffcf8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212123fd8 R12: 00000000800000ef
R13: 0000000000004016 R14: 0000000000000000 R15: 00000000800000ef
FS:  00007f0ad5c69700(0000) GS:ffff88097f320000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff8809568ffcf8 ffffffffa097bd9c ffff8809568ffd18 ffffffffa081a672
 ffff8809339dc080 0000000000000000 ffff8809568ffda8 ffffffffa0825894
 ffff880212123fd8 000000ef00000001 00000000800000ef ffff880931754b40
Call Trace:
 [<ffffffffa097bd9c>] ? update_cr8_intercept+0x2c/0x30 [kvm_intel]
 [<ffffffffa081a672>] update_cr8_intercept+0x62/0x90 [kvm]
 [<ffffffffa0825894>] vcpu_enter_guest+0x304/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff810ba4b5>] ? futex_wake+0xa5/0x150
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 02 c9 c3 48 8b 55 f8 48 89 fe 31 c0 48 c7 c7 40 32 99 a0 e8 fd 70 bd e0 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 <48> 89 f0 48 89 fa 48 89 e5 0f 79 d0 0f 96 c1 84 c9 75 02 5d c3 
BUG: soft lockup - CPU#3 stuck for 23s! [qemu-kvm:2596]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 3 PID: 2596 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880935a26350 ti: ffff880934038000 task.ti: ffff880934038000
RIP: 0010:[<ffffffffa0978620>]  [<ffffffffa0978620>] vmx_sync_pir_to_irr_dummy+0x0/0x10 [kvm_intel]
RSP: 0018:ffff880934039ce0  EFLAGS: 00000202
RAX: ffffffffa0993ea0 RBX: ffffffffffffff10 RCX: 00000000ffffffff
RDX: ffff880955557580 RSI: ffff880936757000 RDI: ffff8809358d4100
RBP: ffff880934039cf8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212295fd8 R12: 0000000000000000
R13: ffffe8ffffa60ee0 R14: 0000000000000002 R15: 0000000000000000
FS:  00007f0aa3fff700(0000) GS:ffff88097f260000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa083f131 ffff880934039cf8 ffff8809358d4100 ffff880934039d18
 ffffffffa081a685 ffff8809358d4100 0000000000000000 ffff880934039da8
 ffffffffa0825894 ffff880212295fd8 000000ef00000001 00000000800000ef
Call Trace:
 [<ffffffffa083f131>] ? kvm_lapic_find_highest_irr+0x41/0xa0 [kvm]
 [<ffffffffa081a685>] update_cr8_intercept+0x75/0x90 [kvm]
 [<ffffffffa0825894>] vcpu_enter_guest+0x304/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff810ba4b5>] ? futex_wake+0xa5/0x150
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 31 c0 80 3d c2 bb 01 00 00 55 48 89 e5 74 10 48 8b 87 50 2a 00 00 48 85 c0 0f 95 c0 0f b6 c0 5d c3 66 2e 0f 1f 84 00 00 00 00 00 <66> 66 66 66 90 55 48 89 e5 5d c3 0f 1f 44 00 00 66 66 66 66 90 
BUG: soft lockup - CPU#10 stuck for 22s! [qemu-kvm:2593]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 10 PID: 2593 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880954f9af40 ti: ffff880931674000 task.ti: ffff880931674000
RIP: 0010:[<ffffffff810a908b>]  [<ffffffff810a908b>] __srcu_read_lock+0x1b/0x50
RSP: 0018:ffff880931675da8  EFLAGS: 00000282
RAX: 0000000000000000 RBX: ffffffffa0825aaf RCX: ffff880934df5000
RDX: ffffe8ffffb40ee0 RSI: 000060f680800ee0 RDI: ffff8809359c0040
RBP: ffff880931675da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212217fd8 R12: ffffffffa097d774
R13: ffff880931675d18 R14: 0000000000000000 R15: ffff880931668040
FS:  00007f0ac5ffb700(0000) GS:ffff88097f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880931675df8 ffffffffa0825f96 ffff880931675dd8 ffff880931668070
 ffff880931668040 ffff880931668040 0000000000000000 ffff880931497000
 0000000000000000 0000000000000000 ffff880931675e38 ffffffffa082603d
Call Trace:
 [<ffffffffa0825f96>] __vcpu_run+0x226/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 66 66 66 90 8b 07 55 48 89 e5 83 e0 01 48 8b 57 08 65 48 03 14 25 a8 cd 00 00 <48> 63 c8 48 8b 34 ca 48 83 c6 01 48 89 34 ca 0f ae f0 48 8b 57 
BUG: soft lockup - CPU#2 stuck for 23s! [qemu-kvm:2588]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 2 PID: 2588 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880955780fc0 ti: ffff880935c92000 task.ti: ffff880935c92000
RIP: 0010:[<ffffffffa097d66e>]  [<ffffffffa097d66e>] __vmx_complete_interrupts.part.33+0xe/0xd0 [kvm_intel]
RSP: 0018:ffff880935c93d08  EFLAGS: 00000202
RAX: 00000000800000ef RBX: 0000000000000000 RCX: 0000000000004018
RDX: 000000000000401a RSI: 00000000800000ef RDI: ffff880935c84100
RBP: ffff880935c93d08 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff88021217bfd8 R12: 0000000000000001
R13: ffff88021217bfd8 R14: 0000000000000000 R15: ffff880935c93d18
FS:  00007f0ad4c67700(0000) GS:ffff88097f240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935c93d18 ffffffffa097d768 ffff880935c93da8 ffffffffa0825aaf
 ffff88021217bfd8 000000ef00000001 00000000800000ef ffff880954b9f740
 ffff8809359c0040 0000000000000001 ffff880935c93fd8 ffff880955780fc0
Call Trace:
 [<ffffffffa097d768>] vmx_cancel_injection+0x38/0x50 [kvm_intel]
 [<ffffffffa0825aaf>] vcpu_enter_guest+0x51f/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: f0 80 4b 31 08 48 83 c4 08 b8 01 00 00 00 5b 5d c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 f0 80 4f 31 08 <41> 89 f0 41 89 f1 41 81 e0 00 07 00 00 41 81 f8 00 03 00 00 74 
BUG: soft lockup - CPU#4 stuck for 23s! [qemu-kvm:2590]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 4 PID: 2590 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809358d84d0 ti: ffff88007ecf0000 task.ti: ffff88007ecf0000
RIP: 0010:[<ffffffffa083f17a>]  [<ffffffffa083f17a>] kvm_lapic_find_highest_irr+0x8a/0xa0 [kvm]
RSP: 0018:ffff88007ecf1ce8  EFLAGS: 00000202
RAX: 00000000000000ef RBX: 0000000000000000 RCX: 000000000000000f
RDX: 0000000000008000 RSI: ffff88007f20f000 RDI: ffff880079aac080
RBP: ffff88007ecf1cf8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff8802121abfd8 R12: 0000000000000000
R13: 00000000800000ef R14: 0000000000000001 R15: ffff8802121abfd8
FS:  00007f0ac77fe700(0000) GS:ffff88097f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff88007ecf1cf8 ffff880079aac080 ffff88007ecf1d18 ffffffffa081a685
 ffff880079aac080 0000000000000000 ffff88007ecf1da8 ffffffffa0825894
 ffff8802121abfd8 000000ef00000001 00000000800000ef ffff88093145e180
Call Trace:
 [<ffffffffa081a685>] update_cr8_intercept+0x75/0x90 [kvm]
 [<ffffffffa0825894>] vcpu_enter_guest+0x304/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 04 48 63 d2 8b 14 11 85 d2 75 16 83 e8 20 83 f8 e0 75 e6 b0 ff 48 83 c4 08 5b 5d c3 0f 1f 44 00 00 b9 ff ff ff ff 0f bd ca 01 c8 <eb> e8 31 c0 48 83 bf 70 02 00 00 00 74 dc e9 7b ff ff ff 0f 1f 
BUG: soft lockup - CPU#5 stuck for 23s! [qemu-kvm:2591]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 5 PID: 2591 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809546f4110 ti: ffff880935a34000 task.ti: ffff880935a34000
RIP: 0010:[<ffffffffa0978bd0>]  [<ffffffffa0978bd0>] vmcs_writel+0x0/0x30 [kvm_intel]
RSP: 0018:ffff880935a35cf0  EFLAGS: 00000246
RAX: ffffffffa0993ea0 RBX: 0000000000000000 RCX: 000000000000000f
RDX: 000000000000000e RSI: 0000000000000000 RDI: 000000000000401c
RBP: ffff880935a35cf8 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000001 R14: 000000004a956ba7 R15: ffff880935a35cd8
FS:  00007f0ac6ffd700(0000) GS:ffff88097f2a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa097bd9c ffff880935a35d18 ffffffffa081a672 ffff88093157c0c0
 0000000000000000 ffff880935a35da8 ffffffffa0825894 00000000800000fd
 000000ef00000001 0000000000000000 ffff88093145e280 ffff8809359c0040
Call Trace:
 [<ffffffffa097bd9c>] ? update_cr8_intercept+0x2c/0x30 [kvm_intel]
 [<ffffffffa081a672>] update_cr8_intercept+0x62/0x90 [kvm]
 [<ffffffffa0825894>] vcpu_enter_guest+0x304/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 0f 96 c0 84 c0 75 02 c9 c3 48 8b 55 f8 48 89 fe 31 c0 48 c7 c7 40 32 99 a0 e8 fd 70 bd e0 c9 c3 66 66 2e 0f 1f 84 00 00 00 00 00 <66> 66 66 66 90 55 48 89 f0 48 89 fa 48 89 e5 0f 79 d0 0f 96 c1 
BUG: soft lockup - CPU#6 stuck for 23s! [qemu-kvm:2592]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 6 PID: 2592 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff88093157a450 ti: ffff880954d4e000 task.ti: ffff880954d4e000
RIP: 0010:[<ffffffff810a90a1>]  [<ffffffff810a90a1>] __srcu_read_lock+0x31/0x50
RSP: 0018:ffff880954d4fd18  EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffffffffa097e2a5 RCX: 0000000000000000
RDX: 000060f680800ee0 RSI: 0000000000000001 RDI: ffff8809359c0040
RBP: ffff880954d4fd18 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 00000000800000fd R14: 0000000000000000 R15: 0000000000000000
FS:  00007f0ac67fc700(0000) GS:ffff88097f2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880954d4fda8 ffffffffa0825a94 0000000000000000 000000ef00000001
 00000000800000fd ffff88093145e380 ffff8809359c0040 0000000000000001
 ffff880954d4ffd8 ffff88093157a450 ffff880954d4fd78 ffffffffa083fdb1
Call Trace:
 [<ffffffffa0825a94>] vcpu_enter_guest+0x504/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 07 55 48 89 e5 83 e0 01 48 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 63 c8 48 8b 34 ca 48 83 c6 01 48 89 34 ca 0f ae f0 48 8b 57 08 <65> 48 03 14 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca 48 83 c6 01 
BUG: soft lockup - CPU#7 stuck for 23s! [qemu-kvm:2589]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 7 PID: 2589 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933bfce00 ti: ffff880079bbe000 task.ti: ffff880079bbe000
RIP: 0010:[<ffffffffa097e2a0>]  [<ffffffffa097e2a0>] vmx_inject_irq+0xa0/0x130 [kvm_intel]
RSP: 0018:ffff880079bbfc98  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: ffffe8ffffae0ee0 RSI: 00000000800000ef RDI: 0000000000004016
RBP: ffff880079bbfcc8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880957b59200
R13: ffff880079bbfc88 R14: ffffffff8155eba2 R15: ffff880079bbfc48
FS:  00007f0ac7fff700(0000) GS:ffff88097f2e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 00000000800000ef ffff880079aa8040 0000000000000000 0000000000000001
 ffff880079bbffd8 ffff880933bfce00 ffff880079bbfd18 ffffffffa081ab29
 ffff880079bbfcf8 ffffffffa083f131 ffff880079bbfcf8 ffff880079aa8040
Call Trace:
 [<ffffffffa081ab29>] inject_pending_event+0xf9/0x1b0 [kvm]
 [<ffffffffa083f131>] ? kvm_lapic_find_highest_irr+0x41/0xa0 [kvm]
 [<ffffffffa0825814>] vcpu_enter_guest+0x284/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 41 81 cc 00 00 00 80 80 bb bd 08 00 00 00 75 18 44 89 e6 bf 16 40 00 00 <e8> 2b a9 ff ff eb c5 66 0f 1f 84 00 00 00 00 00 0f b6 b3 b0 08 
BUG: soft lockup - CPU#8 stuck for 23s! [qemu-kvm:2595]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 8 PID: 2595 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809317403d0 ti: ffff880935518000 task.ti: ffff880935518000
RIP: 0010:[<ffffffffa097d66e>]  [<ffffffffa097d66e>] __vmx_complete_interrupts.part.33+0xe/0xd0 [kvm_intel]
RSP: 0018:ffff880935519d08  EFLAGS: 00000202
RAX: 00000000800000ef RBX: 0000000000000000 RCX: 0000000000004018
RDX: 000000000000401a RSI: 00000000800000ef RDI: ffff880933bf80c0
RBP: ffff880935519d08 R08: 0000000000000000 R09: 00000000800000ef
R10: ffff880957b59278 R11: 0000000000000001 R12: 0000000000000000
R13: 00000000800000ef R14: ffff880957b59278 R15: 0000000000000001
FS:  00007f0ac4ff9700(0000) GS:ffff88097f300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000c30008 CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935519d18 ffffffffa097d768 ffff880935519da8 ffffffffa0825aaf
 ffff880953c8ac40 000000ef00000001 ffff88093145e680 ffff88093145e680
 ffff8809359c0040 0000000000000001 ffff880935519fd8 ffff8809317403d0
Call Trace:
 [<ffffffffa097d768>] vmx_cancel_injection+0x38/0x50 [kvm_intel]
 [<ffffffffa0825aaf>] vcpu_enter_guest+0x51f/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: f0 80 4b 31 08 48 83 c4 08 b8 01 00 00 00 5b 5d c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 f0 80 4f 31 08 <41> 89 f0 41 89 f1 41 81 e0 00 07 00 00 41 81 f8 00 03 00 00 74 
BUG: soft lockup - CPU#9 stuck for 22s! [qemu-kvm:2586]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 9 PID: 2586 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933e48390 ti: ffff8809568fe000 task.ti: ffff8809568fe000
RIP: 0010:[<ffffffffa0840b3f>]  [<ffffffffa0840b3f>] kvm_apic_accept_events+0x5f/0x100 [kvm]
RSP: 0018:ffff8809568ffcf8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000002
RDX: ffffe8ffffb20ee0 RSI: 000000002b558df6 RDI: ffff8809339dc080
RBP: ffff8809568ffd18 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212123fd8 R12: ffffffffffffff10
R13: ffff8809568ffcf8 R14: 0000000000000000 R15: ffffe8ffffb20ee0
FS:  00007f0ad5c69700(0000) GS:ffff88097f320000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff8809339dc080 0000000000000000 ffff8809339dc080 0000000000000000
 ffff8809568ffda8 ffffffffa08257fa ffff880212123fd8 000000ef00000001
 00000000800000ef ffff880931754b40 ffff8809359c0040 0000000000000001
Call Trace:
 [<ffffffffa08257fa>] vcpu_enter_guest+0x26a/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff810ba4b5>] ? futex_wake+0xa5/0x150
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 00 00 74 27 31 c0 49 87 84 24 e0 00 00 00 48 89 45 e8 48 8b 45 e8 a8 01 75 52 48 8b 45 e8 a8 02 74 09 83 bb 84 02 00 00 02 74 11 <48> 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 80 00 00 00 00 f6 05 0b ee 
BUG: soft lockup - CPU#3 stuck for 23s! [qemu-kvm:2596]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 3 PID: 2596 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880935a26350 ti: ffff880934038000 task.ti: ffff880934038000
RIP: 0010:[<ffffffff810a909d>]  [<ffffffff810a909d>] __srcu_read_lock+0x2d/0x50
RSP: 0018:ffff880934039da8  EFLAGS: 00000206
RAX: 0000000000000000 RBX: ffffffffa0825aaf RCX: 0000000000000000
RDX: ffffe8ffffa60ee0 RSI: 0000000000000003 RDI: ffff8809359c0040
RBP: ffff880934039da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212295fd8 R12: ffffffffa097d774
R13: ffff880934039d18 R14: 0000000000000000 R15: ffff8809358d4100
FS:  00007f0aa3fff700(0000) GS:ffff88097f260000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880934039df8 ffffffffa0825f96 ffff880934039dd8 ffffffff8105dcef
 ffff8809358d4100 ffff8809358d4100 0000000000000000 ffff88093536f000
 0000000000000000 0000000000000000 ffff880934039e38 ffffffffa082603d
Call Trace:
 [<ffffffffa0825f96>] __vcpu_run+0x226/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff810ba4b5>] ? futex_wake+0xa5/0x150
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 66 66 90 8b 07 55 48 89 e5 83 e0 01 48 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 63 c8 48 8b 34 ca 48 83 c6 01 48 89 34 ca 0f ae f0 <48> 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca 
BUG: soft lockup - CPU#10 stuck for 22s! [qemu-kvm:2593]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 10 PID: 2593 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880954f9af40 ti: ffff880931674000 task.ti: ffff880931674000
RIP: 0010:[<ffffffffa08258f0>]  [<ffffffffa08258f0>] vcpu_enter_guest+0x360/0x7e0 [kvm]
RSP: 0018:ffff880931675d28  EFLAGS: 00000246
RAX: ffffffffa0993ea0 RBX: ffff880931668040 RCX: 0000000000000000
RDX: 000000000000401c RSI: 0000000000000001 RDI: ffff880931668040
RBP: ffff880931675da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212217fd8 R12: ffffffffa097e2a5
R13: ffff880931675cc8 R14: 0000000000000000 R15: 00000000800000ef
FS:  00007f0ac5ffb700(0000) GS:ffff88097f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880931675df8 000000ef00000001 ffff880212217fd8 ffff88093145e480
 ffff8809359c0040 0000000000000001 ffff880931675fd8 ffff880954f9af40
 ffff880931675d78 ffffffffa083fdb1 ffff880931675d98 ffff880931668040
Call Trace:
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 83 42 02 00 00 04 74 23 44 8b 73 78 45 85 f6 75 1a 48 8b 83 78 08 00 00 31 c9 48 89 c2 48 c1 ea 20 0f 01 d1 c7 43 78 01 00 00 00 <48> 8b 3b 8b 73 28 c7 43 2c 01 00 00 00 48 83 c7 40 e8 ba 37 88 
BUG: soft lockup - CPU#2 stuck for 23s! [qemu-kvm:2588]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 2 PID: 2588 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880955780fc0 ti: ffff880935c92000 task.ti: ffff880935c92000
RIP: 0010:[<ffffffffa083deb6>]  [<ffffffffa083deb6>] apic_update_ppr+0x6/0xb0 [kvm]
RSP: 0018:ffff880935c93cd8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffffffffff10 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000800000ef RDI: ffff880954b9f740
RBP: ffff880935c93cf8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff88021217bfd8 R12: 00000000800000ef
R13: 0000000000004016 R14: 0000000000000002 R15: 00000000800000ef
FS:  00007f0ad4c67700(0000) GS:ffff88097f240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935c93cf8 ffffffffa083ff57 ffff880935c93cf8 ffff880935c84100
 ffff880935c93d18 ffffffffa083d67e ffff880935c93fd8 ffff880935c84100
 ffff880935c93da8 ffffffffa0825b25 ffff880935c93df8 000000ef00000001
Call Trace:
 [<ffffffffa083ff57>] ? kvm_apic_has_interrupt+0x47/0x110 [kvm]
 [<ffffffffa083d67e>] kvm_cpu_has_injectable_intr+0x5e/0x80 [kvm]
 [<ffffffffa0825b25>] vcpu_enter_guest+0x595/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 4c 89 e6 ff d0 48 89 d8 4c 29 f0 49 8b 44 07 f0 48 85 c0 75 e0 eb 93 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 <48> 89 e5 48 83 ec 20 66 83 bf a2 00 00 00 00 4c 89 65 e8 4c 8b 
BUG: soft lockup - CPU#4 stuck for 23s! [qemu-kvm:2590]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 4 PID: 2590 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809358d84d0 ti: ffff88007ecf0000 task.ti: ffff88007ecf0000
RIP: 0010:[<ffffffffa097c6c0>]  [<ffffffffa097c6c0>] vmx_save_host_state+0x0/0x20 [kvm_intel]
RSP: 0018:ffff88007ecf1d20  EFLAGS: 00000213
RAX: ffffffffa0993ea0 RBX: ffff880079aac080 RCX: 0000000000000000
RDX: 000000000000401c RSI: 0000000000000000 RDI: ffff880079aac080
RBP: ffff88007ecf1da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff8802121abfd8 R12: ffffffffa097e2a5
R13: ffff88007ecf1cc8 R14: 0000000000000000 R15: ffff88093145e180
FS:  00007f0ac77fe700(0000) GS:ffff88097f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa08258b7 ffff88007ecf1df8 000000ef00000001 ffff8802121abfd8
 ffff88093145e180 ffff8809359c0040 0000000000000001 ffff88007ecf1fd8
 ffff8809358d84d0 ffff88007ecf1d78 ffffffffa083fdb1 ffff88007ecf1d98
Call Trace:
 [<ffffffffa08258b7>] ? vcpu_enter_guest+0x327/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 00 e9 1e ff ff ff 0f 1f 44 00 00 31 f6 bf 08 0c 00 00 e8 24 c5 ff ff c7 83 34 3c 00 00 01 00 00 00 e9 dd fe ff ff 0f 1f 44 00 00 <66> 66 66 66 90 8b b7 20 3c 00 00 55 48 89 e5 85 f6 75 05 e8 68 
BUG: soft lockup - CPU#5 stuck for 23s! [qemu-kvm:2591]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 5 PID: 2591 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809546f4110 ti: ffff880935a34000 task.ti: ffff880935a34000
RIP: 0010:[<ffffffffa081aaa3>]  [<ffffffffa081aaa3>] inject_pending_event+0x73/0x1b0 [kvm]
RSP: 0018:ffff880935a35cd8  EFLAGS: 00000246
RAX: 00000000800000fd RBX: ffffffffffffff10 RCX: 0000000000000000
RDX: 0000000000004016 RSI: 00000000800000fd RDI: 0000000000004016
RBP: ffff880935a35d18 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000001 R12: 00000000800000fd
R13: 0000000000004016 R14: 0000000000000002 R15: 00000000800000fd
FS:  00007f0ac6ffd700(0000) GS:ffff88097f2a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935a35cf8 ffffffffa083f131 ffff880935a35cf8 ffff88093157c0c0
 0000000000000000 0000000000000001 ffff880935a35fd8 ffff8809546f4110
 ffff880935a35da8 ffffffffa0825814 ffff880935a35df8 000000ef00000001
Call Trace:
 [<ffffffffa083f131>] ? kvm_lapic_find_highest_irr+0x41/0xa0 [kvm]
 [<ffffffffa0825814>] vcpu_enter_guest+0x284/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 00 00 85 c0 0f 8f e6 00 00 00 48 8b 05 07 52 04 00 44 0f b6 83 b6 08 00 00 44 89 f1 44 89 ea 44 89 e6 48 89 df ff 90 88 01 00 00 <48> 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 
BUG: soft lockup - CPU#6 stuck for 23s! [qemu-kvm:2592]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 6 PID: 2592 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff88093157a450 ti: ffff880954d4e000 task.ti: ffff880954d4e000
RIP: 0010:[<ffffffffa097c6c0>]  [<ffffffffa097c6c0>] vmx_save_host_state+0x0/0x20 [kvm_intel]
RSP: 0018:ffff880954d4fd20  EFLAGS: 00000213
RAX: ffffffffa0993ea0 RBX: ffff88093592c100 RCX: 0000000000000000
RDX: 000000000000401c RSI: 0000000000000000 RDI: ffff88093592c100
RBP: ffff880954d4fda8 R08: 0000000000000000 R09: 00000000800000fd
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa097e2a5
R13: ffff880954d4fcc8 R14: 0000000000000000 R15: 00000000800000fd
FS:  00007f0ac67fc700(0000) GS:ffff88097f2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa08258b7 0000000000000000 000000ef00000001 00000000800000fd
 ffff88093145e380 ffff8809359c0040 0000000000000001 ffff880954d4ffd8
 ffff88093157a450 ffff880954d4fd78 ffffffffa083fdb1 ffff880954d4fd98
Call Trace:
 [<ffffffffa08258b7>] ? vcpu_enter_guest+0x327/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 00 e9 1e ff ff ff 0f 1f 44 00 00 31 f6 bf 08 0c 00 00 e8 24 c5 ff ff c7 83 34 3c 00 00 01 00 00 00 e9 dd fe ff ff 0f 1f 44 00 00 <66> 66 66 66 90 8b b7 20 3c 00 00 55 48 89 e5 85 f6 75 05 e8 68 
BUG: soft lockup - CPU#7 stuck for 23s! [qemu-kvm:2589]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 7 PID: 2589 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933bfce00 ti: ffff880079bbe000 task.ti: ffff880079bbe000
RIP: 0010:[<ffffffffa083f84d>]  [<ffffffffa083f84d>] kvm_lapic_get_cr8+0x2d/0x40 [kvm]
RSP: 0018:ffff880079bbfd00  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000f
RDX: 0000000000008000 RSI: ffff88007ec2a000 RDI: ffff880079aa8040
RBP: ffff880079bbfd18 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880079bbfc88
R13: 0000000000000202 R14: 0000000000000010 R15: ffffffffa0978be2
FS:  00007f0ac7fff700(0000) GS:ffff88097f2e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa081a65d ffff880079aa8040 0000000000000000 ffff880079bbfda8
 ffffffffa0825894 0000000000000000 000000ef00000001 00000000800000ef
 ffff88093145e080 ffff8809359c0040 0000000000000001 ffff880079bbffd8
Call Trace:
 [<ffffffffa081a65d>] ? update_cr8_intercept+0x4d/0x90 [kvm]
 [<ffffffffa0825894>] vcpu_enter_guest+0x304/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 66 66 90 8b 05 55 ff 01 00 55 48 89 e5 85 c0 7f 1f 48 8b 87 70 02 00 00 5d 48 8b 80 a8 00 00 00 8b 80 80 00 00 00 25 f0 00 00 00 <48> c1 e8 04 c3 31 c0 48 83 bf 70 02 00 00 00 75 d5 5d c3 66 66 
BUG: soft lockup - CPU#8 stuck for 23s! [qemu-kvm:2595]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 8 PID: 2595 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff8809317403d0 ti: ffff880935518000 task.ti: ffff880935518000
RIP: 0010:[<ffffffff810a909d>]  [<ffffffff810a909d>] __srcu_read_lock+0x2d/0x50
RSP: 0018:ffff880935519d18  EFLAGS: 00000257
RAX: 0000000000000000 RBX: ffffffffa097e2a5 RCX: 0000000000000000
RDX: ffffe8ffffb00ee0 RSI: 0000000000000000 RDI: ffff8809359c0040
RBP: ffff880935519d18 R08: 0000000000000000 R09: 00000000800000ef
R10: ffff880957b59278 R11: 0000000000000001 R12: ffff880935519c98
R13: 0000000000000282 R14: 0000000000000010 R15: ffffffffa097e226
FS:  00007f0ac4ff9700(0000) GS:ffff88097f300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000c30008 CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880935519da8 ffffffffa0825a94 0000000000000001 000000ef00000001
 00000000800000ef ffff88093145e680 ffff8809359c0040 0000000000000001
 ffff880935519fd8 ffff8809317403d0 ffff880935519d78 ffffffffa083fdb1
Call Trace:
 [<ffffffffa0825a94>] vcpu_enter_guest+0x504/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 66 66 90 8b 07 55 48 89 e5 83 e0 01 48 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 63 c8 48 8b 34 ca 48 83 c6 01 48 89 34 ca 0f ae f0 <48> 8b 57 08 65 48 03 14 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca 
BUG: soft lockup - CPU#9 stuck for 22s! [qemu-kvm:2586]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 9 PID: 2586 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880933e48390 ti: ffff8809568fe000 task.ti: ffff8809568fe000
RIP: 0010:[<ffffffff810a90db>]  [<ffffffff810a90db>] __srcu_read_unlock+0x1b/0x20
RSP: 0018:ffff8809568ffd18  EFLAGS: 00000246
RAX: 000060f680800ee0 RBX: ffffffffa097e2a5 RCX: 0000000000000000
RDX: 000000000000401c RSI: 000060f680800ee0 RDI: ffff8809359c0040
RBP: ffff8809568ffd18 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212123fd8 R12: 0000000000000001
R13: ffff880212123fd8 R14: 0000000000000000 R15: ffff8809568ffcf8
FS:  00007f0ad5c69700(0000) GS:ffff88097f320000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff8809568ffda8 ffffffffa0825906 ffff880212123fd8 000000ef00000001
 00000000800000ef ffff880931754b40 ffff8809359c0040 0000000000000001
 ffff8809568fffd8 ffff880933e48390 ffff8809568ffd78 ffffffffa083fdb1
Call Trace:
 [<ffffffffa0825906>] vcpu_enter_guest+0x376/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff810ba4b5>] ? futex_wake+0xa5/0x150
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 34 ca 48 83 c6 01 48 89 34 ca 5d c3 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 0f ae f0 48 8b 47 08 48 63 f6 48 8d 34 f0 65 48 ff 0e <5d> c3 0f 1f 00 66 66 66 66 90 55 8b 07 48 89 e5 5d c3 0f 1f 00 
BUG: soft lockup - CPU#3 stuck for 22s! [qemu-kvm:2596]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 3 PID: 2596 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880935a26350 ti: ffff880934038000 task.ti: ffff880934038000
RIP: 0010:[<ffffffff810a90d0>]  [<ffffffff810a90d0>] __srcu_read_unlock+0x10/0x20
RSP: 0018:ffff880934039d18  EFLAGS: 00000282
RAX: 000060f680800ee0 RBX: ffffffffa097e2a5 RCX: 0000000000000000
RDX: 000000000000401c RSI: 0000000000000000 RDI: ffff8809359c0040
RBP: ffff880934039d18 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212295fd8 R12: 0000000000000001
R13: ffff880934039d08 R14: 0000000000000002 R15: ffff880934039cf8
FS:  00007f0aa3fff700(0000) GS:ffff88097f260000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffff880934039da8 ffffffffa0825906 ffff880212295fd8 0000000000000001
 00000000800000ef 0000000000000000 0000000000000888 ffff880936757000
 ffff880955557580 0000000000000000 ffff8809359c0040 ffffffffffffff10
Call Trace:
 [<ffffffffa0825906>] vcpu_enter_guest+0x376/0x7e0 [kvm]
 [<ffffffff810a90cc>] ? __srcu_read_unlock+0xc/0x20
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffff8105dcef>] ? __set_current_blocked+0x3f/0x60
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff810ba4b5>] ? futex_wake+0xa5/0x150
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffffa081a3c4>] ? kvm_on_user_return+0x64/0x70 [kvm]
 [<ffffffff8111ebdd>] ? fire_user_return_notifiers+0x3d/0x50
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 25 a8 cd 00 00 48 83 c1 02 48 8b 34 ca 48 83 c6 01 48 89 34 ca 5d c3 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 0f ae f0 48 8b 47 08 <48> 63 f6 48 8d 34 f0 65 48 ff 0e 5d c3 0f 1f 00 66 66 66 66 90 
BUG: soft lockup - CPU#10 stuck for 22s! [qemu-kvm:2593]
Modules linked in: fuse ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables bridge stp lockd llc vfat fat ext4 jbd2 dm_mirror dm_region_hash dm_log dm_mod raid1 vhost_net macvtap cdc_ether macvlan vhost tun iTCO_wdt iTCO_vendor_support lpc_ich i7core_edac bnx2 usbnet sunrpc kvm_intel ioatdma i2c_i801 ipmi_si ipmi_msghandler kvm dca acpi_cpufreq mfd_core shpchp i2c_core edac_core serio_raw microcode mii pcspkr sg uinput ipv6 autofs4 ext3 jbd mbcache sd_mod sr_mod cdrom crc_t10dif crct10dif_common megaraid_sas ata_piix
CPU: 10 PID: 2593 Comm: qemu-kvm Not tainted 3.13.0+ #374
Hardware name: IBM System x3650 M3 -[794582A]-/94Y7614, BIOS -[D6E154AUS-1.13]- 09/23/2011
task: ffff880954f9af40 ti: ffff880931674000 task.ti: ffff880931674000
RIP: 0010:[<ffffffffa097d730>]  [<ffffffffa097d730>] vmx_cancel_injection+0x0/0x50 [kvm_intel]
RSP: 0018:ffff880931675d20  EFLAGS: 00000212
RAX: 0000000000000001 RBX: ffff880931668040 RCX: 0000000000000002
RDX: ffffffffa0993ea0 RSI: 00000000553eb4d0 RDI: ffff880931668040
RBP: ffff880931675da8 R08: 0000000000000000 R09: 00000000800000ef
R10: 0000000000000001 R11: ffff880212217fd8 R12: ffffffffa097e2a5
R13: ffff880931675cc8 R14: 0000000000000000 R15: 00000000800000ef
FS:  00007f0ac5ffb700(0000) GS:ffff88097f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000ffffffff CR3: 00000009310cb000 CR4: 00000000000027e0
Stack:
 ffffffffa0825aaf ffff880212217fd8 000000ef00000001 00000000800000ef
 ffff88093145e480 ffff8809359c0040 0000000000000001 ffff880931675fd8
 ffff880954f9af40 ffff880931675d78 ffffffffa083fdb1 ffff880931675d98
Call Trace:
 [<ffffffffa0825aaf>] ? vcpu_enter_guest+0x51f/0x7e0 [kvm]
 [<ffffffffa083fdb1>] ? kvm_apic_local_deliver+0x51/0x70 [kvm]
 [<ffffffffa0825f08>] __vcpu_run+0x198/0x230 [kvm]
 [<ffffffffa082603d>] kvm_arch_vcpu_ioctl_run+0x9d/0x170 [kvm]
 [<ffffffffa080e4ba>] kvm_vcpu_ioctl+0x41a/0x5f0 [kvm]
 [<ffffffff811906f5>] do_vfs_ioctl+0x75/0x2b0
 [<ffffffff810bc052>] ? SyS_futex+0x142/0x1a0
 [<ffffffff811909c1>] SyS_ioctl+0x91/0xb0
 [<ffffffff81569dd2>] system_call_fastpath+0x16/0x1b
Code: 63 d1 0f 78 d0 48 89 c2 41 0f b6 f1 e8 ea 23 ea ff 5d c3 0f 1f 84 00 00 00 00 00 41 0f b6 f1 e8 77 22 ea ff 5d c3 0f 1f 44 00 00 <66> 66 66 66 90 55 ba 16 40 00 00 48 89 e5 0f 78 d0 85 c0 c6 87 


#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 3.13.0 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
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
# CONFIG_LOCALVERSION_AUTO is not set
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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

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
# CONFIG_NO_HZ_FULL is not set
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
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=19
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
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
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
CONFIG_MODULE_SIG_SHA1=y
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha1"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_HYPERVISOR_GUEST is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=m
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

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
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
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
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=m
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_ZONES is not set
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_LED=m
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=m
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=m
# CONFIG_IP_SET_HASH_NETNET is not set
CONFIG_IP_SET_HASH_NETPORT=m
# CONFIG_IP_SET_HASH_NETIFACE is not set
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
# CONFIG_IP_VS_NFCT is not set
# CONFIG_IP_VS_PE_SIP is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_SYNPROXY is not set
CONFIG_IP_NF_TARGET_ULOG=m
# CONFIG_NF_NAT_IPV4 is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
# CONFIG_IP6_NF_MATCH_RPFILTER is not set
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
# CONFIG_IP6_NF_TARGET_SYNPROXY is not set
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
# CONFIG_NF_NAT_IPV6 is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=m
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_6LOWPAN is not set
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_INGRESS=m
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_CLS_BPF is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
# CONFIG_NET_EMATCH_IPSET is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
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
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_LEDS is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
# CONFIG_CAN_EMS_PCMCIA is not set
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_PEAK_PCMCIA is not set
# CONFIG_CAN_PEAK_PCI is not set
CONFIG_CAN_KVASER_PCI=m
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_SOFTING is not set
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_RDMA=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
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
CONFIG_REGMAP_I2C=m
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
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
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=m
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_OSD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

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
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
# CONFIG_SCSI_MVSAS_TASKLET is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_BFA_FC=m
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=m
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_HIGHBANK is not set
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
# CONFIG_SATA_RCAR is not set
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
# CONFIG_PATA_ARASAN_CF is not set
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=m
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
# CONFIG_ISCSI_TARGET is not set
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=m
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_VXLAN is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_SUNGEM_PHY=m
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_3C589=m
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=m
CONFIG_PCNET32=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=m
CONFIG_VXGE=m
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IGB=m
CONFIG_IGB_HWMON=y
CONFIG_IGB_DCA=y
CONFIG_IGBVF=m
CONFIG_IXGB=m
CONFIG_IXGBE=m
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_IP1000=m
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
CONFIG_FEALNX=m
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=m
CONFIG_NS83820=m
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=m
CONFIG_NE2K_PCI=m
CONFIG_PCMCIA_PCNET=m
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=m
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLGE=m
CONFIG_NETXEN_NIC=m
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=m
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=m
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=m
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=m
CONFIG_SIS190=m
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=m
CONFIG_EPIC100=m
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NIU=m
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=m
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=m
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_VELOCITY=m
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_LIBERTAS_THINFIRM=m
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM_USB=m
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
CONFIG_MWL8K=m
# CONFIG_ATH_CARDS is not set
CONFIG_B43=m
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m
# CONFIG_IWLMVM is not set
CONFIG_IWLWIFI_OPMODE_MODULAR=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m

#
# iwl3945 / iwl4965 Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
# CONFIG_RT2800PCI is not set
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_MMIO=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL_TI is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
# CONFIG_MWIFIEX is not set
# CONFIG_CW1200 is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m
CONFIG_VMXNET3=m
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
# CONFIG_GIGASET_CAPI is not set
CONFIG_GIGASET_I4L=y
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

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
CONFIG_KEYBOARD_ADP5588=m
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
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=m
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
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
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2007=m
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

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
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

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
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

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
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_KGDB_NMI is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_ADP5588 is not set

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
# CONFIG_GPIO_MCP23S08 is not set

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
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
# CONFIG_SND_ASIHPI is not set
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
# CONFIG_SND_ES1968_INPUT is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_PREALLOC_SIZE=512
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
# CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
# CONFIG_SND_LOLA is not set
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
# CONFIG_SND_MAESTRO3_INPUT is not set
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_USB_HIFACE is not set
CONFIG_SND_FIREWIRE=y
# CONFIG_SND_DICE is not set
# CONFIG_SND_FIREWIRE_SPEAKERS is not set
# CONFIG_SND_ISIGHT is not set
# CONFIG_SND_SCS1X is not set
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_SONY_FF is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=m
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=m
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_QIB=m
CONFIG_INFINIBAND_QIB_DCA=y
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_INFINIBAND_CXGB4=m
CONFIG_MLX4_INFINIBAND=m
# CONFIG_MLX5_INFINIBAND is not set
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
# CONFIG_INFINIBAND_SRPT is not set
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=m
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_PANEL is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
CONFIG_NET_VENDOR_SILICOM=y
# CONFIG_SBYPASS is not set
# CONFIG_BPCTL is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_USB_BTMTK is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACERHDF is not set
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
# CONFIG_DELL_WMI_AIO is not set
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_IDEAPAD_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
# CONFIG_AMD_IOMMU_V2 is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
# CONFIG_NFS_V4_2 is not set
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_OBJLAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_FSCACHE=y
CONFIG_NFS_USE_LEGACY_DNS=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_V4_SECURITY_LABEL is not set
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SMB2 is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

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
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
# CONFIG_KGDB_LOW_LEVEL_TRAP is not set
# CONFIG_KGDB_KDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=m
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
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
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_KVM_DEVICE_ASSIGNMENT=y
CONFIG_BINARY_PRINTF=y

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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

