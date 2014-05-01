Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaEAL1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:27:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49583 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbaEAL1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:27:48 -0400
From: Will Deacon <will.deacon@arm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Kay Sievers <kay@vrfy.org>
Subject: [RESEND PATCH 2/2] printk: report dropping of messages from logbuf
Date: Thu,  1 May 2014 12:27:40 +0100
Message-Id: <1398943660-5706-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398943660-5706-1-git-send-email-will.deacon@arm.com>
References: <1398943660-5706-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the log ring buffer becomes full, we silently overwrite old messages
with new data. console_unlock will detect this case and fast-forward the
console_* pointers to skip over the corrupted data, but nothing will be
reported to the user.

This patch hijacks the first valid log message after detecting that we
dropped messages and prefixes it with a note detailing how many messages
were dropped. For long (~1000 char) messages, this will result in some
truncation of the real message, but given that we're dropping things
anyway, that doesn't seem to be the end of the world.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 kernel/printk/printk.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 721a7d8fb853..e9e83d627ff0 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2046,10 +2046,15 @@ again_noirq:
 		}
 
 		if (console_seq < log_first_seq) {
+			len = sprintf(text, "** %u printk messages dropped ** ",
+				      (unsigned)(log_first_seq - console_seq));
+
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
 			console_prev = 0;
+		} else {
+			len = 0;
 		}
 skip:
 		if (console_seq == log_next_seq)
@@ -2074,8 +2079,8 @@ skip:
 		}
 
 		level = msg->level;
-		len = msg_print_text(msg, console_prev, false,
-				     text, sizeof(text));
+		len += msg_print_text(msg, console_prev, false,
+				      text + len, sizeof(text) - len);
 		console_idx = log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
-- 
1.9.2

