Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3KFCPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:15:23 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:54631 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3KFCPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:15:21 -0500
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Wed, 06 Nov 2013 10:15:15 +0800
From: Rongjun Ying <Rongjun.Ying@csr.com>
To: Shawn Guo <shawn.guo@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>
CC: rjying <rjying@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "rongjun.ying@gcsr.com" <rongjun.ying@gcsr.com>
Subject: RE: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage instead
 of voltage-tolerance
Thread-Topic: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage instead
 of voltage-tolerance
Thread-Index: AQHO2dSzt4p89ClR/0iIszhVSF2c8ZoVh94AgAB5jYCAAXZxwA==
Date: Wed, 6 Nov 2013 02:15:07 +0000
Message-ID: <86130EF012BDF348AA0D464A4F44947801295423DF@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1383621014-11202-1-git-send-email-rongjun.ying@csr.com>
 <CAKohpo=qR5WD=5VjGmeRraQ+_m5NUn8xiP5Z_ZuZWLv1hNx5KA@mail.gmail.com>
 <20131105115307.GN19770@S2101-09.ap.freescale.net>
In-Reply-To: <20131105115307.GN19770@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.5.123]
MIME-Version: 1.0
Content-Language: zh-CN
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Shawn Guo [mailto:shawn.guo@linaro.org]
> Sent: Tuesday, November 05, 2013 7:53 PM
> To: Viresh Kumar
> Cc: rjying; Rafael J. Wysocki; cpufreq@vger.kernel.org; linux-
> pm@vger.kernel.org; Linux Kernel Mailing List; rongjun.ying@gcsr.com;
> Rongjun Ying
> Subject: Re: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage
> instead of voltage-tolerance
> 
> On Tue, Nov 05, 2013 at 10:08:06AM +0530, Viresh Kumar wrote:
> > Adding shawn in cc list..
> >
> > On 5 November 2013 08:40, rjying <rjying@gmail.com> wrote:
> > > From: Rongjun Ying <rongjun.ying@csr.com>
> > >
> > > Sometime the regulator can't supply appropriate voltages for
> requestion of cpu.
> > > All voltage tolerance value can't figure out a good voltage.
> 
> The voltage-tolerance is an optional device tree property.  You can
> omit it if you do not have a value for it.
> 
> Shawn

It bounced for some reason, trying to send again.

If omit voltage-tolerance, sometimes also can't get appropriate voltages.
For example:
If the regulator IC only can supply min voltage is 1.000V and max voltage is 1.200V, and cpu work max voltage is 1.200V.
But the cpu just need 1.100V when cpu run under a freq.
So regulator_set_voltage_tol will return failed. 
Because the regulator_set_voltage will invoke with min-uV is 1100000 and max-uV is 1100000 parameters.
Regulator can't supply it.
As this case, the regulator just need supply 1.200V.

RongJun Ying
> 
> > >
> > > Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> > > ---
> > >  drivers/cpufreq/cpufreq-cpu0.c |   17 ++++++++++-------
> > >  1 files changed, 10 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/cpufreq/cpufreq-cpu0.c
> > > b/drivers/cpufreq/cpufreq-cpu0.c index c522a95..0c9e6b9 100644
> > > --- a/drivers/cpufreq/cpufreq-cpu0.c
> > > +++ b/drivers/cpufreq/cpufreq-cpu0.c
> > > @@ -23,7 +23,7 @@
> > >  #include <linux/slab.h>
> > >
> > >  static unsigned int transition_latency; -static unsigned int
> > > voltage_tolerance; /* in percentage */
> > > +static unsigned int voltage_max;
> > >
> > >  static struct device *cpu_dev;
> > >  static struct clk *cpu_clk;
> > > @@ -45,7 +45,7 @@ static int cpu0_set_target(struct cpufreq_policy
> > > *policy,  {
> > >         struct cpufreq_freqs freqs;
> > >         struct opp *opp;
> > > -       unsigned long volt = 0, volt_old = 0, tol = 0;
> > > +       unsigned long volt = 0, volt_old = 0;
> > >         long freq_Hz, freq_exact;
> > >         unsigned int index;
> > >         int ret;
> > > @@ -82,7 +82,6 @@ static int cpu0_set_target(struct cpufreq_policy
> *policy,
> > >                 }
> > >                 volt = opp_get_voltage(opp);
> > >                 rcu_read_unlock();
> > > -               tol = volt * voltage_tolerance / 100;
> > >                 volt_old = regulator_get_voltage(cpu_reg);
> > >         }
> > >
> > > @@ -92,7 +91,7 @@ static int cpu0_set_target(struct cpufreq_policy
> > > *policy,
> > >
> > >         /* scaling up?  scale voltage before frequency */
> > >         if (!IS_ERR(cpu_reg) && freqs.new > freqs.old) {
> > > -               ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
> > > +               ret = regulator_set_voltage(cpu_reg, volt,
> > > + voltage_max);
> > >                 if (ret) {
> > >                         pr_err("failed to scale voltage up: %d\n",
> ret);
> > >                         freqs.new = freqs.old; @@ -104,14 +103,14
> @@
> > > static int cpu0_set_target(struct cpufreq_policy *policy,
> > >         if (ret) {
> > >                 pr_err("failed to set clock rate: %d\n", ret);
> > >                 if (!IS_ERR(cpu_reg))
> > > -                       regulator_set_voltage_tol(cpu_reg, volt_old,
> tol);
> > > +                       regulator_set_voltage(cpu_reg, volt_old,
> > > + voltage_max);
> > >                 freqs.new = freqs.old;
> > >                 goto post_notify;
> > >         }
> > >
> > >         /* scaling down?  scale voltage after frequency */
> > >         if (!IS_ERR(cpu_reg) && freqs.new < freqs.old) {
> > > -               ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
> > > +               ret = regulator_set_voltage(cpu_reg, volt,
> > > + voltage_max);
> > >                 if (ret) {
> > >                         pr_err("failed to scale voltage down: %d\n",
> ret);
> > >                         clk_set_rate(cpu_clk, freqs.old * 1000); @@
> > > -224,7 +223,11 @@ static int cpu0_cpufreq_probe(struct
> platform_device *pdev)
> > >                 goto out_put_node;
> > >         }
> > >
> > > -       of_property_read_u32(np, "voltage-tolerance",
> &voltage_tolerance);
> > > +       ret = of_property_read_u32(np, "voltage-max", &voltage_max);
> > > +       if (ret) {
> > > +               pr_err("failed to get max voltage: %d\n", ret);
> > > +               goto out_put_node;
> > > +       }
> > >
> > >         if (of_property_read_u32(np, "clock-latency",
> &transition_latency))
> > >                 transition_latency = CPUFREQ_ETERNAL;
> > > --
> > > 1.7.5.4
> > >
> 
> 
> 
>  To report this email as spam click
> https://www.mailcontrol.com/sr/MZbqvYs5QwJvpeaetUwhCQ==
> X88IR7qi8t8XvyHQDjR!61qPoTyr8GNFXkv3KeH4!zzvzA== .


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
