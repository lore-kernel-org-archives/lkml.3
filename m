Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab3BZEqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:46:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759187Ab3BZEqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:46:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,737,1355068800"; 
   d="scan'208";a="6769063"
Message-ID: <512C3DA6.8080304@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 12:44:22 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Simon Horman <horms@verge.net.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: Re: [PATCH v2] kexec: Use min_t to simplify logic
References: <512A25A1.4040002@gmail.com> <20130225003651.GD17964@verge.net.au> <20130225153554.19cde4b4.akpm@linux-foundation.org>
In-Reply-To: <20130225153554.19cde4b4.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 12:45:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 12:45:14
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月26日 07:35, Andrew Morton 写道:
> On Mon, 25 Feb 2013 09:36:51 +0900
> Simon Horman <horms@verge.net.au> wrote:
> 
>> On Sun, Feb 24, 2013 at 10:37:21PM +0800, Zhang Yanfei wrote:
>>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>>>
>>> This is just a tweak: using min_t to simplify logic of variable
>>> assignments.
>>>
>>> v2:
>>> - Rewrite patch description as Simon suggested.
>>> - Fix an inappropriate if test introduced by v1. Thanks Simon.
>>
>> Hi Zhang,
>>
>> thanks for the update.
>>
>> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Signed-off-by: implies that you were involved in the development or
> patch delivery.  Were you?  If not, an Acked-by or Reviewed-by is more
> appropriate.
> 
> Also, the need to use min_t rather than min is a sign that the types
> are screwed up.  Let's take a look.
> 
>>>
>>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>>> index 2436ffc..effd655 100644
>>> --- a/kernel/kexec.c
>>> +++ b/kernel/kexec.c
>>> @@ -822,13 +822,8 @@ static int kimage_load_normal_segment(struct kimage *image,
>>>  		/* Start with a clear page */
>>>  		clear_page(ptr);
>>>  		ptr += maddr & ~PAGE_MASK;
>>> -		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
>>> -		if (mchunk > mbytes)
>>> -			mchunk = mbytes;
>>> -
>>> -		uchunk = mchunk;
>>> -		if (uchunk > ubytes)
>>> -			uchunk = ubytes;
>>> +		mchunk = min_t(size_t, mbytes, PAGE_SIZE - (maddr & ~PAGE_MASK));
>>> +		uchunk = min_t(size_t, ubytes, mchunk);
> 
> The types of ubytes and mbytes are clearly wrong.  They are initialised
> from a size_t and they are manipulated alongside size_t's.

Ah, yes. I didn't realize this before.

> 
> The types of PAGE_SIZE and PAGE_MASK are vague - iirc they once had
> different types on different architectures, so some form of casting is
> unavoidable here.

Yes.

> 
>>>  		result = copy_from_user(ptr, buf, uchunk);
>>>  		kunmap(page);
>>> @@ -874,13 +869,9 @@ static int kimage_load_crash_segment(struct kimage *image,
>>>  		}
>>>  		ptr = kmap(page);
>>>  		ptr += maddr & ~PAGE_MASK;
>>> -		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
>>> -		if (mchunk > mbytes)
>>> -			mchunk = mbytes;
>>> -
>>> -		uchunk = mchunk;
>>> -		if (uchunk > ubytes) {
>>> -			uchunk = ubytes;
>>> +		mchunk = min_t(size_t, mbytes, PAGE_SIZE - (maddr & ~PAGE_MASK));
>>> +		uchunk = min_t(size_t, ubytes, mchunk);
>>> +		if (mchunk > uchunk) {
>>>  			/* Zero the trailing part of the page */
>>>  			memset(ptr + uchunk, 0, mchunk - uchunk);
>>>  		}
> 
> Again, mybtes and ubytes have the wrong type.
> 
>>> @@ -1461,8 +1452,7 @@ void vmcoreinfo_append_str(const char *fmt, ...)
>>>  	r = vsnprintf(buf, sizeof(buf), fmt, args);
>>>  	va_end(args);
>>>  
>>> -	if (r + vmcoreinfo_size > vmcoreinfo_max_size)
>>> -		r = vmcoreinfo_max_size - vmcoreinfo_size;
>>> +	r = min_t(size_t, r, vmcoreinfo_max_size - vmcoreinfo_size);
>>>  
>>>  	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
> 
> vmcoreinfo_max_size is a size_t and vmcoreinfo_size is a size_t and
> memcpy's `size' argument is a size_t.  Therefore the type of `r' should
> be...  what?  int!  bzzzzt.

yes.

So I will split the patch into two, first fix the wrong types here. Then
use min_t to simply the logic.

Thanks
Zhang

> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 

