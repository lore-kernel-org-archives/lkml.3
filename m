Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaLGOWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 09:22:39 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaLGOWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 09:22:37 -0500
Message-ID: <548462A8.2010107@nod.at>
Date: Sun, 07 Dec 2014 15:22:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] UBI: Fastmap: Notify user in case of an ubi_update_fastmap()
 failure
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-4-git-send-email-richard@nod.at> <54845D53.1070903@codeaurora.org>
In-Reply-To: <54845D53.1070903@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.12.2014 um 14:59 schrieb Tanya Brokhman:
> Hi Richard,
> 
> On 11/30/2014 1:35 PM, Richard Weinberger wrote:
>> If ubi_update_fastmap() fails notify the user.
>> This is not a hard error as ubi_update_fastmap() makes sure that upon failure
>> the current on-flash fastmap will no be used upon next UBI attach.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>   drivers/mtd/ubi/wl.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>> index 523d8a4..7821342 100644
>> --- a/drivers/mtd/ubi/wl.c
>> +++ b/drivers/mtd/ubi/wl.c
>> @@ -657,7 +657,11 @@ again:
>>        * refill the WL pool synchronous. */
>>       if (pool->used == pool->size || wl_pool->used == wl_pool->size) {
>>           spin_unlock(&ubi->wl_lock);
>> -        ubi_update_fastmap(ubi);
>> +        ret = ubi_update_fastmap(ubi);
>> +        if (ret) {
>> +            ubi_msg(ubi, "Unable to write a new fastmap: %i", ret);
>> +            return -ENOSPC;
> 
> Why do you fail the whole function (ubi_wl_get_peb) if fastmap update failed? Its possible that the fm_pools were refilled correctly, and the actual fastmap_write failed, so there
> is nothing preventing the user to get peb allocated and continue working. You invalidate the fastmap, so if powercut occurs a full scan will be performed. So its possible to
> allocate from fm_pools (although fastmap is not valid on disc) and try writing fastmap again when the pools filled up.
> I'm for the ubi_msg but against "return -ENOSPC;"

Maybe the case you've described is powercut safe, but there can be other unsafe cases.
Let's stay on the safe side and be paranoid, it does not hurt.
If fastmap has proven stable we can start with tricky optimizations.

Thanks,
//richard
