Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab3CVCL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:11:27 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47774 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3CVCLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:11:25 -0400
Message-ID: <514BBDC5.6090104@linux.vnet.ibm.com>
Date: Fri, 22 Mar 2013 10:11:17 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] KVM: MMU: fast zap all shadow pages
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130321222151.GA19821@amt.cnet>
In-Reply-To: <20130321222151.GA19821@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032202-8878-0000-0000-00000665886E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 06:21 AM, Marcelo Tosatti wrote:
> On Wed, Mar 20, 2013 at 04:30:20PM +0800, Xiao Guangrong wrote:
>> Changlog:
>> V2:
>>   - do not reset n_requested_mmu_pages and n_max_mmu_pages
>>   - batch free root shadow pages to reduce vcpu notification and mmu-lock
>>     contention
>>   - remove the first patch that introduce kvm->arch.mmu_cache since we only
>>     'memset zero' on hashtable rather than all mmu cache members in this
>>     version
>>   - remove unnecessary kvm_reload_remote_mmus after kvm_mmu_zap_all
>>
>> * Issue
>> The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
>> walk and zap all shadow pages one by one, also it need to zap all guest
>> page's rmap and all shadow page's parent spte list. Particularly, things
>> become worse if guest uses more memory or vcpus. It is not good for
>> scalability.
> 
> Xiao, 
> 
> The bulk removal of shadow pages from mmu cache is nerving - it creates
> two codepaths to delete a data structure: the usual, single entry one
> and the bulk one.
> 
> There are two main usecases for kvm_mmu_zap_all(): to invalidate the
> current mmu tree (from kvm_set_memory) and to tear down all pages
> (VM shutdown).
> 
> The first usecase can use your idea of an invalid generation number
> on shadow pages. That is, increment the VM generation number, nuke the root
> pages and thats it. 
> 
> The modifications should be contained to kvm_mmu_get_page() mostly,
> correct? (would also have to keep counters to increase SLAB freeing 
> ratio, relative to number of outdated shadow pages).

Yes.

> 
> And then have codepaths that nuke shadow pages break from the spinlock,

I think this is not needed any more. We can let mmu_notify use the generation
number to invalid all shadow pages, then we only need to free them after
all vcpus down and mmu_notify unregistered - at this point, no lock contention,
we can directly free them.

> such as kvm_mmu_slot_remove_write_access does now (spin_needbreak).

BTW, to my honest, i do not think spin_needbreak is a good way - it does
not fix the hot-lock contention and it just occupies more cpu time to avoid
possible soft lock-ups.

Especially, zap-all-shadow-pages can let other vcpus fault and vcpus contest
mmu-lock, then zap-all-shadow-pages release mmu-lock and wait, other vcpus
create page tables again. zap-all-shadow-page need long time to be finished,
the worst case is, it can not completed forever on intensive vcpu and memory
usage.

I still think the right way to fix this kind of thing is optimization for
mmu-lock.

> That would also solve the current issues without using more memory 
> for pte_list_desc and without the delicate "Reset MMU cache" step.
> 
> What you think?

I agree your point, Marcelo! I will redesign it. Thank you!

