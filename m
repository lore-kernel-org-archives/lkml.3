Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaIOItP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:49:15 -0400
Received: from mx0.aculab.com ([213.249.233.131]:39181 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753434AbaIOItN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:49:13 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Marc Kleine-Budde'" <mkl@pengutronix.de>,
        "'Rickard Strandqvist'" <rickard_strandqvist@spectrumdigital.se>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: Oliver Hartkopp <socketcan@hartkopp.net>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Christopher R. Baker" <cbaker@rec.ri.cmu.edu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
Thread-Topic: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
Thread-Index: AQHP0EGesx6Ru+ZEc0K0ZqftXKP+D5wB3RxQ///zd4CAABEekA==
Date: Mon, 15 Sep 2014 08:47:18 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17491F83@AcuExch.aculab.com>
References: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <063D6719AE5E284EB5DD2968C1650D6D17491F2B@AcuExch.aculab.com>
 <5416A65D.6010500@pengutronix.de>
In-Reply-To: <5416A65D.6010500@pengutronix.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8F8nMRS013617

From: Marc Kleine-Budde [ 
> On 09/15/2014 10:28 AM, David Laight wrote:
> > From: Rickard Strandqvist
> > ...
> >> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> > ...
> >> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> >> b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> >> index 644e6ab..d4fe8ac 100644
> >> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> >> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> >> @@ -830,7 +830,7 @@ static void peak_usb_disconnect(struct usb_interface *intf)
> >>  		char name[IFNAMSIZ];
> >>
> >>  		dev->state &= ~PCAN_USB_STATE_CONNECTED;
> >> -		strncpy(name, netdev->name, IFNAMSIZ);
> >> +		strlcpy(name, netdev->name, IFNAMSIZ);
> >>
> >>  		unregister_netdev(netdev);
> >>  		free_candev(netdev);
> >
> > Or:
> > 	char name[sizeof netdev->name];
> > 	memcpy(name, netdev->name, sizeof netdev->name);
> 
> I would be "sizeof(foo)" in kernel coding style,
But not in mine :-)
sizeof is an operator, not a function, it's argument can be (type).

> but let's have a look at the original code:
> 
>                 struct net_device *netdev = dev->netdev;
>                 char name[IFNAMSIZ];
> 
>                 dev->state &= ~PCAN_USB_STATE_CONNECTED;
>                 strncpy(name, netdev->name, IFNAMSIZ);
> 
>                 unregister_netdev(netdev);
>                 free_candev(netdev);
> 
>                 kfree(dev->cmd_buf);
>                 dev->next_siblings = NULL;
>                 if (dev->adapter->dev_free)
>                         dev->adapter->dev_free(dev);
> 
>                 dev_info(&intf->dev, "%s removed\n", name);
> 
> I think it's save to use:
> 
>     dev_info(&intf->dev, "%s removed\n", netdev_name(dev->netdev));
> 
> instead of doing the str?cpy() in the first place. But why not use:
> 
>     netdev_info(dev->netdev, "removed\n");
> 
> Is the USB device information lost when using netdev_info()?

My guess is it avoids a 'use after free' - but I'm not going to
dig that far.

Another issue with blindly replacing strncpy() with strlcpy()
(which doesn't affect the above) is when copying status to userspace.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
