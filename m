Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaLSRgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:36:49 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:65524 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaLSRgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:36:47 -0500
Message-ID: <1419010603.9773.84.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] r8152: drop the tx packet with invalid length
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>, Tom Herbert <therbert@google.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Fri, 19 Dec 2014 09:36:43 -0800
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ED585A@RTITMBSV03.realtek.com.tw>
References: <1417020748.29427.59.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141126.120658.498602780456343676.davem@davemloft.net>
	 <1417027459.29427.63.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141126.153356.461494573591656082.davem@davemloft.net>
	 <0835B3720019904CB8F7AA43166CEEB2ED585A@RTITMBSV03.realtek.com.tw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-19 at 06:42 +0000, Hayes Wang wrote:

> Excuse me. I try to implement ndo_gso_check() with kernel 3.18.
> However, I still get packets with gso and their skb lengths are more
> than the acceptable one. Do I miss something?
> 
> +static bool rtl8152_gso_check(struct sk_buff *skb, struct net_device *dev)
> +{
> +	if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
> +		return false;
> +
> +	return true;
> +}
>  
> @@ -5861,6 +5876,9 @@ static const struct net_device_ops rtl8152_netdev_ops = {
>  	.ndo_set_mac_address	= rtl8152_set_mac_address,
>  	.ndo_change_mtu		= rtl8152_change_mtu,
>  	.ndo_validate_addr	= eth_validate_addr,
> +	.ndo_gso_check		= rtl8152_gso_check,
>  };

You are right, it seems ndo_gso_check() is buggy at this moment.

Presumably this method should alter %features so that we really segment
the packets in software.

features &= ~NETIF_F_GSO_MASK;



