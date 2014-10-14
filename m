Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaJNJtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:49:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbaJNJtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:49:17 -0400
Message-ID: <543CF19B.3040305@suse.com>
Date: Tue, 14 Oct 2014 11:49:15 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com
Subject: Re: [Xen-devel] [PATCH] xen: avoid writing to freed memory after
 race in p2m handling
References: <1413277218-11437-1-git-send-email-jgross@suse.com> <543CED29.4050905@citrix.com>
In-Reply-To: <543CED29.4050905@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 11:30 AM, David Vrabel wrote:
> On 14/10/14 10:00, Juergen Gross wrote:
>> In case a race was detected during allocation of a new p2m tree
>> element in alloc_p2m() the new allocated mid_mfn page is freed without
>> updating the pointer to the found value in the tree. This will result
>> in overwriting the just freed page with the mfn of the p2m leaf.
>
> Can this race actually happen?  i.e., does this need tagging for stable?

Good question. I just stumbled over it while writing the linear p2m-list
patch.

Is it possible for gnttab_map_refs() to call set_foreign_p2m_mapping()
specifying a pfn which has been invalid before? In this case the race
could happen in dom0.

I think ballooning alone can't trigger this race, as it is calling
set_phys_to_machine() under lock only.

Juergen

>
> David
>
>> --- a/arch/x86/xen/p2m.c
>> +++ b/arch/x86/xen/p2m.c
>> @@ -566,6 +566,7 @@ static bool alloc_p2m(unsigned long pfn)
>>   		/* Separately check the mid mfn level */
>>   		unsigned long missing_mfn;
>>   		unsigned long mid_mfn_mfn;
>> +		unsigned long old_mfn;
>>
>>   		mid_mfn = alloc_p2m_page();
>>   		if (!mid_mfn)
>> @@ -575,10 +576,13 @@ static bool alloc_p2m(unsigned long pfn)
>>
>>   		missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
>>   		mid_mfn_mfn = virt_to_mfn(mid_mfn);
>> -		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
>> +		old_mfn = cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn);
>> +		if (old_mfn != missing_mfn) {
>>   			free_p2m_page(mid_mfn);
>> -		else
>> +			mid_mfn = mfn_to_virt(old_mfn);
>> +		} else {
>>   			p2m_top_mfn_p[topidx] = mid_mfn;
>> +		}
>>   	}
>>
>>   	if (p2m_top[topidx][mididx] == p2m_identity ||
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

