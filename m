Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbaBFP3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:29:14 -0500
Received: from mx0.aculab.com ([213.249.233.131]:58336 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755123AbaBFP3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:29:07 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Igor Gnatenko'" <i.gnatenko.brain@gmail.com>,
        Emil Goode <emilgoode@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Ming Lei <ming.lei@canonical.com>,
        Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: asix: fix bad header length bug
Thread-Topic: [PATCH] net: asix: fix bad header length bug
Thread-Index: AQHPIz4f9jIHqyBVlkS9F+g2/ALCs5qoWHGA
Date: Thu, 6 Feb 2014 15:28:13 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6B99F7@AcuExch.aculab.com>
References: <1391691384-8486-1-git-send-email-emilgoode@gmail.com>
 <1391692768.2843.4.camel@X1Carbon.localdomain>
In-Reply-To: <1391692768.2843.4.camel@X1Carbon.localdomain>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s16FTNKL006086

From: Igor Gnatenko
> On Thu, 2014-02-06 at 13:56 +0100, Emil Goode wrote:
> > The AX88772B occasionally send rx packets that cross urb boundaries
> > and the remaining partial packet is sent with no header.
> > When the buffer with a partial packet is of less number of octets
> > than the value of hard_header_len the buffer is discarded by the
> > usbnet module. This is causing dropped packages and error messages
> > in dmesg.
> >
> > This can be reproduced by using ping with a packet size
> > between 1965-1976.
> >
> > The bug has been reported here:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=29082
> >
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> Reported-and-tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> > ---
> >  drivers/net/usb/asix_devices.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> > index 9765a7d..120bb29 100644
> > --- a/drivers/net/usb/asix_devices.c
> > +++ b/drivers/net/usb/asix_devices.c
> > @@ -455,6 +455,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
> >  	dev->net->ethtool_ops = &ax88772_ethtool_ops;
> >  	dev->net->needed_headroom = 4; /* cf asix_tx_fixup() */
> >  	dev->net->needed_tailroom = 4; /* cf asix_tx_fixup() */
> > +	dev->net->hard_header_len = 0; /* Partial packets have no header */

That is the wrong place for the fix.

It should only be done when rx_urb_size is set to a multiple of the usb
packet size.
That is only done for some of the supported devices.

In fact, if the rx_urb_size is a multiple of the usb frame size (or 1k)
then maybe the usbnet code should assume that the driver is capable
of processing ethernet frames that cross usb packet boundaries and
not delete short packets at all - regardless of the hard_header_len.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
