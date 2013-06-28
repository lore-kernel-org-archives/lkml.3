Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124Ab3F1G0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 02:26:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:58977 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab3F1G0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 02:26:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,957,1363158000"; 
   d="scan'208";a="323775119"
Message-ID: <51CD2DFE.6070704@intel.com>
Date: Fri, 28 Jun 2013 09:32:30 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 06/15] perf tools: fix parse_events_terms() freeing
 local variable on error path
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-7-git-send-email-adrian.hunter@intel.com> <51CC64A7.6040305@gmail.com>
In-Reply-To: <51CC64A7.6040305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/13 19:13, David Ahern wrote:
> On 6/27/13 1:54 AM, Adrian Hunter wrote:
>> The list_head is on the stack, so just free the rest of the list.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   tools/perf/util/parse-events.c | 7 ++++++-
>>   tools/perf/util/parse-events.h | 1 +
>>   tools/perf/util/pmu.c          | 2 +-
>>   3 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>> index 995fc25..d9cb055 100644
>> --- a/tools/perf/util/parse-events.c
>> +++ b/tools/perf/util/parse-events.c
>> @@ -1231,12 +1231,17 @@ int parse_events_term__clone(struct
>> parse_events_term **new,
>>               term->val.str, term->val.num);
>>   }
>>
>> -void parse_events__free_terms(struct list_head *terms)
>> +void parse_events__free_terms_only(struct list_head *terms)
>>   {
>>       struct parse_events_term *term, *h;
>>
>>       list_for_each_entry_safe(term, h, terms, list)
>>           free(term);
>> +}
>> +
>> +void parse_events__free_terms(struct list_head *terms)
>> +{
>> +    parse_events__free_terms_only(terms);
>>
>>       free(terms);
>>   }
> 
> Seems like you can just fix parse_events__free_terms to do the right thing
> and not call free(terms) -- ie., no need for a separate "only" function.
> From there only test_term() needs to do the free(terms) and since it mallocs
> the memory there it is nicely symmetrical.

There are 2 more calls to parse_events__free_terms in util/parse-events.y

