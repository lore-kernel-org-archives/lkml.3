Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaB1H0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:26:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57397 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB1H0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:26:44 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <531039F3.4050707@jp.fujitsu.com>
Date: Fri, 28 Feb 2014 16:25:39 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, <viro@zeniv.linux.org.uk>,
        <jmoyer@redhat.com>, <kosaki.motohiro@gmail.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio ring
 page migration.
References: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com> <1393497616-16428-3-git-send-email-tangchen@cn.fujitsu.com> <20140227145730.GA639@kvack.org>
In-Reply-To: <20140227145730.GA639@kvack.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/27 23:57), Benjamin LaHaise wrote:
> On Thu, Feb 27, 2014 at 06:40:16PM +0800, Tang Chen wrote:
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
>> So add a wmb to synchronize them.
>
> The smp_wmb() is not needed after you added the taking of ctx->completion_lock
> lock since all accesses to ring_pages is then protected by the spinlock.
> Why are you adding this then?  Or have you missed adding the lock somewhere?

Pleaes see following thread. It's a updated patch.

https://lkml.org/lkml/2014/2/27/237

aio_read_events_ring() accesses ring_pages without locking ctx-completion_lock.
If copying old page'date to new page runs after new page was set to ctx->ring_pages
by changing order, aio_read_events_ring() may not work correctly.

So smp_wmb() and smp_rmb() is needed.

Thanks,
Yasuaki Ishimatsu

> Also, if you've changed the patch, it is customary to add a "v2" somewhere in
> the patch title so that I have some idea what version of the patch should be
> applied.
>
> 		-ben



>
>> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>> ---
>>   fs/aio.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 50c089c..f0ed838 100644
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
>> --
>> 1.8.3.1
>




