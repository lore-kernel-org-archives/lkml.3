Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab3FSL6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934052Ab3FSL6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:58:19 -0400
Message-ID: <51C19CD2.3080608@redhat.com>
Date: Wed, 19 Jun 2013 13:58:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] KVM: MMU: document write_flooding_count
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1371632965-20077-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
> Document write_flooding_count to Documentation/virtual/kvm/mmu.txt
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/mmu.txt | 8 ++++++++
>  arch/x86/include/asm/kvm_host.h   | 5 +++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
> index ce6df51..5a6b2e2 100644
> --- a/Documentation/virtual/kvm/mmu.txt
> +++ b/Documentation/virtual/kvm/mmu.txt
> @@ -214,6 +214,14 @@ Shadow pages contain the following information:
>      It is only used on 32bit host which helps us to detect whether updating the
>      64bit spte is complete so that we can avoid reading the truncated value out
>      of mmu-lock.
> +  write_flooding_count:
> +    In order to sync the page table between guest and host, the page sometimes
> +    needs to be write-protected (see "Synchronized and unsynchronized pages"
> +    below), any write to the page can cause write emulation. If the emulation
> +    on the page is too frequent we'd better unmap the page to avoid the
> +    future emulation. write_flooding_count aims at this optimization which is
> +    increased when the page needs to be write emulated and cleared when the
> +    page is actually used.

    A guest may write to a page table many times, causing a lot of
    emulations if the page needs to be write-protected (see "Synchronized
    and unsynchronized pages" below).  Leaf pages can be unsynchronized
    so that they do not trigger frequent emulation, but this is not
    possible for non-leafs.  This field counts the number of emulations
    since the last time the page table was actually used; if emulation
    is triggered too frequently on this page, KVM will unmap the page
    to avoid emulation in the future.

>  Reverse map
>  ===========
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1dac2c1..5eb5382 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -234,6 +234,11 @@ struct kvm_mmu_page {
>  	int clear_spte_count;
>  #endif
>  
> +	/*
> +	 * Increased when the page needs to be write emulated, cleared
> +	 * when the page is actually used as page table to avoid frequent
> +	 * emulation on the page.
> +	 */

        /* Number of writes since the last time traversal visited this page.  */

wdyt, better or worse?

Paolo

>  	int write_flooding_count;
>  };
>  
> 

