Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaHYJmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:42:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaHYJmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:42:07 -0400
Date: Mon, 25 Aug 2014 11:41:41 +0200
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
Message-ID: <20140825094140.GA11611@krava.brq.redhat.com>
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

> -void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
> +int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
>  {
> +	/*
> +	 * XXX: 64 is arbitrary, just not to call realloc at each fd.
> +	 *	Find a better autogrowing heuristic
> +	 */
> +	if (evlist->nr_fds == evlist->nr_fds_alloc &&
> +	    perf_evlist__grow_pollfd(evlist, 64) < 0)
> +		return -ENOMEM;
> +
>  	fcntl(fd, F_SETFL, O_NONBLOCK);
>  	evlist->pollfd[evlist->nr_fds].fd = fd;
>  	evlist->pollfd[evlist->nr_fds].events = POLLIN | POLLERR | POLLHUP;
>  	evlist->nr_fds++;
> +	return 0;
>  }
>  
>  int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
> @@ -713,7 +739,11 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
>  		return -1;
>  	}
>  
> -	perf_evlist__add_pollfd(evlist, fd);
> +	if (perf_evlist__add_pollfd(evlist, fd) < 0) {
> +		__perf_evlist__munmap(evlist->mmap[idx].base, idx);

unmap does not look necessary here.. should be handeled by out_unmap
in both perf_evlist__mmap_per_thread and perf_evlist__mmap_per_cpu

jirka
