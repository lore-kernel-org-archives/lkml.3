Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbaGRPYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:24:54 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:65230 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761928AbaGRPYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:24:51 -0400
X-IronPort-AV: E=Sophos;i="5.01,685,1400025600"; 
   d="scan'208";a="154127367"
Date: Fri, 18 Jul 2014 16:24:49 +0100
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net 2/4] xen-netback: Fix releasing frag_list skbs in
 error path
Message-ID: <20140718152449.GO7142@zion.uk.xensource.com>
References: <1405624192-21722-1-git-send-email-zoltan.kiss@citrix.com>
 <1405624192-21722-3-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405624192-21722-3-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 08:09:50PM +0100, Zoltan Kiss wrote:
> When the grant operations failed, the skb is freed up eventually, and it tries
> to release the frags, if there is any. For the main skb nr_frags is set to 0 to
> avoid this, but on the frag_list it iterates through the frags array, and tries
> to call put_page on the page pointer which contains garbage at that time.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Reported-by: Armin Zentai <armin.zentai@ezit.hu>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org
> ---
> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index 604ff71..e9ffb05 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -1522,6 +1522,11 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
>  		/* Check the remap error code. */
>  		if (unlikely(xenvif_tx_check_gop(queue, skb, &gop_map, &gop_copy))) {

It's worth adding a comment here saying that all those pages have been
freed in xenvif_tx_check_gop so that we don't leak any page even if we
manually set nr_frags to 0.

Wei.

>  			skb_shinfo(skb)->nr_frags = 0;
> +			if (skb_has_frag_list(skb)) {
> +				struct sk_buff *nskb =
> +						skb_shinfo(skb)->frag_list;
> +				skb_shinfo(nskb)->nr_frags = 0;
> +			}
>  			kfree_skb(skb);
>  			continue;
>  		}
