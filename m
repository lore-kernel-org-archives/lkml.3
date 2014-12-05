Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaLEVC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:02:59 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaLEVC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:02:58 -0500
Message-ID: <54821D80.50703@nod.at>
Date: Fri, 05 Dec 2014 22:02:56 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] UBI: Split __wl_get_peb()
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-6-git-send-email-richard@nod.at> <5481EE65.1090705@codeaurora.org>
In-Reply-To: <5481EE65.1090705@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tanya,

Am 05.12.2014 um 18:41 schrieb Tanya Brokhman:
> On 11/24/2014 3:20 PM, Richard Weinberger wrote:
>> Make it two functions, wl_get_wle() and wl_get_peb().
>> wl_get_peb() works exactly like __wl_get_peb() but wl_get_wle()
>> does not call produce_free_peb().
>> While refilling the fastmap user pool we cannot release ubi->wl_lock
>> as produce_free_peb() does.
>> Hence the fastmap logic uses now wl_get_wle().
> 
> hmmm... confused... I don't see fastmap code changed

It will be used in ubi_refill_pools() later.
Patch 6/6 does this.
I'll fix the commit message.

>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>   drivers/mtd/ubi/wl.c | 61 ++++++++++++++++++++++++++++++++--------------------
>>   1 file changed, 38 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>> index 7730b97..f028b68 100644
>> --- a/drivers/mtd/ubi/wl.c
>> +++ b/drivers/mtd/ubi/wl.c
>> @@ -499,13 +499,46 @@ out:
>>   #endif
>>
>>   /**
>> - * __wl_get_peb - get a physical eraseblock.
>> + * wl_get_wle - get a mean wl entry to be used by wl_get_peb() or
>> + * refill_wl_user_pool().
>> + * @ubi: UBI device description object
>> + *
>> + * This function returns a a wear leveling entry in case of success and
> 
> If you upload a new version, you have a double "a" here: "returns a a wear leveling"

Thx!

>> + * NULL in case of failure.
>> + */
>> +static struct ubi_wl_entry *wl_get_wle(struct ubi_device *ubi)
>> +{
>> +    struct ubi_wl_entry *e;
>> +
>> +    e = find_mean_wl_entry(ubi, &ubi->free);
>> +    if (!e) {
>> +        ubi_err(ubi, "no free eraseblocks");
>> +        return NULL;
>> +    }
>> +
>> +    self_check_in_wl_tree(ubi, e, &ubi->free);
>> +
>> +    /*
>> +     * Move the physical eraseblock to the protection queue where it will
>> +     * be protected from being moved for some time.
>> +     */
> 
> I don't think this comment is valid anymore....

Correct, will update!

Thanks,
//richard
