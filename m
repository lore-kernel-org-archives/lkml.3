Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaKSCax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:30:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:34100 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbaKSCav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:30:51 -0500
Message-ID: <1416364227.5704.20.camel@kernel.crashing.org>
Subject: Re: [PATCH] drivers/core/of: Add symlink to device-tree from
 devices with an OF node
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jeremy Kerr <jeremy.kerr@au1.ibm.com>
Date: Wed, 19 Nov 2014 13:30:27 +1100
In-Reply-To: <CAL_Jsq+YyfMWxiOFv4x3g5hZJH0XRqCKj2He1XO9eyXWjHTMrg@mail.gmail.com>
References: <1415342031.4925.27.camel@kernel.crashing.org>
	 <1415342117.4925.29.camel@kernel.crashing.org>
	 <1415596626.5769.14.camel@kernel.crashing.org>
	 <CAL_JsqKG=vpeGKj3v-2VW9oGQsnmuYMHRfy6LuXDXE=ROjHT4w@mail.gmail.com>
	 <1415841047.5124.62.camel@kernel.crashing.org>
	 <CAL_Jsq+YyfMWxiOFv4x3g5hZJH0XRqCKj2He1XO9eyXWjHTMrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 10:37 -0600, Rob Herring wrote:
> On Wed, Nov 12, 2014 at 7:10 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > So I've been annoyed lately with having a bunch of devices such as i2c
> > eeproms (for use by VPDs, server world !) and other bits and pieces that
> > I want to be able to identify from userspace, and possibly provide
> > additional data about from FW.
> >
> > Basically, it boils down to correlating the sysfs device with the OF
> > tree device node, so that user space can use device-tree info such as
> > additional "location" or "label" (or whatever else we can come up with)
> > propreties to identify a given device, or get some attributes of use
> > about it, etc...
> >
> > Now, so far, we've done that in some subsystem in a fairly ad-hoc basis
> > using "devspec" properties. For example, PCI creates them if it can
> > correlate the probed device with a DT node. Some powerpc specific busses
> > do that too.
> >
> > However, i2c doesn't and it would be nice to have something more generic
> > since technically any device can have a corresponding device tree node.
> >
> > This patch adds an "of_node" symlink to devices that have a non-NULL
> > dev->of_node pointer, the patch is pretty trivial and seems to work just
> > fine for me.
> >
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 20da3ad..8c7b607 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -493,6 +493,15 @@ static int device_add_attrs(struct device *dev)
> >                         goto err_remove_dev_groups;
> >         }
> >
> > +#ifdef CONFIG_OF
> > +       if (dev->of_node) {
> 
> if (IS_ENABLED(CONFIG_OF) && dev->of_node)

Ok, I didn't realize the of_node field existed in struct device even
without CONFIG_OF (otherwise that wouldn't have compiled). Grant, Rob,
do you want to take this patch (with the above fixed) or should I not
bother based on the fact that the info is in uevent ? I prefer still
doing the symlink but you tell me.

> > +               error = sysfs_create_link(&dev->kobj, &dev->of_node->kobj,
> > +                                         "of_node");
> > +               if (error)
> > +                       dev_warn(dev, "Error %d creating of_node link\n", error);
> > +       }
> > +#endif /* CONFIG_OF */
> > +
> >         return 0;
> >
> >   err_remove_dev_groups:
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


