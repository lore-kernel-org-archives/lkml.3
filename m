Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3JCPoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:44:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49650 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3JCPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:44:14 -0400
Date: Thu, 3 Oct 2013 17:44:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, jolsa@redhat.com
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20131003154401.GO31370@twins.programming.kicks-ass.net>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
 <20130912183849.GA16674@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912183849.GA16674@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:38:49PM -0400, Dave Jones wrote:

> The current one I'm staring at is this from LIST_DEBUG..
> 
> list_del corruption. next->prev should be prev (ffff88000fb812b0), but was ffff88000fb812b0. (next=ffff88009df8b7b0).
> 
> The sharp eyed will notice that those first two addresses are actually the same.
> So we matched the next->prev != prev test, but at the time we got to the printk that follows
> in the WARN, the inverse was true. Smells like a race of some kind.

FWIW, I've not given up on this. I've found one bug in the list_entry
handling already -- although not this one.

Today I hit a more revealing error:

[ 8348.150303] list_del corruption. prev->next should be ffff88042839c108, but was 6b6b6b6b6b6b6b6b

And as we all know that 6b is POISON_FREE, so we're staring at a
use-after-free here.

Brain did give out for today though.. more staring at reference counts
tomorrow.

The sad thing is that reproduction takes forever on my machine; I need
to let trinity run for a good hour and then ^C abort the run. Only then
will I hit it fairly reliably.
