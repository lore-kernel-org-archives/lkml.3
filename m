Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbaLKFcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:32:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaLKFcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:32:10 -0500
Message-ID: <54892C58.5070707@suse.com>
Date: Thu, 11 Dec 2014 06:32:08 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH] xen: switch to post-init routines in xen
 mmu.c earlier
References: <1418226963-24873-1-git-send-email-jgross@suse.com> <54888BC6.7030601@citrix.com>
In-Reply-To: <54888BC6.7030601@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 07:07 PM, David Vrabel wrote:
> On 10/12/14 15:56, Juergen Gross wrote:
>> With the virtual mapped linear p2m list the post-init mmu operations
>> must be used for setting up the p2m mappings, as in case of
>> CONFIG_FLATMEM the init routines may trigger BUGs.
>>
>> Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   arch/x86/xen/mmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> index 6ab6150..a1a429a 100644
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -1225,6 +1225,7 @@ static void __init xen_pagetable_p2m_setup(void)
>>   static void __init xen_pagetable_init(void)
>>   {
>>   	paging_init();
>> +	xen_post_allocator_init();
>>
>>   	xen_pagetable_p2m_setup();
>>
>
> This feels very chicken-and-egg to me:  To setup the P2M we need to use
> the MMU ops that use the P2M...
>
> Please explain very clearly why this is all safe.

Okay. paging_init() sets up all infrastructure needed to switch to the
post-init mmu ops done by xen_post_allocator_init(). With the virtual
mapped linear p2m list we need some mmu ops during setup of this list,
so we have to switch to the correct mmu ops as soon as possible.

The p2m list is usable from the beginning, just expansion requires to
have established the new linear mapping. So the call of
xen_remap_memory() had to be introduced, but this is not due to the
mmu ops requiring this.

Summing it up: calling xen_post_allocator_init() not directly after
paging_init() was conceptually wrong in the beginning, it just didn't
matter up to now as no functions used between the two calls needed
some critical mmu ops (e.g. alloc_pte). This has changed now, so I
corrected it.

Juergen

>
>> @@ -1236,7 +1237,6 @@ static void __init xen_pagetable_init(void)
>>   		xen_remap_memory();
>>
>>   	xen_setup_shared_info();
>> -	xen_post_allocator_init();
>>   }
>>   static void xen_write_cr2(unsigned long cr2)
>>   {
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

