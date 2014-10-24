Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbaJXNz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566AbaJXNz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:55:26 -0400
Date: Fri, 24 Oct 2014 15:55:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Kan Liang <kan.liang@intel.com>
Cc: a.p.zijlstra@chello.nl, eranian@google.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, paulus@samba.org, acme@kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V6 17/17] perf tools: choose to dump callchain from LBR
 and FP
Message-ID: <20141024135510.GA17720@krava.brq.redhat.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
 <1413755712-8259-18-git-send-email-kan.liang@intel.com>
 <20141024133600.GC1036@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024133600.GC1036@krava.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 03:36:00PM +0200, Jiri Olsa wrote:
> On Sun, Oct 19, 2014 at 05:55:12PM -0400, Kan Liang wrote:
> 
> SNIP
> 
> > -				return 0;
> > -			}
> > -			continue;
> > +		mix_chain_nr = i + 2 + lbr_nr;
> > +		if (mix_chain_nr > PERF_MAX_STACK_DEPTH) {
> > +			pr_warning("corrupted callchain. skipping...\n");
> > +			return 0;
> >  		}
> >  
> > -		al.filtered = 0;
> > -		thread__find_addr_location(thread, machine, cpumode,
> > -					   MAP__FUNCTION, ip, &al);
> > -		if (al.sym != NULL) {
> > -			if (sort__has_parent && !*parent &&
> > -			    symbol__match_regex(al.sym, &parent_regex))
> > -				*parent = al.sym;
> > -			else if (have_ignore_callees && root_al &&
> > -			  symbol__match_regex(al.sym, &ignore_callees_regex)) {
> > -				/* Treat this symbol as the root,
> > -				   forgetting its callees. */
> > -				*root_al = al;
> > -				callchain_cursor_reset(&callchain_cursor);
> > +		for (j = 0; j < mix_chain_nr; j++) {
> > +			struct addr_location al;
> > +
> > +			if (callchain_param.order == ORDER_CALLEE) {
> > +				if (j < i + 2)
> > +					ip = chain->ips[j];
> > +				else
> > +					ip = lbr_stack->entries[j - i - 2].from;
> > +			} else {
> > +				if (j < lbr_nr)
> > +					ip = lbr_stack->entries[lbr_nr - j - 1].from;
> > +				else
> > +					ip = chain->ips[i + 1 - (j - lbr_nr)];
> >  			}
> > +			err = __machine__resolve_callchain_sample(machine,
> > +				thread, ip, &cpumode, parent, root_al, &al);
> > +			/* Discard all when the callchain is corrupted */
> > +			if (err > 0)
> > +				return 0;
> > +			else if (err)
> > +				return err;
> 
> so you print FP callchains followed by LBR stack data, right?
> 
> but AFAICS from kernel changes the FP callchains and LBR callchains
> data are unrelated.. 2 datasources of the same information
> 
> do we rather want to print them separately? or using an option
> as Andi did in his lbr-as-callgraph patchset:
>   http://marc.info/?l=linux-kernel&m=141177467802602&w=2

hum, sorry I've got confused by perf report -D output:

5719019682019 0x2128 [0x80]: PERF_RECORD_SAMPLE(IP, 0x2): 2499/2499: 0x401791 period: 327077 addr: 0
... chain: nr:3
.....  0: fffffffffffffe00 FP
.....  1: 0000000000401791 FP
.....  2: 00000032dca21d63 LBR
.....  3: 000000000040184c LBR

which sometimes displays user space FP data with LBR.. but I guess
the intention was to display either userspace FP or LBR, right?

I think we should have an option to be able to choose/switch.
Once general option that will tell report to use:
  FP, DWARF, LBR (branches), LBR (callchain)

setting by default whatever the best option is based on the data we have.

thanks,
jirka
