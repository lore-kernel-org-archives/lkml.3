Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaHTO5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:57:10 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51223 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751213AbaHTO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:57:07 -0400
Date: Wed, 20 Aug 2014 15:56:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v2 09/18] ACPI / processor: Make it possible to get CPU
 hardware ID via GICC
Message-ID: <20140820145654.GP24600@localhost>
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>
 <1407166105-17675-10-git-send-email-hanjun.guo@linaro.org>
 <20140818142740.GU20043@localhost>
 <53F30CCE.9040705@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F30CCE.9040705@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 09:37:34AM +0100, Hanjun Guo wrote:
> On 2014-8-18 22:27, Catalin Marinas wrote:
> > On Mon, Aug 04, 2014 at 04:28:16PM +0100, Hanjun Guo wrote:
> >> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> >> index e32321c..4007313 100644
> >> --- a/drivers/acpi/processor_core.c
> >> +++ b/drivers/acpi/processor_core.c
> >> @@ -64,6 +64,38 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
> >>  	return 0;
> >>  }
> >>  
> >> +/*
> >> + * On ARM platform, MPIDR value is the hardware ID as apic ID
> >> + * on Intel platforms
> >> + */
> >> +static int map_gicc_mpidr(struct acpi_subtable_header *entry,
> >> +		int device_declaration, u32 acpi_id, int *mpidr)
> >> +{
> >> +	struct acpi_madt_generic_interrupt *gicc =
> >> +	    container_of(entry, struct acpi_madt_generic_interrupt, header);
> >> +
> >> +	if (!(gicc->flags & ACPI_MADT_ENABLED))
> >> +		return -ENODEV;
> >> +
> >> +	/* In the GIC interrupt model, logical processors are
> >> +	 * required to have a Processor Device object in the DSDT,
> >> +	 * so we should check device_declaration here
> >> +	 */
> >> +	if (device_declaration && (gicc->uid == acpi_id)) {
> >> +		/*
> >> +		 * Only bits [0:7] Aff0, bits [8:15] Aff1, bits [16:23] Aff2
> >> +		 * and bits [32:39] Aff3 are meaningful, so pack the Affx
> >> +		 * fields into a single 32 bit identifier to accommodate the
> >> +		 * acpi processor drivers.
> >> +		 */
> >> +		*mpidr = ((gicc->arm_mpidr & 0xff00000000) >> 8)
> >> +			 | gicc->arm_mpidr;
> > 
> > You can use pack_mpidr_into_32_bits().
> 
> processor_core.c will be used by x86 and ia64 too, it will cause
> compile error on !ARM64 platforms.

Oh. So we do we have an ARM-specific function in core ACPI code?

-- 
Catalin
