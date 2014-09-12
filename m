Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaILMKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:10:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:42363 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbaILMKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:10:54 -0400
Date: Fri, 12 Sep 2014 09:10:43 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf top -g -U --sort=symbol --children == lalalalala?
Message-ID: <20140912121043.GE1801@kernel.org>
References: <1410263641.15383.8.camel@marge.simpson.net>
 <20140909133737.GK2773@kernel.org>
 <CAM9d7cgCuVVNrA7DU=t_CgENLa-dxRW2HXoO3Uo6=2izshSjhg@mail.gmail.com>
 <1410439392.20184.17.camel@marge.simpson.net>
 <20140911134338.GE10158@kernel.org>
 <878ulpmhbt.fsf@sejong.aot.lge.com>
 <1410511293.5547.33.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410511293.5547.33.camel@marge.simpson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 12, 2014 at 10:41:33AM +0200, Mike Galbraith escreveu:
> On Fri, 2014-09-12 at 16:24 +0900, Namhyung Kim wrote: 
> > Hi Arnaldo and Mike,
> > 
> > On Thu, 11 Sep 2014 10:43:38 -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Sep 11, 2014 at 02:43:12PM +0200, Mike Galbraith escreveu:
> > >> On Thu, 2014-09-11 at 17:09 +0900, Namhyung Kim wrote: 
> > >> > On Tue, Sep 9, 2014 at 10:37 PM, Arnaldo Carvalho de Melo
> > >> > <acme@ghostprotocols.net> wrote:
> > >> > > Em Tue, Sep 09, 2014 at 01:54:01PM +0200, Mike Galbraith escreveu:
> > >> > >> Seems the now default on --children thingy doesn't like -U much.
> > >> > >
> > >> > > Namhyung, can you please take a look at this?
> > >> > 
> > >> > So what is the problem here?
> > >> 
> > >> Well, if you don't see anything wrong, I guess nothing at all.
> > >
> > > :-)
> > >
> > > I think that when we decide that it is so better to change defaults like
> > > we did this time, we should be required to add a big fat warning (a
> > > --tui popup, use the first lines on --stdio, etc) about why the default
> > > was changed and allow quick, easy opt out, restoring previous behaviour
> > > after the user, being warned, knows what to expect, tries it, and then
> > > is in a better position to decide if keeping the new default is what is
> > > desired.
> > 
> > So the problem is that why it turned on --children option by default,
> > right?  I thought you mentioned there's a problem with -U option and I
> > couldn't figure out what it is.
> > 
> > 
> > >  
> > >> > >> Samples: 5K of event 'cycles', Event count (approx.): 2268660922
> > >> > >>   Children      Self  Symbol
> > >> > >> +   46.42%     0.04%  [k] system_call_fastpath
> > >  
> > >> I'll just turn it off until I figure out what cool stuff this is telling
> > >> me. why that symbol becomes the number one hit, and why total% > 100.
> > >  
> > >> To me, it looks like top smoked it's breakfast, went to lala land ;-)
> > >
> > > Yeah, its confusing, I'll let Namhyung explain it ;-)
> > 
> > Now I have three persion yell at me for this change. :)
> > 
> > When this change was developping, Ingo said it'd be better if it looks
> > like output of sysprof as it's more popular for most (userland?) guys.
> > You can see the discussion in the following links:
> > 
> >   https://lkml.org/lkml/2013/10/31/97
> >   https://lkml.org/lkml/2013/11/1/85
> > 
> > The children field is a cumulative total overhead (for its all
> > children/callee) so sum of them would be more than 100%.  And as Ingo
> > requested it sorts the output entries using children overhead so that
> > one can easily see higher level view of performance bottle-neck.
> 
> I still don't get why my #1 _KERNEL_ (-U) overhead in the below changes
> from __schedule() to system_call().  The thing that's consuming the most
> cycles remains __schedule().  It doesn't really matter much I 'spose,
> turning it off in .perfconfig works fine.
> 
> (seems top wants to learn to ignore cpu_startup_entry too [see hmm
> below], and maybe grow an option to _not_ ignore idle stuff)

yeah, ideally we would have some flag from the kernel stating that it is
idle context, so that we don't have to keep this list of idle functions.

Until then we can try to get this more manageable by having a file where
people can add idle functions and as well as not just discard entries
for these functions, but instead mark them as idle.

And as well have a key in interactive tools to toggle them on/off and
somethile like -U/-K to set the initial value of this toggle from the
command line.
 
> --no-children
> -    6.52%  [k] __schedule
>    - __schedule
>       - 56.95% schedule
>            99.88% pipe_wait
>               pipe_read
>               new_sync_read
>               vfs_read
>               sys_read
>               system_call
>               __read_nocancel
>               __libc_start_main
>       + 40.63% schedule_preempt_disabled
>       + 1.03% __read_nocancel
>         0.78% pipe_wait
>            pipe_read
>            new_sync_read
>            vfs_read
>            sys_read
>            system_call
>            __read_nocancel
>            __libc_start_main
>       + 0.62% cpu_startup_entry <== hmm
> +    5.13%  [k] native_sched_clock
> +    4.80%  [k] system_call
> +    4.36%  [k] resched_curr
> +    3.59%  [k] _raw_spin_lock_irqsave
> +    3.34%  [k] __switch_to
> 
> 
> --children
> +   68.49%     4.92%  [k] system_call
> +   32.75%     0.42%  [k] sys_write
> +   31.85%     0.86%  [k] vfs_write
> +   30.20%     0.43%  [k] sys_read
> +   29.34%     0.74%  [k] new_sync_write
> +   29.22%     0.62%  [k] vfs_read
> +   27.88%     0.70%  [k] new_sync_read
> +   27.65%     1.70%  [k] pipe_write
> +   26.62%     2.86%  [k] cpu_startup_entry  <== hmm
> +   26.23%     2.05%  [k] pipe_read
> +   22.38%     0.45%  [k] __wake_up_sync_key
> -   21.92%     6.61%  [k] __schedule
>    - __schedule
>       - 62.95% schedule
>            99.88% pipe_wait
>               pipe_read
>               new_sync_read
>               vfs_read
>               sys_read
>               system_call
>               __read_nocancel
>       + 35.27% schedule_preempt_disabled
>       + 1.38% __read_nocancel
> +   20.53%     0.81%  [k] __wake_up_common
> +   19.72%     0.17%  [k] autoremove_wake_function
> +   19.55%     0.09%  [k] default_wake_function
> +   19.01%     1.44%  [k] try_to_wake_up
> +   18.65%     0.84%  [k] pipe_wait
> +   15.07%     1.06%  [k] schedule
> 
