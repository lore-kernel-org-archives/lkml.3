Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaJ1MHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:07:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaJ1MHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:07:49 -0400
Message-ID: <544F8713.9040803@suse.com>
Date: Tue, 28 Oct 2014 13:07:47 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: boris.ostrovsky@oracle.com, xen-devel@lists.xensource.com,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 0/2] xen: Switch to virtual mapped linear
 p2m list
References: <1414421551-31555-1-git-send-email-jgross@suse.com>	<544E61DD.8050305@citrix.com>	<544F22E4.9040706@suse.com> <1414489898.23883.25.camel@citrix.com> <544F83C1.3010402@citrix.com>
In-Reply-To: <544F83C1.3010402@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 12:53 PM, Andrew Cooper wrote:
> On 28/10/14 09:51, Ian Campbell wrote:
>> On Tue, 2014-10-28 at 06:00 +0100, Juergen Gross wrote:
>>> On 10/27/2014 04:16 PM, David Vrabel wrote:
>>>> On 27/10/14 14:52, Juergen Gross wrote:
>>>>> Paravirtualized kernels running on Xen use a three level tree for
>>>>> translation of guest specific physical addresses to machine global
>>>>> addresses. This p2m tree is used for construction of page table
>>>>> entries, so the p2m tree walk is performance critical.
>>>>>
>>>>> By using a linear virtual mapped p2m list accesses to p2m elements
>>>>> can be sped up while even simplifying code. To achieve this goal
>>>>> some p2m related initializations have to be performed later in the
>>>>> boot process, as the final p2m list can be set up only after basic
>>>>> memory management functions are available.
>>>> What impact does this have on 32-bit guests which don't have huge amount
>>>> of virtual address space?
>>>>
>>>> I think a 32-bit guest could have up to 64 GiB of PFNs, which would
>>>> require a 128 MiB p2m array, which is too large?
>>> It is 64 MB (one entry on 32 bit is 32 bits :-) ).
>>>
>>> With a m2p array of only 16 MB size I doubt a 32 bit guest can be larger
>>> than 16 GB, or am I wrong here?
>> I think they can be bigger, the compat r/o m2p is 168MB, since Xen
>> doesn't need to be in the hole as well (like it was with a real 32-bit
>> Xen). There is also some scope for dynamic sizing of the hole (queried
>> via XENMEM_machphys_mapping), I'm not sure if pvops makes use of that
>> though.
>>
>> In practice a 32-bit kernel starts to get pretty unhappy somewhere
>> between 32 and 64GB because it runs out of low memory for various
>> structures which are sized according to the amount of RAM. Or it did,
>> it's been years since I've tried, maybe things are more able to use
>> highmem now. In any case if you have such large amounts of RAM using a
>> 64-bit kernel would be advisable.
>
> It is XenServers experience that something (I presume a
> power-of-two-aligned mapping) cuts off at 128MB of the compat m2p,
> allowing for 32bit guest pages to exist in the first 128GB of host RAM.
>
> Technically speaking, there is nothing preventing a 32bit PV guest being
> that large.  The traditional issues with 32bit PAE kernels do not apply
> as Xen is running in long mode, but kernel lowmem will be the limiting
> factor.  Switching to a 2/2 split will help, but it is a loosing battle.
>
> It should be noted that OEL formally supports 64GB 32bit PV VMs, and as
> a result, the XenServer VM lifecycle tests do test it, and it works.

Okay, back to the original question: is the (up to) 64 MB virtual
mapping of the p2m list on 32-bit pv domains a problem or not?

If yes, the virtual mapped linear p2m list could still be used on
64 bit domains, paving the way for support of more than 512 GB of
domain memory. OTOH having to keep the p2m tree coding alive isn't
my favorite solution...


Juergen

