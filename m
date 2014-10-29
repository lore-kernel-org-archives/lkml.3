Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaJ2Fnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:43:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaJ2Fny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:43:54 -0400
Message-ID: <54507E98.3030809@suse.com>
Date: Wed, 29 Oct 2014 06:43:52 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 1/2] Xen: Delay remapping memory of pv-domain
References: <1414421551-31555-1-git-send-email-jgross@suse.com> <1414421551-31555-2-git-send-email-jgross@suse.com> <544FD3A2.1050903@citrix.com> <54507B6A.2060706@suse.com>
In-Reply-To: <54507B6A.2060706@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 06:30 AM, Juergen Gross wrote:
> On 10/28/2014 06:34 PM, David Vrabel wrote:
>> Can these patches be split up?  They're hard to review as-is.  e.g., the
>> changes to page allocation look they could be split out.
>>
>> On 27/10/14 14:52, Juergen Gross wrote:
>>> Early in the boot process the memory layout of a pv-domain is changed
>>> to match the E820 map (either the host one for Dom0 or the Xen one)
>>> regarding placement of RAM and PCI holes. This requires removing memory
>>> pages initially located at positions not suitable for RAM and adding
>>> them later at higher addresses where no restrictions apply.
>>
>> How does this impact Matt Rushton's recent change to ensure the
>> relocated frames are contiguous?
>
> It is simplifying it. :-)
>
> The relocated frames are in the same sequence as before, just at
> another location. As the remapping is done later, I don't have to be
> careful not to cross a p2m leaf page boundary (allocating a new leaf
> page is no problem now).
>
>>
>> The change was "xen/setup: Remap Xen Identity Mapped RAM" (4fbb67e3c87).
>>
>>> +    /* Update kernel mapping */
>>> +    if (HYPERVISOR_update_va_mapping((unsigned long)__va(pfn <<
>>> PAGE_SHIFT),
>>> +                     mfn_pte(mfn, PAGE_KERNEL), 0)) {
>>> +        WARN(1, "Failed to update kernel mapping for mfn=%ld
>>> pfn=%ld\n",
>>> +              mfn, pfn);
>>> +        return 0;
>>
>> I think you need to check if this is a PFN for a high page before
>> updating the mapping.
>
> Really? I'm not aware of having removed such a check. If it is really
> necessary it must have been missing before...

Wait, now I see my fault: by doing the remapping later I've skipped the
highmem check during adding the memory to the system. Okay, I'll update
the patch.


Juergen

