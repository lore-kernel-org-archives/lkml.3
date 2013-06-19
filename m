Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795Ab3FSPuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934108Ab3FSPuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:50:23 -0400
Message-ID: <1371656989.22659.98.camel@ul30vt.home>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexander Graf <agraf@suse.de>, Alexey Kardashevskiy <aik@ozlabs.ru>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Date: Wed, 19 Jun 2013 09:49:49 -0600
In-Reply-To: <1371653443.21896.291.camel@pasglop>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
	 <1371422343.21896.143.camel@pasglop>
	 <1371438800.22681.38.camel@ul30vt.home>
	 <1371441361.21896.152.camel@pasglop>
	 <1371522772.22681.140.camel@ul30vt.home> <87txkun568.fsf@rustcorp.com.au>
	 <1371617970.21896.232.camel@pasglop>
	 <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
	 <1371653443.21896.291.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 00:50 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2013-06-19 at 11:58 +0200, Alexander Graf wrote:
> 
> > > Alex, any objection ?
> > 
> > Which Alex? :)
> 
> Heh, mostly Williamson in this specific case but your input is still
> welcome :-)
> 
> > I think validate works, it keeps iteration logic out of the kernel
> > which is a good thing. There still needs to be an interface for
> > getting the iommu id in VFIO, but I suppose that one's for the other
> > Alex and Jörg to comment on.
> 
> I think getting the iommu fd is already covered by separate patches from
> Alexey.
> 
> > > 
> > > Do we need to make it a get/put interface instead ?
> > > 
> > > 	vfio_validate_and_use_iommu(file, iommu_id);
> > > 
> > > 	vfio_release_iommu(file, iommu_id);
> > > 
> > > To ensure that the resource remains owned by the process until KVM
> > > is closed as well ?
> > > 
> > > Or do we want to register with VFIO with a callback so that VFIO can
> > > call us if it needs us to give it up ?
> > 
> > Can't we just register a handler on the fd and get notified when it
> > closes? Can you kill VFIO access without closing the fd?
> 
> That sounds actually harder :-)
> 
> The question is basically: When we validate that relationship between a
> specific VFIO struct file with an iommu, what is the lifetime of that
> and how do we handle this lifetime properly.
> 
> There's two ways for that sort of situation: The notification model
> where we get notified when the relationship is broken, and the refcount
> model where we become a "user" and thus delay the breaking of the
> relationship until we have been disposed of as well.
> 
> In this specific case, it's hard to tell what is the right model from my
> perspective, which is why I would welcome Alex (W.) input.
> 
> In the end, the solution will end up being in the form of APIs exposed
> by VFIO for use by KVM (via that symbol lookup mechanism) so Alex (W),
> as owner of VFIO at this stage, what do you want those to look
> like ? :-)

My first thought is that we should use the same reference counting as we
have for vfio devices (group->container_users).  An interface for that
might look like:

int vfio_group_add_external_user(struct file *filep)
{
	struct vfio_group *group = filep->private_data;

	if (filep->f_op != &vfio_group_fops)
		return -EINVAL;


	if (!atomic_inc_not_zero(&group->container_users))
		return -EINVAL;

	return 0;
}

void vfio_group_del_external_user(struct file *filep)
{
	struct vfio_group *group = filep->private_data;

	BUG_ON(filep->f_op != &vfio_group_fops);

	vfio_group_try_dissolve_container(group);
}

int vfio_group_iommu_id_from_file(struct file *filep)
{
	struct vfio_group *group = filep->private_data;

	BUG_ON(filep->f_op != &vfio_group_fops);

	return iommu_group_id(group->iommu_group);
}

Would that work?  Thanks,

Alex

