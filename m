Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaBNQtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:49:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbaBNQt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:49:28 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 4/5] printk: Use also the last bytes in the ring buffer
Date: Fri, 14 Feb 2014 17:47:35 +0100
Message-Id: <1392396456-19236-5-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
References: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that we have newer used the last byte in the ring buffer. In fact,
we have newer used the last 4 bytes because of padding.

First problem is in the check for free space. The exact number of free bytes
is enough to store the length of data.

Second problem is in the check where the ring buffer is rotated. The left side
counts the first unused index. It is unused, so it might be the same as the size
of the buffer.

Note that the first problem has to be fixed together with the second one.
Otherwise, the buffer is rotated even when there is enough space on the
end of the buffer. Then the beginning of the buffer is rewritten and
valid entries get corrupted.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index bc6eed48a454..a463707ca88f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -319,7 +319,7 @@ static void log_store(int facility, int level,
 		else
 			free = log_first_idx - log_next_idx;
 
-		if (free > size + sizeof(struct printk_log))
+		if (free >= size + sizeof(struct printk_log))
 			break;
 
 		/* drop old messages until we have enough contiuous space */
@@ -327,7 +327,7 @@ static void log_store(int facility, int level,
 		log_first_seq++;
 	}
 
-	if (log_next_idx + size + sizeof(struct printk_log) >= log_buf_len) {
+	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
-- 
1.8.4

