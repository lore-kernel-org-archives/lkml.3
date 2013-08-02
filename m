Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3HBW4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:56:09 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60242 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3HBW4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:56:07 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH 03/12] KVM: MMU: lazily drop large spte
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130802202750.GA12159@amt.cnet>
Date: Sat, 3 Aug 2013 06:56:01 +0800
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D049E89F-488C-4B8C-ACD0-9D2DF6961C2E@gmail.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130802145524.GA3501@amt.cnet> <CEA85F58-33B6-469B-AF14-A40860DEAC05@gmail.com> <20130802202750.GA12159@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 3, 2013, at 4:27 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Fri, Aug 02, 2013 at 11:42:19PM +0800, Xiao Guangrong wrote:
>> 
>> On Aug 2, 2013, at 10:55 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>> 
>>> On Tue, Jul 30, 2013 at 09:02:01PM +0800, Xiao Guangrong wrote:
>>>> Currently, kvm zaps the large spte if write-protected is needed, the later
>>>> read can fault on that spte. Actually, we can make the large spte readonly
>>>> instead of making them un-present, the page fault caused by read access can
>>>> be avoided
>>>> 
>>>> The idea is from Avi:
>>>> | As I mentioned before, write-protecting a large spte is a good idea,
>>>> | since it moves some work from protect-time to fault-time, so it reduces
>>>> | jitter.  This removes the need for the return value.
>>>> 
>>>> [
>>>> It has fixed the issue reported in 6b73a9606 by stopping fast page fault
>>>> marking the large spte to writable
>>>> ]
>>> 
>>> Xiao,
>>> 
>>> Can you please write a comment explaining why are the problems 
>>> with shadow vs large read-only sptes (can't recall anymore),
>>> and then why it is now safe to do it.
>> 
>> Hi Marcelo,
>> 
>> Thanks for your review.  Yes. The bug reported in  6b73a9606 is, in this patch,
>> we mark the large spte as readonly when the pages are dirt logged and the
>> readonly spte can be set to writable by fast page fault, but on that path, it failed
>> to check dirty logging, so it will set the large spte to writable but only set the first
>> page to the dirty bitmap.
>> 
>> For example:
>> 
>> 1): KVM maps 0 ~ 2M memory to guest which is pointed by SPTE and SPTE
>>     is writable.
>> 
>> 2): KVM dirty log 0 ~ 2M,  then set SPTE to readonly
>> 
>> 3): fast page fault set SPTE to writable and set page 0 to the dirty bitmap.
>> 
>> Then 4K ~ 2M memory is not dirty logged.
> 
> Ok can you write a self contained summary of read-only large sptes (when
> they are created, when destroyed, from which point they can't be created,
> etc), and the interaction with shadow write protection and creation of
> writeable sptes?
> Its easy to get lost.

Okay, will do.

