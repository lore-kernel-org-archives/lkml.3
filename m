Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaJXPVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:21:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:46371 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbaJXPVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:21:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,780,1406617200"; 
   d="scan'208";a="619880359"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V6 17/17] perf tools: choose to dump callchain from LBR
 and FP
Thread-Topic: [PATCH V6 17/17] perf tools: choose to dump callchain from LBR
 and FP
Thread-Index: AQHP6+jVSxfa+6qSJ0Sih5TOfMVew5w+wPiAgAAFWgCAAJQIQA==
Date: Fri, 24 Oct 2014 15:20:34 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016492F7@SHSMSX103.ccr.corp.intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
 <1413755712-8259-18-git-send-email-kan.liang@intel.com>
 <20141024133600.GC1036@krava.brq.redhat.com>
 <20141024135510.GA17720@krava.brq.redhat.com>
In-Reply-To: <20141024135510.GA17720@krava.brq.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> On Fri, Oct 24, 2014 at 03:36:00PM +0200, Jiri Olsa wrote:
> > On Sun, Oct 19, 2014 at 05:55:12PM -0400, Kan Liang wrote:
> >
> > SNIP
> >
> > > -				return 0;
> > > -			}
> > > -			continue;
> > > +		mix_chain_nr = i + 2 + lbr_nr;
> > > +		if (mix_chain_nr > PERF_MAX_STACK_DEPTH) {
> > > +			pr_warning("corrupted callchain. skipping...\n");
> > > +			return 0;
> > >  		}
> > >
> > > -		al.filtered = 0;
> > > -		thread__find_addr_location(thread, machine, cpumode,
> > > -					   MAP__FUNCTION, ip, &al);
> > > -		if (al.sym != NULL) {
> > > -			if (sort__has_parent && !*parent &&
> > > -			    symbol__match_regex(al.sym, &parent_regex))
> > > -				*parent = al.sym;
> > > -			else if (have_ignore_callees && root_al &&
> > > -			  symbol__match_regex(al.sym,
> &ignore_callees_regex)) {
> > > -				/* Treat this symbol as the root,
> > > -				   forgetting its callees. */
> > > -				*root_al = al;
> > > -				callchain_cursor_reset(&callchain_cursor);
> > > +		for (j = 0; j < mix_chain_nr; j++) {
> > > +			struct addr_location al;
> > > +
> > > +			if (callchain_param.order == ORDER_CALLEE) {
> > > +				if (j < i + 2)
> > > +					ip = chain->ips[j];
> > > +				else
> > > +					ip = lbr_stack->entries[j - i - 2].from;
> > > +			} else {
> > > +				if (j < lbr_nr)
> > > +					ip = lbr_stack->entries[lbr_nr - j -
> 1].from;
> > > +				else
> > > +					ip = chain->ips[i + 1 - (j - lbr_nr)];
> > >  			}
> > > +			err =
> __machine__resolve_callchain_sample(machine,
> > > +				thread, ip, &cpumode, parent, root_al, &al);
> > > +			/* Discard all when the callchain is corrupted */
> > > +			if (err > 0)
> > > +				return 0;
> > > +			else if (err)
> > > +				return err;
> >
> > so you print FP callchains followed by LBR stack data, right?
> >
> > but AFAICS from kernel changes the FP callchains and LBR callchains
> > data are unrelated.. 2 datasources of the same information
> >
> > do we rather want to print them separately? or using an option as Andi
> > did in his lbr-as-callgraph patchset:
> >   http://marc.info/?l=linux-kernel&m=141177467802602&w=2
> 
> hum, sorry I've got confused by perf report -D output:
> 
> 5719019682019 0x2128 [0x80]: PERF_RECORD_SAMPLE(IP, 0x2): 2499/2499:
> 0x401791 period: 327077 addr: 0 ... chain: nr:3 .....  0: fffffffffffffe00 FP .....  1:
> 0000000000401791 FP .....  2: 00000032dca21d63 LBR .....  3: 000000000040184c
> LBR
> 
> which sometimes displays user space FP data with LBR.. but I guess the
> intention was to display either userspace FP or LBR, right?
> 

It depends on how user set the perf report --call-graph options, and
if both data are available.

Let's say both FP and LBR data are available.

If the user prefer the fp data,
here is the command and the call chain from last sample. 
perf report --call-graph fractal,0.5,callee,function,fp -D

3741913434263 0x3a2960 [0xe8]: PERF_RECORD_SAMPLE(IP, 0x2):
20920/20920: 0x400568 period: 611393 addr: 0
... chain: nr:6
.....  0: fffffffffffffe00
.....  1: 0000000000400568
.....  2: 000000000040058c <---- FP data start from here
.....  3: 00000000004005b8
.....  4: 00000000004005fe
.....  5: 0000003d1cc21b45
.....  6: 0000000000000005
 ... thread: a.out:20920
 ...... dso: /home/lk/a.out


If the user prefer the lbr data source,
here is the command and the call chain from last sample. 
perf report --call-graph fractal,0.5,callee,function,lbr -D


3741913434263 0x3a2960 [0xe8]: PERF_RECORD_SAMPLE(IP, 0x2):
20920/20920: 0x400568 period: 611393 addr: 0
... chain: nr:6
.....  0: fffffffffffffe00
.....  1: 0000000000400568
.....  2: 0000000000400587 <---- LBR data start from here
.....  3: 00000000004005b3
.....  4: 00000000004005f9
.....  5: 0000003d1cc21b43
.....  6: 0000000000400474
 ... thread: a.out:20920
 ...... dso: /home/lk/a.out 


If there is only one data source available (either fp or lbr),
no matter what option is set, the only available data is printed. 

> I think we should have an option to be able to choose/switch.
> Once general option that will tell report to use:
>   FP, DWARF, LBR (branches), LBR (callchain)

We cannot collect LBR branch and LBR callchain at the same time.
If both call-chain and branch are required, it only collects branch.

The choose/switch can only happen when the user only want to
collect call chain by FP. So I only extend the reporter's --call-graph
option to callchain source (fp or lbr). The default one is fp.

Thanks,
Kan

> 
> setting by default whatever the best option is based on the data we have.
> 
> thanks,
> jirka
