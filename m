Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaJONQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:16:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35164 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931AbaJONP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:15:59 -0400
Date: Wed, 15 Oct 2014 14:15:51 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
Message-ID: <20141015131551.GC20034@leverpostej>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <1413378271.2762.77.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413378271.2762.77.camel@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 02:04:31PM +0100, David Woodhouse wrote:
> Here's a completely untested patch to convert of_serial to be usable via
> ACPI properties too. The properties themselves were fairly
> straightforward; the interesting part is converting to
> platform_get_irq() and platform_get_resource() — in the latter case
> first trying IORESOURCE_MEM then IORESOURCE_IO if that fails.
> 
> Does this look sane? We'll probably want to think about renaming the
> module and the config option too, but that can come after the basic
> functionality.

The majority of these properties look like they constrained to the
device in question, so make sense for _DSD too.

However...

> @@ -155,7 +168,7 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
>  	if (!match)
>  		return -EINVAL;
>  
> -	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
> +	if (!device_get_property(&ofdev->dev, "used-by-rtas", NULL))
>  		return -EBUSY;

This property should never be present on an ACPI system. RTAS is a
completely different firmware interface on PowerPC.

As a general note, I would hope that we're not going to blindly convert
drivers and subsystems over to a common property interface without
considering each property w.r.t. the particular FW interface. 

Each addition to _DSD, especially if through a common accessor needs
_more_ scrutiny than is applied to DT bindings, and we hardly manage to
review DT bindings.

Mark.
