Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaAVTgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:36:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50436 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAVTge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:36:34 -0500
Date: Wed, 22 Jan 2014 14:36:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: [GIT PULL] (xen) stable/for-linus-3.14-rc0-tag
Message-ID: <20140122193625.GA8827@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.14-rc0-tag

which has two major features that Xen community is excited about:
<blurb  - please include it in the merge commit>

The first is event channel scalability by David Vrabel - we switch over from an
two-level per-cpu bitmap of events (IRQs) - to an FIFO queue with priorities.
This lets us be able to handle more events, have lower latency, and better
scalability. Good stuff.

The other is PVH by Mukesh Rathor. In short, PV is a mode where the kernel lets
the hypervisor program page-tables, segments, etc. With EPT/NPT capabilities in
current processors, the overhead of doing this in an HVM (Hardware Virtual
Machine) container is much lower than the hypervisor doing it for us. In short
we let a PV guest run without doing page-table, segment, syscall, etc updates
through the hypervisor - instead it is all done within the guest container.
It is a "hybrid" PV - hence the 'PVH' name - a PV guest within an HVM container.

The major benefits are less code to deal with - for example we only
use one function from the the pv_mmu_ops (which has 39 function calls);
faster performance for syscall (no context switches into the hypervisor);
less traps on various operations; etc.

It is still being baked - the ABI is not yet set in stone. But it is
pretty awesome and we are excited about it.

Lastly, there are some changes to ARM code - you should get a simple conflict
which has been resolved in #linux-next.

In short, this pull has awesome features.

</blurb  - please include it in the merge commit>

Please pull!

 MAINTAINERS                                |    1 +
 arch/arm/include/asm/xen/page.h            |    3 +-
 arch/arm/xen/enlighten.c                   |    9 +-
 arch/x86/include/asm/xen/page.h            |    8 +-
 arch/x86/xen/Kconfig                       |    4 +
 arch/x86/xen/enlighten.c                   |  126 +-
 arch/x86/xen/grant-table.c                 |   63 +
 arch/x86/xen/irq.c                         |    5 +-
 arch/x86/xen/mmu.c                         |  166 ++-
 arch/x86/xen/p2m.c                         |   15 +-
 arch/x86/xen/platform-pci-unplug.c         |   79 +-
 arch/x86/xen/setup.c                       |   40 +-
 arch/x86/xen/smp.c                         |   49 +-
 arch/x86/xen/time.c                        |    1 +
 arch/x86/xen/xen-head.S                    |   25 +-
 arch/x86/xen/xen-ops.h                     |    1 +
 drivers/block/xen-blkfront.c               |    4 +-
 drivers/char/tpm/xen-tpmfront.c            |    4 +
 drivers/input/misc/xen-kbdfront.c          |    4 +
 drivers/net/xen-netfront.c                 |    2 +-
 drivers/pci/xen-pcifront.c                 |    4 +
 drivers/video/xen-fbfront.c                |    6 +-
 drivers/xen/Kconfig                        |    1 -
 drivers/xen/Makefile                       |    3 +-
 drivers/xen/balloon.c                      |    9 +-
 drivers/xen/dbgp.c                         |    2 +-
 drivers/xen/events.c                       | 1935 ----------------------------
 drivers/xen/events/Makefile                |    5 +
 drivers/xen/events/events_2l.c             |  372 ++++++
 drivers/xen/events/events_base.c           | 1716 ++++++++++++++++++++++++
 drivers/xen/events/events_fifo.c           |  428 ++++++
 drivers/xen/events/events_internal.h       |  150 +++
 drivers/xen/evtchn.c                       |    2 +-
 drivers/xen/gntdev.c                       |    2 +-
 drivers/xen/grant-table.c                  |   90 +-
 drivers/xen/pci.c                          |    2 +
 drivers/xen/platform-pci.c                 |   11 +-
 drivers/xen/xenbus/xenbus_client.c         |    3 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c |    2 +-
 include/xen/events.h                       |    9 +
 include/xen/grant_table.h                  |    9 +-
 include/xen/interface/elfnote.h            |   13 +
 include/xen/interface/event_channel.h      |   68 +
 include/xen/interface/xen.h                |    6 -
 include/xen/platform_pci.h                 |   25 +-
 include/xen/xen.h                          |   14 +
 46 files changed, 3379 insertions(+), 2117 deletions(-)


