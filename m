Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab3FRV7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:59:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:52202 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab3FRV7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:59:36 -0400
Message-ID: <1371592737.21896.197.camel@pasglop>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 19 Jun 2013 07:58:57 +1000
In-Reply-To: <1371566935.22681.169.camel@ul30vt.home>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
	 <1371422343.21896.143.camel@pasglop>
	 <1371438800.22681.38.camel@ul30vt.home>
	 <1371441361.21896.152.camel@pasglop>
	 <1371522772.22681.140.camel@ul30vt.home>
	 <1371530335.21896.169.camel@pasglop>
	 <1371566935.22681.169.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 08:48 -0600, Alex Williamson wrote:
> On Tue, 2013-06-18 at 14:38 +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2013-06-17 at 20:32 -0600, Alex Williamson wrote:
> > 
> > > Right, we don't want to create dependencies across modules.  I don't
> > > have a vision for how this should work.  This is effectively a complete
> > > side-band to vfio, so we're really just dealing in the iommu group
> > > space.  Maybe there needs to be some kind of registration of ownership
> > > for the group using some kind of token.  It would need to include some
> > > kind of notification when that ownership ends.  That might also be a
> > > convenient tag to toggle driver probing off for devices in the group.
> > > Other ideas?  Thanks,
> > 
> > All of that smells nasty like it will need a pile of bloody
> > infrastructure.... which makes me think it's too complicated and not the
> > right approach.
> > 
> > How does access control work today on x86/VFIO ? Can you give me a bit
> > more details ? I didn't get a good grasp in your previous email....
> 
> The current model is not x86 specific, but it only covers doing iommu
> and device access through vfio.  The kink here is that we're trying to
> do device access and setup through vfio, but iommu manipulation through
> kvm.  We may want to revisit whether we can do the in-kernel iommu
> manipulation through vfio rather than kvm.

How would that be possible ?

The hypercalls from the guest arrive in KVM... in a very very specific &
restricted environment which we call real mode (MMU off but still
running in guest context), where we try to do as much as possible, or in
virtual mode, where they get handled as normal KVM exits.

The only way we could handle them "in VFIO" would be if somewhat VFIO
registered callbacks with KVM... if we have that sort of
cross-dependency, then we may as well have a simpler one where VFIO
tells KVM what iommu is available for the VM

> For vfio in general, the group is the unit of ownership.  A user is
> granted access to /dev/vfio/$GROUP through file permissions.  The user
> opens the group and a container (/dev/vfio/vfio) and calls SET_CONTAINER
> on the group.  If supported by the platform, multiple groups can be set
> to the same container, which allows for iommu domain sharing.  Once a
> group is associated with a container, an iommu backend can be
> initialized for the container.  Only then can a device be accessed
> through the group.
> 
> So even if we were to pass a vfio group file descriptor into kvm and it
> matched as some kind of ownership token on the iommu group, it's not
> clear that's sufficient to assume we can start programming the iommu.
> Thanks,

Your scheme seems to me that it would have the same problem if you
wanted to do virtualized iommu....

In any case, this is a big deal. We have a requirement for pass-through.
It cannot work with any remotely usable performance level if we don't
implement the calls in KVM, so it needs to be sorted one way or another
and I'm at a loss how here...

Ben.

> Alex
> 
> > From the look of it, the VFIO file descriptor is what has the "access
> > control" to the underlying iommu, is this right ? So we somewhat need to
> > transfer (or copy) that ownership from the VFIO fd to the KVM VM.
> > 
> > I don't see a way to do that without some cross-layering here...
> > 
> > Rusty, are you aware of some kernel mechanism we can use for that ?
> > 
> > Cheers,
> > Ben.
> > 
> > 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm-ppc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


