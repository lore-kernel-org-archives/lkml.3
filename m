Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3GHMHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:07:22 -0400
Received: from mail.openrapids.net ([64.15.138.104]:36982 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751770Ab3GHMHV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:07:21 -0400
Date: Mon, 8 Jul 2013 08:07:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mats Liljegren <liljegren.mats2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: lttng and full nohz
Message-ID: <20130708120717.GA21348@Krystal>
References: <CA+xJJ1-2zHMjV3AFiprRjChEff=Bynj4uK_1wL6vKVR=H-T8Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+xJJ1-2zHMjV3AFiprRjChEff=Bynj4uK_1wL6vKVR=H-T8Bg@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mats Liljegren (liljegren.mats2@gmail.com) wrote:
> I've been investigating why lttng destroys full nohz mode, and the
> root cause is that lttng uses timers for flushing trace buffers. So
> I'm planning on moving the timers to the ticking CPU, so that any CPU
> using full nohz mode can continue to do so even though they might have
> tracepoints.
> 
> I can see that kernel/sched/core.c has the function
> get_nohz_timer_target() which tries to find an idle CPU to allocate
> for a timer that has not specified a CPU to be pinned to.
> 
> My question here is: For full nohz mode, should this still be "only"
> an idle CPU, or should it be translated to a CPU not running in full
> nohz mode? I'd think this could make it a lot easier to allow
> applications to make full use of full nohz.

One thing to be aware of wrt LTTng ring buffer: if you look at
lttng-ring-buffer-client.h, you will notice that we use

  .sync = RING_BUFFER_SYNC_PER_CPU,

as ring buffer synchronization. This means we need to issue event write
and sub-buffer switch from the CPU owning the buffer, or, in very
specific cases, if the CPU owning the buffer is offline, we can touch it
from a remote CPU, but just one (e.g. cpu hotplug code).

For the LTTng ring buffer, there are two timers to take into account:
switch_timer and read_timer.

The switch_timer is not enabled by default. When it is enabled by the
end-user, it periodically flush the lttng buffers. If you want to make
this timer execute from a single timer handler and apply to all buffers
(without IPI), you will need to use

  .sync = RING_BUFFER_SYNC_GLOBAL,

to allow concurrent updates to a ring buffer from remote CPUs.

The other timer requires less modifications: the read_timer periodically
checks if the poll() needs to be awakened. It just reads the producer
offset position and compares it to the current consumer position. This
one can be moved to a single timer handler that covers all CPUs without
any change to the "sync" choice.

Please note that the read_timer is current used by default. It can be
entirely removed if you choose

  .wakeup = RING_BUFFER_WAKEUP_BY_WRITER,

instead of RING_BUFFER_WAKEUP_BY_TIMER. However, if you choose the
wakeup by writer, the tracer will discard events coming from NMI
handlers, because some locks need to be taken by the tracing site in
this mode.

If we care about performance and scalability (we really should), the
right approach would be to keep RING_BUFFER_SYNC_PER_CPU though, and
keep the per-CPU timers for periodic flush (switch_timer). We might want
to hook into the full nohz entry/hooks (hopefully they exist) to move
the per-cpu timers out of the full nohz CPUs, and enable a new flag on
these ring buffers that would allow to dynamically change between
RING_BUFFER_SYNC_PER_CPU and RING_BUFFER_SYNC_GLOBAL for a given ring
buffer.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
