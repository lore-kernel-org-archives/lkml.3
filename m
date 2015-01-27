Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbbA0AJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:09:22 -0500
Received: from 8bytes.org ([81.169.241.247]:51290 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403AbbA0AJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:09:16 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Will Deacon <will.deacon@arm.com>, Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [RFC PATCH 0/5] iommu: Introduce default domains for iommu groups
Date: Tue, 27 Jan 2015 01:08:54 +0100
Message-Id: <1422317339-22620-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a patch-set to add a default domain to each
iommu-group present in the system. The default domain is
used for devices that are not assigned to any other domain.

This means, when a device is detached from a domain, it
is automatically re-assigned to its default domain. These
changes make use of the domain types introduced in another
patch-set. The default domain is allocated with type
IOMMU_DOMAIN_DMA to be used in a common DMA-API implemention
later.

For now the default-domain handling is an opt-in for iommu
drivers, as some changes are required in them. First of all,
the semantics of the attach_domain callback has changed.
This callback must not fail if a device is already attached
to a domain, but just overwrite the existing attachment.
This semantic change allows to get rid of the detach_domain
callback when all drivers are converted.

A driver can enable default domains for itself by
implementing a domain_alloc callback that can return domains
of the IOMMU_DOMAIN_DMA type. But these patches only
implement domains in the core code and do not convert any
driver yet.

This patch-set also makes the difference between
attach/detach_device and attach/detach_group more explict.
With patch 3 applied, attach/detach_device will only succeed
when the device is the only one in its group. This probably
requires changes in the callers, which are not included
here.

Any useful comments and feedback appreciated.

Thanks,

	Joerg

Joerg Roedel (5):
  iommu: Add default domain to iommu-groups
  iommu: Allocate a default domain for iommu groups
  iommu: Limit iommu_attach/detach_device to devices with their own
    group
  iommu: Make sure a device is always attached to a domain
  iommu: Add iommu_get_domain_for_dev function

 drivers/iommu/iommu.c | 142 ++++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/iommu.h |   6 +++
 2 files changed, 138 insertions(+), 10 deletions(-)

-- 
1.9.1

