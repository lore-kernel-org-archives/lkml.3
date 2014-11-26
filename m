Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaKZMvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:51:05 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:37128 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKZMvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:51:03 -0500
Date: Wed, 26 Nov 2014 13:50:53 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 21/42] virtio_net: get rid of
 virtio_net_hdr/skb_vnet_hdr
Message-ID: <20141126135053.1bf4f97c.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-22-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-22-git-send-email-mst@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112612-0013-0000-0000-000001FEF751
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:42:53 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio 1.0 doesn't use virtio_net_hdr anymore, and in fact, it's not
> really useful since virtio_net_hdr_mrg_rxbuf includes that as the first
> field anyway.
> 
> Let's drop it, precalculate header len and store within vi instead.
> 
> This way we can also remove struct skb_vnet_hdr.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 90 ++++++++++++++++++++++--------------------------
>  1 file changed, 41 insertions(+), 49 deletions(-)
> 

> @@ -260,13 +256,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> 
>  	hdr = skb_vnet_hdr(skb);
> 
> -	if (vi->mergeable_rx_bufs) {
> -		hdr_len = sizeof hdr->mhdr;
> -		hdr_padded_len = sizeof hdr->mhdr;
> -	} else {
> -		hdr_len = sizeof hdr->hdr;
> +	hdr_len = vi->hdr_len;
> +	if (vi->mergeable_rx_bufs)
> +		hdr_padded_len = sizeof *hdr;

sizeof without () looks weird to me.

> +	else
>  		hdr_padded_len = sizeof(struct padded_vnet_hdr);
> -	}
> 
>  	memcpy(hdr, p, hdr_len);
> 

Otherwise:

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

