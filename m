Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab3FNB7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759660Ab3FNB7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:59:11 -0400
Date: Thu, 13 Jun 2013 21:08:21 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
Message-ID: <20130614000821.GA3183@amt.cnet>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Hi Xiao,

- Where is the generation number increased?
- Should use spinlock breakable code in kvm_mmu_zap_mmio_sptes()
(picture guest with 512GB of RAM, even walking all those pages is
expensive) (ah, patch to remove kvm_mmu_zap_mmio_sptes does that).
- Is -13 enough to test wraparound? Its highly likely the guest has 
not began executing by the time 13 kvm_set_memory_calls are made
(so no sptes around). Perhaps -2000 is more sensible (should confirm
though).
- Why remove "if (change == KVM_MR_CREATE) || (change
==  KVM_MR_MOVE)" from kvm_arch_commit_memory_region?
Its instructive.

Otherwise looks good.

