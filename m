Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaCEHAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:00:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41651 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaCEHAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:00:01 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5316CB4B.8060905@jp.fujitsu.com>
Date: Wed, 5 Mar 2014 15:59:23 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <miaox@cn.fujitsu.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, <bcrl@kvack.org>,
        <viro@zeniv.linux.org.uk>, <jmoyer@redhat.com>,
        <kosaki.motohiro@gmail.com>, <kosaki.motohiro@jp.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-aio@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Update PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio
 ring page migration.
References: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com> <1393497616-16428-3-git-send-email-tangchen@cn.fujitsu.com> <530F2A2D.50307@jp.fujitsu.com> <530F3327.8020205@jp.fujitsu.com> <53156621.60900@cn.fujitsu.com>
In-Reply-To: <53156621.60900@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/04 14:35), Miao Xie wrote:
> On 	thu, 27 Feb 2014 21:44:23 +0900, Yasuaki Ishimatsu wrote:
>> When doing aio ring page migration, we migrated the page, and update
>> ctx->ring_pages[]. Like the following:
>>
>> aio_migratepage()
>>   |-> migrate_page_copy(new, old)
>>   |   ......				/* Need barrier here */
>>   |-> ctx->ring_pages[idx] = new
>>
>> Actually, we need a memory barrier between these two operations.
>> Otherwise, if ctx->ring_pages[] is updated before memory copy due to
>> the compiler optimization, other processes may have an opportunity
>> to access to the not fully initialized new ring page.
>>
>> So add a wmb and rmb to synchronize them.
>>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> ---
>>   fs/aio.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 50c089c..8d9b82b 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -327,6 +327,14 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
>>   		pgoff_t idx;
>>   		spin_lock_irqsave(&ctx->completion_lock, flags);
>>   		migrate_page_copy(new, old);
>> +
>> +		/*
>> +		 * Ensure memory copy is finished before updating
>> +		 * ctx->ring_pages[]. Otherwise other processes may access to
>> +		 * new ring pages which are not fully initialized.
>> +		 */
>> +		smp_wmb();
>> +
>>   		idx = old->index;
>>   		if (idx < (pgoff_t)ctx->nr_pages) {
>>   			/* And only do the move if things haven't changed */
>> @@ -1074,6 +1082,12 @@ static long aio_read_events_ring(struct kioctx *ctx,
>>   		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
>>   		pos %= AIO_EVENTS_PER_PAGE;
>>
>> +		/*
>> +		 * Ensure that the page's data was copied from old one by
>> +		 * aio_migratepage().
>> +		 */
>> +		smp_rmb();
>> +
> 
> smp_read_barrier_depends() is better.
> 
> "One could place an A smp_rmb() primitive between the pointer fetch and
>   dereference. However, this imposes unneeded overhead on systems (such as
>   i386, IA64, PPC, and SPARC) that respect data dependencies on the read side.
>   A smp_read_barrier_depends() primitive has been added to the Linux 2.6 kernel
>   to eliminate overhead on these systems."
> 		-- From Chapter 7.1 of <Memory Barriers: a Hardware View for Software Hackers>
> 		   Written by Paul E. McKenney
> 
> Thanks
> Miao

Thank you for your comment.
I'll update soon.

Thanks,
Yasauaki Ishimatsu


> 
>>   		ev = kmap(page);
>>   		copy_ret = copy_to_user(event + ret, ev + pos,
>>   					sizeof(*ev) * avail);
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 


