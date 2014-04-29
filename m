Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbaD2NCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:02:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:31336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaD2NCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,951,1389772800"; 
   d="scan'208";a="531565868"
Date: Tue, 29 Apr 2014 06:02:34 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "David E. Box" <david.e.box@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH 5/5] powercap/rapl: change floor frequency for
 vallewview
Message-ID: <20140429060234.3c5affce@ultegra>
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB59EF5AC4@BGSMSX101.gar.corp.intel.com>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1398693880-13428-6-git-send-email-jacob.jun.pan@linux.intel.com>
	<4D68720C2E767A4AA6A8796D42C8EB59EF5AC4@BGSMSX101.gar.corp.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 02:45:22 +0000
"R, Durgadoss" <durgadoss.r@intel.com> wrote:

> Hi Jacob,
> 
> > -----Original Message-----
> > From: Jacob Pan [mailto:jacob.jun.pan@linux.intel.com]
> > Sent: Monday, April 28, 2014 7:35 PM
> > To: Linux PM; Wysocki, Rafael J; LKML
> > Cc: David E. Box; Alan Cox; R, Durgadoss; Accardi, Kristen C; Jacob
> > Pan Subject: [PATCH 5/5] powercap/rapl: change floor frequency for
> > vallewview
> > 
> > RAPL power limit reduce power by limiting CPU P-state and
> > other techniques. On Valleyview, RAPL power limit cannot
> > go to LFM (low frequency mode) if we don't set the floor
> > frequency via IOSF mailbox.
> > 
> > This patch enables setting of floor frquency such that
> > RAPL power limit is more effective.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  drivers/powercap/intel_rapl.c | 27 +++++++++++++++++++--------
> >  1 file changed, 19 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/powercap/intel_rapl.c
> > b/drivers/powercap/intel_rapl.c index b1cda6f..13e4776 100644
> > --- a/drivers/powercap/intel_rapl.c
> > +++ b/drivers/powercap/intel_rapl.c
> > @@ -32,6 +32,7 @@
> > 
> >  #include <asm/processor.h>
> >  #include <asm/cpu_device_id.h>
> > +#include <asm/iosf_mbi.h>
> > 
> >  /* bitmasks for RAPL MSRs, used by primitive access functions */
> >  #define ENERGY_STATUS_MASK      0xffffffff
> > @@ -336,11 +337,17 @@ static int find_nr_power_limit(struct
> > rapl_domain *rd) return i;
> >  }
> > 
> > +#define VLV_CPU_POWER_BUDGET_CTL (0x2)
> > +static const struct x86_cpu_id valleyview_id[] = {
> > +	{ X86_VENDOR_INTEL, 6, 0x37},
> > +	{}
> > +};
> 
> There are other platforms that have this FloorFreq register as well.
> And those addresses are not '0x02'. So, we need to have a cpu_id based
> table to define the address of the floor freq register as well.
> [This is not specific to valleyview.]
> 
Sounds like I need to add an abstraction to capture this. So far, there
are only two exceptions so i was hesitate to do so. Thanks for the
input.
> Also, is there a plan to expose this floor freq ratio through Sysfs
> for runtime configuration. ? May be through a standard thermal
> cooling device interface ?
> 
why would that be necessary? who will use it? floor freq only affects
RAPL, AFAIK. In Linux there is no guaranteed freq anyway. My original
patch to enable RAPL as cooling device was abandoned in favor of
powercap framework, I am not sure if we should go back.

> > +
> >  static int set_domain_enable(struct powercap_zone *power_zone,
> > bool mode) {
> >  	struct rapl_domain *rd =
> > power_zone_to_rapl_domain(power_zone); int nr_powerlimit;
> > -
> > +	u32 mdata = 0;
> >  	if (rd->state & DOMAIN_STATE_BIOS_LOCKED)
> >  		return -EACCES;
> >  	get_online_cpus();
> > @@ -350,7 +357,16 @@ static int set_domain_enable(struct
> > powercap_zone *power_zone, bool mode)
> >  	/* always enable clamp such that p-state can go below OS
> > requested
> >  	 * range. power capping priority over guranteed frequency.
> >  	 */
> > -	rapl_write_data_raw(rd, PL1_CLAMP, mode);
> > +	if (x86_match_cpu(valleyview_id)) {
> > +		iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_PMC_READ,
> > +			VLV_CPU_POWER_BUDGET_CTL, &mdata);
> > +		mdata &= ~(0x7f << 8);
> > +		mdata |= 1 << 8;
> > +		iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_PMC_WRITE,
> > +			VLV_CPU_POWER_BUDGET_CTL, mdata);
> > +	} else
> > +		rapl_write_data_raw(rd, PL1_CLAMP, mode);
> > +
> >  	/* some domains have pl2 */
> >  	if (nr_powerlimit > 1) {
> >  		rapl_write_data_raw(rd, PL2_ENABLE, mode);
> > @@ -833,11 +849,6 @@ static int rapl_write_data_raw(struct
> > rapl_domain *rd, return 0;
> >  }
> > 
> > -static const struct x86_cpu_id energy_unit_quirk_ids[] = {
> > -	{ X86_VENDOR_INTEL, 6, 0x37},/* Valleyview */
> > -	{}
> > -};
> 
> Same thing here. There are other Atom platforms that need this
> conversion quirk. So, please keep the table as is.
> 
> Thanks,
> Durga
> 
> > -
> >  static int rapl_check_unit(struct rapl_package *rp, int cpu)
> >  {
> >  	u64 msr_val;
> > @@ -859,7 +870,7 @@ static int rapl_check_unit(struct rapl_package
> > *rp, int cpu) */
> >  	value = (msr_val & ENERGY_UNIT_MASK) >> ENERGY_UNIT_OFFSET;
> >  	/* some CPUs have different way to calculate energy unit */
> > -	if (x86_match_cpu(energy_unit_quirk_ids))
> > +	if (x86_match_cpu(valleyview_id))
> >  		rp->energy_unit_divisor = 1000000 / (1 << value);
> >  	else
> >  		rp->energy_unit_divisor = 1 << value;
> > --
> > 1.8.1.2
> 

[Jacob Pan]
