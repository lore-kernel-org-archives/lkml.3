Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaLRCvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:51:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37626 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaLRCvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:51:12 -0500
From: Vikram Mulukutla <markivx@codeaurora.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Lime Yang <limey@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Vikram Mulukutla <markivx@codeaurora.org>
Subject: [PATCH] tracing: Fix unmapping loop in tracing_mark_write
Date: Wed, 17 Dec 2014 18:50:56 -0800
Message-Id: <1418871056-6614-1-git-send-email-markivx@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6edb2a8a385f0cdef51dae37ff23e74d76d8a6ce introduced
an array map_pages that contains the addresses returned by
kmap_atomic. However, when unmapping those pages, map_pages[0]
is unmapped before map_pages[1], breaking the nesting requirement
as specified in the documentation for kmap_atomic/kunmap_atomic.

This was caught by the highmem debug code present in kunmap_atomic.
Fix the loop to do the unmapping properly.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-by: Lime Yang <limey@codeaurora.org>
Signed-off-by: Vikram Mulukutla <markivx@codeaurora.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ab76b7b..bceed34 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4931,7 +4931,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	*fpos += written;
 
  out_unlock:
-	for (i = 0; i < nr_pages; i++){
+	for (i = nr_pages - 1; i >= 0; i--) {
 		kunmap_atomic(map_page[i]);
 		put_page(pages[i]);
 	}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

