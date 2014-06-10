Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbaFJB6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:58:09 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37379 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934321AbaFJB6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:58:07 -0400
Message-ID: <5396662B.7010202@kernel.dk>
Date: Mon, 09 Jun 2014 19:58:03 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Junxiao Bi <junxiao.bi@oracle.com>, Andreas Mohr <andi@lisas.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: make nr_requests tunable for loop
References: <20140609072942.GA30728@rhlx01.hs-esslingen.de> <5395D88C.6070007@kernel.dk> <539660F9.9060408@oracle.com>
In-Reply-To: <539660F9.9060408@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-09 19:35, Junxiao Bi wrote:
> On 06/09/2014 11:53 PM, Jens Axboe wrote:
>> On 2014-06-09 01:29, Andreas Mohr wrote:
>>> Hi,
>>>
>>> having had a look at current mainline sources,
>>> frankly I've (well, initially...) got trouble understanding
>>> what this patch is doing.
>>>
>>> It's replacing an aggressive error-type bail-out (-EINVAL) for NULL
>>> request_fn
>>> with an inoccuous-looking "return ret;", yet that ret content currently
>>> *implicitly* is a >= 0 value (resulting from processing by earlier code
>>> which may or may not get incomprehensibly rewritten in future).
>>> I don't understand the reasons for this huge change in return value
>>> handling
>>> (since it's now not assigning a specific return value
>>> for this modified bail-out case).
>>>
>>> OK, well... you could say that since all this function ever was
>>> interested in is the result value of queue_var_store()
>>> (except for error bail-out cases), doing an interim "return ret;"
>>> (which is exactly what the function tail is also doing)
>>> is exactly right.
>>>
>>> But still simple textual appearance of the resulting patch hunks
>>> seems strangely asymmetric
>>> which may easily be a canary for structurally wrong layering of this
>>> function.
>>> Not to mention the now required extra spin_unlock_irq()
>>> in interim return handler...
>>>
>>>
>>> Well, after further analysis I would come to the conclusion
>>> that in general queue_requests_store() does a LOT more than it should -
>>> since blk-sysfs.c's only (expected!) purpose is
>>> to do parameterization of request_queue behaviour as gathered
>>> from sysfs attribute space,
>>> all that function should ever be concerned with is parsing that sysfs
>>> value
>>> and then calling a blk helper for configuration of that very
>>> attribute value
>>> which would *internally* do all the strange internal queue magic
>>> that is currently being updated *open-coded*
>>> at this supposedly *sysfs*-specific place. Ugh.
>>> Main question here: what would one do if one decided to rip out sysfs
>>> and use something entirely different for parameterization?
>>> Yeah indeed - thought so...
>>>
>>>
>>> So yeah, I'd definitely say that that function is lacking some cleanup
>>> which would possibly then even lead (or: would have led ;)
>>> to a much more nicely symmetric textual appearance
>>> of the patch hunk of the small but quite likely useful change
>>> that you currently intend to have here.
>>
>> If you are done ranting, look at the current tree where it has been
>> split out. There was no reason to have it split before, since the
>> sysfs entry point was the only place where we updated nr_requests. If
>> that code has been duplicated, there would have been a justified
>> reason for writing two pages about it.
> Yes, agree, this is the only place updating nr_requests,  we can split
> it as a separated function if it needs updating at some other places in
> future.

Please look at the current tree... It is already split up.

-- 
Jens Axboe

