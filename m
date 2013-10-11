Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab3JKQOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:14:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49012 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757272Ab3JKQOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:14:44 -0400
Date: Fri, 11 Oct 2013 18:14:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131011161436.GM5925@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:32:46AM -0400, Chen, Gong wrote:
> Use trace interface to elaborate all H/W error related
> information.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/acpi/Kconfig        |   7 ++-
>  drivers/acpi/Makefile       |   4 ++
>  drivers/acpi/acpi_extlog.c  |  28 +++++++++++-
>  drivers/acpi/apei/cper.c    |  13 ++++--
>  drivers/acpi/debug_extlog.h |  16 +++++++
>  drivers/acpi/extlog_trace.c | 105 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/extlog_trace.h |  77 ++++++++++++++++++++++++++++++++
>  include/linux/cper.h        |   2 +
>  8 files changed, 246 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/acpi/debug_extlog.h
>  create mode 100644 drivers/acpi/extlog_trace.c
>  create mode 100644 drivers/acpi/extlog_trace.h
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 1465fa8..9ea343e 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -372,12 +372,17 @@ config ACPI_BGRT
>  
>  source "drivers/acpi/apei/Kconfig"
>  
> +config EXTLOG_TRACE
> +	def_bool n

Why the separate config item?

> +
>  config ACPI_EXTLOG
>  	tristate "Extended Error Log support"
>  	depends on X86 && X86_MCE
> +	select EXTLOG_TRACE
>  	default n
>  	help
>  	  This driver adds support for decoding extended errors from hardware.
> -	  which allows the operating system to obtain data from trace.
> +	  which allows the operating system to obtain data from trace. It will
> +	  appear under /sys/kernel/debug/tracing/ras/ .
>  
>  endif	# ACPI
> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> index bce34af..a6e41b7 100644
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -83,4 +83,8 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
>  
>  obj-$(CONFIG_ACPI_APEI)		+= apei/
>  
> +# extended log support
> +acpi-$(CONFIG_EXTLOG_TRACE)	+= extlog_trace.o

You can simply do

obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o extlog_trace.o

> +CFLAGS_extlog_trace.o := -I$(src)
> +
>  obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o

[ ... ]

> diff --git a/drivers/acpi/extlog_trace.c b/drivers/acpi/extlog_trace.c
> new file mode 100644
> index 0000000..2b2824c
> --- /dev/null
> +++ b/drivers/acpi/extlog_trace.c
> @@ -0,0 +1,105 @@
> +#include <linux/export.h>
> +#include <linux/dmi.h>
> +#include "debug_extlog.h"
> +
> +#define CREATE_TRACE_POINTS
> +#include "extlog_trace.h"
> +
> +static char mem_location[LOC_LEN];
> +static char dimm_location[LOC_LEN];
> +
> +static void mem_err_location(struct cper_sec_mem_err *mem)
> +{
> +	char *p;
> +	u32 n = 0;
> +
> +	memset(mem_location, 0, LOC_LEN);
> +	p = mem_location;
> +	if (mem->validation_bits & CPER_MEM_VALID_NODE)
> +		n += sprintf(p + n, " node: %d", mem->node);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_CARD)
> +		n += sprintf(p + n, " card: %d", mem->card);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
> +		n += sprintf(p + n, " module: %d", mem->module);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
> +		n += sprintf(p + n, " rank: %d", mem->rank);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_BANK)
> +		n += sprintf(p + n, " bank: %d", mem->bank);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
> +		n += sprintf(p + n, " device: %d", mem->device);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_ROW)
> +		n += sprintf(p + n, " row: %d", mem->row);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
> +		n += sprintf(p + n, " column: %d", mem->column);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
> +		n += sprintf(p + n, " bit_position: %d", mem->bit_pos);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
> +		n += sprintf(p + n, " requestor_id: 0x%016llx",
> +				mem->requestor_id);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
> +		n += sprintf(p + n, " responder_id: 0x%016llx",
> +				mem->responder_id);
> +	if (n >= LOC_LEN)
> +		goto end;
> +	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
> +		n += sprintf(p + n, " target_id: 0x%016llx", mem->target_id);
> +end:
> +	return;
> +}
> +
> +static void dimm_err_location(struct cper_sec_mem_err *mem)
> +{
> +	memset(dimm_location, 0, LOC_LEN);
> +	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {

By reversing this test you can save yourself an indentation level and a
superfluous memset:

	if (!(mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE))
		return;

	memset(dimm_location, 0, LOC_LEN);
	dmi_memdev_name...
	...


> +		const char *bank = NULL, *device = NULL;
> +		dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
> +		if (bank != NULL && device != NULL)
> +			snprintf(dimm_location, LOC_LEN - 1,
> +				"%s %s", bank, device);
> +		else
> +			snprintf(dimm_location, LOC_LEN - 1,
> +				"DMI handle: 0x%.4x", mem->mem_dev_handle);
> +	}
> +}
> +
> +void trace_mem_error(const uuid_le *fru_id, char *fru_text,
> +		u64 err_count, u32 severity, struct cper_sec_mem_err *mem)
> +{
> +	u32 etype = ~0U;
> +	u64 phy_addr = 0;
> +
> +	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
> +		etype = mem->error_type;
> +	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
> +		phy_addr = mem->physical_addr;
> +		if (mem->validation_bits &
> +				CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK)

This mask could use some slimming:

CPER_MEM_VALID_PA_MASK or CPER_MEM_VALID_PHYS_ADDR_MASK or so so that it
fits in 80 cols.

> +			phy_addr &= mem->physical_addr_mask;
> +	}
> +	mem_err_location(mem);
> +	dimm_err_location(mem);
> +
> +	trace_extlog_mem_event(etype, dimm_location, fru_id, fru_text,
> +			err_count, severity, phy_addr, mem_location);

arg alignment

> +}
> +EXPORT_SYMBOL_GPL(trace_mem_error);
> diff --git a/drivers/acpi/extlog_trace.h b/drivers/acpi/extlog_trace.h
> new file mode 100644
> index 0000000..21f0887
> --- /dev/null
> +++ b/drivers/acpi/extlog_trace.h
> @@ -0,0 +1,77 @@
> +#if !defined(_TRACE_EXTLOG_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_EXTLOG_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/cper.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM extlog

Shouldn't that be TRACE_SYSTEM ras

...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
