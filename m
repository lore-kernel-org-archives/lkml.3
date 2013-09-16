Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab3IPRfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:35:46 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35990 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3IPRfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:35:44 -0400
Date: Mon, 16 Sep 2013 10:35:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH] clk: si570: Add a driver for SI570 oscillators
Message-ID: <20130916173540.GA3481@roeck-us.net>
References: <1379033737-30015-1-git-send-email-soren.brinkmann@xilinx.com>
 <1379033737-30015-2-git-send-email-soren.brinkmann@xilinx.com>
 <52373314.5070806@wwwdotorg.org>
 <20130916164927.GB21352@roeck-us.net>
 <5237390E.5070203@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5237390E.5070203@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 10:59:58AM -0600, Stephen Warren wrote:
> On 09/16/2013 10:49 AM, Guenter Roeck wrote:
> > On Mon, Sep 16, 2013 at 10:34:28AM -0600, Stephen Warren wrote:
> >> On 09/12/2013 06:55 PM, Soren Brinkmann wrote:
> >>> Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> >>> The devices generate low-jitter clock signals and are reprogrammable via
> >>> an I2C interface.
> >>
> >>> diff --git a/Documentation/devicetree/bindings/clock/silabs,si570.txt b/Documentation/devicetree/bindings/clock/silabs,si570.txt
> >>
> >>> +Required properties:
> >>> + - compatible: Shall be one of "silabs,si57x", "silabs,si59x".
> >>> + - reg: I2C device address.
> >>> + - #clock-cells: From common clock bindings: Shall be 0.
> >>> + - factory-fout: Factory set default frequency
> >>
> >> So, there's no way to query this from the device at all? Looking at the
> >> data-sheet, all the frequency generation parameters are in registers,
> >> and the device supports I2C read commands. As such, I'm not convinced
> >> this property is necessary.
> >
> > Unfortunately, the chip does not report the factory setting for fout,
> > so the property is needed. The chip can not be programmed without it.
> 
> So fout is not the default overall output frequency, but rather
> something internal that that feeds into the frequency generation
> process, and the registers in the device only describe that frequency
> generation process, not the frequency that feeds into it?
> 
Here is what the datasheet has to say:

"The device's default output frequency is set at the
factory and can be reprogrammed through the two-wire
I2C serial port. Once the device is powered down, it will
return to its factory-set default output frequency."

So it is a default output frequency. However, the chip not report
what it is, and it can be programmed to other frequencies (and
commonly is). In reality it is a reference frequency which happens
to match the output frequency if all registers are at their
default (post-reset) setting.

Correct, the registers only describe the frequency generation process relative
to the reference frequency, so that frequency has to be known to calculate
the correct register values for other frequencies.

> If so, it might be worth enhancing the binding documentation to briefly
> describe that. Presumably the details are all in the HW documentation,
> but it'd be nice if the binding doc was obviously correct without having
> to fully understand the entire HW documentation.
> 
> >>> +Optional properties:
> >>> + - initial-fout: Initial output frequency to set during probe
> >>
> >> "probe" is a Linux-specific concept. This property should be removed. If
> >> the driver is asked to set a specific frequency, it should do so, but I
> >> don't think it should program something pro-actively just because it
> >> starts up.
> >>
> >> If this property is acceptable, it'd be better to describe it more along
> >> the lines of the following:
> >>
> >> initial-fout: The frequency at which the system requires the clock to
> >> operate.
> >
> > It should probably be something like "clock-frequency". In many use cases
> > the programmed frequency is set to a constant frequency at system startup
> > and never changed, similar to other clocks.
> 
> I was going to suggest that too, but re-considered since I think
> clock-frequency is more appropriate for fixed-frequency clocks, rather
> than to specify the value at which a programmable clock generator should
> operate?
> 
> I don't think we have a good story yet for how to represent
> how-we-want-the-clock-tree-configured, as opposed to representing the HW
> itself (which is what DT should be more about).
> 
In many cases the chip _is_ used to generate a fixed frequency, so we will
have to have a means to describe it. That it _can_ be used differently is a
different matter. After all, that is true for many clock generators.

Guenter
