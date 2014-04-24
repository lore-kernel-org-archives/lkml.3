Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaDXS7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:59:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:38800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbaDXS7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:59:01 -0400
Date: Thu, 24 Apr 2014 20:58:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, tkhai@yandex.ru
Subject: Re: Real-time scheduling policies and hyper-threading
Message-ID: <20140424185858.GB26782@laptop.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36851398363372@webcorp2g.yandex-team.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:16:12PM +0400, Roman Gushchin wrote:
> Are there any known solutions of this problem except disabling
> hyper-threading and frequency scaling at all?

This is what we generally tell people to do; disable HT in the BIOS,
offline the siblings or similar approaches.

Similarly we typically tell people to keep each rt workload to a single
NUMA node, and in case the workload really is bigger and must cross into
multiple, use memory interleave where possible.

> Are there any common plans to enhance the load balancing algorithm in
> the rt-scheduler?

Nope; at best the topology driven placement is going to be a heuristic,
and the last thing you want for your realtime tasks is (non deterministic)
placement heuristics.

You, and only you, know your workload and can devise a correct placement
policy. We have cpusets and cpu affinity available to carve up your
system for this.

That said, there might be something we could do for soft(er) realtime,
but I don't think there's been much (if any) research on this.

> Does anyone use rt-scheduler for runtime-like cpu-bound tasks?

So in general cpu bound tasks in the RT classes (FIFO/RR/DEADLINE) are
bad and can make the system go funny.

For general system health it is important that various system tasks
(kthreads usually) can run. Many of these kthreads run at !rt prios, and
by having cpu bound tasks in rt prios they don't get to run.


