Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbaLINYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:24:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:34864 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684AbaLINYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:24:19 -0500
Date: Tue, 9 Dec 2014 10:24:14 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 02/22] perf evlist: Add initial support for mmapping
 an Instruction Trace buffer
Message-ID: <20141209132414.GD4189@kernel.org>
References: <1416489808-4489-1-git-send-email-adrian.hunter@intel.com>
 <1416489808-4489-3-git-send-email-adrian.hunter@intel.com>
 <20141125165752.GB563@krava.brq.redhat.com>
 <5475D174.50402@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5475D174.50402@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 26, 2014 at 03:11:16PM +0200, Adrian Hunter escreveu:
> On 25/11/14 18:57, Jiri Olsa wrote:
> > On Thu, Nov 20, 2014 at 03:23:08PM +0200, Adrian Hunter wrote:
> > 
> > SNIP
> > 
> >> +			bool per_cpu __maybe_unused)
> >> +{
> >> +}
> >> +
> >>  static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
> >>  {
> >>  	if (evlist->mmap[idx].base != NULL) {
> >> @@ -731,6 +759,7 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
> >>  		evlist->mmap[idx].base = NULL;
> >>  		evlist->mmap[idx].refcnt = 0;
> >>  	}
> >> +	itrace_mmap__munmap(&evlist->mmap[idx].itrace_mmap);
> >>  }
> >>  
> >>  void perf_evlist__munmap(struct perf_evlist *evlist)
> >> @@ -758,6 +787,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
> >>  struct mmap_params {
> >>  	int prot;
> >>  	int mask;
> >> +	struct itrace_mmap_params itrace_mp;
> >>  };
> >>  
> >>  static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
> >> @@ -788,6 +818,10 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
> >>  		return -1;
> >>  	}
> >>  
> >> +	if (itrace_mmap__mmap(&evlist->mmap[idx].itrace_mmap,
> >> +			      &mp->itrace_mp, evlist->mmap[idx].base, fd))
> >> +		return -1;
> >> +
> > 
> > so the itrace mmap is mmaped with right after event mmap for event fd..?
> 
> The AUX area support is not implemented yet.  The AUX mmap size and offset
> are set through the mmap page via aux_offset and aux_size.

>From a quick look the user bits looks nicely done, step by step
introducing stuff, but I would like to try it all together, where can I
get the kernel bits so that I can try to find some machine where to test
the whole thing?

- Arnaldo
 
> > is there any latest version of kernel changes, so I could check with
> > kernel's perf_mmap? hum.. or you just use the same mmap?
> 
> I re-based and pushed to:
> 
> 	git://git.infradead.org/users/ahunter/linux-perf.git
> 
> The missing AUX bits are added in this patch:
> 
> 	http://git.infradead.org/users/ahunter/linux-perf.git/commitdiff/f1be40371b5600a5c4a20f88adff9595bdf5e7ec
