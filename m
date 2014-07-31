Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaGaMey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:34:54 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63401 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaGaMev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:34:51 -0400
Date: Thu, 31 Jul 2014 14:34:43 +0200
From: Robert Richter <rric@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140731123443.GS4703@rric.localhost>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <20140730154626.GD20162@leverpostej>
 <CAL_JsqLJ_W34XTF2aMOW9z+Gq4oxbrX1RztyJN8Mi0OFPeNxfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLJ_W34XTF2aMOW9z+Gq4oxbrX1RztyJN8Mi0OFPeNxfg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.07.14 11:37:38, Rob Herring wrote:
> On Wed, Jul 30, 2014 at 10:46 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Wed, Jul 30, 2014 at 04:06:31PM +0100, Robert Richter wrote:
> >> From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>

> >> +/ {
> >> +     model = "Cavium ThunderX CN88XX Family";
> >> +     compatible = "cavium,thunder-88xx";
> >
> > Please don't use wildcards in compatible strings. Give this an absolute
> > name, and override as necessary.

The naming 88xx refers to the processor family and arn't actually
wildcards. In the future we might need another dts file for 87xx, but
so far all SoCs of 88xx family should use the same dts files. In this
sense the naming is very specific.


> >> +     cpus {
> >> +             #address-cells = <2>;
> >> +             #size-cells = <0>;
> >> +
> >> +             cpu@000 {
> >> +                     device_type = "cpu";
> >> +                     compatible = "cavium,thunder", "arm,armv8";
> >> +                     reg = <0x0 0x000>;
> >> +                     enable-method = "psci";
> >> +             };
> >
> > Just to check: both the SoC and CPU are called thunder?

The soc is called thunder-88xx, the cpu thunder. E.g. an 87xx soc will
have the same core in which is thunder.


> >> +     memory@00000000 {
> >> +             device_type = "memory";
> >> +             reg = <0x0 0x00000000 0x0 0x80000000>;
> >> +     };
> >> +
> >> +     gic0: interrupt-controller@801000000000 {
> >
> > To make this easier to read, please place a comma between 32-bit
> > portions of the unit address (e.g. here have 8010,00000000).

Changed this.

> 
> Mark, perhaps a dtc or checkpatch.pl check for this?
> 
> This should also be under a bus node.

Will do.

> 
> >> +             compatible = "arm,gic-v3";
> >> +             #interrupt-cells = <3>;
> >> +             #address-cells = <2>;
> >> +             #size-cells = <2>;
> >> +             ranges;
> >
> > This has no children, so why have ranges, #address-cells, and
> > #size-cells?

Right, this is a leftover from a change in a follow on patch that
introduces a child for its. Will remove #address-cells, #size-cells
and ranges in this patch and move the change to the later patch.

> >
> >> +             interrupt-controller;
> >> +             reg = <0x8010 0x00000000 0x0 0x010000>, /* GICD */
> >> +                   <0x8010 0x80000000 0x0 0x200000>; /* GICR */
> >> +             interrupts = <1 9 0xf04>;
> >> +     };

> >> +             clocks {
> >> +                     #address-cells = <2>;
> >> +                     #size-cells = <2>;
> >> +                     ranges;
> >> +
> >> +                     refclk50mhz: refclk50mhz {
> >> +                             compatible = "fixed-clock";
> >> +                             #clock-cells = <0>;
> >> +                             clock-frequency = <50000000>;
> >> +                             clock-output-names = "refclk50mhz";
> >> +                     };
> >> +             };
> >
> > Please get rid of the clocks node and just put the clocks here.

Will do.

> >
> >> +
> >> +             uaa0: serial@87e024000000 {
> >> +                     compatible = "arm,pl011", "arm,primecell";
> >> +                     reg = <0x87e0 0x24000000 0x0 0x1000>;
> >> +                     interrupts = <1 21 4>;
> >> +                     clocks = <&refclk50mhz>;
> >> +                     clock-names = "apb_pclk";
> >
> > Is this actually the apb_pclk, or is the the uartclk? I assume it's the
> > latter.
> 
> Shouldn't new bindings have both clocks here? A single clock was a
> mistake I think (mine in fact).

Do you mean
			clock-names = "uartclk", "apb_pclk";
here?

Thanks,

-Robert
