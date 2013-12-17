Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab3LQUwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:52:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28506 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3LQUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Subject: [PATCH v11] PVH support for Linux kernel.
Date: Tue, 17 Dec 2013 15:51:31 -0500
Message-Id: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches, also available at
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/pvh.v11

implements the neccessary functionality to boot a PV guest in PVH mode.

This blog has a great description of what PVH is:
http://blog.xen.org/index.php/2012/10/31/the-paravirtualization-spectrum-part-2-from-poles-to-a-spectrum/

These patches are based on v3.13-rc4 + stable/for-linus-3.13 (which should
go out Wednesday).

Changelog of v11 as compared to v10: [https://lkml.org/lkml/2013/12/12/625]:
 - Split patches in a more logical sense, squash some
 - Dropped Acked-by's from folks
 - Fleshed out descriptions

Regression wise - there are no bugs. That is if you compile/boot it with
CONFIG_XEN_PVH=y or "# CONFIG_XEN_PVH is not set" - in both cases as
either dom0 or domU there are no bugs. Also launched it as 32/64 bit
dom0 with 32/64 domU as PV or PVHVM, and along with SLES11, SLES12,
F15->F19 (32/64), OL5, OL6, RHEL5 (32/64) FreeBSD HVM, NetBSD PV without issues.

The only things needed to make this work as PVH are:

 0) Get the latest version of Xen and compile/install it.
    See http://wiki.xen.org/wiki/Compiling_Xen_From_Source for details

 1) Clone above mentioned tree

    See http://wiki.xenproject.org/wiki/Mainline_Linux_Kernel_Configs#Configuring_the_Kernel
    for details. The steps are:

	cd $HOME
	git clone  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git linux
	cd linux
	git checkout origin/stable/pvh.v11

 2) Compile with CONFIG_XEN_PVH=y

    a) From scratch:

	make defconfig
	make menuconfig
	Processor type and features  --->  Linux guest support  --->
		 Paravirtualization layer for spinlocks
		 Xen guest support	(which will now show you:)
		 Support for running as a PVH guest (NEW)

	in case you like to edit .config, it is:

	CONFIG_HYPERVISOR_GUEST=y
	CONFIG_PARAVIRT=y
	CONFIG_PARAVIRT_GUEST=y
	CONFIG_PARAVIRT_SPINLOCKS=y
	CONFIG_XEN=y
	CONFIG_XEN_PVH=y

	You will also have to enable the block, network drivers, console, etc
	which are in different submenus.

    b). Based on your current distro.

	cp /boot/config-`uname -r` $HOME/linux/.config
	make menuconfig
	Processor type and features  --->  Linux guest support  --->
		 Support for running as a PVH guest (NEW)

 3) Launch it with 'pvh=1' in your guest config (for example):

	extra="console=hvc0 debug  kgdboc=hvc0 nokgdbroundup  initcall_debug debug"
	kernel="/mnt/lab/latest/vmlinuz"
	ramdisk="/mnt/lab/latest/initramfs.cpio.gz"
	memory=1024
	vcpus=4
	name="pvh"
	vif = [ 'mac=00:0F:4B:00:00:68, bridge=switch' ]
	vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
	disk=['phy:/dev/sdb1,xvda,w']
	pvh=1
	on_reboot="preserve"
	on_crash="preserve"
	on_poweroff="preserve"

    using 'xl'. Xend 'xm' does not have PVH support.

It will bootup as a normal PV guest, but 'xen-detect' will report it as an HVM
guest.

The functionality that is turned off is:
 - VCPU hotplug. You can try it but it should not allow you to do it.
   So 'echo 0 > /sys/bus/cpu/devices/cpu4/online' will error out.


Items that have not been tested extensively or at all:
  - Migration (xl save && xl restore for example).

  - 32-bit guests (won't even present you with a CONFIG_XEN_PVH option)

  - PCI passthrough

  - Running it in dom0 mode (as the patches for that are not yet in Xen upstream).
    If you want to try that, you can merge/pull Mukesh's branch:

	cd $HOME/xen
	git pull git://oss.oracle.com/git/mrathor/xen.git dom0pvh-v6

    .. and use this bootup parameter ("dom0pvh=1"). Remember to recompile
    and install the new version of Xen. This patchset
    does not contain the patches neccessary to setup guests - but I can
    create one easily enough. 

  - Memory ballooning
.
  - Multiple VBDs, NICs, etc.

If you encounter errors, please email with the following (pls note that the
guest config has 'on_reboot="preserve", on_crash="preserve" - which you should
have in your guest config to contain the memory of the guest):

 a) xl dmesg
 b) xl list
 c) xenctx -s $HOME/linux/System.map -f -a -C <domain id>
    [xenctx is sometimes found in  /usr/lib/xen/bin/xenctx ]
 d) the console output from the guest
 e) Anything else you can think off.

Stash away your vmlinux file (it is too big to send via email) - as I might
need it later on.

That is it!

Thank you!

 arch/x86/include/asm/xen/page.h    |   7 ++-
 arch/x86/xen/Kconfig               |   8 +++
 arch/x86/xen/enlighten.c           | 112 +++++++++++++++++++++++++++++--------
 arch/x86/xen/irq.c                 |   5 +-
 arch/x86/xen/mmu.c                 |  35 ++++++++++--
 arch/x86/xen/p2m.c                 |  12 +++-
 arch/x86/xen/setup.c               |  37 +++++++++---
 arch/x86/xen/smp.c                 |  49 ++++++++++------
 arch/x86/xen/xen-head.S            |   8 ++-
 arch/x86/xen/xen-ops.h             |   1 +
 drivers/xen/cpu_hotplug.c          |   4 +-
 drivers/xen/events.c               |   5 ++
 drivers/xen/gntdev.c               |   2 +-
 drivers/xen/grant-table.c          |  80 +++++++++++++++++++++++---
 drivers/xen/platform-pci.c         |   2 +-
 drivers/xen/xenbus/xenbus_client.c |   3 +-
 include/xen/grant_table.h          |   2 +-
 include/xen/xen.h                  |   8 +++
 18 files changed, 312 insertions(+), 68 deletions(-)


Konrad Rzeszutek Wilk (2):
      xen/pvh: Don't setup P2M tree.
      xen/pvh: Piggyback on PVHVM for grant driver.

Mukesh Rathor (10):
      xen/p2m: Check for auto-xlat when doing mfn_to_local_pfn.
      xen/pvh: Define what an PVH guest is.
      xen/pvh: Early bootup changes in PV code.
      xen/pvh: Update E820 to work with PVH
      xen/pvh: Load GDT/GS in early PV bootup code for BSP.
      xen/pvh: Secondary VCPU bringup (non-bootup CPUs)
      xen/pvh: MMU changes for PVH
      xen/pvh: Piggyback on PVHVM XenBus and event channels for PVH.
      xen/pvh: Disable PV code that does not work with PVH.
      xen/pvh: Support ParaVirtualized Hardware extensions.

