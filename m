Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaGBGIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:08:21 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:2397
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751983AbaGBGIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:08:19 -0400
Date: Wed, 2 Jul 2014 13:53:33 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@rjwysocki.net>, <linaro-kernel@lists.linaro.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arvind.chauhan@arm.com>, <sboyd@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>, <spk.linux@gmail.com>,
        <thomas.ab@samsung.com>, <nm@ti.com>, <t.figa@samsung.com>
Subject: Re: [PATCH 06/14] cpufreq: cpu0: defer probe if clock isn't
 registered yet
Message-ID: <20140702055330.GA3454@dragon>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
 <eb6df0f1f2c82db0d516b9b63820cfe0c0c97d5c.1404231535.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <eb6df0f1f2c82db0d516b9b63820cfe0c0c97d5c.1404231535.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130487540227838459;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(448002)(199002)(189002)(51704005)(24454002)(19580405001)(83322001)(46102001)(44976005)(31966008)(74662001)(50466002)(21056001)(97756001)(87936001)(77982001)(68736004)(97736001)(69596002)(99396002)(54356999)(79102001)(81542001)(50986999)(83506001)(85852003)(85326001)(76176999)(107046002)(33656002)(81156004)(6806004)(106466001)(19580395003)(46406003)(4396001)(57986006)(33716001)(84676001)(95666004)(104016002)(64706001)(81342001)(20776003)(26826002)(92566001)(85306003)(76482001)(80022001)(83072002)(23726002)(86362001)(74502001)(47776003)(102836001)(92726001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB009;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0260457E99
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 10:02:35PM +0530, Viresh Kumar wrote:
> Currently, we defer probe if regulator_get() returned -EPROBE_DEFER, i.e.
> regulator isn't registered yet.
> 
> The same is true for clock as well, so lets defer in that case as well.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq-cpu0.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 4273a5f..b5b8e1c 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -150,8 +150,17 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>  
>  	cpu_clk = clk_get(cpu_dev, NULL);
>  	if (IS_ERR(cpu_clk)) {
> -		ret = PTR_ERR(cpu_clk);

If you keep this ...

> -		pr_err("failed to get cpu0 clock: %d\n", ret);
> +		/*
> +		 * If cpu's clk node is present, but clock is not yet
> +		 * registered, we should try defering probe.
> +		 */
> +		if (PTR_ERR(cpu_clk) == -EPROBE_DEFER) {

... you can use 'ret' here ...

> +			dev_err(cpu_dev, "cpu0 clock not ready, retry\n");
> +			ret = -EPROBE_DEFER;

... this can be saved ...

> +		} else {
> +			ret = PTR_ERR(cpu_clk);

... and this as well.

Shawn

> +			dev_err(cpu_dev, "failed to get cpu0 clock: %d\n", ret);
> +		}
>  		goto out_put_reg;
>  	}
>  
> -- 
> 2.0.0.rc2
> 
