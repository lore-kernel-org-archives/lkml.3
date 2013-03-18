Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3CRS2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:28:19 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:49530 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3CRS2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:28:18 -0400
Date: Mon, 18 Mar 2013 11:21:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: workqueue code needing preemption disabled
Message-ID: <20130318182130.GA3042@htj.dyndns.org>
References: <1363617383.25967.152.camel@gandalf.local.home>
 <20130318160652.GA20133@mtj.dyndns.org>
 <1363623799.25967.172.camel@gandalf.local.home>
 <1363624020.25967.175.camel@gandalf.local.home>
 <1363624243.25967.178.camel@gandalf.local.home>
 <20130318164351.GA21516@mtj.dyndns.org>
 <1363626487.25967.186.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363626487.25967.186.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 01:08:07PM -0400, Steven Rostedt wrote:
> On Mon, 2013-03-18 at 09:43 -0700, Tejun Heo wrote:
> 
> > Making gcwq locks disable preemption would be much safer / easier, but
> > if that's not desirable, anything touching gcwq->idle_list would be a
> > good place to start - worker_enter_idle() and worker_leave_idle().
> > Hmmm... ignoring CPU hotplug, I think those two might just do it.
> > Give it a try?  How reproducible is the problem?
> 
> Not very :-( I triggered it twice on a 40 CPU box. It can go
> approximately 1 month before it triggers. And the box we are testing on
> is currently a loaner, and we have it on extension right now. Which
> means we wont have it much longer.
> 
> But perhaps that's the place to fix things.

I've been thinking about it and AFAICS the only way that BUG_ON()
could trigger from preemption is if preemption happens while the
idle_list head is becoming or stopping being empty.
ie. pool->worklist is half updated so list_empty() isn't true but the
first next entry is already pointing back to itself.  If there's a
crashdump, it shouldn't be too difficult to verify and wrapping the
above two functions should resolve it.

Thanks.

-- 
tejun
