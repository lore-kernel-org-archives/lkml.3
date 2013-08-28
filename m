Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3H1NUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:20:15 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62609 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3H1NUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <521BD4F8.5050504@gmail.com>
References: <20130826131121.GA26224@quad>
	<521BD4F8.5050504@gmail.com>
Date: Wed, 28 Aug 2013 15:20:10 +0200
Message-ID: <CABPqkBQAkPp8OWLUs0GuL4QiFWv01UNvBdU78u9d5nzSaVBs3w@mail.gmail.com>
Subject: Re: [PATCH] perf mem: add priv level filtering support
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:21 AM, David Ahern <dsahern@gmail.com> wrote:
>
> On 8/26/13 7:11 AM, Stephane Eranian wrote:
>>
>> perf mem: add priv level filtering support
>>
>> This patch adds the -u -and -k options to perf to allow
>> filtering of load/store sampling based on priv levels.
>> This may not be supported by all HW platforms.
>>
>> By default, loads/stores are sampled at both user and
>> kernel privilege levels.
>>
>> To sample only at the user level:
>> $ perf mem -u -t load rec ......
>>
>> To sample only at the kernel level:
>> $ perf mem -k -t load rec ......
>>
>> Man page updated accordingly.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>
>> diff --git a/tools/perf/Documentation/perf-mem.txt b/tools/perf/Documentation/perf-mem.txt
>> index 888d511..4c4e405 100644
>> --- a/tools/perf/Documentation/perf-mem.txt
>> +++ b/tools/perf/Documentation/perf-mem.txt
>> @@ -43,6 +43,12 @@ OPTIONS
>>         option can be passed in record mode. It will be interpreted the same way as perf
>>         record.
>>
>> +-k::
>> +       Only sample loads/stores at the user level (default: user + kernel)
>> +
>> +-u::
>> +       Only sample loads/stores at the kernel level (default: user + kernel)
>
>
> Are the descriptions backwards? In the commit message yuo have -u means user level and -k means kernel level; the help message here seems backwards.
>
You are right. Let me resubmit....
Thanks.

