Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaBQLtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 06:49:40 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7034 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaBQLti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:49:38 -0500
X-IronPort-AV: E=Sophos;i="4.95,860,1384300800"; 
   d="scan'208";a="101394258"
Message-ID: <5301F74E.3070107@citrix.com>
Date: Mon, 17 Feb 2014 11:49:34 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v9] xen/grant-table: Avoid m2p_override during mapping
References: <1392238453-26147-1-git-send-email-zoltan.kiss@citrix.com> <alpine.DEB.2.02.1402161828380.4307@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1402161828380.4307@kaball.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/02/14 18:36, Stefano Stabellini wrote:
> On Wed, 12 Feb 2014, Zoltan Kiss wrote:
>> diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
>> index e0965ab..4eaeb3f 100644
>> --- a/arch/arm/include/asm/xen/page.h
>> +++ b/arch/arm/include/asm/xen/page.h
>> @@ -97,16 +97,15 @@ static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
>>   	return NULL;
>>   }
>>
>> -static inline int m2p_add_override(unsigned long mfn, struct page *page,
>> -		struct gnttab_map_grant_ref *kmap_op)
>> -{
>> -	return 0;
>> -}
>> -
>> -static inline int m2p_remove_override(struct page *page, bool clear_pte)
>> -{
>> -	return 0;
>> -}
>> +extern int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
>> +				   struct gnttab_map_grant_ref *kmap_ops,
>> +				   struct page **pages, unsigned int count,
>> +				   bool m2p_override);
>> +
>> +extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
>> +				     struct gnttab_map_grant_ref *kmap_ops,
>> +				     struct page **pages, unsigned int count,
>> +				     bool m2p_override);
>
> Much much better.
> The only comment I have is about this m2p_override boolean parameter.
> m2p_override is now meaningless in this context, what we really want to
> let the arch specific implementation know is whether the mapping is a
> kernel only mapping or a userspace mapping.
> Testing for kmap_ops != NULL might even be enough, but it would not
> improve the interface.
gntdev is the only user of this, the kmap_ops parameter there is:
use_ptemod ? map->kmap_ops + offset : NULL
where:
use_ptemod = !xen_feature(XENFEAT_auto_translated_physmap);
So I think we can't rely on kmap_ops to decide whether we should 
m2p_override or not.

> Is it possible to realize if the mapping is a userspace mapping by
> checking for GNTMAP_application_map in map_ops?
> Otherwise I would keep the boolean and rename it to user_mapping.
Sounds better, but as far as I see gntdev set that flag in 
find_grant_ptes, which is called only

if (use_ptemod) {
	err = apply_to_page_range(vma->vm_mm, vma->vm_start,
				  vma->vm_end - vma->vm_start,
				  find_grant_ptes, map);

So if xen_feature(XENFEAT_auto_translated_physmap), we don't have 
kmap_ops, and GNTMAP_application_map is not set as well, but I guess we 
still need m2p_override. Or not? I'm a bit confused, maybe because of 
Monday ...

Zoli
