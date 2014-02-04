Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935256AbaBDW42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:56:28 -0500
Received: from mail.efficios.com ([78.47.125.74]:53116 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbaBDW4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:56:24 -0500
Date: Tue, 4 Feb 2014 22:56:24 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: tglx@linutronix.de
Cc: Heinz.Egger@linutronix.de, bigeasy@linutronix.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Molnar, Ingo" <mingo@kernel.org>, rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Message-ID: <238497929.19329.1391554584871.JavaMail.zimbra@efficios.com>
In-Reply-To: <104831840.19303.1391553779700.JavaMail.zimbra@efficios.com>
Subject: Perf user-space ABI sequence lock memory barriers
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.114.90.220]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF26 (Linux)/8.0.5_GA_5839)
Thread-Topic: Perf user-space ABI sequence lock memory barriers
Thread-Index: tU4aEo8ChZC1MoMlGAd5jPvQvpZ8tw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently integrating user-space performance counters from
Perf into LTTng-UST, and I'm noticing something odd regarding
the home-made sequence lock found at:

kernel/events/core.c: perf_event_update_userpage()

        ++userpg->lock;
        barrier();
[...]
        barrier();
        ++userpg->lock;

This goes in pair with something like this at user-level:

        do {
                seq = pc->lock;
                barrier();

                idx = pc->index;
                count = pc->offset;
                if (idx)
                        count += rdpmc(idx - 1);

                barrier();
        } while (pc->lock != seq);

As we see, only compiler barrier() are protecting all this.
First question, is it possible that the update be performed
by a thread running on a different CPU than the thread reading
the info in user-space ?

I would be tempted to use a volatile semantic on all reads of the
lock field (ACCESS_ONCE()). Secondly, read sequence locks usually use a
smp_rmb() at the end of the seqcount_begin(), and at the beginning
of the seqcount_retry(). Moreover, this is usually matched
by smp_wmb() in write_seqcount begin/end().

Am I missing something special about this lock that makes these
barriers unnecessary ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
