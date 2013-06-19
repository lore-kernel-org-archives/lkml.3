Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3FSOv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:51:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:49793 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724Ab3FSOv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:51:28 -0400
Message-ID: <1371653443.21896.291.camel@pasglop>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Date: Thu, 20 Jun 2013 00:50:43 +1000
In-Reply-To: <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
	 <1371422343.21896.143.camel@pasglop>
	 <1371438800.22681.38.camel@ul30vt.home>
	 <1371441361.21896.152.camel@pasglop>
	 <1371522772.22681.140.camel@ul30vt.home> <87txkun568.fsf@rustcorp.com.au>
	 <1371617970.21896.232.camel@pasglop>
	 <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 11:58 +0200, Alexander Graf wrote:

> > Alex, any objection ?
> 
> Which Alex? :)

Heh, mostly Williamson in this specific case but your input is still
welcome :-)

> I think validate works, it keeps iteration logic out of the kernel
> which is a good thing. There still needs to be an interface for
> getting the iommu id in VFIO, but I suppose that one's for the other
> Alex and Jörg to comment on.

I think getting the iommu fd is already covered by separate patches from
Alexey.

> > 
> > Do we need to make it a get/put interface instead ?
> > 
> > 	vfio_validate_and_use_iommu(file, iommu_id);
> > 
> > 	vfio_release_iommu(file, iommu_id);
> > 
> > To ensure that the resource remains owned by the process until KVM
> > is closed as well ?
> > 
> > Or do we want to register with VFIO with a callback so that VFIO can
> > call us if it needs us to give it up ?
> 
> Can't we just register a handler on the fd and get notified when it
> closes? Can you kill VFIO access without closing the fd?

That sounds actually harder :-)

The question is basically: When we validate that relationship between a
specific VFIO struct file with an iommu, what is the lifetime of that
and how do we handle this lifetime properly.

There's two ways for that sort of situation: The notification model
where we get notified when the relationship is broken, and the refcount
model where we become a "user" and thus delay the breaking of the
relationship until we have been disposed of as well.

In this specific case, it's hard to tell what is the right model from my
perspective, which is why I would welcome Alex (W.) input.

In the end, the solution will end up being in the form of APIs exposed
by VFIO for use by KVM (via that symbol lookup mechanism) so Alex (W),
as owner of VFIO at this stage, what do you want those to look
like ? :-)

Cheers,
Ben.
 
> 
> Alex
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm-ppc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


