Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763361Ab3DDQpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:45:16 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:39119 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762912Ab3DDQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:45:14 -0400
MIME-Version: 1.0
In-Reply-To: <515D35B0.8020107@jp.fujitsu.com>
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
	<1365035906-3208-2-git-send-email-yinghai@kernel.org>
	<515D35B0.8020107@jp.fujitsu.com>
Date: Thu, 4 Apr 2013 09:45:14 -0700
X-Google-Sender-Auth: tLHbqZpOn5Uwvf1F9rrUWmX4LgI
Message-ID: <CAE9FiQUi3OL0gQO8Ks-mODVvAxDV_evNqNwUGuzoa-msJU6JLQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 1:11 AM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:
> (2013/04/04 9:38), Yinghai Lu wrote:
>
>> Index: linux-2.6/lib/swiotlb.c
>> ===================================================================
>> --- linux-2.6.orig/lib/swiotlb.c
>> +++ linux-2.6/lib/swiotlb.c
>> @@ -105,9 +105,9 @@ setup_io_tlb_npages(char *str)
>>       if (!strcmp(str, "force"))
>>               swiotlb_force = 1;
>>
>> -     return 1;
>> +     return 0;
>>   }
>> -__setup("swiotlb=", setup_io_tlb_npages);
>> +early_param("swiotlb", setup_io_tlb_npages);
>>   /* make io_tlb_overflow tunable too? */
>>
>>   unsigned long swiotlb_nr_tbl(void)
>> @@ -115,6 +115,18 @@ unsigned long swiotlb_nr_tbl(void)
>>       return io_tlb_nslabs;
>>   }
>>   EXPORT_SYMBOL_GPL(swiotlb_nr_tbl);
>> +
>> +/* default to 64MB */
>> +#define IO_TLB_DEFAULT_SIZE (64UL<<20)
>> +unsigned long swiotlb_size_or_default(void)
>> +{
>> +     unsigned long size;
>> +
>> +     size = io_tlb_nslabs << IO_TLB_SHIFT;
>> +
>> +     return size ? size : (IO_TLB_DEFAULT_SIZE);
>> +}
>> +
>>   /* Note that this doesn't work with highmem page */
>>   static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
>>                                     volatile void *address)
>> @@ -188,8 +200,7 @@ int __init swiotlb_init_with_tbl(char *t
>>   void  __init
>>   swiotlb_init(int verbose)
>>   {
>> -     /* default to 64MB */
>> -     size_t default_size = 64UL<<20;
>> +     size_t default_size = IO_TLB_DEFAULT_SIZE;
>>       unsigned char *vstart;
>>       unsigned long bytes;
>
> The variable default_size seems no longer necessary. IO_TLB_DEFAULT_SIZE
> should be used directly.

Yes, but that does not hurt.

>
>>
>> Index: linux-2.6/Documentation/kernel-parameters.txt
>> ===================================================================
>> --- linux-2.6.orig/Documentation/kernel-parameters.txt
>> +++ linux-2.6/Documentation/kernel-parameters.txt
>> @@ -596,9 +596,6 @@ bytes respectively. Such letter suffixes
>>                       is selected automatically. Check
>>                       Documentation/kdump/kdump.txt for further details.
>>
>> -     crashkernel_low=size[KMG]
>> -                     [KNL, x86] parts under 4G.
>> -
>>       crashkernel=range1:size1[,range2:size2,...][@offset]
>>                       [KNL] Same as above, but depends on the memory
>>                       in the running system. The syntax of range is
>> @@ -606,6 +603,18 @@ bytes respectively. Such letter suffixes
>>                       a memory unit (amount[KMG]). See also
>>                       Documentation/kdump/kdump.txt for an example.
>>
>> +     crashkernel_low=size[KMG]
>> +                     [KNL, x86_64] range under 4G. When crashkernel= is
>> +                     passed, kernel allocate physical memory region
>> +                     above 4G, that cause second kernel crash on system
>> +                     that need swiotlb later. Kernel would try to allocate
>> +                     some region below 4G automatically. This one let
>> +                     user to specify own low range under 4G for second
>> +                     kernel instead.
>
> In fact, swiotlb caused the 2nd kernel to fail to boot this time, but in
> general, other components that require low memory can cause the same
> situation. I think it better to avoid the description that only swiotlb
> can cause the 2nd kernel to fail to boot.
>
> So, how about this?
>
> ... that cause second kernel crash on system that require some amount of
> low memory, e.g. swiotlb that requires at least 72MB low memory at
> default. Kernel would ...

ok, will change that.

>
>> +                     0: to disable low allocation on systems that do not
>> +                     need swiotlb, that will save 72M low ram in first
>> +                     kernel.
>> +
>
> Similarly, I think it better not to say swiotlb thing here. Just:
>
>   0: to disable automatic low memory allocation.

ok,

it will be:

---
        crashkernel_low=size[KMG]
                        [KNL, x86_64] range under 4G. When crashkernel= is
                        passed, kernel allocate physical memory region
                        above 4G, that cause second kernel crash on system
                        that require some amount of low memory, e.g. swiotlb
                        requires at least 64M+32K low memory.  Kernel would
                        try to allocate 72M below 4G automatically.
                        This one let user to specify own low range under 4G
                        for second kernel instead.
                        0: to disable low allocation.
---

Thanks

Yinghai
