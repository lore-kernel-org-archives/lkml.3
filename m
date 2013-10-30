Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3J3QKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab3J3QKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:10:45 -0400
Message-ID: <52712F7D.3090309@redhat.com>
Date: Wed, 30 Oct 2013 17:10:37 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, aik@ozlabs.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kvm: Destroy & free KVM devices on release
References: <20131029160019.22578.16409.stgit@bling.home>  <20131029161322.22578.18997.stgit@bling.home>  <20131030104029.GE4651@redhat.com> <1383143422.4097.170.camel@ul30vt.home>  <20131030153338.GI4651@redhat.com> <527128D7.9070603@redhat.com> <1383148594.4097.184.camel@ul30vt.home>
In-Reply-To: <1383148594.4097.184.camel@ul30vt.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/10/2013 16:56, Alex Williamson ha scritto:
> On Wed, 2013-10-30 at 16:42 +0100, Paolo Bonzini wrote:
>> Il 30/10/2013 16:33, Gleb Natapov ha scritto:
>>>> Hmm, ok.  In that case I can drop this patch and I think the rest just
>>>> boils down to userspace use of the device.  I had been close()'ing the
>>>> kvm device fd when all QEMU vfio devices are detached, but I can just as
>>>> easily leave it open in case a new device is added later.  I'll send out
>>>> a new series after doing some more review and testing.  Do you have any
>>>> comments on the rest of the series?  Thanks,
>>>
>>> If I understand 4/4 correctly if there is VFIO device connected we
>>> assume non coherent domain. How hard it would be to do proper checking
>>> in this path series?
>>
>> Yes, that's my understanding as well.  Is the performance impact measurable?
> 
> I have additional patches to do this, the blocker is that intel-iommu
> strips IOMMU_CACHE from the flags I provide if the IOMMU domain as a
> whole (ie. all of the hardware units involved in the domain) do not all
> support Snoop Control (SC).  Thus I can't rely on simply tracking the
> hardware capabilities of the domain because some IOMMU PTEs will have
> SNP set, others will not.  It depends on the state of the IOMMU domain
> at the time of the mapping.  Therefore the only way to switch back to
> coherent from non-coherent is to unmap and remap everything.  This is
> what legacy KVM device assignment does, but I can't see how that's not
> racy wrt inflight DMA.
> 
> The patch approach I was taking is:
> 
> 1) Enable KVM to handle the VM as non-coherent (which is trued, VFIO
> never sets IOMMU_CACHE currently due to the above issues).
> 
> 2) Get QEMU to enable the KVM device, fixing the coherency issue.
> 
> 3) Fix Intel IOMMU to honor IOMMU_CACHE regardless of hw capabilities
> (patch posted).
> 
> 4) Make VFIO always map w/ IOMMU_CACHE
> 
> 5) Create VFIO external user interface to query capabilities.
> 
> 6) Update KVM device to use it.
> 
> As to performance, for graphics I can't tell a difference whether
> NoSnoop is prevented or KVM does WBINVD.  I'm hoping though that we can
> consider the mode enabled by this patch as a temporary step in the
> process and we'll eventually get to a state where we only emulate WBINVD
> when necessary.  Correctness trumps performance in the current round.
> Thanks,

Thanks for the explanation.  Gleb, this looks fine to me.  WDYT?

Paolo

