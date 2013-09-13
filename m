Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3IMItU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:49:20 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38514 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3IMItR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:49:17 -0400
Message-ID: <5232D186.6090701@ozlabs.ru>
Date: Fri, 13 Sep 2013 18:49:10 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, gleb@redhat.com, benh@kernel.crashing.org,
        bsd@redhat.com, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [RFC PATCH 3/3] kvm: Add VFIO device for handling IOMMU cache
 coherency
References: <20130912211401.8542.82932.stgit@bling.home> <20130912212314.8542.9692.stgit@bling.home>
In-Reply-To: <20130912212314.8542.9692.stgit@bling.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 07:23 AM, Alex Williamson wrote:
> So far we've succeeded at making KVM and VFIO mostly unaware of each
> other, but there's any important point where that breaks down.  Intel
> VT-d hardware may or may not support snoop control.  When snoop
> control is available, intel-iommu promotes No-Snoop transactions on
> PCIe to be cache coherent.  That allows KVM to handle things like the
> x86 WBINVD opcode as a nop.  When the hardware does not support this,
> KVM must implement a hardware visible WBINVD for the guest.
> 
> We could simply let userspace tell KVM how to handle WBINVD, but it's
> privileged for a reason.  Allowing an arbitrary user to enable
> physical WBINVD gives them a more access to the hardware.  Previously,
> this has only been enabled for guests supporting legacy PCI device
> assignment.  In such cases it's necessary for proper guest execution.
> We therefore create a new KVM-VFIO virtual device.  The user can add
> and remove VFIO groups to this device via file descriptors.  KVM
> makes use of the VFIO external user interface to validate that the
> user has access to physical hardware and gets the coherency state of
> the IOMMU from VFIO.  This provides equivalent functionality to
> legacy KVM assignment, while keeping (nearly) all the bits isolated.
> 
> The one intrusion is the resulting flag indicating the coherency
> state.  For this RFC it's placed on the x86 kvm_arch struct, however
> I know POWER has interest in using the VFIO external user interface,
> and I'm hoping we can share a common KVM-VFIO device.  Perhaps they
> care about No-Snoop handling as well or the code can be #ifdef'd.


POWER does not support (at least boos3s - "server", not sure about others)
this cache-non-coherent stuff at all.

Regarding reusing this device with external API for POWER - I posted a
patch which introduces KVM device to link KVM with IOMMU but besides the
list of groups registered in KVM, it also provides the way to find a group
by LIOBN (logical bus number) which is used in DMA map/unmap hypercalls. So
in my case kvm_vfio_group struct needs LIOBN and it would be nice to have
there window_size too (for a quick boundary check). I am not sure we want
to mix everything here.

It is in "[PATCH v10 12/13] KVM: PPC: Add support for IOMMU in-kernel
handling" if you are interested (kvmppc_spapr_tce_iommu_device).



-- 
Alexey
