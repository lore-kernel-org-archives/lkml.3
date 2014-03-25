Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaCYQZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:25:09 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:32784 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaCYQZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:25:06 -0400
MIME-Version: 1.0
In-Reply-To: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Date: Tue, 25 Mar 2014 12:25:03 -0400
Message-ID: <CAHqbYQuOM4CmJGR7aT7_b6XCoYtUvqHmhxYKynF5_ABW10LDVQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] KVM: x86: flush tlb out of mmu-lock after write protection
From: Hu Yaohui <loki2441@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@kernel.org>, avi.kivity@gmail.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guangrong,
Since you have written in the kvm/mmu.txt.
<quote>

  unsync:
    If true, then the translations in this page may not match the guest's
    translation.  This is equivalent to the state of the tlb when a pte is
    changed but before the tlb entry is flushed.  Accordingly, unsync ptes
    are synchronized when the guest executes invlpg or flushes its tlb by
    other means.  Valid for leaf pages.

</quote>

This make sense to me, my question is when those unsync bits will be
set? When the guest writes to the level 1 guest page tables, it will
not cause a page fault. Those unsync bit is unlikely to be set when
the entry is modified. (correct me if I am wrong).

<code>
static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
{
...
    for_each_shadow_entry(vcpu, gva, iterator) {
        level = iterator.level;
        sptep = iterator.sptep;

        sp = page_header(__pa(sptep));
        if (is_last_spte(*sptep, level)) {
            int offset, shift;

            if (!sp->unsync)
                break;
...
</code>
When guest called invlpg, kvm invlpg will navigate to to the last
level,  if the sp->unsync is not set to 1, since the initial value is
zero. it will just break. It's not straight forward to me that the
specified sp will be synced with the guest page table.

I think I have missed something or misunderstood the whole mechanism,
I would really appreciate it if you could shed some lights on that.

Best Wishes,
Yaohui Hu

On Mon, Mar 10, 2014 at 10:01 AM, Xiao Guangrong
<xiaoguangrong@linux.vnet.ibm.com> wrote:
> This patchset is splited from my previous patchset:
> [PATCH v3 00/15] KVM: MMU: locklessly write-protect
> that can be found at:
> https://lkml.org/lkml/2013/10/23/265
>
> Changelog v4 :
> - add more comments for patch 5 and thank for Marcelo's review
>
> Xiao Guangrong (5):
>   Revert "KVM: Simplify kvm->tlbs_dirty handling"
>   KVM: MMU: properly check last spte in fast_page_fault()
>   KVM: MMU: lazily drop large spte
>   KVM: MMU: flush tlb if the spte can be locklessly modified
>   KVM: MMU: flush tlb out of mmu lock when write-protect the sptes
>
>  arch/x86/kvm/mmu.c         | 72 ++++++++++++++++++++++++++++++----------------
>  arch/x86/kvm/mmu.h         | 14 +++++++++
>  arch/x86/kvm/paging_tmpl.h |  7 ++---
>  arch/x86/kvm/x86.c         | 20 ++++++++++---
>  include/linux/kvm_host.h   |  4 +--
>  virt/kvm/kvm_main.c        |  5 +++-
>  6 files changed, 85 insertions(+), 37 deletions(-)
>
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
