Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaGaQTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:19:13 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44551 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaGaQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:19:10 -0400
Date: Thu, 31 Jul 2014 09:19:02 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 0/10] RCU-tasks implementation
Message-ID: <20140731161902.GA12697@cloud>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731003914.GA3872@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 05:39:14PM -0700, Paul E. McKenney wrote:
> This series provides a prototype of an RCU-tasks implementation, which has
> been requested to assist with tramopoline removal.  This flavor of RCU
> is task-based rather than CPU-based, and has voluntary context switch,
> usermode execution, and the idle loops as its only quiescent states.
> This selection of quiescent states ensures that at the end of a grace
> period, there will no longer be any tasks depending on a trampoline that
> was removed before the beginning of that grace period.  This works because
> such trampolines do not contain function calls, do not contain voluntary
> context switches, do not switch to usermode, and do not switch to idle.

I'm concerned about the amount of system overhead this introduces.
Polling for holdout tasks seems quite excessive.  If I understand the
intended use case correctly, the users of this will want to free
relatively small amounts of memory; thus, waiting a while to do so seems
fine, especially if the system isn't under any particular memory
pressure.

Thus, rather than polling, could you simply flag the holdout
tasks, telling the scheduler "hey, next time you don't have anything
better to do..."?  Then don't bother with them again unless the system
runs low on memory and asks you to free some.  (And mandate that you can
only use this to free memory rather than for any other purpose.)

Also, ideally this should remain entirely optional; nothing in the core
kernel should depend on it.

- Josh Triplett
