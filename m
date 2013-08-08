Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966035Ab3HHTie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:38:34 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:57381 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3HHTib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:38:31 -0400
X-AuditID: cbfec372-b7f046d000001821-f9-5203f3b518f0
Date: Thu, 08 Aug 2013 16:38:22 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130808163822.67e0828a@samsung.com>
In-reply-to: <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/hIN2tn5mDDJqWGVgsacqw+LzhH5vF
	h75rTBbL9/UzWlzeNYfN4uy842wW91ueslv0L+xlstjX8YDJ4s2FeywOXB7fW/tYPFr23WL3
	WLCp1GPXtp1MHov3vGTyeHBoM4vHo8UtjB6fN8kFcERx2aSk5mSWpRbp2yVwZfx+sJap4K1U
	xc81bSwNjJ9Euxg5OSQETCROPd/EAmGLSVy4t54NxBYSWMIoce+7fxcjF5DdwySx7OYKZpAE
	i4CqxL+FrWBFbAJGEq8aW1hBbBEBU4kjK64zgTQwC5xmlOj63s0EkhAWCJPYs6cZyObg4BUw
	lNi1NQ3E5BQIkHi9TA5i/lRGiW/v5jKDxCUEnCS2TvUF6eQVEJT4Mfke2G3MAloSm7c1sULY
	8hKb17xlnsAoMAtJ2SwkZbOQlC1gZF7FKFpanFxQnJSea6hXnJhbXJqXrpecn7uJERIbRTsY
	n22wOsQowMGoxMOrsJ05SIg1say4MvcQowQHs5II74ssoBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQZGie7NjTZXPv40KdLb0cUdsn/bw6ioFylFGwJcd4T+OTSl3S3fmDtxM/8btotXW3ubCg9Z
	5547NPfKdEbGj5K3GWreW3xos5twdO5H2w2LLcTOuc/3mL3Ov2XLnPVCSsUzHUQaeJKPPn+e
	WvCu48XrY6t5LhrWfP+fyvsql2F3gG8lS+wLppmMSizFGYmGWsxFxYkAV7HozGsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 08 Aug 2013 23:57:51 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:

> Enable memory error trace event in cper.c

Why do we need to do that? Memory error events are already handled
via edac_ghes module, in a standard way that allows the same
tracing to be used by either BIOS or by direct hardware error
report mechanism.

Adding an extra tracing for the same thing here will just make
userspace more complex, and will create duplicated error events
for the very same error.

Ok, if the interface there is poor, let's improve it, but adding
yet another interface to report the same error doesn't sound
reasonable on my eyes.

Regards,
Mauro
> 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
>  drivers/acpi/apei/cper.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index 33dc6a0..19a9c0b 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -32,6 +32,10 @@
>  #include <linux/pci.h>
>  #include <linux/aer.h>
>  
> +#define CREATE_TRACE_POINTS
> +#define TRACE_EVENT_GHES
> +#include <trace/events/ras.h>
> +
>  /*
>   * CPER record ID need to be unique even after reboot, because record
>   * ID is used as index for ERST storage, while CPER records from
> @@ -193,8 +197,13 @@ static const char *cper_mem_err_type_strs[] = {
>  	"scrub uncorrected error",
>  };
>  
> -static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
> +static void cper_print_mem(const char *pfx,
> +		const struct acpi_hest_generic_status *estatus,
> +		const struct acpi_hest_generic_data *gdata,
> +		const struct cper_sec_mem_err *mem)
>  {
> +	trace_ghes_platform_memory_event(estatus, gdata, mem);
> +
>  	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
>  		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
>  	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)
> @@ -292,8 +301,10 @@ static const char *apei_estatus_section_flag_strs[] = {
>  	"latent error",
>  };
>  
> -static void apei_estatus_print_section(
> -	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
> +static void apei_estatus_print_section(const char *pfx,
> +		const struct acpi_hest_generic_status *estatus,
> +		const struct acpi_hest_generic_data *gdata,
> +		int sec_no)
>  {
>  	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>  	__u16 severity;
> @@ -320,7 +331,7 @@ static void apei_estatus_print_section(
>  		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
>  		printk("%s""section_type: memory error\n", pfx);
>  		if (gdata->error_data_length >= sizeof(*mem_err))
> -			cper_print_mem(pfx, mem_err);
> +			cper_print_mem(pfx, estatus, gdata, mem_err);
>  		else
>  			goto err_section_too_small;
>  	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
> @@ -355,7 +366,7 @@ void apei_estatus_print(const char *pfx,
>  	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
>  	while (data_len > sizeof(*gdata)) {
>  		gedata_len = gdata->error_data_length;
> -		apei_estatus_print_section(pfx, gdata, sec_no);
> +		apei_estatus_print_section(pfx, estatus, gdata, sec_no);
>  		data_len -= gedata_len + sizeof(*gdata);
>  		gdata = (void *)(gdata + 1) + gedata_len;
>  		sec_no++;


-- 

Cheers,
Mauro
