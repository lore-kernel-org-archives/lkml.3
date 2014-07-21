Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaGUIsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:48:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:47458 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaGUIso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:48:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,699,1400050800"; 
   d="scan'208";a="564821753"
Message-ID: <53CCD3A7.5070002@intel.com>
Date: Mon, 21 Jul 2014 11:47:35 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org> <53CCB6AE.6020505@intel.com> <20140721080219.GA4183@krava.redhat.com>
In-Reply-To: <20140721080219.GA4183@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 11:02 AM, Jiri Olsa wrote:
> On Mon, Jul 21, 2014 at 09:43:58AM +0300, Adrian Hunter wrote:
>> On 07/21/2014 12:55 AM, Jiri Olsa wrote:
>>> hi,
>>> this patchset factors session's ordered samples queue,
>>> and allows to limit the size of this queue.
>>>
>>> v3 changes:
>>>   - rebased to latest tip/perf/core
>>>   - add comment for WARN in patch 8 (David)
>>>   - added ordered-events debug variable (David)
>>>   - renamed ordered_events_(get|put) to ordered_events_(new|delete)
>>>   - renamed struct ordered_events_queue to struct ordered_events
>>>
>>> v2 changes:
>>>   - several small changes for review comments (Namhyung)
>>>
>>>
>>> The report command queues events till any of following
>>> conditions is reached:
>>>   - PERF_RECORD_FINISHED_ROUND event is processed
>>>   - end of the file is reached
>>>
>>> Any of above conditions will force the queue to flush some
>>> events while keeping all allocated memory for next events.
>>>
>>> If PERF_RECORD_FINISHED_ROUND is missing the queue will
>>
>> Why is it missing?
> 
> it's stored only for tracepoints now patch 17 fixies that

Wouldn't that make a huge difference all by itself?

I would make that the first patch, and measure the difference
that it makes by itself.

> 
>>
>>> allocate memory for every single event in the perf.data.
>>> This could lead to enormous memory consuption and speed
>>> degradation of report command for huge perf.data files.
>>>
>>> With the quue allocation limit of 100 MB, I've got around
>>> 15% speedup on reporting of ~10GB perf.data file.
>>
>> How do you know the results are still valid?  Wouldn't it
>> be better to wait that extra 15% and know that the data has
>> been processed correctly?
> 
> The HALF flush could cause the out of order message
> (which I get occasionaly anyway). Patch 19 allows

Occasional out-of-order messages would be worth investigating
IMHO.  Either there is a bug or there is some "interesting"
data being recorded.

> out of order events after HALF flush.
> 
> The main reason for me was to control the memory allocation,
> which could get enormous without ROUND events being stored.

But now you are storing them...

> The 100MB queue limit seems to be enough not to hit out of
> order event due to the HALF flush.

...so is the 100MB limit needed at all if you have ROUND
events?

