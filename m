Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbbAYVMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:12:45 -0500
Received: from mail.nuclearfallout.net ([208.146.45.251]:41608 "EHLO
	mail.nuclearfallout.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbbAYVMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:12:43 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2015 16:12:43 EST
Message-ID: <54C55AB6.7060207@nuclearfallout.net>
Date: Sun, 25 Jan 2015 13:05:58 -0800
From: John <jw@nuclearfallout.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        Wei Liu <wei.liu2@citrix.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.18 007/183] xen-netback: support frontends without feature-rx-notify
 again
References: <20150125180810.160428929@linuxfoundation.org> <20150125180810.508350174@linuxfoundation.org>
In-Reply-To: <20150125180810.508350174@linuxfoundation.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

No objections. I've been using it in production and have not seen any 
problems.

-John

On 1/25/2015 10:05 AM, Greg Kroah-Hartman wrote:
> 3.18-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: David Vrabel <david.vrabel@citrix.com>
>
> [ Upstram commit 26c0e102585d5a4d311f5d6eb7f524d288e7f6b7 ]
>
> Commit bc96f648df1bbc2729abbb84513cf4f64273a1f1 (xen-netback: make
> feature-rx-notify mandatory) incorrectly assumed that there were no
> frontends in use that did not support this feature.  But the frontend
> driver in MiniOS does not and since this is used by (qemu) stubdoms,
> these stopped working.
>
> Netback sort of works as-is in this mode except:
>
> - If there are no Rx requests and the internal Rx queue fills, only
>    the drain timeout will wake the thread.  The default drain timeout
>    of 10 s would give unacceptable pauses.
>
> - If an Rx stall was detected and the internal Rx queue is drained,
>    then the Rx thread would never wake.
>
> Handle these two cases (when feature-rx-notify is disabled) by:
>
> - Reducing the drain timeout to 30 ms.
>
> - Disabling Rx stall detection.
>
> Reported-by: John <jw@nuclearfallout.net>
> Tested-by: John <jw@nuclearfallout.net>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Reviewed-by: Wei Liu <wei.liu2@citrix.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/net/xen-netback/common.h    |    4 +++-
>   drivers/net/xen-netback/interface.c |    4 +++-
>   drivers/net/xen-netback/netback.c   |   27 ++++++++++++++-------------
>   drivers/net/xen-netback/xenbus.c    |   12 +++++++++---
>   4 files changed, 29 insertions(+), 18 deletions(-)
>
> --- a/drivers/net/xen-netback/common.h
> +++ b/drivers/net/xen-netback/common.h
> @@ -230,6 +230,8 @@ struct xenvif {
>   	 */
>   	bool disabled;
>   	unsigned long status;
> +	unsigned long drain_timeout;
> +	unsigned long stall_timeout;
>   
>   	/* Queues */
>   	struct xenvif_queue *queues;
> @@ -328,7 +330,7 @@ irqreturn_t xenvif_interrupt(int irq, vo
>   extern bool separate_tx_rx_irq;
>   
>   extern unsigned int rx_drain_timeout_msecs;
> -extern unsigned int rx_drain_timeout_jiffies;
> +extern unsigned int rx_stall_timeout_msecs;
>   extern unsigned int xenvif_max_queues;
>   
>   #ifdef CONFIG_DEBUG_FS
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -166,7 +166,7 @@ static int xenvif_start_xmit(struct sk_b
>   		goto drop;
>   
>   	cb = XENVIF_RX_CB(skb);
> -	cb->expires = jiffies + rx_drain_timeout_jiffies;
> +	cb->expires = jiffies + vif->drain_timeout;
>   
>   	xenvif_rx_queue_tail(queue, skb);
>   	xenvif_kick_thread(queue);
> @@ -414,6 +414,8 @@ struct xenvif *xenvif_alloc(struct devic
>   	vif->ip_csum = 1;
>   	vif->dev = dev;
>   	vif->disabled = false;
> +	vif->drain_timeout = msecs_to_jiffies(rx_drain_timeout_msecs);
> +	vif->stall_timeout = msecs_to_jiffies(rx_stall_timeout_msecs);
>   
>   	/* Start out with no queues. */
>   	vif->queues = NULL;
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -60,14 +60,12 @@ module_param(separate_tx_rx_irq, bool, 0
>    */
>   unsigned int rx_drain_timeout_msecs = 10000;
>   module_param(rx_drain_timeout_msecs, uint, 0444);
> -unsigned int rx_drain_timeout_jiffies;
>   
>   /* The length of time before the frontend is considered unresponsive
>    * because it isn't providing Rx slots.
>    */
> -static unsigned int rx_stall_timeout_msecs = 60000;
> +unsigned int rx_stall_timeout_msecs = 60000;
>   module_param(rx_stall_timeout_msecs, uint, 0444);
> -static unsigned int rx_stall_timeout_jiffies;
>   
>   unsigned int xenvif_max_queues;
>   module_param_named(max_queues, xenvif_max_queues, uint, 0644);
> @@ -2022,7 +2020,7 @@ static bool xenvif_rx_queue_stalled(stru
>   	return !queue->stalled
>   		&& prod - cons < XEN_NETBK_RX_SLOTS_MAX
>   		&& time_after(jiffies,
> -			      queue->last_rx_time + rx_stall_timeout_jiffies);
> +			      queue->last_rx_time + queue->vif->stall_timeout);
>   }
>   
>   static bool xenvif_rx_queue_ready(struct xenvif_queue *queue)
> @@ -2040,8 +2038,9 @@ static bool xenvif_have_rx_work(struct x
>   {
>   	return (!skb_queue_empty(&queue->rx_queue)
>   		&& xenvif_rx_ring_slots_available(queue, XEN_NETBK_RX_SLOTS_MAX))
> -		|| xenvif_rx_queue_stalled(queue)
> -		|| xenvif_rx_queue_ready(queue)
> +		|| (queue->vif->stall_timeout &&
> +		    (xenvif_rx_queue_stalled(queue)
> +		     || xenvif_rx_queue_ready(queue)))
>   		|| kthread_should_stop()
>   		|| queue->vif->disabled;
>   }
> @@ -2094,6 +2093,9 @@ int xenvif_kthread_guest_rx(void *data)
>   	struct xenvif_queue *queue = data;
>   	struct xenvif *vif = queue->vif;
>   
> +	if (!vif->stall_timeout)
> +		xenvif_queue_carrier_on(queue);
> +
>   	for (;;) {
>   		xenvif_wait_for_rx_work(queue);
>   
> @@ -2120,10 +2122,12 @@ int xenvif_kthread_guest_rx(void *data)
>   		 * while it's probably not responsive, drop the
>   		 * carrier so packets are dropped earlier.
>   		 */
> -		if (xenvif_rx_queue_stalled(queue))
> -			xenvif_queue_carrier_off(queue);
> -		else if (xenvif_rx_queue_ready(queue))
> -			xenvif_queue_carrier_on(queue);
> +		if (vif->stall_timeout) {
> +			if (xenvif_rx_queue_stalled(queue))
> +				xenvif_queue_carrier_off(queue);
> +			else if (xenvif_rx_queue_ready(queue))
> +				xenvif_queue_carrier_on(queue);
> +		}
>   
>   		/* Queued packets may have foreign pages from other
>   		 * domains.  These cannot be queued indefinitely as
> @@ -2194,9 +2198,6 @@ static int __init netback_init(void)
>   	if (rc)
>   		goto failed_init;
>   
> -	rx_drain_timeout_jiffies = msecs_to_jiffies(rx_drain_timeout_msecs);
> -	rx_stall_timeout_jiffies = msecs_to_jiffies(rx_stall_timeout_msecs);
> -
>   #ifdef CONFIG_DEBUG_FS
>   	xen_netback_dbg_root = debugfs_create_dir("xen-netback", NULL);
>   	if (IS_ERR_OR_NULL(xen_netback_dbg_root))
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -886,9 +886,15 @@ static int read_xenbus_vif_flags(struct
>   		return -EOPNOTSUPP;
>   
>   	if (xenbus_scanf(XBT_NIL, dev->otherend,
> -			 "feature-rx-notify", "%d", &val) < 0 || val == 0) {
> -		xenbus_dev_fatal(dev, -EINVAL, "feature-rx-notify is mandatory");
> -		return -EINVAL;
> +			 "feature-rx-notify", "%d", &val) < 0)
> +		val = 0;
> +	if (!val) {
> +		/* - Reduce drain timeout to poll more frequently for
> +		 *   Rx requests.
> +		 * - Disable Rx stall detection.
> +		 */
> +		be->vif->drain_timeout = msecs_to_jiffies(30);
> +		be->vif->stall_timeout = 0;
>   	}
>   
>   	if (xenbus_scanf(XBT_NIL, dev->otherend, "feature-sg",
>
>

