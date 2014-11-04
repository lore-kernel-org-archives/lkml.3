Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaKDPqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:46:02 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56373 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753960AbaKDPp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:45:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index() when using properties
Date: Tue, 04 Nov 2014 17:06:40 +0100
Message-ID: <2107668.8toVpPDgB1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACxGe6uXogQaT9m_Zysb+daSHCz2B97OdMBHuCzJvNYj9oNWfQ@mail.gmail.com>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com> <2331586.goAnq7FsMG@vostro.rjw.lan> <CACxGe6uXogQaT9m_Zysb+daSHCz2B97OdMBHuCzJvNYj9oNWfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 02:48:40 PM Grant Likely wrote:
> On Mon, Nov 3, 2014 at 9:52 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, November 03, 2014 04:25:08 PM Rafael J. Wysocki wrote:
> >> On Sunday, November 02, 2014 08:49:37 PM Darren Hart wrote:
> >> >
> >> > On 11/1/14 4:11, Grant Likely wrote:
> >> > > On Tue, 28 Oct 2014 22:59:57 +0100
> >> > > , "Rafael J. Wysocki" <rjw@rjwysocki.net>
> >> > >  wrote:
> >> > >> On Tuesday, October 28, 2014 01:15:27 PM Mika Westerberg wrote:
> >> > >>> acpi_dev_add_driver_gpios() makes it possible to set up mapping between
> >> > >>> properties and ACPI GpioIo resources in a driver, so we can take index
> >> > >>> parameter in acpi_find_gpio() into use with _DSD device properties now.
> >> > >>>
> >> > >>> This index can be used to select a GPIO from a property with multiple
> >> > >>> GPIOs:
> >> > >>>
> >> > >>>   Package () {
> >> > >>>         "data-gpios",
> >> > >>>         Package () {
> >> > >>>                 \_SB.GPIO, 0, 0, 0,
> >> > >>>                 \_SB.GPIO, 1, 0, 0,
> >> > >>>                 \_SB.GPIO, 2, 0, 1,
> >> > >>>         }
> >> > >>>   }
> >> > >>>
> >> > >>> In order to retrieve the last GPIO from a driver we can simply do:
> >> > >>>
> >> > >>>   desc = devm_gpiod_get_index(dev, "data", 2);
> >> > >>>
> >> > >>> and so on.
> >> > >>>
> >> > >>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> > >>
> >> > >> Cool. :-)
> >> > >>
> >> > >> Any objections anyone?
> >> > >
> >> > > Actually, I do. Not in the idea, but in the implementation. The way this gets encoded:
> >> > >
> >> > >   Package () {
> >> > >           \_SB.GPIO, 0, 0, 0,
> >> > >           \_SB.GPIO, 1, 0, 0,
> >> > >           \_SB.GPIO, 2, 0, 1,
> >> > >   }
> >> > >
> >> > > Means that decoding each GPIO tuple requires the length of a tuple to be
> >> > > fixed, or to implement a DT-like #gpio-cells. If it is fixed, then there
> >> > > is no way to expand the binding later. Can this be done in the following
> >> > > way instead?
> >> > >
> >> > >   Package () {
> >> > >           Package () { \_SB.GPIO, 0, 0, 0 },
> >> > >           Package () { \_SB.GPIO, 1, 0, 0 },
> >> > >           Package () { \_SB.GPIO, 2, 0, 1 },
> >> > >   }
> >> > >
> >> > > This is one of the biggest pains in device tree. We don't have any way
> >> > > to group tuples so it requires looking up stuff across the tree to
> >> > > figure out how to parse each multi-item property.
> >> > >
> >> > > I know that last year we talked about how bios vendors would get
> >> > > complicated properties wrong, but I think there is little risk in this
> >> > > case. If the property is encoded wrong, the driver simply won't work and
> >> > > it is unlikely to get shipped before being fixed.
> >> >
> >> > This particular nesting of Packages is expressly prohibited by the
> >> > Device Properties UUID for the reasons you mention.
> >> >
> >> > http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> >>
> >> Also we don't use properties where single name is assigned to multiple GPIOs
> >> anywhere in the current device-properties patchset, so this is not relevant at
> >> the moment.
> >>
> >> Moreover, even if we were to use them, we would need to ensure that this:
> >>
> >>       Package () {
> >>               \_SB.GPIO, 0, 0, 0
> >>       }
> >>
> >> was equivalent to
> >>
> >>       Package () {
> >>               Package () { \_SB.GPIO, 0, 0, 0 }
> >>       }
> >>
> >> This is not impossible to do and I suppose we could even explain that in the
> >> implementation guide document in a sensible way, but that would require the
> >> document linked above to be changed first and *then* we can think about writing
> >> kernel code to it.  Not the other way around, please.
> >>
> >> So Grant, do you want us to proceed with that?
> >
> > Before you reply, one more observation that seems to be relevant.
> >
> > In ACPI, both this:
> >
> >         Package () {
> >                 \_SB.GPIO, 0, 0, 0,
> >                 \_SB.GPIO, 1, 0, 0,
> >                 \_SB.GPIO, 2, 0, 1,
> >         }
> >
> > and this:
> >
> >         Package () {
> >                 Package () { \_SB.GPIO, 0, 0, 0 },
> >                 Package () { \_SB.GPIO, 1, 0, 0 },
> >                 Package () { \_SB.GPIO, 2, 0, 1 },
> >         }
> >
> > carry the same information, because every element of a package has a type,
> > so there is no danger of confusing an ACPI_TYPE_LOCAL_REFERENCE with
> > ACPI_TYPE_INTEGER.  Thus one can easily count the number of GPIOs represented
> > by the first package by counting the number of reference elements in it.
> > The second one has more structure which in this particular case is arguably
> > redundant.
> 
> Okay, this make sense. I'm okay with this approach, and I would
> recommend making that the only valid method for parsing in
> acpi_dev_get_property_reference(). Get rid of the *size_prop argument
> so that it always behaves the same way and users aren't tempted to do
> something clever.

OK, I'll send a followup patch to remove the size_prop arg from
acpi_dev_get_property_reference().

> > Of course, that's not the case for list properties where each item consists
> > of a bunch of integers, like
> >
> >         Package () {
> >                 Package () { 0, 0, 0 },
> >                 Package () { 1, 0, 0 },
> >                 Package () { 2, 0, 1 },
> >         }
> >
> > but I'm not sure if this is relevant at all.
> 
> Probably not. With a pure list it isn't implicitly referencing data in
> another node. In the ref+args pattern the length of each tuple can
> vary based on which node it references, but on a simple list the
> parsing is going to be a lot simpler.

OK

Rafael

