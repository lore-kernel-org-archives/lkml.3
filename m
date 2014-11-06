Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaKFJLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:11:34 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54063 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKFJLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <545B172C.4060105@nvidia.com>
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414599796-30597-5-git-send-email-tomeu.vizoso@collabora.com> <545B172C.4060105@nvidia.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Thu, 6 Nov 2014 10:11:00 +0100
X-Google-Sender-Auth: 7NL0KwSk-Mxn5DvTsTeXW-x1D8g
Message-ID: <CAAObsKBe8kigKfEs_ER+1X5fqLw3dZD69XHicEn4cVuQTyoFAw@mail.gmail.com>
Subject: Re: [PATCH v3 04/13] of: document new emc-timings subnode in nvidia,tegra124-car
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 November 2014 07:37, Alexandre Courbot <acourbot@nvidia.com> wrote:
> On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
>>
>> The EMC clock needs some extra information for changing its rate.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>>   .../bindings/clock/nvidia,tegra124-car.txt         | 46
>> +++++++++++++++++++++-
>>   1 file changed, 44 insertions(+), 2 deletions(-)
>>
>> diff --git
>> a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>> b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>> index ded5d62..42e0588 100644
>> --- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>> +++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>> @@ -19,12 +19,35 @@ Required properties :
>>     In clock consumers, this cell represents the bit number in the CAR's
>>     array of CLK_RST_CONTROLLER_RST_DEVICES_* registers.
>>
>> +The node should contain a "emc-timings" subnode for each supported RAM
>> type (see
>> +field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address
>> being its
>> +RAM_CODE.
>> +
>> +Required properties for "emc-timings" nodes :
>> +- nvidia,ram-code : Should contain the value of RAM_CODE this timing set
>> +  is used for.
>> +
>> +Each "emc-timings" node should contain a "timing" subnode for every
>> supported
>> +EMC clock rate. The "timing" subnodes should have the clock rate in Hz as
>> their
>> +unit address.
>
>
> This seems to be a quite liberal use of unit addresses (same in the next
> patch) - is this allowed by DT?

Well, it's not that different from using the register address. I think
it helps with readability more than an arbitrary index.

>> +
>> +Required properties for "timing" nodes :
>> +- clock-frequency : Should contain the memory clock rate to which this
>> timing
>> +relates.
>> +- nvidia,parent-clock-frequency : Should contain the rate at which the
>> current
>> +parent of the EMC clock should be running at this timing.
>> +- clocks : Must contain an entry for each entry in clock-names.
>> +  See ../clocks/clock-bindings.txt for details.
>> +- clock-names : Must include the following entries:
>> +  - emc-parent : the clock that should be the parent of the EMC clock at
>> this
>> +timing.
>> +
>>   Example SoC include file:
>>
>>   / {
>> -       tegra_car: clock {
>> +       tegra_car: clock@0,60006000 {
>>                 compatible = "nvidia,tegra124-car";
>> -               reg = <0x60006000 0x1000>;
>> +               reg = <0x0 0x60006000 0x0 0x1000>;
>>                 #clock-cells = <1>;
>>                 #reset-cells = <1>;
>>         };
>> @@ -60,4 +83,23 @@ Example board file:
>>         &tegra_car {
>>                 clocks = <&clk_32k> <&osc>;
>>         };
>> +
>> +       clock@0,60006000 {
>> +               emc-timings@3 {
>> +                       nvidia,ram-code = <3>;
>> +
>> +                       timing@12750000 {
>> +                               clock-frequency = <12750000>;
>> +                               nvidia,parent-clock-frequency =
>> <408000000>;
>> +                               clocks = <&tegra_car TEGRA124_CLK_PLL_P>;
>> +                               clock-names = "emc-parent";
>> +                       };
>> +                       timing@20400000 {
>> +                               clock-frequency = <20400000>;
>> +                               nvidia,parent-clock-frequency =
>> <408000000>;
>> +                               clocks = <&tegra_car TEGRA124_CLK_PLL_P>;
>> +                               clock-names = "emc-parent";
>> +                       };
>> +               };
>> +       };
>
>
> At first it seems confusing to see a top-level node without a compatible
> property, until you realize it has already been defined before.
>
> In patch 05, you put "Example board file:" above a similar node, which is
> enough to lift that ambiguity - could you do the same here?

Oh, actually it was already in the file. I took this idea from here
for patch 05.

Thanks,

Tomeu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
