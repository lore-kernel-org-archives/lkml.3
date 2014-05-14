Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaENXSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:18:00 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41990 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaENXR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:17:57 -0400
Message-ID: <5373F9A0.6000702@gmail.com>
Date: Thu, 15 May 2014 01:17:52 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Mike Turquette <mturquette@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] clk: berlin: add clock binding docs for Marvell Berlin2
 SoCs
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com> <1399839881-29895-3-git-send-email-sebastian.hesselbarth@gmail.com> <20140514223230.19795.63328@quantum>
In-Reply-To: <20140514223230.19795.63328@quantum>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 12:32 AM, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2014-05-11 13:24:35)
>> This adds mandatory device tree binding documentation for the clock related
>> IP found on Marvell Berlin2 (BG2, BG2CD, and BG2Q) SoCs.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  .../devicetree/bindings/clock/berlin2-clock.txt    | 169 +++++++++++++++++++++
>>  1 file changed, 169 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/clock/berlin2-clock.txt
>>
>> diff --git a/Documentation/devicetree/bindings/clock/berlin2-clock.txt b/Documentation/devicetree/bindings/clock/berlin2-clock.txt
>> new file mode 100644
>> index 000000000000..3da87a488402
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/berlin2-clock.txt
>> @@ -0,0 +1,169 @@
>> +* Marvell Berlin2 clock bindings
>> +
>> +Marvell Berlin2 (BG2, BG2CD, BG2Q) share the same IP for PLLs and clocks,
>> +with some minor differences in features and register layout. The below
>> +describes the individual clock related IP:
>> +
>> +* Audio/Video PLL
>> +
>> +The Audio/Video PLL (AVPLL) is a dual-VCO PLL with 8 channels each. Each
>> +of the VCOs can sythesize a single VCO frequency based on a single input
>> +reference clock. Each of the 8 channels then, can derive an output clock
>> +from that VCO frequency by various dividers/multipliers.
>> +
>> +Required properties:
>> +- compatible: shall be "marvell,berlin2-avpll"
>> +- reg: address and length of the corresponding AVPLL registers
>> +- #clock-cells: shall be set to 2
>> +- clocks: single clock specifier referencing the AVPLL input clock
>> +
>> +To ease match-up with the desired AVPLL output clock, clock specifiers
>> +referencing AVPLL clocks shall contain two cells. The first refers to
>> +the VCO (0=AVPLL_A, 1=AVPLL_B) while the second refers to the corresponding
>> +channel starting with 1. For example, to reference AVPLL_B3 the clock
>> +specifier shall be: <&avpll 1 3>.
>> +
>> +Example:
>> +
>> +avpll: pll@ea0040 {
>> +       compatible = "marvell,berlin2-avpll";
>> +       #clock-cells = <2>;
>> +       reg = <0xea0050 0x100>;
>> +       clocks = <&refclk>;
>> +};
> 
> Thanks for submitting the series. It looks good. I do have some comments
> about the DT bindings though. I'm encouraging new bindings (and
> especially new platforms or existing platforms that are only now
> converting over to CCF) to not put their per-clock data into DTS. This
> has scalability problems, is unpopular with the DT crowd and sometimes
> makes it hard to do things like set CLK_SET_RATE_PARENT flags for
> individual clocks.

Ok, so you are proposing the have a single node for all the SoCs
internal plls and clocks. The individual SoCs will have to deal
with the differences in a single driver, right?

> The following is a copy/paste from an email I sent earlier today[1]. Of
> course per-clock data makes great sense if you have an off-SoC clock
> such as a fixed-rate oscillator (e.g. the fixed-clock binding). Let me
> know what you think:
[...]
> Using this type of binding you only need to declare your clock generator
> IP node in dts, and then define a mapping in the DT include chroot. Then
> you can define your per-clock data inside of your clock driver instead
> of putting all of the details inside of DT.
> 
> If you have a strong reason to do it the way that you originally posted
> then let me know.

Actually, the intermediate patch set sent before this one had a single
DT clock node. The most important draw-back of a single clock node
is that Berlin's global registers are more like a register dumpster.
Vital other registers, e.g. reset, are intermixed with clock registers.

Given the lack of public datasheets (I look everything up in some
auto-generated BSP includes), I like the current approach because it
helps to get in at least some structure to the register mess ;)

Considering the postponed of_clk_create_name() helper, that would allow
us to remove at least the names from DT again. Another option would be
a syscon node for the registers, that clk, reset, pinctrl drivers can
access. But IIRC early syscon support isn't settled, yet?

So, my current idea is:
- take this as is, stabilize berlin branches for v3.16
- review of_clk_create_name() and of_clk_get_parent_name() to allow
  to remove clock-output-names properties from Berlin (and other) dtsis
- maybe switch to early syscon if it is available in v3.16

I know this would likely break DT ABI policy, but hey who else boots
mainline Linux on his Chromecast currently except me :P

Is that okay with you (and DT folks)?

Sebastian
