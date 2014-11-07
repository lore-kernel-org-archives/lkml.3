Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaKGFbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:31:40 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16715 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaKGFbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:31:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Nov 2014 21:30:39 -0800
Message-ID: <545C5927.3010001@nvidia.com>
Date: Fri, 7 Nov 2014 14:31:19 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/13] of: document new emc-timings subnode in nvidia,tegra124-car
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com> <1414599796-30597-5-git-send-email-tomeu.vizoso@collabora.com> <545B172C.4060105@nvidia.com> <CAL_JsqKYSF3JVrXH_dkqRXQrgUU3igzvoK1C2k1Caz-4UuHX6Q@mail.gmail.com>
In-Reply-To: <CAL_JsqKYSF3JVrXH_dkqRXQrgUU3igzvoK1C2k1Caz-4UuHX6Q@mail.gmail.com>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: HKMAIL104.nvidia.com (10.18.16.13) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 12:12 AM, Rob Herring wrote:
> On Thu, Nov 6, 2014 at 12:37 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
>>>
>>> The EMC clock needs some extra information for changing its rate.
>>>
>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>> ---
>>>    .../bindings/clock/nvidia,tegra124-car.txt         | 46
>>> +++++++++++++++++++++-
>>>    1 file changed, 44 insertions(+), 2 deletions(-)
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>> b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>> index ded5d62..42e0588 100644
>>> --- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>> +++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>> @@ -19,12 +19,35 @@ Required properties :
>>>      In clock consumers, this cell represents the bit number in the CAR's
>>>      array of CLK_RST_CONTROLLER_RST_DEVICES_* registers.
>>>
>>> +The node should contain a "emc-timings" subnode for each supported RAM
>>> type (see
>>> +field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address
>>> being its
>>> +RAM_CODE.
>>> +
>>> +Required properties for "emc-timings" nodes :
>>> +- nvidia,ram-code : Should contain the value of RAM_CODE this timing set
>>> +  is used for.
>>> +
>>> +Each "emc-timings" node should contain a "timing" subnode for every
>>> supported
>>> +EMC clock rate. The "timing" subnodes should have the clock rate in Hz as
>>> their
>>> +unit address.
>>
>>
>> This seems to be a quite liberal use of unit addresses (same in the next
>> patch) - is this allowed by DT?
>
> No, unit address should match a reg property.

Mmm, would you have any suggestion as to how this can be fixed? Right 
now what I can think of is either to replace the "clock-frequency" 
property by "reg" (which would be confusing), or to use a different 
naming scheme, e.g. timing-12750000. IIUC the naming is not essential 
for properly parsing these nodes, so maybe the second solution is the 
way to go?

>
>>> +
>>> +Required properties for "timing" nodes :
>>> +- clock-frequency : Should contain the memory clock rate to which this
>>> timing
>>> +relates.
>>> +- nvidia,parent-clock-frequency : Should contain the rate at which the
>>> current
>>> +parent of the EMC clock should be running at this timing.
>>> +- clocks : Must contain an entry for each entry in clock-names.
>>> +  See ../clocks/clock-bindings.txt for details.
>>> +- clock-names : Must include the following entries:
>>> +  - emc-parent : the clock that should be the parent of the EMC clock at
>>> this
>>> +timing.
>>> +
>>>    Example SoC include file:
>>>
>>>    / {
>>> -       tegra_car: clock {
>>> +       tegra_car: clock@0,60006000 {
>
> The comma here is wrong. Commas should be used when you have something
> like PCI bus:dev:func for addressing.
>
>>>                  compatible = "nvidia,tegra124-car";
>>> -               reg = <0x60006000 0x1000>;
>>> +               reg = <0x0 0x60006000 0x0 0x1000>;
>
> The number of cell's is really irrelevant to the example.
>
>>>                  #clock-cells = <1>;
>>>                  #reset-cells = <1>;
>>>          };
>>> @@ -60,4 +83,23 @@ Example board file:
>>>          &tegra_car {
>>>                  clocks = <&clk_32k> <&osc>;
>>>          };
>>> +
>>> +       clock@0,60006000 {
>>> +               emc-timings@3 {
>>> +                       nvidia,ram-code = <3>;
>>> +
>>> +                       timing@12750000 {
>>> +                               clock-frequency = <12750000>;
>>> +                               nvidia,parent-clock-frequency =
>>> <408000000>;
>>> +                               clocks = <&tegra_car TEGRA124_CLK_PLL_P>;
>>> +                               clock-names = "emc-parent";
>
> Why do you need both clocks and hardcoded values? clock-frequency is
> the desired freq you want to set TEGRA124_CLK_PLL_P to?

That would be nvidia,parent-clock-frequency IIUC, while clock-frequency 
is the resulting EMC clock.

>
> The clocks property really belongs as part of the memory controller
> node or a memory device node.

I would tend to agree here. Tomeu, does it make sense to move these 
properties to the EMC driver instead?
