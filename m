Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3FGNbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:31:43 -0400
Received: from mx0.aculab.com ([213.249.233.131]:34552 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752395Ab3FGNbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:31:42 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: Scaling problem with a lot of AF_PACKET sockets on different interfaces
Date: Fri, 7 Jun 2013 14:30:52 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B727B@saturn3.aculab.com>
In-Reply-To: <1370608871.5854.64.camel@marge.simpson.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Scaling problem with a lot of AF_PACKET sockets on different interfaces
Thread-Index: Ac5jfkflcGNXHlCzRm65e8ayAyU6ZgAAt55w
References: <51B1CA50.30702@telenet.dn.ua> <1370608871.5854.64.camel@marge.simpson.net>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Mike Galbraith" <bitbucket@online.de>,
        "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: <linux-kernel@vger.kernel.org>, "netdev" <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r57DVmAP020481

> > I have a Linux router with a lot of interfaces (hundreds or
> > thousands of VLANs) and an application that creates AF_PACKET
> > socket per interface and bind()s sockets to interfaces.
...
> > I noticed that box has strange performance problems with
> > most of the CPU time spent in __netif_receive_skb:
> >   86.15%  [k] __netif_receive_skb
> >    1.41%  [k] _raw_spin_lock
> >    1.09%  [k] fib_table_lookup
> >    0.99%  [k] local_bh_enable_ip
...
> > This corresponds to:
> >
> > net/core/dev.c:
> >          type = skb->protocol;
> >          list_for_each_entry_rcu(ptype,
> >                          &ptype_base[ntohs(type) & PTYPE_HASH_MASK], list) {
> >                  if (ptype->type == type &&
> >                      (ptype->dev == null_or_dev || ptype->dev == skb->dev ||
> >                       ptype->dev == orig_dev)) {
> >                          if (pt_prev)
> >                                  ret = deliver_skb(skb, pt_prev, orig_dev);
> >                          pt_prev = ptype;
> >                  }
> >          }
> >
> > Which works perfectly OK until there are a lot of AF_PACKET sockets, since
> > the socket adds a protocol to ptype list:

Presumably the 'ethertype' is the same for all the sockets?
(And probably the '& PTYPE_HASH_MASH' doesn't separate it from 0800
or 0806 (IIRC IP and ICMP))

How often is that deliver_skb() inside the loop called?
If the code could be arranged so that the scan loop didn't contain
a function call then the loop code would be a lot faster since
the compiler can cache values in registers.
While that woukd speed the code up somewhat, there would still be a
significant cost to iterate 1000+ times.

Looks like the ptype_base[] should be per 'dev'?
Or just put entries where ptype->dev != null_or_dev on a per-interface
list and do two searches?

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
