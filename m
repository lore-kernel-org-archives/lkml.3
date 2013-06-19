Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3FSQQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:16:11 -0400
Received: from mx0.aculab.com ([213.249.233.131]:47204 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757027Ab3FSQQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:16:07 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [net-next rfc 1/3] net: avoid high order memory allocation for queues by using flex array
Date: Wed, 19 Jun 2013 17:06:21 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B729A@saturn3.aculab.com>
In-Reply-To: <1371657511.3252.324.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [net-next rfc 1/3] net: avoid high order memory allocation for queues by using flex array
Thread-Index: Ac5tBfVZiH0s9G20S5yuVzIkWG5SaAAAKniA
References: <1371620452-49349-1-git-send-email-jasowang@redhat.com> <1371620452-49349-2-git-send-email-jasowang@redhat.com> <1371623518.3252.267.camel@edumazet-glaptop> <20130619091132.GA2816@redhat.com> <1371635763.3252.289.camel@edumazet-glaptop> <20130619154059.GA13735@redhat.com> <1371657511.3252.324.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Jason Wang" <jasowang@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <hkchu@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5JGGJLh010303

> +static void netif_free_tx_queues(struct net_device *dev)
> +{
> +	if (is_vmalloc_addr(dev->_tx))
> +		vfree(dev->_tx);
> +	else
> +		kfree(dev->_tx);
> +}
> +
>  static int netif_alloc_netdev_queues(struct net_device *dev)
>  {
>  	unsigned int count = dev->num_tx_queues;
> @@ -5261,9 +5270,11 @@ static int netif_alloc_netdev_queues(struct net_device *dev)
>  	BUG_ON(count < 1);
> 
>  	tx = kcalloc(count, sizeof(struct netdev_queue), GFP_KERNEL);
> -	if (!tx)
> -		return -ENOMEM;
> -
> +	if (!tx) {
> +		tx = vzalloc(count * sizeof(struct netdev_queue));
> +		if (!tx)
> +			return -ENOMEM;
> +	}
>  	dev->_tx = tx;

Given the number of places I've seen this code added, why
not put it in a general helper?

I also thought that malloc() with GFP_KERNEL would sleep.
Under what conditions does it fail instead?

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
