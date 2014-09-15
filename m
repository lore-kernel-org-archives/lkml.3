Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaIOK0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:26:25 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49928 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaIOK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:26:21 -0400
Message-ID: <5416BEC2.8040906@ozlabs.ru>
Date: Mon, 15 Sep 2014 20:26:10 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Alistair Popple <alistair@popple.id.au>,
        Anton Blanchard <anton@samba.org>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] powerpc/iommu/ddw: Fix endianness
References: <1410261723-21810-1-git-send-email-aik@ozlabs.ru>	 <5416A64E.1060005@ozlabs.ru> <1410772688.3931.0.camel@concordia>
In-Reply-To: <1410772688.3931.0.camel@concordia>
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 07:18 PM, Michael Ellerman wrote:
> On Mon, 2014-09-15 at 18:41 +1000, Alexey Kardashevskiy wrote:
>> On 09/09/2014 09:22 PM, Alexey Kardashevskiy wrote:
>>> rtas_call() accepts and returns values in CPU endianness.
> 
> Sounds right.
> 
>>> of_read_number() accepts big-endian values but create.addr_hi/lo returned
>>> by rtas_call() are in CPU endiannes.
> 
> Also sounds right.
> 
>>> The dynamic_dma_window_prop struct defines all members as BE so let's
>>> make it true.
> 
> It does. But why does it do that? It seems to be allocated and setup in
> enable_ddw() and then the only place I see it used is in
> tce_setrange_multi_pSeriesLP()/tce_clearrange_multi_pSeriesLP(), which both
> unpack it again. What am I missing?

I do not know why they are BE. I just know that create_ddw() returns
ddw_create_response struct which members are declared as BE but they are
not as rtas_call() already made them CPU-endian.

May be rtas_call() must not be used for structs. Or these structs must be
fixed to be CPU endian. Cannot choose what/how to fix here. Sure I still
can miss something here and it is all correct and I have to fix QEMU.


>>> struct dynamic_dma_window_prop {
>>>         __be32  liobn;          /* tce table number */
>>>         __be64  dma_base;       /* address hi,lo */
>>>         __be32  tce_shift;      /* ilog2(tce_page_size) */
>>>         __be32  window_shift;   /* ilog2(tce_window_size) */
>>> };
> 
> We do read them from the device tree in find_existing_ddw_windows(), but if
> that's the only place then the conversion to cpu endian should happen there.


enable_ddw() kmalloc's ddwprop which is of this dynamic_dma_window_prop type.

Then enable_ddw() initializes properties of that ddwprop thing but does it
incorrectly.

Then it calls walk_system_ram_range() which eventually calls
tce_setrange_multi_pSeriesLP() to map every single page of guest's ram, the
dynamic_dma_window_prop struct pointer is a void* argument of that callback.



find_existing_ddw_windows() handles something called
"linux,direct64-ddr-window-info" which is not a part of DDW at all and it
is not from PAPR and this patch is not about it.



>>> diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
>>> index 7c1d77c..700020a 100644
>>> --- a/arch/powerpc/platforms/pseries/iommu.c
>>> +++ b/arch/powerpc/platforms/pseries/iommu.c
>>> @@ -750,7 +750,7 @@ static void remove_ddw(struct device_node *np, bool remove_prop)
>>>  		pr_debug("%s successfully cleared tces in window.\n",
>>>  			 np->full_name);
>>>  
>>> -	ret = rtas_call(ddw_avail[2], 1, 1, NULL, liobn);
>>> +	ret = rtas_call(be32_to_cpu(ddw_avail[2]), 1, 1, NULL, liobn);
> 
> The conversion should happen once where ever ddw_avail comes out of the device
> tree, rather than everywhere it's used.

ddw_avail is a pointer to device tree property value:
ddw_avail = of_get_property(np, "ibm,ddw-applicable", &len);

This contains 3 tokens, only 2 of them are actually used by the DDW code in
its current state and each of them is used just once in the guest's
lifetime. Older guest kernels would use the "reset" extension token but
again - only once. I fail to see the point in caching CPU-endian values of
these tokens.



> 
> cheers
> 
> 
> 


-- 
Alexey
