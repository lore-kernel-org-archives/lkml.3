Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab3LDP2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:28:15 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:57362 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3LDP2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:28:13 -0500
MIME-Version: 1.0
In-Reply-To: <CANVTcTabw2pxUP0iinepviavSLHT7AAyaQvA7e-mv2simbX7ow@mail.gmail.com>
References: <20130116235102.16015.77379.stgit@grignak.americas.hpqcorp.net>
	<CANVTcTabw2pxUP0iinepviavSLHT7AAyaQvA7e-mv2simbX7ow@mail.gmail.com>
Date: Wed, 4 Dec 2013 23:28:12 +0800
Message-ID: <CABawtvP3m_dAKaOLxNqHXQobsgk92ysh6H881i3eDASLi+-WAg@mail.gmail.com>
Subject: Re: [BUG] Re: [PATCH v10 1/3] aerdrv: Trace Event for AER
From: Ethan Zhao <ethan.kernel@gmail.com>
To: rui wang <ruiv.wang@gmail.com>
Cc: Lance Ortiz <lance.ortiz@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        lance_ortiz@hotmail.com, jiang.liu@intel.com, tony.luck@intel.com,
        bp@alien8.de, rostedt@goodmis.org, m.chehab@samsung.com,
        linux-acpi@vger.kernel.org, linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, gong.chen@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rui,
   Agree with that, there are really many such confusing error type definition
need to be standardized or unified, some of them are
ambiguous、inconsistent, some of them violates ACPI/PCI spec.

  According to the ACPI spec, the 'FATAL' in fact, is a sub-category
of 'UNCORRECTABLE' , the another one is 'NON-FATAL', then how to
understand the bebow 'UNCORRECTABLE's ?  mean  uncorrectable-non-fatal
? just guess, confusing.

acpi\actbl1.h

#define ACPI_EINJ_PROCESSOR_CORRECTABLE     (1)
#define ACPI_EINJ_PROCESSOR_UNCORRECTABLE   (1<<1)
#define ACPI_EINJ_PROCESSOR_FATAL           (1<<2)
#define ACPI_EINJ_MEMORY_CORRECTABLE        (1<<3)
#define ACPI_EINJ_MEMORY_UNCORRECTABLE      (1<<4)
#define ACPI_EINJ_MEMORY_FATAL              (1<<5)
#define ACPI_EINJ_PCIX_CORRECTABLE          (1<<6)
#define ACPI_EINJ_PCIX_UNCORRECTABLE        (1<<7)
#define ACPI_EINJ_PCIX_FATAL                (1<<8)
#define ACPI_EINJ_PLATFORM_CORRECTABLE      (1<<9)
#define ACPI_EINJ_PLATFORM_UNCORRECTABLE    (1<<10)
#define ACPI_EINJ_PLATFORM_FATAL            (1<<11)

edac.h

enum hw_event_mc_err_type {
HW_EVENT_ERR_CORRECTED,
HW_EVENT_ERR_UNCORRECTED,
HW_EVENT_ERR_FATAL,
HW_EVENT_ERR_INFO,
};

ghes.h
enum {
GHES_SEV_NO = 0x0,
GHES_SEV_CORRECTED = 0x1,
GHES_SEV_RECOVERABLE = 0x2,
GHES_SEV_PANIC = 0x3,
};

What's the meaning of GHES_SEV_PANIC ? Why not 'FATAL' , just as
described in ACPI spec section 18.3.2.6.1,
"
Error Severity 4 16 Identifies the error severity of the reported error:
0 – Recoverable
1 – Fatal
2 – Corrected
3 – None
"
If there is other intension, but could be seen translated into 'FATAL' later:

case GHES_SEV_PANIC:
  type = HW_EVENT_ERR_FATAL;

And these looks reasonable,
aer.h

#define AER_NONFATAL 0
#define AER_FATAL 1
#define AER_CORRECTABLE 2


Thanks,
Ethan

