Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaKGLfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:35:53 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:38475 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaKGLfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:35:48 -0500
Message-ID: <545CAE72.4000308@kapsi.fi>
Date: Fri, 07 Nov 2014 13:35:14 +0200
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Rob Herring <robherring2@gmail.com>
CC: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
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
Subject: Re: [PATCH v3 04/13] of: document new emc-timings subnode in nvidia,tegra124-car
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com> <1414599796-30597-5-git-send-email-tomeu.vizoso@collabora.com> <545B172C.4060105@nvidia.com> <CAL_JsqKYSF3JVrXH_dkqRXQrgUU3igzvoK1C2k1Caz-4UuHX6Q@mail.gmail.com> <545C5927.3010001@nvidia.com>
In-Reply-To: <545C5927.3010001@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To better facilitate discussion, here's an outline of how the driver works:

emc_set_rate (CAR) gets called
   The current timing (= rate,parent pair) is checked along with the
     target timing.
   If the target timing has the same clock source (~parent, see
     emc_parent_clk_sources in the clk driver), find a timing with a
     different clock source. This is to prevent a situation where we
     have switched to a new parent rate but the EMC has not yet been
     reprogrammed. This new timing is called a backup timing.
   If a backup timing was required, switch to it (using this same
     procedure).
   Set the rate of the new parent to the required rate and enable it. It
     is important to use the correct parent for each timing, since in
     addition to the rate requirements, there are jitter requirements.
     The specified timings have been verified by a hardware team.
   Call tegra_emc_prepare_timing_change. This does assorted things to
     prepare the EMC block for a timing change and also tells the MC
     driver to prepare for it.
   Prepare the value that will be written to CLK_SOURCE_EMC in the CAR
     block. This value contains the divisor to get from the parent rate
     to the EMC rate and specifies the parent clock to use.
   Write the value. This must be done in a single write, as it starts a
     state machine that uses the written value.
   Call tegra_emc_complete_timing_change. This will lead the state
     machine to completion.
   Tell CCF that our parent is now the specified one.
   Disable the old parent.

Note that information about the parent is only needed within the CAR 
driver and not in EMC or MC.
Those drivers only need to map the EMC rate to a set of configuration 
values.

If the parent clock information is moved under the EMC node, we have 
some options:
a) Add API to EMC that the CAR driver can use to query the parent 
information.
b) Add API to CAR that the EMC driver can use to write the rate and 
parent information.
c) Other?

Cheers,
Mikko.

On 11/07/2014 07:31 AM, Alexandre Courbot wrote:
> On 11/07/2014 12:12 AM, Rob Herring wrote:
>> On Thu, Nov 6, 2014 at 12:37 AM, Alexandre Courbot
>> <acourbot@nvidia.com> wrote:
>>> On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
>>>>
>>>> The EMC clock needs some extra information for changing its rate.
>>>>
>>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>> ---
>>>>    .../bindings/clock/nvidia,tegra124-car.txt         | 46
>>>> +++++++++++++++++++++-
>>>>    1 file changed, 44 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>>> b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>>> index ded5d62..42e0588 100644
>>>> --- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>>> +++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
>>>> @@ -19,12 +19,35 @@ Required properties :
>>>>      In clock consumers, this cell represents the bit number in the
>>>> CAR's
>>>>      array of CLK_RST_CONTROLLER_RST_DEVICES_* registers.
>>>>
>>>> +The node should contain a "emc-timings" subnode for each supported RAM
>>>> type (see
>>>> +field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address
>>>> being its
>>>> +RAM_CODE.
>>>> +
>>>> +Required properties for "emc-timings" nodes :
>>>> +- nvidia,ram-code : Should contain the value of RAM_CODE this
>>>> timing set
>>>> +  is used for.
>>>> +
>>>> +Each "emc-timings" node should contain a "timing" subnode for every
>>>> supported
>>>> +EMC clock rate. The "timing" subnodes should have the clock rate in
>>>> Hz as
>>>> their
>>>> +unit address.
>>>
>>>
>>> This seems to be a quite liberal use of unit addresses (same in the next
>>> patch) - is this allowed by DT?
>>
>> No, unit address should match a reg property.
>
> Mmm, would you have any suggestion as to how this can be fixed? Right
> now what I can think of is either to replace the "clock-frequency"
> property by "reg" (which would be confusing), or to use a different
> naming scheme, e.g. timing-12750000. IIUC the naming is not essential
> for properly parsing these nodes, so maybe the second solution is the
> way to go?
>
>>
>>>> +
>>>> +Required properties for "timing" nodes :
>>>> +- clock-frequency : Should contain the memory clock rate to which this
>>>> timing
>>>> +relates.
>>>> +- nvidia,parent-clock-frequency : Should contain the rate at which the
>>>> current
>>>> +parent of the EMC clock should be running at this timing.
>>>> +- clocks : Must contain an entry for each entry in clock-names.
>>>> +  See ../clocks/clock-bindings.txt for details.
>>>> +- clock-names : Must include the following entries:
>>>> +  - emc-parent : the clock that should be the parent of the EMC
>>>> clock at
>>>> this
>>>> +timing.
>>>> +
>>>>    Example SoC include file:
>>>>
>>>>    / {
>>>> -       tegra_car: clock {
>>>> +       tegra_car: clock@0,60006000 {
>>
>> The comma here is wrong. Commas should be used when you have something
>> like PCI bus:dev:func for addressing.
>>
>>>>                  compatible = "nvidia,tegra124-car";
>>>> -               reg = <0x60006000 0x1000>;
>>>> +               reg = <0x0 0x60006000 0x0 0x1000>;
>>
>> The number of cell's is really irrelevant to the example.
>>
>>>>                  #clock-cells = <1>;
>>>>                  #reset-cells = <1>;
>>>>          };
>>>> @@ -60,4 +83,23 @@ Example board file:
>>>>          &tegra_car {
>>>>                  clocks = <&clk_32k> <&osc>;
>>>>          };
>>>> +
>>>> +       clock@0,60006000 {
>>>> +               emc-timings@3 {
>>>> +                       nvidia,ram-code = <3>;
>>>> +
>>>> +                       timing@12750000 {
>>>> +                               clock-frequency = <12750000>;
>>>> +                               nvidia,parent-clock-frequency =
>>>> <408000000>;
>>>> +                               clocks = <&tegra_car
>>>> TEGRA124_CLK_PLL_P>;
>>>> +                               clock-names = "emc-parent";
>>
>> Why do you need both clocks and hardcoded values? clock-frequency is
>> the desired freq you want to set TEGRA124_CLK_PLL_P to?
>
> That would be nvidia,parent-clock-frequency IIUC, while clock-frequency
> is the resulting EMC clock.
>
>>
>> The clocks property really belongs as part of the memory controller
>> node or a memory device node.
>
> I would tend to agree here. Tomeu, does it make sense to move these
> properties to the EMC driver instead?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

