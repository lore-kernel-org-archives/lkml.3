Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3KSQ2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:28:30 -0500
Received: from mx0.aculab.com ([213.249.233.131]:49597 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752947Ab3KSQ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:28:29 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: net/usb/ax88179_178a driver broken in linux-3.12
Date: Tue, 19 Nov 2013 16:26:57 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7435@saturn3.aculab.com>
In-Reply-To: <1384877400.8604.107.camel@edumazet-glaptop2.roam.corp.google.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: net/usb/ax88179_178a driver broken in linux-3.12
Thread-Index: Ac7lQbqUiJag01MvS56MpcAf1tGRxwAAKBhg
References: <52890C7E.6000607@pobox.com> <52891178.2080509@pobox.com> <52891341.4020403@pobox.com> <AE90C24D6B3A694183C094C60CF0A2F6026B742B@saturn3.aculab.com> <AE90C24D6B3A694183C094C60CF0A2F6026B742F@saturn3.aculab.com> <528A9A36.50903@pobox.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7431@saturn3.aculab.com> <528B6F73.7040801@pobox.com> <1384870550.8604.101.camel@edumazet-glaptop2.roam.corp.google.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7434@saturn3.aculab.com> <1384877400.8604.107.camel@edumazet-glaptop2.roam.corp.google.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Mark Lord" <mlord@pobox.com>, "Ming Lei" <ming.lei@canonical.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAJGSaPo003546

> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> On Tue, 2013-11-19 at 14:43 +0000, David Laight wrote:
> 
> > It isn't directly a TSO problem.
> > There has always been a bug in the xhci driver for fragmented buffers.
> > TSO just means it is given a lot of fragmented buffers.
> >
> > As well as user-supplied fragmented buffers, the bug affects
> > internal fragmentation that happens whenever a buffer crosses a 64k
> > byte boundary (please hw engineers - stop doing this!)
> 
> TCP stack uses order-3 allocations.
> 
> This means 32KB for x86 (PAGE_SIZE=4096)
> 
> What is PAGE_SIZE for your arches ?
> 
> If there is a 6KB limit, we might adapt TCP to make sure we do not cross
> a 64KB boundary.
> 
> Other strategy would be to detect this case in the driver and split a
> problematic segment into two parts.

The xhci code does all the checks for buffer fragments crossing 64k boundaries.
I've posted a patch that uses a conservative upper limit for the
number of fragments: 2 * number_of_sg_buffs + xfer_len/65536.
This saves scanning the sg list twice.

For those not reading linux-usb:

The xhci 'bug' is that an SG list may only cross the end of a ring
segment at an aligned length.
For USB2 devices this will be 512 bytes. For USB3 the documented alignment
could be 16k (depends on a burst size), but might only be 1k.
(This is another place where the hw engineers haven't made life easy.)
The only simple solution is to ensure that a SG list doesn't cross
the end of a ring segment.

	David


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
