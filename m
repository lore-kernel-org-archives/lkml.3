Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967310Ab3HICt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:49:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51245 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab3HICtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 22:49:25 -0400
Message-ID: <520458B4.90003@gmail.com>
Date: Thu, 08 Aug 2013 22:49:24 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/19] perf top: Use new idle_sym check
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com> <1375930261-77273-8-git-send-email-dsahern@gmail.com> <20130808150647.GB6102@ghostprotocols.net>
In-Reply-To: <20130808150647.GB6102@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/13 11:06 AM, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 07, 2013 at 10:50:49PM -0400, David Ahern escreveu:
>> Avoids strcmp processing each sample.
>
> How so? This is done just when loading a DSO, when then each symbol is
> checked against this list.

hmmm.... see that now, yes. The timehist command wants to know idle 
times, not just filter them out like perf-top does.

David

>
> Tangentially, Frédéric, wasn't there a patchset from you that marks the
> context of idle samples, in perf_event_header->misc, additiotally to
> PERF_RECORD_MISC_KERNEL, etc? I think there were some for IRQ context as
> well, right?
>
> - Arnaldo
>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Stephane Eranian <eranian@google.com>
>> ---
>>   tools/perf/builtin-top.c |   25 ++-----------------------
>>   1 file changed, 2 insertions(+), 23 deletions(-)
>>
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index 440c3b3..8eb0e3a 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -634,26 +634,9 @@ repeat:
>>   	return NULL;
>>   }
>>
>> -/* Tag samples to be skipped. */
>> -static const char *skip_symbols[] = {
>> -	"intel_idle",
>> -	"default_idle",
>> -	"native_safe_halt",
>> -	"cpu_idle",
>> -	"enter_idle",
>> -	"exit_idle",
>> -	"mwait_idle",
>> -	"mwait_idle_with_hints",
>> -	"poll_idle",
>> -	"ppc64_runlatch_off",
>> -	"pseries_dedicated_idle_sleep",
>> -	NULL
>> -};
>> -
>>   static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
>>   {
>>   	const char *name = sym->name;
>> -	int i;
>>
>>   	/*
>>   	 * ppc64 uses function descriptors and appends a '.' to the
>> @@ -671,12 +654,8 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
>>   	    strstr(name, "_text_end"))
>>   		return 1;
>>
>> -	for (i = 0; skip_symbols[i]; i++) {
>> -		if (!strcmp(skip_symbols[i], name)) {
>> -			sym->ignore = true;
>> -			break;
>> -		}
>> -	}
>> +	if (symbol__is_idle(sym))
>> +		sym->ignore = true;
>>
>>   	return 0;
>>   }
>> --
>> 1.7.10.1

