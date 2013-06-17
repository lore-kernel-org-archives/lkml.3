Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3FQDNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:13:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab3FQDNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:13:35 -0400
Message-ID: <1371438800.22681.38.camel@ul30vt.home>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Date: Sun, 16 Jun 2013 21:13:20 -0600
In-Reply-To: <1371422343.21896.143.camel@pasglop>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
	 <1371422343.21896.143.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 08:39 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2013-06-05 at 16:11 +1000, Alexey Kardashevskiy wrote:
> > +long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm *kvm,
> > +               struct kvm_create_spapr_tce_iommu *args)
> > +{
> > +       struct kvmppc_spapr_tce_table *tt = NULL;
> > +       struct iommu_group *grp;
> > +       struct iommu_table *tbl;
> > +
> > +       /* Find an IOMMU table for the given ID */
> > +       grp = iommu_group_get_by_id(args->iommu_id);
> > +       if (!grp)
> > +               return -ENXIO;
> > +
> > +       tbl = iommu_group_get_iommudata(grp);
> > +       if (!tbl)
> > +               return -ENXIO;
> 
> So Alex Graf pointed out here, there is a security issue here, or are we
> missing something ?
> 
> What prevents a malicious program that has access to /dev/kvm from
> taking over random iommu groups (including host used ones) that way?
> 
> What is the security model of that whole iommu stuff to begin with ?

IOMMU groups themselves don't provide security, they're accessed by
interfaces like VFIO, which provide the security.  Given a brief look, I
agree, this looks like a possible backdoor.  The typical VFIO way to
handle this would be to pass a VFIO file descriptor here to prove that
the process has access to the IOMMU group.  This is how /dev/vfio/vfio
gains the ability to setup an IOMMU domain an do mappings with the
SET_CONTAINER ioctl using a group fd.  Thanks,

Alex



