Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKFPMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:12:39 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55781 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKFPMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:12:36 -0500
MIME-Version: 1.0
In-Reply-To: <545B172C.4060105@nvidia.com>
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414599796-30597-5-git-send-email-tomeu.vizoso@collabora.com> <545B172C.4060105@nvidia.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 6 Nov 2014 09:12:13 -0600
Message-ID: <CAL_JsqKYSF3JVrXH_dkqRXQrgUU3igzvoK1C2k1Caz-4UuHX6Q@mail.gmail.com>
Subject: Re: [PATCH v3 04/13] of: document new emc-timings subnode in nvidia,tegra124-car
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
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

On Thu, Nov 6, 2014 at 12:37 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
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

No, unit address should match a reg property.

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

The comma here is wrong. Commas should be used when you have something
like PCI bus:dev:func for addressing.

>>                 compatible = "nvidia,tegra124-car";
>> -               reg = <0x60006000 0x1000>;
>> +               reg = <0x0 0x60006000 0x0 0x1000>;

The number of cell's is really irrelevant to the example.

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

Why do you need both clocks and hardcoded values? clock-frequency is
the desired freq you want to set TEGRA124_CLK_PLL_P to?

The clocks property really belongs as part of the memory controller
node or a memory device node.

Rob
