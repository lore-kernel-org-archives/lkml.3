Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaEWIxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:53:00 -0400
Received: from mx0.aculab.com ([213.249.233.131]:52768 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751621AbaEWIw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:52:57 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        Jim Baxter <jim_baxter@mentor.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "kamal@canonical.com" <kamal@canonical.com>,
        "Ben Hutchings" <bhutchings@solarflare.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>, "fw@strlen.de" <fw@strlen.de>
Subject: RE: skbuff truesize incorrect.
Thread-Topic: skbuff truesize incorrect.
Thread-Index: AQHPdgCCL2lnKeimqUeV55a8ET8tq5tN2VIA
Date: Fri, 23 May 2014 08:52:13 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1724C490@AcuExch.aculab.com>
References: <537E4AFD.20304@mentor.com>
 <1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4N8rAok000447

From: Eric Dumazet
> On Thu, 2014-05-22 at 20:07 +0100, Jim Baxter wrote:
> 
> >
> > I have been investigating a network issue with bursts of network traffic
> > over USB CDC-NCM, the issue is that the kernel is dropping packets
> > because sk_rcvqueues_full() returns true due to skb2->truesize is always
> > 32960 instead of SKB_TRUESIZE(skb2->len) which is about 1800.
> >
> > The code I am trying to fix is this code below, it is splitting a set of
> > multiple network packets compressed into a single 16k packet into
> > individual skb's and sending them up the network stack.
> 
> if skb are allocated with 16k = 16384 bytes, adding the struct
> skb_shared_info overhead and rounding up to power of two gives 32768
> bytes.
> 
> Chances to be able to allocate 32KB contiguous memory are slim after a
> while.
> 
> I would set rx_max (rx_urb_size) to SKB_MAX_HEAD(0) so that you do not
> use high order allocations.
> 
> What is the exact 'overhead' using ~4K instead of 16K exactly on this
> hardware ?

Many of the usb ethernet drivers have the same issue.

The hardware will put multiple ethernet frames into a single USB bulk data
message. To handle this the driver generates a URB that is (hopefully) long
enough for the longest USB message (typically 32k is assumed to be enough).
The URB that usb_net generated have the data in a linear skb - which then
has a large 'truesize'.

Since USB bulk data are terminated by a short fragment there is actually
no need for the URB be long enough for the full message. Provided the
URB are multiples of the USB message size (1k for USB 3) the message
can be received into multiple URB - the driver just has to be willing
to merge URB buffers (as well as split them) when generating the ethernet
frames.

What the driver needs to do us allocate URB with 2k (or 4k) buffers and
only allocate the skb when processing the receive data.
Unfortunately this is a major rework of usb_net.c

Note that some of the usb ethernet drivers allocate large skb then
lie about the truesize.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
