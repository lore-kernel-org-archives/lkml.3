Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaIKMty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:49:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbaIKMsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:48:51 -0400
Message-ID: <54119A1C.4020501@redhat.com>
Date: Thu, 11 Sep 2014 08:48:28 -0400
From: Vlad Yasevich <vyasevic@redhat.com>
Reply-To: vyasevic@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
CC: akpm@linux-foundation.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.2 105/131] net: Correctly set segment mac_len in skb_segment().
References: <lsq.1410438733.15448606@decadent.org.uk>
In-Reply-To: <lsq.1410438733.15448606@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:32 AM, Ben Hutchings wrote:
> 3.2.63-rc1 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Vlad Yasevich <vyasevic@redhat.com>
> 
> [ Upstream commit fcdfe3a7fa4cb74391d42b6a26dc07c20dab1d82 ]
> 
> When performing segmentation, the mac_len value is copied right
> out of the original skb.  However, this value is not always set correctly
> (like when the packet is VLAN-tagged) and we'll end up copying a bad
> value.
> 
> One way to demonstrate this is to configure a VM which tags
> packets internally and turn off VLAN acceleration on the forwarding
> bridge port.  The packets show up corrupt like this:
> 16:18:24.985548 52:54:00:ab:be:25 > 52:54:00:26:ce:a3, ethertype 802.1Q
> (0x8100), length 1518: vlan 100, p 0, ethertype 0x05e0,
>         0x0000:  8cdb 1c7c 8cdb 0064 4006 b59d 0a00 6402 ...|...d@.....d.
>         0x0010:  0a00 6401 9e0d b441 0a5e 64ec 0330 14fa ..d....A.^d..0..
>         0x0020:  29e3 01c9 f871 0000 0101 080a 000a e833)....q.........3
>         0x0030:  000f 8c75 6e65 7470 6572 6600 6e65 7470 ...unetperf.netp
>         0x0040:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.netp
>         0x0050:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.netp
>         0x0060:  6572 6600 6e65 7470 6572 6600 6e65 7470 erf.netperf.netp
>         ...
> 
> This also leads to awful throughput as GSO packets are dropped and
> cause retransmissions.
> 
> The solution is to set the mac_len using the values already available
> in then new skb.  We've already adjusted all of the header offset, so we
> might as well correctly figure out the mac_len using skb_reset_mac_len().
> After this change, packets are segmented correctly and performance
> is restored.
> 
> CC: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7121d9b..0ccfb53 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2669,7 +2669,6 @@ struct sk_buff *skb_segment(struct sk_buff *skb, u32 features)
>  		tail = nskb;
>  
>  		__copy_skb_header(nskb, skb);
> -		nskb->mac_len = skb->mac_len;
>  
>  		/* nskb and skb might have different headroom */
>  		if (nskb->ip_summed == CHECKSUM_PARTIAL)
> @@ -2679,6 +2678,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, u32 features)
>  		skb_set_network_header(nskb, skb->mac_len);
>  		nskb->transport_header = (nskb->network_header +
>  					  skb_network_header_len(skb));
> +		skb_reset_mac_len(nskb);

This will not fix the problem here because the network header above will
already be set incorrectly based on the old mac_len.

This patch depends on
commit 030737bcc3c404e273e97dbe06fe9561699a411b
Author: Eric Dumazet <edumazet@google.com>
Date:   Sat Oct 19 11:42:54 2013 -0700

    net: generalize skb_segment()

that correctly populates the header offsets in the new segment.

-vlad

>  		skb_copy_from_linear_data(skb, nskb->data, doffset);
>  
>  		if (fskb != skb_shinfo(skb)->frag_list)
> 

