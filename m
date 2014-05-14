Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaENQcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:32:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38408 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbaENQcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:32:41 -0400
Date: Wed, 14 May 2014 12:32:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Michael Matz <matz@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140514163238.GA15690@htj.dyndns.org>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
 <20140501142414.GA31611@htj.dyndns.org>
 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
 <20140501210242.GA28948@mtj.dyndns.org>
 <20140501210943.GB28948@mtj.dyndns.org>
 <537384B9.5090907@suse.cz>
 <20140514151501.GA24142@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514151501.GA24142@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jiri, Vojtech.

On Wed, May 14, 2014 at 05:15:01PM +0200, Vojtech Pavlik wrote:
> On Wed, May 14, 2014 at 04:59:05PM +0200, Jiri Slaby wrote:
> > I see the worst case scenario. (For curious readers, it is for example
> > this kthread body:
> > while (1) {
> >   some_paired_call(); /* invokes pre-patched code */
> >   if (kthread_should_stop()) { /* kgraft switches to the new code */
> >     its_paired_function(); /* invokes patched code (wrong) */
> >     break;
> >   }
> >   its_paired_function(); /* the same (wrong) */
> > })
> > 
> > What to do with that now? We have come up with a couple possibilities.
> > Would you consider try_to_freeze() a good state-defining function? As it
> > is called when a kthread expects weird things can happen, it should be
> > safe to switch to the patched version in our opinion.
> > 
> > The other possibility is to patch every kthread loop (~300) and insert
> > kgr_task_safe() semi-manually at some proper place.
> > 
> > Or if you have any other suggestions we would appreciate that?
> 
> A heretic idea would be to convert all kernel threads into functions
> that do not sleep and exit after a single iteration and are called from
> a central kthread main loop function. That would get all of

Or converting them to use workqueues instead.  Converting majority of
kthread users to workqueue is probably a good idea regardless of this
because workqueues are far easier to get right and give clear
delineation boundary between execution instances between which it's
safe to freeze and shutdown (and possibly to patch the work function).
Let alone overall lower overhead.  I converted some and was planning
on converting most of them but never got around ot it.

> kthread_should_stop() and try_to_freeze() and kgr_task_safe() nicely
> into one place and at the same time put enough constraint on what the
> thread function can do to prevent it from breaking the assumptions of
> each of these calls. 

Yeah, the exactly same rationales for using workqueue over kthreads.
That said, even with most kthread users converted to workqueue, we'd
probably want something which can really enforce correctness for the
leftovers as long as we continue to expose kthread interface.  Ooh,
there's also kthread_worker thing which puts workqueue-like semantics
on top of kthreads which can be used for whatever which can't be
converted to workqueue due to special worker attributes or whatnot.

So, yeah, I think there are enough tools available to put enough
semantic meanings over how kthreads are used such that things like
freezer or hot-code patching can be implemented in the generic
framework rather than in hundred scattered places but it's likely to
take a substantial amount of work.  The upside is that conversions are
likely beneficial on their own so they can be pushed separately.

Thanks.

-- 
tejun