Ben Hutchings (1):
      xen/pci: Fix build on non-x86

David Vrabel (15):
      xen/events: refactor retrigger_dynirq() and resend_irq_on_evtchn()
      xen/events: remove unnecessary init_evtchn_cpu_bindings()
      xen/events: move drivers/xen/events.c into drivers/xen/events/
      xen/events: move 2-level specific code into its own file
      xen/events: add struct evtchn_ops for the low-level port operations
      xen/events: allow setup of irq_info to fail
      xen/events: add a evtchn_op for port setup
      xen/events: Refactor evtchn_to_irq array to be dynamically allocated
      xen/events: add xen_evtchn_mask_all()
      xen/evtchn: support more than 4096 ports
      xen/events: Add the hypervisor interface for the FIFO-based event channels
      xen/events: allow event channel priority to be set
      xen/x86: set VIRQ_TIMER priority to maximum
      xen/events: use the FIFO-based ABI if available
      MAINTAINERS: add git repository for Xen

Ian Campbell (1):
      xen: balloon: enable for ARM

Jie Liu (1):
      xen: simplify balloon_first_page() with list_first_entry_or_null()

Konrad Rzeszutek Wilk (12):
      xen/pvhvm: If xen_platform_pci=0 is set don't blow up (v4).
      xen/pvhvm: Remove the xen_platform_pci int.
      xen/pvh: Don't setup P2M tree.
      xen/mmu/p2m: Refactor the xen_pagetable_init code (v2).
      xen/mmu: Cleanup xen_pagetable_p2m_copy a bit.
      xen/grants: Remove gnttab_max_grant_frames dependency on gnttab_init.
      xen/grant-table: Refactor gnttab_init
      xen/grant: Implement an grant frame array struct (v3).
      xen/pvh: Piggyback on PVHVM for grant driver (v4)
      xen/grant-table: Force to use v1 of grants.
      xen/pvh: Fix compile issues with xen_pvh_domain()
      xen/pvh: Use 'depend' instead of 'select'.

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

Paul Gortmaker (1):
      xen: delete new instances of __cpuinit usage

Roger Pau Monne (1):
      xen/pvh: Set X86_CR0_WP and others in CR0 (v2)

Stefano Stabellini (1):
      xen/fb: allow xenfb initialization for hvm guests

Wei Liu (3):
      asm/xen/page.h: remove redundant semicolon
      xen/events: introduce test_and_set_mask()
      xen/events: replace raw bit ops with functions

Wei Yongjun (3):
      xen/pvh: remove duplicated include from enlighten.c
      xen-platform: fix error return code in platform_pci_init()
      xen/evtchn_fifo: fix error return code in evtchn_fifo_setup()

Yijing Wang (1):
      xen: Use dev_is_pci() to check whether it is pci device


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJS4B21AAoJEFjIrFwIi8fJcHkH/ieS9chu+NCtIiBecbCaDsVk
zCM36mAir+SKabwsZkSH8FrAPfqetF5wfnl/WoXOGto3ep8GjfJJv0LSfiNOtxHi
2jpKSs0NyzVb9Vd6zGeygRQXyrB5nYaBT33/hZHX3DTXbQErKPjKdeQsOzxvqSKf
kPy32q34MxMtMHO3pJnVJyzfrfl5mMiE1Xfh6yQiIr1n2KnWesCxgMOKrfpMomQF
wEPfuKJXMc09J04KXaCHwxf1TEB3J7HvnqZABdXbtODDc42RkPvslP3SO8tv5N/O
o8jikXrUReAMZRVtkzT5uvB9b6K04WoP3lfokiDxD0IvqAMuk44HCbqDNfHZXS8=
=MqO7
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
