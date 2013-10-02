Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3JBKCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:02:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47135 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3JBKCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:02:07 -0400
Date: Wed, 2 Oct 2013 12:01:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 8/8] perf tools: Get current comm instead of last one
Message-ID: <20131002100149.GB7941@localhost.localdomain>
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
 <1380185890-25758-9-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380185890-25758-9-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 05:58:10PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> At insert time, a hist entry should reference comm at the time
> otherwise it'll get the last comm anyway.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Link: http://lkml.kernel.org/n/tip-n6pykiiymtgmcjs834go2t8x@git.kernel.org
> [ Fixed up const pointer issues ]
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/comm.c   | 15 +++++++++++++++
>  tools/perf/util/comm.h   |  1 +
>  tools/perf/util/hist.c   |  3 +++
>  tools/perf/util/sort.c   | 14 +++++---------
>  tools/perf/util/sort.h   |  1 +
>  tools/perf/util/thread.c |  6 +++---
>  tools/perf/util/thread.h |  2 ++
>  7 files changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
> index 0cfb55202537..ecd3c9938d3e 100644
> --- a/tools/perf/util/comm.c
> +++ b/tools/perf/util/comm.c
> @@ -94,6 +94,21 @@ struct comm *comm__new(const char *str, u64 timestamp)
>  	return comm;
>  }
>  
> +void comm__override(struct comm *comm, const char *str, u64 timestamp)
> +{
> +	struct comm_str *old = comm->comm_str;
> +
> +	comm->comm_str = comm_str_findnew(str, &comm_str_root);
> +	if (!comm->comm_str) {
> +		comm->comm_str = old;
> +		return;
> +	}
> +
> +	comm->start = timestamp;
> +	comm_str_get(comm->comm_str);
> +	comm_str_put(old);
> +}
> +
>  void comm__free(struct comm *comm)
>  {
>  	comm_str_put(comm->comm_str);
> diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
> index f62d215bede2..b2c364b37468 100644
> --- a/tools/perf/util/comm.h
> +++ b/tools/perf/util/comm.h
> @@ -16,5 +16,6 @@ struct comm {
>  void comm__free(struct comm *comm);
>  struct comm *comm__new(const char *str, u64 timestamp);
>  const char *comm__str(const struct comm *comm);
> +void comm__override(struct comm *self, const char *str, u64 timestamp);
>  
>  #endif  /* __PERF_COMM_H */
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index a2d58e7abdcf..1aa97b012a09 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -412,6 +412,7 @@ struct hist_entry *__hists__add_mem_entry(struct hists *self,
>  {
>  	struct hist_entry entry = {
>  		.thread	= al->thread,
> +		.comm = curr_comm(al->thread),

So now that we have an accessor for that, it clashes a bit with existing names.

I suggest we rename thread__comm_curr() -> thread__comm_str()
And rename curr_comm() -> thread__comm()

Hmm?
