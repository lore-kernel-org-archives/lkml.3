Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3HSIy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:54:56 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57300
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891Ab3HSIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:54:55 -0400
X-IronPort-AV: E=Sophos;i="4.89,912,1367964000"; 
   d="scan'208";a="24220295"
Message-ID: <5211DD5C.1080306@inria.fr>
Date: Mon, 19 Aug 2013 10:54:52 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Dan Williams <djbw@fb.com>
CC: Vinod Koul <vinod.koul@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine: make dma_channel_rebalance() NUMA aware
References: <51F8F14C.8060507@inria.fr> <CAA9_cmcvssPaatgHe8jCaDTfWe4X2GkWVorvMRxaX7tz2s131w@mail.gmail.com>
In-Reply-To: <CAA9_cmcvssPaatgHe8jCaDTfWe4X2GkWVorvMRxaX7tz2s131w@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 19/08/2013 10:19, Dan Williams a écrit :
>>   * @cap: capability to match
>> - * @n: nth channel desired
>> + * @cpu: cpu index which the channel should be close to
>>   *
>> - * Defaults to returning the channel with the desired capability and the
>> - * lowest reference count when 'n' cannot be satisfied.  Must be called
>> - * under dma_list_mutex.
>> + * If some channels are close to the given cpu, the one with the lowest
>> + * reference count is returned. Otherwise, cpu is ignored and only the
>> + * reference count is taken into account.
> I think we can drop these comments and the distinction, see below.

I understand that we can remove the cpu==-1 case, but I don't see why we
would remove the 3 last lines above. The code still looks for a
NUMA-local channels first.

Here's an updated patch with all your comments applied, except the
removal of these 3 comment lines.

Brice



dmaengine: make dma_channel_rebalance() NUMA aware

dma_channel_rebalance() currently distributes channels by processor ID.
These IDs often change with the BIOS, and the order isn't related to
the DMA channel list (related to PCI bus ids).
* On my SuperMicro dual E5 machine, first socket has processor IDs [0-7]
  (and [16-23] for hyperthreads), second socket has [8-15]+[24-31]
  => channels are properly allocated to local CPUs.
* On Dells R720 with same processors, first socket has even processor IDs,
  second socket has odd numbers
  => half the processors get channels on the remote socket, causing
     cross-NUMA traffic and lower DMA performance.

Change nth_chan() to return the channel with min table_count and in the
NUMA node of the given CPU, if any. If none, the (non-local) channel with
min table_count is returned. nth_chan() is therefore renamed into min_chan()
since we don't iterate until the nth channel anymore. In practice, the
behavior is the same because first channels are taken first and are then
ignored because they got an additional reference.

The new code has a slightly higher complexity since we always scan the
entire list of channels for finding the minimal table_count (instead
of stopping after N chans), and because we check whether the CPU is in the
DMA device locality mask. Overall we still have time complexity =
number of chans x number of processors. This rebalance is rarely used,
so this won't hurt.

On the above SuperMicro machine, channels are still allocated the same.
On the Dells, there are no locality issue anymore (MEMCPY channel X goes
to processor X and to its hyperthread sibling).

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 drivers/dma/dmaengine.c |   64 +++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 27 deletions(-)

Index: linux-3.11-rc3/drivers/dma/dmaengine.c
===================================================================
--- linux-3.11-rc3.orig/drivers/dma/dmaengine.c	2013-07-29 05:53:33.000000000 +0200
+++ linux-3.11-rc3/drivers/dma/dmaengine.c	2013-08-19 10:31:10.600721807 +0200
@@ -376,20 +376,30 @@ void dma_issue_pending_all(void)
 EXPORT_SYMBOL(dma_issue_pending_all);
 
 /**
- * nth_chan - returns the nth channel of the given capability
+ * dma_chan_is_local - returns true if the channel is in the same numa-node as the cpu
+ */
+static bool dma_chan_is_local(struct dma_chan *chan, int cpu)
+{
+	int node = dev_to_node(chan->device->dev);
+	return node == -1 || cpumask_test_cpu(cpu, cpumask_of_node(node));
+}
+
+/**
+ * min_chan - returns the channel with min count and in the same numa-node as the cpu
  * @cap: capability to match
- * @n: nth channel desired
+ * @cpu: cpu index which the channel should be close to
  *
- * Defaults to returning the channel with the desired capability and the
- * lowest reference count when 'n' cannot be satisfied.  Must be called
- * under dma_list_mutex.
+ * If some channels are close to the given cpu, the one with the lowest
+ * reference count is returned. Otherwise, cpu is ignored and only the
+ * reference count is taken into account.
+ * Must be called under dma_list_mutex.
  */
-static struct dma_chan *nth_chan(enum dma_transaction_type cap, int n)
+static struct dma_chan *min_chan(enum dma_transaction_type cap, int cpu)
 {
 	struct dma_device *device;
 	struct dma_chan *chan;
-	struct dma_chan *ret = NULL;
 	struct dma_chan *min = NULL;
+	struct dma_chan *localmin = NULL;
 
 	list_for_each_entry(device, &dma_device_list, global_node) {
 		if (!dma_has_cap(cap, device->cap_mask) ||
@@ -398,27 +408,22 @@ static struct dma_chan *nth_chan(enum dm
 		list_for_each_entry(chan, &device->channels, device_node) {
 			if (!chan->client_count)
 				continue;
-			if (!min)
-				min = chan;
-			else if (chan->table_count < min->table_count)
+			if (!min || chan->table_count < min->table_count)
 				min = chan;
 
-			if (n-- == 0) {
-				ret = chan;
-				break; /* done */
-			}
+			if (dma_chan_is_local(chan, cpu))
+				if (!localmin ||
+				    chan->table_count < localmin->table_count)
+					localmin = chan;
 		}
-		if (ret)
-			break; /* done */
 	}
 
-	if (!ret)
-		ret = min;
+	chan = localmin ? localmin : min;
 
-	if (ret)
-		ret->table_count++;
+	if (chan)
+		chan->table_count++;
 
-	return ret;
+	return chan;
 }
 
 /**
@@ -435,7 +440,6 @@ static void dma_channel_rebalance(void)
 	struct dma_device *device;
 	int cpu;
 	int cap;
-	int n;
 
 	/* undo the last distribution */
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
@@ -454,16 +458,10 @@ static void dma_channel_rebalance(void)
 		return;
 
 	/* redistribute available channels */
-	n = 0;
 	for_each_dma_cap_mask(cap, dma_cap_mask_all)
-		for_each_online_cpu(cpu) {
-			if (num_possible_cpus() > 1)
-				chan = nth_chan(cap, n++);
-			else
-				chan = nth_chan(cap, -1);
-
-			per_cpu_ptr(channel_table[cap], cpu)->chan = chan;
-		}
+		for_each_online_cpu(cpu)
+			per_cpu_ptr(channel_table[cap], cpu)->chan
+			 = min_chan(cap, cpu);
 }
 
 static struct dma_chan *private_candidate(const dma_cap_mask_t *mask,

