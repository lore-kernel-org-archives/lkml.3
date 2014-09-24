Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaIXHze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:55:34 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:63948 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaIXHzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:55:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
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
Date: Wed, 24 Sep 2014 09:55:12 +0200
Message-ID: <4515093.TGIQh7cBOD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1579761.oeYleOAY1N@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <2809308.3y5s7TV5Ip@wuerfel> <1579761.oeYleOAY1N@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LeSJ7GpoVvSg6ctU3Oec9HHKLepvPYQfTHDWQRDapiW
 NHMcsTexhn4wTVEORf5uI4DertIHJ/pADXGELfQhbpDuB7b8bt
 1f/4P/PaD4+IZyHOzomuY16BsFGDkbb0k9FNX0XFfCvaBw1P5g
 um6+gZpdvWa5kQrZZvj2GwzpO+d220yS7LinkmUaddpL8s54kt
 xtE4N9aAGHXeE2FjMV/K0jexuMIFIlvoXPLSYl13P0HaWddIQq
 z5KR+yOX7ac0rwQUaRMsJCi0K7E5RyM6/lCFGbNWxMc4ZkZ/Lg
 h+8QtY3UD15o0AopOm+4NnX0jzLsILLwVQCCHUXcr8ObuwY4qN
 /R0yfIN5rbJdzdl3zDmk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 22:47:36 Rafael J. Wysocki wrote:
> Quite frankly, I'm not sure what you're asking for.
> 
> It seems to mean "I kind of don't like the current implementation", but
> then the last part is quite unclear to me.  Are you suggesting to add more
> "if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) etc" type of checks to
> device drivers?  That I'd like to avoid to be honest.

No, that is not what I want. Device drivers should ideally call interfaces
that just take a 'struct device' or 'struct platform_device' pointer,
and those should be implemented in an appropriate way.

> Instead of the current proposal we can introduce something like
> 
> int device_get_child_property(struct device *dev, void *child_node,
>                               const char *propname, void **valptr);
> 
> (and analogously for device_read_property*) and use that in the drivers that
> need to iterate over child nodes of a device.  Quite along the lines of what
> Dmitry is suggesting.
> 
> Then, fn() in acpi_for_each_child_node() (and the of_ counterpart of it)
> would become
> 
> int (*fn)(struct device *dev, void *child_node, void *data)
> 
> and so on.
> 
> Would you prefer that?

I must still be missing part of what you are trying to achieve above.
We definitely need an interface to get properties from the device itself,
like

int device_get_property(struct device *dev, const char *propname, void **valptr);

(whatever valptr ends up being, that would be a separate discussion).

As soon as it comes to devices that have child nodes, I don't see a
necessity to have a generic abstraction for them, as this is typically
only done for some of the more obscure bindings, or for child nodes that
are defined in a subsystem-wide binding rather than a device private
binding.

For the former case, I think they are indeed better left in drivers that
actively know the difference between DT and ACPI, and that don't necessarily
use the same binding for both. In the latter case, I'd leave the
implementation up to subsystem code, which again would know what
interface it is using.

	Arnd
