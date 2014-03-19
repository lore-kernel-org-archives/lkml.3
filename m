Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaCSU2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:28:45 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:56997 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaCSU2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:28:43 -0400
Date: Wed, 19 Mar 2014 16:28:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, uobergfe@redhat.com
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work queues
Message-ID: <20140319202839.GA3656@mtj.dyndns.org>
References: <20140319151252.16ed3ac6@gandalf.local.home>
 <20140319193407.GA11257@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319193407.GA11257@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven, Peter.

On Wed, Mar 19, 2014 at 08:34:07PM +0100, Peter Zijlstra wrote:
> The way I understand workqueues is that we cannot guarantee concurrency
> like this. It tries, but there's no guarantee.

So, the guarantee is that if a workqueue has WQ_MEM_RECLAIM, it'll
always have at least one worker thread working on it, so workqueues
which may be depended upon during memory reclaim should have the flag
set and must not require more than single level of concurrency to make
forward progress.  Workqueues w/o memory reclaim set depend on the
fact that eventually memory will be reclaimed and enough number of
workers necessary to make forward progress will be made available.

> WQ_MAX_ACTIVE seems to be a hard upper limit of concurrent workers. So
> given 511 other blocked works, the described problem will always happen.

That actually is per-workqueue limit and workqueue core will try to
create as many workers as possible to satisfy the demanded
concurrency.  ie. having two workqueues with the same max_active means
that the total number of workers may reach 2 * max_active; however,
this is no guarantee.  If the system is under memory pressure and the
workqueues don't have MEM_RECLAIM set, they may not get any
concurrency until more memory is made available.

> Creating another workqueue doesn't actually create more threads.

It looks like the issue Steven is describing is caused by having a
dependency chain longer than 1 through rwsem in a MEM_RECLAIM
workqueue.  Moving the write work items to a separate workqueue breaks
the r-w-r chain and ensures that forward progress can be made with
single level of concurrency on both workqueues, so, yeah, it looks
like the correct fix to me.  It it scarily subtle tho and quite likely
to present in other code paths too. :(

Thanks.

-- 
tejun
