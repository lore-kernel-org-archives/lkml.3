Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaBSOdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:33:19 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38011 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaBSOdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:33:16 -0500
Message-ID: <5304C0C4.3080601@arm.com>
Date: Wed, 19 Feb 2014 14:33:40 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Sudeep.Holla@arm.com, Lan Tianyu <tianyu.lan@intel.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/5] ACPI / processor: Introduce map_gic_id() to get
 apic id from MADT or _MAT method
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org> <1392740638-2479-4-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1392740638-2479-4-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 19 Feb 2014 14:33:16.0993 (UTC) FILETIME=[873B2310:01CF2D7F]
X-MC-Unique: 114021914331404701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On 18/02/14 16:23, Hanjun Guo wrote:
> Get apic id from MADT or _MAT method is not implemented on arm/arm64,
> and ACPI 5.0 introduces GIC Structure for it, so this patch introduces
> map_gic_id() to get apic id followed the ACPI 5.0 spec.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/acpi/processor_core.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index 4dcf776..d316d9b 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -71,6 +71,27 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>  	return 0;
>  }
>  
> +static int map_gic_id(struct acpi_subtable_header *entry,
> +		int device_declaration, u32 acpi_id, int *apic_id)
> +{
> +	struct acpi_madt_generic_interrupt *gic =
> +		(struct acpi_madt_generic_interrupt *)entry;
> +
> +	if (!(gic->flags & ACPI_MADT_ENABLED))
> +		return -ENODEV;
> +
> +	/* In the GIC interrupt model, logical processors are
> +	 * required to have a Processor Device object in the DSDT,
> +	 * so we should check device_declaration here
> +	 */
> +	if (device_declaration && (gic->uid == acpi_id)) {
> +		*apic_id = gic->gic_id;

I have mentioned this earlier, it's not clear yet to me how does this work ?
It needs more clarity in the form of comment here at-least as the ACPIv5.0 is
also not so clear or explicit on how to handle this.

Here you are expecting gic->uid = acpi_id which is fine, while acpi_map_cpuid
matches apic_id with cpu_physical_id(which must be MPIDR in ARM{32,64}). The
latter imposes restriction that gic->gic_id has to be MPIDR. Does that mean we
are imposing restriction on GIC ID to be MPIDR ? If so please document it here
and please explain the reason behind that choice.

I would expect _UID to be MPIDR rather than GIC ID but you may have some reasons
for this choice.

Regards,
Sudeep

