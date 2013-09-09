Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3IIN1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:27:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3IIN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:26:53 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5h2nd_9qxKYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_hvWx0eUMykA:10 a=VwQbUJbxAAAA:8 a=1J0JeIo9MnkITmv3CngA:9 a=Zh68SRI7RUMA:10 a=kHDKEh1Unz4A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909124557.340784265@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 08:45:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Joakim Hernberg <jbh@alchemy.lu>
Subject: [PATCH RT 09/16] drm/i915: drop trace_i915_gem_ring_dispatch on rt
References: <20130909124531.445392664@goodmis.org>
Content-Disposition: inline; filename=0009-drm-i915-drop-trace_i915_gem_ring_dispatch-on-rt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This tracepoint is responsible for:

|[<814cc358>] __schedule_bug+0x4d/0x59
|[<814d24cc>] __schedule+0x88c/0x930
|[<814d3b90>] ? _raw_spin_unlock_irqrestore+0x40/0x50
|[<814d3b95>] ? _raw_spin_unlock_irqrestore+0x45/0x50
|[<810b57b5>] ? task_blocks_on_rt_mutex+0x1f5/0x250
|[<814d27d9>] schedule+0x29/0x70
|[<814d3423>] rt_spin_lock_slowlock+0x15b/0x278
|[<814d3786>] rt_spin_lock+0x26/0x30
|[<a00dced9>] gen6_gt_force_wake_get+0x29/0x60 [i915]
|[<a00e183f>] gen6_ring_get_irq+0x5f/0x100 [i915]
|[<a00b2a33>] ftrace_raw_event_i915_gem_ring_dispatch+0xe3/0x100 [i915]
|[<a00ac1b3>] i915_gem_do_execbuffer.isra.13+0xbd3/0x1430 [i915]
|[<810f8943>] ? trace_buffer_unlock_commit+0x43/0x60
|[<8113e8d2>] ? ftrace_raw_event_kmem_alloc+0xd2/0x180
|[<8101d063>] ? native_sched_clock+0x13/0x80
|[<a00acf29>] i915_gem_execbuffer2+0x99/0x280 [i915]
|[<a00114a3>] drm_ioctl+0x4c3/0x570 [drm]
|[<8101d0d9>] ? sched_clock+0x9/0x10
|[<a00ace90>] ? i915_gem_execbuffer+0x480/0x480 [i915]
|[<810f1c18>] ? rb_commit+0x68/0xa0
|[<810f1c6c>] ? ring_buffer_unlock_commit+0x1c/0xa0
|[<81197467>] do_vfs_ioctl+0x97/0x540
|[<81021318>] ? ftrace_raw_event_sys_enter+0xd8/0x130
|[<811979a1>] sys_ioctl+0x91/0xb0
|[<814db931>] tracesys+0xe1/0xe6

Chris Wilson does not like to move i915_trace_irq_get() out of the macro

|No. This enables the IRQ, as well as making a number of
|very expensively serialised read, unconditionally.

so it is gone now on RT.

Cc: stable-rt@vger.kernel.org
Reported-by: Joakim Hernberg <jbh@alchemy.lu>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index e97ed61..4fd9b3f 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1297,7 +1297,9 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 			goto err;
 	}
 
+#ifndef CONFIG_PREEMPT_RT_BASE
 	trace_i915_gem_ring_dispatch(ring, seqno);
+#endif
 
 	exec_start = batch_obj->gtt_offset + args->batch_start_offset;
 	exec_len = args->batch_len;
-- 
1.7.10.4


