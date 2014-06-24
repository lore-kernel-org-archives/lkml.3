Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaFXKmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:42:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbaFXKmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:42:00 -0400
Message-ID: <53A955F5.6050801@suse.de>
Date: Tue, 24 Jun 2014 12:41:57 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Subject: Re: [PATCH] vfio: Fix endianness handling for emulated BARs
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>	 <1403116512.3707.175.camel@ul30vt.home> <53A233E9.6030006@ozlabs.ru>	 <53A241F6.9010307@ozlabs.ru> <53A25D74.5000804@ozlabs.ru>	 <1403234514.3707.278.camel@ul30vt.home> <1403305961.4587.66.camel@pasglop> <53A94EBD.101@ozlabs.ru>
In-Reply-To: <53A94EBD.101@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24.06.14 12:11, Alexey Kardashevskiy wrote:
> On 06/21/2014 09:12 AM, Benjamin Herrenschmidt wrote:
>> On Thu, 2014-06-19 at 21:21 -0600, Alex Williamson wrote:
>>
>>> Working on big endian being an accident may be a matter of perspective
>>   :-)
>>
>>> The comment remains that this patch doesn't actually fix anything except
>>> the overhead on big endian systems doing redundant byte swapping and
>>> maybe the philosophy that vfio regions are little endian.
>> Yes, that works by accident because technically VFIO is a transport and
>> thus shouldn't perform any endian swapping of any sort, which remains
>> the responsibility of the end driver which is the only one to know
>> whether a given BAR location is a a register or some streaming data
>> and in the former case whether it's LE or BE (some PCI devices are BE
>> even ! :-)
>>
>> But yes, in the end, it works with the dual "cancelling" swaps and the
>> overhead of those swaps is probably drowned in the noise of the syscall
>> overhead.
>>
>>> I'm still not a fan of iowrite vs iowritebe, there must be something we
>>> can use that doesn't have an implicit swap.
>> Sadly there isn't ... In the old day we didn't even have the "be"
>> variant and readl/writel style accessors still don't have them either
>> for all archs.
>>
>> There is __raw_readl/writel but here the semantics are much more than
>> just "don't swap", they also don't have memory barriers (which means
>> they are essentially useless to most drivers unless those are platform
>> specific drivers which know exactly what they are doing, or in the rare
>> cases such as accessing a framebuffer which we know never have side
>> effects).
>>
>>>   Calling it iowrite*_native is also an abuse of the namespace.
>>
>>>   Next thing we know some common code
>>> will legitimately use that name.
>> I might make sense to those definitions into a common header. There have
>> been a handful of cases in the past that wanted that sort of "native
>> byte order" MMIOs iirc (though don't ask me for examples, I can't really
>> remember).
>>
>>>   If we do need to define an alias
>>> (which I'd like to avoid) it should be something like vfio_iowrite32.
>
> Ping?
>
> We need to make a decision whether to move those xxx_native() helpers
> somewhere (where?) or leave the patch as is (as we figured out that
> iowriteXX functions implement barriers and we cannot just use raw
> accessors) and fix commit log to explain everything.

Is there actually any difference in generated code with this patch 
applied and without? I would hope that iowrite..() is inlined and 
cancels out the cpu_to_le..() calls that are also inlined?


Alex