>
> David
>
>
>
>> +
>>   SEE ALSO
>>   --------
>>   linkperf:perf-record[1], linkperf:perf-report[1]
>> diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
>> index 706a1fa..8ac9d1e 100644
>> --- a/tools/perf/builtin-mem.c
>> +++ b/tools/perf/builtin-mem.c
>> @@ -9,13 +9,18 @@
>>   #define MEM_OPERATION_LOAD    "load"
>>   #define MEM_OPERATION_STORE   "store"
>>
>> -static const char      *mem_operation          = MEM_OPERATION_LOAD;
>> +#define OP_LOAD                0x1
>> +#define OP_STORE       0x2
>> +
>>
>>   struct perf_mem {
>>         struct perf_tool        tool;
>>         char const              *input_name;
>>         bool                    hide_unresolved;
>> +       const char              *mem_op;
>>         bool                    dump_raw;
>> +       bool                    user;
>> +       bool                    kernel;
>>         const char              *cpu_list;
>>         DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
>>   };
>> @@ -25,35 +30,88 @@ static const char * const mem_usage[] = {
>>         NULL
>>   };
>>
>> -static int __cmd_record(int argc, const char **argv)
>> +static inline const char *get_plm(struct perf_mem *mem)
>> +{
>> +       const char *plm = "";
>> +
>> +       if (mem->user && !mem->kernel) {
>> +               plm = "u";
>> +       } else if (!mem->user && mem->kernel) {
>> +               plm = "k";
>> +       }
>> +       return plm;
>> +}
>> +
>> +static int __cmd_record(int argc, const char **argv, struct perf_mem *mem)
>>   {
>>         int rec_argc, i = 0, j;
>>         const char **rec_argv;
>> -       char event[64];
>> -       int ret;
>> +       char *str;
>> +       int mode = 0;
>> +       int ki, ret;
>> +
>> +
>> +       if (!strcmp(mem->mem_op, MEM_OPERATION_STORE))
>> +               mode |= OP_STORE;
>> +       else if (!strcmp(mem->mem_op, MEM_OPERATION_LOAD))
>> +               mode |= OP_LOAD;
>> +       else  {
>> +               fprintf(stderr, "unknown sampling mode: %s\n", mem->mem_op);
>> +               return -1;
>> +       }
>>
>> -       rec_argc = argc + 4;
>> +       rec_argc = argc + 6;
>>         rec_argv = calloc(rec_argc + 1, sizeof(char *));
>>         if (!rec_argv)
>>                 return -1;
>>
>>         rec_argv[i++] = strdup("record");
>> -       if (!strcmp(mem_operation, MEM_OPERATION_LOAD))
>> -               rec_argv[i++] = strdup("-W");
>> +
>>         rec_argv[i++] = strdup("-d");
>> -       rec_argv[i++] = strdup("-e");
>>
>> -       if (strcmp(mem_operation, MEM_OPERATION_LOAD))
>> -               sprintf(event, "cpu/mem-stores/pp");
>> -       else
>> -               sprintf(event, "cpu/mem-loads/pp");
>> +        if (mode & OP_LOAD) {
>> +                rec_argv[i++] = strdup("-W");
>>
>> -       rec_argv[i++] = strdup(event);
>> -       for (j = 1; j < argc; j++, i++)
>> -               rec_argv[i] = argv[j];
>> +                rec_argv[i++] = strdup("-e");
>> +
>> +                str = malloc(strlen("cpu/mem-loads/pp") + 1 + 1);
>> +                if (!str) {
>> +                        ki = i;
>> +                        ret = -1;
>> +                        goto end;
>> +                }
>> +                sprintf(str, "cpu/mem-loads/%spp", get_plm(mem));
>> +                rec_argv[i++] = str;
>> +        }
>> +
>> +        if (mode & OP_STORE) {
>> +                rec_argv[i++] = strdup("-e");
>> +
>> +                str = malloc(strlen("cpu/mem-stores/pp") + 1 + 1);
>> +                if (!str) {
>> +                        ki = i;
>> +                        ret = -1;
>> +                        goto end;
>> +                }
>> +                sprintf(str, "cpu/mem-stores/%spp", get_plm(mem));
>> +                rec_argv[i++] = str;
>> +        }
>> +
>> +        /* arguments after i are not malloc'd */
>> +        ki = i;
>>
>> -       ret = cmd_record(i, rec_argv, NULL);
>> +       for (j = 1; j < argc; j++, ki++)
>> +               rec_argv[ki] = argv[j];
>> +
>> +       ret = cmd_record(ki, rec_argv, NULL);
>> +
>> +end:
>> +       /*
>> +        * XXX: free rec_argv[] entries, difficult because
>> +        * cmd_record() drops some of them...
>> +        */
>>         free(rec_argv);
>> +
>>         return ret;
>>   }
>>
>> @@ -171,7 +229,7 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
>>          * there is no weight (cost) associated with stores, so don't print
>>          * the column
>>          */
>> -       if (strcmp(mem_operation, MEM_OPERATION_LOAD))
>> +       if (strcmp(mem->mem_op, MEM_OPERATION_LOAD))
>>                 rep_argv[i++] = strdup("--sort=mem,sym,dso,symbol_daddr,"
>>                                        "dso_daddr,tlb,locked");
>>
>> @@ -199,7 +257,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
>>                 .input_name              = "perf.data",
>>         };
>>         const struct option mem_options[] = {
>> -       OPT_STRING('t', "type", &mem_operation,
>> +       OPT_STRING('t', "type", &mem.mem_op,
>>                    "type", "memory operations(load/store)"),
>>         OPT_BOOLEAN('D', "dump-raw-samples", &mem.dump_raw,
>>                     "dump raw samples in ASCII"),
>> @@ -213,13 +271,18 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
>>                    "separator",
>>                    "separator for columns, no spaces will be added"
>>                    " between columns '.' is reserved."),
>> +       OPT_BOOLEAN('u', "user-level", &mem.user,
>> +                   "include user-level accesses"),
>> +       OPT_BOOLEAN('k', "kernel-level", &mem.kernel,
>> +                   "include kernel-level accesses"),
>>         OPT_END()
>>         };
>>
>>         argc = parse_options(argc, argv, mem_options, mem_usage,
>>                              PARSE_OPT_STOP_AT_NON_OPTION);
>>
>> -       if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
>> +       if (!argc || !(strncmp(argv[0], "rec", 3)
>> +                      || strncmp(argv[0], "rep", 3)))
>>                 usage_with_options(mem_usage, mem_options);
>>
>>         if (!mem.input_name || !strlen(mem.input_name)) {
>> @@ -228,9 +291,12 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
>>                 else
>>                         mem.input_name = "perf.data";
>>         }
>> +       /* default to load only, some processors only support loads */
>> +       if (!mem.mem_op)
>> +               mem.mem_op = MEM_OPERATION_LOAD;
>>
>>         if (!strncmp(argv[0], "rec", 3))
>> -               return __cmd_record(argc, argv);
>> +               return __cmd_record(argc, argv, &mem);
>>         else if (!strncmp(argv[0], "rep", 3))
>>                 return report_events(argc, argv, &mem);
>>         else
>>
>
