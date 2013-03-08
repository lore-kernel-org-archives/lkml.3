Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab3CHDHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760224Ab3CHDGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:55 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4kdi2j5RM5EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=V3aKm8yhTOcA:10 a=20KFwNOVAAAA:8 a=5jHLcVRV713uWfaQrGEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030653.089018575@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 08/17] tracing: Add config option to allow snapshot to swap per cpu
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Add-config-option-to-allow-snapshot-to-swap-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

When the preempt or irq latency tracers are enabled, they require
the ring buffer to be able to swap the per cpu sub buffers between
two main buffers. This adds a slight overhead to tracing as the
trace recording needs to perform some checks to synchronize
between recording and swaps that might be happening on other CPUs.

The config RING_BUFFER_ALLOW_SWAP is set when a user of the ring
buffer needs the "swap cpu" feature, otherwise the extra checks
are not implemented and removed from the tracing overhead.

The snapshot feature will swap per CPU if the RING_BUFFER_ALLOW_SWAP
config is set. But that only gets set by things like OPROFILE
and the irqs and preempt latency tracers.

This config is added to let the user decide to include this feature
with the snapshot agnostic from whether or not another user of
the ring buffer sets this config.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 590a27f..f78eab2 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -192,6 +192,7 @@ config IRQSOFF_TRACER
 	select TRACER_MAX_TRACE
 	select RING_BUFFER_ALLOW_SWAP
 	select TRACER_SNAPSHOT
+	select TRACER_SNAPSHOT_PER_CPU_SWAP
 	help
 	  This option measures the time spent in irqs-off critical
 	  sections, with microsecond accuracy.
@@ -215,6 +216,7 @@ config PREEMPT_TRACER
 	select TRACER_MAX_TRACE
 	select RING_BUFFER_ALLOW_SWAP
 	select TRACER_SNAPSHOT
+	select TRACER_SNAPSHOT_PER_CPU_SWAP
 	help
 	  This option measures the time spent in preemption-off critical
 	  sections, with microsecond accuracy.
@@ -266,6 +268,27 @@ config TRACER_SNAPSHOT
 	      echo 1 > /sys/kernel/debug/tracing/snapshot
 	      cat snapshot
 
+config TRACER_SNAPSHOT_PER_CPU_SWAP
+        bool "Allow snapshot to swap per CPU"
+	depends on TRACER_SNAPSHOT
+	select RING_BUFFER_ALLOW_SWAP
+	help
+	  Allow doing a snapshot of a single CPU buffer instead of a
+	  full swap (all buffers). If this is set, then the following is
+	  allowed:
+
+	      echo 1 > /sys/kernel/debug/tracing/per_cpu/cpu2/snapshot
+
+	  After which, only the tracing buffer for CPU 2 was swapped with
+	  the main tracing buffer, and the other CPU buffers remain the same.
+
+	  When this is enabled, this adds a little more overhead to the
+	  trace recording, as it needs to add some checks to synchronize
+	  recording with swaps. But this does not affect the performance
+	  of the overall system. This is enabled by default when the preempt
+	  or irq latency tracers are enabled, as those need to swap as well
+	  and already adds the overhead (plus a lot more).
+
 config TRACE_BRANCH_PROFILING
 	bool
 	select GENERIC_TRACER
-- 
1.7.10.4


