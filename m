Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaHYQAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:00:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:57632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbaHYQAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:00:34 -0400
Date: Mon, 25 Aug 2014 12:59:14 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/10] perf evlist: Allow growing pollfd on add method
Message-ID: <20140825155914.GB2849@kernel.org>
References: <1408741190-5123-1-git-send-email-acme@kernel.org>
 <1408741190-5123-7-git-send-email-acme@kernel.org>
 <20140825094747.GB11611@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825094747.GB11611@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 25, 2014 at 11:47:47AM +0200, Jiri Olsa escreveu:
> On Fri, Aug 22, 2014 at 05:59:46PM -0300, Arnaldo Carvalho de Melo wrote:

> > -static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
> > +static int perf_evlist__grow_pollfd(struct perf_evlist *evlist, int hint)
> > +{
> > +	int nr_fds_alloc = evlist->nr_fds_alloc + hint;
> > +	size_t size = sizeof(struct pollfd) * nr_fds_alloc;
> > +	struct pollfd *pollfd = realloc(evlist->pollfd, size);
> > +
> > +	if (pollfd == NULL)
> > +		return -ENOMEM;
> > +
> > +	evlist->nr_fds_alloc = nr_fds_alloc;
> > +	evlist->pollfd	     = pollfd;
> > +	return 0;
> > +}
> > +
> > +int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
> >  {
> >  	int nr_cpus = cpu_map__nr(evlist->cpus);
> >  	int nr_threads = thread_map__nr(evlist->threads);
> > @@ -416,16 +430,28 @@ static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
> >  			nfds += nr_cpus * nr_threads;
> >  	}
> >  
> > -	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
> > -	return evlist->pollfd != NULL ? 0 : -ENOMEM;
> > +	if (evlist->nr_fds_alloc - evlist->nr_fds < nfds &&
> > +	    perf_evlist__grow_pollfd(evlist, nfds) < 0)
> > +		return -ENOMEM;
> 
> hum, so do we still need perf_evlist__alloc_pollfd?
> we grow any time we need inside perf_evlist__add_pollfd..

Humm, yeah, it could conceivably be removed and then we would rely
always on add_pollfd() autogrowing it as needed. But then, I thought
that code using this could optimize for the case where it knows in
advance how many entries it will need, just like perf_evlist does.

I.e. the first thing builtin-kvm.c should do would be to grow it by two
more entries, because it knows it wants to add just two more entries, in
advance, etc.

- Arnaldo
