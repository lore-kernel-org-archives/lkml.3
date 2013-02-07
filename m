Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab3BGDUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:20:45 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:61572 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab3BGDUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:20:42 -0500
Message-ID: <1360207237.28557.48.camel@edumazet-glaptop>
Subject: Re: [PATCH 2/2] qlcnic: set gso_type
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, Eilon Greenstein <eilong@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, linux-driver@qlogic.com,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, bhutchings@solarflare.com
Date: Wed, 06 Feb 2013 19:20:37 -0800
In-Reply-To: <f262d9330d22447ed8fd487ad7b28d668efbf333.1360191528.git.mst@redhat.com>
References: <cover.1360191528.git.mst@redhat.com>
	 <f262d9330d22447ed8fd487ad7b28d668efbf333.1360191528.git.mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 01:02 +0200, Michael S. Tsirkin wrote:
> qlcnic set gso_size but not gso type. This leads to crashes
> in macvtap.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> This one I only compiled - don't have qlogic hardware.
> 
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> index bb4311e..370049c 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> @@ -1043,8 +1043,13 @@ qlcnic_process_lro(struct qlcnic_adapter *adapter,
>  	th->seq = htonl(seq_number);
>  	length = skb->len;
>  
> -	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP)
> +	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP) {
>  		skb_shinfo(skb)->gso_size = qlcnic_get_lro_sts_mss(sts_data1);
> +		if (skb->protocol == ETH_P_IPV6)

Are you sure its not skb->protocol == htons(ETH_P_IPV6) ?

> +			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
> +		else
> +			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
> +	}
>  
>  	if (vid != 0xffff)
>  		__vlan_hwaccel_put_tag(skb, vid);


