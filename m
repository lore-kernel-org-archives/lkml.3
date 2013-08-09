Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966929Ab3HIADz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:03:55 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53111 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966789Ab3HIADx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:03:53 -0400
MIME-Version: 1.0
In-Reply-To: <FC9702EC51E4CA40A875703BEBD6CEF80183DA88@SHSMSX101.ccr.corp.intel.com>
References: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
	<1337003229-9158-4-git-send-email-jiang.liu@huawei.com>
	<CANVTcTan9N=Bvf=-vDwOQhS13y+JtWfqApF75yuksQuFBBVDZw@mail.gmail.com>
	<FC9702EC51E4CA40A875703BEBD6CEF80183DA88@SHSMSX101.ccr.corp.intel.com>
Date: Thu, 8 Aug 2013 17:03:51 -0700
Message-ID: <CAPoiz9wm=K0jLhYQzRbuOe5gP376W6ovoU6pxCqe1Fqmv8W28Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/7] dmaengine: enhance dmaengine to support DMA
 device hotplug
From: Jon Mason <jdmason@kudzu.us>
To: "Wang, Rui Y" <rui.y.wang@intel.com>
Cc: "liuj97@gmail.com" <liuj97@gmail.com>,
        "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "chenkeping@huawei.com" <chenkeping@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Guo, Chaohong" <chaohong.guo@intel.com>, Dan Williams <djbw@fb.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 3:59 AM, Wang, Rui Y <rui.y.wang@intel.com> wrote:
> (resend adding cc list)

The e-mail you are responding to is over a year old, but doesn't
appear to have been accepted.  I suppose late is better than never...

Adding Dan Williams new e-mail address and Dave Jiang.

Thanks,
Jon

