Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaIVOt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:49:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:34058 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbaIVOt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:49:56 -0400
Date: Mon, 22 Sep 2014 11:49:49 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf pollfd v3
Message-ID: <20140922144949.GE32694@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <20140911113336.GB13634@krava.brq.redhat.com>
 <20140911114825.GC13634@krava.brq.redhat.com>
 <20140911133029.GC10158@kernel.org>
 <20140911213638.GC1801@kernel.org>
 <20140918160455.GI2770@kernel.org>
 <20140922133526.GB18187@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922133526.GB18187@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 22, 2014 at 03:35:26PM +0200, Jiri Olsa escreveu:
> On Thu, Sep 18, 2014 at 01:04:55PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Sep 11, 2014 at 06:36:38PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Done, updated it there:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/fdarray.v4
> > 
> > Its on top of my last perf/core branch, i.e. with builtin-record.c using
> > perf_evlist__mmap_consume() and it and builtin-trace.c doing one last
> > mmap_read loop to consume what is left after all fds for a mmap are
> > closed.
> > 
> > I'll wait a bit before reposting, probably Jiri will not be able to
> > comment this week, but I would like to at least post the URL for this
> > latest v4 kit.
> > 
> > Adrian, if you could take a look at it, would be really great :-)
> 
> I checked the branch.. the last patch brakes the functionality
> of perf record for me

Breaks in what sense?
 
> I tried attached change instead.. but then I realized we dont
> actually need the final unmap for record command, because
> we always open 1 mmap for each CPU and then do the output ioctl
> for any other process we monitor for each CPU.. so all the mmaps
> stay until last process is dead or we exit
> 
> maybe we could have this code just to be complete,

This is to be complete, trying to find she simples setup + event loop
processing + teardown API.

> or I missed something ;-)

We'll both find it, eventually ;-)

- Arnaldo
 
> +++ b/tools/perf/builtin-record.c
> @@ -244,11 +244,15 @@ static int record__mmap_read_all(struct record *rec)
>  	int rc = 0;
>  
>  	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
> -		if (rec->evlist->mmap[i].base) {
> -			if (record__mmap_read(rec, &rec->evlist->mmap[i]) != 0) {
> +		struct perf_mmap *md = &rec->evlist->mmap[i];
> +
> +		if (md->base) {
> +			if (record__mmap_read(rec, md) != 0) {
>  				rc = -1;
>  				goto out;
>  			}
> +			if (md->refcnt == 1 && perf_mmap__empty(md))
> +				perf_evlist__mmap_put(rec->evlist, i);

Humm, this should go into perf_evlist__mmap_consume(), is it not there?
I.e. record__mmap_read() will have called it, nope? Humm, it seems I
haven't rebased this on top of tip/perf/core, that has this at the end of
record__mmap_read():

        md->prev = old;
        perf_evlist__mmap_consume(rec->evlist, idx);

Sorry about that, but at least it matches what you did, no?

I just pushed a perf/fdarray.v5 with it.

There is one more thing I realised, that is we can't exit the loop like
I do in my series at these places:

  commit 593ee89818b3ab3493a9f368c1eb6b2e4c4a9512
    perf trace: Filter out POLLHUP'ed file descriptors

  commit 2478af9c299f4f7950b8d5d4bca2d2c71d661018
    perf record: Filter out POLLHUP'ed file descriptors


I need to reorder the patches so that this draining gets merged with the
test for entries in the poll fdarray to drop to zero.

The end result should be the equivalent to what is in perf/fdarray.v5,
but if we test right at those two last mentioned patches, we may lose
the last few events in a record or trace session.

- Arnaldo

> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 3cebc9a..82bab81 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -25,7 +25,6 @@
>  #include <linux/bitops.h>
>  #include <linux/hash.h>
>  
> -static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
>  static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
>  
>  #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> @@ -676,17 +675,12 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
>  	return event;
>  }
>  
> -static bool perf_mmap__empty(struct perf_mmap *md)
> -{
> -	return perf_mmap__read_head(md) != md->prev;
> -}
> -
>  static void perf_evlist__mmap_get(struct perf_evlist *evlist, int idx)
>  {
>  	++evlist->mmap[idx].refcnt;
>  }
>  
> -static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx)
> +void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx)
>  {
>  	BUG_ON(evlist->mmap[idx].refcnt == 0);
>  
> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> index bd312b0..fdd395a 100644
> --- a/tools/perf/util/evlist.h
> +++ b/tools/perf/util/evlist.h
> @@ -204,6 +204,13 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
>  	pc->data_tail = tail;
>  }
>  
> +static inline bool perf_mmap__empty(struct perf_mmap *md)
> +{
> +	return perf_mmap__read_head(md) != md->prev;
> +}
> +
> +void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
> +
>  bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
>  void perf_evlist__to_front(struct perf_evlist *evlist,
>  			   struct perf_evsel *move_evsel);
