Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3LPKLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:11:04 -0500
Received: from mx0.aculab.com ([213.249.233.131]:50764 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753185Ab3LPKLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:11:01 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH 1/1] AX88179_178A: Add FLAG_HW_IPALIGN to determine whether reserving NET_IP_ALIGN bytes for an SKB.
Date: Mon, 16 Dec 2013 10:09:40 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7490@saturn3.aculab.com>
In-Reply-To: <52AEA3A8.2020906@asix.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] AX88179_178A: Add FLAG_HW_IPALIGN to determine whether reserving NET_IP_ALIGN bytes for an SKB.
Thread-Index: Ac76MPnw55YFiv9QQl2F9DoC+5/5dAAFTTIw
References: <1386926708-2343-1-git-send-email-freddy@asix.com.tw> <AE90C24D6B3A694183C094C60CF0A2F6026B748A@saturn3.aculab.com> <52AEA3A8.2020906@asix.com.tw>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Freddy Xin" <freddy@asix.com.tw>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <louis@asix.com.tw>,
        <allan@asix.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBGAB8MN024079

> From: Freddy Xin
> On 2013å¹´12æœˆ13æ—¥ 18:36, David Laight wrote:
> >> From: freddy@asix.com.tw
> > ...
> >> -	skb = __netdev_alloc_skb_ip_align(dev->net, size, flags);
> >> +	if (dev->driver_info->flags & FLAG_HW_IPALIGN)
> >> +		skb = __netdev_alloc_skb(dev->net, size, flags);
> >> +	else
> >> +		skb = __netdev_alloc_skb_ip_align(dev->net, size, flags);
> > Given the definition:
> > static inline struct sk_buff *__netdev_alloc_skb_ip_align(struct net_device *dev,
> >                  unsigned int length, gfp_t gfp)
> > {
> >          struct sk_buff *skb = __netdev_alloc_skb(dev, length + NET_IP_ALIGN, gfp);
> >
> >          if (NET_IP_ALIGN && skb)
> >                  skb_reserve(skb, NET_IP_ALIGN);
> >          return skb;
> > }
> >
> > It really ought to be possible to code that without an extra conditional.
> >
> > 	David
>
> The AX88179_178A driver do need to know the value of NET_IP_ALIGN
> to determine whether enabling the feature that makes IP header align
> on a dword-aligned address, but according to the comments from David
> Miller, I need to consider all situations, not just for the case that
> NET_IP_ALIGN is zero, so the condition added in rx_submit is just used to
> determine whether reserving NET_IP_ALIGN bytes for each SKB.

I was thinking of something like:

	skb = netdev_alloc_skb(dev, length + dev->skb_align, gfp);
	if (NET_IP_ALIGN && skb && !(ev->driver_flags & FLAG_HW_IPALIGN))
		skb_reserve(skb, NET_IP_ALIGN);

It might even be reasonable to remove the length adjustment - provided
that all the later code uses the skb length.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
