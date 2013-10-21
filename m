Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3JUS3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:29:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:9369 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab3JUS3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:29:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414655008"
Message-ID: <52657278.7050208@intel.com>
Date: Mon, 21 Oct 2013 21:29:12 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/19] perf tools: Fix 32-bit cross build
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-10-git-send-email-adrian.hunter@intel.com> <20131021141228.GA2245@ghostprotocols.net>
In-Reply-To: <20131021141228.GA2245@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/10/2013 5:12 p.m., Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 18, 2013 at 03:29:06PM +0300, Adrian Hunter escreveu:
>> Setting EXTRA_CFLAGS=-m32 did not work because CFLAGS
>> was not passed around.

Unfortunately passing CFLAGS seems to break some of the
tests, so this needs more work.

>
> <SNIP>
>
>> index c873e03..699cdb7 100644
>> --- a/tools/perf/Makefile.perf
>> +++ b/tools/perf/Makefile.perf
>> @@ -706,7 +706,7 @@ $(LIB_FILE): $(LIB_OBJS)
>>   TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
>>
>>   $(LIBTRACEEVENT): $(TE_SOURCES)
>> -	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
>> +	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) CFLAGS="-g -Wall $(EXTRA_CFLAGS)" libtraceevent.a
>
> So are we unconditionally set -g and -Wall?

They are the defaults from tools/lib/traceevent/Makefile
if CFLAGS is not set.  It seemed reasonably to keep them
the same.

>
> And by making CFLAGS be $(EXTRA_CFLAGS) implies EXTRA_CFLAGS already
> contains "$(CFLAGS)?

No I was intending to pass only -m32

>
> - Arnaldo
>
>>
>>   $(LIBTRACEEVENT)-clean:
>>   	$(call QUIET_CLEAN, libtraceevent)
>> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
>> index c516d6b..c94a06b 100644
>> --- a/tools/perf/config/Makefile
>> +++ b/tools/perf/config/Makefile
>> @@ -92,7 +92,7 @@ endif
>>
>>   feature_check = $(eval $(feature_check_code))
>>   define feature_check_code
>> -  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
>> +  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(CFLAGS)" LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
>>   endef
>>
>>   feature_set = $(eval $(feature_set_code))
>> @@ -169,7 +169,7 @@ ifeq ($(feature-all), 1)
>>     #
>>     $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
>>   else
>> -  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
>> +  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
>>     $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
>>   endif
>>
>> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
>> index 452b67c..353c00c 100644
>> --- a/tools/perf/config/feature-checks/Makefile
>> +++ b/tools/perf/config/feature-checks/Makefile
>> @@ -31,7 +31,7 @@ CC := $(CC) -MD
>>
>>   all: $(FILES)
>>
>> -BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
>> +BUILD = $(CC) $(CFLAGS) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
>>
>>   ###############################
>>
>> --
>> 1.7.11.7
