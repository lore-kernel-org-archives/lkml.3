Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbbAWOvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:51:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52767 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752488AbbAWOve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:51:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
Date: Fri, 23 Jan 2015 16:14:13 +0100
Message-ID: <4300012.3cqZ9mP0gj@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150123112122.GD30522@kuha.fi.intel.com>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com> <1564228.rcRekIyDUd@vostro.rjw.lan> <20150123112122.GD30522@kuha.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 23, 2015 01:21:22 PM Heikki Krogerus wrote:
> 
> --Nq2Wo0NMKNjxTN9z
> Content-Type: text/plain; charset=iso-8859-1
> Content-Disposition: inline
> Content-Transfer-Encoding: 8bit
> 
> Hi guys,
> 
> On Thu, Jan 22, 2015 at 05:14:22PM +0100, Rafael J. Wysocki wrote:
> > On Thursday, January 22, 2015 11:57:55 AM Alexandre Courbot wrote:
> > > If we decide to go ahead with the solution proposed by this patch for
> > > practical reasons (which are good reasons indeed), I still have one
> > > problem with its current form.
> > > 
> > > As the discussion highlighted, this is an ACPI problem, so I'd very
> > > much like it to be confined to the ACPI GPIO code, to be enabled only
> > > when ACPI is, and to use function names that start with acpi_gpio.
> > 
> > I can agree with that.
> > 
> > > The current implementation leverages platform lookup, making said lookup
> > > less efficient in the process and bringing confusion about its
> > > purpose. Although the two processes are indeed similar, they are
> > > separate things: one is a legitimate way to map GPIOs, the other is a
> > > fixup for broken firmware.
> > > 
> > > I suppose we all agree this is a hackish fix, so let's confine it as
> > > much as we can.
> > 
> > OK
> > 
> > Heikki, any comments?
> 
> I'm fine with that.
> 
> That actually makes me think that we could then drop the lookup tables
> completely and use device properties instead with the help of "generic
> property" (attached):

Which reminds me that I've lost track of this one.

Can you please resend it and CC something like linux-acpi?

Also I'm not sure what you mean by "drop the lookup tables completely".

> We would just need to agree on the format how to describe a gpio
> property, document it and of course convert the current users as
> usual. The format could be something like this as an example (I'm
> writing this out of my head so don't shoot me if you can see it would
> not work. Just an example):
> 
> static const u32 example_gpio[] = { <gpio>, <flags>, };
> 
> static struct dev_gen_prop example_prop[] =
>         {
>                 .type = DEV_PROP_U32,
>                 .name = "gpio,<con_id>",
>                 .nval = 2,
>                 .num = &example_gpio,
>         },
>         { },
> };
> 
> static struct platform_device example_pdev = {
>         ...
>         .dev = {
>                 .gen_prop = &example_prop,
>         },
> }
> 
> 
> In gpiolib.c we would then, instead of going through the lookups,
> simply ask for that property:
> 
>         ...
>         sprintf(propname, "gpio,%s", con_id);
>         device_property_read_u32_array(dev, propname, &val, 2);
>         ...
>         desc = gpio_to_desc(val[0]);
>         flags = val[1];
>         ...
> 
> 
> So this is just and idea. I think it would be relatively easy to
> implement. What do you guys think?

Well, I need some time to think about that.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
