Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaCEQZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:25:51 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62477 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaCEQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:25:50 -0500
MIME-Version: 1.0
In-Reply-To: <20140305095155.GA1835@krava.brq.redhat.com>
References: <1393896396-10427-1-git-send-email-artagnon@gmail.com> <20140305095155.GA1835@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 5 Mar 2014 11:25:09 -0500
Message-ID: <CALkWK0npg=XSnB0jCN9E60MoQNskhrcuV7YYZF_4-bCKnKWLcg@mail.gmail.com>
Subject: Re: [PATCH] perf kvm: introduce --list-cmds for use by scripts
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> On Mon, Mar 03, 2014 at 08:26:36PM -0500, Ramkumar Ramachandra wrote:
>> Introduce
>>
>>   $ perf kvm --list-cmds
>>
>> to dump a raw list of commands for use by the completion script. In
>> order to do this, introduce parse_options_subcommand() for handling
>> subcommands as a special case in the parse-options machinery.
>
> so this doesn't change the behaviour at all, right?

It just introduces --list-cmds; no, it doesn't change behavior otherwise.

>>
>> -     argc = parse_options(argc, argv, kvm_options, kvm_usage,
>> -                     PARSE_OPT_STOP_AT_NON_OPTION);
>> +     argc = parse_options_subcommand(argc, argv, kvm_options, kvm_subcommands, kvm_usage,
>> +                                     PARSE_OPT_STOP_AT_NON_OPTION);
>>       if (!argc)
>>               usage_with_options(kvm_usage, kvm_options);
>>
>> diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
>> index 496e2ab..ae3a576 100644
>> --- a/tools/perf/perf-completion.sh
>> +++ b/tools/perf/perf-completion.sh
>> @@ -123,7 +123,7 @@ __perf_main ()
>>               __perfcomp_colon "$evts" "$cur"
>>       # List subcommands for 'perf kvm'
>>       elif [[ $prev == "kvm" ]]; then
>> -             subcmds="top record report diff buildid-list stat"
>> +             subcmds=$($cmd $prev --list-cmds)
>
> Do we want some generic approach here.. if we're
> adding generic --list-cmds option anyway.. hm?

Currently, we're using $cmd $prev --list-cmds instead of hard-coding a
list for 'perf kvm'. Once I submit future patches to convert other
commands to use parse_options_subcommand(), we can use the same line
for completions.

Or did you mean something else when you said generic approach?

>> -int parse_options(int argc, const char **argv, const struct option *options,
>> -               const char * const usagestr[], int flags)
>> +int parse_options_subcommand(int argc, const char **argv, const struct option *options,
>> +                     const char *const subcommands[], const char *usagestr[], int flags)
>>  {
>>       struct parse_opt_ctx_t ctx;
>>
>>       perf_header__set_cmdline(argc, argv);
>>
>> +     /* build usage string if it's not provided */
>> +     if (subcommands && !usagestr[0]) {
>> +             struct strbuf buf = STRBUF_INIT;
>> +
>> +             strbuf_addf(&buf, "perf %s [<options>] {", argv[0]);
>> +             for (int i = 0; subcommands[i]; i++) {
>> +                     if (i)
>> +                             strbuf_addstr(&buf, "|");
>> +                     strbuf_addstr(&buf, subcommands[i]);
>> +             }
>> +             strbuf_addstr(&buf, "}");
>> +
>> +             usagestr[0] = strdup(buf.buf);
>> +             strbuf_release(&buf);
>> +     }
>
> is above code ever used now?

Yeah; note that kvm_usage is initialized to { NULL, NULL } and passed
-- this code fills in the usage string then.
