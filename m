Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaIXNsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:48:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49284 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751969AbaIXNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:48:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Wed, 24 Sep 2014 16:08:15 +0200
Message-ID: <3464697.XblUcyRfDp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4515093.TGIQh7cBOD@wuerfel>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1579761.oeYleOAY1N@vostro.rjw.lan> <4515093.TGIQh7cBOD@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 24, 2014 09:55:12 AM Arnd Bergmann wrote:
> On Tuesday 23 September 2014 22:47:36 Rafael J. Wysocki wrote:
> > Quite frankly, I'm not sure what you're asking for.
> > 
> > It seems to mean "I kind of don't like the current implementation", but
> > then the last part is quite unclear to me.  Are you suggesting to add more
> > "if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) etc" type of checks to
> > device drivers?  That I'd like to avoid to be honest.
> 
> No, that is not what I want. Device drivers should ideally call interfaces
> that just take a 'struct device' or 'struct platform_device' pointer,
> and those should be implemented in an appropriate way.

But then you have drivers that access properties of their child nodes which
have no corresponding struct device(s).

> > Instead of the current proposal we can introduce something like
> > 
> > int device_get_child_property(struct device *dev, void *child_node,
> >                               const char *propname, void **valptr);
> > 
> > (and analogously for device_read_property*) and use that in the drivers that
> > need to iterate over child nodes of a device.  Quite along the lines of what
> > Dmitry is suggesting.
> > 
> > Then, fn() in acpi_for_each_child_node() (and the of_ counterpart of it)
> > would become
> > 
> > int (*fn)(struct device *dev, void *child_node, void *data)
> > 
> > and so on.
> > 
> > Would you prefer that?
> 
> I must still be missing part of what you are trying to achieve above.
> We definitely need an interface to get properties from the device itself,
> like
> 
> int device_get_property(struct device *dev, const char *propname, void **valptr);
> 
> (whatever valptr ends up being, that would be a separate discussion).
> 
> As soon as it comes to devices that have child nodes, I don't see a
> necessity to have a generic abstraction for them, as this is typically
> only done for some of the more obscure bindings, or for child nodes that
> are defined in a subsystem-wide binding rather than a device private
> binding.

Well, I don't really agree here.

We can demonstrably reduce code duplication (and therefore complexity too) in
at least two drivers by doing that at a reasonably low cost, which is
simply exposing the API for child nodes and adding helpers for iterating
over them.

We don't have to use struct fw_dev_node (or similar) for that if that's what
bothers you, but in my opinion something like "get me a property of this thing
which may be either a device tree node or an ACPI object" (ie. what the current
dev_node_get_property() does) is more straightforwad than "get me a property
of that child of this device which may be either a device tree node or an ACPI
object" (ie. what device_get_child_property() as described above would do).

> For the former case, I think they are indeed better left in drivers that
> actively know the difference between DT and ACPI, and that don't necessarily
> use the same binding for both. In the latter case, I'd leave the
> implementation up to subsystem code, which again would know what
> interface it is using.

The case in question is drivers that need not know the difference between DT and
ACPI and do use the same binding for both.  It seems quite clear what needs to
be done in the other cases.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
