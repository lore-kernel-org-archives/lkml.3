Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007AbaHVT3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:29:50 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64268 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaHVT3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:29:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Andrew Lunn <andrew@lunn.ch>, "Tomeu Vizoso" <tomeu.vizoso@collabora.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140821133825.GH8608@lunn.ch>
Cc: "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Tomasz Figa" <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        "Rabin Vincent" <rabin@rab.in>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408375833-10703-4-git-send-email-tomeu.vizoso@collabora.com>
 <20140820225513.5251.284@quantum> <53F5A587.9030200@collabora.com>
 <20140821133825.GH8608@lunn.ch>
Message-ID: <20140822192933.5251.53733@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v7 3/8] cpufreq: kirkwood: Remove use of the clk provider API
Date: Fri, 22 Aug 2014 12:29:33 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Lunn (2014-08-21 06:38:25)
> On Thu, Aug 21, 2014 at 09:53:43AM +0200, Tomeu Vizoso wrote:
> > On 08/21/2014 12:55 AM, Mike Turquette wrote:
> > >Quoting Tomeu Vizoso (2014-08-18 08:30:29)
> > >>Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> > >>---
> > >>  drivers/cpufreq/kirkwood-cpufreq.c | 3 +--
> > >>  1 file changed, 1 insertion(+), 2 deletions(-)
> > >>
> > >>diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
> > >>index 37a4806..f3d087f 100644
> > >>--- a/drivers/cpufreq/kirkwood-cpufreq.c
> > >>+++ b/drivers/cpufreq/kirkwood-cpufreq.c
> > >>@@ -12,7 +12,6 @@
> > >>  #include <linux/kernel.h>
> > >>  #include <linux/module.h>
> > >>  #include <linux/clk.h>
> > >>-#include <linux/clk-provider.h>
> > >>  #include <linux/cpufreq.h>
> > >>  #include <linux/of_device.h>
> > >>  #include <linux/platform_device.h>
> > >>@@ -50,7 +49,7 @@ static struct cpufreq_frequency_table kirkwood_freq_table[] = {
> > >>
> > >>  static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
> > >>  {
> > >>-       if (__clk_is_enabled(priv.powersave_clk))
> > >>+       if (clk_is_enabled(priv.powersave_clk))
> > >>                 return kirkwood_freq_table[1].frequency;
> > >>         return kirkwood_freq_table[0].frequency;
> > >>  }
> > >>--
> > >>1.9.3
> > >>
> > >
> > >Tomeu,
> > >
> > >After taking a second look at clk_is_enabled and the Kirkwood driver, I
> > >would prefer to not implement clk_is_enabled. The main reason is that it
> > >is racey, since the clock's status could of course change as soon as as
> > >that call completes. Furthermore I am worried that drivers might do
> > >something like:
> > >
> > >if (!clk_is_enabled(clk))
> > >     clk_enable(clk);
> > >
> > >Which is crap and the driver should just call clk_enable any time it
> > >needs the clock. To that end I propose to drop "clk: provide public
> > >clk_is_enabled function" and replace your update to kirkwood-cpufreq.c
> > >with the following patch. Let me know what you think.
> 
> Hi Mike, Tomeu
> 
> > >+static unsigned long cpu_frequency = 0;
> 
> 
> This has a problem. You are making an assumption about the initial
> state. The way the hardware works, is you change the state of the
> clock and then perform a Wait For Interrupt. Once the hardware has
> finished adjusting its PLL, it raises an interrupt and things
> continue.

Andrew,

Thanks for reviewing. I think my patch is equivalent to the old way of
doing things, with one exception that I will address later below.

struct cpufreq_frequency_table kirkwood_freq_table has clock rates
initialized to zero, so there is no regression compared to my unsigned
long cpu_frequency variable used for tracking the clock rate. Both
implementations start with unknown rates in hardware and initialize a
variable to zero until that rate can be discovered later on in
kirkwood_cpufreq_probe().

kirkwood_cpufreq_get_cpu_frequency() returns the frequency based on the
state of the clock. As best I can tell, this clock is only touched by
this cpufreq driver and nowhere else, so the driver knows the state of
the clock implicitly and doesn't need to read any hardware registers to
see if it is enabled or not. Every time we enable or disable the clock
we can know the cpu frequency.

> 
> However, if you don't cause an actual state change, the WFI never
> returns. If this assumption is wrong, your box is dead the first time
> it tries to change cpu frequency.

So if a state change in hardware never occurs, the cpu will not wake up?
That sounds like a bad situation but I do not understand how it relates
to the changes I made in the driver. Could you explain how tracking
cpu_frequency in the driver would result in the cpu not waking up from
wfi?

> 
> This is why the code reads the hardware register to find the real
> current state, rather than assume it.

OK, so this is the point that I referenced above that needs to be
addressed. The *only* difference between my implementation and yours is
that you do read the enable bit on the powersave clock every time you
query the frequency. Note that this driver controls the state of the
powersave clock directly via calls to clk_enable & clk_disable.

Is there ever a case where hardware will change the state of the clock
behind our backs? If the driver calls clk_enable(priv.powersave_clk),
then is there ever a possibility that the clock will in fact be
disabled? Likewise if we disable the clock with a call to
clk_disable(priv.powersave_clk), is there ever an instance where the
hardware will re-enable that clock without telling us? Can the driver's
view of the clock status be out of sync with the actual hardware?

Thanks,
Mike

> 
>         Andrew
> 
> > >+
> > >  /*
> > >   * Kirkwood can swap the clock to the CPU between two clocks:
> > >   *
> > >@@ -50,9 +51,7 @@ static struct cpufreq_frequency_table kirkwood_freq_table[] = {
> > >
> > >  static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
> > >  {
> > >-    if (__clk_is_enabled(priv.powersave_clk))
> > >-            return kirkwood_freq_table[1].frequency;
> > >-    return kirkwood_freq_table[0].frequency;
> > >+    return cpu_frequency;
> > >  }
> > >
> > >  static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
> > >@@ -71,9 +70,11 @@ static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
> > >     switch (state) {
> > >     case STATE_CPU_FREQ:
> > >             clk_disable(priv.powersave_clk);
> > >+            cpu_frequency = kirkwood_freq_table[0].frequency;
> > >             break;
> > >     case STATE_DDR_FREQ:
> > >             clk_enable(priv.powersave_clk);
> > >+            cpu_frequency = kirkwood_freq_table[1].frequency;
> > >             break;
> > >     }
> > >
> > >@@ -133,6 +134,7 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
> > >
> > >     clk_prepare_enable(priv.cpu_clk);
> > >     kirkwood_freq_table[0].frequency = clk_get_rate(priv.cpu_clk) / 1000;
> > >+    cpu_frequency = kirkwood_freq_table[0].frequency;
> > >
> > >     priv.ddr_clk = of_clk_get_by_name(np, "ddrclk");
> > >     if (IS_ERR(priv.ddr_clk)) {
> > >
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
