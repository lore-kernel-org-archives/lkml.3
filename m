Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaAOFTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:19:48 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:32828 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaAOFTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:19:47 -0500
Date: Tue, 14 Jan 2014 21:19:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH v2 tip/core/timers] Crude timer-wheel latency hacks
Message-ID: <20140115051939.GA31164@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011505-8236-0000-0000-000006151FBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following three patches provide some crude timer-wheel latency
patches.  I understand that a more comprehensive solution is in progress,
but in the meantime, these patches work well in cases where a given
CPU has either zero or one timers pending, which is a common case for
NO_HZ_FULL kernels.  So, on the off-chance that this is helpful to
someone, the individual patches are as follows:

1.	Add ->all_timers field to tbase_vec to count all timers, not
	just the non-deferrable ones.

2.	Avoid jiffy-at-a-time stepping when the timer wheel is empty.

3.	Avoid jiffy-at-a-time stepping when the timer wheel transitions
	to empty.

4.	Avoid jiffy-at-a-time stepping after a timer is added to an
	initially empty timer wheel.

Differences from v1:

o	Fix an embarrassing bug located by Oleg Nesterov where the
	timer wheel could be judged to be empty even if it contained
	deferrable timers.

							Thanx, Paul

------------------------------------------------------------------------

 b/kernel/timer.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

