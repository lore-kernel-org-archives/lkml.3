Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaLZQ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 11:27:15 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33484 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaLZQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 11:27:13 -0500
Message-ID: <549D8C59.1000700@gmail.com>
Date: Fri, 26 Dec 2014 09:27:05 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 02/37] perf record: Use a software dummy event to track
 task/mmap events
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1419405333-27952-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/14 12:14 AM, Namhyung Kim wrote:
> Prepend a software dummy event into evlist to track task/comm/mmap
> events separately.  This is a preparation of multi-file/thread support
> which will come later.

Are you are making this the first event because of how perf internals 
are coded -- that the first event tracks tasks events? With the tracking 
bit in evsel you should not need to do that. Is there another reason?

---8<---

> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index cfbe2b99b9aa..72dff295237e 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -193,6 +193,44 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
>   	return -ENOMEM;
>   }
>
> +int perf_evlist__prepend_dummy(struct perf_evlist *evlist)
> +{
> +	struct perf_event_attr attr = {
> +		.type = PERF_TYPE_SOFTWARE,
> +		.config = PERF_COUNT_SW_DUMMY,
> +	};
> +	struct perf_evsel *evsel, *pos;
> +
> +	event_attr_init(&attr);
> +
> +	evsel = perf_evsel__new(&attr);
> +	if (evsel == NULL)
> +		goto error;
> +
> +	/* use strdup() because free(evsel) assumes name is allocated */
> +	evsel->name = strdup("dummy");
> +	if (!evsel->name)
> +		goto error_free;
> +
> +	list_for_each_entry(pos, &evlist->entries, node) {
> +		pos->idx += 1;
> +		pos->tracking = false;
> +	}
> +
> +	list_add(&evsel->node, &evlist->entries);
> +	evsel->idx = 0;
> +	evsel->tracking = true;

perf_evlist__set_tracking_event()?

David

