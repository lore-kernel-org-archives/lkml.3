Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3FROtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:49:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab3FROtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:49:10 -0400
Message-ID: <1371566935.22681.169.camel@ul30vt.home>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 18 Jun 2013 08:48:55 -0600
In-Reply-To: <1371530335.21896.169.camel@pasglop>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
	 <1371422343.21896.143.camel@pasglop>
	 <1371438800.22681.38.camel@ul30vt.home>
	 <1371441361.21896.152.camel@pasglop>
	 <1371522772.22681.140.camel@ul30vt.home>
	 <1371530335.21896.169.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 14:38 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-06-17 at 20:32 -0600, Alex Williamson wrote:
> 
> > Right, we don't want to create dependencies across modules.  I don't
> > have a vision for how this should work.  This is effectively a complete
> > side-band to vfio, so we're really just dealing in the iommu group
> > space.  Maybe there needs to be some kind of registration of ownership
> > for the group using some kind of token.  It would need to include some
> > kind of notification when that ownership ends.  That might also be a
> > convenient tag to toggle driver probing off for devices in the group.
> > Other ideas?  Thanks,
> 
> All of that smells nasty like it will need a pile of bloody
> infrastructure.... which makes me think it's too complicated and not the
> right approach.
> 
> How does access control work today on x86/VFIO ? Can you give me a bit
> more details ? I didn't get a good grasp in your previous email....

The current model is not x86 specific, but it only covers doing iommu
and device access through vfio.  The kink here is that we're trying to
do device access and setup through vfio, but iommu manipulation through
kvm.  We may want to revisit whether we can do the in-kernel iommu
manipulation through vfio rather than kvm.

For vfio in general, the group is the unit of ownership.  A user is
granted access to /dev/vfio/$GROUP through file permissions.  The user
opens the group and a container (/dev/vfio/vfio) and calls SET_CONTAINER
on the group.  If supported by the platform, multiple groups can be set
to the same container, which allows for iommu domain sharing.  Once a
group is associated with a container, an iommu backend can be
initialized for the container.  Only then can a device be accessed
through the group.

So even if we were to pass a vfio group file descriptor into kvm and it
matched as some kind of ownership token on the iommu group, it's not
clear that's sufficient to assume we can start programming the iommu.
Thanks,

Alex

> From the look of it, the VFIO file descriptor is what has the "access
> control" to the underlying iommu, is this right ? So we somewhat need to
> transfer (or copy) that ownership from the VFIO fd to the KVM VM.
> 
> I don't see a way to do that without some cross-layering here...
> 
> Rusty, are you aware of some kernel mechanism we can use for that ?
> 
> Cheers,
> Ben.
> 
> 



