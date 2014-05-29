Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaE2Efc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaE2EfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.14 064/140] drm/i915: Do not dereference pointers from ring buffer in evict event
Date: Wed, 28 May 2014 21:33:23 -0700
Message-Id: <20140529043057.706056903@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_trace.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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


