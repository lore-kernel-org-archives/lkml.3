Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaEOFce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:32:34 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46787 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaEOFcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:32:32 -0400
Message-ID: <1400131949.5175.114.camel@marge.simpson.net>
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
Date: Thu, 15 May 2014 07:32:29 +0200
In-Reply-To: <20140515050915.GA5539@mtj.dyndns.org>
References: <20140501210242.GA28948@mtj.dyndns.org>
	 <20140501210943.GB28948@mtj.dyndns.org> <537384B9.5090907@suse.cz>
	 <20140514151501.GA24142@suse.cz> <20140514163238.GA15690@htj.dyndns.org>
	 <1400126037.5175.55.camel@marge.simpson.net>
	 <20140515040608.GA3825@htj.dyndns.org>
	 <1400129178.5175.82.camel@marge.simpson.net>
	 <20140515045011.GB3825@htj.dyndns.org>
	 <1400130262.5175.93.camel@marge.simpson.net>
	 <20140515050915.GA5539@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 01:09 -0400, Tejun Heo wrote: 
> Hello, Mike.
> 
> On Thu, May 15, 2014 at 07:04:22AM +0200, Mike Galbraith wrote:
> > On Thu, 2014-05-15 at 00:50 -0400, Tejun Heo wrote: 
> > > Do we know specific kthreads which need to be exposed with this way?
> > 
> > Soft/hard irq threads and anything having to do with IO mostly, which
> > including workqueues.  I had to give the user a rather fugly global
> > prioritization option to let users more or less safely do the evil deeds
> > they want to and WILL do whether I agree with their motivation to do so
> > or not.  I tell all users that realtime is real dangerous, but if they
> > want to do that, it's their box, so by definition perfectly fine.
> 
> Frederic is working on global settings for workqueues, so that'll
> resolve some of those issues at least.

Yeah, wrt what runs where for unbound workqueues, but not priority. 

> > > If there are good enough reasons for specific ones, sure, but I don't
> > > think "we can't change any of the kthreads because someone might be
> > > diddling with it" is something we can sustain in the long term.
> > 
> > I think the opposite.  Taking any control the user has is pure evil.
> 
> I'm not sure good/evil is the right frame to think about it.  Is
> pooling worker threads evil in nature then?

When there may be realtime consumers, yes to some extent, because it
inserts allocations he can't control directly into his world, but that's
the least of his worries.  The instant userspace depends upon any kernel
proxy the user has no control over, he instantly has a priority
inversion he can do nothing about.  This is exactly what happened that
prompted me to do fugly global hack.  User turned pet database piggies
loose as realtime tasks for his own reasons, misguided or not, they
depend upon worker threads and kjournald et al who he can control, but
kworker threads respawn as normal tasks which can and will end up under
high priority userspace tasks.  Worst case is box becomes dead, also
killing pet, best case is pet collapses to the floor in a quivering
heap.  Neither makes Joe User particularly happy.

-Mike

