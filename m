Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab3EBLtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 07:49:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54981 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354Ab3EBLty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 07:49:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, nm@ti.com
Subject: Re: [PATCH] cpufreq: cpu0: Free parent node for error cases
Date: Thu, 02 May 2013 13:58:09 +0200
Message-ID: <2882677.ddYllFuZlK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130502024849.GF3442@S2101-09.ap.freescale.net>
References: <ad5f8a25684dbdd6fcb385fb420da0b4709e7392.1367384647.git.viresh.kumar@linaro.org> <20130502024849.GF3442@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 02, 2013 10:48:50 AM Shawn Guo wrote:
> On Wed, May 01, 2013 at 10:34:43AM +0530, Viresh Kumar wrote:
> > We are freeing parent node in success cases but not in failure cases. Lets do
> > it.
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  drivers/cpufreq/cpufreq-cpu0.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> > index 3ab8294..c025714 100644
> > --- a/drivers/cpufreq/cpufreq-cpu0.c
> > +++ b/drivers/cpufreq/cpufreq-cpu0.c
> > @@ -189,7 +189,8 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
> >  
> >  	if (!np) {
> >  		pr_err("failed to find cpu0 node\n");
> > -		return -ENOENT;
> > +		ret = -ENOENT;
> > +		goto out_put_parent;
> >  	}
> >  
> >  	cpu_dev = &pdev->dev;
> > @@ -199,7 +200,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
> >  	if (IS_ERR(cpu_clk)) {
> >  		ret = PTR_ERR(cpu_clk);
> >  		pr_err("failed to get cpu0 clock: %d\n", ret);
> > -		goto out_put_node;
> > +		goto out_put_np;
> >  	}
> >  
> >  	cpu_reg = devm_regulator_get(cpu_dev, "cpu0");
> > @@ -211,13 +212,13 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
> >  	ret = of_init_opp_table(cpu_dev);
> >  	if (ret) {
> >  		pr_err("failed to init OPP table: %d\n", ret);
> > -		goto out_put_node;
> > +		goto out_put_np;
> >  	}
> >  
> >  	ret = opp_init_cpufreq_table(cpu_dev, &freq_table);
> >  	if (ret) {
> >  		pr_err("failed to init cpufreq table: %d\n", ret);
> > -		goto out_put_node;
> > +		goto out_put_np;
> >  	}
> >  
> >  	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
> > @@ -262,8 +263,10 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
> >  
> >  out_free_table:
> >  	opp_free_cpufreq_table(cpu_dev, &freq_table);
> > -out_put_node:
> > +out_put_np:
> 
> Unnecessary renaming brings unnecessary diffstat?

Yeah, I'd prefer only changes that are essential here.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
