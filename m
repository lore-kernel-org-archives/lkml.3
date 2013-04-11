Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab3DKUd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:33:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab3DKU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:14 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6LstSCgQ-xEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=M78_CQRQiDQA:10 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202551.894982360@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 035/171 ] tracing: Fix race in snapshot swapping
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0035-tracing-Fix-race-in-snapshot-swapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ Upstream commit 2721e72dd10f71a3ba90f59781becf02638aa0d9 ]

Although the swap is wrapped with a spin_lock, the assignment
of the temp buffer used to swap is not within that lock.
It needs to be moved into that lock, otherwise two swaps
happening on two different CPUs, can end up using the wrong
temp buffer to assign in the swap.

Luckily, all current callers of the swap function appear to have
their own locks. But in case something is added that allows two
different callers to call the swap, then there's a chance that
this race can trigger and corrupt the buffers.

New code is coming soon that will allow for this race to trigger.

I've Cc'd stable, so this bug will not show up if someone backports
one of the changes that can trigger this bug.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c38c81..0293d9a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -693,7 +693,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct ring_buffer *buf = tr->buffer;
+	struct ring_buffer *buf;
 
 	if (trace_stop_count)
 		return;
@@ -705,6 +705,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	}
 	arch_spin_lock(&ftrace_max_lock);
 
+	buf = tr->buffer;
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 
-- 
1.7.10.4


