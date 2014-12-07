Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaLGJpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 04:45:21 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbaLGJpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 04:45:19 -0500
Message-ID: <548421AB.90303@nod.at>
Date: Sun, 07 Dec 2014 10:45:15 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] UBI: Fastmap: Fix races in ubi_wl_get_peb()
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-5-git-send-email-richard@nod.at> <5481AE79.1090900@codeaurora.org> <5481B120.5020409@nod.at> <5481E336.8090303@codeaurora.org> <54821EC3.3030107@nod.at> <54840385.5040305@codeaurora.org>
In-Reply-To: <54840385.5040305@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.12.2014 um 08:36 schrieb Tanya Brokhman:
> On 12/5/2014 11:08 PM, Richard Weinberger wrote:
> 
>>
>>>>>>             spin_unlock(&ubi->wl_lock);
>>>>>> +        if (retried) {
>>>>>> +            ubi_err(ubi, "Unable to get a free PEB from user WL pool");
>>>>>> +            ret = -ENOSPC;
>>>>>> +            goto out;
>>>>>> +        }
>>>>>> +        retried = 1;
>>>>>
>>>>> Why did you decide to retry in this function? and why only 1 retry attempt? I'm not against it, trying to understand the logic.
>>>>
>>>> Because failing immediately with -ENOSPC is not nice.
>>>
>>> Why not? this is what was done before....
>>
>> The behavior from before was not good.
>> If we return here a -ENOSPC it is not because we ran out of free PEBs, it is because the pool contains
>> no free PEBs and needs refilling.
>> As between refilling the pool and requesting a fresh PEB from it another thread could "steal" all PEBs
>> we retry.
>>
>>> I think what I really bothers me in this case is that you don't sleep, you branch immediately to retry again, so the chances that there will be context switch and free pebs appear
>>> aren't that high.
>>> I'm used to functions using some sort of "retry" logic to sleep before retrying. Of course sleeping isn't a good idea here. That's why the "retry" bugs me a bit.
>>
>> You mean a cond_resched()?
>> This retry-logic is common pattern in UBI. For exmaple see ubi_wl_put_peb().
> 
> you're right. didn't pay much attention to ubi_wl_put_peb() before. don't like it there either :)
> perhaps we can rethink this later for both cases.

If there is room for improvement I'm all open for an extra patch set all over UBI. :-)

Thanks,
//richard
