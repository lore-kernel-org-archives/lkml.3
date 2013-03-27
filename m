Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3C0IlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:41:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42425 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3C0IlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:41:11 -0400
Message-ID: <1364373658.5053.52.camel@laptop>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>,
        benisty.e@gmail.com, Ingo Molnar <mingo@redhat.com>
Date: Wed, 27 Mar 2013 09:40:58 +0100
In-Reply-To: <5151BC78.3030306@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	  <5150B1C2.8090607@oracle.com>
	  <20130325163844.042a45ba@annuminas.surriel.com>
	  <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	  <1364303965.5053.29.camel@laptop>
	  <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
	 <1364308023.5053.40.camel@laptop> <5151BC78.3030306@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 11:19 -0400, Rik van Riel wrote:
> That makes me wonder, how did mm_take_all_locks used to work before
> we turned the anon_vma lock into a mutex?
> 
> The code used to use spin_lock_nest_lock, but still has the potential
> to overflow the preempt counter. How did that ever work right?

It did trigger a bunch of warnings, but early on it was understood that
KVM would have 'few' vmas when starting and registering the
mmu_notifier thing.. then KVM bloated into insanity.

But aside from the warnings, if you overflow the regular preempt_count
bits, nothing really bad happens because you start poking at softirq
nesting, then hardirq etc.. all of those also disable preemption. 

You'll get a few 'unexpected' side-effects for things like
serving_softirq()/in_irq() or whatever those functions are called, but
other than that things mostly work.

I don't particularly like overflowing preempt count, but its mostly
harmless (up to a point). The much worse offender in my book is the
duration of the preempt_disable section thus created.

Esp with everything in user control, you can basically create an
arbitrary long non-preempt section with the semops.

