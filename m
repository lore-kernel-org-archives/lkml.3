Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaKKMDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:03:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaKKMDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:03:35 -0500
Message-ID: <5461FB14.6090908@suse.com>
Date: Tue, 11 Nov 2014 13:03:32 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Cooper <andrew.cooper3@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH V3 2/8] xen: Delay remapping memory of pv-domain
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-3-git-send-email-jgross@suse.com> <5461F6C7.9070500@citrix.com>
In-Reply-To: <5461F6C7.9070500@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 12:45 PM, Andrew Cooper wrote:
> On 11/11/14 05:43, Juergen Gross wrote:
>> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
>> index fa75842..f67f8cf 100644
>> --- a/arch/x86/xen/p2m.c
>> +++ b/arch/x86/xen/p2m.c
>> @@ -268,6 +271,22 @@ static void p2m_init(unsigned long *p2m)
>>   		p2m[i] = INVALID_P2M_ENTRY;
>>   }
>>
>> +static void * __ref alloc_p2m_page(void)
>> +{
>> +	if (unlikely(use_brk))
>> +		return extend_brk(PAGE_SIZE, PAGE_SIZE);
>> +
>> +	if (unlikely(!slab_is_available()))
>> +		return alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
>> +
>> +	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
>> +}
>> +
>> +static void free_p2m_page(void *p)
>> +{
>> +	free_page((unsigned long)p);
>> +}
>> +
>
> What guarantees are there that free_p2m_page() is only called on p2m
> pages allocated using __get_free_page() ?  I can see from this diff that
> this is the case, but that doesn't help someone coming along in the future.
>
> At the very least, a comment is warranted about the apparent mismatch
> between {alloc,free}_p2m_page().

Okay, I'll add a comment.

>
>> @@ -420,6 +439,7 @@ unsigned long __init xen_revector_p2m_tree(void)
>>   	unsigned long *mfn_list = NULL;
>>   	unsigned long size;
>>
>> +	use_brk = 0;
>>   	va_start = xen_start_info->mfn_list;
>>   	/*We copy in increments of P2M_PER_PAGE * sizeof(unsigned long),
>>   	 * so make sure it is rounded up to that */
>> @@ -484,6 +504,7 @@ unsigned long __init xen_revector_p2m_tree(void)
>>   #else
>>   unsigned long __init xen_revector_p2m_tree(void)
>>   {
>> +	use_brk = 0;
>>   	return 0;
>>   }
>>   #endif
>
> This appears to be a completely orphaned function.
>
> It has a split definition based on CONFIG_X86_64, but the sole caller is
> xen_pagetable_p2m_copy() which is X86_64 only.
>
> How does use_brk get cleared for 32bit PV guests?

Good catch. use_brk is removed in a later patch and I have to admit I
didn't test each patch with 32 bit guests, just some of them (including
the final one, of course).

I'll change (and test) the patch accordingly.


Juergen

