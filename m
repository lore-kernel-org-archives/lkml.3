Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaEODyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:54:03 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:39967 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaEODyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:54:01 -0400
Message-ID: <1400126037.5175.55.camel@marge.simpson.net>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 15 May 2014 05:53:57 +0200
In-Reply-To: <20140514163238.GA15690@htj.dyndns.org>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
	 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
	 <20140501142414.GA31611@htj.dyndns.org>
	 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
	 <20140501210242.GA28948@mtj.dyndns.org>
	 <20140501210943.GB28948@mtj.dyndns.org> <537384B9.5090907@suse.cz>
	 <20140514151501.GA24142@suse.cz> <20140514163238.GA15690@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 12:32 -0400, Tejun Heo wrote: 
> Hello, Jiri, Vojtech.
> 
> On Wed, May 14, 2014 at 05:15:01PM +0200, Vojtech Pavlik wrote:
> > On Wed, May 14, 2014 at 04:59:05PM +0200, Jiri Slaby wrote:
> > > I see the worst case scenario. (For curious readers, it is for example
> > > this kthread body:
> > > while (1) {
> > >   some_paired_call(); /* invokes pre-patched code */
> > >   if (kthread_should_stop()) { /* kgraft switches to the new code */
> > >     its_paired_function(); /* invokes patched code (wrong) */
> > >     break;
> > >   }
> > >   its_paired_function(); /* the same (wrong) */
> > > })
> > > 
> > > What to do with that now? We have come up with a couple possibilities.
> > > Would you consider try_to_freeze() a good state-defining function? As it
> > > is called when a kthread expects weird things can happen, it should be
> > > safe to switch to the patched version in our opinion.
> > > 
> > > The other possibility is to patch every kthread loop (~300) and insert
> > > kgr_task_safe() semi-manually at some proper place.
> > > 
> > > Or if you have any other suggestions we would appreciate that?
> > 
> > A heretic idea would be to convert all kernel threads into functions
> > that do not sleep and exit after a single iteration and are called from
> > a central kthread main loop function. That would get all of
> 
> Or converting them to use workqueues instead.  Converting majority of
> kthread users to workqueue is probably a good idea regardless of this
> because workqueues are far easier to get right and give clear
> delineation boundary between execution instances between which it's
> safe to freeze and shutdown (and possibly to patch the work function).
> Let alone overall lower overhead.  I converted some and was planning
> on converting most of them but never got around ot it.

Hm.  The user would need to be able to identify and prioritize the
things, and have his settings stick.  Any dynamic pool business doing
allocations and/or munging priorities would be highly annoying.

I saw a case where dynamic workers inflicted a realtime regression on a
user (but what they were getting away with previously was.. horrid).

-Mike

