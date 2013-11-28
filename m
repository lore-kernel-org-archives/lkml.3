Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3K1IyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:54:00 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36797 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3K1Ix7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:53:59 -0500
Message-ID: <5297049E.3020800@linux.vnet.ibm.com>
Date: Thu, 28 Nov 2013 16:53:50 +0800
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
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131122191429.GA13308@amt.cnet> <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com> <5292EE2F.5090305@linux.vnet.ibm.com> <20131125181254.GB21858@amt.cnet> <529413C1.60302@linux.vnet.ibm.com> <20131126193148.GA18071@amt.cnet>
In-Reply-To: <20131126193148.GA18071@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112808-3568-0000-0000-0000049E6D57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 03:31 AM, Marcelo Tosatti wrote:
> On Tue, Nov 26, 2013 at 11:21:37AM +0800, Xiao Guangrong wrote:
>> On 11/26/2013 02:12 AM, Marcelo Tosatti wrote:
>>> On Mon, Nov 25, 2013 at 02:29:03PM +0800, Xiao Guangrong wrote:
>>>>>> Also, there is no guarantee of termination (as long as sptes are
>>>>>> deleted with the correct timing). BTW, can't see any guarantee of
>>>>>> termination for rculist nulls either (a writer can race with a lockless
>>>>>> reader indefinately, restarting the lockless walk every time).
>>>>>
>>>>> Hmm, that can be avoided by checking dirty-bitmap before rewalk,
>>>>> that means, if the dirty-bitmap has been set during lockless write-protection,
>>>>> it�s unnecessary to write-protect its sptes. Your idea?
>>>> This idea is based on the fact that the number of rmap is limited by
>>>> RMAP_RECYCLE_THRESHOLD. So, in the case of adding new spte into rmap,
>>>> we can break the rewalk at once, in the case of deleting, we can only
>>>> rewalk RMAP_RECYCLE_THRESHOLD times.
>>>
>>> Please explain in more detail.
>>
>> Okay.
>>
>> My proposal is like this:
>>
>> pte_list_walk_lockless()
>> {
>> restart:
>>
>> +	if (__test_bit(slot->arch.dirty_bitmap, gfn-index))
>> +		return;
>>
>> 	code-doing-lockless-walking;
>> 	......
>> }
>>
>> Before do lockless-walking, we check the dirty-bitmap first, if
>> it is set we can simply skip write-protection for the gfn, that
>> is the case that new spte is being added into rmap when we lockless
>> access the rmap.
> 
> The dirty bit could be set after the check.
> 
>> For the case of deleting spte from rmap, the number of entry is limited
>> by RMAP_RECYCLE_THRESHOLD, that is not endlessly.
> 
> It can shrink and grow while lockless walk is performed.

Yes, indeed.

Hmmm, another idea in my mind to fix this is encoding the position into
the reserved bits of desc->more pointer, for example:

          +------+    +------+    +------+
rmapp ->  |Desc 0| -> |Desc 1| -> |Desc 2|
          +------+    +------+    +------+

There are 3 descs on the rmap, and:
rmapp = &desc0 | 1UL | 3UL << 50;
desc0->more = desc1 | 2UL << 50;
desc1->more = desc0 | 1UL << 50
desc2->more = &rmapp | 1UL; (The nulls pointer)

We will walk to the next desc only if the "position" of current desc
is >= the position of next desc. That can make sure we can reach the
last desc anyway.

And in order to avoiding doing too many "rewalk", we will goto the
slow path (do walk with holding the lock) instead when retry the walk
more that N times.

Thanks all you guys in thanksgiving day. :)

