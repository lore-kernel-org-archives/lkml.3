Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaHKHPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:15:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaHKHPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:15:07 -0400
Date: Mon, 11 Aug 2014 12:43:08 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140811071308.GA4184@grmbl.mre>
References: <20140707224841.GA10101@linux.vnet.ibm.com>
 <1405085703-14822-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53E48D18.8080007@redhat.com>
 <20140808162502.GX5821@linux.vnet.ibm.com>
 <20140808173710.GA13483@grmbl.mre>
 <20140808181835.GD5821@linux.vnet.ibm.com>
 <20140808183424.GB13483@grmbl.mre>
 <20140808214347.GH5821@linux.vnet.ibm.com>
 <20140808214648.GA19058@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140808214648.GA19058@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 08 Aug 2014 [14:46:48], Paul E. McKenney wrote:
> On Fri, Aug 08, 2014 at 02:43:47PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 09, 2014 at 12:04:24AM +0530, Amit Shah wrote:
> > > On (Fri) 08 Aug 2014 [11:18:35], Paul E. McKenney wrote:
> > 
> > [ . . . ]
> > 
> > > > Hmmm... What happens if you boot a7d7a143d0b4cb1914705884ca5c25e322dba693
> > > > with the kernel parameter "acpi=off"?
> > > 
> > > That doesn't change anything - still hangs.
> > > 
> > > I intend to look at this more on Monday, though - turning in for
> > > today.  In the meantime, if there's anything else you'd like me to
> > > try, please let me know.
> > 
> > OK, given that I still cannot reproduce it, I do need your help with
> > the diagnostics.  And so what sorts of diagnostics work for you in
> > the hung state?  Are you able to dump ftrace buffers?
> > 
> > If you are able to dump ftrace buffers, please enable rcu:rcu_nocb_wake
> > and send me the resulting trace.
> 
> And another random kernel boot parameter to try is rcu_nocb_poll.

Right, this gets the boot going again:

