Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3KZDC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:02:59 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38732 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3KZDCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:02:50 -0500
Message-ID: <52940F4A.4040701@linux.vnet.ibm.com>
Date: Tue, 26 Nov 2013 11:02:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131122191429.GA13308@amt.cnet> <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com> <20131125140803.GA1489@amt.cnet>
In-Reply-To: <20131125140803.GA1489@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112603-7014-0000-0000-000003F89EEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 10:08 PM, Marcelo Tosatti wrote:
> On Mon, Nov 25, 2013 at 02:11:31PM +0800, Xiao Guangrong wrote:
>>
>> On Nov 23, 2013, at 3:14 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>>
>>> On Wed, Oct 23, 2013 at 09:29:25PM +0800, Xiao Guangrong wrote:
>>>> It likes nulls list and we use the pte-list as the nulls which can help us to
>>>> detect whether the "desc" is moved to anther rmap then we can re-walk the rmap
>>>> if that happened
>>>>
>>>> kvm->slots_lock is held when we do lockless walking that prevents rmap
>>>> is reused (free rmap need to hold that lock) so that we can not see the same
>>>> nulls used on different rmaps
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>
>>> How about simplified lockless walk on the slot while rmapp entry
>>> contains a single spte? (which should be the case with two-dimensional
>>> paging).
>>>
>>> That is, grab the lock when finding a rmap with more than one spte in
>>> it (and then keep it locked until the end).
>>
>> Hmm… that isn't straightforward and more complex than the approach
>> in this patchset. Also it can drop the improvement for shadow mmu that
>> gets great improvement by this patchset.
> 
> It is not more complex, since it would remove list lockless walk. Only
> the spte pointer at rmap[spte] is accessed without a lock. Its much much
> simpler.
> 
>>> For example, nothing prevents lockless walker to move into some
>>> parent_ptes chain, right?
>>
>> No.
>>
>> The nulls can help us to detect this case, for parent_ptes, the nulls points
>> to "shadow page" but for rmaps, the nulls points to slot.arch.rmap. There
>> is no chance that the “rmap" is used as shadow page when slot-lock is held.
> 
> The SLAB cache is the same, so entries can be reused. What prevents
> a desc entry living in slot.arch.rmap to be freed and reused by a
> parent_ptes desc?
> 

We will check is_last_spte(), all the sptes on parent_ptes should be failed.
And Gleb suggested to use a separate slab for rmap, that should be excellent.

