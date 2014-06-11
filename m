Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaFKTCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:02:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37668 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaFKTCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:02:19 -0400
Date: Wed, 11 Jun 2014 21:02:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, m.chehab@samsung.com, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v7] trace, RAS: Add eMCA trace event interface
Message-ID: <20140611190214.GE14923@pd.tnic>
References: <1402475691-30045-1-git-send-email-gong.chen@linux.intel.com>
 <1402475691-30045-6-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402475691-30045-6-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:34:49AM -0400, Chen, Gong wrote:
> Add trace interface to elaborate all H/W error related information.
> 
> v7 -> v6: compact trace info to save trace buffer space.
> v6 -> v5: format adjustment.
> v5 -> v4: Add physical mask(LSB) in trace.
> v4 -> v3: change ras trace dependency rule.
> v3 -> v2: minor adjustment according to the suggestion from Boris.
> v2 -> v1: spinlock is not needed anymore.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/acpi/Kconfig        |  4 ++-
>  drivers/acpi/acpi_extlog.c  | 27 ++++++++++++++++---
>  drivers/firmware/efi/cper.c | 48 +++++++++++++++++++++++++++++++---
>  drivers/ras/ras.c           |  1 +
>  include/linux/cper.h        | 21 +++++++++++++++
>  include/ras/ras_event.h     | 63 +++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 156 insertions(+), 8 deletions(-)
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
> index 1853341..e61da95 100644
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
> @@ -137,8 +138,12 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
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
> +	static u32 err_seq;
>  
>  	estatus = extlog_elog_entry_check(cpu, bank);
>  	if (estatus == NULL)
> @@ -148,7 +153,23 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
>  	/* clear record status to enable BIOS to update it again */
>  	estatus->block_status = 0;
>  
> -	rc = print_extlog_rcd(NULL, (struct acpi_generic_status *)elog_buf, cpu);
> +	tmp = (struct acpi_generic_status *)elog_buf;
> +	print_extlog_rcd(NULL, tmp, cpu);
> +
> +	/* log event via trace */
> +	err_seq++;
> +	gdata = (struct acpi_generic_data *)(tmp + 1);
> +	if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
> +		fru_id = (uuid_le *)gdata->fru_id;
> +	if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
> +		fru_text = gdata->fru_text;
> +	sec_type = (uuid_le *)gdata->section_type;
> +	if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
> +		struct cper_sec_mem_err *mem = (void *)(gdata + 1);
> +		if (gdata->error_data_length >= sizeof(*mem))
> +			trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
> +					       (u8)gdata->error_severity);
> +	}
>  
>  	return NOTIFY_STOP;
>  }
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index 83b56b61..85d6d30 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -207,7 +207,7 @@ const char *cper_mem_err_type_str(unsigned int etype)
>  }
>  EXPORT_SYMBOL_GPL(cper_mem_err_type_str);
>  
> -int cper_mem_err_location(const struct cper_sec_mem_err *mem, char *msg)
> +int cper_mem_err_location(struct cper_mem_err_compact *mem, char *msg)
>  {
>  	u32 len, n;
>  
> @@ -249,7 +249,7 @@ int cper_mem_err_location(const struct cper_sec_mem_err *mem, char *msg)
>  	return n;
>  }
>  
> -int cper_dimm_err_location(const struct cper_sec_mem_err *mem, char *msg)
> +int cper_dimm_err_location(struct cper_mem_err_compact *mem, char *msg)
>  {
>  	u32 len, n;
>  	const char *bank = NULL, *device = NULL;
> @@ -271,8 +271,47 @@ int cper_dimm_err_location(const struct cper_sec_mem_err *mem, char *msg)
>  	return n;
>  }
>  
> +void cper_mem_err_pack(const struct cper_sec_mem_err *mem, void *data)
> +{
> +	struct cper_mem_err_compact *cmem = (struct cper_mem_err_compact *)data;
> +
> +	cmem->validation_bits = mem->validation_bits;
> +	cmem->node = mem->node;
> +	cmem->card = mem->card;
> +	cmem->module = mem->module;
> +	cmem->bank = mem->bank;
> +	cmem->device = mem->device;
> +	cmem->row = mem->row;
> +	cmem->column = mem->column;
> +	cmem->bit_pos = mem->bit_pos;
> +	cmem->requestor_id = mem->requestor_id;
> +	cmem->responder_id = mem->responder_id;
> +	cmem->target_id = mem->target_id;
> +	cmem->rank = mem->rank;
> +	cmem->mem_array_handle = mem->mem_array_handle;
> +	cmem->mem_dev_handle = mem->mem_dev_handle;
> +}
> +EXPORT_SYMBOL_GPL(cper_mem_err_pack);

Why do we export this one and the one below? What .config warrants this?

CONFIG_ACPI_EXTLOG=m doesn't need them, AFAICT.

