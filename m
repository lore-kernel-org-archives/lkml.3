Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaIPU6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:58:34 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:36582 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbaIPUwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:04 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com
Subject: [PATCH 06/22] ocfs2: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:20 +0200
Message-Id: <1410900696-6481-7-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/ocfs2/cluster/heartbeat.c | 2 +-
 fs/ocfs2/cluster/masklog.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 7303929..eec35c2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2244,7 +2244,7 @@ ssize_t o2hb_heartbeat_group_mode_store(struct o2hb_heartbeat_group *group,
 		return -EINVAL;
 
 	for (i = 0; i < O2HB_HEARTBEAT_NUM_MODES; ++i) {
-		if (strnicmp(page, o2hb_heartbeat_mode_desc[i], len))
+		if (strncasecmp(page, o2hb_heartbeat_mode_desc[i], len))
 			continue;
 
 		ret = o2hb_global_heartbeat_mode_set(i);
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 07ac24f..af7598b 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -49,13 +49,13 @@ static ssize_t mlog_mask_show(u64 mask, char *buf)
 
 static ssize_t mlog_mask_store(u64 mask, const char *buf, size_t count)
 {
-	if (!strnicmp(buf, "allow", 5)) {
+	if (!strncasecmp(buf, "allow", 5)) {
 		__mlog_set_u64(mask, mlog_and_bits);
 		__mlog_clear_u64(mask, mlog_not_bits);
-	} else if (!strnicmp(buf, "deny", 4)) {
+	} else if (!strncasecmp(buf, "deny", 4)) {
 		__mlog_set_u64(mask, mlog_not_bits);
 		__mlog_clear_u64(mask, mlog_and_bits);
-	} else if (!strnicmp(buf, "off", 3)) {
+	} else if (!strncasecmp(buf, "off", 3)) {
 		__mlog_clear_u64(mask, mlog_not_bits);
 		__mlog_clear_u64(mask, mlog_and_bits);
 	} else
-- 
2.0.4

