Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3AUVRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:17:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21666 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3AUVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:29 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=l4BbF3yPhCkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yqYrUU7wycAA:10 a=20KFwNOVAAAA:8 a=eEcxTydvMsNfiGhbaFQA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211727.615543487@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/13 -next] ring-buffer: Remove unnecessary recusive call in rb_advance_iter()
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0002-ring-buffer-Remove-unnecessary-recusive-call-in-rb_a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The original ring-buffer code had special checks at the start
of rb_advance_iter() and instead of repeating them again at the
end of the function if a certain condition existed, I just did
a recursive call to rb_advance_iter() because the special condition
would cause rb_advance_iter() to return early (after the checks).

But as things have changed, the special checks no longer exist
and the only thing done for the special_condition is to call
rb_inc_iter() and return. Instead of doing a confusing recursive call,
just call rb_inc_iter instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ce8514f..6ff9cc4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3425,7 +3425,7 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 	/* check for end of page padding */
 	if ((iter->head >= rb_page_size(iter->head_page)) &&
 	    (iter->head_page != cpu_buffer->commit_page))
-		rb_advance_iter(iter);
+		rb_inc_iter(iter);
 }
 
 static int rb_lost_events(struct ring_buffer_per_cpu *cpu_buffer)
-- 
1.7.10.4


