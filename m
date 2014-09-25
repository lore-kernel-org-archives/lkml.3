Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaIYPPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:15:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbaIYPPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:15:53 -0400
Message-ID: <1411658144.25340.75.camel@deneb.redhat.com>
Subject: Re: [PATCH] iommu/core: fix bus notifier breakage
From: Mark Salter <msalter@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Date: Thu, 25 Sep 2014 11:15:44 -0400
In-Reply-To: <20140925144754.GD8306@8bytes.org>
References: <1411322304-3925-1-git-send-email-msalter@redhat.com>
	 <20140925144754.GD8306@8bytes.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 16:47 +0200, Joerg Roedel wrote:
> On Sun, Sep 21, 2014 at 01:58:24PM -0400, Mark Salter wrote:
> > iommu_bus_init() registers a bus notifier on the given bus by using
> > a statically defined notifier block:
> > 
> >   static struct notifier_block iommu_bus_nb = {
> >           .notifier_call = iommu_bus_notifier,
> >   };
> > 
> > This same notifier block is used for all busses. This causes a
> > problem for notifiers registered after iommu has registered this
> > callback on multiple busses. The problem is that a subsequent
> > notifier being registered on a bus which has this iommu notifier
> > will also get linked in to the notifier list of all other busses
> > which have this iommu notifier.
> > 
> > This patch fixes this by allocating the notifier_block at runtime.
> > Some error checking is also added to catch any allocation failure
> > or notifier registration error.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > ---
> >  drivers/iommu/iommu.c | 26 ++++++++++++++++----------
> >  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> Makes sense, applied. Where have you hit this condition where IOMMUs for
> different buses are registered?

arm_smmu_init()

	/* Oh, for a proper bus abstraction */
	if (!iommu_present(&platform_bus_type))
		bus_set_iommu(&platform_bus_type, &arm_smmu_ops);

#ifdef CONFIG_ARM_AMBA
	if (!iommu_present(&amba_bustype))
		bus_set_iommu(&amba_bustype, &arm_smmu_ops);
#endif

#ifdef CONFIG_PCI
	if (!iommu_present(&pci_bus_type))
		bus_set_iommu(&pci_bus_type, &arm_smmu_ops);
#endif


