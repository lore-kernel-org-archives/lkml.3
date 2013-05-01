Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428Ab3EAPEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:04:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40697 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab3EAPEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:04:15 -0400
Date: Wed, 1 May 2013 10:04:03 -0500
From: Nishanth Menon <nm@ti.com>
To: <Sudeep.KarkadaNagesha@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Shawn Guo <shawn.guo@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 2/2] PM / OPP: check for existing OPP list when
 initialising from device tree
Message-ID: <20130501150403.GA20488@kahuna>
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1367406679-21603-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367406679-21603-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:11-20130501, Sudeep.KarkadaNagesha@arm.com wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> CPUs are registered as devices and their OPPs can be initialised from
> the device tree. Whenever CPUs can be hotplugged out, the corresponding
> cpu devices are not removed. As a result all their OPPs remain intact
> even when they are offlined.
> 
> But when they are hotplugged back-in, the cpufreq along with other cpu
> related subsystem gets re-initialised. Since its almost same as secondary
> cpu being brought up, no special consideration is taken in the hotplug
> path. As a result of this the cpufreq will try to initialise the OPPs
> again though the cpu device already contains the OPPs.
> 
> This patch checks if there exist an OPP list associated with the device,
> before attempting to initialise it.
> 
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  drivers/base/power/opp.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 4dfdc01..66d52d2 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -706,6 +706,11 @@ static int of_init_opp_table_from_ofnode(struct device *dev,
>  	const __be32 *val;
>  	int nr;
>  
> +	/* Check for existing list for 'dev' */
> +	dev_opp = find_device_opp(dev);
> +	if (!IS_ERR(dev_opp))
> +		return 0; /* Device OPP already initialized */
> +
It gets a little touchy here -> the normal expectation is for the OPP
entries to be populated onetime at boot.
For example - driver bug where same device was attempted twice Vs the
usecase you mention here - how'd we differentiate between the two?
>  	prop = of_find_property(of_node, "operating-points", NULL);
>  	if (!prop)
>  		return -ENODEV;
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards,
Nishanth Menon
