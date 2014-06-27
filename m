Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaF0TLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:11:03 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:45223 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaF0TLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:11:02 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: pmladek@suse.cz, jack@suse.cz, joe@perches.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] printk: tweak do_syslog() to match comments
Date: Fri, 27 Jun 2014 14:11:01 -0500
Message-Id: <1403896261-15464-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In do_syslog() there's a path used by kmsg_poll() and kmsg_read()
that only needs to know whether there's any data available to read
(and not its size).  These callers only check for non-zero return.
As a shortcut, do_syslog() returns the difference between what
has been logged and what has been "seen."

The comments say that the "count of records" should be returned but
it's not.  Instead it returns (log_next_idx - syslog_idx), which is
a difference between buffer offsets--and the result could be negative.

The behavior is the same (it'll be zero or not in the same cases),
but the count of records is more meaningful and it matches what the
comments say.  So change the code to return that.

Signed-off-by: Alex Elder <elder@linaro.org>
---
This patch is also available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/do_syslog_tweak

 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ea2d5f6..f4a92e8 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1310,7 +1310,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			 * for pending data, not the size; return the count of
 			 * records, not the length.
 			 */
-			error = log_next_idx - syslog_idx;
+			error = log_next_seq - syslog_seq;
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
-- 
1.9.1

