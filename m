Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaHYG7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:59:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:41787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaHYG7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="562960237"
Message-ID: <53FADE71.8070006@intel.com>
Date: Mon, 25 Aug 2014 09:57:53 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/10] perf evlist: Introduce perf_evlist__filter_pollfd
 method
References: <1408741190-5123-1-git-send-email-acme@kernel.org> <1408741190-5123-2-git-send-email-acme@kernel.org>
In-Reply-To: <1408741190-5123-2-git-send-email-acme@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 11:59 PM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> To remove all entries in evlist->pollfd[] that have revents matching at
> least one of the bits in the specified mask.
> 
> It'll adjust evlist->nr_fds to the number of unfiltered fds and will
> return this value, as a convenience and to avoid requiring direct access
> to internal state of perf_evlist objects.
> 
> This will be used after polling the evlist fds so that we remove fds
> that were closed by the kernel.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-ki3oqbfjg84si3f9amhyqvzb@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/evlist.c | 16 ++++++++++++++++
>  tools/perf/util/evlist.h |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index a3e28b49128a..bd7896073d10 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -428,6 +428,22 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
>  	evlist->nr_fds++;
>  }
>  
> +int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
> +{
> +	int fd = 0, nr_fds = 0;
> +
> +	while (fd < evlist->nr_fds) {

A for loop is clearer e.g.

	for (fd = 0; fd < evlist->nr_fds; fd++) {


> +		if ((evlist->pollfd[fd].revents & revents_and_mask) == 0)
> +			++nr_fds;
> +
> +		if (++fd != nr_fds)
> +			evlist->pollfd[nr_fds] = evlist->pollfd[fd];

That looks like it will go off the end of the array.  Shouldn't it be:

		if ((evlist->pollfd[fd].revents & revents_and_mask) == 0) {
			if (fd != nr_fds)
				evlist->pollfd[nr_fds] = evlist->pollfd[fd];
			nr_fds += 1;
		}

> +	}
> +
> +	evlist->nr_fds = nr_fds;
> +	return nr_fds;
> +}
> +
>  static void perf_evlist__id_hash(struct perf_evlist *evlist,
>  				 struct perf_evsel *evsel,
>  				 int cpu, int thread, u64 id)
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index 106de53a6a74..1082420951f9 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -84,6 +84,8 @@ void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
>  
>  void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
>  
> +int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask);
> +
>  struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
>  
>  struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
> 

