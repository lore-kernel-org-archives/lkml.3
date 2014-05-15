Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaEOGFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:05:21 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36888 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaEOGFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:05:20 -0400
Date: Thu, 15 May 2014 02:05:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140515060515.GB5539@mtj.dyndns.org>
References: <537384B9.5090907@suse.cz>
 <20140514151501.GA24142@suse.cz>
 <20140514163238.GA15690@htj.dyndns.org>
 <1400126037.5175.55.camel@marge.simpson.net>
 <20140515040608.GA3825@htj.dyndns.org>
 <1400129178.5175.82.camel@marge.simpson.net>
 <20140515045011.GB3825@htj.dyndns.org>
 <1400130262.5175.93.camel@marge.simpson.net>
 <20140515050915.GA5539@mtj.dyndns.org>
 <1400131949.5175.114.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400131949.5175.114.camel@marge.simpson.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mike.

On Thu, May 15, 2014 at 07:32:29AM +0200, Mike Galbraith wrote:
> On Thu, 2014-05-15 at 01:09 -0400, Tejun Heo wrote: 
> > > Soft/hard irq threads and anything having to do with IO mostly, which
> > > including workqueues.  I had to give the user a rather fugly global
> > > prioritization option to let users more or less safely do the evil deeds
> > > they want to and WILL do whether I agree with their motivation to do so
> > > or not.  I tell all users that realtime is real dangerous, but if they
> > > want to do that, it's their box, so by definition perfectly fine.
> > 
> > Frederic is working on global settings for workqueues, so that'll
> > resolve some of those issues at least.
> 
> Yeah, wrt what runs where for unbound workqueues, but not priority. 

Shouldn't be too difficult to extend it to cover priorities if
necessary once the infrastructure is in place.

> > > > If there are good enough reasons for specific ones, sure, but I don't
> > > > think "we can't change any of the kthreads because someone might be
> > > > diddling with it" is something we can sustain in the long term.
> > > 
> > > I think the opposite.  Taking any control the user has is pure evil.
> > 
> > I'm not sure good/evil is the right frame to think about it.  Is
> > pooling worker threads evil in nature then?
> 
> When there may be realtime consumers, yes to some extent, because it
> inserts allocations he can't control directly into his world, but that's
> the least of his worries.  The instant userspace depends upon any kernel
> proxy the user has no control over, he instantly has a priority
> inversion he can do nothing about.  This is exactly what happened that
> prompted me to do fugly global hack.  User turned pet database piggies
> loose as realtime tasks for his own reasons, misguided or not, they
> depend upon worker threads and kjournald et al who he can control, but
> kworker threads respawn as normal tasks which can and will end up under
> high priority userspace tasks.  Worst case is box becomes dead, also
> killing pet, best case is pet collapses to the floor in a quivering
> heap.  Neither makes Joe User particularly happy.

I'm not sure how much weight I can put on the specific use case.  Even
with the direct control that the user thought to have previously, the
use case was ripe with possibilities of breakage from any number of
reasons.  For example, there are driver paths which bounce to async
execution on IO exceptions (doesn't have to be hard errors) and setups
like the above would easily lock out exception handling and how's the
setup gonna work when the filesystems have to use dynamic pool of
workers as btrfs does?

The identified problem in the above case is allowing the kernel to
make reasonable forward progress even when RT processes don't concede
CPU cycles.  If that is a use case that needs to be supported, we
better engineer an appropriate solution for that.  Such solution
doesn't necessarily have to be advanced either.  Maybe all that's
necessary is marking the async mechanisms involved in IO path as such
(we already need to mark all workqueues involved in memory reclaim
path anyway) and provide a mechanism to make all of them RT when
directed.  It might be simple but still would be a concious
engineering decision.

I think the point I'm trying to make is that it isn't possible to
continue improving and maintaining the kernel with blanket
restrictions on internal details.  If certain things shouldn't be
done, we better find out the specific reasons; otherwise, it's
impossible to weight the pros and cons of different options and make a
reasonable choice or to find out ways to accomodate those restrictions
while still achieving the original goals.

Anyways, we're getting slightly off-topic and it seems like we'll have
to agree to disagree.

Thanks.

-- 
tejun
