Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaAXLIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:08:43 -0500
Received: from ms01.sssup.it ([193.205.80.99]:54153 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752345AbaAXLIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:08:41 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 06:08:41 EST
Message-ID: <52E23BA3.7090206@sssup.it>
Date: Fri, 24 Jan 2014 10:08:35 +0000
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Luca Abeni <luca.abeni@unitn.it>
CC: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        nicola.manica@disi.unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com, rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <20140120112442.GA8907@austad.us> <52DD1377.5090201@gmail.com> <20140120131616.GB8907@austad.us> <52DD2711.9080504@unitn.it> <20140121102016.GA12002@austad.us> <52DE5B7F.8020900@unitn.it> <20140121123334.GJ30183@twins.programming.kicks-ass.net> <52DE6D21.1080602@unitn.it> <20140121135559.GK30183@twins.programming.kicks-ass.net> <52DFC196.7020301@unitn.it> <20140122135159.GQ31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140122135159.GQ31570@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/14 13:51, Peter Zijlstra wrote:
>>> Another possibly extension; one proposed by Ingo; is to demote tasks to
>>> SCHED_OTHER once they exceed their budget instead of the full block they
>>> get now -- we could possibly call this SCHED_FLAG_DL_CBS_SOFT or such.

Soft reservations are also very useful, as in multimedia and adaptive RT  apps
we expect these budgets to be roughly estimated, rather than being carefully
computed WCETs.

For example, in the experimentation with adaptive budget tuning made with Jack,

  http://retis.sssup.it/~tommaso/papers/lac11.php

the best results were achieved just setting the QOS_F_SOFT flag of the old
AQuoSA (apologies for mentioning that old crappy code), that was implementing
exactly downgrade of the task to the regular CFS scheduler for the time in
which the budget was exhausted.
That Jack-related scenario is quite challenging as due to the change in the
required budget due to new Jack clients joining, or varying workloads of
existing clients (e.g., timidity). At least, as far as the intention of being
seamless to applications is kept (apps required no change at all -- only Jack
server and client library were changed). FYI, I wish we could replay those
modifications on top of SCHED_DEADLINE one day :-)...

  http://repo.or.cz/w/jack2.git/shortlog/refs/heads/aquosa

> We should also again talk about what it would take to allow
> unprivileged access to SCHED_DEADLINE. The things I can remember are the
> obvious cap on utilization and a minimum period -- the latter so that we
> don't DoS the system with a metric ton of tiny tasks.
> 
> But I seem to remember there were a few other issues.

Exactly. I can remember also a huge period might be harmful, because with it
even a tiny utilization may lead to a big runtime that starves the whole non
RT tasks for a significant time. Just in case, I had this paper

  http://retis.sssup.it/~tommaso/papers/rtas08.php

discussing the issues I had found, and how they were tackled in the AQuoSA
supervisor. See Section 3.1. Note that the AQuoSA model was probably more
complex due to the possibility of hosting multiple tasks in the same
deadline-driven reservation, and the possibility for parts of the tasks
in a user reservation being capable of being re-wrapped within another
app-specific reservation etc.... I'd expect the situation to be quite
simpler with SCHED_DEADLINE.

My2c,

	Tommaso

