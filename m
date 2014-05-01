Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaEAVJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:09:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46359 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaEAVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:09:47 -0400
Date: Thu, 1 May 2014 17:09:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140501210943.GB28948@mtj.dyndns.org>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
 <20140501142414.GA31611@htj.dyndns.org>
 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
 <20140501210242.GA28948@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501210242.GA28948@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 05:02:42PM -0400, Tejun Heo wrote:
> Hello, Jiri.
> 
> On Thu, May 01, 2014 at 10:17:44PM +0200, Jiri Kosina wrote:
> > I agree that this expectation might really somewhat implicit and is not 
> > probably properly documented anywhere. The basic observation is "whenever 
> > kthread_should_stop() is being called, all data structures are in a 
> > consistent state and don't need any further updates in order to achieve 
> > consistency, because we can exit the loop immediately here", as 
> > kthread_should_stop() is the very last thing every freezable kernel thread 
> 
> But kthread_should_stop() doesn't necessarily imply that "we can exit
> the loop *immediately*" at all.  It just indicates that it should
> terminate in finite amount of time.  I don't think it'd be too

Just a bit of addition.  Please note that kthread_should_stop(), along
with the freezer test, is actually trickier than it seems.  It's very
easy to write code which works most of the time but misses wake up
from kill when the timing is just right (or wrong).  It should be
interlocked with set_current_state() and other related queueing data
structure accesses.  This was several years ago but when I audited
most kthread users in kernel, especially in combination with the
freezer test which also has similar requirement, surprising percentage
of users (at least several tens of pct) were getting it slightly
wrong, so kthread_should_stop() really isn't used as "we can exit
*immediately*".  It just isn't that simple.

Thanks.

-- 
tejun
