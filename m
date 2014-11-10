Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaKJKk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:40:57 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:41528 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaKJKky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:40:54 -0500
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: namhyung@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc: avanzini.arianna@gmail.com
Subject: [PATCH RFC v2] trace, blktrace: don't let the sysfs interface remove trace from running list
Date: Mon, 10 Nov 2014 11:40:49 +0100
Message-Id: <1415616049-1132-1-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <8761env4vf.fsf@sejong.aot.lge.com>
References: <8761env4vf.fsf@sejong.aot.lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, blktrace can be started/stopped via its ioctl-based interface
(used by the userspace blktrace tool) or via its ftrace interface. The
function blk_trace_remove_queue(), called each time an "enable" tunable
of the ftrace interface transitions to zero, removes the trace from the
running list, even if no function from the sysfs interface adds it to
such a list. This leads to a null pointer dereference.
This commit changes the blk_trace_remove_queue() function so that it
does not remove the blk_trace from the running list.

v2:
    - Now the patch removes the invocation of list_del() instead of
      adding an useless if branch, as suggested by Namhyung Kim.

Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 kernel/trace/blktrace.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c1bd4ad..bd05fd2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1493,9 +1493,6 @@ static int blk_trace_remove_queue(struct request_queue *q)
 	if (atomic_dec_and_test(&blk_probes_ref))
 		blk_unregister_tracepoints();
 
-	spin_lock_irq(&running_trace_lock);
-	list_del(&bt->running_list);
-	spin_unlock_irq(&running_trace_lock);
 	blk_trace_free(bt);
 	return 0;
 }
-- 
2.1.2