>
> Hi Jiang,
> See my comments inline.
>
>> -----Original Message-----
>> From: Jiang Liu <liuj97@gmail.com>
>> Date: Mon, 14 May 2012 21:47:05 +0800
>> Subject: [RFC PATCH v2 3/7] dmaengine: enhance dmaengine to support DMA
>> device hotplug
>> To: Dan Williams <dan.j.williams@intel.com>, Maciej Sosnowski
>> <maciej.sosnowski@intel.com>, Vinod Koul <vinod.koul@intel.com>
>> Cc: Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
>> linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
>>
>> From: Jiang Liu <liuj97@gmail.com>
>>
>> From: Jiang Liu <liuj97@gmail.com>
>>
>> To support DMA device hotplug, dmaengine must correctly manage reference
>> count for DMA channels. On the other hand, DMA hot path is performance
>> critical, reference count management code should avoid polluting global shared
>> cachelines, otherwise it may cause heavy performance penalty.
>>
>> This patch introduces a lightweight DMA channel reference count management
>> mechanism by using percpu counter. When DMA device hotplug is disabled,
>> there's no performance penalty. When hotplug is enabled, a
>> dma_find_channel()/dma_put_channel() pair adds two local memory accesses
>> to the hot path.
>>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>> ---
>>  drivers/dma/dmaengine.c   |  112
>> +++++++++++++++++++++++++++++++++++++++++----
>>  include/linux/dmaengine.h |   29 +++++++++++-
>>  2 files changed, 129 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c index
>> d3b1c48..eca45c0 100644
>> --- a/drivers/dma/dmaengine.c
>> +++ b/drivers/dma/dmaengine.c
>> @@ -61,12 +61,20 @@
>>  #include <linux/rculist.h>
>>  #include <linux/idr.h>
>>  #include <linux/slab.h>
>> +#include <linux/sched.h>
>>
>>  static DEFINE_MUTEX(dma_list_mutex);
>>  static DEFINE_IDR(dma_idr);
>>  static LIST_HEAD(dma_device_list);
>>  static long dmaengine_client_count;
>>
>> +#ifdef       CONFIG_DMA_ENGINE_HOTPLUG
>> +static atomic_t dmaengine_dirty;
>> +static struct static_key dmaengine_quiesce = STATIC_KEY_INIT_FALSE;
>> +static DECLARE_WAIT_QUEUE_HEAD(dmaengine_wait_queue);
>> +DEFINE_PER_CPU(long, dmaengine_chan_ref_count);
>> +#endif       /* CONFIG_DMA_ENGINE_HOTPLUG */
>> +
>>  /* --- sysfs implementation --- */
>>
>>  /**
>> @@ -305,10 +313,40 @@ arch_initcall(dma_channel_table_init);
>>   */
>>  struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type)
>> {
>> -     return this_cpu_read(channel_table[tx_type]->chan);
>> +     struct dma_chan *chan = this_cpu_read(channel_table[tx_type]->chan);
>> +
>> +#ifdef       CONFIG_DMA_ENGINE_HOTPLUG
>> +     this_cpu_inc(dmaengine_chan_ref_count);
>> +     if (static_key_false(&dmaengine_quiesce))
>> +             chan = NULL;
>> +#endif
>> +
>> +     return chan;
>>  }
>>  EXPORT_SYMBOL(dma_find_channel);
>>
>> +#ifdef       CONFIG_DMA_ENGINE_HOTPLUG
>> +struct dma_chan *dma_get_channel(struct dma_chan *chan) {
>> +     if (static_key_false(&dmaengine_quiesce))
>> +             atomic_inc(&dmaengine_dirty);
>> +     this_cpu_inc(dmaengine_chan_ref_count);
>> +
>> +     return chan;
>> +}
>> +EXPORT_SYMBOL(dma_get_channel);
>> +#endif
>> +
>> +/**
>> + * dma_has_capability - check whether any channel supports tx_type
>> + * @tx_type: transaction type
>> + */
>> +bool dma_has_capability(enum dma_transaction_type tx_type) {
>> +     return !!this_cpu_read(channel_table[tx_type]->chan);
>> +}
>> +EXPORT_SYMBOL(dma_has_capability);
>> +
>>  /*
>>   * net_dma_find_channel - find a channel for net_dma
>>   * net_dma has alignment requirements
>> @@ -316,10 +354,15 @@ EXPORT_SYMBOL(dma_find_channel);  struct
>> dma_chan *net_dma_find_channel(void)  {
>>       struct dma_chan *chan = dma_find_channel(DMA_MEMCPY);
>> -     if (chan && !is_dma_copy_aligned(chan->device, 1, 1, 1))
>> -             return NULL;
>>
>> -     return chan;
>> +     if (chan && is_dma_copy_aligned(chan->device, 1, 1, 1))
>> +             return chan;
>> +
>> +#ifdef       CONFIG_DMA_ENGINE_HOTPLUG
>> +     this_cpu_dec(dmaengine_chan_ref_count);
>> +#endif
>> +
>> +     return NULL;
>>  }
>>  EXPORT_SYMBOL(net_dma_find_channel);
>>
>> @@ -393,6 +436,37 @@ static struct dma_chan *nth_chan(enum
>> dma_transaction_type cap, int n)
>>       return ret;
>>  }
>>
>> +static void dma_channel_quiesce(void)
>> +{
>> +#ifdef       CONFIG_DMA_ENGINE_HOTPLUG
>> +     int cpu;
>> +     long ref_count;
>> +     int quiesce_count = 0;
>> +
>> +     static_key_slow_inc(&dmaengine_quiesce);
>> +
>> +     do {
>> +             atomic_set(&dmaengine_dirty, 0);
>> +             schedule_timeout(1);
>> +
>> +             if (atomic_read(&dmaengine_dirty)) {
>> +                     quiesce_count = 0;
>> +                     continue;
>> +             }
>> +
>> +             ref_count = 0;
>> +             for_each_possible_cpu(cpu)
>> +                     ref_count += per_cpu(dmaengine_chan_ref_count, cpu);
>> +             if (ref_count == 0)
>> +                     quiesce_count++;
>> +             else
>> +                     quiesce_count = 0;
>> +     } while (quiesce_count < 10);
>> +
>> +     static_key_slow_dec(&dmaengine_quiesce);
>> +#endif
>> +}
>> +
>
> The purpose of dma_channel_quiesce() is unclear to me. It waits until dmaengine_chan_ref_count is 0, but how do you prevent someone from using dma after it returns?
>
> <snip>
>
>> @@ -767,14 +848,22 @@ void dma_async_device_unregister(struct
>> dma_device *device)
>>
>>       mutex_lock(&dma_list_mutex);
>>       list_del_rcu(&device->global_node);
>> -     dma_channel_rebalance();
>> +     dma_channel_rebalance(true);
>>       mutex_unlock(&dma_list_mutex);
>>
>>       /* Check whether it's called from module exit function. */
>>       if (try_module_get(device->dev->driver->owner)) {
>> +#ifndef      CONFIG_DMA_ENGINE_HOTPLUG
>>               dev_warn(device->dev,
>>                       "%s isn't called from module exit function.\n",
>>                       __func__);
>> +#else
>> +             list_for_each_entry(chan, &device->channels, device_node) {
>> +                     /* TODO: notify clients to release channels*/
>> +                     wait_event(dmaengine_wait_queue,
>> +                                chan->client_count == 0);
>> +             }
>
> How do you notify clients to release the channels? Is there an updated version which handles this? There're resources (e.g. timers) that must be free'd, which can only happen when someone calls dma_chan_put() until client_count reaches 0 and device_free_chan_resources() gets called.
>
> Rui Wang
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
