Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaB1Bnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:43:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaB1Bnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:43:42 -0500
X-IronPort-AV: E=Sophos;i="4.97,559,1389715200"; 
   d="scan'208";a="9618412"
Message-ID: <530FE66F.9040308@cn.fujitsu.com>
Date: Fri, 28 Feb 2014 09:29:19 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, viro@zeniv.linux.org.uk,
        jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio ring
 page migration.
References: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com> <1393497616-16428-3-git-send-email-tangchen@cn.fujitsu.com> <20140227145730.GA639@kvack.org>
In-Reply-To: <20140227145730.GA639@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/28 09:35:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/28 09:41:13,
	Serialize complete at 2014/02/28 09:41:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,
On 02/27/2014 10:57 PM, Benjamin LaHaise wrote:

> On Thu, Feb 27, 2014 at 06:40:16PM +0800, Tang Chen wrote:
>> When doing aio ring page migration, we migrated the page, and update
>> ctx->ring_pages[]. Like the following:
>>
>> aio_migratepage()
>>  |-> migrate_page_copy(new, old)
>>  |   ......				/* Need barrier here */
>>  |-> ctx->ring_pages[idx] = new
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
> Also, if you've changed the patch, it is customary to add a "v2" somewhere in 
> the patch title so that I have some idea what version of the patch should be 
> applied.

The completion_lock just protects updating ring->head when reading events,
so wmb is still needed here.

Regards,
Gu

> 
> 		-ben
> 
>> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>> ---
>>  fs/aio.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 50c089c..f0ed838 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -327,6 +327,14 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
>>  		pgoff_t idx;
>>  		spin_lock_irqsave(&ctx->completion_lock, flags);
>>  		migrate_page_copy(new, old);
>> +
>> +		/*
>> +		 * Ensure memory copy is finished before updating
>> +		 * ctx->ring_pages[]. Otherwise other processes may access to
>> +		 * new ring pages which are not fully initialized.
>> +		 */
>> +		smp_wmb();
>> +
>>  		idx = old->index;
>>  		if (idx < (pgoff_t)ctx->nr_pages) {
>>  			/* And only do the move if things haven't changed */
>> -- 
>> 1.8.3.1
> 


