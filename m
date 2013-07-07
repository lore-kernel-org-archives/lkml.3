Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3GGQpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 12:45:21 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62421 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3GGQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 12:45:17 -0400
Message-ID: <51D99B19.3090107@gmail.com>
Date: Sun, 07 Jul 2013 10:45:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 6/6] perf parse events: demystify memory allocations
References: <1372793245-4136-1-git-send-email-dsahern@gmail.com> <1372793245-4136-7-git-send-email-dsahern@gmail.com> <20130707152623.GF23433@krava.brq.redhat.com>
In-Reply-To: <20130707152623.GF23433@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/7/13 9:26 AM, Jiri Olsa wrote:
> On Tue, Jul 02, 2013 at 01:27:25PM -0600, David Ahern wrote:
>> List heads are currently allocated way down the function chain in __add_event
>> and add_tracepoint and then freed when the scanner code calls
>> parse_events_update_lists.
>>
>> Be more explicit with where memory is allocated and who should free it. With
>> this patch the list_head is allocated in the scanner code and freed when the
>> scanner code calls parse_events_update_lists.
>>
>
> SNIP
>
>> @@ -266,9 +279,10 @@ event_legacy_mem:
>>   PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
>>   {
>>   	struct parse_events_evlist *data = _data;
>> -	struct list_head *list = NULL;
>> +	struct list_head *list;
>>
>> -	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
>> +	ALLOC_LIST(list);
>> +	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
>>   					     (void *) $2, $4));
>>   	$$ = list;
>>   }
>> @@ -276,9 +290,10 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
>>   PE_PREFIX_MEM PE_VALUE sep_dc
>>   {
>>   	struct parse_events_evlist *data = _data;
>> -	struct list_head *list = NULL;
>> +	struct list_head *list;
>>
>> -	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
>> +	ALLOC_LIST(list);
>> +	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
>>   					     (void *) $2, NULL));
>
> so who now frees the list if there's an error
> in parse_events_add_breakpoint?

According to valgrind that memory is not freed prior to this patch, so 
this one does not introduce new leaks.

>
> ditto for other ABORT_ON cases

I will whip up a patch to free memory on failure paths.

David