> +const char *cper_mem_err_unpack(struct trace_seq *p, void *data)
> +{
> +	struct cper_mem_err_compact *cmem = (struct cper_mem_err_compact *)data;
> +	const char *ret = p->buffer + p->len;
> +
> +	if (cper_mem_err_location(cmem, rcd_decode_str))
> +		trace_seq_printf(p, "%s", rcd_decode_str);
> +	if (cper_dimm_err_location(cmem, rcd_decode_str))
> +		trace_seq_printf(p, "%s", rcd_decode_str);
> +	trace_seq_putc(p, '\0');
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(cper_mem_err_unpack);
> +
>  static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
>  {
> +	struct cper_mem_err_compact cmem;
> +
>  	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
>  		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
>  	if (mem->validation_bits & CPER_MEM_VALID_PA)
> @@ -281,14 +320,15 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
>  	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
>  		printk("%s""physical_address_mask: 0x%016llx\n",
>  		       pfx, mem->physical_addr_mask);
> -	if (cper_mem_err_location(mem, rcd_decode_str))
> +	cper_mem_err_pack(mem, &cmem);
> +	if (cper_mem_err_location(&cmem, rcd_decode_str))
>  		printk("%s%s\n", pfx, rcd_decode_str);
>  	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
>  		u8 etype = mem->error_type;
>  		printk("%s""error_type: %d, %s\n", pfx, etype,
>  		       cper_mem_err_type_str(etype));
>  	}
> -	if (cper_dimm_err_location(mem, rcd_decode_str))
> +	if (cper_dimm_err_location(&cmem, rcd_decode_str))
>  		printk("%s%s\n", pfx, rcd_decode_str);
>  }
>  
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
> diff --git a/include/linux/cper.h b/include/linux/cper.h
> index ed088b9..3548160 100644
> --- a/include/linux/cper.h
> +++ b/include/linux/cper.h
> @@ -22,6 +22,7 @@
>  #define LINUX_CPER_H
>  
>  #include <linux/uuid.h>
> +#include <linux/trace_seq.h>
>  
>  /* CPER record signature and the size */
>  #define CPER_SIG_RECORD				"CPER"
> @@ -363,6 +364,24 @@ struct cper_sec_mem_err {
>  	__u16	mem_dev_handle;		/* module handle in UEFI 2.4 */
>  };
>  
> +struct cper_mem_err_compact {
> +	__u64	validation_bits;
> +	__u16	node;
> +	__u16	card;
> +	__u16	module;
> +	__u16	bank;
> +	__u16	device;
> +	__u16	row;
> +	__u16	column;
> +	__u16	bit_pos;
> +	__u64	requestor_id;
> +	__u64	responder_id;
> +	__u64	target_id;
> +	__u16	rank;
> +	__u16	mem_array_handle;
> +	__u16	mem_dev_handle;
> +};
> +
>  struct cper_sec_pcie {
>  	__u64		validation_bits;
>  	__u32		port_type;
> @@ -406,5 +425,7 @@ const char *cper_severity_str(unsigned int);
>  const char *cper_mem_err_type_str(unsigned int);
>  void cper_print_bits(const char *prefix, unsigned int bits,
>  		     const char * const strs[], unsigned int strs_size);
> +void cper_mem_err_pack(const struct cper_sec_mem_err *, void *);
> +const char *cper_mem_err_unpack(struct trace_seq *, void *);
>  
>  #endif
> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index acbcbb8..c5e58db 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -9,6 +9,69 @@
>  #include <linux/edac.h>
>  #include <linux/ktime.h>
>  #include <linux/aer.h>
> +#include <linux/cper.h>
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
> +	TP_PROTO(struct cper_sec_mem_err *mem,
> +		 u32 err_seq,
> +		 const uuid_le *fru_id,
> +		 const char *fru_text,
> +		 u8 sev),
> +
> +	TP_ARGS(mem, err_seq, fru_id, fru_text, sev),
> +
> +	TP_STRUCT__entry(
> +		__field(u32, err_seq)
> +		__field(u8, etype)
> +		__field(u8, sev)
> +		__field(u64, pa)
> +		__field(u8, pa_mask_lsb)
> +		__array(u8, fru_id, 40)

How did you come up with this magic number? Why isn't that sizeof(uuid_le)?

> +		__string(fru_text, fru_text)
> +		__array(u8, data, sizeof(struct cper_mem_err_compact))
> +	),
> +
> +	TP_fast_assign(
> +		__entry->err_seq = err_seq;
> +		if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
> +			__entry->etype = mem->error_type;
> +		else
> +			__entry->etype = ~0;
> +		__entry->sev = sev;
> +		if (mem->validation_bits & CPER_MEM_VALID_PA)
> +			__entry->pa = mem->physical_addr;
> +		else
> +			__entry->pa = ~0ull;
> +
> +		if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
> +			__entry->pa_mask_lsb =
> +				(u8)__ffs64(mem->physical_addr_mask);

No need for the linebreak here - just let it stick out.

> +		else
> +			__entry->pa_mask_lsb = ~0;
> +		snprintf(__entry->fru_id, 39, "%pUl", fru_id);

Yeah, I didn't catch the reasoning behind why we need to convert the FRU
into a string and not leave it simply as u8[16]...

> +		__assign_str(fru_text, fru_text);
> +		cper_mem_err_pack(mem, __entry->data);
> +	),
> +
> +	TP_printk("{%d} %s error: %s physical addr: %016llx (mask lsb: %x) %sFRU: %s %.20s",
> +		  __entry->err_seq,
> +		  cper_severity_str(__entry->sev),
> +		  cper_mem_err_type_str(__entry->etype),
> +		  __entry->pa,
> +		  __entry->pa_mask_lsb,
> +		  cper_mem_err_unpack(p, __entry->data),
> +		  __entry->fru_id,
> +		  __get_str(fru_text))
> +);
>  
>  /*
>   * Hardware Events Report
> -- 
> 2.0.0.rc2
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
