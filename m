Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbaDHQKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:10:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42731 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbaDHQKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:10:34 -0400
Date: Tue, 8 Apr 2014 18:10:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: sched: long running interrupts breaking spinlocks
Message-ID: <20140408161023.GP10526@twins.programming.kicks-ass.net>
References: <53441540.7070102@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53441540.7070102@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 11:26:56AM -0400, Sasha Levin wrote:
> Hi all,
> 
> (all the below happened inside mm/ code, so while I don't suspect
> it's a mm/ issue you folks got cc'ed anyways!)
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following:
> 
> [ 4071.166362] BUG: spinlock lockup suspected on CPU#19, trinity-c19/17092

That's a heuristic in the spinlock code; triggering it with big machines
(19 cpus is far bigger than anything at the time that code was written)
and virt (yay for lock owner preemption; another thing we didn't have
back when) is trivial.

I'd not worry too much about this.

So DEBUG_SPINLOCKS turns spin_lock() into something like:

  for (i = 0; i < loops; i++)
  	if (spin_trylock())
		return;

  /* complain */

And you simply ran out of loops.
