Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaL3F4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 00:56:03 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:35881 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaL3F4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 00:56:01 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 30 Dec 2014 14:57:12 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/37] perf tools: Create separate mmap for dummy
 tracking event
Message-ID: <20141230055712.GF6081@sejong>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-6-git-send-email-namhyung@kernel.org>
 <54A15AB5.6050806@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54A15AB5.6050806@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 03:44:21PM +0200, Adrian Hunter wrote:
> > @@ -843,9 +889,22 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
> >  
> >  		fd = FD(evsel, cpu, thread);
> >  
> > -		if (*output == -1) {
> > +		if (perf_evsel__is_dummy_tracking(evsel)) {
> > +			struct mmap_params track_mp = {
> > +				.prot	= mp->prot,
> > +				.len	= TRACK_MMAP_SIZE,
> > +			};
> > +
> > +			if (__perf_evlist__mmap(evlist, &evlist->track_mmap[idx],
> > +						&track_mp, fd) < 0)
> > +				return -1;
> > +
> > +			/* mark idx as track mmap idx (negative) */
> > +			idx = track_mmap_idx(idx);
> 
> Do you not still need to do SET_OUTPUT when there are multiple cpus and
> multiple pids?

You're right.  I just considered simple cases, will fix.

Thanks,
Namhyung


> 
> 
> > +		} else if (*output == -1) {
> >  			*output = fd;
> > -			if (__perf_evlist__mmap(evlist, idx, mp, *output) < 0)
> > +			if (__perf_evlist__mmap(evlist, &evlist->mmap[idx],
> > +						mp, *output) < 0)
> >  				return -1;
> >  		} else {
> >  			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
> > @@ -874,6 +933,11 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
> >  			perf_evlist__set_sid_idx(evlist, evsel, idx, cpu,
> >  						 thread);
> >  		}
> > +
> > +		if (mp->track && perf_evsel__is_dummy_tracking(evsel)) {
> > +			/* restore idx as normal idx (positive) */
> > +			idx = track_mmap_idx(idx);
> > +		}
> >  	}
> >  
> >  	return 0;
