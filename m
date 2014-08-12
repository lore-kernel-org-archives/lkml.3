Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaHLVTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:19:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33532 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaHLVTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <1407819721-27833-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1407819721-27833-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 12 Aug 2014 14:18:45 -0700
Message-ID: <CALzav=eZyM4_Y6yVoDnTZZUEbbF+T8WR_mSZa3h51FHs1uGBWQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: fix cache stale memslot info with correct mmio
 generation number
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 10:02 PM, Xiao Guangrong
<xiaoguangrong@linux.vnet.ibm.com> wrote:
> @@ -722,9 +719,10 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  {
>         struct kvm_memslots *old_memslots = kvm->memslots;
>

I think you want

  slots->generation = old_memslots->generation;

here.

On the KVM_MR_DELETE path, install_new_memslots is called twice so this
patch introduces a short window of time where the generation number
actually decreases.

> -       update_memslots(slots, new, kvm->memslots->generation);
> +       update_memslots(slots, new);
>         rcu_assign_pointer(kvm->memslots, slots);
>         synchronize_srcu_expedited(&kvm->srcu);
> +       slots->generation++;
>
>         kvm_arch_memslots_updated(kvm);
>
> --
> 1.8.3.1
>
