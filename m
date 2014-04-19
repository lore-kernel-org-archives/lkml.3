Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaDSOEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:04:09 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43916 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaDSOEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:04:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140419130726.GC3277@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
	<1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
	<1397907496-5993-6-git-send-email-laijs@cn.fujitsu.com>
	<20140419130726.GC3277@htj.dyndns.org>
Date: Sat, 19 Apr 2014 22:04:06 +0800
X-Google-Sender-Auth: p79gs9Fv78uRY9BdbJ2DzOLBC4g
Message-ID: <CACvQF52jWM1LFQGYZFyktCubt6YWdCx6kd3+aCW=3mCpzCR1Mw@mail.gmail.com>
Subject: Re: [PATCH 5/9 V2] idr: covert BUG_ON() to WARN_ON_ONCE() if the
 argument is invalid.
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 9:07 PM, Tejun Heo <tj@kernel.org> wrote:
> On Sat, Apr 19, 2014 at 07:38:12PM +0800, Lai Jiangshan wrote:
>> @@ -559,7 +559,7 @@ void idr_remove(struct idr *idp, int id)
>>       struct idr_layer *p;
>>       struct idr_layer *to_free;
>>
>> -     if (id < 0)
>> +     if (WARN_ON_ONCE(id < 0))
>>               return;
>
> ISTR callers which call in with error value, but yeah weeding them out
> could be a good idea.  Shouldn't it be idr_remove_warning() though?

WARN_ON_ONCE() for invalid id (negative id).
idr_remove_warning() for unallocated id.

>
>> @@ -1030,6 +1030,9 @@ void ida_remove(struct ida *ida, int id)
>>       int n;
>>       struct ida_bitmap *bitmap;
>>
>> +     if (WARN_ON_ONCE(id < 0))
>> +             return;
>
> Why not jump to err?

WARN_ON_ONCE() for invalid id (negative id).
"goto err" for unallocated id.

>
>> +
>>       if (idr_id > idr_max(ida->idr.layers))
>>               goto err;
>>
>> @@ -1096,13 +1099,14 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
>>       unsigned int max;
>>       unsigned long flags;
>>
>> -     BUG_ON((int)start < 0);
>> -     BUG_ON((int)end < 0);
>> +     if (WARN_ON_ONCE(((int)start < 0) || ((int)end < 0)))
>> +             return -EINVAL;
>>
>>       if (end == 0)
>>               max = 0x80000000;
>>       else {
>> -             BUG_ON(end < start);
>> +             if (WARN_ON_ONCE(end < start))
>> +                     return -ENOSPC;
>
> -EINVAL

In my V1 patch, it returns -EINVAL.

The V2 changelog explain this change: make the returned value as the
same as idr_alloc().
###
It is important for cyclic allocation (idr_alloc()).

int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end,
gfp_t gfp_mask)
{
int id;

id = idr_alloc(idr, ptr, max(start, idr->cur), end, gfp_mask);
if (id == -ENOSPC)
id = idr_alloc(idr, ptr, start, end, gfp_mask);

if (likely(id >= 0))
idr->cur = id + 1;
return id;
}

idr->cur can equals to @end. idr_alloc() should return  -ENOSPC for
next idr_alloc().

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
