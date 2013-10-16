Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab3JPMqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:46:33 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63867 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934162Ab3JPMqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:46:31 -0400
Date: Wed, 16 Oct 2013 14:46:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
Message-ID: <20131016124627.GA2611@gmail.com>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
 <20131010180049.GD9929@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010180049.GD9929@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So, the RAPL patch-set clearly needs more work.

* Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Oct 10, 2013 at 04:50:05PM +0200, Stephane Eranian wrote:
> > $ perf stat -a -e rapl/rapl-energy-cores/,rapl/rapl-energy-pkg/ -I 1000 sleep 10
> >             time             counts events
> >      1.000345931        772 278 493 rapl/rapl-energy-cores/
> >      1.000345931     55 539 138 560 rapl/rapl-energy-pkg/    
> >      2.000836387        771 751 936 rapl/rapl-energy-cores/  
> >      2.000836387     55 326 015 488 rapl/rapl-energy-pkg/

Why is there the rapl/rapl duplication in the event name? It should be 
rapl/energy-cores, rapl/energy-pkg, etc.

I'm also not sure about the Intel-specific naming. Joules per core and 
Joules per socket ought to be pretty generic, even if the initial 
implementation is Intel-only. I.e.:

	power/energy-core
	power/energy-pkg

> Hmm, so I'm looking at builtin-stat.c::print_interval() and since it 
> gets the perf_evsel counters and you can deduce the counter name from 
> it, you probably could match the rapl counters and do the Watts 
> conversion above as a special case.
> 
> I dunno, it is much better than having some naked numbers for which 
> people have to go stare at the sources + CPU vendor docs as to what they 
> actually mean.

So what should happen here is to extend the sysfs attributes that tell us 
that it's in 32.32 fixed-point format.

We should also tell user-space that the unit of this counter is 'Joule'.

Then things like:

	perf stat -a -e power/* sleep 1

would output, without knowing any RAPL details:

            0.20619 Joule    power/energy-core
            2.42151 Joule    power/energy-pkg

or so.

Other platforms offering energy measurement facilities will then name 
their counters in the same power/* (or energy/*) namespace, with new names 
if they do something fundamentally differently.

Tooling can then generalize along these abstractions, as much as the 
hardware allows it.

Thanks,

	Ingo
