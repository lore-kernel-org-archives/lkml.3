Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaIKNkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:40:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:51701 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbaIKNkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:40:40 -0400
Date: Thu, 11 Sep 2014 10:40:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 14/14] perf evlist: Unmap ring buffer when fd is nuked
Message-ID: <20140911134029.GD10158@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-15-git-send-email-acme@kernel.org>
 <20140911122751.GD13634@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911122751.GD13634@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 11, 2014 at 02:27:51PM +0200, Jiri Olsa escreveu:
> On Wed, Sep 10, 2014 at 11:08:49AM -0300, Arnaldo Carvalho de Melo wrote:
 
> SNIP
 
> >  int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
> >  {
> > -	return fdarray__add(&evlist->pollfd, fd, POLLIN | POLLERR | POLLHUP);
> > +	return __perf_evlist__add_pollfd(evlist, fd, -1);
> > +}

> > +static void perf_evlist__munmap_filtered(struct fdarray *fda, int fd)
> > +{
> > +	struct perf_evlist *evlist = container_of(fda, struct perf_evlist, pollfd);
> > +
> > +	perf_evlist__mmap_put(evlist, fda->priv[fd]);
 
> we cannot do this.. because of the way we read the map
 
> getting error or hup does not mean the mmap is empty,
> it can still have data, which we loose if we unmap it

Understood, good catch, so I think that since associating with the mmap
is done automagically by the evlist class, it should continue, as I did,
doing the mmap_put's to have it in pairs, and then we have two choices:

1. the user, i.e. the tool, does an extra perf_evlist__mmap_get() to
make sure that it exits the loop with the mmaps in place, since it will
have that extra refcount, and then drain the buffers one last time, then
to the final put, or leave it there to be reaped unconditionally at
perf_evlist__delete()

2. Do this all automagically in the evlist layer(), i.e. start the
perf_mmap->nr_fds (that gets renamed, as this is no longer the number of
fds, but just a generic refcount) at 2, and when confirming the mmap
read, in perf_evlist__mmap_consume(), check if the refcount is 1 and if
there are no more events, do the final mmap_put.

I think #2 is better, no?

I.e. tools remain as they are, just doing the filtering, that could even
be renamed from perf_evlist__filter_pollfd() to perf_evlist__eof(), to
use some well known TLA for "no more things to read". :-)

I.e. the less the tools are _required_ to know about how events are laid
out and dealt with, concentrating just on _consuming_ those events, the
better.

- Arnaldo
 
> following test will get data only with attached patch:
> 
> ---
> term1:
>   $ cat
> 
> term2:
>   $ cat perf record -p `pgrep cat`
> 
> term1:
>   ^D
> ---
> 
> we get poll READ notification based on the wattermart settings,
> which by default is half size of the ring buffer.. so for small
> amount of perf data we dont get the poll read notification
> 
> I think we need to handle this in the record command context
> and read out the mmap before we unmap it
> 
> jirka
> 
> 
> 
> >  }
> >  
> >  int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
> >  {
> > -	return fdarray__filter(&evlist->pollfd, revents_and_mask, NULL);
> > +	return fdarray__filter(&evlist->pollfd, revents_and_mask,
> > +			       perf_evlist__munmap_filtered);
> >  }
> >  
> >  int perf_evlist__poll(struct perf_evlist *evlist, int timeout)
> > @@ -751,7 +774,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
> >  			perf_evlist__mmap_get(evlist, idx);
> >  		}
> >  
> > -		if (perf_evlist__add_pollfd(evlist, fd) < 0) {
> > +		if (__perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
> >  			perf_evlist__mmap_put(evlist, idx);
> >  			return -1;
> >  		}
> > -- 
> > 1.9.3
> > 
> 
> ---
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index fdb755f..9e71a47 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -448,6 +448,7 @@ static void perf_evlist__munmap_filtered(struct fdarray *fda, int fd)
>  {
>  	struct perf_evlist *evlist = container_of(fda, struct perf_evlist, pollfd);
>  
> +if (0)
>  	perf_evlist__mmap_put(evlist, fda->priv[fd]);
>  }
>  
