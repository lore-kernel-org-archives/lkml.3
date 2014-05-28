Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaE1P2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:28:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:54668 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752358AbaE1P2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:28:34 -0400
Date: Wed, 28 May 2014 11:28:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: bp@alien8.de, tony.luck@intel.com, m.chehab@samsung.com,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140528112832.5f83c66b@gandalf.local.home>
In-Reply-To: <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added LKML

On Tue, 27 May 2014 23:32:18 -0400
"Chen, Gong" <gong.chen@linux.intel.com> wrote:

> Add trace interface to elaborate all H/W error related information.
> 
> v6 -> v5: format adjustment.
> v5 -> v4: Add physical mask(LSB) in trace.
> v4 -> v3: change ras trace dependency rule.
> v3 -> v2: minor adjustment according to the suggestion from Boris.
> v2 -> v1: spinlock is not needed anymore.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/acpi/Kconfig       |  4 +++-
>  drivers/acpi/acpi_extlog.c | 54 +++++++++++++++++++++++++++++++++++++++---
>  drivers/ras/ras.c          |  1 +
>  include/ras/ras_event.h    | 59 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 114 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index a34a228..099a2d5 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -370,6 +370,7 @@ config ACPI_EXTLOG
>  	tristate "Extended Error Log support"
>  	depends on X86_MCE && X86_LOCAL_APIC
>  	select UEFI_CPER
> +	select RAS_TRACE
>  	default n
>  	help
>  	  Certain usages such as Predictive Failure Analysis (PFA) require
> @@ -384,6 +385,7 @@ config ACPI_EXTLOG
>  
>  	  Enhanced MCA Logging allows firmware to provide additional error
>  	  information to system software, synchronous with MCE or CMCI. This
> -	  driver adds support for that functionality.
> +	  driver adds support for that functionality with corresponding
> +	  tracepoint which carries that information to userspace.
>  
>  endif	# ACPI
> diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
> index c4a5d87..8815b73 100644
> --- a/drivers/acpi/acpi_extlog.c
> +++ b/drivers/acpi/acpi_extlog.c
> @@ -16,6 +16,7 @@
>  #include <asm/mce.h>
>  
>  #include "apei/apei-internal.h"
> +#include <ras/ras_event.h>
>  
>  #define EXT_ELOG_ENTRY_MASK	GENMASK_ULL(51, 0) /* elog entry address mask */
>  
> @@ -43,6 +44,9 @@ struct extlog_l1_head {
>  
>  static int old_edac_report_status;
>  
> +static char mem_location[CPER_REC_LEN];
> +static char dimm_location[CPER_REC_LEN];
> +
>  static u8 extlog_dsm_uuid[] __initdata = "663E35AF-CC10-41A4-88EA-5470AF055295";
>  
>  /* L1 table related physical address */
> @@ -69,6 +73,30 @@ static u32 l1_percpu_entry;
>  #define ELOG_ENTRY_ADDR(phyaddr) \
>  	(phyaddr - elog_base + (u8 *)elog_addr)
>  
> +static void __trace_mem_error(const uuid_le *fru_id, char *fru_text,
> +			       u32 err_number, u8 severity,
> +			       struct cper_sec_mem_err *mem)
> +{
> +	u8 etype = ~0, pa_mask_lsb = ~0;
> +	u64 pa = ~0ull;
> +
> +	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
> +		etype = mem->error_type;
> +
> +	if (mem->validation_bits & CPER_MEM_VALID_PA)
> +		pa = mem->physical_addr;
> +
> +	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
> +		pa_mask_lsb = (u8)__ffs64(mem->physical_addr_mask);
> +
> +	memset(mem_location, 0, CPER_REC_LEN);
> +	cper_mem_err_location(mem, mem_location);
> +	memset(dimm_location, 0, CPER_REC_LEN);
> +	cper_dimm_err_location(mem, dimm_location);
> +	trace_extlog_mem_event(err_number, etype, severity, pa, pa_mask_lsb,
> +			       fru_id, dimm_location, mem_location, fru_text);

This seems like a lot of work for a tracepoint. Why all the strings?
Ideally, you want to record in the fast path the minimum raw data and
reconstruct it at the time it is read.

> +}
> +
>  static struct acpi_generic_status *extlog_elog_entry_check(int cpu, int bank)
>  {
>  	int idx;
> @@ -137,8 +165,12 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
>  	struct mce *mce = (struct mce *)data;
>  	int	bank = mce->bank;
>  	int	cpu = mce->extcpu;
> -	struct acpi_generic_status *estatus;
> -	int rc;
> +	struct acpi_generic_status *estatus, *tmp;
> +	struct acpi_generic_data *gdata;
> +	const uuid_le *fru_id = &NULL_UUID_LE;
> +	char *fru_text = "";
> +	uuid_le *sec_type;
> +	static u32 err_number;
>  
>  	estatus = extlog_elog_entry_check(cpu, bank);
>  	if (estatus == NULL)
> @@ -148,7 +180,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
>  	/* clear record status to enable BIOS to update it again */
>  	estatus->block_status = 0;
>  
> -	rc = print_extlog_rcd(NULL, (struct acpi_generic_status *)elog_buf, cpu);
> +	tmp = (struct acpi_generic_status *)elog_buf;
> +	print_extlog_rcd(NULL, tmp, cpu);
> +
> +	/* log event via trace */
> +	err_number++;
> +	gdata = (struct acpi_generic_data *)(tmp + 1);
> +	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
> +		fru_id = (uuid_le *)gdata->fru_id;
> +	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
> +		fru_text = gdata->fru_text;
> +	sec_type = (uuid_le *)gdata->section_type;
> +	if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
> +		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
> +		if (gdata->error_data_length >= sizeof(*mem_err))
> +			__trace_mem_error(fru_id, fru_text, err_number,
> +					  (u8)gdata->error_severity, mem_err);
> +	}
>  
>  	return NOTIFY_STOP;
>  }
> diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
> index 4cac43a..da227a3 100644
> --- a/drivers/ras/ras.c
> +++ b/drivers/ras/ras.c
> @@ -23,4 +23,5 @@ static int __init ras_init(void)
>  }
>  subsys_initcall(ras_init);
>  
> +EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index acbcbb8..4d3bc92 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -9,6 +9,65 @@
>  #include <linux/edac.h>
>  #include <linux/ktime.h>
>  #include <linux/aer.h>
> +#include <linux/cper.h>
> +
> +
> +/*
> + * MCE Extended Error Log trace event
> + *
> + * These events are generated when hardware detects a corrected or
> + * uncorrected event.
> + */
> +
> +/* memory trace event */
> +
> +TRACE_EVENT(extlog_mem_event,
> +	TP_PROTO(u32 error_number,
> +		 u8 etype,
> +		 u8 severity,
> +		 u64 pa,
> +		 u8 pa_mask_lsb,
> +		 const uuid_le *fru_id,
> +		 const char *dimm_info,
> +		 const char *mem_loc,
> +		 const char *fru_text),
> +
> +	TP_ARGS(error_number, etype, severity, pa, pa_mask_lsb, fru_id,
> +		dimm_info, mem_loc, fru_text),
> +
> +	TP_STRUCT__entry(
> +		__field(u32, error_number)
> +		__field(u8, etype)
> +		__field(u8, severity)
> +		__field(u64, pa)
> +		__field(u8, pa_mask_lsb)
> +		__string(dimm_info, dimm_info)
> +		__string(mem_loc, mem_loc)
> +		__dynamic_array(char, fru, CPER_REC_LEN)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->error_number = error_number;
> +		__entry->etype = etype;
> +		__entry->severity = severity;
> +		__entry->pa = pa;
> +		__entry->pa_mask_lsb = pa_mask_lsb;
> +		__assign_str(dimm_info, dimm_info);
> +		__assign_str(mem_loc, mem_loc);
> +		snprintf(__get_dynamic_array(fru), CPER_REC_LEN - 1,
> +			 "FRU: %pUl %.20s", fru_id, fru_text);

For example, here don't use snprintf(). Save that processing for the
TP_printk(), as that is done at time of read. Again, only store the
minimum raw data, and reconstruct it later. Why slow down the fast path?

-- Steve

> +	),
> +
> +	TP_printk("%d %s error: %s %s physical addr: %016llx (mask lsb: %x), %s%s",
> +		  __entry->error_number,
> +		  cper_severity_str(__entry->severity),
> +		  cper_mem_err_type_str(__entry->etype),
> +		  __get_str(dimm_info),
> +		  __entry->pa,
> +		  __entry->pa_mask_lsb,
> +		  __get_str(mem_loc),
> +		  __get_str(fru))
> +);
>  
>  /*
>   * Hardware Events Report

