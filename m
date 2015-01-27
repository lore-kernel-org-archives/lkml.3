Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbbA0Kwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:52:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbbA0Kwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:52:45 -0500
Date: Tue, 27 Jan 2015 11:52:42 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Christoph Lameter <cl@linux.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
Message-ID: <20150127105242.GC19880@dhcp22.suse.cz>
References: <20150114165036.GI4706@dhcp22.suse.cz>
 <54B7F7C4.2070105@codeaurora.org>
 <20150116154922.GB4650@dhcp22.suse.cz>
 <54BA7D3A.40100@codeaurora.org>
 <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
 <54BC879C.90505@codeaurora.org>
 <20150121143920.GD23700@dhcp22.suse.cz>
 <alpine.DEB.2.11.1501221010510.3937@gentwo.org>
 <20150126174606.GD22681@dhcp22.suse.cz>
 <alpine.DEB.2.11.1501261233550.16786@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501261233550.16786@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-01-15 12:35:00, Christoph Lameter wrote:
> On Mon, 26 Jan 2015, Michal Hocko wrote:
> 
> > > Please do not run the vmstat_updates concurrently. They update shared
> > > cachelines and therefore can cause bouncing cachelines if run concurrently
> > > on multiple cpus.
> >
> > Would you preffer to call smp_call_function_single on each CPU
> > which needs an update? That would make vmstat_shepherd slower but that
> > is not a big deal, is it?
> 
> Run it from the timer interrupt as usual from a work request? Those are
> staggered.

I am not following. The idea was to run vmstat_shepherd in a kernel
thread and waking up as per defined timeout and then check need_update
for each CPU and call smp_call_function_single to refresh the timer
rather than building a mask and then calling sm_call_function_many to
reduce paralel contention on the shared counters.

> > Anyway I am wondering whether the cache line bouncing between
> > vmstat_update instances is a big deal in the real life. Updating shared
> > counters whould bounce with many CPUs but this is an operation which is
> > not done often. Also all the CPUs would have update the same counters
> > all the time and I am not sure this happens that often. Do you have a
> > load where this would be measurable?
> 
> Concurrent page faults update lots of counters concurrently.

True

> But will those trigger the smp_call_function?

The smp_call_function was meant to be called only from the
vmstat_shepherd context which does happen "rarely". Or am I missing your
point here?

-- 
Michal Hocko
SUSE Labs
