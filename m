Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaF0AGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 20:06:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44732 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaF0AGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 20:06:03 -0400
Message-ID: <53ACB568.4000903@codeaurora.org>
Date: Thu, 26 Jun 2014 17:06:00 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
References: <cover.1403684824.git.viresh.kumar@linaro.org> <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org> <53AB1CC1.4010907@codeaurora.org> <CAKohpo=Q7eWNwcK6KF9_U-zD0g=96QHW9hiQupLpV5GqoWE+mA@mail.gmail.com>
In-Reply-To: <CAKohpo=Q7eWNwcK6KF9_U-zD0g=96QHW9hiQupLpV5GqoWE+mA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/14 03:52, Viresh Kumar wrote:
> On 26 June 2014 00:32, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> I don't think this driver should be using regulator_get_optional() (Mark
>> B. please correct me if I'm wrong). I doubt a supply is actually
>> optional for CPUs, just some DTs aren't specifying them. In those cases,
>> the regulator core will insert a dummy supply and the code will work
>> without having to check for probe defer and error pointers.
> Hi Stephen,
>
> Thanks for your comments.
>
> Leaving the above one, I have tried to fix all you mentioned. And it surely
> looks much better now.
>
> I would like to wait for a day or two before sending V2, as people might
> be reviewing it and the above issue is still wide open..
>
> But in case you wanna test it (completely changed I must say, but
> for good), its here:
>
> git://git.linaro.org/people/viresh.kumar/linux.git cpufreq/cpu0-krait-v2

I gave it a spin. It looks mostly good except for the infinite loop:

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index b7ee67c4d1c0..6744321ae33d 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -138,8 +138,10 @@ try_again:
                }
 
                /* Try with "cpu-supply" */
-               if (reg == reg_cpu0)
+               if (reg == reg_cpu0) {
+                       reg = reg_cpu;
                        goto try_again;
+               }
 
                dev_warn(cpu_dev, "failed to get cpu%d regulator: %ld\n",
                         cpu, PTR_ERR(cpu_reg));

and I think we just want reg_cpu to be "cpu", not "cpu-supply" because I
think the regulator core adds in the "-supply" part already.

After fixing that I can get cpufreq going. I'm currently working on
populating the OPPs at runtime without relying on DT. So eventually I'll
need this patch:

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index b7ee67c4d1c0..6744321ae33d 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -239,11 +241,6 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
        }
 
        ret = of_init_opp_table(cpu_dev);
-       if (ret) {
-               dev_err(cpu_dev, "failed to init OPP table: %d\n", ret);
-               goto out_put_node;
-       }
-
        ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
        if (ret) {
                dev_err(cpu_dev, "failed to init cpufreq table: %d\n", ret);

which I hope is ok.

Finally, checking for equivalent pointers from clk_get() will work now,
but it isn't future-proof if/when the clock framework starts returning
dynamically allocated clock pointers for each clk_get() invocation.
Maybe we need a function in the common clock framework that tells us if
the clocks are the same either via DT or by taking two clock pointers?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

