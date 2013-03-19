Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3CSPhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:37:55 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:45665 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3CSPhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:37:54 -0400
Message-ID: <51488642.4060809@linux.vnet.ibm.com>
Date: Tue, 19 Mar 2013 23:37:38 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: MMU: fast zap all shadow pages
References: <514006AC.2020904@linux.vnet.ibm.com> <514007A0.1040400@linux.vnet.ibm.com> <20130318204601.GA16208@amt.cnet> <5147D63B.4000400@linux.vnet.ibm.com> <20130319144043.GA8767@amt.cnet>
In-Reply-To: <20130319144043.GA8767@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031915-4790-0000-0000-000007757111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 10:40 PM, Marcelo Tosatti wrote:

> 
> I misunderstood the benefit of your idea (now i got it: zap root
> and flush TLB guarantees vcpus will refault). What i'd like to avoid is
> 
> memset(cache, 0, sizeof(*cache));
> kvm_mmu_init(kvm);
> 
> I'd prefer normal operations on those data structures (in mmu_cache).
> And also the page accounting is a problem.
> 
> Perhaps you can use a generation number to consider whether shadow pages
> are valid? So: 
> 
> find_sp(gfn_t gfn)
> lookup hash
> if sp->generation_number != mmu->current_generation_number
> 	initialize page as if it were just allocated (but keep it in the hash list)
> 
> And on kvm_mmu_zap_all()
> spin_lock(mmu_lock)
> for each page
> if page->root_count
> 	zero sp->spt[]
> 
> flush TLB
> mmu->current_generation_number++
> spin_unlock(mmu_lock)
> 
> Then have kvm_mmu_free_all() that actually frees all data.
> 
> Hum, not sure if thats any better than your current patchset.

I also got the idea of generation number like yours which i mentioned
it in the [PATCH 0/6]:

* TODO
Avoiding Marcelo beat me :), they are some works not attached to make the
patchset more smaller:
(1): batch kvm_reload_remote_mmus for zapping root shadow pages
(2): free shadow pages by using generation-number
(3): remove unneeded kvm_reload_remote_mmus after kvm_mmu_zap_all
(4): drop unnecessary @npages from kvm_arch_create_memslot
(5): rename init_kvm_mmu to init_vcpu_mmu

> Well, maybe resend patchset with bug fixes / improvements and 
> we go from there.

I agree. Thanks for your time, Marcelo!


