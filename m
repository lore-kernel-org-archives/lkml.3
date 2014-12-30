Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaL3XEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 18:04:32 -0500
Received: from mail.kernel.org ([198.145.29.136]:52706 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaL3XEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 18:04:31 -0500
Date: Tue, 30 Dec 2014 20:04:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: "perf top -g" leaking ~300MB per second.
Message-ID: <20141230230425.GB14973@kernel.org>
References: <20141213084845.GA13453@x4>
 <20141213090331.GB13453@x4>
 <20141213152635.GG9845@kernel.org>
 <548C828B.4040309@gmail.com>
 <20141230053813.GD6081@sejong>
 <20141230083524.GA2143@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230083524.GA2143@x4>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 30, 2014 at 09:35:24AM +0100, Markus Trippelsdorf escreveu:
> On 2014.12.30 at 14:38 +0900, Namhyung Kim wrote:
> > Hi David and Markus,
> > 
> > On Sat, Dec 13, 2014 at 11:16:43AM -0700, David Ahern wrote:
> > > On 12/13/14 8:26 AM, Arnaldo Carvalho de Melo wrote:
> > > >The callchain code was done initially for 'report' and when I made 'top'
> > > >reuse the hist_entry code allowing 'top' to collect callchains was too
> > > >easy, but then we need to go thru the callchain/hists/hist_entry code to
> > > >make sure that they don't leak, will try to do it...
> > > >
> > > 
> > > As I recall it is build up of the dead_threads list.
> > 
> > Maybe.  But I guess it's because of leak of callchains..
> > 
> > Markus, could you please test below patch how much it affects?
> 
> Thanks Namhyung. It leaks an order of magnitude less memory now:
> ~30MB/sec on my machine.
> 
> Valgrind shows (last entries of the list):
> ...
> ==20512== 7,225,920 bytes in 17,370 blocks are possibly lost in loss record 295 of 301
> ==20512==    at 0x402B000: calloc (vg_replace_malloc.c:623)
> ==20512==    by 0x4A6996: zalloc (util.h:189)
> ==20512==    by 0x4A6996: hist_entry__new (hist.c:309)
> ==20512==    by 0x4A8249: add_hist_entry (hist.c:431)
> ==20512==    by 0x4A8249: __hists__add_entry (hist.c:477)
> ==20512==    by 0x4A8902: iter_add_single_cumulative_entry (hist.c:730)
> ==20512==    by 0x4A8A64: hist_entry_iter__add (hist.c:876)
> ==20512==    by 0x43787A: perf_event__process_sample (builtin-top.c:787)
> ==20512==    by 0x43787A: perf_top__mmap_read_idx (builtin-top.c:854)
> ==20512==    by 0x4395EE: perf_top__mmap_read (builtin-top.c:871)
> ==20512==    by 0x4395EE: __cmd_top (builtin-top.c:974)
> ==20512==    by 0x4395EE: cmd_top (builtin-top.c:1266)
> ==20512==    by 0x41B702: run_builtin (perf.c:341)
> ==20512==    by 0x41AE51: handle_internal_command (perf.c:400)
> ==20512==    by 0x41AE51: run_argv (perf.c:444)
> ==20512==    by 0x41AE51: main (perf.c:559)

#1) Ok, those are the hist_entries that were not decayed, if top continued
they would eventually be decayed, freed, etc, i.e. the exit of top is
equivalent to the last decay.

> ==20512== 
> ==20512== 8,922,480 bytes in 159,330 blocks are possibly lost in loss record 296 of 301
> ==20512==    at 0x402B000: calloc (vg_replace_malloc.c:623)
> ==20512==    by 0x4821FE: zalloc (util.h:189)
> ==20512==    by 0x4821FE: fill_node (callchain.c:450)
> ==20512==    by 0x4821FE: add_child (callchain.c:473)
> ==20512==    by 0x4821FE: append_chain_children (callchain.c:596)
> ==20512==    by 0x48514E: callchain_append (callchain.c:672)
> ==20512==    by 0x4A8947: iter_add_single_cumulative_entry (hist.c:739)
> ==20512==    by 0x4A8A64: hist_entry_iter__add (hist.c:876)
> ==20512==    by 0x43787A: perf_event__process_sample (builtin-top.c:787)
> ==20512==    by 0x43787A: perf_top__mmap_read_idx (builtin-top.c:854)
> ==20512==    by 0x43967E: perf_top__mmap_read (builtin-top.c:871)
> ==20512==    by 0x43967E: __cmd_top (builtin-top.c:996)
> ==20512==    by 0x43967E: cmd_top (builtin-top.c:1266)
> ==20512==    by 0x41B702: run_builtin (perf.c:341)
> ==20512==    by 0x41AE51: handle_internal_command (perf.c:400)
> ==20512==    by 0x41AE51: run_argv (perf.c:444)
> ==20512==    by 0x41AE51: main (perf.c:559)
> ==20512== 

> ==20512== 11,050,136 bytes in 1,663 blocks are definitely lost in loss record 297 of 301
> ==20512==    at 0x402B000: calloc (vg_replace_malloc.c:623)
> ==20512==    by 0x44F7BF: zalloc (util.h:189)
> ==20512==    by 0x44F7BF: symbol__alloc_hist (annotate.c:455)
> ==20512==    by 0x44F7BF: symbol__inc_addr_samples (annotate.c:507)
> ==20512==    by 0x44F7BF: hist_entry__inc_addr_samples (annotate.c:521)
> ==20512==    by 0x437A65: perf_top__record_precise_ip (builtin-top.c:195)
> ==20512==    by 0x437A65: hist_iter__top_callback (builtin-top.c:688)
> ==20512==    by 0x4A8AC8: hist_entry_iter__add (hist.c:892)
> ==20512==    by 0x43787A: perf_event__process_sample (builtin-top.c:787)
> ==20512==    by 0x43787A: perf_top__mmap_read_idx (builtin-top.c:854)
> ==20512==    by 0x43967E: perf_top__mmap_read (builtin-top.c:871)
> ==20512==    by 0x43967E: __cmd_top (builtin-top.c:996)
> ==20512==    by 0x43967E: cmd_top (builtin-top.c:1266)
> ==20512==    by 0x41B702: run_builtin (perf.c:341)
> ==20512==    by 0x41AE51: handle_internal_command (perf.c:400)
> ==20512==    by 0x41AE51: run_argv (perf.c:444)
> ==20512==    by 0x41AE51: main (perf.c:559)

These (symbol__alloc_hist) we need to free up the decaying of per RIP
annotation gets to zero... Will check where to do this...

> ==20512== 
> ==20512== 24,920,064 bytes in 59,904 blocks are possibly lost in loss record 298 of 301
> ==20512==    at 0x402B000: calloc (vg_replace_malloc.c:623)
> ==20512==    by 0x4A6996: zalloc (util.h:189)
> ==20512==    by 0x4A6996: hist_entry__new (hist.c:309)
> ==20512==    by 0x4A8249: add_hist_entry (hist.c:431)
> ==20512==    by 0x4A8249: __hists__add_entry (hist.c:477)
> ==20512==    by 0x4A8902: iter_add_single_cumulative_entry (hist.c:730)
> ==20512==    by 0x4A8A64: hist_entry_iter__add (hist.c:876)
> ==20512==    by 0x43787A: perf_event__process_sample (builtin-top.c:787)
> ==20512==    by 0x43787A: perf_top__mmap_read_idx (builtin-top.c:854)
> ==20512==    by 0x43967E: perf_top__mmap_read (builtin-top.c:871)
> ==20512==    by 0x43967E: __cmd_top (builtin-top.c:996)
> ==20512==    by 0x43967E: cmd_top (builtin-top.c:1266)
> ==20512==    by 0x41B702: run_builtin (perf.c:341)
> ==20512==    by 0x41AE51: handle_internal_command (perf.c:400)
> ==20512==    by 0x41AE51: run_argv (perf.c:444)
> ==20512==    by 0x41AE51: main (perf.c:559)

Same thing as #1.

> ==20512== 
> ==20512== 26,147,680 bytes in 62,855 blocks are possibly lost in loss record 299 of 301
> ==20512==    at 0x402B000: calloc (vg_replace_malloc.c:623)
> ==20512==    by 0x4A6996: zalloc (util.h:189)
> ==20512==    by 0x4A6996: hist_entry__new (hist.c:309)
> ==20512==    by 0x4A8249: add_hist_entry (hist.c:431)
> ==20512==    by 0x4A8249: __hists__add_entry (hist.c:477)
> ==20512==    by 0x4A8728: iter_add_next_cumulative_entry (hist.c:803)
> ==20512==    by 0x4A8AA5: hist_entry_iter__add (hist.c:887)
> ==20512==    by 0x43787A: perf_event__process_sample (builtin-top.c:787)
> ==20512==    by 0x43787A: perf_top__mmap_read_idx (builtin-top.c:854)
> ==20512==    by 0x43967E: perf_top__mmap_read (builtin-top.c:871)
> ==20512==    by 0x43967E: __cmd_top (builtin-top.c:996)
> ==20512==    by 0x43967E: cmd_top (builtin-top.c:1266)
> ==20512==    by 0x41B702: run_builtin (perf.c:341)
> ==20512==    by 0x41AE51: handle_internal_command (perf.c:400)
> ==20512==    by 0x41AE51: run_argv (perf.c:444)
> ==20512==    by 0x41AE51: main (perf.c:559)
> ==20512== 
> ==20512== 44,939,792 bytes in 3,788 blocks are definitely lost in loss record 300 of 301
> ==20512==    at 0x402B000: calloc (vg_replace_malloc.c:623)
> ==20512==    by 0x44F7BF: zalloc (util.h:189)
> ==20512==    by 0x44F7BF: symbol__alloc_hist (annotate.c:455)
> ==20512==    by 0x44F7BF: symbol__inc_addr_samples (annotate.c:507)
> ==20512==    by 0x44F7BF: hist_entry__inc_addr_samples (annotate.c:521)
> ==20512==    by 0x437A65: perf_top__record_precise_ip (builtin-top.c:195)
> ==20512==    by 0x437A65: hist_iter__top_callback (builtin-top.c:688)
> ==20512==    by 0x4A8AC8: hist_entry_iter__add (hist.c:892)
> ==20512==    by 0x43787A: perf_event__process_sample (builtin-top.c:787)
> ==20512==    by 0x43787A: perf_top__mmap_read_idx (builtin-top.c:854)
> ==20512==    by 0x4395EE: perf_top__mmap_read (builtin-top.c:871)
> ==20512==    by 0x4395EE: __cmd_top (builtin-top.c:974)
> ==20512==    by 0x4395EE: cmd_top (builtin-top.c:1266)
> ==20512==    by 0x41B702: run_builtin (perf.c:341)
> ==20512==    by 0x41AE51: handle_internal_command (perf.c:400)
> ==20512==    by 0x41AE51: run_argv (perf.c:444)
> ==20512==    by 0x41AE51: main (perf.c:559)
> ==20512== 
> ==20512== 81,248,440 bytes in 1,450,865 blocks are possibly lost in loss record 301 of 301
> ==20512==    at 0x402B000: calloc (vg_replace_malloc.c:623)
> ==20512==    by 0x4821FE: zalloc (util.h:189)
> ==20512==    by 0x4821FE: fill_node (callchain.c:450)
> ==20512==    by 0x4821FE: add_child (callchain.c:473)
> ==20512==    by 0x4821FE: append_chain_children (callchain.c:596)
> ==20512==    by 0x48514E: callchain_append (callchain.c:672)
> ==20512==    by 0x4A8768: iter_add_next_cumulative_entry (hist.c:812)
> ==20512==    by 0x4A8AA5: hist_entry_iter__add (hist.c:887)
> ==20512==    by 0x43787A: perf_event__process_sample (builtin-top.c:787)
> ==20512==    by 0x43787A: perf_top__mmap_read_idx (builtin-top.c:854)
> ==20512==    by 0x43967E: perf_top__mmap_read (builtin-top.c:871)
> ==20512==    by 0x43967E: __cmd_top (builtin-top.c:996)
> ==20512==    by 0x43967E: cmd_top (builtin-top.c:1266)
> ==20512==    by 0x41B702: run_builtin (perf.c:341)
> ==20512==    by 0x41AE51: handle_internal_command (perf.c:400)
> ==20512==    by 0x41AE51: run_argv (perf.c:444)
> ==20512==    by 0x41AE51: main (perf.c:559)
> ==20512== 
> ==20512== LEAK SUMMARY:
> ==20512==    definitely lost: 56,810,427 bytes in 5,479 blocks
> ==20512==    indirectly lost: 4,000 bytes in 125 blocks
> ==20512==      possibly lost: 210,493,048 bytes in 2,552,578 blocks
> ==20512==    still reachable: 18,258 bytes in 242 blocks
> ==20512==         suppressed: 0 bytes in 0 blocks
> 
> -- 
> Markus
