Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaLSGm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 01:42:28 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:56655 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaLSGm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 01:42:26 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID sBJ6gEvS006169, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net] r8152: drop the tx packet with invalid length
Thread-Topic: [PATCH net] r8152: drop the tx packet with invalid length
Thread-Index: AQHQCV9ExQJeo8eXJ0uzTHR36OfvLZxymd4AgAAEDQCAABszgIAAHqAAgCO8/BA=
Date: Fri, 19 Dec 2014 06:42:14 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ED585A@RTITMBSV03.realtek.com.tw>
References: <1417020748.29427.59.camel@edumazet-glaptop2.roam.corp.google.com>
	<20141126.120658.498602780456343676.davem@davemloft.net>
	<1417027459.29427.63.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141126.153356.461494573591656082.davem@davemloft.net>
In-Reply-To: <20141126.153356.461494573591656082.davem@davemloft.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Miller [mailto:davem@davemloft.net] 
> Sent: Thursday, November 27, 2014 4:34 AM
[...]
> >> > Looks like a candidate for ndo_gso_check(), so that we do not drop, but
> >> > instead segment from netif_needs_gso()/validate_xmit_skb()
> >> 
> >> You mean have the bridge implement the ndo_gso_check() method right?
> > 
> > No, I meant this particular driver.
> > 
> > Note that netif_skb_features() does only this check :
> > 
> > if (gso_segs > dev->gso_max_segs || gso_segs < dev->gso_min_segs)
> >       features &= ~NETIF_F_GSO_MASK;
> > 
> > Ie not testing gso_max_size
> > 
> > It looks like all these particular tests should be moved on
> > ndo_gso_check(), to remove code from netif_skb_features()
> 
> A check against gso_max_size is generic enough that it ought to be put
> right into netif_needs_gso() rather then duplicating it into every
> driver's ndo_gso_check() method don't you think?

Excuse me. I try to implement ndo_gso_check() with kernel 3.18.
However, I still get packets with gso and their skb lengths are more
than the acceptable one. Do I miss something?

+static bool rtl8152_gso_check(struct sk_buff *skb, struct net_device *dev)
+{
+	if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
+		return false;
+
+	return true;
+}
 
@@ -5861,6 +5876,9 @@ static const struct net_device_ops rtl8152_netdev_ops = {
 	.ndo_set_mac_address	= rtl8152_set_mac_address,
 	.ndo_change_mtu		= rtl8152_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_gso_check		= rtl8152_gso_check,
 };

Best Regards,
Hayes
