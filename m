Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbaGOJJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:09:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52574 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932500AbaGOJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:09:47 -0400
Date: Tue, 15 Jul 2014 11:09:42 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Peter.Chen@freescale.com, kishon <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        alexandre.belloni@free-electrons.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, jszhang@marvell.com,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: Re: [PATCH 3/4] usb: add support to the PHY framework for HCD
Message-ID: <20140715090942.GC1011@kwain>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-4-git-send-email-antoine.tenart@free-electrons.com>
 <CAFp+6iELkaXOQiM0=JzUj=YZGqfMjOPFt+-dnEs4=Q3EzyBJBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFp+6iELkaXOQiM0=JzUj=YZGqfMjOPFt+-dnEs4=Q3EzyBJBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Mon, Jul 14, 2014 at 02:38:03PM +0530, Vivek Gautam wrote:
> On Wed, Jul 9, 2014 at 3:47 PM, Antoine Ténart
> <antoine.tenart@free-electrons.com> wrote:
> > diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> > index bec31e2efb88..b985af5b167c 100644
> > --- a/drivers/usb/core/hcd.c
> > +++ b/drivers/usb/core/hcd.c
> > @@ -42,6 +42,7 @@
> >  #include <linux/pm_runtime.h>
> >  #include <linux/types.h>
> >
> > +#include <linux/phy/phy.h>
> >  #include <linux/usb.h>
> >  #include <linux/usb/hcd.h>
> >  #include <linux/usb/phy.h>
> > @@ -2631,21 +2632,35 @@ int usb_add_hcd(struct usb_hcd *hcd,
> >         int retval;
> >         struct usb_device *rhdev;
> >
> > -       if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy) {
> > -               struct usb_phy *phy = usb_get_phy_dev(hcd->self.controller, 0);
> > +       if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy && !hcd->usb_phy) {
> > +               struct phy *phy = of_phy_get(hcd->self.controller->of_node, 0);
> >
> > -               if (IS_ERR(phy)) {
> > -                       retval = PTR_ERR(phy);
> > -                       if (retval == -EPROBE_DEFER)
> > -                               return retval;
> > -               } else {
> > -                       retval = usb_phy_init(phy);
> > +               if (!IS_ERR(phy)) {
> > +                       retval = phy_init(hcd->phy);
> >                         if (retval) {
> > -                               usb_put_phy(phy);
> > +                               phy_exit(hcd->phy);
> >                                 return retval;
> >                         }
> > +                       retval = phy_power_on(hcd->phy);
> >                         hcd->phy = phy;
> >                         hcd->remove_phy = 1;
> > +               } else {
> > +                       struct usb_phy *phy =
> > +                               usb_get_phy_dev(hcd->self.controller, 0);
> > +
> > +                       if (IS_ERR(phy)) {
> > +                               retval = PTR_ERR(phy);
> > +                               if (retval == -EPROBE_DEFER)
> > +                                       return retval;
> > +                       } else {
> > +                               retval = usb_phy_init(phy);
> > +                               if (retval) {
> > +                                       usb_put_phy(phy);
> > +                                       return retval;
> > +                               }
> > +                               hcd->usb_phy = phy;
> > +                               hcd->remove_phy = 1;
> > +                       }
> >                 }
> >         }
> 
> Just a note here:
> There had already been a patch for adding the generic phy support in
> usb/core/hcd.c in 3.16 cycle by
> Sergei and Yoshihiro [1], though structurally a bit different, was not
> picked since there wasn't any user of the patch
> till then. Do you mind modifying on top of that patch
> 
> [1] https://www.mail-archive.com/linux-usb@vger.kernel.org/msg43471.html

Sure, I'll rework my series taking in account this patch. I'll cook a v2
for later today.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
