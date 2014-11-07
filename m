Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaKGOn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:43:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbaKGOnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:43:55 -0500
Message-ID: <545CDAA8.4050803@suse.com>
Date: Fri, 07 Nov 2014 15:43:52 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH V2 5/5] Xen: switch to linear virtual mapped
 sparse p2m list
References: <1415252853-7106-1-git-send-email-jgross@suse.com> <1415252853-7106-6-git-send-email-jgross@suse.com> <545CCF15.4070402@citrix.com> <545CD306.90001@suse.com> <545CD9F2.80208@citrix.com>
In-Reply-To: <545CD9F2.80208@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 03:40 PM, David Vrabel wrote:
> On 07/11/14 14:11, Juergen Gross wrote:
>> On 11/07/2014 02:54 PM, David Vrabel wrote:
>>> On 06/11/14 05:47, Juergen Gross wrote:
>>> [...]
>>>> @@ -526,23 +411,83 @@ unsigned long get_phys_to_machine(unsigned long
>>>> pfn)
>>>>            return IDENTITY_FRAME(pfn);
>>>>        }
>>>>
>>>> -    topidx = p2m_top_index(pfn);
>>>> -    mididx = p2m_mid_index(pfn);
>>>> -    idx = p2m_index(pfn);
>>>> +    ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
>>>> +    BUG_ON(!ptep || level != PG_LEVEL_4K);
>>>>
>>>>        /*
>>>>         * The INVALID_P2M_ENTRY is filled in both p2m_*identity
>>>>         * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
>>>>         * would be wrong.
>>>>         */
>>>> -    if (p2m_top[topidx][mididx] == p2m_identity)
>>>> +    if (pte_pfn(*ptep) == PFN_DOWN(__pa(p2m_identity)))
>>>>            return IDENTITY_FRAME(pfn);
>>>>
>>>> -    return p2m_top[topidx][mididx][idx];
>>>> +    return xen_p2m_addr[pfn];
>>>
>>> You should test xen_p2m_addr[pfn] == INVALID_P2M_ENTRY before checking
>>> if it's an identity entry.  This should skip the more expensive
>>> lookup_address() in the common case.
>>
>> I do. The check is in __pfn_to_mfn(). get_phys_to_machine() is called in
>> this case only.
>
> So you do.  I missed that.
>
>>>>    bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>>>
>>> I think you should map p2m_missing and p2m_identity as read-only and do
>>> the new page allocation on a write fault.
>>>
>>> set_phys_to_machine() is used every grant map and unmap and in the
>>> common case (already allocated array page) it must be a fast and simple:
>>>
>>>       xen_p2m_addr[pfn] = mfn;
>>
>> Nice idea. I'll try it.
>
> You probably want to try this with a custom exception fixup (or abuse
> put_user()).

Yeah, that was my idea, too.

Juergen

