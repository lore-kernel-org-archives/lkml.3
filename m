Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbaLKUoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:44:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55427 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752783AbaLKUoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:44:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kristen Carlson Accardi <kristen@linux.intel.com>,
        Ethan Zhao <ethan.zhao@oracle.com>
Cc: dirk.j.brandewie@intel.com, linda.knippers@hp.com, viresh.kumar@linaro.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        ethan.kernel@gmail.com
Subject: Re: [PATCH 2/2 V9] intel_pstate: add kernel parameter to force loading.
Date: Thu, 11 Dec 2014 22:05:53 +0100
Message-ID: <2949247.5egUrLMaeB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141210122849.17d258d8@kcaccard-desk.amr.corp.intel.com>
References: <1418089399-9310-1-git-send-email-ethan.zhao@oracle.com> <20141210122849.17d258d8@kcaccard-desk.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 10, 2014 12:28:49 PM Kristen Carlson Accardi wrote:
> On Tue, 9 Dec 2014 10:43:19 +0900
> Ethan Zhao <ethan.zhao@oracle.com> wrote:
> 
> > To force loading on Oracle Sun X86 servers, provide one kernel command line
> > parameter
> > 
> >   intel_pstate = force
> > 
> > For those who be aware of the risk of no power capping capabily working and
> > try to get better performance with this driver.
> > 
> > Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> > Tested-by: Alexey Kodanev <alexey.kodanev@oracle.com>
> > Reviewed-by: Linda Knippers <linda.knippers@hp.com>
> 
> Acked-by: Kristen Carlson Accardi <kristen@linux.intel.com>

Patch applied, but I had to rebase it on top of the HWP changes from Dirk.

Please check my linux-next branch for the result and let me know if there's
anything wrong with it.

> > ---
> >  v2: change to hardware vendor specific naming parameter.
> >  v4: refine code and doc.
> >  v5&v6: fix a typo in doc.
> >  v7: change enum PCC to PPC.
> >  v8: change the name of kernel command line parameter to generic one.
> >  v9: refine doc
> > 
> >  Documentation/kernel-parameters.txt | 5 +++++
> >  drivers/cpufreq/intel_pstate.c      | 6 +++++-
> >  2 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 479f332..7d0983e 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -1446,6 +1446,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  		       disable
> >  		         Do not enable intel_pstate as the default
> >  		         scaling driver for the supported processors
> > +		       force
> > +			 Enable intel_pstate on systems that prohibit it by default
> > +			 in favor of acpi-cpufreq. Forcing the intel_pstate driver
> > +			 instead of acpi-cpufreq may disable platform features, such
> > +			 as thermal controls and power capping, that rely on ACPI
> > +			 P-States information being indicated to OSPM and therefore
> > +			 should be used with caution. This option does not work with
> > +			 processors that aren't supported by the intel_pstate driver
> > +			 or on platforms that use pcc-cpufreq instead of acpi-cpufreq.
> >  
> >  	intremap=	[X86-64, Intel-IOMMU]
> >  			on	enable Interrupt Remapping (default)
> > diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> > index 1bb62ca..2654e13 100644
> > --- a/drivers/cpufreq/intel_pstate.c
> > +++ b/drivers/cpufreq/intel_pstate.c
> > @@ -866,6 +866,7 @@ static struct cpufreq_driver intel_pstate_driver = {
> >  };
> >  
> >  static int __initdata no_load;
> > +static unsigned int  force_load;
> >  
> >  static int intel_pstate_msrs_not_valid(void)
> >  {
> > @@ -1003,7 +1004,8 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
> >  			case PSS:
> >  				return intel_pstate_no_acpi_pss();
> >  			case PPC:
> > -				return intel_pstate_has_acpi_ppc();
> > +				return intel_pstate_has_acpi_ppc() &&
> > +					(!force_load);
> >  			}
> >  	}
> >  
> > @@ -1078,6 +1080,8 @@ static int __init intel_pstate_setup(char *str)
> >  
> >  	if (!strcmp(str, "disable"))
> >  		no_load = 1;
> > +	if (!strcmp(str, "force"))
> > +		force_load = 1;
> >  	return 0;
> >  }
> >  early_param("intel_pstate", intel_pstate_setup);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
