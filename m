Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaDOQJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:09:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaDOQJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:09:00 -0400
Date: Tue, 15 Apr 2014 12:08:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: acme@kernel.org, jolsa@redhat.com, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/5] perf: Create hist_entry groups
Message-ID: <20140415160841.GT8488@redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
 <878ur7thwh.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878ur7thwh.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:01:50PM +0900, Namhyung Kim wrote:
> Hi Don,
> 
> On Thu, 10 Apr 2014 16:10:56 -0400, Don Zickus wrote:
> > This patchset creates a new layer of hist entry objects called
> > hist_entry_groups.  The purpose is to help organize the hist_entries
> > into groups before sorting them.  As a result you can gain a
> > new perspective on the data by organizing the groups into cpu, pid
> > or cacheline.  See patch 5 for sample output.
> >
> > The main driver for this patchset is to find a way to sort and display
> > cacheline data in a way that is useful.  My previous attempts seemed
> > hackish until I realized cacheline sorting is really just a collection
> > of hist_entries.  Anyway that was my focus for doing this.
> >
> > The overall idea looks like:
> >
> > evlist
> >   evsel
> >     hists
> >         hist_entry_group  <<< new object
> >           hist_entry
> >
> >
> > Implementing this was not pretty.  I tried to seperate the patches the
> > best I could.  But in order for each patch to compile, patch 4 turned into
> > a 1400 line diff that is mostly noise.
> >
> > Also, this patchset breaks most tools (mainly because I don't understand
> > all the interactions), hence the RFC.  I mostly tested with 'perf report
> >  --stdio' and 'perf mem report --stdio'.
> >
> > Please let me know if this is an interesting idea to go forward with or not.
> 
> I'd like to show you my previous two patchsets.
> 
> The first one is for adding --field option and changing the sort
> behavior little different [1].  I'm about to send a new version to the
> list soon.
> 
> I think what you want to do is sorting output by an order of sort keys
> not just by the overhead.  So with the patchset applied, you can do it
> like:
> 
>   $ perf report --field overhead,pid,dso,sym --sort pid
> 
>   # Overhead         Command:  Pid      Shared Object                             
>   # ........  ....................  .................  ...........................
>   #
>       32.93%         swapper:    0  [kernel.kallsyms]  [k] intel_idle             
>        6.79%         swapper:    0  [kernel.kallsyms]  [k] enqueue_entity         
>        1.42%         swapper:    0  [kernel.kallsyms]  [k] update_sd_lb_stats     
>        1.30%         swapper:    0  [kernel.kallsyms]  [k] timekeeping_max_deferme
>        1.18%         swapper:    0  [kernel.kallsyms]  [k] update_cfs_shares      
>        1.07%         swapper:    0  [kernel.kallsyms]  [k] __irq_work_run         
>        0.96%         swapper:    0  [kernel.kallsyms]  [k] rcu_check_callbacks    
>        0.64%         swapper:    0  [kernel.kallsyms]  [k] irqtime_account_process
>        0.50%         swapper:    0  [kernel.kallsyms]  [k] int_sqrt               
>        0.47%         swapper:    0  [kernel.kallsyms]  [k] __tick_nohz_idle_enter 
>        0.47%         swapper:    0  [kernel.kallsyms]  [k] menu_select            
>        0.35%         swapper:    0  [kernel.kallsyms]  [k] run_timer_softirq      
>        0.16%         swapper:    0  [kernel.kallsyms]  [k] __perf_event_enable    
>        0.12%         swapper:    0  [kernel.kallsyms]  [k] rcu_eqs_exit_common.isr
>        0.50%      watchdog/6:   37  [kernel.kallsyms]  [k] update_sd_lb_stats     
>        3.45%            Xorg: 1335  [kernel.kallsyms]  [k] schedule               
>        6.55%  gnome-terminal: 1903  libc-2.17.so       [.] __strcmp_sse42         
>        1.59%         firefox: 2137  [kernel.kallsyms]  [k] cpuacct_charge         
>        0.50%           emacs: 2473  emacs-24.1         [.] 0x000000000012241a     
>        0.38%           emacs: 2473  emacs-24.1         [.] 0x00000000000bfbf7     
>        0.31%           emacs: 2473  emacs-24.1         [.] 0x00000000001780dd     
>        0.29%           emacs: 2473  emacs-24.1         [.] 0x000000000002eb48     
>        4.40%     kworker/7:1:11028  [kernel.kallsyms]  [k] generic_exec_single    
>        1.30%     kworker/0:0:25667  [kernel.kallsyms]  [k] generic_exec_single    
>        5.93%     kworker/5:1:26447  [kernel.kallsyms]  [k] generic_exec_single    
>        2.06%     kworker/1:2:26653  [kernel.kallsyms]  [k] generic_exec_single    
> 
> As you can see the output is now sorted by pid value (and then overhead,
> dso, sym if previous key resulted in a same value), so swapper (pid 0)
> comes first and then watchdog/6, Xorg, and so on..

This is probably a workable solution for our c2c tool.  I can play with
this some more.

> 
> But it's not guarantee that the hottest pid comes always first on the
> output, it just sorted it by pid and it gets the result simply because
> the system was idle mostly.  I think you can handle it in your c2c tool
> properly though.
> 
> Another one I'd like to introduce is somewhat similar to your work.
> It's called hierarchy view and groups each entries according to sort
> keys [2].  But it only supported --gtk output at that time (in order not
> to make the hands dirty unnecessarily ;-) and (thus?) didn't get much
> review.  But I think the idea is same and requires less change by just
> adding few fields (rb_root) to hist_entry instead of new data structure.

Looks promising.

I keep thinking with all these hist_entry hacks to support flexibility, if
we should just do some bigger changes to the design.  I was thinking along
the lines of combining hist_entries and callchain stuff and maybe output
changes into a unified heirarchy somehow.  This way we could re-use alot
of code and throw away all the silly callchain special cases and just
treat it like a sort_entry.

I am not sure how that would work (or if really possible), but I was
playing with ideas in my head based on Jiri's suggestion, of something
like a tree layout where 'struct hists' would be sorta like a directory
and would dictate the data type in the 'files' of 'struct hist_entry'.

The idea was 'struct hists' would normally have a HIST data type and
contain the specific sort_entry(ies) for its heirarchy.  The 'struct
hist_entries' below it would all be the normal HIST data type.  For
callchain support, there would be a 'struct hist' under each 'hist_entry'
that would be of data type CALLCHAIN and its sort specific rules.

This way we could add display a callchain anywhere in the heirarchy
(instead of the normal last position).

If you then split the entries and entries_in out of struct hist and
instead create two 'struct hists', one for input and one output.  Then
perhaps we could create a data type GTK_OUT for a gtk specific output sort
of entries.  This might help re-use/reduce some of the ui/ code.

Anyway, it is probably way to much thrashing, just some ideas to help
promote better data visibilty.

I was enjoying the ideas of 'groups' and how it can help re-arrange the
data and allow us to look at bottlenecks differently.  While --field and
--hierarchy can achieve similar things, I am wondering if the output is
still simple enough to interpret (and the commandline simple enough for
users to utilize).

My 2cents.  Time to jump on a plane.

Cheers,
Don
