Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaJWXb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:31:58 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63210 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJWXb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:31:57 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <54498FE8.4010700@lge.com>
Date: Fri, 24 Oct 2014 08:31:52 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Devendra Naga <devendranaga4@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com
Subject: Re: [RFC 1/2] staging: ion: shrink page-pool by page unit
References: <1414068740-9553-1-git-send-email-gioh.kim@lge.com>	<1414068740-9553-2-git-send-email-gioh.kim@lge.com> <CAOFgiypyxykRPpYn7dAXnnDHhCR-MwRnNT46BdwS28TKobnxuw@mail.gmail.com> <54498C68.8090207@lge.com>
In-Reply-To: <54498C68.8090207@lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-10-24 오전 8:16, Gioh Kim 쓴 글:
>
>
> 2014-10-24 오전 5:36, Devendra Naga 쓴 글:
>> Hello,
>>
>> On Thu, Oct 23, 2014 at 6:22 PM, Gioh Kim <gioh.kim@lge.com> wrote:
>>> This patch shrink page-pool by page unit.
>>>
>>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>>> ---
>>>   drivers/staging/android/ion/ion_page_pool.c   |    5 +++--
>>>   drivers/staging/android/ion/ion_system_heap.c |    7 +++++--
>>>   2 files changed, 8 insertions(+), 4 deletions(-)
>>
>>>
>>
>> --- cut --
>>
>>> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
>>> index da2a63c..36e73c3 100644
>>> --- a/drivers/staging/android/ion/ion_system_heap.c
>>> +++ b/drivers/staging/android/ion/ion_system_heap.c
>>> @@ -211,7 +211,7 @@ static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
>>>                                          int nr_to_scan)
>>>   {
>>>          struct ion_system_heap *sys_heap;
>>> -       int nr_total = 0;
>>> +       int nr_total = 0, nr_freed;
>>>          int i;
>>>
>>>          sys_heap = container_of(heap, struct ion_system_heap, heap);
>>> @@ -219,7 +219,10 @@ static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
>>>          for (i = 0; i < num_orders; i++) {
>>>                  struct ion_page_pool *pool = sys_heap->pools[i];
>>>
>>> -               nr_total += ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
>>> +               nr_freed += ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
>>
>> nr_freed is not initialised to zero. This might result in updating of
>> a garbage value stored initially after nr_freed is created.
>
> Yes, your're right. It's my mistake.
> I testes this on my platform with custom kernel and copied codes.
> I missed a line for it.
> I'm sorry.

Following is the correct code:
nr_freed = ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);

>
>>
>>> +               nr_total += nr_freed;
>>> +               /* nr_to_scan can be negative */
>>> +               nr_to_scan -= nr_freed;
>>>          }
>>>
>>>          return nr_total;
>>> --
>>> 1.7.9.5
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
