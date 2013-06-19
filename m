Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3FSFAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:00:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:44293 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3FSFAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:00:10 -0400
Message-ID: <1371617970.21896.232.camel@pasglop>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 19 Jun 2013 14:59:30 +1000
In-Reply-To: <87txkun568.fsf@rustcorp.com.au>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
	 <1371422343.21896.143.camel@pasglop>
	 <1371438800.22681.38.camel@ul30vt.home>
	 <1371441361.21896.152.camel@pasglop>
	 <1371522772.22681.140.camel@ul30vt.home> <87txkun568.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 13:05 +0930, Rusty Russell wrote:
> symbol_get() won't try to load a module; it'll just fail.  This is what
> you want, since they must have vfio in the kernel to get a valid fd...

Ok, cool. I suppose what we want here Alexey is slightly higher level,
something like:

	vfio_validate_iommu_id(file, iommu_id)

Which verifies that the file that was passed in is allowed to use
that iommu_id.

That's a simple and flexible interface (ie, it will work even if we
support multiple iommu IDs in the future for a vfio, for example
for DDW windows etc...), the logic to know about the ID remains
in qemu, this is strictly a validation call.

That way we also don't have to expose the containing vfio struct etc...
just that simple function.

Alex, any objection ?

Do we need to make it a get/put interface instead ?

	vfio_validate_and_use_iommu(file, iommu_id);

	vfio_release_iommu(file, iommu_id);

To ensure that the resource remains owned by the process until KVM
is closed as well ?

Or do we want to register with VFIO with a callback so that VFIO can
call us if it needs us to give it up ?

Cheers,
Ben.


