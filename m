Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935318Ab3DJHFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:05:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3DJHFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:05:21 -0400
Message-ID: <1365577512.30071.11.camel@laptop>
Subject: Re: [PATCH 2/7] sched: Update rq clock on nohz CPU before setting
 fair group shares
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Date: Wed, 10 Apr 2013 09:05:12 +0200
In-Reply-To: <CAFTL4hxcQyv_J4ky8wL0rzVemWPpBcjuCV=FeHBvXn5Bht-3OA@mail.gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
	 <1365266760-24725-3-git-send-email-fweisbec@gmail.com>
	 <1365499591.30071.3.camel@laptop>
	 <CAFTL4hxcQyv_J4ky8wL0rzVemWPpBcjuCV=FeHBvXn5Bht-3OA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 15:21 +0200, Frederic Weisbecker wrote:
> 
> Also please check those two patches in my series, it's a draft for an
> rq clock debug framework. For now it's just a brainless stale clock
> check but that's a start:
> 
> * http://thread.gmane.org/gmane.linux.kernel/1470769/focus=1470786
> * http://thread.gmane.org/gmane.linux.kernel/1470769/focus=1470750

Right.. I was thinking of something like function-graph trace, where
we'd mark the context (fgraph_data I think its called) of the function
calling update_rq_clock() (and inherit this state on all child
contexts) and then verify the current context has this marker set when
we read ->clock.


Now clearly that would not work for something like:

  a()
   b()
    update_rq_clock()
   c()
    read_rq_clock()

since we'd loose the marker once we pop b, but I'm not sure how common
this is.

Also, we could issue a warning when calling update_rq_clock() and the
marker is already set.

There's a further issue where we need to track the rq we updated vs the
rq we're reading, but I think even without that this might be of some
help.


I think Mike once tried something along the lines of keeping a per rq
state that got cleared at the end of schedule() but that doesn't catch
things like the migrate handlers I think.

