Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3KSOog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:44:36 -0500
Received: from mx0.aculab.com ([213.249.233.131]:47280 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752921Ab3KSOod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:44:33 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: net/usb/ax88179_178a driver broken in linux-3.12
Date: Tue, 19 Nov 2013 14:43:42 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7434@saturn3.aculab.com>
In-Reply-To: <1384870550.8604.101.camel@edumazet-glaptop2.roam.corp.google.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: net/usb/ax88179_178a driver broken in linux-3.12
Thread-Index: Ac7lMcORDCkSwVImS2ytAEEsbrPalQAAmQMA
References: <52890C7E.6000607@pobox.com> <52891178.2080509@pobox.com> <52891341.4020403@pobox.com> <AE90C24D6B3A694183C094C60CF0A2F6026B742B@saturn3.aculab.com> <AE90C24D6B3A694183C094C60CF0A2F6026B742F@saturn3.aculab.com> <528A9A36.50903@pobox.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7431@saturn3.aculab.com> <528B6F73.7040801@pobox.com> <1384870550.8604.101.camel@edumazet-glaptop2.roam.corp.google.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>, "Mark Lord" <mlord@pobox.com>
Cc: "Ming Lei" <ming.lei@canonical.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAJEifDI002917

> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> On Tue, 2013-11-19 at 09:02 -0500, Mark Lord wrote:
> > On 13-11-19 05:04 AM, David Laight wrote:
> > >> From: Mark Lord
> > ..
> > >> except the ax88179_178a driver still does not work in linux-3.12,
> > >> whereas it works fine in all earlier kernels.

I've seen lost packets in IIRC 3.2

> > >> That's a regression.
> > >> And a simple revert (earlier in this thread) fixes it.
> > >> So.. let's revert it for now, until a proper xhci compatible patch is produced.
> > ...
> > > There is a patch to xhci-ring.c that should fix the SG problem.
> > > http://www.spinics.net/lists/linux-usb/msg97176.html
> > >
> > > I think it should apply to the 3.12 sources.
> >
> > I am running with that patch here now (thanks),
> > and it too appears to prevent the lockups.
> >
> > But is this patch upstream already?
> > If yes, then it needs to get pushed out to -stable for 3.12 at least.

Having someone else confirm that there is a bug, and that the
patch fixes it should help it get pushed to -stable.

> > If not upstream, then the revert is probably safest for -stable,
> > rather than new code that has never been upstream before.
> >
> 
> > Both patches are attached to this email.
> > One or the other is required for the USB 3.0 network adapters to function in 3.12.
> 
> I do not see any error in commit f27070158d6754765f2
> ("ax88179_178a: avoid copy of tx tcp packets")
> 
> Quite the contrary in fact...
> 
> I suspect a TSO bug, and would rather disable TSO for this nic.
> 
> Have you tried to revert 3804fad45411b482
> ("USBNET: ax88179_178a: enable tso if usb host supports sg dma")

It isn't directly a TSO problem.
There has always been a bug in the xhci driver for fragmented buffers.
TSO just means it is given a lot of fragmented buffers.

As well as user-supplied fragmented buffers, the bug affects
internal fragmentation that happens whenever a buffer crosses a 64k
byte boundary (please hw engineers - stop doing this!)

I'm not sure whether usbnet would ever pass buffers that cross 64k
boundaries. I've not seen one - even with TSO. But the rx buffers
are 20k (doesn't seem ideal!) and could also be problematical.

USB mass storage has used SG for ages, the buffers must all be
adequately aligned for the hardware - they won't meet the constraint
for USB3 itself, but the documented restriction may be more severe
than the actual one.

	David



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
