Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaLSQRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:17:44 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33444 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaLSQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:17:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141218142205.GZ11764@sirena.org.uk>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
	<1414729631-11005-5-git-send-email-tharvey@gateworks.com>
	<CAOMZO5DzEe91pTv+UkCbj0DzgVDOb9hjuakt9NmpTJnEk-j8UA@mail.gmail.com>
	<CAJ+vNU3PQYCE4tABUiqU+vGkGqBEqdVKz25W88-ByOQZxunVLw@mail.gmail.com>
	<20141218142205.GZ11764@sirena.org.uk>
Date: Fri, 19 Dec 2014 08:17:41 -0800
Message-ID: <CAJ+vNU1YQWGFaEm8w8wtaFvUy1jig26jW3+3teMFHLB_oFyn8Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] cpufreq: imx6q: add ldo-bypass support
From: Tim Harvey <tharvey@gateworks.com>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>, Anson.Huang@freescale.com,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 6:22 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Dec 18, 2014 at 06:11:15AM -0800, Tim Harvey wrote:
>> On Wed, Dec 17, 2014 at 6:36 AM, Fabio Estevam <festevam@gmail.com> wrote:
>> > On Fri, Oct 31, 2014 at 2:27 AM, Tim Harvey <tharvey@gateworks.com> wrote:
>> >> When an external PMIC is used for VDD_SOC and VDD_ARM you can save power by
>> >> bypassing the internal LDO's provided by the anantop regulator as long as
>> >> you are running less than 1.2GHz. If running at 1.2GHz the IMX6 datasheets
>> >> state that you must use the internal LDO's to reduce ripple on the suplies.
>> >>
>> >> A failure to bypass the LDO's when using an external PMIC will result in an
>> >> extra voltage drop (~125mV) between VDD_ARM_IN and VDD_ARM and VDD_SOC_IN and
>> >> VDD_SOC which violates the voltages specificed by the datasheets.
>
> This description doesn't make much sense - there must of course always
> be an external power source for the SoC and the discussion of bypassing
> also suggests that it's not just a case of disconnecting the internal
> LDOs.
>
>> What is needed is to determine if the cpu vddsoc and vddarm regulators
>> are both 'not' the same as the anatop provided regulators (then we
>> bypass the anatop regulators) so I need to do such a check after all
>> regulators are registered. Perhaps I need to have a late_init call (or
>> some other init call that happens after all regulators are
>> registered).
>
>> Phillipp/Mark - what are your thoughts here? Do the regulator core
>> functions regulator_is_same() [1] and regulator_is_bypass() [2] I
>> propose make sense to determine if regulators are the same and in
>> bypass mode and overcome the detection issues Phillipp discussed in a
>> previous thread [3]?
>
> Please provide a clear description of what's actually going on here.
> What does the hardware actually look like and what is being configured?
> You're telling me the solution you've decided on, not what the problem
> that this is supposed to solve is.

Mark,

I can embellish the description with more information. Does this
describe the issue better?

---

The IMX6 CPU family (IMX6S/IMX6DL/IMX6D/IMX6Q) have three CPU related
voltage rails: VDD_ARM (for the ARM core(s)), VDD_SOC (for the SoC
logic), and VDD_PU (for the GPU and VPU). All three of these have
voltage setpoints recommended by the datasheet which vary per CPU
frequency. They also all have internal LDO's (implemented via the
anantop voltage regulator) such that a board does not have to have a
complex PMIC with scalable voltages. The VDD_PU LDO is internally tied
to the VDD_SOC input. Therefore, there are two external power inputs
to the chip: VDD_ARM and VDD_SOC. When using a non scalable PMIC you
can provide VDD_ARM and VDD_SOC with a set voltage level specified by
the datasheet, and use the three internal LDO's inside the IMX6 to
adjust the three power rails down to the proper value per CPU
frequency setpoint. If however you have an external PMIC that is
capable of adjusting the VDD_ARM and VDD_SOC to the IMX6 and an
appropriate regulator driver is capable of doing so, you must
configure the cpu nodes vddarm and vddsoc regulators to those provided
by your PMIC and 'bypass' the internal LDO's by setting their scaling
value to full-scale (0x1f). Failure to place the internal LDO's in
'bypass mode' will result in a minimum of 125mV drop from the external
input to the internal voltage rail such that the CPU operating points
describing the voltage of the external inputs per CPU frequency will
not be properly met.

An additional benefit of using a PMIC with a regulator driver is that
you can save power regulating the voltage with a switching regulator
PMIC vs an inefficient LDO within the CPU. This also will help to move
thermal power out of the IMX6 and to your PMIC.

If running at 1.2GHz the IMX6 datasheets state that you must use the
internal LDO's to reduce ripple on the supplies.

----

Maybe Fabio has something to add? Perhaps this should go somewhere
under Documentation but I'm not clear where.

Tim
