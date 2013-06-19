Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580Ab3FSJ7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:59:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933873Ab3FSJ67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:58:59 -0400
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1371617970.21896.232.camel@pasglop>
Date: Wed, 19 Jun 2013 11:58:50 +0200
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru> <1370412673-1345-4-git-send-email-aik@ozlabs.ru> <1371422343.21896.143.camel@pasglop> <1371438800.22681.38.camel@ul30vt.home> <1371441361.21896.152.camel@pasglop> <1371522772.22681.140.camel@ul30vt.home> <87txkun568.fsf@rustcorp.com.au> <1371617970.21896.232.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19.06.2013, at 06:59, Benjamin Herrenschmidt wrote:

> On Wed, 2013-06-19 at 13:05 +0930, Rusty Russell wrote:
>> symbol_get() won't try to load a module; it'll just fail.  This is what
>> you want, since they must have vfio in the kernel to get a valid fd...
> 
> Ok, cool. I suppose what we want here Alexey is slightly higher level,
> something like:
> 
> 	vfio_validate_iommu_id(file, iommu_id)
> 
> Which verifies that the file that was passed in is allowed to use
> that iommu_id.
> 
> That's a simple and flexible interface (ie, it will work even if we
> support multiple iommu IDs in the future for a vfio, for example
> for DDW windows etc...), the logic to know about the ID remains
> in qemu, this is strictly a validation call.
> 
> That way we also don't have to expose the containing vfio struct etc...
> just that simple function.
> 
> Alex, any objection ?

Which Alex? :)

I think validate works, it keeps iteration logic out of the kernel which is a good thing. There still needs to be an interface for getting the iommu id in VFIO, but I suppose that one's for the other Alex and Jörg to comment on.

> 
> Do we need to make it a get/put interface instead ?
> 
> 	vfio_validate_and_use_iommu(file, iommu_id);
> 
> 	vfio_release_iommu(file, iommu_id);
> 
> To ensure that the resource remains owned by the process until KVM
> is closed as well ?
> 
> Or do we want to register with VFIO with a callback so that VFIO can
> call us if it needs us to give it up ?

Can't we just register a handler on the fd and get notified when it closes? Can you kill VFIO access without closing the fd?


Alex

