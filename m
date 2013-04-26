Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab3DZKLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:11:51 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33890 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab3DZKLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:11:50 -0400
MIME-Version: 1.0
In-Reply-To: <51771D78.5080101@codeaurora.org>
References: <51771D78.5080101@codeaurora.org>
Date: Fri, 26 Apr 2013 12:11:49 +0200
Message-ID: <CACRpkdY2EHiaFTK26hoCwQ_TxgECohR2EAAmQESZYNvnx-mX9A@mail.gmail.com>
Subject: Re: [RFC] pinctrl: Pin controller with different types of pins
From: Linus Walleij <linus.walleij@linaro.org>
To: hanumant <hanumant@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 1:47 AM, hanumant <hanumant@codeaurora.org> wrote:

> 2) After the above, we have config registers for the dedicated pins.
> In this case the config register are per use case. For example
> if SDCC uses dedicated pins as follows 1 clock pin, 8 data pins and 2
> command pins then there will be one config register as follows
> Bits 31-29 = clk pull value (1-7)
> Bits 28-26 = data line pull values (1-7)
> Bits 25-23 = command pull values (1-7)
> Bits 8-6 = clk drive strength values (1-7)
> Bits 5-3 = data drive strength values
> Bits 2-0 = command drive strength values

OK seems normal. I guess you really mean "drive strength" as in
"configurable mA output", because often the voltage (VCCQ) can
be controlled as well.

There is some overlap with regulators here, CC:ing Mark Brown
for a second opinion.

> The only option I see is
>
> 1) to implement this as one pin controller, with total number of pins =
> multi function pins + dedicated pins.

This seems easiest, this is what I would do.

> 2) The pin descriptor registered with the framework would be part of a
> bigger descriptor maintained by the driver that additionally defines the pin
> type and the register manipulation methods for that type.

Yes:

struct foo_desc {
    struct pin_desc desc;
    ...
};

Register &foo->desc to the pinctrl subsystem, to get back to
foo_desc, use container_of() to get to your descriptor from the
&foo_desc->desc.

> 3) The pin number would serve as an index into the driver descriptor.

I do not understandd what this means.

> 4) The register manipulation methods would be part of the of_device_id
> data for the pin controller

Not following. You're saying you register on controller, don't
you rather want a field on struct foo_desc telling how to handle
the particular pin type?

> I have not been able to find any precedence for this kind of pin controller
> design.

We've covered the simple cases and now we get to the
complicated ones :-)

> Is there any value add to having a private data field for the framework pin
> descriptor that can be overloaded for every pin to take care of these kinds
> of problems?

Incidentally I already answered a similar mail earlier today, and the
answer is no.

Encapsulate struct pin_desc inside a custom struct and get used to
using container_of().

Yours,
Linus Walleij
