Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbaLKMP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:15:29 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:39847 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599AbaLKMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:15:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,557,1413244800"; 
   d="scan'208";a="203313732"
Message-ID: <54898AD9.2030009@citrix.com>
Date: Thu, 11 Dec 2014 12:15:21 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: switch to post-init routines in xen
 mmu.c earlier
References: <1418226963-24873-1-git-send-email-jgross@suse.com>	<54888BC6.7030601@citrix.com> <54892C58.5070707@suse.com>
In-Reply-To: <54892C58.5070707@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/14 05:32, Juergen Gross wrote:
> On 12/10/2014 07:07 PM, David Vrabel wrote:
>> On 10/12/14 15:56, Juergen Gross wrote:
>>> With the virtual mapped linear p2m list the post-init mmu operations
>>> must be used for setting up the p2m mappings, as in case of
>>> CONFIG_FLATMEM the init routines may trigger BUGs.
>>>
>>> Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>> ---
>>>   arch/x86/xen/mmu.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>>> index 6ab6150..a1a429a 100644
>>> --- a/arch/x86/xen/mmu.c
>>> +++ b/arch/x86/xen/mmu.c
>>> @@ -1225,6 +1225,7 @@ static void __init xen_pagetable_p2m_setup(void)
>>>   static void __init xen_pagetable_init(void)
>>>   {
>>>       paging_init();
>>> +    xen_post_allocator_init();
>>>
>>>       xen_pagetable_p2m_setup();
>>>
>>
>> This feels very chicken-and-egg to me:  To setup the P2M we need to use
>> the MMU ops that use the P2M...
>>
>> Please explain very clearly why this is all safe.
> 
> Okay. paging_init() sets up all infrastructure needed to switch to the
> post-init mmu ops done by xen_post_allocator_init(). With the virtual
> mapped linear p2m list we need some mmu ops during setup of this list,
> so we have to switch to the correct mmu ops as soon as possible.
> 
> The p2m list is usable from the beginning, just expansion requires to
> have established the new linear mapping. So the call of
> xen_remap_memory() had to be introduced, but this is not due to the
> mmu ops requiring this.
> 
> Summing it up: calling xen_post_allocator_init() not directly after
> paging_init() was conceptually wrong in the beginning, it just didn't
> matter up to now as no functions used between the two calls needed
> some critical mmu ops (e.g. alloc_pte). This has changed now, so I
> corrected it.

I've added this to the commit message and applied to
devel/for-linus-3.19.  If the tests pass I will consider sending a
further pull request for 3.19 including the linear p2m changes early
next week.

Thanks.

David
