Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaFDRCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:02:09 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63282 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaFDRCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:02:07 -0400
Message-ID: <538F510C.8030109@kernel.dk>
Date: Wed, 04 Jun 2014 11:02:04 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: scameron@beardog.cce.hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] cciss: use safer test on the result of find_first_zero_bit
References: <20140604145135.GC6970@beardog.cce.hp.com> <538F4F99.2020502@kernel.dk> <alpine.DEB.2.10.1406041858170.2441@hadrien>
In-Reply-To: <alpine.DEB.2.10.1406041858170.2441@hadrien>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 10:59 AM, Julia Lawall wrote:
> 
> 
> On Wed, 4 Jun 2014, Jens Axboe wrote:
> 
>> On 06/04/2014 08:51 AM, scameron@beardog.cce.hp.com wrote:
>>>> Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
>>>> return a larger number than the maximum position argument if that position
>>>> is not a multiple of BITS_PER_LONG.
>>>>
>>>> The semantic match that finds this problem is as follows:
>>>> (http://coccinelle.lip6.fr/)
>>>>
>>>> // <smpl>
>>>> @@
>>>> expression e1,e2,e3;
>>>> statement S1,S2;
>>>> @@
>>>>
>>>> e1 = find_first_zero_bit(e2,e3)
>>>> ...
>>>> if (e1
>>>> - ==
>>>> + >=
>>>>   e3)
>>>> S1 else S2
>>>> // </smpl>
>>>>
>>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>>>
>>>> ---
>>>>  drivers/block/cciss.c |    2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff -u -p a/drivers/block/cciss.c b/drivers/block/cciss.c
>>>> --- a/drivers/block/cciss.c
>>>> +++ b/drivers/block/cciss.c
>>>> @@ -980,7 +980,7 @@ static CommandList_struct *cmd_alloc(ctl
>>>>
>>>>  	do {
>>>>  		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
>>>> -		if (i == h->nr_cmds)
>>>> +		if (i >= h->nr_cmds)
>>>>  			return NULL;
>>>>  	} while (test_and_set_bit(i, h->cmd_pool_bits) != 0);
>>>>  	c = h->cmd_pool + i;
>>>
>>>
>>> Thanks. Ack.
>>>
>>> You can add
>>>
>>> Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>>
>>> to this patch if you want.
>>>
>>> You might consider adding "Cc: stable@vger.kernel.org" into the
>>> sign-off area as well.
>>
>> There are two such instances in cciss.c, btw.
> 
> Actually, there seem to be three, and I didn't find the other two because
> the assignment is inlined into the test.  But the patch isn't needed
> anyway, because it turns out that the result never goes over the bound
> value.

I have always defensively programmed it, but it would make a shitty API
if it did.

-- 
Jens Axboe

