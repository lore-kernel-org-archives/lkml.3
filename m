Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3FJTQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:16:21 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37386 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3FJTQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130610135154.GA11905@dhcp-26-207.brq.redhat.com>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
	<1370644273-10495-11-git-send-email-yinghai@kernel.org>
	<20130610135154.GA11905@dhcp-26-207.brq.redhat.com>
Date: Mon, 10 Jun 2013 12:16:16 -0700
X-Google-Sender-Auth: nZ__LRT3e_PINmZzI875m7pc3BU
Message-ID: <CAE9FiQUvmyUt048veb_kFr-9Ap2cza7ti28x-cm9AcoU8edhbw@mail.gmail.com>
Subject: Re: [PATCH v3 10/27] genirq: Split __irq_reserve_irqs from irq_alloc_descs
From: Yinghai Lu <yinghai@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 6:51 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Fri, Jun 07, 2013 at 03:30:56PM -0700, Yinghai Lu wrote:
>> irq_alloc_descs and irq_reserve_irqs are almost the same.
>> Separate code out to __irq_reserved_irqs, and other two reuse
>> __irq_reserve_irqs.
>>
>> We will use __irq_reserve_irqs for coming ioapic hotplug support.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Alexander Gordeev <agordeev@redhat.com>
>> ---
>>  include/linux/irq.h  |  1 +
>>  kernel/irq/irqdesc.c | 54 ++++++++++++++++++++++++++++++----------------------
>>  2 files changed, 32 insertions(+), 23 deletions(-)
>>
>> diff --git a/include/linux/irq.h b/include/linux/irq.h
>> index bc4e066..4e0fcbb 100644
>> --- a/include/linux/irq.h
>> +++ b/include/linux/irq.h
>> @@ -600,6 +600,7 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>>
>>  void irq_free_descs(unsigned int irq, unsigned int cnt);
>>  int irq_reserve_irqs(unsigned int from, unsigned int cnt);
>> +int __irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt);
>>
>>  static inline void irq_free_desc(unsigned int irq)
>>  {
>> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
>> index 192a302..3b9fb92 100644
>> --- a/kernel/irq/irqdesc.c
>> +++ b/kernel/irq/irqdesc.c
>> @@ -340,18 +340,15 @@ void irq_free_descs(unsigned int from, unsigned int cnt)
>>  EXPORT_SYMBOL_GPL(irq_free_descs);
>>
>>  /**
>> - * irq_alloc_descs - allocate and initialize a range of irq descriptors
>> - * @irq:     Allocate for specific irq number if irq >= 0
>> + * __irq_reserve_descs - reserve and initialize a range of irq descriptors
>> + * @irq:     Reserve for specific irq number if irq >= 0
>>   * @from:    Start the search from this irq number
>> - * @cnt:     Number of consecutive irqs to allocate.
>> - * @node:    Preferred node on which the irq descriptor should be allocated
>> - * @owner:   Owning module (can be NULL)
>> + * @cnt:     Number of consecutive irqs to reserve.
>>   *
>>   * Returns the first irq number or error code
>>   */
>>  int __ref
>> -__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>> -               struct module *owner)
>> +__irq_reserve_irqs(int irq, unsigned int from, unsigned int cnt)
>>  {
>>       int start, ret;
>>
>> @@ -369,7 +366,7 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>>       start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
>>                                          from, cnt, 0);
>>       ret = -EEXIST;
>> -     if (irq >=0 && start != irq)
>> +     if (irq >= 0 && start != irq)
>>               goto err;
>>
>>       if (start + cnt > nr_irqs) {
>> @@ -380,12 +377,36 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>>
>>       bitmap_set(allocated_irqs, start, cnt);
>>       mutex_unlock(&sparse_irq_lock);
>> -     return alloc_descs(start, cnt, node, owner);
>> +     return start;
>>
>>  err:
>>       mutex_unlock(&sparse_irq_lock);
>>       return ret;
>>  }
>> +
>> +/**
>> + * irq_alloc_descs - allocate and initialize a range of irq descriptors
>> + * @irq:     Allocate for specific irq number if irq >= 0
>> + * @from:    Start the search from this irq number
>> + * @cnt:     Number of consecutive irqs to allocate.
>> + * @node:    Preferred node on which the irq descriptor should be allocated
>> + * @owner:   Owning module (can be NULL)
>> + *
>> + * Returns the first irq number or error code
>> + */
>> +int __ref
>> +__irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
>> +               struct module *owner)
>> +{
>> +     int start;
>> +
>> +     start = __irq_reserve_irqs(irq, from, cnt);
>> +
>> +     if (start < 0)
>> +             return start;
>> +
>> +     return alloc_descs(start, cnt, node, owner);
>
> I think alloc_descs() fail path is needed before return.

__irq_reserve_irqs already return -EEXIST etc,

old kernel is like:

>> @@ -380,12 +377,36 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,

       bitmap_set(allocated_irqs, start, cnt);
       mutex_unlock(&sparse_irq_lock);
     return alloc_descs(start, cnt, node, owner);

 err:
      mutex_unlock(&sparse_irq_lock);
      return ret;

so i don't change the fail path handling.

Thanks

Yinghai
