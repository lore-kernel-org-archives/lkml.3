Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaETObL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:31:11 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:32884 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaETObH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:31:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAF03EBfwFC7bK=j0W3K+no9TK7xe2nF1ZXH9bMBRNzVErB5EjQ@mail.gmail.com>
References: <1400169891-29546-1-git-send-email-tthayer@altera.com>
	<1400169891-29546-2-git-send-email-tthayer@altera.com>
	<20140516075344.GF949@pengutronix.de>
	<CAF03EBfOrBWsGVkwYHQt9Pm858LtkgUThkM6dFjksa93ETo_bw@mail.gmail.com>
	<20140519191206.GH949@pengutronix.de>
	<CAF03EBfwFC7bK=j0W3K+no9TK7xe2nF1ZXH9bMBRNzVErB5EjQ@mail.gmail.com>
Date: Tue, 20 May 2014 09:31:06 -0500
Message-ID: <CANk1AXTdSheUkNtF2fSmtcYaUrd2CnTjBxGitmSy88H4VRVbnw@mail.gmail.com>
Subject: Re: [PATCHv5 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM controller
From: Alan Tull <delicious.quinoa@gmail.com>
To: Thor Thayer <tthayer.linux@gmail.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, Borislav Petkov <bp@alien8.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Alan Tull <atull@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 2:37 PM, Thor Thayer <tthayer.linux@gmail.com> wrote:

>>> >> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
>>> >> new file mode 100644
>>> >> index 0000000..8f8746b
>>> >> --- /dev/null
>>> >> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
>>> >> @@ -0,0 +1,11 @@
>>> >> +Altera SOCFPGA SDRAM Controller
>>> >> +
>>> >> +Required properties:
>>> >> +- compatible : "altr,sdr-ctl";
>>> >> +- reg : Should contain 1 register ranges(address and length)
>>> >> +
>>> >> +Example:
>>> >> +     sdrctl@ffc25000 {
>>> >> +             compatible = "altr,sdr-ctl";
>>> >> +             reg = <0xffc25000 0x1000>;
>>> >> +     };
>>> >> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>>> >> index df43702..6ce912e 100644
>>> >> --- a/arch/arm/boot/dts/socfpga.dtsi
>>> >> +++ b/arch/arm/boot/dts/socfpga.dtsi
>>> >> @@ -676,6 +676,11 @@
>>> >>                       clocks = <&l4_sp_clk>;
>>> >>               };
>>> >>
>>> >> +             sdrctl@ffc25000 {
>>> >> +                     compatible = "altr,sdr-ctl", "syscon";
>>> >                                                    ^^^^^^^^^^
>>> >
>>> > Get rid of that, too, please.
>>>
>>> Hi Steffan,
>>>
>>> I believe I need to keep the "syscon". The same register (ctrlcfg)
>>> that has the ECC enable bitfield also includes the DRAM configuration
>>> bitfields that other drivers will want to access (specifically the
>>> FPGA bridge needs this information). Since this register will be
>>> shared between drivers,  syscon seems like the best solution.
>>>
>>
>> Hm, from looking at the documentation of the ctrlcfg I can't really
>> understand which bits you would need for the FPGA brigde and why.

Hi Steffen,

Offset 0x80 in the sdr-ctl is the "fpgaportrst" register.  14 bits
wide, defaults to 0.  When appropriate bits set to 1 in that reg, it
allows an FPGA port to come out of reset (enables that port).  Has no
other effect on SDRAM configuration.

>> That all sounds like stuff you would want to set for the specific
>> RAM you are dealing with on a specific board.
>> What bridge are you talking about? The SDRAM bridge?

Yes, the port allows the FPGA a direct path to the SDRAM.  This one
register the only register in the sdr that the bridge driver needs.

>>
>> I can see the problem with the ECC enable, though.
>>
>> Regards,
>> Steffen
>>
>
> Hi Steffen,
>
> I'll get more details from the guy working on the FPGA bridge when he
> gets back in the office. When I started working on EDAC, that register
> had been allocated by the FPGA bridge driver so we decided to use the
> syscon to allow sharing of the register.
>
> My understanding was that the FPGA bridge as an SDRAM master would
> allow FPGA devices to access the SDRAM.  As part of that process, they
> may want to read the SDRAM configuration.

The FPGA bridge driver doesn't look at the SDRAM configuration.  It
just wants access to this one register so it can enable or disable the
FPGA path to SDRAM.  The only function of this bridge driver is to
enable/disable the bridge.

~Alan

>
> I'll need to get more details from the driver developer because the
> FPGA driver is in flux while the appropriate driver architecture is
> being discussed.
>
> Thor
>
>
>>> >                 sdrctl@ffc25000 {
>>> >                         compatible = "altr,sdr-ctl";
>>> >                         reg = <0xffc25000 0x1000>;
>>> >                         ranges;
>>> >
>>> >                         edac@ffc2502c {
>>> >                                 compatible = "altr,sdram-edac";
>>> >                                 reg = <0xffc2502c 0x50>;
>>> >                                 interrupts = <0 39 4>;
>>> >                         };
>>> >                 };
>>> >
>>> > Then we can later add:
>>> >
>>> >                         sdr-ports: ports@ffc2507c {
>>> >                                 #reset-cells = <1>;
>>> >                                 compatible = "altr,sdr-ports";
>>> >                                 reg = <0xffc2507c 0x10>;
>>> >                                 clocks = <&ddr_dqs_clk>;
>>> >                                 ...
>>> >                         };
>>
>> --
>> Pengutronix e.K.                           |                             |
>> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
>> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
