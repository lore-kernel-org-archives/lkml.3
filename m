Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaILIll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:41:41 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:46788 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaILIli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:41:38 -0400
Message-ID: <1410511293.5547.33.camel@marge.simpson.net>
Subject: Re: perf top -g -U --sort=symbol --children == lalalalala?
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2014 10:41:33 +0200
In-Reply-To: <878ulpmhbt.fsf@sejong.aot.lge.com>
References: <1410263641.15383.8.camel@marge.simpson.net>
	 <20140909133737.GK2773@kernel.org>
	 <CAM9d7cgCuVVNrA7DU=t_CgENLa-dxRW2HXoO3Uo6=2izshSjhg@mail.gmail.com>
	 <1410439392.20184.17.camel@marge.simpson.net>
	 <20140911134338.GE10158@kernel.org> <878ulpmhbt.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 16:24 +0900, Namhyung Kim wrote: 
> Hi Arnaldo and Mike,
> 
> On Thu, 11 Sep 2014 10:43:38 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Sep 11, 2014 at 02:43:12PM +0200, Mike Galbraith escreveu:
> >> On Thu, 2014-09-11 at 17:09 +0900, Namhyung Kim wrote: 
> >> > On Tue, Sep 9, 2014 at 10:37 PM, Arnaldo Carvalho de Melo
> >> > <acme@ghostprotocols.net> wrote:
> >> > > Em Tue, Sep 09, 2014 at 01:54:01PM +0200, Mike Galbraith escreveu:
> >> > >> Seems the now default on --children thingy doesn't like -U much.
> >> > >
> >> > > Namhyung, can you please take a look at this?
> >> > 
> >> > So what is the problem here?
> >> 
> >> Well, if you don't see anything wrong, I guess nothing at all.
> >
> > :-)
> >
> > I think that when we decide that it is so better to change defaults like
> > we did this time, we should be required to add a big fat warning (a
> > --tui popup, use the first lines on --stdio, etc) about why the default
> > was changed and allow quick, easy opt out, restoring previous behaviour
> > after the user, being warned, knows what to expect, tries it, and then
> > is in a better position to decide if keeping the new default is what is
> > desired.
> 
> So the problem is that why it turned on --children option by default,
> right?  I thought you mentioned there's a problem with -U option and I
> couldn't figure out what it is.
> 
> 
> >  
> >> > >> Samples: 5K of event 'cycles', Event count (approx.): 2268660922
> >> > >>   Children      Self  Symbol
> >> > >> +   46.42%     0.04%  [k] system_call_fastpath
> >  
> >> I'll just turn it off until I figure out what cool stuff this is telling
> >> me. why that symbol becomes the number one hit, and why total% > 100.
> >  
> >> To me, it looks like top smoked it's breakfast, went to lala land ;-)
> >
> > Yeah, its confusing, I'll let Namhyung explain it ;-)
> 
> Now I have three persion yell at me for this change. :)
> 
> When this change was developping, Ingo said it'd be better if it looks
> like output of sysprof as it's more popular for most (userland?) guys.
> You can see the discussion in the following links:
> 
>   https://lkml.org/lkml/2013/10/31/97
>   https://lkml.org/lkml/2013/11/1/85
> 
> The children field is a cumulative total overhead (for its all
> children/callee) so sum of them would be more than 100%.  And as Ingo
> requested it sorts the output entries using children overhead so that
> one can easily see higher level view of performance bottle-neck.

I still don't get why my #1 _KERNEL_ (-U) overhead in the below changes
from __schedule() to system_call().  The thing that's consuming the most
cycles remains __schedule().  It doesn't really matter much I 'spose,
turning it off in .perfconfig works fine.

(seems top wants to learn to ignore cpu_startup_entry too [see hmm
below], and maybe grow an option to _not_ ignore idle stuff)

--no-children
-    6.52%  [k] __schedule
   - __schedule
      - 56.95% schedule
           99.88% pipe_wait
              pipe_read
              new_sync_read
              vfs_read
              sys_read
              system_call
              __read_nocancel
              __libc_start_main
      + 40.63% schedule_preempt_disabled
      + 1.03% __read_nocancel
        0.78% pipe_wait
           pipe_read
           new_sync_read
           vfs_read
           sys_read
           system_call
           __read_nocancel
           __libc_start_main
      + 0.62% cpu_startup_entry <== hmm
+    5.13%  [k] native_sched_clock
+    4.80%  [k] system_call
+    4.36%  [k] resched_curr
+    3.59%  [k] _raw_spin_lock_irqsave
+    3.34%  [k] __switch_to


--children
+   68.49%     4.92%  [k] system_call
+   32.75%     0.42%  [k] sys_write
+   31.85%     0.86%  [k] vfs_write
+   30.20%     0.43%  [k] sys_read
+   29.34%     0.74%  [k] new_sync_write
+   29.22%     0.62%  [k] vfs_read
+   27.88%     0.70%  [k] new_sync_read
+   27.65%     1.70%  [k] pipe_write
+   26.62%     2.86%  [k] cpu_startup_entry  <== hmm
+   26.23%     2.05%  [k] pipe_read
+   22.38%     0.45%  [k] __wake_up_sync_key
-   21.92%     6.61%  [k] __schedule
   - __schedule
      - 62.95% schedule
           99.88% pipe_wait
              pipe_read
              new_sync_read
              vfs_read
              sys_read
              system_call
              __read_nocancel
      + 35.27% schedule_preempt_disabled
      + 1.38% __read_nocancel
+   20.53%     0.81%  [k] __wake_up_common
+   19.72%     0.17%  [k] autoremove_wake_function
+   19.55%     0.09%  [k] default_wake_function
+   19.01%     1.44%  [k] try_to_wake_up
+   18.65%     0.84%  [k] pipe_wait
+   15.07%     1.06%  [k] schedule


