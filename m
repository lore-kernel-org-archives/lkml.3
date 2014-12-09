Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaLIUzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:55:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30639 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaLIUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:55:03 -0500
Message-ID: <5487620E.8060807@oracle.com>
Date: Tue, 09 Dec 2014 15:56:46 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2] xen/blkfront: remove redundant flush_op
References: <54860EA4.7090705@oracle.com> <1418135110-7194-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418135110-7194-1-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 09:25 AM, Vitaly Kuznetsov wrote:
> flush_op is unambiguously defined by feature_flush:
>      REQ_FUA | REQ_FLUSH -> BLKIF_OP_WRITE_BARRIER
>      REQ_FLUSH -> BLKIF_OP_FLUSH_DISKCACHE
>      0 -> 0
> and thus can be removed. This is just a cleanup.
>
> The patch was suggested by Boris Ostrovsky.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


> ---
> Changes from v1:
>     Future-proof feature_flush against new flags [Boris Ostrovsky].
>
> The patch is supposed to be applied after "xen/blkfront: improve protection
> against issuing unsupported REQ_FUA".
> ---
>   drivers/block/xen-blkfront.c | 51 +++++++++++++++++++++++++++-----------------
>   1 file changed, 31 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 2e6c103..2236c6f 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -126,7 +126,6 @@ struct blkfront_info
>   	unsigned int persistent_gnts_c;
>   	unsigned long shadow_free;
>   	unsigned int feature_flush;
> -	unsigned int flush_op;
>   	unsigned int feature_discard:1;
>   	unsigned int feature_secdiscard:1;
>   	unsigned int discard_granularity;
> @@ -479,7 +478,19 @@ static int blkif_queue_request(struct request *req)
>   				 * way.  (It's also a FLUSH+FUA, since it is
>   				 * guaranteed ordered WRT previous writes.)
>   				 */
> -				ring_req->operation = info->flush_op;
> +				switch (info->feature_flush &
> +					((REQ_FLUSH|REQ_FUA))) {
> +				case REQ_FLUSH|REQ_FUA:
> +					ring_req->operation =
> +						BLKIF_OP_WRITE_BARRIER;
> +					break;
> +				case REQ_FLUSH:
> +					ring_req->operation =
> +						BLKIF_OP_FLUSH_DISKCACHE;
> +					break;
> +				default:
> +					ring_req->operation = 0;
> +				}
>   			}
>   			ring_req->u.rw.nr_segments = nseg;
>   		}
> @@ -685,20 +696,26 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
>   	return 0;
>   }
>   
> +static const char *flush_info(unsigned int feature_flush)
> +{
> +	switch (feature_flush & ((REQ_FLUSH | REQ_FUA))) {
> +	case REQ_FLUSH|REQ_FUA:
> +		return "barrier: enabled;";
> +	case REQ_FLUSH:
> +		return "flush diskcache: enabled;";
> +	default:
> +		return "barrier or flush: disabled;";
> +	}
> +}
>   
>   static void xlvbd_flush(struct blkfront_info *info)
>   {
>   	blk_queue_flush(info->rq, info->feature_flush);
> -	printk(KERN_INFO "blkfront: %s: %s: %s %s %s %s %s\n",
> -	       info->gd->disk_name,
> -	       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
> -		"barrier" : (info->flush_op == BLKIF_OP_FLUSH_DISKCACHE ?
> -		"flush diskcache" : "barrier or flush"),
> -	       info->feature_flush ? "enabled;" : "disabled;",
> -	       "persistent grants:",
> -	       info->feature_persistent ? "enabled;" : "disabled;",
> -	       "indirect descriptors:",
> -	       info->max_indirect_segments ? "enabled;" : "disabled;");
> +	pr_info("blkfront: %s: %s %s %s %s %s\n",
> +		info->gd->disk_name, flush_info(info->feature_flush),
> +		"persistent grants:", info->feature_persistent ?
> +		"enabled;" : "disabled;", "indirect descriptors:",
> +		info->max_indirect_segments ? "enabled;" : "disabled;");
>   }
>   
>   static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
> @@ -1190,7 +1207,6 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
>   				if (error == -EOPNOTSUPP)
>   					error = 0;
>   				info->feature_flush = 0;
> -				info->flush_op = 0;
>   				xlvbd_flush(info);
>   			}
>   			/* fall through */
> @@ -1810,7 +1826,6 @@ static void blkfront_connect(struct blkfront_info *info)
>   		physical_sector_size = sector_size;
>   
>   	info->feature_flush = 0;
> -	info->flush_op = 0;
>   
>   	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
>   			    "feature-barrier", "%d", &barrier,
> @@ -1823,10 +1838,8 @@ static void blkfront_connect(struct blkfront_info *info)
>   	 *
>   	 * If there are barriers, then we use flush.
>   	 */
> -	if (!err && barrier) {
> +	if (!err && barrier)
>   		info->feature_flush = REQ_FLUSH | REQ_FUA;
> -		info->flush_op = BLKIF_OP_WRITE_BARRIER;
> -	}
>   	/*
>   	 * And if there is "feature-flush-cache" use that above
>   	 * barriers.
> @@ -1835,10 +1848,8 @@ static void blkfront_connect(struct blkfront_info *info)
>   			    "feature-flush-cache", "%d", &flush,
>   			    NULL);
>   
> -	if (!err && flush) {
> +	if (!err && flush)
>   		info->feature_flush = REQ_FLUSH;
> -		info->flush_op = BLKIF_OP_FLUSH_DISKCACHE;
> -	}
>   
>   	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
>   			    "feature-discard", "%d", &discard,

