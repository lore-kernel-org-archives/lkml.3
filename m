Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaIHL4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:56:34 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:57098 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbaIHL4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:56:32 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <540D9A3F.2000807@smartplayin.com>
Date: Mon, 08 Sep 2014 17:29:59 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 00/15] Krait clocks + Krait CPUfreq
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org> <540D7A18.4030201@smartplayin.com>
In-Reply-To: <540D7A18.4030201@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Stephen for spaming.
I read the full patch cover letter and found your note. Somehow I missed
on that.

Thanks
Pramod
On Monday 08 September 2014 03:12 PM, Pramod Gurav wrote:
> Hi Stephen,
> Looks like one patch is missing from v1. Is this removed from v2
> patchset from some reason?
> 	ARM: Add Krait L2 register accessor functions
> 
> But there are references to this in v2 set and build fails while
> compiling drivers/clk/qcom/clk-krait.c.
> 
> Thanks and Regards
> Pramod
> 
> On Saturday 06 September 2014 04:17 AM, Stephen Boyd wrote:
>> These patches provide cpufreq scaling on devices with Krait CPUs.
>> In Krait CPU designs there's one PLL and two muxes per CPU, allowing
>> us to switch CPU frequencies independently.
>>
>> 				 secondary
>> 	 +-----+                    +
>> 	 | QSB |-------+------------|\
>> 	 +-----+       |            | |-+
>> 		       |    +-------|/  |
>> 		       |    |       +   |
>> 	 +-----+       |    |           |
>> 	 | PLL |----+-------+           |   primary
>> 	 +-----+    |  |                |     +
>> 		    |  |                +-----|\       +------+
>> 	 +-------+  |  |                      | \      |      |
>> 	 | HFPLL |----------+-----------------|  |-----| CPU0 |
>> 	 +-------+  |  |    |                 |  |     |      |
>> 		    |  |    | +-----+         | /      +------+
>> 		    |  |    +-| / 2 |---------|/
>> 		    |  |      +-----+         +
>> 		    |  |         secondary
>> 		    |  |            +
>> 		    |  +------------|\
>> 		    |               | |-+
>> 		    +---------------|/  |   primary
>> 				    +   |     +
>> 					+-----|\       +------+
>> 	 +-------+                            | \      |      |
>> 	 | HFPLL |----------------------------|  |-----| CPU1 |
>> 	 +-------+          |                 |  |     |      |
>> 			    | +-----+         | /      +------+
>> 			    +-| / 2 |---------|/
>> 			      +-----+         +
>>
>> To support this in the common clock framework we model the muxes,
>> dividers, and PLLs as different clocks. CPUfreq only interacts
>> with the primary mux (farthest right in the diagram). When CPUfreq
>> sets a rate, the mux code finds the best parent that can provide the rate.
>> Due to the design, QSB and the top PLL are always a fixed rate and thus
>> only support one frequency each. These sources provide the lowest
>> frequencies for the CPUs. The HFPLLs are where we can make the CPU go
>> faster (GHz range). Sometimes we need to run the HFPLL twice as
>> fast and divide it by two to get a particular frequency.
>>
>> When switching rates we can't leave the CPU clocked by the HFPLL because
>> we need to turn off the output of the PLL when changing its frequency.
>> This means we have to switch over to the secondary mux and use one of the
>> fixed sources. This is why we need something like the safe parent patch.
>>
>> I plan to submit the DTS changes through arm-soc, but I've included everything
>> here to make it easier to pick things up for testing, etc. Please note
>> that these patches rely on the Krait L2 accessor patch I posted a while back
>> in another series[1]. This also relies on the cpufreq-generic patchset from
>> Viresh[2]. If anything can be picked up right now it would be better
>> to reduce the churn over time as other pieces settle. The series gets
>> progressively more controversial as it goes on, so I hope that things
>> near the beggining will be picked up earlier.
>>
>> Changes since v1:
>>  * Added IPQ and APQ8064 support
>>  * Switched to cpufreq-generic
>>  * Added OPP parsing from DT (need to write binding though)
>>  * New patches to make clk-generic.c go away
>>   * Made mux and divider reusable for non-MMIO devices
>>   * Added a mux_determine_rate_closest (not sure if this is really needed)
>>   * Added unregistration of muxes
>>  * New patch to avoid sending high frequencies down to devices using clocks
>>
>> TODO:
>>  * Add Krait regulator voltage scaling (not strictly necessary)
>>  * Document DT bindings
>>  * Use a new efuse/eeprom API instead of hardcoding the location in the driver
>>  * Add some thermal awareness
>>
>>
>> Stephen Boyd (15):
>>   clk: mux: Add unregistration API
>>   clk: mux: Split out register accessors for reuse
>>   clk: Add __clk_mux_determine_rate_closest
>>   clk: divider: Make generic for usage elsewhere
>>   clk: Add safe switch hook
>>   clk: Avoid sending high rates to downstream clocks during set_rate
>>   clk: qcom: Add support for High-Frequency PLLs (HFPLLs)
>>   clk: qcom: Add HFPLL driver
>>   clk: qcom: Add MSM8960/APQ8064's HFPLLs
>>   clk: qcom: Add IPQ806X's HFPLLs
>>   clk: qcom: Add support for Krait clocks
>>   clk: qcom: Add KPSS ACC/GCC driver
>>   clk: qcom: Add Krait clock controller driver
>>   cpufreq: Add module to register cpufreq on Krait CPUs
>>   ARM: dts: qcom: Add necessary DT data for Krait cpufreq
>>
>>  arch/arm/boot/dts/qcom-apq8064.dtsi          | 230 +++++++++++++++++
>>  arch/arm/boot/dts/qcom-msm8960.dtsi          |  49 ++++
>>  arch/arm/boot/dts/qcom-msm8974.dtsi          | 311 ++++++++++++++++++++++-
>>  drivers/clk/clk-divider.c                    | 197 +++++++++------
>>  drivers/clk/clk-mux.c                        |  91 ++++---
>>  drivers/clk/clk.c                            | 133 +++++++---
>>  drivers/clk/qcom/Kconfig                     |  28 +++
>>  drivers/clk/qcom/Makefile                    |   5 +
>>  drivers/clk/qcom/clk-hfpll.c                 | 253 +++++++++++++++++++
>>  drivers/clk/qcom/clk-hfpll.h                 |  54 ++++
>>  drivers/clk/qcom/clk-krait.c                 | 166 +++++++++++++
>>  drivers/clk/qcom/clk-krait.h                 |  49 ++++
>>  drivers/clk/qcom/gcc-ipq806x.c               |  83 +++++++
>>  drivers/clk/qcom/gcc-msm8960.c               | 172 +++++++++++++
>>  drivers/clk/qcom/hfpll.c                     | 110 +++++++++
>>  drivers/clk/qcom/kpss-xcc.c                  |  94 +++++++
>>  drivers/clk/qcom/krait-cc.c                  | 357 +++++++++++++++++++++++++++
>>  drivers/cpufreq/Kconfig.arm                  |   9 +
>>  drivers/cpufreq/Makefile                     |   1 +
>>  drivers/cpufreq/qcom-cpufreq.c               | 199 +++++++++++++++
>>  include/dt-bindings/clock/qcom,gcc-msm8960.h |   2 +
>>  include/linux/clk-private.h                  |   2 +
>>  include/linux/clk-provider.h                 |  32 ++-
>>  23 files changed, 2486 insertions(+), 141 deletions(-)
>>  create mode 100644 drivers/clk/qcom/clk-hfpll.c
>>  create mode 100644 drivers/clk/qcom/clk-hfpll.h
>>  create mode 100644 drivers/clk/qcom/clk-krait.c
>>  create mode 100644 drivers/clk/qcom/clk-krait.h
>>  create mode 100644 drivers/clk/qcom/hfpll.c
>>  create mode 100644 drivers/clk/qcom/kpss-xcc.c
>>  create mode 100644 drivers/clk/qcom/krait-cc.c
>>  create mode 100644 drivers/cpufreq/qcom-cpufreq.c
>>
>> [1] http://lkml.iu.edu/hypermail/linux/kernel/1404.0/02636.html
>> [2] git://git.linaro.org/people/viresh.kumar/linux cpufreq/cpu0-krait-v3
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
