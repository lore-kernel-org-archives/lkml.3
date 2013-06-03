Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab3FCA7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 20:59:03 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44924 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3FCA6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 20:58:55 -0400
Date: Mon, 3 Jun 2013 08:58:49 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH 2/3] mm/kmemleak.c: Use list_for_each_entry_safe to reconstruct function scan_gray_list
References: <519224D8.5090704@gmail.com>, 
	<20130530144028.GF23631@arm.com>
X-Priority: 3
X-GUID: FAB18D1D-89D4-4516-AC3C-7990CBC53379
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201306030858459339090@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r530xQUq003295

>On Tue, May 14, 2013 at 12:49:44PM +0100, majianpeng wrote:
>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> ---
>>  mm/kmemleak.c | 8 +-------
>>  1 file changed, 1 insertion(+), 7 deletions(-)
>> 
>> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>> index b1525db..f0ece93 100644
>> --- a/mm/kmemleak.c
>> +++ b/mm/kmemleak.c
>> @@ -1225,22 +1225,16 @@ static void scan_gray_list(void)
>>  	 * from inside the loop. The kmemleak objects cannot be freed from
>>  	 * outside the loop because their use_count was incremented.
>>  	 */
>> -	object = list_entry(gray_list.next, typeof(*object), gray_list);
>> -	while (&object->gray_list != &gray_list) {
>> +	list_for_each_entry_safe(object, tmp, &gray_list, gray_list) {
>>  		cond_resched();
>>  
>>  		/* may add new objects to the list */
>>  		if (!scan_should_stop())
>>  			scan_object(object);
>>  
>> -		tmp = list_entry(object->gray_list.next, typeof(*object),
>> -				 gray_list);
>> -
>>  		/* remove the object from the list and release it */
>>  		list_del(&object->gray_list);
>>  		put_object(object);
>> -
>> -		object = tmp;
>>  	}
>>  	WARN_ON(!list_empty(&gray_list));
>
>I tried this patch for a few days and I hit the WARN_ON after the loop.
>During scanning, new entries may be added at the end of the loop but we
>need to loop until all the entries have been removed. I probably had a
>reason why I had the 'while' loop.
>
>The key difference is that list_for_each_entry_safe() gets the next
>entry (n or tmp above) before scan_object() and it may hit the end of
>the list. However, scan_object() may do a list_add_tail(&gray_list)
>hence we need to get the next entry after this function.
>
>Basically list_for_each_entry_safe() is not safe with tail additions.
>I'll revert this patch (hasn't reached mainline anyway).
>
Ok, i see. 
Thanks!
>Thanks.
>
>-- 
>Catalinÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
