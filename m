Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaAZWGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 17:06:47 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:42070 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaAZWGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 17:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <201401091517.36357@pali>
References: <201311191151.17153@pali> <201311271740.42913@pali>
 <20131127173904.GD8123@saruman.home> <201401091517.36357@pali>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Sun, 26 Jan 2014 23:06:05 +0100
Message-ID: <CAHYPw2HfJwPHVXzvcNkFgfMm2TS-MQstuAF4hzcva-ycJSxevQ@mail.gmail.com>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
To: Felipe Balbi <balbi@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@ring0.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "freemangordon @ maemo. org - Talk" <freemangordon@abv.bg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-09 Pali Rohár <pali.rohar@gmail.com>:
> On Wednesday 27 November 2013 18:39:04 Felipe Balbi wrote:
>> Hi,
>>
>> On Wed, Nov 27, 2013 at 05:40:42PM +0100, Pali Rohár wrote:
>> > > > > > @@ -282,10 +284,12 @@ static void
>> > > > > > obex_disconnect(struct gserial *g) if
>> > > > > > (!obex->can_activate)
>> > > > > >
>> > > > > >             return;
>> > > > > >
>> > > > > > +#if 0
>> > > > > >
>> > > > > >     status = usb_function_deactivate(&g->func);
>> > > > > >     if (status)
>> > > > > >
>> > > > > >             DBG(cdev, "obex ttyGS%d function deactivate -->
>> > > > > >             %d\n",
>> > > > > >
>> > > > > >                     obex->port_num, status);
>> > > > > >
>> > > > > > +#endif
>> > > > > >
>> > > > > >  }
>> > > > > >
>> > > > > >  /*-------------------------------------------------
>> > > > > >  ---- ------
>> > > > > >
>> > > > > > --------------*/ @@ -372,6 +376,7 @@ static int
>> > > > > > obex_bind(struct usb_configuration *c, struct
>> > > > > > usb_function *f) if (status)
>> > > > > >
>> > > > > >             goto fail;
>> > > > > >
>> > > > > > +#if 0
>> > > > > >
>> > > > > >     /* Avoid letting this gadget enumerate until the
>> > > > > >     userspace
>> > > > > >
>> > > > > >      * OBEX server is active.
>> > > > > >      */
>> > > > > >
>> > > > > > @@ -381,6 +386,7 @@ static int obex_bind(struct
>> > > > > > usb_configuration *c, struct usb_function *f)
>> > > > > > obex->port_num, status);
>> > > > > >
>> > > > > >     else
>> > > > > >
>> > > > > >             obex->can_activate = true;
>> > > > > >
>> > > > > > +#endif
>> > > > > >
>> > > > > >     DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",
>> > > > >
>> > > > > Hi, with above patch g_nokia.ko working and not
>> > > > > crashing.
>> > > >
>> > > > yeah, makes sense. We shouldn't call phy operations in
>> > > > atomic context. I'll see how easy it would be to fix
>> > > > that. Real patch coming soon(-ish).
>> > >
>> > > I think we could send diff below for the -rc cycle and
>> > > figure out a better to handle this for the merge window.
>> > > Can you check if it also works with patch below ?
>> > >
>> > > diff --git a/drivers/usb/musb/omap2430.c
>> > > b/drivers/usb/musb/omap2430.c index 2a408cd..8aa59a2
>> > > 100644 --- a/drivers/usb/musb/omap2430.c
>> > > +++ b/drivers/usb/musb/omap2430.c
>> > > @@ -659,7 +659,6 @@ static int
>> > > omap2430_runtime_suspend(struct device *dev)
>> > > OTG_INTERFSEL);
>> > >
>> > >           omap2430_low_level_exit(musb);
>> > >
>> > > -         phy_power_off(musb->phy);
>> > >
>> > >   }
>> > >
>> > >   return 0;
>> > >
>> > > @@ -674,7 +673,6 @@ static int
>> > > omap2430_runtime_resume(struct device *dev)
>> > > omap2430_low_level_init(musb);
>> > >
>> > >           musb_writel(musb->mregs, OTG_INTERFSEL,
>> > >
>> > >                           musb->context.otg_interfsel);
>> > >
>> > > -         phy_power_on(musb->phy);
>> > >
>> > >   }
>> > >
>> > >   return 0;
>> >
>> > Hi, I applied similar patch (commented usb_phy_set_suspend
>> > instead phy_power_on/off) on 3.12-rc5 and it working too, no
>> > crash. I do not have rebased n900 patches on top of 3.13
>> > tree, so I cannot check it. But I think phy_power_on/off
>> > doing same as usb_phy_set_suspend in 3.12.
>>
>> cool, I'll send this during the -rc and Cc stable, then I'll
>> manually backport it to stable later.
>
> PING!
>
> I still do not see this patch in linus tree. What happened?
>
> --
> Pali Rohár
> pali.rohar@gmail.com

BUMP

Is there any problem with above patch?

-- 
Pali Rohár
pali.rohar@gmail.com
