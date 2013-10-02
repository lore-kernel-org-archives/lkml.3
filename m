Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3JBRdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:33:24 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:26294 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754116Ab3JBRdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:33:06 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, linux-pci@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux390@de.ibm.com, linux-s390@vger.kernel.org, x86@kernel.org,
        linux-ide@vger.kernel.org, iss_storagedev@hp.com,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement pattern
Date: Wed,  2 Oct 2013 12:48:16 +0200
Message-Id: <cover.1380703262.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is against "next" branch in Bjorn's repo:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

Currently pci_enable_msi_block() and pci_enable_msix() interfaces
return a error code in case of failure, 0 in case of success and a
positive value which indicates the number of MSI-X/MSI interrupts
that could have been allocated. The latter value should be passed
to a repeated call to the interfaces until a failure or success:


	for (i = 0; i < FOO_DRIVER_MAXIMUM_NVEC; i++)
		adapter->msix_entries[i].entry = i;

	while (nvec >= FOO_DRIVER_MINIMUM_NVEC) {
		rc = pci_enable_msix(adapter->pdev,
				     adapter->msix_entries, nvec);
		if (rc > 0)
			nvec = rc;
		else
			return rc;
	}

	return -ENOSPC;


This technique proved to be confusing and error-prone. Vast share
of device drivers simply fail to follow the described guidelines.

This update converts pci_enable_msix() and pci_enable_msi_block()
interfaces to canonical kernel functions and makes them return a
error code in case of failure or 0 in case of success.

