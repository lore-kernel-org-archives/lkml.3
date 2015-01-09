Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbbAIMvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:51:39 -0500
Received: from smtp.citrix.com ([66.165.176.89]:34609 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119AbbAIMvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:51:38 -0500
X-IronPort-AV: E=Sophos;i="5.07,730,1413244800"; 
   d="scan'208";a="213312146"
Message-ID: <54AFCED7.7040407@citrix.com>
Date: Fri, 9 Jan 2015 12:51:35 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, Juergen Gross <JGross@suse.com>
CC: xen-devel <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen: use correct type for physical addresses
References: <1420736490-15351-1-git-send-email-jgross@suse.com>	<1420736490-15351-4-git-send-email-jgross@suse.com> <54AFB410020000780005306E@mail.emea.novell.com>
In-Reply-To: <54AFB410020000780005306E@mail.emea.novell.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 09:57, Jan Beulich wrote:
>>>> On 08.01.15 at 18:01, <JGross@suse.com> wrote:
>> --- a/arch/x86/xen/setup.c
>> +++ b/arch/x86/xen/setup.c
>> @@ -140,7 +140,7 @@ static void __init xen_del_extra_mem(u64 start, u64 size)
>>  unsigned long __ref xen_chk_extra_mem(unsigned long pfn)
>>  {
>>  	int i;
>> -	unsigned long addr = PFN_PHYS(pfn);
>> +	u64 addr = PFN_PHYS(pfn);
> 
> Isn't phys_addr_t the type to use here?

Agreed.

>> @@ -284,7 +286,7 @@ static void __init xen_update_mem_tables(unsigned long pfn, unsigned long mfn)
>>  	}
>>  
>>  	/* Update kernel mapping, but not for highmem. */
>> -	if ((pfn << PAGE_SHIFT) >= __pa(high_memory))
>> +	if (PFN_PHYS(pfn) >= (u64)(__pa(high_memory)))
> 
> I don't think you really need the cast on the right side - __pa()
> should be returning a value of suitable type (and unsigned long
> would be sufficient for anything up to and including high_memory).

I'd prefer:

    if (pfn >= PFN_DOWN(__pa(high_memory))

David
