Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaACUeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:34:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23298 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaACU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:29:59 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com
Subject: [PATCH v13] Linux Xen PVH support (v13)
Date: Fri,  3 Jan 2014 14:38:17 -0500
Message-Id: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches, also available at

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v13

implements the neccessary functionality to boot a PV guest in PVH mode.

This blog has a great description of what PVH is:
http://blog.xen.org/index.php/2012/10/31/the-paravirtualization-spectrum-part-2-from-poles-to-a-spectrum/

These patches are based on v3.13-rc6. If I had failed to
address your review I am terrible sorry - it was an oversight.
Please poke at the patch again.

Changes since v13: [http://mid.gmane.org/1388550945-25499-1-git-send-email-konrad.wilk@oracle.com]
 - Rework per David and Stefano review.
 - Fix regression with Xen 4.1.
 - Use native_cpuid instead of xen_cpuid.

v12: [http://mid.gmane.org/1387313503-31362-1-git-send-email-konrad.wilk@oracle.com]
 - Rework per Stefano's review.
 - Split some patches up for easier review.
 - Bugs fixed.

v11 as compared to v10: [https://lkml.org/lkml/2013/12/12/625]:
 - Split patches in a more logical sense, squash some
 - Dropped Acked-by's from folks
 - Fleshed out descriptions


Regression wise - there are no bugs with Xen 4.[1,2,3,4].

That is if you compile/boot it with
CONFIG_XEN_PVH=y or "# CONFIG_XEN_PVH is not set" - in both cases as
either dom0 or domU there are no bugs. Also launched it as 32/64 bit
dom0 with 32/64 domU as PV or PVHVM, and along with SLES11, SLES12,
F15->F19 (32/64), OL5, OL6, RHEL5 (32/64) FreeBSD HVM, NetBSD PV without issues.

With Xen 4.1, there was a regression, (see
http://mid.gmane.org/20131220175735.GA619@phenom.dumpdata.com)
and it this patchset has the fix for it.


-------------------------
PARAVIRT OPS / x86_init /apic /smp ops
------------------------

The paravirt ops that are in usage are:

	pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;

These are still used:

        pv_info = xen_info;
        pv_init_ops = xen_init_ops;
        pv_apic_ops = xen_apic_ops;
        pv_time_ops = xen_time_ops;

And the x86_init,apic, and smp_ops ops are still in force.

This is just the first step so there might be some other ones
that are needed that I failed to enumerate.

The pv_cpu_ops is not used. From pv_mmu_ops only one is used.

-----------------------------
HOW TO USE IT
-----------------------------

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
  - Multiple VBDs, NICs, etc.

Things that are broken:
 - CPUID filtering. There are no filtering done at all which  means that
   certain cpuid flags are exposed to the guest. The x2apic will cause
   a crash if the NMI handler is invoked. The APERF will cause inferior
   scheduling decisions.
 
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

 arch/arm/include/asm/xen/page.h    |   1 +
 arch/arm/xen/enlighten.c           |   9 +-
 arch/x86/include/asm/xen/page.h    |   8 +-
 arch/x86/xen/Kconfig               |   5 ++
 arch/x86/xen/enlighten.c           | 100 +++++++++++++++++-----
 arch/x86/xen/grant-table.c         |  62 ++++++++++++++
 arch/x86/xen/irq.c                 |   5 +-
 arch/x86/xen/mmu.c                 | 166 +++++++++++++++++++++----------------
 arch/x86/xen/p2m.c                 |  15 +++-
 arch/x86/xen/setup.c               |  40 +++++++--
 arch/x86/xen/smp.c                 |  49 +++++++----
 arch/x86/xen/xen-head.S            |  25 +++++-
 arch/x86/xen/xen-ops.h             |   1 +
 drivers/xen/events.c               |  14 ++--
 drivers/xen/gntdev.c               |   2 +-
 drivers/xen/grant-table.c          |  87 ++++++++++++++-----
 drivers/xen/platform-pci.c         |  10 ++-
 drivers/xen/xenbus/xenbus_client.c |   3 +-
 include/xen/grant_table.h          |   9 +-
 include/xen/interface/elfnote.h    |  13 +++
 include/xen/xen.h                  |  14 ++++
 21 files changed, 483 insertions(+), 155 deletions(-)

Konrad Rzeszutek Wilk (7):
      xen/pvh: Don't setup P2M tree.
      xen/mmu/p2m: Refactor the xen_pagetable_init code (v2).
      xen/mmu: Cleanup xen_pagetable_p2m_copy a bit.
      xen/grants: Remove gnttab_max_grant_frames dependency on gnttab_init.
      xen/grant-table: Refactor gnttab_init
      xen/grant: Implement an grant frame array struct (v2).
      xen/pvh: Piggyback on PVHVM for grant driver (v4)

Mukesh Rathor (12):
      xen/p2m: Check for auto-xlat when doing mfn_to_local_pfn.
      xen/pvh/x86: Define what an PVH guest is (v3).
      xen/pvh: Early bootup changes in PV code (v4).
      xen/pvh: MMU changes for PVH (v2)
      xen/pvh/mmu: Use PV TLB instead of native.
      xen/pvh: Setup up shared_info.
      xen/pvh: Load GDT/GS in early PV bootup code for BSP.
      xen/pvh: Secondary VCPU bringup (non-bootup CPUs)
      xen/pvh: Update E820 to work with PVH (v2)
      xen/pvh: Piggyback on PVHVM for event channels (v2)
      xen/pvh: Piggyback on PVHVM XenBus.
      xen/pvh: Support ParaVirtualized Hardware extensions (v3).

