Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaEOEGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:06:15 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:33073 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOEGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:06:14 -0400
Date: Thu, 15 May 2014 00:06:08 -0400
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
Message-ID: <20140515040608.GA3825@htj.dyndns.org>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
 <20140501142414.GA31611@htj.dyndns.org>
 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
 <20140501210242.GA28948@mtj.dyndns.org>
 <20140501210943.GB28948@mtj.dyndns.org>
 <537384B9.5090907@suse.cz>
 <20140514151501.GA24142@suse.cz>
 <20140514163238.GA15690@htj.dyndns.org>
 <1400126037.5175.55.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400126037.5175.55.camel@marge.simpson.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Mike.

On Thu, May 15, 2014 at 05:53:57AM +0200, Mike Galbraith wrote:
> Hm.  The user would need to be able to identify and prioritize the

I suppose you mean userland by "the user"?

> things, and have his settings stick.  Any dynamic pool business doing
> allocations and/or munging priorities would be highly annoying.

There are some use cases where control over worker priority or other
attributes are necessary.  I'm not sure using kthread for that reason
is a good engineering choice tho.  Many of those cases end up being
accidental.

I think it'd be healthier to identify the use cases and then provide
proper interface for it.  Note that workqueue can now expose interface
to modify concurrency, priority and cpumask to userland which
writeback workers are already using.

In general, being restricted to using kthread internally for this
reason seems wrong to me.  It's too direct influence on the
implementation mechanism.

> I saw a case where dynamic workers inflicted a realtime regression on a
> user (but what they were getting away with previously was.. horrid).

Yeah, exactly.  It'd be far better to identify the use case properly
and provide the appropriate interface for it.  That said, even if it
really requires diddling with kthread directly from userland,
kthread_worker can still be used.  It's still one dedicated kthread
but with structured usage from kernel side so that infrastructure
features like freezer and possibly kgr can be implemented in a single
place rather than scattered around all over the place.

Thanks.

-- 
tejun
