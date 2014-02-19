Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaBSDFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:05:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbaBSDFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:05:14 -0500
Date: Tue, 18 Feb 2014 22:04:38 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 02/21] perf c2c: Dump raw records, decode data_src bits
Message-ID: <20140219030438.GQ25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-3-git-send-email-dzickus@redhat.com>
 <20140218125335.GF4343@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218125335.GF4343@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:53:35PM +0100, Jiri Olsa wrote:
> On Mon, Feb 10, 2014 at 12:28:57PM -0500, Don Zickus wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > From the c2c prototype:
> > 
> > [root@sandy ~]# perf c2c -r report | head -7
> > T Status    Pid Tid CPU          Inst Adrs     Virt Data Adrs Phys Data Adrs Cycles Source      Decoded Source                ObJect:Symbol
> > --------------------------------------------------------------------------------------------------------------------------------------------
> >   raw input 779 779   7 0xffffffff810865dd 0xffff8803f4d75ec8              0    370 0x68080882 [LOAD,LCL_LLC,MISS,SNP NA]    [kernel.kallsyms]:try_to_wake_up
> >   raw input 779 779   7 0xffffffff8107acb3 0xffff8802a5b73158              0    297 0x6a100142 [LOAD,L1,HIT,SNP NONE,LOCKED] [kernel.kallsyms]:up_read
> >   raw input 779 779   7       0x3b7e009814     0x7fff87429ea0              0    925 0x68100142 [LOAD,L1,HIT,SNP NONE]        ???:???
> >   raw input   0   0   1 0xffffffff8108bf81 0xffff8803eafebf50              0    172 0x68800842 [LOAD,LCL_LLC,HIT,SNP HITM]   [kernel.kallsyms]:update_stats_wait_end
> >   raw input 779 779   7       0x3b7e0097cc     0x7fac94b69068              0    228 0x68100242 [LOAD,LFB,HIT,SNP NONE]       ???:???
> > [root@sandy ~]#
> > 
> > The "Phys Data Adrs" column is not available at this point.
> 
> SNIP
> 
> > +		       sample->data_src,
> > +		       data_src,
> > +		       al->map ? (al->map->dso ? al->map->dso->long_name : "???") : "???",
> > +		       al->sym ? al->sym->name : "???");
> > +}
> > +
> > +static int perf_c2c__process_load_store(struct perf_c2c *c2c,
> > +					struct perf_sample *sample,
> > +					struct addr_location *al)
> > +{
> > +	if (c2c->raw_records)
> > +		perf_sample__fprintf(sample, ' ', "raw input", al, stdout);
> > +
> >  	return 0;
> >  }
> >  
> >  static const struct perf_evsel_str_handler handlers[] = {
> > -	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
> > -	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },
> > +	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load_store, },
> > +	{ "cpu/mem-stores/pp",	       perf_c2c__process_load_store, },
> 
> hm.. so it's only one function for both handlers.. no need
> to use handlers at all then, right?

I implemented them seperately but then realized they look identical once
everything was working, so I combined them again.  I keep thinking there
has to be some advantage to have them seperate, but haven't found a use
case.

You still need to use the handlers, in case you want to add some other events
into the mix and have them filtered out with this tool.

However, I do have the problem of trying to figure out a good way to
dynamically adjust the '30' above.  Seeing that Intel doesn't publish
L1, LFB and L2 latency numbers, we have been guessing at 30 cycles for an
LLC hit.  It would probably be nice to adjust that on the command line as
opposed to recompiling.  Small issue.

Cheers,
Don
