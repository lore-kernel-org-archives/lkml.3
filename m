Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3LIIDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:03:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:22951 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab3LIIDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:03:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,856,1378882800"; 
   d="scan'208";a="449048043"
Message-ID: <52A57B12.1090609@intel.com>
Date: Mon, 09 Dec 2013 10:10:58 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH V2 2/3] perf script: Add an option to print the source
 line number
References: <1386315778-11633-1-git-send-email-adrian.hunter@intel.com> <1386315778-11633-3-git-send-email-adrian.hunter@intel.com> <52A4ADC8.3020202@gmail.com>
In-Reply-To: <52A4ADC8.3020202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/13 19:35, David Ahern wrote:
> On 12/6/13, 12:42 AM, Adrian Hunter wrote:
>> Add field 'srcline' that displays the source file name
>> and line number associated with the sample ip.  The
>> information displayed is the same as from addr2line.
> 
> example output?

            grep 10701/10701 2497321.421013:  ffffffff81043ffa native_write_msr_safe+0xa ([kernel.kallsyms])
  /usr/src/debug/kernel-3.9.fc17/linux-3.9.10-100.fc17.x86_64/arch/x86/include/asm/msr.h:95
            grep 10701/10701 2497321.421984:  ffffffff8165b6b3 _raw_spin_lock+0x13 ([kernel.kallsyms])
  /usr/src/debug/kernel-3.9.fc17/linux-3.9.10-100.fc17.x86_64/arch/x86/include/asm/spinlock.h:54
            grep 10701/10701 2497321.421990:  ffffffff810b64b3 tick_sched_timer+0x53 ([kernel.kallsyms])
  /usr/src/debug/kernel-3.9.fc17/linux-3.9.10-100.fc17.x86_64/kernel/time/tick-sched.c:840
            grep 10701/10701 2497321.421992:  ffffffff8106f63f run_timer_softirq+0x2f ([kernel.kallsyms])
  /usr/src/debug/kernel-3.9.fc17/linux-3.9.10-100.fc17.x86_64/kernel/timer.c:1372



