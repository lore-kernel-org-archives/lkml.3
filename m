Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3JWGmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:42:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:60736 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3JWGmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,553,1378882800"; 
   d="scan'208";a="415583599"
Message-ID: <52676F96.6090000@intel.com>
Date: Wed, 23 Oct 2013 09:41:26 +0300
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
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 04/14] perf script: Set up output options for in-stream
 attributes
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com> <1382427258-17495-5-git-send-email-adrian.hunter@intel.com> <52676979.7020909@gmail.com>
In-Reply-To: <52676979.7020909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/13 09:15, David Ahern wrote:
> On 10/22/13 8:34 AM, Adrian Hunter wrote:
>> +static int process_attr(struct perf_tool *tool, union perf_event *event,
>> +            struct perf_evlist **pevlist)
>> +{
>> +    struct perf_script *scr = container_of(tool, struct perf_script, tool);
>> +    struct perf_evlist *evlist;
>> +    struct perf_evsel *evsel, *pos;
>> +    int err;
>> +
>> +    err = perf_event__process_attr(tool, event, pevlist);
>> +    if (err)
>> +        return err;
>> +
>> +    evlist = *pevlist;
>> +    evsel = perf_evlist__last(*pevlist);
> 
> This assumes new entries are added to the end of evlist in
> perf_event__process_attr. Would be better to change it to return the newly
> created evsel so you don't need to look it up after adding it.

perf_event__process_attr() must not reorder the attributes,
it would misrepresent the way they were recorded.

> 
>> +
>> +    if (evsel->attr.type >= PERF_TYPE_MAX)
>> +        return 0;
>> +
>> +    list_for_each_entry(pos, &evlist->entries, node) {
>> +        if (pos->attr.type == evsel->attr.type && pos != evsel)
>> +            return 0;
>> +    }
> 
> What's the point of this loop?

Each type is checked once - see perf_session__check_output_opt()

