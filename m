Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaEBPmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:42:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43869 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaEBPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 066/151] drm/i915: Do not dereference pointers from ring buffer in evict event
Date: Fri,  2 May 2014 08:37:34 -0700
Message-Id: <1399045139-4531-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 9297ebf29ad9118edd6c0fedc84f03e35028827d upstream.

The TP_printk() should never dereference any pointers, because the ring
buffer can be read at some unknown time in the future. If a device no
longer exists, it can cause a kernel oops. This also makes this
event useless when saving the ring buffer in userspaces tools such as
perf and trace-cmd.

The i915_gem_evict_vm dereferences the vm pointer which may also not
exist when the ring buffer is read sometime in the future.

Link: http://lkml.kernel.org/r/1395095198-20034-3-git-send-email-artagnon@gmail.com
Reported-by: Ramkumar Ramachandra <artagnon@gmail.com>
Fixes: bcccff847d1f "drm/i915: trace vm eviction instead of everything"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[danvet: Try to make it actually compile]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_trace.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index 6e580c9..783ae08 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -238,14 +238,16 @@ TRACE_EVENT(i915_gem_evict_vm,
 	    TP_ARGS(vm),
 
 	    TP_STRUCT__entry(
+			     __field(u32, dev)
 			     __field(struct i915_address_space *, vm)
 			    ),
 
 	    TP_fast_assign(
+			   __entry->dev = vm->dev->primary->index;
 			   __entry->vm = vm;
 			  ),
 
-	    TP_printk("dev=%d, vm=%p", __entry->vm->dev->primary->index, __entry->vm)
+	    TP_printk("dev=%d, vm=%p", __entry->dev, __entry->vm)
 );
 
 TRACE_EVENT(i915_gem_ring_sync_to,
-- 
1.9.1

