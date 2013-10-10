Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3JJFtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:49:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3JJFtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:49:18 -0400
Date: Wed, 9 Oct 2013 22:50:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-Id: <20131009225006.7101379c.akpm@linux-foundation.org>
In-Reply-To: <20131008102505.404025673@infradead.org>
References: <20131008102505.404025673@infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Oct 2013 12:25:05 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> The current cpu hotplug lock is a single global lock; therefore excluding
> hotplug is a very expensive proposition even though it is rare occurrence under
> normal operation.
> 
> There is a desire for a more light weight implementation of
> {get,put}_online_cpus() from both the NUMA scheduling as well as the -RT side.
> 
> The current hotplug lock is a full reader preference lock -- and thus supports
> reader recursion. However since we're making the read side lock much cheaper it
> is the expectation that it will also be used far more. Which in turn would lead
> to writer starvation.
> 
> Therefore the new lock proposed is completely fair; albeit somewhat expensive
> on the write side. This in turn means that we need a per-task nesting count to
> support reader recursion.

This is a lot of code and a lot of new complexity.  It needs some pretty
convincing performance numbers to justify its inclusion, no?
