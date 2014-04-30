Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbaD3FaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:30:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:50567 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbaD3F37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 01:29:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,956,1389772800"; 
   d="scan'208";a="532209558"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "David E. Box" <david.e.box@linux.intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
CC: "alan@linux.intel.com" <alan@linux.intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: RE: [PATCH v2 1/4] powercap/rapl: further relax energy counter
 checks
Thread-Topic: [PATCH v2 1/4] powercap/rapl: further relax energy counter
 checks
Thread-Index: AQHPY/tdPgqAXGE0ZUuhxXt2JzeiuJspolEw
Date: Wed, 30 Apr 2014 05:29:54 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59EF6C00@BGSMSX101.gar.corp.intel.com>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
 <1398810789-2301-2-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1398810789-2301-2-git-send-email-david.e.box@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David E. Box [mailto:david.e.box@linux.intel.com]
> Sent: Wednesday, April 30, 2014 4:03 AM
> To: david.e.box@linux.intel.com; jacob.jun.pan@linux.intel.com; linux-
> pm@vger.kernel.org; Wysocki, Rafael J; linux-kernel@vger.kernel.org;
> hpa@linux.intel.com
> Cc: alan@linux.intel.com; R, Durgadoss; Accardi, Kristen C
> Subject: [PATCH v2 1/4] powercap/rapl: further relax energy counter checks
> 
> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> Energy counters may roll slowly for some RAPL domains, checking all
> of them can be time consuming and takes unpredictable amount of time.
> Therefore, we relax the sanity check by only checking availability of the
> MSRs and non-zero value of the energy status counters. It has been shown
> sufficient for all the platforms tested to filter out inactive domains.
> 

Acked-by: Durgadoss R <durgadoss.r@intel.com>

Thanks,
Durga

> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/powercap/intel_rapl.c |   29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
> index d9a0770..1c987d2 100644
> --- a/drivers/powercap/intel_rapl.c
> +++ b/drivers/powercap/intel_rapl.c
> @@ -1124,8 +1124,7 @@ err_cleanup_package:
>  static int rapl_check_domain(int cpu, int domain)
>  {
>  	unsigned msr;
> -	u64 val1, val2 = 0;
> -	int retry = 0;
> +	u64 val = 0;
> 
>  	switch (domain) {
>  	case RAPL_DOMAIN_PACKAGE:
> @@ -1144,26 +1143,13 @@ static int rapl_check_domain(int cpu, int domain)
>  		pr_err("invalid domain id %d\n", domain);
>  		return -EINVAL;
>  	}
> -	if (rdmsrl_safe_on_cpu(cpu, msr, &val1))
> -		return -ENODEV;
> -
> -	/* PP1/uncore/graphics domain may not be active at the time of
> -	 * driver loading. So skip further checks.
> +	/* make sure domain counters are available and contains non-zero
> +	 * values, otherwise skip it.
>  	 */
> -	if (domain == RAPL_DOMAIN_PP1)
> -		return 0;
> -	/* energy counters roll slowly on some domains */
> -	while (++retry < 10) {
> -		usleep_range(10000, 15000);
> -		rdmsrl_safe_on_cpu(cpu, msr, &val2);
> -		if ((val1 & ENERGY_STATUS_MASK) != (val2 &
> ENERGY_STATUS_MASK))
> -			return 0;
> -	}
> -	/* if energy counter does not change, report as bad domain */
> -	pr_info("domain %s energy ctr %llu:%llu not working, skip\n",
> -		rapl_domain_names[domain], val1, val2);
> +	if (rdmsrl_safe_on_cpu(cpu, msr, &val) || !val)
> +		return -ENODEV;
> 
> -	return -ENODEV;
> +	return 0;
>  }
> 
>  /* Detect active and valid domains for the given CPU, caller must
> @@ -1180,6 +1166,9 @@ static int rapl_detect_domains(struct rapl_package *rp,
> int cpu)
>  		/* use physical package id to read counters */
>  		if (!rapl_check_domain(cpu, i))
>  			rp->domain_map |= 1 << i;
> +		else
> +			pr_warn("RAPL domain %s detection failed\n",
> +				rapl_domain_names[i]);
>  	}
>  	rp->nr_domains = bitmap_weight(&rp->domain_map,
> 	RAPL_DOMAIN_MAX);
>  	if (!rp->nr_domains) {
> --
> 1.7.10.4

