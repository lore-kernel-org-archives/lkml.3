Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLCB5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:57:48 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61146 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751244AbaLCB5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:57:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>, dirk.j.brandewie@intel.com,
        linda.knippers@hp.com, viresh.kumar@linaro.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH 1/2 V6] intel_pstate: skip this driver if Sun server has _PPC method
Date: Wed, 03 Dec 2014 03:19:10 +0100
Message-ID: <20270069.XOrGjO4EFd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141202102231.32b43385@kcaccard-desk.amr.corp.intel.com>
References: <1417401128-32086-1-git-send-email-ethan.zhao@oracle.com> <20141202102231.32b43385@kcaccard-desk.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 02, 2014 10:22:31 AM Kristen Carlson Accardi wrote:
> On Mon, 1 Dec 2014 11:32:08 +0900
> Ethan Zhao <ethan.zhao@oracle.com> wrote:
> 
> > Oracle Sun X86 servers have dynamic power capping capability that works via
> > ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
> > enabled.
> > 
> > Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> > Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> > Tested-by: Linda Knippers <linda.knippers@hp.com>
> 
> Acked-by: Kristen Carlson Accardi <kristen@linux.intel.com>

Patch queued up for 3.19-rc1, thanks!

> > ---
> >   v2: fix break HP Proliant issue.
> >   v3: expand the hardware vendor list.
> >   v4: refine code.
> >   v5v6: change enum PCC to PPC.
> > 
> >  drivers/cpufreq/intel_pstate.c | 45 ++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 41 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> > index 27bb6d3..1bb62ca 100644
> > --- a/drivers/cpufreq/intel_pstate.c
> > +++ b/drivers/cpufreq/intel_pstate.c
> > @@ -943,15 +943,46 @@ static bool intel_pstate_no_acpi_pss(void)
> >  	return true;
> >  }
> >  
> > +static bool intel_pstate_has_acpi_ppc(void)
> > +{
> > +	int i;
> > +
> > +	for_each_possible_cpu(i) {
> > +		struct acpi_processor *pr = per_cpu(processors, i);
> > +
> > +		if (!pr)
> > +			continue;
> > +		if (acpi_has_method(pr->handle, "_PPC"))
> > +			return true;
> > +	}
> > +	return false;
> > +}
> > +
> > +enum {
> > +	PSS,
> > +	PPC,
> > +};
> > +
> >  struct hw_vendor_info {
> >  	u16  valid;
> >  	char oem_id[ACPI_OEM_ID_SIZE];
> >  	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE];
> > +	int  oem_pwr_table;
> >  };
> >  
> >  /* Hardware vendor-specific info that has its own power management modes */
> >  static struct hw_vendor_info vendor_info[] = {
> > -	{1, "HP    ", "ProLiant"},
> > +	{1, "HP    ", "ProLiant", PSS},
> > +	{1, "ORACLE", "X4-2    ", PPC},
> > +	{1, "ORACLE", "X4-2L   ", PPC},
> > +	{1, "ORACLE", "X4-2B   ", PPC},
> > +	{1, "ORACLE", "X3-2    ", PPC},
> > +	{1, "ORACLE", "X3-2L   ", PPC},
> > +	{1, "ORACLE", "X3-2B   ", PPC},
> > +	{1, "ORACLE", "X4470M2 ", PPC},
> > +	{1, "ORACLE", "X4270M3 ", PPC},
> > +	{1, "ORACLE", "X4270M2 ", PPC},
> > +	{1, "ORACLE", "X4170M2 ", PPC},
> >  	{0, "", ""},
> >  };
> >  
> > @@ -966,15 +997,21 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
> >  
> >  	for (v_info = vendor_info; v_info->valid; v_info++) {
> >  		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
> > -		    !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
> > -		    intel_pstate_no_acpi_pss())
> > -			return true;
> > +			!strncmp(hdr.oem_table_id, v_info->oem_table_id,
> > +						ACPI_OEM_TABLE_ID_SIZE))
> > +			switch (v_info->oem_pwr_table) {
> > +			case PSS:
> > +				return intel_pstate_no_acpi_pss();
> > +			case PPC:
> > +				return intel_pstate_has_acpi_ppc();
> > +			}
> >  	}
> >  
> >  	return false;
> >  }
> >  #else /* CONFIG_ACPI not enabled */
> >  static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
> > +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
> >  #endif /* CONFIG_ACPI */
> >  
> >  static int __init intel_pstate_init(void)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
