Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaLGJtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 04:49:49 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbaLGJtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 04:49:47 -0500
Message-ID: <548422B8.5080307@nod.at>
Date: Sun, 07 Dec 2014 10:49:44 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] UBI: Fastmap: Make ubi_refill_pools() fair
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-7-git-send-email-richard@nod.at> <5481F1A1.50609@codeaurora.org> <54821BF6.8010000@nod.at> <548407F0.90209@codeaurora.org>
In-Reply-To: <548407F0.90209@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.12.2014 um 08:55 schrieb Tanya Brokhman:
> Hi Richard
> 
> On 12/5/2014 10:56 PM, Richard Weinberger wrote:
>>>> -/**
>>>> - * refill_wl_user_pool - refills all the fastmap pool used by ubi_wl_get_peb.
>>>> - * @ubi: UBI device description object
>>>> - */
>>>> -static void refill_wl_user_pool(struct ubi_device *ubi)
>>>> -{
>>>> -    struct ubi_fm_pool *pool = &ubi->fm_pool;
>>>> +            pool->pebs[pool->size] = e->pnum;
>>>> +            pool->size++;
>>>> +        } else
>>>> +            enough++;
>>>>
>>>> -    return_unused_pool_pebs(ubi, pool);
>>>> +        if (wl_pool->size < wl_pool->max_size) {
>>>> +            if (!ubi->free.rb_node ||
>>>> +               (ubi->free_count - ubi->beb_rsvd_pebs < 5))
>>>> +                break;
>>>>
>>>> -    for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
>>>> -        pool->pebs[pool->size] = __wl_get_peb(ubi);
>>>> -        if (pool->pebs[pool->size] < 0)
>>>> +            e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
>>>> +            self_check_in_wl_tree(ubi, e, &ubi->free);
>>>> +            rb_erase(&e->u.rb, &ubi->free);
>>>> +            ubi->free_count--;
>>>
>>> why don't you use wl_get_peb() here?
>>
>> Because wl_get_peb() is not equivalent to the above code.
>> We want a PEB to be used for wear-leveling not for "end users" like UBIFS.
> 
> sorry, my mistake. I meant wl_get_wle() (the new function). the only diff between wl_get_wle() and the above is that you use find_wl_entry() and wl_get_wle() uses
> find_mean_wl_entry() and takes the anchor into consideration. So I;m trying to understand why wl_get_wle() isn't good here?

wl_get_wle() uses find_mean_wl_entry() which returns a PEB to be used for "end users".
Please see the 3rd parameter to find_wl_entry().
For "end users" a medium worn out PEB is good enough.

Thanks,
//richard
