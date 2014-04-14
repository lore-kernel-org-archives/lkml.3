Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbaDNH6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:58:21 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63768 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaDNH6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:58:20 -0400
MIME-Version: 1.0
In-Reply-To: <534B8540.4000904@cn.fujitsu.com>
References: <5462835.Vnc4dWZRns@daeseok-laptop.cloud.net>
	<534B8540.4000904@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 16:58:20 +0900
Message-ID: <CAHb8M2CK+GLuXKx7Si7WsiDceXES8DR4jgHWLuz95ZahCTTk1Q@mail.gmail.com>
Subject: Re: [PATCH] workqueue: fix double unlock bug
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: tj <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-14 15:50 GMT+09:00 Lai Jiangshan <laijs@cn.fujitsu.com>:
> On 04/14/2014 08:58 AM, Daeseok Youn wrote:
>>
>> mutex_unlock() and put_pwq_unlocked() do not need to be called
>> when alloc_unbound_pwq() is failed.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  kernel/workqueue.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 0ee63af..e6e9f6a 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -4100,7 +4100,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
>>       if (!pwq) {
>>               pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
>>                          wq->name);
>> -             goto out_unlock;
>> +             return;
>>       }
>>
>>       /*
>
>
> Nice catch!!!
>
> The supposed correct behavior is documented in the head of
> this function. We forgot to do it.
>
>  * If NUMA affinity can't be adjusted due to memory allocation failure, it
>  * falls back to @wq->dfl_pwq which may not be optimal but is always
>  * correct.
>
> Could you use the following code instead of "goto out_unlock":
>                 mutex_lock(&wq->mutex);
>                 if (pwq == wq->dfl_pwq)
>                         goto out_unlock;
>                 else
>                         goto use_dfl_pwq;
>
> Correct&BAD. There are two blocks of suck code in this function:
>                 if (pwq == wq->dfl_pwq)
>                         goto out_unlock;
>                 else
>                         goto use_dfl_pwq;
>
> You can replace both these two blocks code to the following code:
>                 goto use_dfl_pwq;
OK. I will remove that "if-else" condition and just use "goto use_dfl_pwq" and
send this patch as V2.

Thanks.
Daeseok Youn
>
> The result is the same as before except it adds some small overhead.
> I don't care the small overhead in this function.
>
> Thanks
> Lai
>
