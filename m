Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaLGLeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 06:34:36 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaLGLef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 06:34:35 -0500
Message-ID: <54843B48.6020701@nod.at>
Date: Sun, 07 Dec 2014 12:34:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] UBI: Fastmap: Fix memory leaks while closing the
 WL sub-system
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-2-git-send-email-richard@nod.at> <54840C44.4090406@codeaurora.org> <548423E3.8010106@nod.at> <54843AE2.6070608@codeaurora.org>
In-Reply-To: <54843AE2.6070608@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.12.2014 um 12:32 schrieb Tanya Brokhman:
> On 12/7/2014 11:54 AM, Richard Weinberger wrote:
>> Am 07.12.2014 um 09:13 schrieb Tanya Brokhman:
>>> On 11/30/2014 1:35 PM, Richard Weinberger wrote:
>>>> Add a ubi_fastmap_close() to free all resources used by fastmap
>>>> at WL shutdown.
>>>>
>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>> ---
>>>>    drivers/mtd/ubi/wl.c | 21 ++++++++++++++++++---
>>>>    1 file changed, 18 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>>>> index c2822f7..47b215f 100644
>>>> --- a/drivers/mtd/ubi/wl.c
>>>> +++ b/drivers/mtd/ubi/wl.c
>>>> @@ -2064,6 +2064,23 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>>>>        }
>>>>    }
>>>>
>>>> +static void ubi_fastmap_close(struct ubi_device *ubi)
>>>> +{
>>>> +#ifdef CONFIG_MTD_UBI_FASTMAP
>>>> +    int i;
>>>> +
>>>> +    flush_work(&ubi->fm_work);
>>>> +    return_unused_pool_pebs(ubi, &ubi->fm_pool);
>>>> +    return_unused_pool_pebs(ubi, &ubi->fm_wl_pool);
>>>> +
>>>> +    if (ubi->fm) {
>>>> +        for (i = 0; i < ubi->fm->used_blocks; i++)
>>>> +            kfree(ubi->fm->e[i]);
>>>> +    }
>>>> +    kfree(ubi->fm);
>>>
>>> kfree(ubi->fm_buf)?
>>
>> No this is not a typo, I kfree() here ubi->fm by design.
>> What am I missing? :)
> 
> I think you missed freeing ubi->fm_buf, before (not instead) you free ubi->fm :)

No. fm_buf is vfree()d upon detach time.

Thanks,
//richard
