Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaDGQF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:05:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47329 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaDGQFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:05:52 -0400
Message-ID: <5342CCDB.3080402@codeaurora.org>
Date: Mon, 07 Apr 2014 19:05:47 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] mtd: ubi: Free peb's synchronously for fastmap
References: <1396339305-16005-1-git-send-email-tlinder@codeaurora.org> <CAFLxGvyUsLZsi3iiape6BivaduvfqZh8kXXwYOFuExUJho09kg@mail.gmail.com>
In-Reply-To: <CAFLxGvyUsLZsi3iiape6BivaduvfqZh8kXXwYOFuExUJho09kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/2014 4:02 PM, Richard Weinberger wrote:
> On Tue, Apr 1, 2014 at 10:01 AM, Tanya Brokhman <tlinder@codeaurora.org> wrote:
>> At first mount it's possible that there are not enough free PEBs since
>> there are PEB's pending to be erased. In such scenario, fm_pool (which is
>> the pool from which user required PEBs are allocated) will be empty.
>> Try fixing the above described situation by synchronously performing
>> pending erase work, thus produce another free PEB.
>>
>> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>>
>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>> index 457ead3..9a36f78 100644
>> --- a/drivers/mtd/ubi/wl.c
>> +++ b/drivers/mtd/ubi/wl.c
>> @@ -595,10 +595,29 @@ static void refill_wl_pool(struct ubi_device *ubi)
>>   static void refill_wl_user_pool(struct ubi_device *ubi)
>>   {
>>          struct ubi_fm_pool *pool = &ubi->fm_pool;
>> +       int err;
>>
>>          return_unused_pool_pebs(ubi, pool);
>>
>>          for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
>> +retry:
>> +               if (!ubi->free.rb_node ||
>> +                  (ubi->free_count - ubi->beb_rsvd_pebs < 1)) {
>> +                       /*
>> +                        * There are no available PEBs. Try to free
>> +                        * PEB by means of synchronous execution of
>> +                        * pending works.
>> +                        */
>> +                       if (ubi->works_count == 0)
>> +                               break;
>> +                       spin_unlock(&ubi->wl_lock);
>> +                       err = do_work(ubi);
>> +                       spin_lock(&ubi->wl_lock);
>
> This is basically what produce_free_peb() does.

Right. I didn't use t just because of the termination condition. 
produce_free_peb stops if there is 1 free peb. I need more then 1

>
>> +                       if (err < 0)
>> +                               break;
>> +                       goto retry;
>> +               }
>> +
>>                  pool->pebs[pool->size] = __wl_get_peb(ubi);
>
> __wl_get_peb() already calls produce_free_peb() when we run out of free PEBs.
>
> Does your patch really fix a problem you encounter or did you find the
> issue by reviewing
> the code?
>

Yes. We encountered this issue, as described in the commit message. This 
is the fix. Verified and working for us.

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
