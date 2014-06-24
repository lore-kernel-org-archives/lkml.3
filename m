Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaFXAdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:33:05 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:56397 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaFXAdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:33:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53A8C6F6.2060906@jp.fujitsu.com>
Date: Tue, 24 Jun 2014 09:31:50 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tangchen@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
        <guz.fnst@cn.fujitsu.com>, <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] x86,mem-hotplug: modify PGD entry when removing memory
References: <53A132E2.9000605@jp.fujitsu.com>	 <53A133ED.2090005@jp.fujitsu.com> <1403289003.25108.3.camel@misato.fc.hp.com>
In-Reply-To: <1403289003.25108.3.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/21 3:30), Toshi Kani wrote:
> On Wed, 2014-06-18 at 15:38 +0900, Yasuaki Ishimatsu wrote:
>   :
>> @@ -186,7 +186,12 @@ void sync_global_pgds(unsigned long start, unsigned long end)
>>   		const pgd_t *pgd_ref = pgd_offset_k(address);
>>   		struct page *page;
>>
>> -		if (pgd_none(*pgd_ref))
>> +		/*
>> +		 * When it is called after memory hot remove, pgd_none()
>> +		 * returns true. In this case (removed == 1), we must clear
>> +		 * the PGD entries in the local PGD level page.
>> +		 */
>> +		if (pgd_none(*pgd_ref) && !removed)
>>   			continue;
>>
>>   		spin_lock(&pgd_lock);
>> @@ -199,12 +204,18 @@ void sync_global_pgds(unsigned long start, unsigned long end)
>>   			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
>>   			spin_lock(pgt_lock);
>>
>> -			if (pgd_none(*pgd))
>> -				set_pgd(pgd, *pgd_ref);
>> -			else

>> +			if (!pgd_none(*pgd_ref) && !pgd_none(*pgd))
>>   				BUG_ON(pgd_page_vaddr(*pgd)
>>   				       != pgd_page_vaddr(*pgd_ref));
>>
>> +			if (removed) {
>
> Shouldn't this condition be "else if"?

The first if sentence checks whether PGDs hit to BUG_ON. And the second
if sentence checks whether the function was called after hot-removing memory.
I think that the first if sentence and the second if sentence check different
things. So I think the condition should be "if" sentence.

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> -Toshi
>
>> +				if (pgd_none(*pgd_ref) && !pgd_none(*pgd))
>> +					pgd_clear(pgd);
>> +			} else {
>> +				if (pgd_none(*pgd))
>> +					set_pgd(pgd, *pgd_ref);
>> +			}
>> +
>>   			spin_unlock(pgt_lock);
>>   		}
>
>


