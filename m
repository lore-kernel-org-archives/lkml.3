Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3JaTeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:34:05 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1259 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab3JaTeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:34:02 -0400
X-IronPort-AV: E=Sophos;i="4.93,611,1378857600"; 
   d="scan'208";a="66880405"
Message-ID: <5272B0A7.30104@citrix.com>
Date: Thu, 31 Oct 2013 19:33:59 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@citrix.com>, <ian.campbell@citrix.com>,
        <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next RFC 1/5] xen-netback: Introduce TX grant map
 definitions
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com> <1383094220-14775-2-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1383094220-14775-2-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/13 00:50, Zoltan Kiss wrote:
> +void xenvif_zerocopy_callback(struct ubuf_info *ubuf, bool zerocopy_success)
> +{
> +	unsigned long flags;
> +	pending_ring_idx_t index;
> +	u16 pending_idx = ubuf->desc;
> +	struct pending_tx_info *temp =
> +		container_of(ubuf, struct pending_tx_info, callback_struct);
> +	struct xenvif *vif =
> +		container_of(temp - pending_idx, struct xenvif,
> +			pending_tx_info[0]);
> +
> +	spin_lock_irqsave(&vif->dealloc_lock, flags);
> +	do {
> +		pending_idx = ubuf->desc;
> +		ubuf = (struct ubuf_info *) ubuf->ctx;
> +		index = pending_index(vif->dealloc_prod);
> +		vif->dealloc_ring[index] = pending_idx;
> +		/* Sync with xenvif_tx_action_dealloc:
> +		 * insert idx then incr producer.
> +		 */
> +		smp_wmb();
> +		vif->dealloc_prod++;
> +		napi_schedule(&vif->napi);
> +	} while (ubuf);
> +	spin_unlock_irqrestore(&vif->dealloc_lock, flags);
> +}

Another possible place for improvement is the placing of napi_schedule. 
Now it get called after every fragment, which is probably suboptimal. I 
think it's likely that the vif thread can't finish one dealloc faster 
than one iteration of this while loop.
Another idea is to place it after the while, so it get called only once, 
but in the meantime the thread doesn't have chance to start working on 
the deallocs.
A compromise might be to do it once in the first iteration of the loop, 
and then once after the loop to make sure the thread knows about the 
dealloc.
Thoughts?

Zoli
