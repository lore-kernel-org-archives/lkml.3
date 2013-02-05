Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3BER2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:28:25 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55389 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3BER2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:28:23 -0500
Message-ID: <51114134.4070503@gmail.com>
Date: Tue, 05 Feb 2013 11:28:20 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>, js1304@gmail.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/3] ARM: mm: use static_vm for managing static mapped
 areas
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com> <1360024314-1895-4-git-send-email-iamjoonsoo.kim@lge.com> <alpine.LFD.2.02.1302042308220.6300@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1302042308220.6300@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 10:44 PM, Nicolas Pitre wrote:
> On Tue, 5 Feb 2013, Joonsoo Kim wrote:
> 
>> A static mapped area is ARM-specific, so it is better not to use
>> generic vmalloc data structure, that is, vmlist and vmlist_lock
>> for managing static mapped area. And it causes some needless overhead and
>> reducing this overhead is better idea.
>>
>> Now, we have newly introduced static_vm infrastructure.
>> With it, we don't need to iterate all mapped areas. Instead, we just
>> iterate static mapped areas. It helps to reduce an overhead of finding
>> matched area. And architecture dependency on vmalloc layer is removed,
>> so it will help to maintainability for vmalloc layer.
>>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

[snip]

>> @@ -859,17 +864,12 @@ static void __init pci_reserve_io(void)
>>  {
>>  	struct vm_struct *vm;
>>  	unsigned long addr;
>> +	struct static_vm *svm;
>>  
>> -	/* we're still single threaded hence no lock needed here */
>> -	for (vm = vmlist; vm; vm = vm->next) {
>> -		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
>> -			continue;
>> -		addr = (unsigned long)vm->addr;
>> -		addr &= ~(SZ_2M - 1);
>> -		if (addr == PCI_IO_VIRT_BASE)
>> -			return;
>> +	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
>> +	if (svm)
>> +		return;
>>
>> -	}
>>  
>>  	vm_reserve_area_early(PCI_IO_VIRT_BASE, SZ_2M, pci_reserve_io);
>>  }
> 
> The replacement code is not equivalent.  I can't recall why the original 
> is as it is, but it doesn't look right to me.  The 2MB round down 
> certainly looks suspicious.

The PCI mapping is at a fixed, aligned 2MB mapping. If we find any
virtual address within that region already mapped, it is an error. We
probably should have had a WARN here.

> 
> The replacement code should be better.  However I'd like you to get an 
> ACK from Rob Herring as well for this patch.

It doesn't appear to me the above case is handled. The virt addr is
checked whether it is within an existing mapping, but not whether the
new mapping would overlap an existing mapping. It would be good to check
for this generically rather than specifically for the PCI i/o mapping.

Rob

