Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3GBGUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:20:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:55569 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116Ab3GBGUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:20:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,978,1363158000"; 
   d="scan'208";a="325557647"
Message-ID: <51D27280.30007@intel.com>
Date: Tue, 02 Jul 2013 09:26:08 +0300
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
Subject: Re: [PATCH V3 06/15] perf tools: fix parse_events_terms() freeing
 local variable on error path
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com> <1372409006-8431-7-git-send-email-adrian.hunter@intel.com> <51CDC589.8070306@gmail.com> <51D13754.4080602@intel.com> <51D1CE93.7070804@gmail.com>
In-Reply-To: <51D1CE93.7070804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/13 21:46, David Ahern wrote:
> On 7/1/13 2:01 AM, Adrian Hunter wrote:
>> On 28/06/13 20:19, David Ahern wrote:
>>> On 6/28/13 2:43 AM, Adrian Hunter wrote:
>>>> The list_head is on the stack, so just free the rest of the list.
>>>>
>>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>>>> ---
>>>>    tools/perf/util/parse-events.c | 7 ++++++-
>>>>    tools/perf/util/parse-events.h | 1 +
>>>>    tools/perf/util/pmu.c          | 2 +-
>>>>    3 files changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/tools/perf/util/parse-events.c
>>>> b/tools/perf/util/parse-events.c
>>>> index 995fc25..d9cb055 100644
>>>> --- a/tools/perf/util/parse-events.c
>>>> +++ b/tools/perf/util/parse-events.c
>>>> @@ -1231,12 +1231,17 @@ int parse_events_term__clone(struct
>>>> parse_events_term **new,
>>>>                term->val.str, term->val.num);
>>>>    }
>>>>
>>>> -void parse_events__free_terms(struct list_head *terms)
>>>> +void parse_events__free_terms_only(struct list_head *terms)
>>>>    {
>>>>        struct parse_events_term *term, *h;
>>>>
>>>>        list_for_each_entry_safe(term, h, terms, list)
>>>>            free(term);
>>>> +}
>>>> +
>>>> +void parse_events__free_terms(struct list_head *terms)
>>>> +{
>>>> +    parse_events__free_terms_only(terms);
>>>>
>>>>        free(terms);
>>>>    }
>>>
>>> I still don't understand the reasoning for an _only function. There is only
>>> 1 place that mallocs the list_head and that 1 user should free its own
>>> memory. All of the other users pass a stack variable.
>>
>> No.  See parse-events.y
> 
> Fine. Fix both then. My point is that parse-events.c code should not be
> freeing memory it does not allocate.

No.  Read the code.  The 'head' member is shared with other lists.  It does
not make sense to turn a tiny bug-fix into such a lot of re-work.

>>
>> The list head is defined as a pointer in the YYTYPE stack element:
>>
>> %union
>> {
>>     char *str;
>>     u64 num;
>>     struct list_head *head;
>>     struct parse_events_term *term;
>> }
>>
>> It is malloc'ed when terms are created:
>>
>> event_term
>> {
>>     struct list_head *head = malloc(sizeof(*head));
>>     struct parse_events_term *term = $1;
>>
>>     ABORT_ON(!head);
>>     INIT_LIST_HEAD(head);
>>     list_add_tail(&term->list, head);
>>     $$ = head;
>> }
>>
> 
> 
> 

