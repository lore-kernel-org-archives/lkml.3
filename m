Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3LTGEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 01:04:53 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:27669
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab3LTGEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 01:04:50 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 20 Dec 2013 14:06:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: John Tobias <john.tobias.ph@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <rjw@rjwysocki.net>, <festevam@gmail.com>, <b20788@freescale.com>,
        <viresh.kumar@linaro.org>
Subject: Re: [PATCH v3 2/2] cpufreq: imx6q: add of_init_opp_table
Message-ID: <20131220060603.GO7172@S2101-09.ap.freescale.net>
References: <1387512929-7304-1-git-send-email-john.tobias.ph@gmail.com>
 <1387512929-7304-2-git-send-email-john.tobias.ph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387512929-7304-2-git-send-email-john.tobias.ph@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:15:29PM -0800, John Tobias wrote:
> Add a routine check to see if the platform supplied the OPP table.
> Incase there's not OPP table exist, it will try to get it.
> 
> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
> ---
>  drivers/cpufreq/imx6q-cpufreq.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
> index 4b3f18e..f261a88 100644
> --- a/drivers/cpufreq/imx6q-cpufreq.c
> +++ b/drivers/cpufreq/imx6q-cpufreq.c
> @@ -187,12 +187,25 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
>  		goto put_node;
>  	}
>  
> -	/* We expect an OPP table supplied by platform */
> +	/* We expect an OPP table supplied by platform.
> +	 * Just, incase the platform did not supply the OPP
> +	 * table, it will try to get it.
> +	 */

	/*
	 * Multi-lines comment
	 */

>  	num = dev_pm_opp_get_opp_count(cpu_dev);
>  	if (num < 0) {
> -		ret = num;
> -		dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
> -		goto put_node;
> +		ret = of_init_opp_table(cpu_dev);
> +		if (ret < 0) {
> +			dev_err(cpu_dev, "failed to init OPP table\n");

It should be good to print the error code, i.e. 'ret', here.

> +			ret = -ENODEV;

There is no need to make up an error code, and just return what you get
from of_init_opp_table().

Shawn

> +			goto put_node;
> +		}
> +
> +		num = dev_pm_opp_get_opp_count(cpu_dev);
> +		if (num < 0) {
> +			ret = num;
> +			dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
> +			goto put_node;
> +		}
>  	}
>  
>  	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
> -- 
> 1.8.3.2
> 

