Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbaISQDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:03:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbaISQDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:03:07 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] iommu: Fix regression in IOMMU grouping
To: joro@8bytes.org, iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mstowe@redhat.com
Date: Fri, 19 Sep 2014 10:03:00 -0600
Message-ID: <20140919154944.14485.743.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had surprisingly little fallout from the DMA alias changes, but
unfortunately one regression has popped up.  We have an AMD system
that seems to use the SATA controller to master transactions for the
legacy IDE controller and they are different slots on the root complex.
The IVRS reports 00:11.0 (SATA) as an alias from 00:14.1 (IDE), which
doesn't work with the new, converged PCI IOMMU grouping code, where
we've made a simplifying assumption that aliases will be to the same
slot.

To fix this, we need to rip out that assumption and write the alias
search code that I was unable to come up with previously.  I think
this can now do the chaining of aliases, which I referenced in the
removed comments.  Any sort of multi-level aliases are exceptionally
unlikely, but I think this code can now handle whatever firmware and
alias quirks can throw at it.

I know this is late for 3.17, but this is a regression from the prior
code.  If reviews and testing can give us the confidence to put it in
for 3.17, that would be my preference.  I've also marked it for stable
in case we want to loop back through that way.  Thanks,

Alex

---

Alex Williamson (2):
      iommu/amd: Split init_iommu_group() from iommu_init_device()
      iommu: Rework iommu_group_get_for_pci_dev()


 drivers/iommu/amd_iommu.c |   27 ++++---
 drivers/iommu/iommu.c     |  163 +++++++++++++++++++++++++++------------------
 2 files changed, 109 insertions(+), 81 deletions(-)
