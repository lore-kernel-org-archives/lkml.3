Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaDSOYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:24:05 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56633 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaDSOX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:23:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140419130112.GB3277@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
	<1397825404-12039-7-git-send-email-laijs@cn.fujitsu.com>
	<20140418171717.GE23576@htj.dyndns.org>
	<5352535D.8030407@cn.fujitsu.com>
	<20140419130112.GB3277@htj.dyndns.org>
Date: Sat, 19 Apr 2014 22:23:58 +0800
X-Google-Sender-Auth: 8m7gxl9Moc6zyvORQ-TufiVwBwg
Message-ID: <CACvQF53zXjTRgL_uHxp=J04efqBuD6L7VbCOpRvSyxQRiBoA_w@mail.gmail.com>
Subject: Re: [PATCH 6/8] idr: avoid ping-pong
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

On Sat, Apr 19, 2014 at 9:01 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sat, Apr 19, 2014 at 06:43:41PM +0800, Lai Jiangshan wrote:
>> On 04/19/2014 01:17 AM, Tejun Heo wrote:
>> It only frees one layer. And the ida_pre_get() for the next ida_get_new*()
>> will allocation it back again. The aim "Throw away extra resources one by one"
>> can't be achieved. It can't keep its memory footprint minimal.
>
> Isn't the point not keeping the memory around per-ida between
> allocations which can be arbitrarily long?  Why isn't it achieved?

"Throw away one layer" is achieved.
"one by one" can't be achieved.

>
>> > I think the right
>> > thing to do is implementing ida_preload() which is simliar to
>> > idr_preload() and do away with per-ida layer cache.
>>
>> Yes and no.

Yes: I agree to add ida_preload().
No: Because I think we don't need to expose ida_preload().

>>
>> We need a static private ida_preload() for ida_simple_get() only.
>>
>> Because the IDA doesn't have any query-function, so IDA's own synchronization
>> is enough for all use cases, IDA should off-loads the caller's
>> synchronization burden.
>
> Hmmm?  And why can't that use preload on its own?

We need to use  preload  for ida_simple_get().
But we don't need to expose the ida_preload() if we kill the
ida_get_new*() APIs.
(The reason why we can kill the ida_get_new*() is explained below.)

>
>> In my todo-list, IDA only needs the following functions. other functions
>> will be deprecated and scheduled to be removed:
>>       void ida_destroy(struct ida *ida);
>>       void ida_init(struct ida *ida);
>>       int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
>>                          gfp_t gfp_mask);
>>       void ida_simple_remove(struct ida *ida, unsigned int id);
>>
>> (I don't think we need any query-function, But...)
>> If in the future we need some query-functions such as:
>>       ida_is_this_id_allocated()
>>       ida_find_next_[un]allocated_id(),
>> In this case, we can expose the ida_preload() and ida_alloc() at the same time that
>> we introduce the query-functions.
>
> Regardless of interface, we can still switch to per-cpu layer caching
> which would make this per-ida allocation issue go away.

agree.

>  I'd much
> prefer to see that than debating the (dis)merits of this patch.

agree.

Please drop this patch.
It will be better if we will cleanup it(and all free list related code)
after ida_preload() is added.

Thanks
Lai

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
