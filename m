Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbaIDBAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:00:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:43891 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932813AbaIDBAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:00:38 -0400
X-IronPort-AV: E=Sophos;i="5.04,462,1406563200"; 
   d="scan'208";a="35487241"
Message-ID: <5407B697.9090501@cn.fujitsu.com>
Date: Thu, 4 Sep 2014 08:47:19 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: <linux-aio@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aio: block exit_aio() until all context requests are
 completed
References: <1409737544-9392-1-git-send-email-guz.fnst@cn.fujitsu.com> <20140903144332.GU20066@kvack.org>
In-Reply-To: <20140903144332.GU20066@kvack.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,
On 09/03/2014 10:43 PM, Benjamin LaHaise wrote:

> Hi Gu,
> 
> On Wed, Sep 03, 2014 at 05:45:44PM +0800, Gu Zheng wrote:
>> It seems that exit_aio() also needs to wait for all iocbs to complete (like
>> io_destroy), but we missed the wait step in current implemention, so fix
>> it in the same way as we did in io_destroy.
> 
> I actually already have another version of this patch queued up that 
> checks the return value of kill_ioctx().

That's good, but I did not find it, have you sent it to the open list?
IMO, there's no need to check the return value of kill_ioctx(), because
context can be marked as DEAD only by io_destroy(), and io_destroy() is
on the block mode. So if we run into the calling of kill_ioctx() in
exit_aio, the context is surely valid.

Thanks,
Gu

> 
> 		-ben
> 
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/aio.c |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 97bc62c..3e35b12 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -793,6 +793,8 @@ void exit_aio(struct mm_struct *mm)
>>  
>>  	for (i = 0; i < table->nr; ++i) {
>>  		struct kioctx *ctx = table->table[i];
>> +		struct completion requests_done =
>> +			COMPLETION_INITIALIZER_ONSTACK(requests_done);
>>  
>>  		if (!ctx)
>>  			continue;
>> @@ -804,7 +806,10 @@ void exit_aio(struct mm_struct *mm)
>>  		 * that it needs to unmap the area, just set it to 0.
>>  		 */
>>  		ctx->mmap_size = 0;
>> -		kill_ioctx(mm, ctx, NULL);
>> +		kill_ioctx(mm, ctx, &requests_done);
>> +
>> +		/* Wait until all IO for the context are done. */
>> +		wait_for_completion(&requests_done);
>>  	}
>>  
>>  	RCU_INIT_POINTER(mm->ioctx_table, NULL);
>> -- 
>> 1.7.7
> 


