Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3CKKhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:37:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53383 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3CKKhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:37:22 -0400
Message-ID: <1362998219.14933.9.camel@laptop>
Subject: Re: [PATCH] sched: wakeup buddy
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Mon, 11 Mar 2013 11:36:59 +0100
In-Reply-To: <5139520C.1060109@linux.vnet.ibm.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
	 <1362677252.10972.26.camel@laptop> <5139520C.1060109@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 10:50 +0800, Michael Wang wrote:

> > OK, so there's two issues I have with all this are:
> > 
> >  - it completely wrecks task placement for things like interrupts (sadly I don't
> >      have a good idea about a benchmark where this matters).
> 
> I don't get this point...could you please give more details?

Take for instance a network workload, the hardirq notifies us there's
data buffered, then softirq does a ton of network layer demuxing and
eventually wakes one (or more) tasks to process data. You want these
tasks to move to the waking cpu, it has lots of this data in cache.

Now, neither hard- nor softirq runs in task context (except for -rt) so
it completely fails on what you propose.

We could simply add something like in_softirq() || in_irq() etc.. to
re-enable wake_affine() for those cases unconditionally, but not sure
that's the right thing either.

> >  - yet another random number.. :/
> 
> Correct...well, but that also means flexibility, I suppose different
> system and workload will need some tuning on this knob to gain more
> benefit, by default, they will gain some benefit, small or big.

Nah, it just means another knob nobody knows how to twiddle.

> > Also, I'm starting to dislike the buddy name; its somewhat over-used.
> 
> I have to agree :), any suggestions?

Nah.. I suppose it depends a bit on the shape the final solution takes,
but I'll think about it.

