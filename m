Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaKALLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 07:11:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63539 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaKALLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 07:11:48 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index()
 when using properties
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <2740724.5yjNTKs1RY@vostro.rjw.lan>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com>
	<2740724.5yjNTKs1RY@vostro.rjw.lan>
Date: Sat, 01 Nov 2014 11:11:43 +0000
Message-Id: <20141101111143.86AC1C409FE@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 22:59:57 +0100
, "Rafael J. Wysocki" <rjw@rjwysocki.net>
 wrote:
> On Tuesday, October 28, 2014 01:15:27 PM Mika Westerberg wrote:
> > acpi_dev_add_driver_gpios() makes it possible to set up mapping between
> > properties and ACPI GpioIo resources in a driver, so we can take index
> > parameter in acpi_find_gpio() into use with _DSD device properties now.
> > 
> > This index can be used to select a GPIO from a property with multiple
> > GPIOs:
> > 
> >   Package () {
> >   	"data-gpios",
> >   	Package () {
> >   		\_SB.GPIO, 0, 0, 0,
> >   		\_SB.GPIO, 1, 0, 0,
> >   		\_SB.GPIO, 2, 0, 1,
> >   	}
> >   }
> > 
> > In order to retrieve the last GPIO from a driver we can simply do:
> > 
> >   desc = devm_gpiod_get_index(dev, "data", 2);
> > 
> > and so on.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Cool. :-)
> 
> Any objections anyone?

Actually, I do. Not in the idea, but in the implementation. The way this gets encoded:

	Package () {
		\_SB.GPIO, 0, 0, 0,
		\_SB.GPIO, 1, 0, 0,
		\_SB.GPIO, 2, 0, 1,
	}

Means that decoding each GPIO tuple requires the length of a tuple to be
fixed, or to implement a DT-like #gpio-cells. If it is fixed, then there
is no way to expand the binding later. Can this be done in the following
way instead?

	Package () {
		Package () { \_SB.GPIO, 0, 0, 0 },
		Package () { \_SB.GPIO, 1, 0, 0 },
		Package () { \_SB.GPIO, 2, 0, 1 },
	}

This is one of the biggest pains in device tree. We don't have any way
to group tuples so it requires looking up stuff across the tree to
figure out how to parse each multi-item property.

I know that last year we talked about how bios vendors would get
complicated properties wrong, but I think there is little risk in this
case. If the property is encoded wrong, the driver simply won't work and
it is unlikely to get shipped before being fixed.

g.

