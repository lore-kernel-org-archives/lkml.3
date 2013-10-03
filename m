Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3JCUku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:40:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab3JCUks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:40:48 -0400
Message-ID: <1380832842.2673.80.camel@ul30vt.home>
Subject: Re: [PATCH v2 4/4] kvm: Add VFIO device for handling IOMMU cache
 coherency
From: Alex Williamson <alex.williamson@redhat.com>
To: gleb@redhat.com
Cc: aik@ozlabs.ru, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 03 Oct 2013 14:40:42 -0600
In-Reply-To: <20131003025134.8850.97617.stgit@bling.home>
References: <20131001201524.31715.4300.stgit@bling.home>
	 <20131003025134.8850.97617.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 20:55 -0600, Alex Williamson wrote:
> So far we've succeeded at making KVM and VFIO mostly unaware of each
> other, but there's an important point where that breaks down.  Intel
> VT-d hardware may or may not support snoop control.  When snoop
> control is available, intel-iommu promotes No-Snoop transactions on
> PCIe to be cache coherent.  That allows KVM to handle things like the
> x86 WBINVD opcode as a nop.  When the hardware does not support this,
> KVM must implement a hardware visible WBINVD for the guest.
> 
> We could simply let userspace tell KVM how to handle WBINVD, but it's
> privileged for a reason.  Allowing an arbitrary user to enable
> physical WBINVD gives them more access to the hardware.  Previously,
> this has only been enabled for guests supporting legacy PCI device
> assignment.  In such cases it's necessary for proper guest execution.
> We therefore create a new KVM-VFIO virtual device.  The user can add
> and remove VFIO groups to this device via file descriptors.  KVM
> makes use of the VFIO external user interface to validate that the
> user has access to physical hardware and, for now, assumes the I/O
> is noncoherent.  Eventually we'll add an interface to allow KVM to
> determine the conherency of the domain as noted in the TODO.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> v2: Patches 1-3 of v1 series remain the same, not resent
>   - Fix cast warning from (int32_t *)u64 from get_user calls
>   - Add a Kconfig variable to protect kvm_vfio_ops for archs
>     not (yet) building virt/kvm/vfio.c

There might be another option for my particular need of this.  The
device PCIe capability has a bit in the Device Control register that
enables a device to do NoSnoop transactions.  Therefore it seems like by
clearing this bit on the physical device and emulating it as read-only
in the guest, we can prevent the NoSnoop at the device rather than at
the IOMMU.  If we can prevent NoSnoop, then I don't think we need to
worry about things like WBINVD emulation in KVM.  Let me work on this a
bit more before applying.  Thanks,

Alex

