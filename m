Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3FJH5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 03:57:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3FJH5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 03:57:00 -0400
Date: Mon, 10 Jun 2013 10:56:56 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
Message-ID: <20130610075656.GY4725@redhat.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:51:22PM +0800, Xiao Guangrong wrote:
> Changelog:
> V3:
>   All of these changes are from Gleb's review:
>   1) rename RET_MMIO_PF_EMU to RET_MMIO_PF_EMULATE.
>   2) smartly adjust kvm generation number in kvm_current_mmio_generatio()
>      to avoid kvm_memslots->generation overflow.
> 
> V2:
>   - rename kvm_mmu_invalid_mmio_spte to kvm_mmu_invalid_mmio_sptes
>   - use kvm->memslots->generation as kvm global generation-number
>   - fix comment and codestyle
>   - init kvm generation close to mmio wrap-around value
>   - keep kvm_mmu_zap_mmio_sptes
> 
> The current way is holding hot mmu-lock and walking all shadow pages, this
> is not scale. This patchset tries to introduce a very simple and scale way
> to fast invalidate all mmio sptes - it need not walk any shadow pages and hold
> any locks.
> 
> The idea is simple:
> KVM maintains a global mmio valid generation-number which is stored in
> kvm->memslots.generation and every mmio spte stores the current global
> generation-number into his available bits when it is created
> 
> When KVM need zap all mmio sptes, it just simply increase the global
> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
> then it walks the shadow page table and get the mmio spte. If the
> generation-number on the spte does not equal the global generation-number,
> it will go to the normal #PF handler to update the mmio spte
> 
> Since 19 bits are used to store generation-number on mmio spte, we zap all
> mmio sptes when the number is round
> 
Looks good to me, but doesn't tis obsolete kvm_mmu_zap_mmio_sptes() and
sp->mmio_cached, so they should be removed as part of the patch series?

> Xiao Guangrong (6):
>   KVM: MMU: retain more available bits on mmio spte
>   KVM: MMU: store generation-number into mmio spte
>   KVM: MMU: make return value of mmio page fault handler more readable
>   KVM: MMU: fast invalidate all mmio sptes
>   KVM: MMU: add tracepoint for check_mmio_spte
>   KVM: MMU: init kvm generation close to mmio wrap-around value
> 
>  arch/x86/include/asm/kvm_host.h |   2 +-
>  arch/x86/kvm/mmu.c              | 131 ++++++++++++++++++++++++++++++++--------
>  arch/x86/kvm/mmu.h              |  17 ++++++
>  arch/x86/kvm/mmutrace.h         |  34 +++++++++--
>  arch/x86/kvm/paging_tmpl.h      |  10 ++-
>  arch/x86/kvm/vmx.c              |  12 ++--
>  arch/x86/kvm/x86.c              |  11 +++-
>  7 files changed, 177 insertions(+), 40 deletions(-)
> 
> -- 
> 1.8.1.4

--
			Gleb.