On Wed, Dec 4, 2013 at 11:10 AM, rui wang <ruiv.wang@gmail.com> wrote:
> Resending adding Mauro's new Email address...
>
>
> On 1/17/13, Lance Ortiz <lance.ortiz@hp.com> wrote:
>> This header file will define a new trace event that will be triggered when
>> a AER event occurs.  The following data will be provided to the trace
>> event.
>>
>> char * dev_name - The name of the slot where the device resides
>>                   ([domain:]bus:device.function).
>>
>> u32 status - Either the correctable or uncorrectable register
>>              indicating what error or errors have been see.
>>
>> u8 severity - error severity 0:NONFATAL 1:FATAL 2:CORRECTED
>>
>> The trace event will also provide a trace string that may look like:
>>
>> "0000:05:00.0 PCIe Bus Error:severity=Uncorrected (Non-Fatal), Poisoned
>> TLP"
>>
>> v1-v2 Move header from include/ras/aer_event.h to
>> include/trace/events/ras.h
>> v3-v4 Cleaned up comments and commit header
>> v4-v5 More cleanup remove () from if statement in print.
>>       Renamed string define to be more specific.
>> v5-v6 change TRACE_SYSTEM define to be ras and not aer.
>>
>> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
>> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Acked-by: Tony Luck <tony.luck@intel.com>
>> ---
>>
>>  include/trace/events/ras.h |   77
>> ++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 77 insertions(+), 0 deletions(-)
>>  create mode 100644 include/trace/events/ras.h
>>
>> diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
>> new file mode 100644
>> index 0000000..88b8783
>> --- /dev/null
>> +++ b/include/trace/events/ras.h
>> @@ -0,0 +1,77 @@
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM ras
>> +
>> +#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_AER_H
>> +
>> +#include <linux/tracepoint.h>
>> +#include <linux/edac.h>
>> +
>> +
>> +/*
>> + * PCIe AER Trace event
>> + *
>> + * These events are generated when hardware detects a corrected or
>> + * uncorrected event on a PCIe device. The event report has
>> + * the following structure:
>> + *
>> + * char * dev_name - The name of the slot where the device resides
>> + *                   ([domain:]bus:device.function).
>> + * u32 status -              Either the correctable or uncorrectable register
>> + *                   indicating what error or errors have been seen
>> + * u8 severity -     error severity 0:NONFATAL 1:FATAL 2:CORRECTED
>> + */
>> +
>> +#define aer_correctable_errors               \
>> +     {BIT(0),        "Receiver Error"},              \
>> +     {BIT(6),        "Bad TLP"},                     \
>> +     {BIT(7),        "Bad DLLP"},                    \
>> +     {BIT(8),        "RELAY_NUM Rollover"},          \
>> +     {BIT(12),       "Replay Timer Timeout"},        \
>> +     {BIT(13),       "Advisory Non-Fatal"}
>> +
>> +#define aer_uncorrectable_errors             \
>> +     {BIT(4),        "Data Link Protocol"},          \
>> +     {BIT(12),       "Poisoned TLP"},                \
>> +     {BIT(13),       "Flow Control Protocol"},       \
>> +     {BIT(14),       "Completion Timeout"},          \
>> +     {BIT(15),       "Completer Abort"},             \
>> +     {BIT(16),       "Unexpected Completion"},       \
>> +     {BIT(17),       "Receiver Overflow"},           \
>> +     {BIT(18),       "Malformed TLP"},               \
>> +     {BIT(19),       "ECRC"},                        \
>> +     {BIT(20),       "Unsupported Request"}
>> +
>> +TRACE_EVENT(aer_event,
>> +     TP_PROTO(const char *dev_name,
>> +              const u32 status,
>> +              const u8 severity),
>> +
>> +     TP_ARGS(dev_name, status, severity),
>> +
>> +     TP_STRUCT__entry(
>> +             __string(       dev_name,       dev_name        )
>> +             __field(        u32,            status          )
>> +             __field(        u8,             severity        )
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __assign_str(dev_name, dev_name);
>> +             __entry->status         = status;
>> +             __entry->severity       = severity;
>> +     ),
>> +
>> +     TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
>> +             __get_str(dev_name),
>> +             __entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
>> +                     __entry->severity == HW_EVENT_ERR_FATAL ?
>> +                     "Fatal" : "Uncorrected",
>> +             __entry->severity == HW_EVENT_ERR_CORRECTED ?
>> +             __print_flags(__entry->status, "|", aer_correctable_errors) :
>> +             __print_flags(__entry->status, "|", aer_uncorrectable_errors))
>> +);
>
> Here's a bug causing inconsistency between dmesg and the trace event output.
> When dmesg says "severity=Corrected", the trace event says
> "severity=Fatal". What happens is that HW_EVENT_ERR_CORRECTED is
> defined in edac.h:
>
> enum hw_event_mc_err_type {
>         HW_EVENT_ERR_CORRECTED,
>         HW_EVENT_ERR_UNCORRECTED,
>         HW_EVENT_ERR_FATAL,
>         HW_EVENT_ERR_INFO,
> };
>
> while aer_print_error() uses aer_error_severity_string[] defined as:
>
> static const char *aer_error_severity_string[] = {
>         "Uncorrected (Non-Fatal)",
>         "Uncorrected (Fatal)",
>         "Corrected"
> };
>
> In this case dmesg is correct because info->severity is assigned in
> aer_isr_one_error() using the definitions in include/linux/ras.h:
> #define AER_NONFATAL                    0
> #define AER_FATAL                       1
> #define AER_CORRECTABLE                 2
>
> So which one is the standard? Is there a plan to unify all these names?
>
> Thanks
> Rui Wang
>
>> +
>> +#endif /* _TRACE_AER_H */
>> +
>> +/* This part must be outside protection */
>> +#include <trace/define_trace.h>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