> 
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   tools/perf/Documentation/perf-script.txt |  2 +-
>>   tools/perf/builtin-script.c              | 10 ++++++++++
>>   tools/perf/util/map.c                    | 17 +++++++++++++++++
>>   tools/perf/util/map.h                    |  2 ++
>>   tools/perf/util/session.c                |  8 ++++++++
>>   tools/perf/util/session.h                |  1 +
>>   6 files changed, 39 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/Documentation/perf-script.txt
>> b/tools/perf/Documentation/perf-script.txt
>> index cfdbb1e..c2a5071 100644
>> --- a/tools/perf/Documentation/perf-script.txt
>> +++ b/tools/perf/Documentation/perf-script.txt
>> @@ -115,7 +115,7 @@ OPTIONS
>>   -f::
>>   --fields::
>>           Comma separated list of fields to print. Options are:
>> -        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff.
>> +        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr,
>> symoff, srcline.
>>           Field list can be prepended with the type, trace, sw or hw,
>>           to indicate to which event type the field list applies.
>>           e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index 4484886..7a571fb 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -43,6 +43,7 @@ enum perf_output_field {
>>       PERF_OUTPUT_DSO             = 1U << 9,
>>       PERF_OUTPUT_ADDR            = 1U << 10,
>>       PERF_OUTPUT_SYMOFFSET       = 1U << 11,
>> +    PERF_OUTPUT_SRCLINE         = 1U << 12,
>>   };
>>
>>   struct output_option {
>> @@ -61,6 +62,7 @@ struct output_option {
>>       {.str = "dso",   .field = PERF_OUTPUT_DSO},
>>       {.str = "addr",  .field = PERF_OUTPUT_ADDR},
>>       {.str = "symoff", .field = PERF_OUTPUT_SYMOFFSET},
>> +    {.str = "srcline", .field = PERF_OUTPUT_SRCLINE},
>>   };
>>
>>   /* default set to maintain compatibility with current format */
>> @@ -210,6 +212,11 @@ static int perf_evsel__check_attr(struct perf_evsel
>> *evsel,
>>                  "to DSO.\n");
>>           return -EINVAL;
>>       }
>> +    if (PRINT_FIELD(SRCLINE) && !PRINT_FIELD(IP)) {
>> +        pr_err("Display of source line number requested but sample IP is
>> not\n"
>> +               "selected. Hence, no address to lookup the source line
>> number.\n");
>> +        return -EINVAL;
>> +    }
>>
>>       if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
>>           perf_evsel__check_stype(evsel, PERF_SAMPLE_TID, "TID",
>> @@ -245,6 +252,9 @@ static void set_print_ip_opts(struct perf_event_attr
>> *attr)
>>
>>       if (PRINT_FIELD(SYMOFFSET))
>>           output[type].print_ip_opts |= PRINT_IP_OPT_SYMOFFSET;
>> +
>> +    if (PRINT_FIELD(SRCLINE))
>> +        output[type].print_ip_opts |= PRINT_IP_OPT_SRCLINE;
>>   }
>>
>>   /*
>> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
>> index ef5bc91..9b9bd71 100644
>> --- a/tools/perf/util/map.c
>> +++ b/tools/perf/util/map.c
>> @@ -11,6 +11,7 @@
>>   #include "strlist.h"
>>   #include "vdso.h"
>>   #include "build-id.h"
>> +#include "util.h"
>>   #include <linux/string.h>
>>
>>   const char *map_type__name[MAP__NR_TYPES] = {
>> @@ -252,6 +253,22 @@ size_t map__fprintf_dsoname(struct map *map, FILE *fp)
>>       return fprintf(fp, "%s", dsoname);
>>   }
>>
>> +int map__fprintf_srcline(struct map *map, u64 addr, const char *prefix,
>> +             FILE *fp)
>> +{
>> +    char *srcline;
>> +    int ret = 0;
>> +
>> +    if (map && map->dso) {
>> +        srcline = get_srcline(map->dso,
>> +                      map__rip_2objdump(map, addr));
>> +        if (srcline != SRCLINE_UNKNOWN)
>> +            ret = fprintf(fp, "%s%s", prefix, srcline);
>> +        free_srcline(srcline);
>> +    }
>> +    return ret;
>> +}
>> +
>>   /**
>>    * map__rip_2objdump - convert symbol start address to objdump address.
>>    * @map: memory map
>> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
>> index e4e259c..18068c6 100644
>> --- a/tools/perf/util/map.h
>> +++ b/tools/perf/util/map.h
>> @@ -103,6 +103,8 @@ struct map *map__clone(struct map *map);
>>   int map__overlap(struct map *l, struct map *r);
>>   size_t map__fprintf(struct map *map, FILE *fp);
>>   size_t map__fprintf_dsoname(struct map *map, FILE *fp);
>> +int map__fprintf_srcline(struct map *map, u64 addr, const char *prefix,
>> +             FILE *fp);
>>
>>   int map__load(struct map *map, symbol_filter_t filter);
>>   struct symbol *map__find_symbol(struct map *map,
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index c236b38..e748f29 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -1497,6 +1497,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel,
>> struct perf_sample *sample,
>>       int print_dso = print_opts & PRINT_IP_OPT_DSO;
>>       int print_symoffset = print_opts & PRINT_IP_OPT_SYMOFFSET;
>>       int print_oneline = print_opts & PRINT_IP_OPT_ONELINE;
>> +    int print_srcline = print_opts & PRINT_IP_OPT_SRCLINE;
>>       char s = print_oneline ? ' ' : '\t';
>>
>>       if (symbol_conf.use_callchain && sample->callchain) {
>> @@ -1546,6 +1547,10 @@ void perf_evsel__print_ip(struct perf_evsel *evsel,
>> struct perf_sample *sample,
>>                   printf(")");
>>               }
>>
>> +            if (print_srcline)
>> +                map__fprintf_srcline(node->map, addr, "\n  ",
>> +                             stdout);
>> +
>>               if (!print_oneline)
>>                   printf("\n");
>>
>> @@ -1575,6 +1580,9 @@ next:
>>               map__fprintf_dsoname(al->map, stdout);
>>               printf(")");
>>           }
>> +
>> +        if (print_srcline)
>> +            map__fprintf_srcline(al->map, al->addr, "\n  ", stdout);
>>       }
>>   }
> 
> Why newline followed by space?

It looked better that way to me.

> 
> Otherwise, Acked-by: David Ahern <dsahern@gmail.com>
> 
> 
> 

