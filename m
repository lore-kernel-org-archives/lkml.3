Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3HZNGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:06:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:10487 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3HZNGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:06:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="351691031"
Message-ID: <521B5466.5040700@intel.com>
Date: Mon, 26 Aug 2013 16:13:10 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf tools: add 'keep tracking' test
References: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com> <1375882231-18339-4-git-send-email-adrian.hunter@intel.com> <87iozawc8b.fsf@sejong.aot.lge.com>
In-Reply-To: <87iozawc8b.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/13 05:33, Namhyung Kim wrote:
> On Wed,  7 Aug 2013 16:30:31 +0300, Adrian Hunter wrote:
>> Add a test for the newly added PERF_COUNT_SW_DUMMY event.
>> The test checks that tracking events continue when an
>> event is disabled but a dummy software event is not
>> disabled.
> 
> [SNIP]
> 
>> +int test__keep_tracking(void)
>> +{
>> +	struct perf_record_opts opts = {
>> +		.mmap_pages	     = UINT_MAX,
>> +		.user_freq	     = UINT_MAX,
>> +		.user_interval	     = ULLONG_MAX,
>> +		.freq		     = 4000,
>> +		.target		     = {
>> +			.uses_mmap   = true,
>> +		},
>> +	};
>> +	struct thread_map *threads = NULL;
>> +	struct cpu_map *cpus = NULL;
>> +	struct perf_evlist *evlist = NULL;
>> +	struct perf_evsel *evsel = NULL;
>> +	int found, err = -1;
>> +	const char *comm;
>> +
>> +	threads = thread_map__new(-1, getpid(), UINT_MAX);
>> +	CHECK_NOT_NULL__(threads);
>> +
>> +	cpus = cpu_map__new(NULL);
>> +	CHECK_NOT_NULL__(cpus);
>> +
>> +	evlist = perf_evlist__new();
>> +	CHECK_NOT_NULL__(evlist);
>> +
>> +	perf_evlist__set_maps(evlist, cpus, threads);
>> +
>> +	CHECK__(parse_events(evlist, "dummy:u"));
>> +	CHECK__(parse_events(evlist, "cycles:u"));
>> +
>> +	perf_evlist__config(evlist, &opts);
>> +
>> +	evsel = perf_evlist__first(evlist);
>> +
>> +	evsel->attr.comm = 1;
>> +	evsel->attr.disabled = 1;
>> +	evsel->attr.enable_on_exec = 0;
>> +
>> +	CHECK__(perf_evlist__open(evlist));
>> +
>> +	CHECK__(perf_evlist__mmap(evlist, UINT_MAX, false));
>> +
>> +	/*
>> +	 * First, test that a 'comm' event can be found when the event is
>> +	 * enabled.
>> +	 */
>> +
>> +	perf_evlist__enable(evlist);
>> +
>> +	comm = "Test COMM 1";
>> +	CHECK__(prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0));
>> +
>> +	perf_evlist__disable(evlist);
>> +
>> +	found = find_comm(evlist, comm);
>> +	if (found != 1) {
>> +		pr_debug("First time, failed to find tracking event.\n");
>> +		goto out_err;
>> +	}
>> +
>> +	/*
>> +	 * Secondly, test that a 'comm' event can be found when the event is
>> +	 * disabled with the dummy event still enabled.
>> +	 */
>> +
>> +	perf_evlist__enable(evlist);
>> +
>> +	evsel = perf_evlist__last(evlist);
>> +
>> +	CHECK__(perf_evlist__disable_event(evlist, evsel));
>> +
>> +	comm = "Test COMM 2";
>> +	CHECK__(prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0));
>> +
>> +	perf_evlist__disable(evlist);
>> +
>> +	found = find_comm(evlist, comm);
>> +	if (found != 1) {
>> +		pr_debug("Seconf time, failed to find tracking event.\n");
>> +		goto out_err;
>> +	}
>> +
>> +	err = 0;
>> +
>> +out_err:
>> +	if (evlist) {
>> +		perf_evlist__disable(evlist);
> 
> It seems the both of goto out_err already called perf_evlist__disable().

There are more "goto out_err"s in the CHECK__ macro

> 
> Thanks,
> Namhyung
> 
> 
>> +		perf_evlist__munmap(evlist);
>> +		perf_evlist__close(evlist);
>> +		perf_evlist__delete(evlist);
>> +	}
>> +	if (cpus)
>> +		cpu_map__delete(cpus);
>> +	if (threads)
>> +		thread_map__delete(threads);
>> +
>> +	return err;
>> +}
> 
> 

