Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaCMKjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:39:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:65059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaCMKjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:39:05 -0400
X-IronPort-AV: E=Sophos;i="4.97,646,1389744000"; 
   d="scan'208";a="109511479"
Message-ID: <1394707143.25873.30.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next v7 8/9] xen-netback: Timeout packets in RX path
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Date: Thu, 13 Mar 2014 10:39:03 +0000
In-Reply-To: <1394142511-14827-9-git-send-email-zoltan.kiss@citrix.com>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
	 <1394142511-14827-9-git-send-email-zoltan.kiss@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 21:48 +0000, Zoltan Kiss wrote:
> @@ -557,12 +577,25 @@ void xenvif_disconnect(struct xenvif *vif)
>  void xenvif_free(struct xenvif *vif)
>  {
>  	int i, unmap_timeout = 0;
> +	/* Here we want to avoid timeout messages if an skb can be legitimatly

"legitimately"

> +	 * stucked somewhere else. Realisticly this could be an another vif's

"stuck" and "Realistically"

> +	 * internal or QDisc queue. That another vif also has this
> +	 * rx_drain_timeout_msecs timeout, but the timer only ditches the
> +	 * internal queue. After that, the QDisc queue can put in worst case
> +	 * XEN_NETIF_RX_RING_SIZE / MAX_SKB_FRAGS skbs into that another vif's
> +	 * internal queue, so we need several rounds of such timeouts until we
> +	 * can be sure that no another vif should have skb's from us. We are
> +	 * not sending more skb's, so newly stucked packets are not interesting

"stuck" again.

> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index 560950e..bb65c7c 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -63,6 +63,13 @@ module_param(separate_tx_rx_irq, bool, 0644);
>  static unsigned int fatal_skb_slots = FATAL_SKB_SLOTS_DEFAULT;
>  module_param(fatal_skb_slots, uint, 0444);
>  
> +/* When guest ring is filled up, qdisc queues the packets for us, but we have
> + * to timeout them, otherwise other guests' packets can get stucked there

"stuck"

Ian.

