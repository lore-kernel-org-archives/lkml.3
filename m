Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaCDQ6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:58:53 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38399 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaCDQ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:58:51 -0500
Message-ID: <1393952328.26794.123.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next 09/12] r8152: support IPv6
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Tue, 04 Mar 2014 08:58:48 -0800
In-Reply-To: <1393934464-23675-10-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	 <1393934464-23675-10-git-send-email-hayeswang@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 20:01 +0800, Hayes Wang wrote:
> Support hw IPv6 checksum for TCP and UDP packets.


> +/*
> + * r8152_csum_workaround()
> + * The hw limites the value the transport offset. When the offset is out of the
> + * range, calculate the checksum by sw.
> + */
> +static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
> +				  struct sk_buff_head *list)
> +{
> +	if (skb_shinfo(skb)->gso_size) {
> +		netdev_features_t features = tp->netdev->features;
> +		struct sk_buff *segs, *nskb;
> +
> +		features &= ~(NETIF_F_IP_CSUM | NETIF_F_SG | NETIF_F_TSO);
> +		segs = skb_gso_segment(skb, features);
> +		if (IS_ERR(segs) || !segs)
> +			goto drop;
> +
> +		do {
> +			nskb = segs;
> +			segs = segs->next;
> +			nskb->next = NULL;
> +			__skb_queue_head(list, nskb);

This introduces TCP reordering.

You should use some kind of skb_queue_splice()