As result, device drivers will cease to use the overcomplicated
repeated fallbacks technique and resort to a straightforward
pattern - determine the number of MSI/MSI-X interrupts required
before calling pci_enable_msi_block() and pci_enable_msix()
interfaces:


	rc = pci_msix_table_size(adapter->pdev);
	if (rc < 0)
		return rc;

	nvec = min(nvec, rc);
	if (nvec < FOO_DRIVER_MINIMUM_NVEC) {
		return -ENOSPC;

	for (i = 0; i < nvec; i++)
		adapter->msix_entries[i].entry = i;

	rc = pci_enable_msix(adapter->pdev,
			     adapter->msix_entries, nvec);
	return rc;


Device drivers will use their knowledge of underlying hardware
to determine the number of MSI/MSI-X interrupts required.

The simplest case would be requesting all available interrupts -
to obtain that value device drivers will use pci_get_msi_cap()
interface for MSI and pci_msix_table_size() for MSI-X.

More complex cases would entail matching device capabilities
to the system environment, i.e. limiting number of hardware
queues (and hence associated MSI/MSI-X interrupts) to the number
of online CPUs.

Device drivers using MSI/MSI-X could be divided in three groups:
- drivers that request a hardcoded number of interrupts;
- drivers that request a number of interrupts using one call to
  pci_enable_msix() and then enable MSI/MSI-X using a follow-up
  to pci_enable_msix();
- drivers that fully follow the guidelines and repeatedly call
  pci_enable_msix() in a loop;
This series converts to the new technique second and third groups.

To simplify device drivers code review I tried to make as little
changes as possible - the scope of this series is an introduction
of the new technique rather than clean-up effort for all drivers
affected.

The testing was very limited - I ensured successful booting on
all affected architectures except MIPS and operation of few
devices with and without pci=nomsi kernel parameter.

There is a ongoing discussion about impact of this update on
PowerPC pSeries platform. I am going to incorporate the outcome
of this discussion into the next version. Yet, the rest of the
platforms and the vast majority of device drivers already can
start getting initial reviews.

Patches 5,6,8	- update of the generic MSI code
Patch 7		- update of architectures affected
Patches 9-77	- bugfixes and updates of device drivers affected

The tree could be found in "pci-next-msi-v1" branch in repo:
https://github.com/a-gordeev/linux.git

Alexander Gordeev (77):
  PCI/MSI: Fix return value when populate_msi_sysfs() failed
  PCI/MSI/PPC: Fix wrong RTAS error code reporting
  PCI/MSI/s390: Fix single MSI only check
  PCI/MSI/s390: Remove superfluous check of MSI type
  PCI/MSI: Convert pci_msix_table_size() to a public interface
  PCI/MSI: Factor out pci_get_msi_cap() interface
  PCI/MSI: Re-design MSI/MSI-X interrupts enablement pattern
  PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
  ahci: Update MSI/MSI-X interrupts enablement code
  ahci: Check MRSM bit when multiple MSIs enabled
  benet: Return -ENOSPC when not enough MSI-Xs available
  benet: Update MSI/MSI-X interrupts enablement code
  bna: Update MSI/MSI-X interrupts enablement code
  bnx2x: Update MSI/MSI-X interrupts enablement code
  bnx2: Update MSI/MSI-X interrupts enablement code
  cciss: Update MSI/MSI-X interrupts enablement code
  cciss: Update a misleading comment on interrupt usage
  cciss: Fallback to single MSI mode in case MSI-X failed
  csiostor: Do not call pci_disable_msix() if pci_enable_msix() failed
  csiostor: Return -ENOSPC when not enough MSI-X vectors available
  csiostor: Update MSI/MSI-X interrupts enablement code
  cxgb3: Do not call pci_disable_msix() if pci_enable_msix() failed
  cxgb3: Return -ENOSPC when not enough MSI-X vectors available
  cxgb3: Update MSI/MSI-X interrupts enablement code
  cxgb4: Return -ENOSPC when not enough MSI-X vectors available
  cxgb4: Update MSI/MSI-X interrupts enablement code
  cxgb4vf: Do not call pci_disable_msix() if pci_enable_msix() failed
  cxgb4vf: Return -ENOSPC when not enough MSI-X vectors available
  cxgb4vf: Update MSI/MSI-X interrupts enablement code
  hpsa: Update a misleading comment on interrupt usage
  hpsa: Update MSI/MSI-X interrupts enablement code
  hpsa: Fallback to single MSI mode in case MSI-X failed
  ioat: Disable MSI-X in case request of IRQ failed
  ioat: Update MSI/MSI-X interrupts enablement code
  ipr: Do not call pci_disable_msi/msix() if pci_enable_msi/msix()
    failed
  ipr: Enable MSI-X when IPR_USE_MSIX type is set, not IPR_USE_MSI
  ipr: Update MSI/MSI-X interrupts enablement code
  ixgbe: Update MSI/MSI-X interrupts enablement code
  ixgbevf: Return -ENOSPC when not enough MSI-X vectors available
  ixgbevf: Update MSI/MSI-X interrupts enablement code
  lpfc: Do not call pci_disable_msix() if pci_enable_msix() failed
  lpfc: Update MSI/MSI-X interrupts enablement code
  lpfc: Return -ENOSPC when not enough MSI-X vectors available
  lpfc: Make MSI-X initialization routine more readable
  megaraid: Update MSI/MSI-X interrupts enablement code
  mlx4: Update MSI/MSI-X interrupts enablement code
  mlx5: Fix memory leak in case not enough MSI-X vectors available
  mlx5: Return -ENOSPC when not enough MSI-X vectors available
  mlx5: Fix minimum number of MSI-Xs
  mlx5: Update MSI/MSI-X interrupts enablement code
  mthca: Update MSI/MSI-X interrupts enablement code
  niu: Update MSI/MSI-X interrupts enablement code
  ntb: Fix missed call to pci_enable_msix()
  ntb: Ensure number of MSIs on SNB is enough for the link interrupt
  ntb: Update MSI/MSI-X interrupts enablement code
  nvme: Update MSI/MSI-X interrupts enablement code
  pmcraid: Update MSI/MSI-X interrupts enablement code
  qib: Update MSI/MSI-X interrupts enablement code
  qla2xxx: Update MSI/MSI-X interrupts enablement code
  qlcnic: Return -ENOSPC when not enough MSI-X vectors available
  qlogic: Return -EINVAL in case MSI-X is not supported
  qlcnic: Remove redundant return operator
  qlcnic: Update MSI/MSI-X interrupts enablement code
  qlcnic: Make MSI-X initialization routine bit more readable
  qlge: Remove a redundant assignment
  qlge: Update MSI/MSI-X interrupts enablement code
  rapidio: Update MSI/MSI-X interrupts enablement code
  sfc: Update MSI/MSI-X interrupts enablement code
  tg3: Update MSI/MSI-X interrupts enablement code
  vmci: Update MSI/MSI-X interrupts enablement code
  vmxnet3: Return -EINVAL if number of requested MSI-Xs is not enough
  vmxnet3: Fixup a weird loop exit
  vmxnet3: Return -ENOSPC when not enough MSI-X vectors available
  vmxnet3: Limit number of rx queues to 1 if per-queue MSI-Xs failed
  vmxnet3: Update MSI/MSI-X interrupts enablement code
  vxge: Sanitize MSI-X allocation routine error codes
  vxge: Update MSI/MSI-X interrupts enablement code

 Documentation/PCI/MSI-HOWTO.txt                    |  123 +++++++++++---------
 arch/mips/pci/msi-octeon.c                         |    2 +-
 arch/powerpc/kernel/msi.c                          |    2 +-
 arch/powerpc/platforms/pseries/msi.c               |    4 +-
 arch/s390/pci/pci.c                                |    2 +-
 arch/x86/kernel/apic/io_apic.c                     |    2 +-
 drivers/ata/ahci.c                                 |   71 ++++++++---
 drivers/ata/ahci.h                                 |    1 +
 drivers/block/cciss.c                              |   22 ++--
 drivers/block/nvme-core.c                          |   48 ++++----
 drivers/dma/ioat/dma.c                             |   11 ++-
 drivers/infiniband/hw/mthca/mthca_main.c           |   16 ++-
 drivers/infiniband/hw/qib/qib_pcie.c               |    4 -
 drivers/misc/vmw_vmci/vmci_guest.c                 |   22 +++-
 drivers/net/ethernet/broadcom/bnx2.c               |   27 +++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   54 ++++-----
 drivers/net/ethernet/broadcom/tg3.c                |   24 ++--
 drivers/net/ethernet/brocade/bna/bnad.c            |   34 +++---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   32 +++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   62 ++++++----
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   49 +++++---
 drivers/net/ethernet/emulex/benet/be_main.c        |   36 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |   62 +++++-----
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   18 +--
 drivers/net/ethernet/mellanox/mlx4/main.c          |   17 ++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   17 ++--
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   38 +++----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |  108 +++++++++--------
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |   40 +++----
 drivers/net/ethernet/sfc/efx.c                     |   18 ++-
 drivers/net/ethernet/sun/niu.c                     |   20 ++--
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   84 +++++++-------
 drivers/ntb/ntb_hw.c                               |   37 ++----
 drivers/ntb/ntb_hw.h                               |    2 -
 drivers/pci/msi.c                                  |   93 +++++----------
 drivers/pci/pcie/portdrv_core.c                    |    2 +
 drivers/rapidio/devices/tsi721.c                   |   27 +++--
 drivers/scsi/csiostor/csio_isr.c                   |   20 ++--
 drivers/scsi/hpsa.c                                |   35 +++---
 drivers/scsi/ipr.c                                 |   52 ++++-----
 drivers/scsi/lpfc/lpfc_init.c                      |   40 ++++---
 drivers/scsi/megaraid/megaraid_sas_base.c          |   20 ++--
 drivers/scsi/pmcraid.c                             |   23 ++--
 drivers/scsi/qla2xxx/qla_isr.c                     |   18 ++-
 include/linux/pci.h                                |    7 +-
 45 files changed, 744 insertions(+), 702 deletions(-)

-- 
1.7.7.6

