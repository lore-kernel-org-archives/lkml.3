Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaJQJoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:44:03 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33243 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaJQJoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <20141015090047.GA26484@red-moon>
References: <1413354920-20165-1-git-send-email-k.chander@samsung.com>
	<20141015090047.GA26484@red-moon>
Date: Fri, 17 Oct 2014 15:13:59 +0530
X-Google-Sender-Auth: pCw75hJM0Lywm_IZ5d1ZV6vKfRI
Message-ID: <CADWw7Ojgttk3cjaac=GGL1D9pejCJw8sJB2JvPFWtyBh3JHYKA@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: exynos7: add support for cpuidle core power down
From: Chander Kashyap <k.chander@samsung.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Chander Kashyap <k.chander@samsung.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

On Wed, Oct 15, 2014 at 2:30 PM, Lorenzo Pieralisi
<lorenzo.pieralisi@arm.com> wrote:
> On Wed, Oct 15, 2014 at 07:35:20AM +0100, Chander Kashyap wrote:
>> Exynos7 has core power down state where cores can be powered off independently.
>> This patch adds support for this state.
>
> Please tell us more about the idle-state values you are adding, in particular
> entry, exit latencies and min-residency values.

Entry latency: This value is calculated as follows:

On entry to arm64_enter_idle_state:
timestamp1 = ktimeget();

after returning from cpu_suspend()

timestamp2 = ktimeget();

latency = timestamp2-timestamp1;

Cpu is not allowed to enter core powerdown by skipping wfi instruction at end.
Hence calculated time contains entry time + failure exit time.


Regarding
exit-latency and target-residency time, got these values from HW team.

I am using these as initial values and I will be working on optimizing
these values with further experiments.
If you could suggest any formal method of deriving these values, i can
try those methods as well.

>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> ---
>> This patch has following dependencies:
>>       - [PATCH v5 0/8] arch: arm64: Enable support for Samsung Exynos7 SoC
>>               http://www.spinics.net/lists/linux-samsung-soc/msg37047.html
>>       - [PATCH v9 0/8] ARM generic idle states
>>               http://permalink.gmane.org/gmane.linux.power-management.general/49224
>
> Series above was merged, so dependency is stale.

i will remove this

>
>>  arch/arm64/boot/dts/exynos/exynos7.dtsi |   18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)dont
>>
>> diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> index ce221ac..8e0a034 100644
>> --- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> +++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
>> @@ -36,6 +36,7 @@
>>                       device_type = "cpu";
>>                       compatible = "arm,cortex-a57", "arm,armv8";
>>                       enable-method = "psci";
>> +                     cpu-idle-states = <&CPU_SLEEP>;
>
> I would add cpu-idle-states phandle after the reg property, as defined
> in the idle states bindings.

i will move this after reg property.

>
>>                       reg = <0x0>;
>>               };
>>
>> @@ -43,6 +44,7 @@
>>                       device_type = "cpu";
>>                       compatible = "arm,cortex-a57", "arm,armv8";
>>                       enable-method = "psci";
>> +                     cpu-idle-states = <&CPU_SLEEP>;
>>                       reg = <0x1>;
>>               };
>>
>> @@ -50,6 +52,7 @@
>>                       device_type = "cpu";
>>                       compatible = "arm,cortex-a57", "arm,armv8";
>>                       enable-method = "psci";
>> +                     cpu-idle-states = <&CPU_SLEEP>;
>>                       reg = <0x2>;
>>               };
>>
>> @@ -57,8 +60,23 @@
>>                       device_type = "cpu";
>>                       compatible = "arm,cortex-a57", "arm,armv8";
>>                       enable-method = "psci";
>> +                     cpu-idle-states = <&CPU_SLEEP>;
>>                       reg = <0x3>;
>>               };
>> +
>> +             idle-states {
>> +                     entry-method = "arm,psci";
>> +
>> +                     CPU_SLEEP: cpu-sleep {
>> +                             compatible = "arm,idle-state";
>> +                             local-timer-stop;
>> +                             arm,psci-suspend-param = <0x0010000>;
>> +                             entry-latency-us = <20>;
>> +                             exit-latency-us = <150>;
>> +                             min-residency-us = <2100>;
>> +                             status = "enabled";
>
> status ? This is not a documented property. If you need it please explain
> why, define its bindings and we can see how to accommodate it.

I will add okay for status property. As per the bindings posted by you.

regards,
>
> Thank you,
> Lorenzo
>
>> +                     };
>> +             };
>>       };
>>
>>       psci {
>> --
>> 1.7.9.5
>>
>>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
