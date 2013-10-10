Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3JJFrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:47:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3JJFrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:47:08 -0400
Date: Wed, 9 Oct 2013 22:47:55 -0700
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
Subject: Re: [PATCH 1/6] hotplug: Optimize {get,put}_online_cpus()
Message-Id: <20131009224755.09d32206.akpm@linux-foundation.org>
In-Reply-To: <20131008103830.117402375@infradead.org>
References: <20131008102505.404025673@infradead.org>
	<20131008103830.117402375@infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Oct 2013 12:25:06 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> The current implementation of get_online_cpus() is global of nature
> and thus not suited for any kind of common usage.
> 
> Re-implement the current recursive r/w cpu hotplug lock such that the
> read side locks are as light as possible.
> 
> The current cpu hotplug lock is entirely reader biased; but since
> readers are expensive there aren't a lot of them about and writer
> starvation isn't a particular problem.
> 
> However by making the reader side more usable there is a fair chance
> it will get used more and thus the starvation issue becomes a real
> possibility.
> 
> Therefore this new implementation is fair, alternating readers and
> writers; this however requires per-task state to allow the reader
> recursion.

Obvious question: can't we adapt lglocks for this?  It would need the
counter in task_struct to permit reader nesting, but what else is
needed?

