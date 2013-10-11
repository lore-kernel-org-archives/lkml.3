Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3JKHwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:52:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42539 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3JKHwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:52:09 -0400
Date: Fri, 11 Oct 2013 09:52:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131011075202.GB18719@pd.tnic>
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
> +
> +/*
> + * MCE Extended Error Log Trace event

Right, we have a perfectly good header for ras TPs:

include/ras/ras_event.h

Mind adding this TP there please?

> + *
> + * These events are generated when hardware detects a corrected or
> + * uncorrected event.
> + *
> + */
> +
> +/* memory trace event */
> +
> +#define LOC_LEN		512
> +#define MSG_LEN		((LOC_LEN) * 2)
> +
> +TRACE_EVENT(extlog_mem_event,
> +	TP_PROTO(u32 etype,
> +		char *dimm_loc,
> +		const uuid_le *fru_id,
> +		char *fru_text,
> +		u64 error_count,
> +		u32 severity,
> +		u64 phy_addr,
> +		char *mem_loc),
> +
> +	TP_ARGS(etype, dimm_loc, fru_id, fru_text, error_count, severity,
> +		phy_addr, mem_loc),
> +
> +	TP_STRUCT__entry(
> +		__field(u32, etype)
> +		__dynamic_array(char, dimm_info, LOC_LEN)
> +		__field(u64, error_count)
> +		__field(u32, severity)
> +		__dynamic_array(char, msg, MSG_LEN)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->error_count = error_count;
> +		__entry->severity = severity;
> +		__entry->etype = etype;
> +		if (dimm_loc[0] != '\0')
> +			snprintf(__get_dynamic_array(dimm_info), LOC_LEN - 1,
> +				"on %s", dimm_loc);
> +		else
> +			__assign_str(dimm_info, "");
> +		if (phy_addr != 0)
> +			snprintf(__get_dynamic_array(msg), MSG_LEN - 1,
> +				"(FRU: %pUl %.20s physical addr: 0x%016llx%s)",
> +				fru_id, fru_text, phy_addr, mem_loc);
> +		else
> +			__assign_str(msg, "");
> +	),
> +
> +	TP_printk("%llu %s error%s:%s %s%s",
> +			__entry->error_count,
> +			cper_severity_str(__entry->severity),
> +			__entry->error_count > 1 ? "s" : "",
> +			cper_mem_err_type_str(__entry->etype),
> +			__get_str(dimm_info),
> +			__get_str(msg))
> +);
> +
> +#endif /* _TRACE_EXTLOG_H */
> +
> +/* This part must be outside protection */
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE extlog_trace
> +#include <trace/define_trace.h>
> diff --git a/include/linux/cper.h b/include/linux/cper.h
> index bd01c9a..c00eb55 100644
> --- a/include/linux/cper.h
> +++ b/include/linux/cper.h
> @@ -395,6 +395,8 @@ struct cper_sec_pcie {
>  #pragma pack()
>  
>  u64 cper_next_record_id(void);
> +const char *cper_severity_str(unsigned int);
> +const char *cper_mem_err_type_str(unsigned int);
>  void cper_print_bits(const char *prefix, unsigned int bits,
>  		     const char *strs[], unsigned int strs_size);
>  
> -- 
> 1.8.4.rc3
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
