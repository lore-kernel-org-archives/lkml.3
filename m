Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3H0KKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:10:39 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:52197 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3H0KKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:10:37 -0400
X-IronPort-AV: E=Sophos;i="4.89,967,1367971200"; 
   d="scan'208";a="8128895"
Message-ID: <521C7B1B.2000506@citrix.com>
Date: Tue, 27 Aug 2013 12:10:35 +0200
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v1] p2m: use GNTTABOP_unmap_and_duplicate if available
References: <1375357597-6186-1-git-send-email-roger.pau@citrix.com> <alpine.DEB.2.02.1308041552360.4893@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1308041552360.4893@kaball.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/13 16:56, Stefano Stabellini wrote:
> On Thu, 1 Aug 2013, Roger Pau Monne wrote:
>> The new GNTTABOP_unmap_and_duplicate operation doesn't zero the
>> mapping passed in new_addr, allowing us to perform batch unmaps in p2m
>> code without requiring the use of a multicall.
>>
>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: David Vrabel <david.vrabel@citrix.com>
> 
> It looks pretty good overall.
> 
> 
>> Changes since RFC:
>>  * Move shared code between _single and _batch to helper
>>    functions.
>> ---
>> I don't currently have a NFS server (the one I had is currently not
>> working due to SD card corruption) and I cannot set up one right now,
>> so I've only tested this with a raw image stored in a local disk.
>> ---
>>  arch/x86/include/asm/xen/page.h     |    4 +-
>>  arch/x86/xen/p2m.c                  |  154 +++++++++++++++++++++++++++++++----
>>  drivers/xen/grant-table.c           |   24 ++----
>>  include/xen/interface/grant_table.h |   22 +++++
>>  4 files changed, 169 insertions(+), 35 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
>> index 6aef9fb..ea1dce6 100644
>> --- a/arch/x86/include/asm/xen/page.h
>> +++ b/arch/x86/include/asm/xen/page.h
>> @@ -51,8 +51,8 @@ extern unsigned long set_phys_range_identity(unsigned long pfn_s,
>>  
>>  extern int m2p_add_override(unsigned long mfn, struct page *page,
>>  			    struct gnttab_map_grant_ref *kmap_op);
>> -extern int m2p_remove_override(struct page *page,
>> -				struct gnttab_map_grant_ref *kmap_op);
>> +extern int m2p_remove_override(struct page **pages,
>> +				struct gnttab_map_grant_ref *kmap_ops, int count);
>>  extern struct page *m2p_find_override(unsigned long mfn);
>>  extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
>>  
>> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
>> index 0d4ec35..e92636c 100644
>> --- a/arch/x86/xen/p2m.c
>> +++ b/arch/x86/xen/p2m.c
>> @@ -154,6 +154,8 @@
>>  #include <linux/hash.h>
>>  #include <linux/sched.h>
>>  #include <linux/seq_file.h>
>> +#include <linux/slab.h>
>> +#include <linux/hardirq.h>
>>  
>>  #include <asm/cache.h>
>>  #include <asm/setup.h>
>> @@ -853,6 +855,7 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>>  
>>  static RESERVE_BRK_ARRAY(struct list_head, m2p_overrides, M2P_OVERRIDE_HASH);
>>  static DEFINE_SPINLOCK(m2p_override_lock);
>> +extern bool gnttab_supports_duplicate;
> 
> If you only use gnttab_supports_duplicate in the m2p, you might as well
> make the variable static and initialize it from m2p_override_init.

m2p_override_init is called way too early in the boot process, if I try
to perform the hypercall there I get a general protection fault.

>>  static void __init m2p_override_init(void)
>>  {
>> @@ -933,8 +936,8 @@ int m2p_add_override(unsigned long mfn, struct page *page,
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(m2p_add_override);
>> -int m2p_remove_override(struct page *page,
>> -		struct gnttab_map_grant_ref *kmap_op)
>> +
>> +static inline int remove_page_override(struct page *page)
>>  {
>>  	unsigned long flags;
>>  	unsigned long mfn;
>> @@ -965,6 +968,49 @@ int m2p_remove_override(struct page *page,
>>  	ClearPagePrivate(page);
>>  
>>  	set_phys_to_machine(pfn, page->index);
>> +
>> +	return 0;
>> +}
>> +
>> +static inline int check_duplicate_mfn(struct page *page, unsigned long mfn)
>> +{
>> +	unsigned long pfn;
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * p2m(m2p(mfn)) == FOREIGN_FRAME(mfn): the mfn is already present
>> +	 * somewhere in this domain, even before being added to the
>> +	 * m2p_override (see comment above in m2p_add_override).
>> +	 * If there are no other entries in the m2p_override corresponding
>> +	 * to this mfn, then remove the FOREIGN_FRAME_BIT from the p2m for
>> +	 * the original pfn (the one shared by the frontend): the backend
>> +	 * cannot do any IO on this page anymore because it has been
>> +	 * unshared. Removing the FOREIGN_FRAME_BIT from the p2m entry of
>> +	 * the original pfn causes mfn_to_pfn(mfn) to return the frontend
>> +	 * pfn again.
>> +	 */
>> +	mfn &= ~FOREIGN_FRAME_BIT;
>> +	ret = __get_user(pfn, &machine_to_phys_mapping[mfn]);
>> +	if (ret == 0 && get_phys_to_machine(pfn) == FOREIGN_FRAME(mfn) &&
>> +			m2p_find_override(mfn) == NULL)
>> +		set_phys_to_machine(pfn, mfn);
>> +
>> +	return ret;
>> +}
> 
> There is no need to keep check_duplicate_mfn separate from
> remove_page_override, you can just "append" this code at the end of
> remove_page_override.

Done, thanks for the review.

