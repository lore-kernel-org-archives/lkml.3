Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaHRRnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:43:46 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62675 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaHRRnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:43:45 -0400
Message-ID: <53F23B4C.2000507@cogentembedded.com>
Date: Mon, 18 Aug 2014 21:43:40 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Pankaj Gupta <pagupta@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
CC: davem@davemloft.net, jasowang@redhat.com, mst@redhat.com,
        dgibson@redhat.com, vfalico@gmail.com, edumazet@google.com,
        vyasevic@redhat.com, hkchu@google.com, wuzhy@linux.vnet.ibm.com,
        xemul@parallels.com, therbert@google.com, bhutchings@solarflare.com,
        xii@google.com, stephen@networkplumber.org
Subject: Re: [RFC 1/4] net: allow large number of rx queues
References: <1408369040-1216-1-git-send-email-pagupta@redhat.com> <1408369040-1216-2-git-send-email-pagupta@redhat.com>
In-Reply-To: <1408369040-1216-2-git-send-email-pagupta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/18/2014 05:37 PM, Pankaj Gupta wrote:

> netif_alloc_rx_queues() uses kcalloc() to allocate memory
> for "struct netdev_queue *_rx" array.
> If we are doing large rx queue allocation kcalloc() might
> fail, so this patch does a fallback to vzalloc().
> Similar implementation is done for tx queue allocation in
> netif_alloc_netdev_queues().

> We avoid failure of high order memory allocation
> with the help of vzalloc(), this allows us to do large
> rx and tx queue allocation which in turn helps us to
> increase the number of queues in tun.

> As vmalloc() adds overhead on a critical network path,
> __GFP_REPEAT flag is used with kzalloc() to do this fallback
> only when really needed.

> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: David Gibson <dgibson@redhat.com>
> ---
>   net/core/dev.c | 20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1c15b18..a455a02 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5942,17 +5942,24 @@ void netif_stacked_transfer_operstate(const struct net_device *rootdev,
>   EXPORT_SYMBOL(netif_stacked_transfer_operstate);
>
>   #ifdef CONFIG_SYSFS
> +static void netif_free_rx_queues(struct net_device *dev)
> +{
> +	kvfree(dev->_rx);
> +}
> +
>   static int netif_alloc_rx_queues(struct net_device *dev)
>   {
>   	unsigned int i, count = dev->num_rx_queues;
>   	struct netdev_rx_queue *rx;
> -
> +	size_t sz = count * sizeof(*rx);

   Please keep an empty line after declarations.

>   	BUG_ON(count < 1);
>

WBR, Sergei

