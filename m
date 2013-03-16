Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3CPCGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 22:06:21 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45714 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab3CPCGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 22:06:19 -0400
Date: Sat, 16 Mar 2013 11:06:12 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/5] KVM: MMU: fast invalid all mmio sptes
Message-Id: <20130316110612.453447e6a1a5bfa7088aefcb@gmail.com>
In-Reply-To: <51433D98.4050605@linux.vnet.ibm.com>
References: <51433D98.4050605@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still reading, but sounds great if this works!

I did not like the idea of mmio-rmap based approach so much, but this
would be really/perfectly scalable.

Thanks,
	Takuya

On Fri, 15 Mar 2013 23:26:16 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> The current way is holding hot mmu-lock and walking all shadow pages, this
> is not scale. This patchset tries to introduce a very simple and scale way
> to fast invalid all mmio sptes - it need not walk any shadow pages and hold
> any locks.
> 
> The idea is simple:
> KVM maintains a global mmio invalid generation-number which is stored in
> kvm->arch.mmio_invalid_gen and every mmio spte stores the current global
> generation-number into his available bits when it is created.
> 
> When KVM need zap all mmio sptes, it just simply increase the global
> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
> then it walks the shadow page table and get the mmio spte. If the
> generation-number on the spte does not equal the global generation-number,
> it will go to the normal #PF handler to update the mmio spte.
> 
> Since 19 bits are used to store generation-number on mmio spte, the
> generation-number can be round after 33554432 times. It is large enough
> for nearly all most cases, but making the code be more strong, we zap all
> shadow pages when the number is round.
> 
> Note: after my patchset that fast zap all shadow pages, kvm_mmu_zap_all is
> not a problem any more. The scalability is the same as zap mmio shadow page
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
