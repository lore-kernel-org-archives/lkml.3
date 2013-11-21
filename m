Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3KUE1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:27:10 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:60059 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3KUE1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:27:04 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte writable
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20131120194727.GA3353@amt.cnet>
Date: Thu, 21 Nov 2013 12:26:48 +0800
Cc: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <ECBA1CAA-823A-4332-A35D-F0A64CD35C6A@gmail.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130807014828.GA4781@amt.cnet> <5201C7D9.20004@linux.vnet.ibm.com> <20131120002920.GA14230@amt.cnet> <B166B522-2CDB-44CA-B594-687B45A1CF01@linux.vnet.ibm.com> <20131120194727.GA3353@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 21, 2013, at 3:47 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Wed, Nov 20, 2013 at 10:20:09PM +0800, Xiao Guangrong wrote:
>>> But what guarantee does userspace require, from GET_DIRTY_LOG, while vcpus are
>>> executing? 
>> 
>> Aha. Single calling GET_DIRTY_LOG is useless since new dirty page can be generated
>> when GET_DIRTY_LOG is being returned. If user wants to get exact dirty pages the vcpus
>> should be stopped. 
>> 
>>> 
>>> With fast page fault:
>>> 
>>>     if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
>>>             /* The window in here... */
>>>             mark_page_dirty(vcpu->kvm, gfn);
>>> 
>>> And the $SUBJECT set_spte reordering, the rule becomes
>>> 
>>> A call to GET_DIRTY_LOG guarantees to return correct information about 
>>> dirty pages before invocation of the previous GET_DIRTY_LOG call.
>>> 
>>> (see example 1: the next GET_DIRTY_LOG will return the dirty information
>>> there).
>>> 
>> 
>> It seems no.
>> 
>> The first GET_DIRTY_LOG can happen before fast-page-fault，
>> the second GET_DIRTY_LOG happens in the window between cmpxchg()
>> and mark_page_dirty(), for the second one, the information is still “incorrect”.
> 
> Its correct for the previous GET_DIRTY_LOG call.

Oh, yes.

> 
>>> The rule for sptes that is, because kvm_write_guest does not match the
>>> documentation at all.
>> 
>> You mean the case of “kvm_write_guest” is valid (I do not know why it is)?
>> Or anything else?
>> 
>>> 
>>> So before example 1 and this patch, the rule (well for sptes at least) was
>>> 
>>> "Given a memory slot, return a bitmap containing any pages dirtied
>>> since the last call to this ioctl.  Bit 0 is the first page in the
>>> memory slot.  Ensure the entire structure is cleared to avoid padding
>>> issues."
>>> 
>>> Can you explain why it is OK to relax this rule?
>> 
>> It’s because:
>> 1) it doesn’t break current use cases, i.e. Live migration and FB-flushing.
>> 2) the current code, like kvm_write_guest  has already broken the documentation
>>   (the guest page has been written but missed in the dirty bitmap).
>> 3) it’s needless to implement a exact get-dirty-pages since the dirty pages can
>>   no be exactly got except stopping vcpus. 
>> 
>> So i think we'd document this case instead. No?
> 
> Lets figure out the requirements, then. I don't understand why
> FB-flushing is safe (think kvm-autotest: one pixel off the entire
> test fails).

I did not read FB-flushing code, i guess the reason why it can work is:
FB-flushing do periodicity get-dirty-page and flush it.  After guest writes
the page, the page will be flushed in the next GET_DIRTY_LOG.

> 
> Before fast page fault: Pages are either write protected or the
> corresponding dirty bitmap bit is set. Any write faults to dirty logged
> sptes while GET_DIRTY log is executing in the protected section are
> allowed to instantiate writeable spte after GET_DIRTY log is finished.
> 
> After fast page fault: Pages can be writeable and the dirty bitmap not
> set. Therefore data can be dirty before GET_DIRTY executes and still
> fail to be returned in the bitmap.

It’s right. The current GET_DIRTY fail to get the dirty page but the
next GET_DIRTY can get it properly since the current GET_DIRTY
need to flush all TLBs that waits for fast-page-fault finish.

I do not think it’s a big problem since single GET_DIRTY is useless as
i explained in the previous mail.

> 
> Since this patchset does not introduce change in behaviour (fast pf
> did), no reason to avoid merging this.

Yes, thank you, Marcelo! :)

> 
> BTW, since GET_DIRTY log does not require to report concurrent (to
> GET_DIRTY_LOG) write faults, it is not necessary to rewalk the spte
> list, is it?

You mean the “rewalk” we introduced in pte_list_walk_lockless() in this patchset?
I think this rewalk is needed because it’s caused by meet a unexpected nulls that
means we’re walking on the unexpected rmap. If we do not do this, some writable
sptes will be missed.




