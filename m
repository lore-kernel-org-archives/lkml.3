Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaAAEiw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:38:52 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18508 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaAAEhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:37:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com
Subject: [PATCH v12] Linux Xen PVH support.
Date: Tue, 31 Dec 2013 23:35:27 -0500
Message-Id: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches, also available at
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v12

implements the neccessary functionality to boot a PV guest in PVH mode.

This blog has a great description of what PVH is:
http://blog.xen.org/index.php/2012/10/31/the-paravirtualization-spectrum-part-2-from-poles-to-a-spectrum/

These patches are based on v3.13-rc6.

Changelog of v12: [http://mid.gmane.org/1387313503-31362-1-git-send-email-konrad.wilk@oracle.com]
 - Rework per Stefano's review.
 - Split some patches up for easier review.
 - Bugs fixed.

Changelog of v11 as compared to v10: [https://lkml.org/lkml/2013/12/12/625]:
 - Split patches in a more logical sense, squash some
 - Dropped Acked-by's from folks
 - Fleshed out descriptions

Regression wise - there are no bugs with Xen 4.2 and Xen 4.3.

That is if you compile/boot it with
CONFIG_XEN_PVH=y or "# CONFIG_XEN_PVH is not set" - in both cases as
either dom0 or domU there are no bugs. Also launched it as 32/64 bit
dom0 with 32/64 domU as PV or PVHVM, and along with SLES11, SLES12,
F15->F19 (32/64), OL5, OL6, RHEL5 (32/64) FreeBSD HVM, NetBSD PV without issues.

With Xen 4.1, there is a regression, (see
http://mid.gmane.org/20131220175735.GA619@phenom.dumpdata.com)
and it is unclear at just time what the right way to fix the PVH ABI
to work around it. When that has been cleared up, some of the patches:

 [PATCH v12 02/18] xen/pvh/x86: Define what an PVH guest is (v2).
 [PATCH v12 03/18] xen/pvh: Early bootup changes in PV code (v2).
 [PATCH v12 07/18] xen/pvh: Setup up shared_info.
 [PATCH v12 11/18] xen/pvh: Piggyback on PVHVM for event channels (v2)
 [PATCH v12 18/18] xen/pvh: Support ParaVirtualized Hardware

will have to be reworked.

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

 arch/arm/xen/enlighten.c           |   9 +-
 arch/x86/include/asm/xen/page.h    |   7 +-
 arch/x86/xen/Kconfig               |   8 ++
 arch/x86/xen/enlighten.c           | 115 ++++++++++++++++++++------
 arch/x86/xen/grant-table.c         |  64 +++++++++++++++
 arch/x86/xen/irq.c                 |   5 +-
 arch/x86/xen/mmu.c                 | 164 ++++++++++++++++++++++---------------
 arch/x86/xen/p2m.c                 |  15 +++-
 arch/x86/xen/setup.c               |  41 ++++++++--
 arch/x86/xen/smp.c                 |  49 +++++++----
 arch/x86/xen/xen-head.S            |   8 +-
 arch/x86/xen/xen-ops.h             |   1 +
 drivers/xen/cpu_hotplug.c          |   4 +-
 drivers/xen/events.c               |  16 ++--
 drivers/xen/gntdev.c               |   2 +-
 drivers/xen/grant-table.c          |  76 ++++++++++++-----
 drivers/xen/platform-pci.c         |  10 ++-
 drivers/xen/xenbus/xenbus_client.c |   3 +-
 include/xen/grant_table.h          |   9 +-
 include/xen/xen.h                  |  14 ++++
 20 files changed, 462 insertions(+), 158 deletions(-)

Konrad Rzeszutek Wilk (6):
      xen/pvh: Don't setup P2M tree.
      xen/mmu/p2m: Refactor the xen_pagetable_init code.
      xen/grants: Remove gnttab_max_grant_frames dependency on gnttab_init.
      xen/grant-table: Refactor gnttab_init
      xen/grant: Implement an grant frame array struct.
      xen/pvh: Piggyback on PVHVM for grant driver (v2)

Mukesh Rathor (12):
      xen/p2m: Check for auto-xlat when doing mfn_to_local_pfn.
      xen/pvh/x86: Define what an PVH guest is (v2).
      xen/pvh: Early bootup changes in PV code (v2).
      xen/pvh: MMU changes for PVH (v2)
      xen/pvh: Setup up shared_info.
      xen/pvh: Load GDT/GS in early PV bootup code for BSP.
      xen/pvh: Secondary VCPU bringup (non-bootup CPUs)
      xen/pvh: Update E820 to work with PVH (v2)
      xen/pvh: Piggyback on PVHVM for event channels (v2)
      xen/pvh: Piggyback on PVHVM XenBus.
      xen/pvh/arm/arm64: Disable PV code that does not work with PVH (v2)
      xen/pvh: Support ParaVirtualized Hardware extensions (v2).

