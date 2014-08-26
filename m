Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253AbaHZJMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:12:03 -0400
Received: from mx0.aculab.com ([213.249.233.131]:59301 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934095AbaHZJMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:12:01 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Jonas Jensen <jonas.jensen@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mirqus@gmail.com" <mirqus@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH v6 2/4] net: moxa: replace build_skb() with
 netdev_alloc_skb_ip_align() / memcpy()
Thread-Topic: [PATCH v6 2/4] net: moxa: replace build_skb() with
 netdev_alloc_skb_ip_align() / memcpy()
Thread-Index: AQHPwQy8ZM6vzevD4E6oQ3XKEu4R5Jvil+hg
Date: Tue, 26 Aug 2014 09:10:19 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1748126F@AcuExch.aculab.com>
References: <1408544342-32058-1-git-send-email-jonas.jensen@gmail.com>
 <1408976542-15624-1-git-send-email-jonas.jensen@gmail.com>
 <4449672.aCJ5J5rv4r@wuerfel>
In-Reply-To: <4449672.aCJ5J5rv4r@wuerfel>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann
> On Monday 25 August 2014 16:22:22 Jonas Jensen wrote:
> > @@ -226,13 +226,15 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
> >                 if (len > RX_BUF_SIZE)
> >                         len = RX_BUF_SIZE;
> >
> > -               skb = build_skb(priv->rx_buf[rx_head], priv->rx_buf_size);
> > +               skb = netdev_alloc_skb_ip_align(ndev, len);
> > +
> >                 if (unlikely(!skb)) {
> > -                       net_dbg_ratelimited("build_skb failed\n");
> > +                       net_dbg_ratelimited("netdev_alloc_skb_ip_align failed\n");
> >                         priv->stats.rx_dropped++;
> >                         priv->stats.rx_errors++;
> >                 }
> >
> > +               memcpy(skb->data, priv->rx_buf[rx_head], len);

Is this memcpy() aligned?
If the hardware can receive to a 4n+2 offset it is probably better to
copy the two bytes before the frame data and to round the length of to
a whole number of words.

> >                 skb_put(skb, len);
> >                 skb->protocol = eth_type_trans(skb, ndev);
> >                 napi_gro_receive(&priv->napi, skb);
> 
> While this seems correct, I wonder why you don't do the normal approach of
> dequeuing the skb from the chain and adding a newly allocated skb to it to
> save the memcpy.

Because the receive buffer area isn't made of skbs.
Post-allocating the skb also reduces the 'true size' of the skb.

	David



