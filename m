Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3FDMLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:11:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3FDMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:11:23 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=SF8-ipd7Fh4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=cu63OdLxYnwA:10 a=zvB_8km6gkYWt6PPexMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370347881.26799.114.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Date: Tue, 04 Jun 2013 08:11:21 -0400
In-Reply-To: <20130604110329.GA14973@somewhere>
References: <1369785676.15552.55.camel@gandalf.local.home>
	 <20130604110329.GA14973@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 13:03 +0200, Frederic Weisbecker wrote:

> If ftrace were to use rcu_dereference_sched() instead of rcu_dereference_raw(), I guess
> the issue would have been detected before. But I guess we want to avoid that for
> tracing recursion?

It's been detected before, just ignored as most of ftrace function
tracing has permanent objects and the synchronization doesn't really
matter for them. But for perf and SystemTap that uses dynamically
created ftrace_ops and needs to free them, it does make a difference.
Something I knew needed to be fixed but never got around to it as the
race is extremely tight (and requires root user trying to trigger it). I
haven't been ably to trigger the race, but in theory it's there.

Note the checks that rcu_dereference_sched() has to test for these kinds
of things would cause ftrace to live lock the system if it had used it.
In fact, I had to make a rcu_dereference_raw_notrace() to prevent ftrace
locking up the system when full rcu debugging is enabled.

-- Steve