--- /var/tmp/rcu-bad.txt  2014-08-11 12:39:53.571306488 +0530
+++ /var/tmp/rcu-good-nocb-poll.txt  2014-08-11 12:40:37.760432052 +0530
@@ -1,7 +1,7 @@
-$ qemu-kvm -m 512 -smp 1 -cpu host,+kvmclock,+x2apic -enable-kvm  -kernel ~/src/linux/arch/x86/boot/bzImage /guests/f11-auto.qcow2  -append 'root=/dev/sda2 acpi=off console=ttyS0 console=tty0'  -snapshot  -serial stdio
+$ qemu-kvm -m 512 -smp 1 -cpu host,+kvmclock,+x2apic -enable-kvm  -kernel ~/src/linux/arch/x86/boot/bzImage /guests/f11-auto.qcow2  -append 'root=/dev/sda2 acpi=off console=ttyS0 console=tty0 rcu_nocb_poll'  -snapshot  -serial stdio
 Initializing cgroup subsys cpu
 Linux version 3.16.0+ (amit@grmbl.mre) (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #80 SMP PREEMPT Fri Aug 8 22:57:35 IST 2014
-Command line: root=/dev/sda2 acpi=off console=ttyS0 console=tty0
+Command line: root=/dev/sda2 acpi=off console=ttyS0 console=tty0 rcu_nocb_poll
 e820: BIOS-provided physical RAM map:
 BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
 BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
@@ -47,14 +47,14 @@
 KVM setup async PF for cpu 0
 kvm-stealtime: cpu 0, msr 1fa0cbc0
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128903
-Kernel command line: root=/dev/sda2 acpi=off console=ttyS0 console=tty0
+Kernel command line: root=/dev/sda2 acpi=off console=ttyS0 console=tty0 rcu_nocb_poll
 PID hash table entries: 2048 (order: 2, 16384 bytes)
 Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
 xsave: enabled xstate_bv 0x7, cntxt size 0x340
 AGP: Checking aperture...
 AGP: No AGP bridge found
-Memory: 485836K/523888K available (4029K kernel code, 727K rwdata, 2184K rodata, 2872K init, 14172K bss, 38052K reserved)
+Memory: 485832K/523888K available (4029K kernel code, 727K rwdata, 2184K rodata, 2872K init, 14172K bss, 38056K reserved)
 SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
 Preemptible hierarchical RCU implementation.
 	     RCU debugfs-based tracing is enabled.
@@ -63,6 +63,7 @@
   RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
   Offload RCU callbacks from all CPUs
   Offload RCU callbacks from CPUs: 0.
+  Poll for callbacks from no-CBs CPUs.
 RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
 NO_HZ: Full dynticks CPUs: 1-3.
 NR_IRQS:4352 nr_irqs:256 16
@@ -114,3 +115,118 @@
 cpuidle: using governor ladder
 cpuidle: using governor menu
 PCI: Using configuration type 1 for base access
+ACPI: Interpreter disabled.
+vgaarb: loaded
+SCSI subsystem initialized
+pps_core: LinuxPPS API ver. 1 registered
+pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
+PTP clock support registered
+PCI: Probing PCI hardware
+PCI host bridge to bus 0000:00
+pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
+pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
+pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
+pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
+pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
+pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
+pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
+pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
+pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
+vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
+pci 0000:00:01.0: PIIX/ICH IRQ router [8086:7000]
+Switched to clocksource kvm-clock
+pnp: PnP ACPI: disabled
+NET: Registered protocol family 2
+TCP established hash table entries: 4096 (order: 3, 32768 bytes)
+TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
+TCP: Hash tables configured (established 4096 bind 4096)
+TCP: reno registered
+UDP hash table entries: 256 (order: 3, 49152 bytes)
+UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
+NET: Registered protocol family 1
+pci 0000:00:00.0: Limiting direct PCI/PCI transfers
+pci 0000:00:01.0: PIIX3: Enabling Passive Release
+pci 0000:00:01.0: Activating ISA DMA hang workarounds
+platform rtc_cmos: registered platform RTC device (no PNP device found)
+rcu-torture:--- Start of test: nreaders=1 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
+rcu-torture: Creating rcu_torture_writer task
+rcu-torture: Creating rcu_torture_fakewriter task
+rcu-torture: rcu_torture_writer task started
+rcu-torture: Creating rcu_torture_fakewriter task
+rcu-torture: rcu_torture_fakewriter task started
+rcu-torture: Creating rcu_torture_fakewriter task
+rcu-torture: rcu_torture_fakewriter task started
+rcu-torture: Creating rcu_torture_fakewriter task
+rcu-torture: rcu_torture_fakewriter task started
+rcu-torture: Creating rcu_torture_reader task
+rcu-torture: rcu_torture_fakewriter task started
+rcu-torture: Creating rcu_torture_stats task
+rcu-torture: rcu_torture_reader task started
+rcu-torture: Creating torture_shuffle task
+rcu-torture: rcu_torture_stats task started
+rcu-torture: Creating torture_stutter task
+rcu-torture: torture_shuffle task started
+rcu-torture: torture_stutter task started
+futex hash table entries: 256 (order: 3, 32768 bytes)
+audit: initializing netlink subsys (disabled)
+audit: type=2000 audit(1407740961.384:1): initialized
+HugeTLB registered 2 MB page size, pre-allocated 0 pages
+msgmni has been set to 948
+Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
+io scheduler noop registered (default)
+pci_hotplug: PCI Hot Plug PCI Core version: 0.5
+Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
+�serial8250: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
+Non-volatile memory driver v1.3
+Linux agpgart interface v0.103
+brd: module loaded
+loop: module loaded
+scsi host0: ata_piix
+scsi host1: ata_piix
+ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc040 irq 14
+ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc048 irq 15
+libphy: Fixed MDIO Bus: probed
+e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
+e1000: Copyright (c) 1999-2006 Intel Corporation.
+e1000 0000:00:03.0: found PCI INT A -> IRQ 11
+ata1.00: ATA-7: QEMU HARDDISK, 1.6.2, max UDMA/100
+ata1.00: 10485760 sectors, multi 16: LBA48 
+ata1.00: configured for MWDMA2
+ata2.00: ATAPI: QEMU DVD-ROM, 1.6.2, max UDMA/100
+ata2.00: configured for MWDMA2
+scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    2    PQ: 0 ANSI: 5
+sd 0:0:0:0: [sda] 10485760 512-byte logical blocks: (5.36 GB/5.00 GiB)
+sd 0:0:0:0: [sda] Write Protect is off
+sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
+scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.6. PQ: 0 ANSI: 5
+sr 1:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
+cdrom: Uniform CD-ROM driver Revision: 3.20
+ sda: sda1 sda2
+sd 0:0:0:0: [sda] Attached SCSI disk
+e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
+e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
+i8042: PNP: No PS/2 controller found. Probing ports directly.
+serio: i8042 KBD port at 0x60,0x64 irq 1
+serio: i8042 AUX port at 0x60,0x64 irq 12
+mousedev: PS/2 mouse device common for all mice
+input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
+pps pps0: new PPS source ktimer
+pps pps0: ktimer PPS source registered
+pps_ldisc: PPS line discipline registered
+device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
+TCP: cubic registered
+NET: Registered protocol family 17
+kmemleak: Kernel memory leak detector initialized
+kmemleak: Automatic memory scanning thread started
+EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
+EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
+EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
+VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
+debug: unmapping init [mem 0xffffffff818b7000-0xffffffff81b84fff]
+Write protecting the kernel read-only data: 8192k
+debug: unmapping init [mem 0xffff8800013f1000-0xffff8800013fffff]
+debug: unmapping init [mem 0xffff880001622000-0xffff8800017fffff]
+rcu-torture: rtc: ffffffff828fd3f0 ver: 1 tfle: 0 rta: 1 rtaf: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=250) barrier: 0/0:0
+rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
+rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
+rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0


		Amit
