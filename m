Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507Ab3FSKYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:24:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:40667 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934190Ab3FSKYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:24:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,896,1363158000"; 
   d="scan'208";a="355978450"
Message-ID: <51C187D5.7040101@linux.intel.com>
Date: Wed, 19 Jun 2013 13:28:37 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com> <1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CACRpkdb2M-TBHbZf=hQE_0ihc4L5amdoFw5QQg2OSFXaMrH8mA@mail.gmail.com>
In-Reply-To: <CACRpkdb2M-TBHbZf=hQE_0ihc4L5amdoFw5QQg2OSFXaMrH8mA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 06:17 PM, Linus Walleij wrote:
> On Tue, Jun 18, 2013 at 1:33 PM, Mathias Nyman
> <mathias.nyman@linux.intel.com>  wrote:
>
>> Add support for gpio on Intel BayTrail platforms. BayTrail supports 3 banks
>> of gpios called SCORE, NCORE ans SUS with 102, 28 and 44 gpio pins.
>> Supports gpio interrupts and ACPI gpio events
>>
>> Pins may be muxed to alternate function instead of gpio by firmware.
>> This driver does not touch the pin muxing and expect firmare
>> to set pin muxing and pullup/down properties properly.
>>
>> Signed-off-by: Mathias Nyman<mathias.nyman@linux.intel.com>
>
> I have a feeling this driver will evolve quite a bit and eventually
> register a pure pinctrl interface as well (currently it's only using
> the ranges as some data container...)
>
> Anyway, it's a good starting point and obviously (I guess?)
> gets your hardware up an ticking, so let's take this as a
> starting point.
>
> So patch applied.
>

Thanks, much appreciated.
We'll see how it evolves.

> This thing only seems to use gpiolib-acpi.c for the basic
> device matching and IRQ handling backend, is that correct?

It only uses gpiolib-acpi.c for handling GPIO-signaled ACPI Events,
which are like SCI events on hardware reduced ACPI platforms.

Basically It's ACPI saying "I have a firmware method that needs to be 
run if a certain gpio is triggered, please do that for me"

So the acpi_gpiochip_request_interrupts() registers interrupt handlers 
which call ACPI firmware methods for those gpio interrupts.

Otherwise gpiolib-acpi.c is useful for other device drivers to translate 
ACPI gpio resource numbers to linux gpio numbers. In ACPI tables the 
gpio resource numbers are per controller and zero based.
>
> What I'm thinking of moving forward is that I have seen
> ACPI fragments with things like "PullUp" etc, which is pinctrl
> domain, so we may come to need some generic ACPI helpers
> inside drivers/pinctrl as well sooner or later.

Probably yes, I'm not an expert on ACPI (or pinctrl), but ACPI5 added 
the GpioInt and GpioIo resources for devices. GpioInt resource 
descriptor has the follwing arguments: GpioInt(EdgeLevel, ActiveLevel, 
Shared, PinConfig, DebounceTimeout, ResourceSource,
esourceSourceIndex, ResourceUsage, DescriptorName, VendorData) {PinList}

Where the PinConfig argument can be PullDefault, PullUp, PullDown, 
PullNone or some vendor specific value.

ResourceSource tells which gpio controller the pin belongs to.

Right now drivers only have helpers for translating the ACPI gpio pin 
number to linux gpio number.

-Mathias
