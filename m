Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaKPJ1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:27:46 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58619 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaKPJ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:27:43 -0500
Date: Sun, 16 Nov 2014 10:27:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Robert Bragg <robert@sixbynine.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
Message-ID: <20141116092737.GA19043@gmail.com>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
 <20141030190841.GI23531@worktop.programming.kicks-ass.net>
 <CAMou1-12ggxAuaPQ8VG7Gf5BZM6CVj6773HRB1QJXagB-okuGg@mail.gmail.com>
 <20141105123354.GR3337@twins.programming.kicks-ass.net>
 <CAMou1-0VQW-P=wPiOmWKXRJV9cqe2OR3yppYG9j0irKwnb78uw@mail.gmail.com>
 <20141110111329.GA19706@gmail.com>
 <CAMou1-1NTyym0fzyT-QmOTMEW-Bu=vX8jLM83+=hGktqd1+Q+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMou1-1NTyym0fzyT-QmOTMEW-Bu=vX8jLM83+=hGktqd1+Q+A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Bragg <robert@sixbynine.org> wrote:

> > I'd strong[ly] suggest thinking about sampling as well, if 
> > the hardware exposes sample information: at least for 
> > profiling CPU loads the difference is like day and night, 
> > compared to aggregated counts and self-profiling.
> 
> Here I was thinking of counters or data that can be sampled via 
> mmio using a hrtimer. E.g. the current gpu frequency or the 
> energy usage. I'm not currently aware of any capability for the 
> gpu to say trigger an interrupt after a threshold number of 
> events occurs (like clock cycles) so I think we may generally 
> be limited to a wall clock time domain for sampling.

In general hrtimer-driven polling gives pretty good profiling 
information as well - key is to be able to get a sample of EU 
thread execution state.

(Trigger thresholds and so can be useful as well, but are a 
second order concern in terms of profiling quality.)

> > It's a very good idea to not expose such limitations to 
> > user-space - the GPU driver doing the necessary hrtimer 
> > polling to construct a proper count is a much higher quality 
> > solution.
> 
> That sounds preferable.
> 
> I'm open to suggestions for finding another way for userspace 
> to initiate a flush besides through read() in case there's a 
> concern that might be set a bad precedent. For the i915_oa 
> driver it seems ok at the moment since we don't currently 
> report a useful counter through read() and for the main use 
> case where we want the flushing we expect that most of the time 
> there won't be any significant cost involved in flushing since 
> we'll be using a very low timer period. Maybe this will bite us 
> later though.

You could add an ioctl() as well - we are not religious about 
them, there's always things that are special enough to not 
warrant a generic syscall.

Anyway, aggregate counts alone are obviously very useful to 
analyzing GPU performance, so your initial approach looks 
perfectly acceptable to me already.

Thanks,

	Ingo
