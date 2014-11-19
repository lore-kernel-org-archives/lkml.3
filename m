Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaKSTFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:05:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:60964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbaKSTFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:05:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,418,1413270000"; 
   d="scan'208";a="639894999"
Date: Wed, 19 Nov 2014 11:05:48 -0800
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: <dirk.j.brandewie@intel.com>, <viresh.kumar@linaro.org>,
        <rjw@rjwysocki.net>, <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <ethan.kernel@gmail.com>, <joe.jin@oracle.com>,
        <brian.maly@oracle.com>
Subject: Re: [PATCH 3/3] intel_pstate: add module and kernel command line
 parameter to ignore ACPI _PPC
Message-ID: <20141119110548.24a0a808@kcaccard-desk.amr.corp.intel.com>
In-Reply-To: <1416299826-15813-8-git-send-email-ethan.zhao@oracle.com>
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com>
	<1416299826-15813-8-git-send-email-ethan.zhao@oracle.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 17:37:06 +0900
Ethan Zhao <ethan.zhao@oracle.com> wrote:

> Add kernel command line parameter
>  intel_pstate = ignore_acpi_ppc
> and module parameter
>  ignore_acpi_ppc = 1
> to allow driver to ignore the ACPI _PPC existence even for Sun x86 servers.
> These parameter could be used for debug\test\workaround etc purpose.
> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>

What if we used a more generic parameter like "force" that would bypass
any vendor specific checks and just load anyway?  This way we don't have
to add new parameters everything some new thing shows up that we want to
ignore.

> ---
>  Documentation/kernel-parameters.txt | 3 +++
>  drivers/cpufreq/intel_pstate.c      | 8 +++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4c81a86..f502b85 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1446,6 +1446,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  		       disable
>  		         Do not enable intel_pstate as the default
>  		         scaling driver for the supported processors
> +		       ignore_acpi_ppc
> +			 Ignore the existence of ACPI method _PPC for Sun x86 servers
> +			 and load the driver.
>  
>  	intremap=	[X86-64, Intel-IOMMU]
>  			on	enable Interrupt Remapping (default)
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 7c5faea..388387b 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -870,6 +870,7 @@ static struct cpufreq_driver intel_pstate_driver = {
>  };
>  
>  static int __initdata no_load;
> +static unsigned int  ignore_acpi_ppc;
>  
>  static int intel_pstate_msrs_not_valid(void)
>  {
> @@ -990,7 +991,7 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>  		    intel_pstate_no_acpi_pss())
>  			return true;
>  		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
> -			intel_pstate_has_acpi_ppc())
> +			intel_pstate_has_acpi_ppc() && !ignore_acpi_ppc)
>  			return true;
>  	}
>  
> @@ -1066,11 +1067,16 @@ static int __init intel_pstate_setup(char *str)
>  
>  	if (!strcmp(str, "disable"))
>  		no_load = 1;
> +	if (!strcmp(str, "ignore_acpi_ppc"))
> +		ignore_acpi_ppc = 1;
>  	return 0;
>  }
>  early_param("intel_pstate", intel_pstate_setup);
>  #endif
>  
> +module_param(ignore_acpi_ppc, uint, 0644);
> +MODULE_PARM_DESC(ignore_acpi_ppc,
> +	"value 0 or non-zero. non-zero -> ignore ACPI _PPC and load this driver");
>  MODULE_AUTHOR("Dirk Brandewie <dirk.j.brandewie@intel.com>");
>  MODULE_DESCRIPTION("'intel_pstate' - P state driver Intel Core processors");
>  MODULE_LICENSE("GPL");

