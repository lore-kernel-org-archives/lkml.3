Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab3CPCNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 22:13:36 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61493 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab3CPCNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 22:13:35 -0400
Date: Sat, 16 Mar 2013 11:13:30 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: MMU: fast invalid all mmio sptes
Message-Id: <20130316111330.6e077a421aa580d80dc08641@gmail.com>
In-Reply-To: <51433E71.2070107@linux.vnet.ibm.com>
References: <51433D98.4050605@linux.vnet.ibm.com>
	<51433E71.2070107@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013 23:29:53 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> +/*
> + * The caller should protect concurrent access on
> + * kvm->arch.mmio_invalid_gen. Currently, it is used by
> + * kvm_arch_commit_memory_region and protected by kvm->slots_lock.
> + */
> +void kvm_mmu_invalid_mmio_spte(struct kvm *kvm)

kvm_mmu_invalidate_mmio_sptes() may be a better name.

Thanks,
	Takuya

> +{
> +	/* Ensure update memslot has been completed. */
> +	smp_mb();
> +
> +	 trace_kvm_mmu_invalid_mmio_spte(kvm);
> +
> +	/*
> +	 * The very rare case: if the generation-number is round,
> +	 * zap all shadow pages.
> +	 */
> +	if (unlikely(kvm->arch.mmio_invalid_gen++ == MAX_GEN)) {
> +		kvm->arch.mmio_invalid_gen = 0;
> +		return kvm_mmu_zap_all(kvm);
> +	}
> +}
> +
