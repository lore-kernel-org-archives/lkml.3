Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaAFKhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:37:05 -0500
Received: from mx0.aculab.com ([213.249.233.131]:49360 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751395AbaAFKhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:37:02 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'walt'" <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mark Lord <mlord@pobox.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Thread-Topic: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Thread-Index: AQHPBmhf5d97FnYUxUSD3GhphkgfRJpx0RcAgAFWX4CABF08EA==
Date: Mon, 6 Jan 2014 10:35:26 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D29D4F9@AcuExch.aculab.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com>
In-Reply-To: <52C6D9F1.9000709@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s06AbEUj032058

> From: walt
...
>         /* Accept arbitrarily long scatter-gather lists */
> -       hcd->self.sg_tablesize = ~0;
> +       hcd->self.sg_tablesize = 31;

Even if that reduces the number of fragments passed to the xhci driver
it may not be enough to limit the actual number of fragments that
need to be placed in the ring itself.
The xhci driver has to split every fragment on any 64k address boundary.

One possibility is to scan long SG lists to see it they are actually
problematic. If all the fragments are suitably aligned let them through
(without any nops).

My gut feeling is that problems only arise when the ring end isn't at
a 1k boundary in the data.

So provided all the fragments are multiples of 1k (after splitting on 64k
boundaries) the transfer will be processed correctly.
Alternatively, if the fragments are all longer than 1k (after the 64k split),
the one that crosses the ring end can be split in two.

A quick 'fix' would be to assume that anything with too many fragments is
probably ok - maybe check the first fragment is suitably aligned.
That would recover the old behaviour for usb disk transfers with a lot
of fragments - yes it is a hack...

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
