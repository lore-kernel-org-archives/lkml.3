Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3JSVd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:33:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35587 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3JSVd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:33:56 -0400
Date: Sat, 19 Oct 2013 14:33:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Petr Mladek <pmladek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/6] x86: allow to call text_poke_bp during boot
Message-ID: <20131019213350.GH4118@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1382106445-31468-3-git-send-email-pmladek@suse.cz>
 <52629F08.2010609@hitachi.com>
 <20131019151658.583ac18e@gandalf.local.home>
 <20131019151919.2d4778d2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019151919.2d4778d2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101921-7164-0000-0000-00000297B07C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 03:19:19PM -0400, Steven Rostedt wrote:
> 
> [ Added Paul because he'll understand this ]
> 
> On Sat, 19 Oct 2013 15:16:58 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Sun, 20 Oct 2013 00:02:32 +0900
> > Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> > > (2013/10/18 23:27), Petr Mladek wrote:
> > > > We would like to use text_poke_bp in ftrace. It might be called also during
> > > > boot when the interupts are disabled. We need to enable them for syncing
> > > > the cores on each CPU. Otherwise, there might be a deadlock, see the
> > > > warning in "smp_call_function_many", kernel/smp.c:371.
> > > 
> > > Steven, is this really needed?
> > > I think if this is the special use(e.g. boottime test),
> > > we'd better to run it after boot...
> > > 
> > 
> > It's used to convert the calls to mcount to nops. But maybe a better
> > thing to do is to check if we only have a single CPU:
> > 
> > static void run_sync(void)
> > {
> > 	if (num_online_cpus() != 1)
> 
> Hmm, to be more robust to handle our future "ideal" machines, perhaps
> this should be:
> 
> 	/* Ideally we would like to run on zero CPUS! */
> 	if (num_online_cpus() < 2)

To be really safe, shouldn't you use complex numbers?  Just in case
you end up running on a system with 5i-3 CPUs or something.  ;-)

							Thanx, Paul

> -- Steve
> 
> 
> > 		on_each_cpu(do_sync_core, NULL, 1);
> > }
> > 
> > 
> > I believe that the only time we call this function with interrupts
> > disabled is before SMP is set up. Thus, the above change would handle
> > that case.
> > 
> > -- Steve
> 

