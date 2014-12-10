Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaLJLtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:49:24 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:46183 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaLJLtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:49:23 -0500
Date: Wed, 10 Dec 2014 17:18:44 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Subject: Re: [RFC PATCH 7/8] perf probe powerpc: Use DWARF info only if
 necessary
Message-ID: <20141210114844.GE16045@naverao1-tp.in.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <50dd0fedb50e3a56ff8f25c44098db3e2a2d6374.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <1418206640.9279.10.camel@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418206640.9279.10.camel@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121011-0033-0000-0000-00000342FEF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/10 09:17PM, Michael Ellerman wrote:
> On Tue, 2014-12-09 at 23:04 +0530, Naveen N. Rao wrote:
> > Use symbol table lookups by default if DWARF is not necessary, since
> > powerpc ABIv2 encodes local entry points in the symbol table and the
> > function entry address in DWARF may not be appropriate for kprobes,
> > as described here:
> > https://sourceware.org/bugzilla/show_bug.cgi?id=17638
> 
> Needs a better changelog.

Ok. Will add, but to elaborate quickly: DWARF will only include the 
entire function in low_pc/entry_pc and high_pc. It can't indicate the 
local entry point. Hence, we need to use the symbol table instead of 
DWARF on ABIv2.

> 
> > diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> > index 174c22e..adcdbd2 100644
> > --- a/tools/perf/util/probe-event.c
> > +++ b/tools/perf/util/probe-event.c
> > @@ -2382,6 +2382,14 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
> >  		}
> >  	}
> >  
> > +#if defined(__powerpc64__) && defined(_CALL_ELF) && _CALL_ELF == 2
> > +	if (!perf_probe_event_need_dwarf(pev)) {
> > +		ret = find_probe_trace_events_from_map(pev, tevs, max_tevs, target);
> > +		if (ret > 0)
> > +			return ret;	/* Found in symbol table */
> > +	}
> > +#endif
> 
> And should be in an arch helper, not a big powerpc wart dropped in the middle
> of the generic code.

Sure - will change.

Thanks for the review!
- Naveen

