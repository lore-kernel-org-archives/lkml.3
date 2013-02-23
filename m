Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3BWNsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 08:48:53 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61946 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3BWNsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 08:48:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130222135938.c6f28ff5.akpm@linux-foundation.org>
References: <5126F5BD.1030602@cn.fujitsu.com>
	<20130222135938.c6f28ff5.akpm@linux-foundation.org>
Date: Sat, 23 Feb 2013 21:48:48 +0800
Message-ID: <CANBD6kHEASSBMzo9n85-gfrpO7q_GV+GYKkrJJcGRFFR7Z5w3w@mail.gmail.com>
Subject: Re: [PATCH] kexec: fix memory leak in function kimage_normal_alloc
From: Yanfei Zhang <zhangyanfei.yes@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/23 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 22 Feb 2013 12:36:13 +0800
> Zhang Yanfei <zhangyanfei@cn.fujitsu.com> wrote:
>
>> If kimage_normal_alloc() fails to alloc pages for image->swap_page, it
>> should call kimage_free_page_list() to free allocated pages in
>> image->control_pages list before it frees image.
>>
>> ...
>>
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -223,6 +223,8 @@ out:
>>
>>  }
>>
>> +static void kimage_free_page_list(struct list_head *list);
>> +
>>  static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>>                               unsigned long nr_segments,
>>                               struct kexec_segment __user *segments)
>> @@ -248,22 +250,22 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>>                                          get_order(KEXEC_CONTROL_PAGE_SIZE));
>>       if (!image->control_code_page) {
>>               printk(KERN_ERR "Could not allocate control_code_buffer\n");
>> -             goto out;
>> +             goto out_free;
>>       }
>>
>>       image->swap_page = kimage_alloc_control_pages(image, 0);
>>       if (!image->swap_page) {
>>               printk(KERN_ERR "Could not allocate swap buffer\n");
>> -             goto out;
>> +             goto out_free;
>>       }
>>
>> -     result = 0;
>> - out:
>> -     if (result == 0)
>> -             *rimage = image;
>> -     else
>> -             kfree(image);
>> +     *rimage = image;
>> +     return 0;
>>
>> +out_free:
>> +     kimage_free_page_list(&image->control_pages);
>> +     kfree(image);
>> +out:
>>       return result;
>>  }
>
> kimage_alloc_normal_control_pages() won't add any pages to the image if
> one of its allocation attemtps failed.  So afaict the first `goto
> out_free' could be just `goto out'.

Nop, the first 'goto out_free' is to free allocated 'image' if the allocation of
image->control_code_page failed. If changed to 'goto out', 'image' cannot
be freed and leads to memory leak.

>
> The second `goto out_free' does appear to be needed: it frees the pages
> allocated by the first call to kimage_alloc_control_pages().  I think.
> The kimage_alloc_control_pages() handling of image->type is a bit
> twisty.

Yeah, it could just call kimage_alloc_normal_control_pages directly.

>
> Please double-check the logic?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
