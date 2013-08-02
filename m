Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3HBPm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:42:28 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43194 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3HBPm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:42:26 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH 03/12] KVM: MMU: lazily drop large spte
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130802145524.GA3501@amt.cnet>
Date: Fri, 2 Aug 2013 23:42:19 +0800
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CEA85F58-33B6-469B-AF14-A40860DEAC05@gmail.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130802145524.GA3501@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2, 2013, at 10:55 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Tue, Jul 30, 2013 at 09:02:01PM +0800, Xiao Guangrong wrote:
>> Currently, kvm zaps the large spte if write-protected is needed, the later
>> read can fault on that spte. Actually, we can make the large spte readonly
>> instead of making them un-present, the page fault caused by read access can
>> be avoided
>> 
>> The idea is from Avi:
>> | As I mentioned before, write-protecting a large spte is a good idea,
>> | since it moves some work from protect-time to fault-time, so it reduces
>> | jitter.  This removes the need for the return value.
>> 
>> [
>>  It has fixed the issue reported in 6b73a9606 by stopping fast page fault
>>  marking the large spte to writable
>> ]
> 
> Xiao,
> 
> Can you please write a comment explaining why are the problems 
> with shadow vs large read-only sptes (can't recall anymore),
> and then why it is now safe to do it.

Hi Marcelo,

Thanks for your review.  Yes. The bug reported in  6b73a9606 is, in this patch,
we mark the large spte as readonly when the pages are dirt logged and the
readonly spte can be set to writable by fast page fault, but on that path, it failed
to check dirty logging, so it will set the large spte to writable but only set the first
page to the dirty bitmap.

For example:

1): KVM maps 0 ~ 2M memory to guest which is pointed by SPTE and SPTE
     is writable.

2): KVM dirty log 0 ~ 2M,  then set SPTE to readonly

3): fast page fault set SPTE to writable and set page 0 to the dirty bitmap.

Then 4K ~ 2M memory is not dirty logged.

In this version, we let fast page fault do not mark large spte to writable if
its page are dirty logged.  But it is still not safe as you pointed out.

>> 
>> 
>> 	/*
>> +	 * Can not map the large spte to writable if the page is dirty
>> +	 * logged.
>> +	 */
>> +	if (sp->role.level > PT_PAGE_TABLE_LEVEL && force_pt_level)
>> +		goto exit;
>> +
> 
> It is not safe to derive slot->dirty_bitmap like this: 
> since dirty log is enabled via RCU update, "is dirty bitmap enabled"
> info could be stale by the time you check it here via the parameter,
> so you can instantiate a large spte (because force_pt_level == false),
> while you should not.

Good catch! This is true even if we enable dirty log under the protection
of mmu lock.

How about let the fault page fault only fix the small spte, that is changing
the code to:
	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
		goto exit;
?


