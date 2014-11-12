Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaKLVUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:20:54 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39804 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaKLVUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:20:49 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/base: Fix PowerPC address parsing hack
To: Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <CAL_JsqKfBGdpFV_XuE4DEhFrkhN33kOMkiZE_TOnAZDm2qjwMw@mail.gmail.com>
References: <1415771461.5124.33.camel@kernel.crashing.org>
	<CAL_JsqKfBGdpFV_XuE4DEhFrkhN33kOMkiZE_TOnAZDm2qjwMw@mail.gmail.com>
Date: Wed, 12 Nov 2014 17:02:51 +0000
Message-Id: <20141112170251.DA1B7C41C04@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014 08:39:32 -0600
, Rob Herring <robherring2@gmail.com>
 wrote:
> On Tue, Nov 11, 2014 at 11:51 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > We have a historical hack that treats missing ranges properties as the
> > equivalent of an empty one. This is needed for ancient PowerMac "bad"
> > device-trees, and shouldn't be enabled for any other PowerPC platform,
> > otherwise we get some nasty layout of devices in sysfs or even
> > duplication when a set of otherwise identically named devices is
> > created multiple times under a different parent node with no ranges
> > property.
> >
> > This fix is needed for the PowerNV i2c busses to be exposed properly
> > and will fix a number of other embedded cases.
> >
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > CC: <stable@vger.kernel.org>
> > ---
> >
> > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > index e371825..e37f017 100644
> > --- a/drivers/of/address.c
> > +++ b/drivers/of/address.c
> > @@ -7,6 +7,10 @@
> >  #include <linux/pci_regs.h>
> >  #include <linux/string.h>
> >
> > +#ifdef CONFIG_PPC
> > +#include <asm/machdep.h>
> > +#endif
> > +
> >  /* Max address size we deal with */
> >  #define OF_MAX_ADDR_CELLS      4
> >  #define OF_CHECK_ADDR_COUNT(na)        ((na) > 0 && (na) <= OF_MAX_ADDR_CELLS)
> > @@ -428,12 +432,13 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
> >          * This code is only enabled on powerpc. --gcl
> >          */
> >         ranges = of_get_property(parent, rprop, &rlen);
> > -#if !defined(CONFIG_PPC)
> > +#if defined(CONFIG_PPC)
> > +       if (!machine_is(powermac))
> 
> Can we use a machine compatible here or something not PPC specific?
> Then we can use IS_ENABLED(CONFIG_PPC) instead of ifdefs.

Yeah, that's kind of nasty!

g.

