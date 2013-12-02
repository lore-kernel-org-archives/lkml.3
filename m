Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab3LBFFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:05:23 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39544 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3LBFFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:05:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130116235102.16015.77379.stgit@grignak.americas.hpqcorp.net>
References: <20130116235102.16015.77379.stgit@grignak.americas.hpqcorp.net>
Date: Mon, 2 Dec 2013 13:05:16 +0800
Message-ID: <CANVTcTaP18CiGOSEcX5Ch_wPw9mEhkgokfp+d+ZOMFD+Ce4juA@mail.gmail.com>
Subject: Re: [PATCH v10 1/3] aerdrv: Trace Event for AER
From: rui wang <ruiv.wang@gmail.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@intel.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        gong.chen@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/13, Lance Ortiz <lance.ortiz@hp.com> wrote:
> This header file will define a new trace event that will be triggered when
> a AER event occurs.  The following data will be provided to the trace
> event.
>
> char * dev_name - The name of the slot where the device resides
>                   ([domain:]bus:device.function).
>
> u32 status - Either the correctable or uncorrectable register
>              indicating what error or errors have been see.
>
> u8 severity - error severity 0:NONFATAL 1:FATAL 2:CORRECTED
>
> The trace event will also provide a trace string that may look like:
>
> "0000:05:00.0 PCIe Bus Error:severity=Uncorrected (Non-Fatal), Poisoned
> TLP"
>
> v1-v2 Move header from include/ras/aer_event.h to
> include/trace/events/ras.h
> v3-v4 Cleaned up comments and commit header
> v4-v5 More cleanup remove () from if statement in print.
>       Renamed string define to be more specific.
> v5-v6 change TRACE_SYSTEM define to be ras and not aer.
>
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Acked-by: Tony Luck <tony.luck@intel.com>
> ---
>
>  include/trace/events/ras.h |   77
> ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 77 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/ras.h
>
> diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
> new file mode 100644
> index 0000000..88b8783
> --- /dev/null
> +++ b/include/trace/events/ras.h
> @@ -0,0 +1,77 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ras
> +
> +#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_AER_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/edac.h>
> +
> +
> +/*
> + * PCIe AER Trace event
> + *
> + * These events are generated when hardware detects a corrected or
> + * uncorrected event on a PCIe device. The event report has
> + * the following structure:
> + *
> + * char * dev_name -	The name of the slot where the device resides
> + *			([domain:]bus:device.function).
> + * u32 status -		Either the correctable or uncorrectable register
> + *			indicating what error or errors have been seen
> + * u8 severity -	error severity 0:NONFATAL 1:FATAL 2:CORRECTED
> + */
> +
> +#define aer_correctable_errors		\
> +	{BIT(0),	"Receiver Error"},		\
> +	{BIT(6),	"Bad TLP"},			\
> +	{BIT(7),	"Bad DLLP"},			\
> +	{BIT(8),	"RELAY_NUM Rollover"},		\
> +	{BIT(12),	"Replay Timer Timeout"},	\
> +	{BIT(13),	"Advisory Non-Fatal"}
> +
> +#define aer_uncorrectable_errors		\
> +	{BIT(4),	"Data Link Protocol"},		\
> +	{BIT(12),	"Poisoned TLP"},		\
> +	{BIT(13),	"Flow Control Protocol"},	\
> +	{BIT(14),	"Completion Timeout"},		\
> +	{BIT(15),	"Completer Abort"},		\
> +	{BIT(16),	"Unexpected Completion"},	\
> +	{BIT(17),	"Receiver Overflow"},		\
> +	{BIT(18),	"Malformed TLP"},		\
> +	{BIT(19),	"ECRC"},			\
> +	{BIT(20),	"Unsupported Request"}
> +
> +TRACE_EVENT(aer_event,
> +	TP_PROTO(const char *dev_name,
> +		 const u32 status,
> +		 const u8 severity),
> +
> +	TP_ARGS(dev_name, status, severity),
> +
> +	TP_STRUCT__entry(
> +		__string(	dev_name,	dev_name	)
> +		__field(	u32,		status		)
> +		__field(	u8,		severity	)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__entry->status		= status;
> +		__entry->severity	= severity;
> +	),
> +
> +	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
> +		__get_str(dev_name),
> +		__entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
> +			__entry->severity == HW_EVENT_ERR_FATAL ?
> +			"Fatal" : "Uncorrected",
> +		__entry->severity == HW_EVENT_ERR_CORRECTED ?
> +		__print_flags(__entry->status, "|", aer_correctable_errors) :
> +		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
> +);

This causes inconsistency between dmesg and the trace event output.
When dmesg says "severity=Corrected", the trace event says
"severity=Fatal". What happens is that HW_EVENT_ERR_CORRECTED is
defined in edac.h:

enum hw_event_mc_err_type {
        HW_EVENT_ERR_CORRECTED,
        HW_EVENT_ERR_UNCORRECTED,
        HW_EVENT_ERR_FATAL,
        HW_EVENT_ERR_INFO,
};

while aer_print_error() uses aer_error_severity_string[] defined as:

static const char *aer_error_severity_string[] = {
        "Uncorrected (Non-Fatal)",
        "Uncorrected (Fatal)",
        "Corrected"
};

In this case dmesg is correct because info->severity is assigned in
aer_isr_one_error() using the definitions in include/linux/ras.h:
#define AER_NONFATAL                    0
#define AER_FATAL                       1
#define AER_CORRECTABLE                 2

So which one is the standard? Is there a plan to unify all these names?

Thanks
Rui Wang
> +
> +#endif /* _TRACE_AER_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
