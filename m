Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3BRRzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:55:06 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35292 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab3BRRzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:55:04 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v4 0/2] perf: use hrtimer for event multiplexing
Date: Mon, 18 Feb 2013 18:54:42 +0100
Message-Id: <1361210084-14409-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current scheme of using the timer tick was fine
for per-thread events. However, it was causing
bias issues in system-wide mode (including for
uncore PMUs). Event groups would not get their
fair share of runtime on the PMU. With tickless
kernels, if a core is idle there is no timer tick,
and thus no event rotation (multiplexing). However,
there are events (especially uncore events) which do
count even though cores are asleep.

This patch changes the timer source for multiplexing.
It introduces a per-cpu hrtimer. The advantage is that
even when the core goes idle, it will come back to
service the hrtimer, thus multiplexing on system-wide
events works much better.

In order to minimize the impact of the hrtimer, it
is turned on and off on demand. When the PMU on
a CPU is overcommitted, the hrtimer is activated.
It is stopped when the PMU is not overcommitted.

In order for this to work properly with HOTPLUG_CPU,
we had to change the order of initialization in
start_kernel() such that hrtimer_init() is run
before perf_event_init().

The second patch provide a sysctl control to
adjust the multiplexing interval. Unit is
milliseconds.

Here is a simple before/after example with
two event groups which do require multiplexing.
This is done in system-wide mode on an idle
system. What matters here is the scaling factor
in [] in not the total counts.

Before:

# perf stat -a -e ref-cycles,ref-cycles sleep 10
 Performance counter stats for 'sleep 10':
 34,319,545 ref-cycles  [56.51%]
 31,917,229 ref-cycles  [43.50%]

 10.000827569 seconds time elapsed

After:
# perf stat -a -e ref-cycles,ref-cycles sleep 10
 Performance counter stats for 'sleep 10':
 11,144,822,193 ref-cycles [50.00%]
 11,103,760,513 ref-cycles [50.00%]

 10.000672946 seconds time elapsed

What matters here is the 50% not the actual
count. Ref-cycles runs only on one fixed counter.
With two instances, each should get 50% of the PMU
which is now true. This helps mitigate the error
introduced by the scaling.

In this second version of the patchset, we now
have the hrtimer_interval per PMU instance. The
tunable is in /sys/devices/XXX/mux_interval_ms,
where XXX is the name of the PMU instance. Due
to initialization changes of each hrtimer, we
had to introduce hrtimer_init_cpu() to initialize
a hrtimer from another CPU.

In the 3rd version, we simplify the code a bit
by using hrtimer_active(). We stopped using
the rotation_list for perf_cpu_hrtimer_cancel().
We also fix an intialization problem.

In the 4th version, we rebase to 3.8.0-rc7 and
we kept SW event on the rotation list which is
now used only for unthrottling. We also renamed
the sysfs tunable to perf_event_mux_interval_ms
to be more consistent with the existing sysctl
entries.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

Stephane Eranian (2):
  perf: use hrtimer for event multiplexing
  perf: add sysfs entry to adjust multiplexing interval per PMU

 include/linux/perf_event.h |    4 +-
 init/main.c                |    2 +-
 kernel/events/core.c       |  169 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 164 insertions(+), 11 deletions(-)

-- 
1.7.9.5

