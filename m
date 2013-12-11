Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab3LKKeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:34:23 -0500
Received: from mx0.aculab.com ([213.249.233.131]:54544 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751116Ab3LKKeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:34:21 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH 1/1] AX88179_178A: Enable the hardware pseudo header in case of the NET_IP_ALIGN equals 0
Date: Wed, 11 Dec 2013 10:33:18 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B747B@saturn3.aculab.com>
In-Reply-To: <52A80397.2080508@asix.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] AX88179_178A: Enable the hardware pseudo header in case of the NET_IP_ALIGN equals 0
Thread-Index: Ac72OV02JKGgSD57Rm6h/VeDYElpcwAIc3Pw
References: <1386323898-2246-1-git-send-email-freddy@asix.com.tw> <20131209.200131.1376169274733452706.davem@davemloft.net> <52A80397.2080508@asix.com.tw>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Freddy Xin" <freddy@asix.com.tw>, "David Miller" <davem@davemloft.net>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <louis@asix.com.tw>, <allan@asix.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBBAYXVL024013

> From: Freddy Xin
> On 2013å¹´12æœˆ10æ—¥ 09:01, David Miller wrote:
> > From: freddy@asix.com.tw
> > Date: Fri,  6 Dec 2013 17:58:18 +0800
> >
> >> From: Freddy Xin <freddy@asix.com.tw>
> >>
> >> The AX88179_178A has a hardware feature that it can insert a 2-bytes pseudo
> >> header in front of each received frame by setting the AX_RX_CTL_IPE bit.
> >> This feature is used to let the IP header be aligned on a doubleword-aligned address,
> >> but the NET_IP_ALIGN may equals to 2 and the __netdev_alloc_skb_ip_align in USBNET will
> >> reserve 2 bytes also, so in this case the driver shouldn't enable this bit.
> >>
> >> This patch modifies the driver to set AX_RX_CTL_IPE just in case of the NET_IP_ALIGN equals 0.
> >>
> >> Signed-off-by: Freddy Xin <freddy@asix.com.tw>
> > Please avoid larger than 80 column lines in your commit messages,
> > people use text-only tools to viee these.
> >
> > Next, it makes no sense to restrict your change to NET_IP_ALIGN==0
> >
> > Simply handle any case, by undoing the reservation if it's getting
> > in the way.  If there isn't an appropriate helper for this, add one.
> >
> I think there is no way of undoing the reservation in the driver.
> Can I add a flag of the driver_info, and use it to determine
> whether undoing the reservation in rx_submit of usbnet?

You probably want to arrange to have save the appropriate offset in
one of the structures - so avoiding any conditionals during the allocate.

I've noticed that the RX URB are 20k bytes long.
Allocating that much physically and virtually contiguous memory for
every rx frame seems sub-optimal to say the least!
What does the skb's 'realsize' end up as?
I don't remember seeing a copy for short frames either.

ISTR there is code to debatch multiple ethernet frames from a single
URB. I think that means that an ethernet frame might end up in two URB.
I'm not sure there is code to handle that either - but I've not looked
that closely at that part of the code.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
