Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaJ0AYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:24:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50739 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaJ0AYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:24:51 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <544D90CD.3090107@lge.com>
Date: Mon, 27 Oct 2014 09:24:45 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
CC: devel@driverdev.osuosl.org, gunho.lee@lge.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 2/3] staging: ion: debugfs to shrink pool
References: <1414133248-639-1-git-send-email-gioh.kim@lge.com> <1414133248-639-3-git-send-email-gioh.kim@lge.com> <544AB8BD.70201@codeaurora.org>
In-Reply-To: <544AB8BD.70201@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-10-25 오전 5:38, Laura Abbott 쓴 글:
> Hi,
>
> On 10/23/2014 11:47 PM, Gioh Kim wrote:
>> This patch creates debugfs files, /sys/kernel/debug/ion/heaps/system_shrink,
>> to shrink pool or get pool size.
>> Reading the file returns pool size and writing occurs to shrink pool.
>>
>
> Can you clarify here that you are updating the existing debugfs
> infrastructure? Since the shrinker debugfs was commented out before
> it missed the API update so it would be good to note that as well.

OK, I will at the v2 patch.

>
>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>> ---
>>   drivers/staging/android/ion/ion.c |   31 ++++++++-----------------------
>>   1 file changed, 8 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
>> index 290d4d2..ecc1121 100644
>> --- a/drivers/staging/android/ion/ion.c
>> +++ b/drivers/staging/android/ion/ion.c
>> @@ -1463,43 +1463,29 @@ static const struct file_operations debug_heap_fops = {
>>       .release = single_release,
>>   };
>>
>> -#ifdef DEBUG_HEAP_SHRINKER
>
> We're now unconditionally adding the shrinker debugfs. I'm not sure if
> this is something we want in production code. Could you turn this
> into a proper Kconfig?

The interface is via debugfs.
I think we don't turn on the debugfs in production code.

>
>>   static int debug_shrink_set(void *data, u64 val)
>>   {
>>       struct ion_heap *heap = data;
>> -    struct shrink_control sc;
>>       int objs;
>>
>> -    sc.gfp_mask = -1;
>> -    sc.nr_to_scan = 0;
>> -
>> -    if (!val)
>> -        return 0;
>> -
>> -    objs = heap->shrinker.shrink(&heap->shrinker, &sc);
>> -    sc.nr_to_scan = objs;
>> +    if (val)
>> +        objs = val;
>> +    else
>> +        objs = heap->ops->shrink(heap, __GFP_HIGHMEM, 0);
>>
>> -    heap->shrinker.shrink(&heap->shrinker, &sc);
>> +    (void)heap->ops->shrink(heap, __GFP_HIGHMEM, objs);
>
> The shrinker API now has separate functions for counting and scanning
> and ion wraps the calls to those as well to account for the deferred
> freelist. I realize the existing behavior may have been broken but the
> debugfs seems incomplete if it's not taking that into account as well.

ion_heap_shrink_count() and ion_heap_shrink_scan() are called by shrinker.
I think debug_shrink_set()/get() are for debugfs, so they can work without shrinker.

You can count deferred freelist via other debugfs file, for instance /sys/kernel/debug/ion/heaps/system.
I think debug_shrink_set()/get() should work by the number of pages in the pool.


>
>>       return 0;
>>   }
>>
>>   static int debug_shrink_get(void *data, u64 *val)
>>   {
>>       struct ion_heap *heap = data;
>> -    struct shrink_control sc;
>> -    int objs;
>> -
>> -    sc.gfp_mask = -1;
>> -    sc.nr_to_scan = 0;
>> -
>> -    objs = heap->shrinker.shrink(&heap->shrinker, &sc);
>> -    *val = objs;
>> +    *val = heap->ops->shrink(heap, __GFP_HIGHMEM, 0);
>>       return 0;
>>   }
>>
>>   DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
>>               debug_shrink_set, "%llu\n");
>> -#endif
>>
>>   void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
>>   {
>> @@ -1534,8 +1520,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
>>               path, heap->name);
>>       }
>>
>> -#ifdef DEBUG_HEAP_SHRINKER
>> -    if (heap->shrinker.shrink) {
>> +    if (heap->ops->shrink) {
>
> Technically a heap doesn't need to set ops->shrink to have a shrinker
> set up (not that it really matters for the current setup). Checking
> for scan_objects would be better.
>
>>           char debug_name[64];
>>
>>           snprintf(debug_name, 64, "%s_shrink", heap->name);
>> @@ -1550,7 +1535,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
>>                   path, debug_name);
>>           }
>>       }
>> -#endif
>> +
>>       up_write(&dev->lock);
>>   }
>>
>>
>
> Thanks,
> Laura
>
