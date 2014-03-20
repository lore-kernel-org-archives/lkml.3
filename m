Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbaCTQbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:31:08 -0400
Received: from 16.mo4.mail-out.ovh.net ([188.165.55.104]:52724 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754216AbaCTQbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:31:06 -0400
X-Greylist: delayed 1798 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 12:31:06 EDT
Message-ID: <532AF29E.3040207@metascale.org>
Date: Thu, 20 Mar 2014 14:52:30 +0100
From: Adrien BAK <adrien.bak@metascale.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mathias Gaunard <mathias.gaunard@metascale.org>
Subject: Re: [PATCH] perf-script : improves option passing mechansim
References: <53286FBD.4050901@metascale.org> <20140318181525.GE6482@ghostprotocols.net>
In-Reply-To: <20140318181525.GE6482@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1065382787720950870
X-Ovh-Remote: 193.55.35.23 (pc35-23.digiteo.u-psud.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed. I wasn't aware of the '--' behaviour and the documentation 
doesn't seem to mention it. My patch essentially implements the same 
behaviour, except that the script name itself is used to separate the 
options. I guess there is not much need the proposed patch then.

Sorry for the wasted time.
Adrien

On 03/18/2014 07:15 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Mar 18, 2014 at 05:09:33PM +0100, Adrien BAK escreveu:
>> This pull request fixes the following issues :
>> * when passing custom arguments to a script, if those arguments are
>>   not declared within perf, they prevent the execution of perf.
>> e.g.
>>
>> perf script -i path/to/perf.data -s my_script -arg1 arg_value
>>
>> perf will issue an error message and no processing will occur
> I haven't tested this, but what comes to mind is the use of -- to
> separate what options should be processed by perf and which ones should
> be left to the script, is that what you're fixing?
>
> - Arnaldo
>   
>> * when passing custom arguments to a script, if those arguments are
>>   declared by perf, they are consumed and not passed to the script.
>> e.g.
>> perf script -i path/to/perf.data -s my_script -h
>>
>> perf will display its own help message, instead of the expected help
>> message from my_script.
>>
>> These issues are addressed as follows :
>> * The parse option flag is changed from PARSE_OPT_STOP_AT_NON_OPTION to
>> PARSE_OPT_KEEP_UNKNOWN
>> * A new option type is introduce OPT_CALLBACK_FINAL_OPTION, which
>> effectively
>>   prevents the parsing of all options located after the script.
>>
>> Signed-off-by: Adrien Bak <adrien.bak@metascale.org>
>>
>> ---
>>
>>   tools/perf/builtin-script.c     | 8 ++++----
>>   tools/perf/util/parse-options.c | 4 ++++
>>   tools/perf/util/parse-options.h | 5 +++++
>>   3 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index 9e9c91f..3cd6a46 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -1523,9 +1523,9 @@ int cmd_script(int argc, const char **argv,
>> const char *prefix __maybe_unused)
>>               "show latency attributes (irqs/preemption disabled, etc)"),
>>       OPT_CALLBACK_NOOPT('l', "list", NULL, NULL, "list available scripts",
>>                  list_available_scripts),
>> -    OPT_CALLBACK('s', "script", NULL, "name",
>> -             "script file name (lang:script name, script name, or *)",
>> -             parse_scriptname),
>> +    OPT_CALLBACK_FINAL_OPTION('s', "script", NULL, "name",
>> +                  "script file name (lang:script name, script name, or *)",
>> +                  parse_scriptname),
>>       OPT_STRING('g', "gen-script", &generate_script_lang, "lang",
>>              "generate perf-script.xx script in specified language"),
>>       OPT_STRING('i', "input", &input_name, "file", "input file name"),
>> @@ -1578,7 +1578,7 @@ int cmd_script(int argc, const char **argv,
>> const char *prefix __maybe_unused)
>>       setup_scripting();
>>
>>       argc = parse_options(argc, argv, options, script_usage,
>> -                 PARSE_OPT_STOP_AT_NON_OPTION);
>> +                 PARSE_OPT_KEEP_UNKNOWN);
>>
>>       file.path = input_name;
>>
>> diff --git a/tools/perf/util/parse-options.c
>> b/tools/perf/util/parse-options.c
>> index d22e3f8..77f566d 100644
>> --- a/tools/perf/util/parse-options.c
>> +++ b/tools/perf/util/parse-options.c
>> @@ -112,6 +112,8 @@ static int get_value(struct parse_opt_ctx_t *p,
>>               return (*opt->callback)(opt, NULL, 0) ? (-1) : 0;
>>           if (get_arg(p, opt, flags, &arg))
>>               return -1;
>> +        if (opt->flags & PARSE_OPT_FINAL_OPTION)
>> +            return (*opt->callback)(opt, arg, 0)?(-1) : (-3);
>>           return (*opt->callback)(opt, arg, 0) ? (-1) : 0;
>>
>>       case OPTION_INTEGER:
>> @@ -366,6 +368,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
>>                   return parse_options_usage(usagestr, options, arg + 1, 1);
>>               case -2:
>>                   goto unknown;
>> +            case -3:
>> +                return PARSE_OPT_DONE;
>>               default:
>>                   break;
>>               }
>> diff --git a/tools/perf/util/parse-options.h
>> b/tools/perf/util/parse-options.h
>> index cbf0149..b1fa6b6 100644
>> --- a/tools/perf/util/parse-options.h
>> +++ b/tools/perf/util/parse-options.h
>> @@ -38,6 +38,7 @@ enum parse_opt_option_flags {
>>       PARSE_OPT_NONEG   = 4,
>>       PARSE_OPT_HIDDEN  = 8,
>>       PARSE_OPT_LASTARG_DEFAULT = 16,
>> +    PARSE_OPT_FINAL_OPTION = 32,
>>   };
>>
>>   struct option;
>> @@ -123,6 +124,10 @@ struct option {
>>       { .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),
>> .value = (v), .argh = "time", .help = (h), .callback =
>> parse_opt_approxidate_cb }
>>   #define OPT_CALLBACK(s, l, v, a, h, f) \
>>       { .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),
>> .value = (v), (a), .help = (h), .callback = (f) }
>> +#define OPT_CALLBACK_FINAL_OPTION(s, l, v, a, h, f) \
>> +    { .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),\
>> +    .value = (v), (a), .help = (h), .callback = (f),\
>> +    .flags = PARSE_OPT_FINAL_OPTION}
>>   #define OPT_CALLBACK_NOOPT(s, l, v, a, h, f) \
>>       { .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l),
>> .value = (v), (a), .help = (h), .callback = (f), .flags =
>> PARSE_OPT_NOARG }
>>   #define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \

