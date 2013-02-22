Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3BVELX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:11:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:19504 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab3BVELW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:11:22 -0500
X-IronPort-AV: E=Sophos;i="4.84,713,1355068800"; 
   d="scan'208";a="6746975"
Message-ID: <5126ECF8.2050806@cn.fujitsu.com>
Date: Fri, 22 Feb 2013 11:58:48 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kexec: prevent double free on image allocation failure
References: <1361496375-30994-1-git-send-email-sasha.levin@oracle.com> <87vc9l5cz4.fsf@xmission.com> <5126DC06.5020005@cn.fujitsu.com> <5126E8F2.70502@oracle.com>
In-Reply-To: <5126E8F2.70502@oracle.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/22 11:59:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/22 11:59:52
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月22日 11:41, Sasha Levin 写道:
> On 02/21/2013 09:46 PM, Zhang Yanfei wrote:
>> 于 2013年02月22日 09:55, Eric W. Biederman 写道:
>>> Sasha Levin <sasha.levin@oracle.com> writes:
>>>
>>>> If kimage_normal_alloc() fails to initialize an allocated kimage, it will free
>>>> the image but would still set 'rimage', as a result kexec_load will try
>>>> to free it again.
>>>>
>>>> This would explode as part of the freeing process is accessing internal
>>>> members which point to uninitialized memory.
>>>
>>> Agreed.
>>>
>>> I don't think that failure path has ever actually been exercised.
>>>
>>> The code is wrong, and it is worth fixing.
>>>
>>> Andrew I do you think you could queue this up?  I don't have a handy tree.
>>
>>
>> I still found another malloc/free problem in this function. So I update the patch.
>>
>> ---------------------
>>
>> From 1fb76a35e4109e1435f55048c20ea58622e7f87b Mon Sep 17 00:00:00 2001
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> Date: Fri, 22 Feb 2013 10:34:02 +0800
>> Subject: [PATCH] kexec: fix allocation problems in function kimage_normal_alloc
>>
>> The function kimage_normal_alloc() has 2 allocation problems that may cause
>> failures:
>>
>>   1. If kimage_normal_alloc() fails to initialize an allocated kimage, it will
>>      free the image but would still set 'rimage', as a result kexec_load will
>>      try to free it again.
>>
>>      This would explode as part of the freeing process is accessing internal
>>      members which point to uninitialized memory.
>>
>>   2. If kimage_normal_alloc() fails to alloc pages for image->swap_page, it
>>      should call kimage_free_page_list() to free allocated pages in
>>      image->control_pages list before it frees image.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> ---
>>  kernel/kexec.c |   10 ++++++----
>>  1 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>> index 5e4bd78..f219357 100644
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -223,6 +223,8 @@ out:
>>  
>>  }
>>  
>> +static void kimage_free_page_list(struct list_head *list);
>> +
>>  static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>>  				unsigned long nr_segments,
>>  				struct kexec_segment __user *segments)
>> @@ -236,8 +238,6 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>>  	if (result)
>>  		goto out;
>>  
>> -	*rimage = image;
>> -
>>  	/*
>>  	 * Find a location for the control code buffer, and add it
>>  	 * the vector of segments so that it's pages will also be
>> @@ -259,10 +259,12 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>>  
>>  	result = 0;
>>   out:
>> -	if (result == 0)
>> +	if (result == 0) {
>>  		*rimage = image;
>> -	else
>> +	} else {
>> +		kimage_free_page_list(&image->control_pages);
>>  		kfree(image);
>> +	}
>>  
>>  	return result;
>>  }
> 
> And if do_kimage_alloc() fails instead of kimage_alloc_control_pages()
> you will NULL deref 'image', so now instead of leaking pages the kernel
> will explode.

Oh, I missed this.

> 
> Either way, this issue you've pointed out should be fixed in a separate
> patch.
> 
> 

OK，I will send another patch.

Thanks
Zhang

