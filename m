Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaEAVCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:02:50 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:46028 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaEAVCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:02:46 -0400
Date: Thu, 1 May 2014 17:02:42 -0400
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
Message-ID: <20140501210242.GA28948@mtj.dyndns.org>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
 <20140501142414.GA31611@htj.dyndns.org>
 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jiri.

On Thu, May 01, 2014 at 10:17:44PM +0200, Jiri Kosina wrote:
> I agree that this expectation might really somewhat implicit and is not 
> probably properly documented anywhere. The basic observation is "whenever 
> kthread_should_stop() is being called, all data structures are in a 
> consistent state and don't need any further updates in order to achieve 
> consistency, because we can exit the loop immediately here", as 
> kthread_should_stop() is the very last thing every freezable kernel thread 

But kthread_should_stop() doesn't necessarily imply that "we can exit
the loop *immediately*" at all.  It just indicates that it should
terminate in finite amount of time.  I don't think it'd be too
difficult to find cases where kthreads do some stuff before returning
after testing kthread_should_stop().  e.g. after pending changes,
workqueue rescuers do one final loop over pending work items after
kthread_should_stop() tests positive to ensure empty queue on exit.
Please note that there's no expectation of discontinuity over the
test.  The users may carry over any state across the test as they see
fit.

> is calling before starting a new iteration.
> 
> For the sake of collecting data points -- do you happen to have any 
> counter-example to the assumption?

Just grep for kthread_should_stop() and look for the ones which
doesn't immediately perform return?  I think there are more which
don't return *immediately*.  You'd have to audit each and everyone to
determine that they don't carry over states across the test.  Most
will hopefully be trivial but not all.  More importantly, sounds like
a maintenance nightmare to me without any means to guarantee, or even
reasonably increase, correctness.

Thanks.

-- 
tejun
