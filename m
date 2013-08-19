Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848Ab3HSITy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:19:54 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:43318 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3HSITw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:19:52 -0400
MIME-Version: 1.0
In-Reply-To: <51F8F14C.8060507@inria.fr>
References: <51F8F14C.8060507@inria.fr>
Date: Mon, 19 Aug 2013 01:19:51 -0700
X-Google-Sender-Auth: t0NHpmWVg-VXIPSo9rWfoXo4x10
Message-ID: <CAA9_cmcvssPaatgHe8jCaDTfWe4X2GkWVorvMRxaX7tz2s131w@mail.gmail.com>
Subject: Re: dmaengine: make dma_channel_rebalance() NUMA aware
From: Dan Williams <djbw@fb.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Vinod Koul <vinod.koul@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 4:13 AM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> dmaengine: make dma_channel_rebalance() NUMA aware
>
> dma_channel_rebalance() currently distributes channels by processor ID.
> These IDs often change with the BIOS, and the order isn't related to
> the DMA channel list (related to PCI bus ids).
> * On my SuperMicro dual E5 machine, first socket has processor IDs [0-7]
>   (and [16-23] for hyperthreads), second socket has [8-15]+[24-31]
>   => channels are properly allocated to local CPUs.
> * On Dells R720 with same processors, first socket has even processor IDs,
>   second socket has odd numbers
>   => half the processors get channels on the remote socket, causing
>      cross-NUMA traffic and lower DMA performance.
>
> Change nth_chan() to return the channel with min table_count and in the
> NUMA node of the given CPU, if any. If none, the (non-local) channel with
> min table_count is returned. nth_chan() is therefore renamed into min_chan()
> since we don't iterate until the nth channel anymore. In practice, the
> behavior is the same because first channels are taken first and are then
> ignored because they got an additional reference.
>
> The new code has a slightly higher complexity since we always scan the
> entire list of channels for finding the minimal table_count (instead
> of stopping after N chans), and because we check whether the CPU is in the
> DMA device locality mask. Overall we still have time complexity =
> number of chans x number of processors. This rebalance is rarely used,
> so this won't hurt.
>
> On the above SuperMicro machine, channels are still allocated the same.
> On the Dells, there are no locality issue anymore (each MEMCPY channel
> goes to both hyperthreads of a single core of the local socket).
>
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
> ---
>  drivers/dma/dmaengine.c |   64 +++++++++++++++++++++++++++---------------------
>  1 file changed, 37 insertions(+), 27 deletions(-)
>
> Index: b/drivers/dma/dmaengine.c
> ===================================================================
> --- a/drivers/dma/dmaengine.c   2013-07-29 05:53:33.000000000 +0200
> +++ b/drivers/dma/dmaengine.c   2013-07-31 13:02:34.640590036 +0200
> @@ -376,20 +376,35 @@ void dma_issue_pending_all(void)
>  EXPORT_SYMBOL(dma_issue_pending_all);
>
>  /**
> - * nth_chan - returns the nth channel of the given capability
> + * dma_chan_is_local - returns 1 if the channel is close to the cpu

Might as well be explicit and say "returns true if the channel is in
the same numa-node as the cpu."

> + */
> +static int dma_chan_is_local(struct dma_chan *chan, int cpu)

Make it return bool since it's an "is" routine.

> +{
> +#ifdef CONFIG_NUMA
> +       int node = dev_to_node(chan->device->dev);
> +       return node == -1 || cpumask_test_cpu(cpu, cpumask_of_node(node));
> +#else
> +       return 1;
> +#endif

The ifdef is not necessary as dev_to_node() returns -1 in the !CONFIG_NUMA case.

> +}
> +
> +/**
> + * min_chan - returns the channel with min count and close to the cpu

same as above replace "close" with "same numa-node".

>   * @cap: capability to match
> - * @n: nth channel desired
> + * @cpu: cpu index which the channel should be close to
>   *
> - * Defaults to returning the channel with the desired capability and the
> - * lowest reference count when 'n' cannot be satisfied.  Must be called
> - * under dma_list_mutex.
> + * If some channels are close to the given cpu, the one with the lowest
> + * reference count is returned. Otherwise, cpu is ignored and only the
> + * reference count is taken into account.

I think we can drop these comments and the distinction, see below.

> + * Must be called under dma_list_mutex.
>   */
> -static struct dma_chan *nth_chan(enum dma_transaction_type cap, int n)
> +static struct dma_chan *min_chan(enum dma_transaction_type cap, int cpu)
>  {
>         struct dma_device *device;
>         struct dma_chan *chan;
>         struct dma_chan *ret = NULL;
>         struct dma_chan *min = NULL;
> +       struct dma_chan *localmin = NULL;
>
>         list_for_each_entry(device, &dma_device_list, global_node) {
>                 if (!dma_has_cap(cap, device->cap_mask) ||
> @@ -398,22 +413,18 @@ static struct dma_chan *nth_chan(enum dm
>                 list_for_each_entry(chan, &device->channels, device_node) {
>                         if (!chan->client_count)
>                                 continue;
> -                       if (!min)
> -                               min = chan;
> -                       else if (chan->table_count < min->table_count)
> +                       if (!min || chan->table_count < min->table_count)
>                                 min = chan;
>
> -                       if (n-- == 0) {
> -                               ret = chan;
> -                               break; /* done */
> -                       }
> +                       if (cpu != -1 && dma_chan_is_local(chan, cpu))
> +                               if (!localmin ||
> +                                   chan->table_count < localmin->table_count)
> +                                       localmin = chan;
>                 }
> -               if (ret)
> -                       break; /* done */

Since we don't break out of the loop early anymore the "ret" variable
can be killed.  Just re-use chan.

>         }
>
>         if (!ret)
> -               ret = min;
> +               ret = localmin ? localmin : min;
>
>         if (ret)
>                 ret->table_count++;
> @@ -435,7 +446,6 @@ static void dma_channel_rebalance(void)
>         struct dma_device *device;
>         int cpu;
>         int cap;
> -       int n;
>
>         /* undo the last distribution */
>         for_each_dma_cap_mask(cap, dma_cap_mask_all)
> @@ -454,16 +464,16 @@ static void dma_channel_rebalance(void)
>                 return;
>
>         /* redistribute available channels */
> -       n = 0;
> -       for_each_dma_cap_mask(cap, dma_cap_mask_all)
> -               for_each_online_cpu(cpu) {
> -                       if (num_possible_cpus() > 1)
> -                               chan = nth_chan(cap, n++);
> -                       else
> -                               chan = nth_chan(cap, -1);
> -
> -                       per_cpu_ptr(channel_table[cap], cpu)->chan = chan;
> -               }
> +       if (num_possible_cpus() == 1) {
> +               for_each_dma_cap_mask(cap, dma_cap_mask_all)
> +                       per_cpu_ptr(channel_table[cap], 0)->chan
> +                        = min_chan(cap, -1);
> +       } else {
> +               for_each_dma_cap_mask(cap, dma_cap_mask_all)
> +                       for_each_online_cpu(cpu)
> +                       per_cpu_ptr(channel_table[cap], cpu)->chan
> +                        = min_chan(cap, cpu);

I think the original suffered from this as well, but when searching
for the channel with the minimal reference count there is no
distinction between trying to allocate a channel per-cpu or a
capability type per-channel.  min reference count satisfies both.  So
we can drop the num_possible_cpus() test and the "-1" case in
min_chan().

--
Dan
