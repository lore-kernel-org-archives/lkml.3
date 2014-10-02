Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaJBNdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:33:04 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaJBNdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:33:02 -0400
Message-ID: <542D540B.5010808@nod.at>
Date: Thu, 02 Oct 2014 15:32:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
References: <1412029248-22454-1-git-send-email-richard@nod.at> <1412029248-22454-4-git-send-email-richard@nod.at> <542D5314.3050701@codeaurora.org>
In-Reply-To: <542D5314.3050701@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.10.2014 15:28, schrieb Tanya Brokhman:
> Hi Richard
> 
> On 9/30/2014 1:20 AM, Richard Weinberger wrote:
>> Fastmap can miss a PEB if it is in the protection queue
>> and not jet in the used tree.
>> Treat every protected PEB as used.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>   drivers/mtd/ubi/fastmap.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
>> index 2b0d8d6..2853a69 100644
>> --- a/drivers/mtd/ubi/fastmap.c
>> +++ b/drivers/mtd/ubi/fastmap.c
>> @@ -1195,6 +1195,19 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
>>           fm_pos += sizeof(*fec);
>>           ubi_assert(fm_pos <= ubi->fm_size);
>>       }
>> +
>> +    for (i = 0; i < UBI_PROT_QUEUE_LEN; i++) {
>> +        list_for_each_entry(wl_e, &ubi->pq[i], u.list) {
> 
> why not list_for_each_entry_safe?

Because we don't delete elements from this list while iterating over it.

>> +            fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
>> +
>> +            fec->pnum = cpu_to_be32(wl_e->pnum);
>> +            fec->ec = cpu_to_be32(wl_e->ec);
>> +
>> +            used_peb_count++;
>> +            fm_pos += sizeof(*fec);
>> +            ubi_assert(fm_pos <= ubi->fm_size);
> 
> Is fm_size ok with this addition or does it needs updating as well?

It is okay. The fastmap size calculation reserves enough space for all possible
PEBs.

Thanks,
//richard
