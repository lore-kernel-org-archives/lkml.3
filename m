Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3GJNuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:50:04 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43854 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3GJNuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:50:02 -0400
Date: Wed, 10 Jul 2013 22:49:56 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: reset arch memslot info on memslot creation
Message-Id: <20130710224956.b7a44f39c151148afa5a47ba@gmail.com>
In-Reply-To: <20130710082439.GA1482@redhat.com>
References: <20130710082439.GA1482@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013 11:24:39 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On x86, kvm_arch_create_memslot assumes that rmap/lpage_info for the
> slot are zeroed out: if they weren't, error handling code after out_free
> label will free memory which wasn't allocated here.
> This always happens to be the case because on KVM_MR_DELETE we clear the
> whole arch structure.  So there's no bug, but it's cleaner not to rely
> on this here.

Yes, the assumption is that the function is called only with zero-sized slots.
Since changing the size is not allowed, DELETE-CREATE is the only case we
care about.

But isn't it possible to make it explicit that zero-sized slots have always
zero-cleared contents instead?  Otherwise, there would be many troubles.

	Takuya

> 
> Make the code more robust by clearing the rmap/lpage_info explicitly.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e8ba99c..96e6eb4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6922,6 +6922,10 @@ int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
>  {
>  	int i;
>  
> +	/* Reset in case slot had some rmap/lpage_info. */
> +	memset(&slot->arch.rmap, 0, sizeof slot->arch.rmap);
> +	memset(&slot->arch.lpage_info, 0, sizeof slot->arch.lpage_info);
> +
>  	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
>  		unsigned long ugfn;
>  		int lpages;
> -- 
> MST
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
