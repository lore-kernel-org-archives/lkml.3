Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3LNE1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 23:27:55 -0500
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:59728 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751734Ab3LNE1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 23:27:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:69:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:4049:4118:4321:4385:4605:5007:6691:7576:7652:8603:9010:10004:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12683:12740:13019,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cause78_277d60386b22a
X-Filterd-Recvd-Size: 7099
Message-ID: <1386995255.2276.1.camel@joe-AO722>
Subject: Re: [PATCH 094/115] ion: fix printk warnings
From: Joe Perches <joe@perches.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>
Date: Fri, 13 Dec 2013 20:27:35 -0800
In-Reply-To: <1386991595-6251-2-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
	 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
	 <1386991595-6251-2-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-13 at 19:26 -0800, John Stultz wrote:
> From: Colin Cross <ccross@android.com>
> 
> Use %z for size_t and %pa for dma_addr_t to avoid warnings in printks.

dma_addr_t is not a phys_addr_t and should _not_ be emitted
with %pa.

Until %pad is in -next, use %lx, (unsigned long long)dma_addr_t.

> Signed-off-by: Colin Cross <ccross@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/ion/ion.c            | 23 ++++++++++++-----------
>  drivers/staging/android/ion/ion_chunk_heap.c |  2 +-
>  drivers/staging/android/ion/ion_cma_heap.c   |  4 ++--
>  drivers/staging/android/ion/ion_heap.c       |  2 +-
>  4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 199ab9a..57698e6 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -471,7 +471,7 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
>  	struct ion_heap *heap;
>  	int ret;
>  
> -	pr_debug("%s: len %d align %d heap_id_mask %u flags %x\n", __func__,
> +	pr_debug("%s: len %zu align %zu heap_id_mask %u flags %x\n", __func__,
>  		 len, align, heap_id_mask, flags);
>  	/*
>  	 * traverse the list of heaps available in this system in priority
> @@ -688,7 +688,7 @@ static int ion_debug_client_show(struct seq_file *s, void *unused)
>  	for (i = 0; i < ION_NUM_HEAP_IDS; i++) {
>  		if (!names[i])
>  			continue;
> -		seq_printf(s, "%16.16s: %16u\n", names[i], sizes[i]);
> +		seq_printf(s, "%16.16s: %16zu\n", names[i], sizes[i]);
>  	}
>  	return 0;
>  }
> @@ -1336,10 +1336,10 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
>  			char task_comm[TASK_COMM_LEN];
>  
>  			get_task_comm(task_comm, client->task);
> -			seq_printf(s, "%16.s %16u %16u\n", task_comm,
> +			seq_printf(s, "%16.s %16u %16zu\n", task_comm,
>  				   client->pid, size);
>  		} else {
> -			seq_printf(s, "%16.s %16u %16u\n", client->name,
> +			seq_printf(s, "%16.s %16u %16zu\n", client->name,
>  				   client->pid, size);
>  		}
>  	}
> @@ -1354,19 +1354,20 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
>  			continue;
>  		total_size += buffer->size;
>  		if (!buffer->handle_count) {
> -			seq_printf(s, "%16.s %16u %16u %d %d\n", buffer->task_comm,
> -				   buffer->pid, buffer->size, buffer->kmap_cnt,
> +			seq_printf(s, "%16.s %16u %16zu %d %d\n",
> +				   buffer->task_comm, buffer->pid,
> +				   buffer->size, buffer->kmap_cnt,
>  				   atomic_read(&buffer->ref.refcount));
>  			total_orphaned_size += buffer->size;
>  		}
>  	}
>  	mutex_unlock(&dev->buffer_lock);
>  	seq_printf(s, "----------------------------------------------------\n");
> -	seq_printf(s, "%16.s %16u\n", "total orphaned",
> +	seq_printf(s, "%16.s %16zu\n", "total orphaned",
>  		   total_orphaned_size);
> -	seq_printf(s, "%16.s %16u\n", "total ", total_size);
> +	seq_printf(s, "%16.s %16zu\n", "total ", total_size);
>  	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE)
> -		seq_printf(s, "%16.s %16u\n", "deferred free",
> +		seq_printf(s, "%16.s %16zu\n", "deferred free",
>  				heap->free_list_size);
>  	seq_printf(s, "----------------------------------------------------\n");
>  
> @@ -1522,11 +1523,11 @@ void __init ion_reserve(struct ion_platform_data *data)
>  			int ret = memblock_reserve(data->heaps[i].base,
>  					       data->heaps[i].size);
>  			if (ret)
> -				pr_err("memblock reserve of %x@%lx failed\n",
> +				pr_err("memblock reserve of %zx@%lx failed\n",
>  				       data->heaps[i].size,
>  				       data->heaps[i].base);
>  		}
> -		pr_info("%s: %s reserved base %lx size %d\n", __func__,
> +		pr_info("%s: %s reserved base %lx size %zu\n", __func__,
>  			data->heaps[i].name,
>  			data->heaps[i].base,
>  			data->heaps[i].size);
> diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
> index fb1a7b9..4eacf52 100644
> --- a/drivers/staging/android/ion/ion_chunk_heap.c
> +++ b/drivers/staging/android/ion/ion_chunk_heap.c
> @@ -186,7 +186,7 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
>  	chunk_heap->heap.ops = &chunk_heap_ops;
>  	chunk_heap->heap.type = ION_HEAP_TYPE_CHUNK;
>  	chunk_heap->heap.flags = ION_HEAP_FLAG_DEFER_FREE;
> -	pr_info("%s: base %lu size %u align %ld\n", __func__, chunk_heap->base,
> +	pr_info("%s: base %lu size %zu align %ld\n", __func__, chunk_heap->base,
>  		heap_data->size, heap_data->align);
>  
>  	return &chunk_heap->heap;
> diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
> index 86b6cf5..1e308a0 100644
> --- a/drivers/staging/android/ion/ion_cma_heap.c
> +++ b/drivers/staging/android/ion/ion_cma_heap.c
> @@ -128,8 +128,8 @@ static int ion_cma_phys(struct ion_heap *heap, struct ion_buffer *buffer,
>  	struct device *dev = cma_heap->dev;
>  	struct ion_cma_buffer_info *info = buffer->priv_virt;
>  
> -	dev_dbg(dev, "Return buffer %p physical address 0x%x\n", buffer,
> -		info->handle);
> +	dev_dbg(dev, "Return buffer %p physical address 0x%pa\n", buffer,
> +		&info->handle);
>  
>  	*addr = info->handle;
>  	*len = buffer->size;
> diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
> index a5a7c572..deaab7c 100644
> --- a/drivers/staging/android/ion/ion_heap.c
> +++ b/drivers/staging/android/ion/ion_heap.c
> @@ -281,7 +281,7 @@ struct ion_heap *ion_heap_create(struct ion_platform_heap *heap_data)
>  	}
>  
>  	if (IS_ERR_OR_NULL(heap)) {
> -		pr_err("%s: error creating heap %s type %d base %lu size %u\n",
> +		pr_err("%s: error creating heap %s type %d base %lu size %zu\n",
>  		       __func__, heap_data->name, heap_data->type,
>  		       heap_data->base, heap_data->size);
>  		return ERR_PTR(-EINVAL);



