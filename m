Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab3JYPDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:03:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46391 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3JYPDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:03:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Santosh.Jodh@citrix.com, JBeulich@suse.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, mukesh.rathor@oracle.com,
        xhejtman@ics.muni.cz, yuval.shaia@oracle.com
Subject: [PATCH v1] Set 1-1 P2M for PCI BARs and MCFG regions - if needed.
Date: Fri, 25 Oct 2013 11:03:19 -0400
Message-Id: <1382713401-4882-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches check and mark the P2M region (if needed) for
PCIe BARs and for MCFG regions.

The reason this is required is that anytime any driver calls ioremap_pfn
or constructs PTEs - we consult the P2M. If we find that for the PFN
the region is INVALID_P2M_ENTRY we return the 0 PFN. If we find that
for the PFN the region is IDENTITY_FRAME we ruturn the PFN (so
pfn_to_mfn(pfn) == pfn) - which makes device drivers happy.

We initially set this up when scanning the E820 and selecting the
E820_RSRV and the gaps between the E820 regions as such. But we also
have to careful as there are potential balloon regions so we can't
assume that region past the E820 is all 1-1.

There are alternative ways of solving this:
 1) Mark all regions past the E820 and past the balloon regions as
    1-1 regions. That requires some surgery in the P2M code to deal
    with the p2m_mid_missing and p2m_mid_identity (new) for the different
    levels in the tree. The code is not for the faint of heart.

 2). Assume that INVALID_P2M_ENTRY is considered 1-1. That would require
    auditing of the code and also making sure that any xen_privcmd_mmap
    calls use the m2p_add_override. However there are some
    valid cases in which we need to check for INVALID_P2M_ENTRY -
    balloon driver - that might be relaxed. However again the P2M code
    and the ABI it places are not for the faint of the heart.

As such these two patches just add extra code to set the IDENTITY_FRAME
on the BARs and for MCFG areas.


 drivers/xen/balloon.c           |  19 +++++
 drivers/xen/pci.c               | 164 +++++++++++++++++++++++++++++++++++++++-
 include/xen/balloon.h           |   1 +
 include/xen/interface/physdev.h |  11 +++
 4 files changed, 192 insertions(+), 3 deletions(-)


Konrad Rzeszutek Wilk (2):
      xen/p2m: Create identity mappings for PFNs beyound E820 and PCI BARs
      xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas and setup 1-1 P2M

