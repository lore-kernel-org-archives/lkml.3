Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3FPW0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:26:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab3FPWZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:25:58 -0400
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
Date: Mon, 17 Jun 2013 00:25:55 +0200
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <384E7BC9-02AF-4F9A-B502-E1DA40A361B8@suse.de>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru> <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05.06.2013, at 08:11, Alexey Kardashevskiy wrote:

> This allows the host kernel to handle H_PUT_TCE, H_PUT_TCE_INDIRECT
> and H_STUFF_TCE requests without passing them to QEMU, which should
> save time on switching to QEMU and back.
> 
> Both real and virtual modes are supported - whenever the kernel
> fails to handle TCE request, it passes it to the virtual mode.
> If it the virtual mode handlers fail, then the request is passed
> to the user mode, for example, to QEMU.
> 
> This adds a new KVM_CAP_SPAPR_TCE_IOMMU ioctl to asssociate
> a virtual PCI bus ID (LIOBN) with an IOMMU group, which enables
> in-kernel handling of IOMMU map/unmap.
> 
> Tests show that this patch increases transmission speed from 220MB/s
> to 750..1020MB/s on 10Gb network (Chelsea CXGB3 10Gb ethernet card).
> 
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> 
> ---
> 
> Changes:
> 2013/06/05:
> * changed capability number
> * changed ioctl number
> * update the doc article number
> 
> 2013/05/20:
> * removed get_user() from real mode handlers
> * kvm_vcpu_arch::tce_tmp usage extended. Now real mode handler puts there
> translated TCEs, tries realmode_get_page() on those and if it fails, it
> passes control over the virtual mode handler which tries to finish
> the request handling
> * kvmppc_lookup_pte() now does realmode_get_page() protected by BUSY bit
> on a page
> * The only reason to pass the request to user mode now is when the user mode
> did not register TCE table in the kernel, in all other cases the virtual mode
> handler is expected to do the job
> ---
> Documentation/virtual/kvm/api.txt   |   28 +++++
> arch/powerpc/include/asm/kvm_host.h |    3 +
> arch/powerpc/include/asm/kvm_ppc.h  |    2 +
> arch/powerpc/include/uapi/asm/kvm.h |    7 ++
> arch/powerpc/kvm/book3s_64_vio.c    |  198 ++++++++++++++++++++++++++++++++++-
> arch/powerpc/kvm/book3s_64_vio_hv.c |  193 +++++++++++++++++++++++++++++++++-
> arch/powerpc/kvm/powerpc.c          |   12 +++
> include/uapi/linux/kvm.h            |    2 +
> 8 files changed, 439 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 6c082ff..e962e3b 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2379,6 +2379,34 @@ the guest. Othwerwise it might be better for the guest to continue using H_PUT_T
> hypercall (if KVM_CAP_SPAPR_TCE or KVM_CAP_SPAPR_TCE_IOMMU are present).
> 
> 
> +4.84 KVM_CREATE_SPAPR_TCE_IOMMU
> +
> +Capability: KVM_CAP_SPAPR_TCE_IOMMU
> +Architectures: powerpc
> +Type: vm ioctl
> +Parameters: struct kvm_create_spapr_tce_iommu (in)
> +Returns: 0 on success, -1 on error
> +
> +This creates a link between IOMMU group and a hardware TCE (translation
> +control entry) table. This link lets the host kernel know what IOMMU
> +group (i.e. TCE table) to use for the LIOBN number passed with
> +H_PUT_TCE, H_PUT_TCE_INDIRECT, H_STUFF_TCE hypercalls.
> +
> +/* for KVM_CAP_SPAPR_TCE_IOMMU */
> +struct kvm_create_spapr_tce_iommu {
> +	__u64 liobn;
> +	__u32 iommu_id;
> +	__u32 flags;
> +};
> +
> +No flag is supported at the moment.
> +
> +When the guest issues TCE call on a liobn for which a TCE table has been
> +registered, the kernel will handle it in real mode, updating the hardware
> +TCE table. TCE table calls for other liobns will cause a vm exit and must
> +be handled by userspace.

Ok, please walk me through the security model you have in mind here.

Basically what this ioctl does is that it creates a guest TCE table that reflects its changes into a host TCE table whenever it gets modified. So far so good.

Now I don't see any checks that verify whether iommu_id is actually good to use from that user's access rights. Just because I have access to /dev/kvm I don't necessarily have access to an iommu control device.

So the least I can see would be a local DoS attack where one user space program with only access to /dev/kvm can simply kill any access to another process's device by overflowing a host iommu TCE table with junk entries.

There's even a certain chance of an information disclosure exploit here where a malicious user space program could get itself all network traffic DMA'd from another VM.

How does this work on the host level? What is the security token to take control of a host TCE table?


Alex

