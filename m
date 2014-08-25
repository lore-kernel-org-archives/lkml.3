Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaHYJsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:48:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbaHYJsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:48:04 -0400
Date: Mon, 25 Aug 2014 11:47:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/10] perf evlist: Allow growing pollfd on add method
Message-ID: <20140825094747.GB11611@krava.brq.redhat.com>
References: <1408741190-5123-1-git-send-email-acme@kernel.org>
 <1408741190-5123-7-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408741190-5123-7-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 05:59:46PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

>  
> -static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
> +static int perf_evlist__grow_pollfd(struct perf_evlist *evlist, int hint)
> +{
> +	int nr_fds_alloc = evlist->nr_fds_alloc + hint;
> +	size_t size = sizeof(struct pollfd) * nr_fds_alloc;
> +	struct pollfd *pollfd = realloc(evlist->pollfd, size);
> +
> +	if (pollfd == NULL)
> +		return -ENOMEM;
> +
> +	evlist->nr_fds_alloc = nr_fds_alloc;
> +	evlist->pollfd	     = pollfd;
> +	return 0;
> +}
> +
> +int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
>  {
>  	int nr_cpus = cpu_map__nr(evlist->cpus);
>  	int nr_threads = thread_map__nr(evlist->threads);
> @@ -416,16 +430,28 @@ static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
>  			nfds += nr_cpus * nr_threads;
>  	}
>  
> -	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
> -	return evlist->pollfd != NULL ? 0 : -ENOMEM;
> +	if (evlist->nr_fds_alloc - evlist->nr_fds < nfds &&
> +	    perf_evlist__grow_pollfd(evlist, nfds) < 0)
> +		return -ENOMEM;

hum, so do we still need perf_evlist__alloc_pollfd?
we grow any time we need inside perf_evlist__add_pollfd..

jirka
