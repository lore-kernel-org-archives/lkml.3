Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaKLJuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:50:03 -0500
Received: from smtp.eu2.fugro.com ([46.34.88.152]:50222 "EHLO
	smtp.eu2.fugro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaKLJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:49:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuAHACUsY1QKCmUW/2dsb2JhbABchDuDBtB3AhyBFwEBAQEBAXyEAgEBAQEDIwQJBEUMBAIBCA0EBAEBAQICBgYFEgECAgIBAR0nCQgBAQQBEgi/YJZKAQEBAQEBAQEBAQEBAQEBAQEBAQEBF4EtjBmDHTEHBgSCbTaBHgWFIgONFQOTWUGEYYwWgUdsgksBAQE
X-IPAS-Result: AuAHACUsY1QKCmUW/2dsb2JhbABchDuDBtB3AhyBFwEBAQEBAXyEAgEBAQEDIwQJBEUMBAIBCA0EBAEBAQICBgYFEgECAgIBAR0nCQgBAQQBEgi/YJZKAQEBAQEBAQEBAQEBAQEBAQEBAQEBF4EtjBmDHTEHBgSCbTaBHgWFIgONFQOTWUGEYYwWgUdsgksBAQE
X-IronPort-AV: E=Sophos;i="5.07,367,1413244800"; 
   d="scan'208";a="20552457"
X-IRP-Internal: 1
X-IRP-FugroSender: 200661
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: "asix: Don't reset PHY on if_up for ASIX 88772" breaks net on arndale platform
Date: Wed, 12 Nov 2014 10:49:36 +0100
Message-ID: <C89EFD3CD56F64468D3D206D683A8D2203A003FE@ldam-msx2.fugro-nl.local>
In-Reply-To: <1415751802.3398.107.camel@decadent.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: "asix: Don't reset PHY on if_up for ASIX 88772" breaks net on arndale platform
Thread-Index: Ac/+DuePpetd3trPToiCSXLHCtBKqQAS/igA
References: <20141104072236.GA559@afflict.kos.to> <C89EFD3CD56F64468D3D206D683A8D2203985F49@ldam-msx2.fugro-nl.local> <20141104094336.GA3145@afflict.kos.to> <C89EFD3CD56F64468D3D206D683A8D2203985FA9@ldam-msx2.fugro-nl.local> <20141104200914.GN23178@opensource.wolfsonmicro.com> <1415751802.3398.107.camel@decadent.org.uk>
From: "Stam, Michel [FINT]" <M.Stam@fugro.nl>
To: "Ben Hutchings" <ben@decadent.org.uk>,
        "Charles Keepax" <ckeepax@opensource.wolfsonmicro.com>
Cc: "Riku Voipio" <riku.voipio@iki.fi>, <davem@davemloft.net>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAC9oDt5016208

Hello Ben,

Regarding the code snippet;

Good question, The original code didn't do this either, which is why I left it as it is. It could cause undesirable behaviour, agreed.

After a quick driver examination: I do see that asix_set_sw_mii and asix_set_hw_mii are called prior to the actual write (asix_mdio_write), it may be that this takes care of ensuring data is written to the chip, as asix_write_cmd waits for usbnet_write_cmd to send (and acknowledge) a USB CONTROL MSG. A lock to the phy is held during this time.

If I recall my USB knowledge, control messages are acknowledged, which would ensure data is written to the chip. Whether the ASIX requires further delay I would not know. I would have to dive deeper into the timings of the ASIX chip and the driver behaviour to see if that would be the case.

Kind regards,

Michel Stam
-----Original Message-----
From: Ben Hutchings [mailto:ben@decadent.org.uk] 
Sent: Wednesday, November 12, 2014 1:23 AM
To: Charles Keepax
Cc: Stam, Michel [FINT]; Riku Voipio; davem@davemloft.net; linux-usb@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-samsung-soc@vger.kernel.org
Subject: Re: "asix: Don't reset PHY on if_up for ASIX 88772" breaks net on arndale platform

On Tue, 2014-11-04 at 20:09 +0000, Charles Keepax wrote:
> On Tue, Nov 04, 2014 at 11:23:06AM +0100, Stam, Michel [FINT] wrote:
> > Hello Riku,
> > 
> > >Fixing a bug (ethtool support) must not cause breakage elsewhere 
> > >(in
> > this case on arndale). This is now a regression of functionality 
> > from 3.17.
> > >
> > >I think it would better to revert the change now and with less 
> > >hurry
> > introduce a ethtool fix that doesn't break arndale.
> > 
> > I don't fully agree here;
> > I would like to point out that this commit is a revert itself. 
> > Fixing the armdale will then cause breakage in other 
> > implementations, such as ours. Blankly reverting breaks other peoples' implementations.
> > 
> > The PHY reset is the thing that breaks ethtool support, so any fix 
> > that appeases all would have to take existing PHY state into account.
[...]
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -299,6 +299,7 @@ static int ax88772_reset(struct usbnet *dev)  {
>         struct asix_data *data = (struct asix_data *)&dev->data;
>         int ret, embd_phy;
> +       int reg;
>         u16 rx_ctl;
> 
>         ret = asix_write_gpio(dev,
> @@ -359,8 +360,10 @@ static int ax88772_reset(struct usbnet *dev)
>         msleep(150);
> 
>         asix_mdio_write(dev->net, dev->mii.phy_id, MII_BMCR, BMCR_RESET);
> -       asix_mdio_write(dev->net, dev->mii.phy_id, MII_ADVERTISE,
> -                       ADVERTISE_ALL | ADVERTISE_CSMA);
> +       reg = asix_mdio_read(dev->net, dev->mii.phy_id, MII_ADVERTISE);
> +       if (!reg)
> +               reg = ADVERTISE_ALL | ADVERTISE_CSMA;
> +       asix_mdio_write(dev->net, dev->mii.phy_id, MII_ADVERTISE, 
> + reg);
[...]

Why is there no sleep after setting the RESET bit?  Doesn't that make the following register writes unreliable?

Ben.

--
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppner
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
