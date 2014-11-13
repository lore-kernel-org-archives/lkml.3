Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaKMJQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:16:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbaKMJP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:15:29 -0500
Message-ID: <546476AE.9080207@suse.com>
Date: Thu, 13 Nov 2014 10:15:26 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 6/8] xen: Hide get_phys_to_machine() to be able to
 tune common path
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-7-git-send-email-jgross@suse.com> <20141112221813.GE7549@laptop.dumpdata.com>
In-Reply-To: <20141112221813.GE7549@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 11:18 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 11, 2014 at 06:43:44AM +0100, Juergen Gross wrote:
>> Today get_phys_to_machine() is always called when the mfn for a pfn
>> is to be obtained. Add a wrapper __pfn_to_mfn() as inline function
>> to be able to avoid calling get_phys_to_machine() when possible as
>
> s/when/where/

No. It's not a matter of the caller, but of the p2m list entry.

>> soon as the switch to a linear mapped p2m list has been done.
>
> But your inline function still calls get_phys_to_machine?

Sure. The switch is done in the next patch. David asked me to split
the patch doing the preparation by adding __pfn_tom_mfn() in an own
patch.

>
>
>>
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   arch/x86/include/asm/xen/page.h | 27 +++++++++++++++++++++------
>>   arch/x86/xen/mmu.c              |  2 +-
>>   arch/x86/xen/p2m.c              |  6 +++---
>>   3 files changed, 25 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
>> index 28fa795..07d8a7b 100644
>> --- a/arch/x86/include/asm/xen/page.h
>> +++ b/arch/x86/include/asm/xen/page.h
>> @@ -59,6 +59,22 @@ extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
>>   				     struct page **pages, unsigned int count);
>>   extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
>>
>> +/*
>> + * When to use pfn_to_mfn(), __pfn_to_mfn() or get_phys_to_machine():
>> + * - pfn_to_mfn() returns either INVALID_P2M_ENTRY or the mfn. In case of an
>> + *   identity entry the identity indicator will be cleared.
>
> Why don't you say : In case of identity PFN the same PFN is returned.
>
> But you did miss that also the FOREIGN_FRAME_BIT is cleared.

I'll reword the comment.

>
>> + * - __pfn_to_mfn() returns the found entry of the p2m table. A possibly set
>
> s/of the/in the/
>> + *   identity indicator will be still set. __pfn_to_mfn() is encapsulating
> .. be still set if the PFN is an identity one.
>> + *   get_phys_to_machine() and might skip that function if possible to speed
>> + *   up the common path.
>
> How is is skipping that function? The patch below does no such thing?

The next patch in this series does.

>
>> + * - get_phys_to_machine() is basically the same as __pfn_to_mfn(), but
>> + *   without any short cuts for the common fast path.
>
> Right. Perhpas we should call it 'slow_p2m' instead of the 'get_phys_to_machine'.

That's a matter of taste, I think. I can change it if nobody else
objects.


Juergen
