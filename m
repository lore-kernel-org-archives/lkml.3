Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3FXFFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 01:05:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3FXFFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 01:05:50 -0400
Message-ID: <1372048884.30572.168.camel@ul30vt.home>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Date: Sun, 23 Jun 2013 22:41:24 -0600
In-Reply-To: <20130624035249.GD25265@voom.fritz.box>
References: <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
	 <1371653443.21896.291.camel@pasglop>
	 <1371656989.22659.98.camel@ul30vt.home> <51C28BEA.8050501@ozlabs.ru>
	 <20130620052822.GB3140@voom.redhat.com> <1371714449.3944.14.camel@pasglop>
	 <51C2C1CC.9000003@ozlabs.ru> <1371740113.32709.22.camel@ul30vt.home>
	 <20130622120304.GB25265@voom.fritz.box>
	 <1371911286.30572.155.camel@ul30vt.home>
	 <20130624035249.GD25265@voom.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 13:52 +1000, David Gibson wrote:
> On Sat, Jun 22, 2013 at 08:28:06AM -0600, Alex Williamson wrote:
> > On Sat, 2013-06-22 at 22:03 +1000, David Gibson wrote:
> > > On Thu, Jun 20, 2013 at 08:55:13AM -0600, Alex Williamson wrote:
> > > > On Thu, 2013-06-20 at 18:48 +1000, Alexey Kardashevskiy wrote:
> > > > > On 06/20/2013 05:47 PM, Benjamin Herrenschmidt wrote:
> > > > > > On Thu, 2013-06-20 at 15:28 +1000, David Gibson wrote:
> > > > > >>> Just out of curiosity - would not get_file() and fput_atomic() on a
> > > > > >> group's
> > > > > >>> file* do the right job instead of vfio_group_add_external_user() and
> > > > > >>> vfio_group_del_external_user()?
> > > > > >>
> > > > > >> I was thinking that too.  Grabbing a file reference would certainly be
> > > > > >> the usual way of handling this sort of thing.
> > > > > > 
> > > > > > But that wouldn't prevent the group ownership to be returned to
> > > > > > the kernel or another user would it ?
> > > > > 
> > > > > 
> > > > > Holding the file pointer does not let the group->container_users counter go
> > > > > to zero
> > > > 
> > > > How so?  Holding the file pointer means the file won't go away, which
> > > > means the group release function won't be called.  That means the group
> > > > won't go away, but that doesn't mean it's attached to an IOMMU.  A user
> > > > could call UNSET_CONTAINER.
> > > 
> > > Uhh... *thinks*.  Ah, I see.
> > > 
> > > I think the interface should not take the group fd, but the container
> > > fd.  Holding a reference to *that* would keep the necessary things
> > > around.  But more to the point, it's the right thing semantically:
> > > 
> > > The container is essentially the handle on a host iommu address space,
> > > and so that's what should be bound by the KVM call to a particular
> > > guest iommu address space.  e.g. it would make no sense to bind two
> > > different groups to different guest iommu address spaces, if they were
> > > in the same container - the guest thinks they are different spaces,
> > > but if they're in the same container they must be the same space.
> > 
> > While the container is the gateway to the iommu, what empowers the
> > container to maintain an iommu is the group.  What happens to a
> > container when all the groups are disconnected or closed?  Groups are
> > the unit that indicates hardware access, not containers.  Thanks,
> 
> Uh... huh?  I'm really not sure what you're getting at.
> 
> The operation we're doing for KVM here is binding a guest iommu
> address space to a particular host iommu address space.  Why would we
> not want to use the obvious handle on the host iommu address space,
> which is the container fd?

AIUI, the request isn't for an interface through which to do iommu
mappings.  The request is for an interface to show that the user has
sufficient privileges to do mappings.  Groups are what gives the user
that ability.  The iommu is also possibly associated with multiple iommu
groups and I believe what is being asked for here is a way to hold and
lock a single iommu group with iommu protection.

>From a practical point of view, the iommu interface is de-privileged
once the groups are disconnected or closed.  Holding a reference count
on the iommu fd won't prevent that.  That means we'd have to use a
notifier to have KVM stop the side-channel iommu access.  Meanwhile
holding the file descriptor for the group and adding an interface that
bumps use counter allows KVM to lock itself in, just as if it had a
device opened itself.  Thanks,

Alex

