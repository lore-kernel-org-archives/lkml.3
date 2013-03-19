Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab3CSL35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:29:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3CSL34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:29:56 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=bGeQnFoGQusA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mxv2HPhRFNcA:10 a=frLJNqDbYEwVCny_utsA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363692594.5938.14.camel@gandalf.local.home>
Subject: Re: [PATCH] scheduler: convert BUG_ON()s in try_to_wake_up_local()
 to WARN_ON_ONCE()s
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 07:29:54 -0400
In-Reply-To: <1363688074.22553.14.camel@laptop>
References: <20130318192234.GD3042@htj.dyndns.org>
	 <1363688074.22553.14.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 11:14 +0100, Peter Zijlstra wrote:
> On Mon, 2013-03-18 at 12:22 -0700, Tejun Heo wrote:
> > try_to_wake_up_local() should only be invoked to wake up another task
> > in the same runqueue and BUG_ON()s are used to enforce the rule.
> > Missing try_to_wake_up_local() can stall workqueue execution but such
> > stalls are likely to be finite either by another work item being
> > queued or the one blocked getting unblocked.  There's no reason to
> > trigger BUG while holding rq lock crashing the whole system.
> > 
> > Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s.
> 
> Doesn't really matter either way, the printk()s triggered by either
> will very likely kill the system anyhow ;-)

Only if something blocks on the console lock, and it tries to wake it
up. But even then, it has to be a reverse rq locking order, or wakeup on
the same rq that its running on (which is very unlikely).

I admit that it doesn't "solve" the bug. But at least there's a chance
to investigate what happened when the bug does occur. Right now we have
only one conclusion when the bug triggers, and that's a hard lockup.

-- Steve


