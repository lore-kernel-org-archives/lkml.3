Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3EaIu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:50:56 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45283 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3EaIs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:27 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 10/16] perf, persistent: Reworking perf_get_persistent_event_fd()
Date: Fri, 31 May 2013 10:47:30 +0200
Message-Id: <1369990056-10310-11-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

There is already a function anon_inode_getfd() that does already all
the work. Reworking and simplifying code.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 7d1aff3..4ecbdab 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -87,33 +87,6 @@ static void del_persistent_event(int cpu, struct perf_event_attr *attr)
 	kfree(desc);
 }
 
-static int __alloc_persistent_event_fd(struct pers_event_desc *desc)
-{
-	struct file *event_file = NULL;
-	int event_fd = -1;
-
-	event_fd = get_unused_fd();
-	if (event_fd < 0)
-		goto out;
-
-	event_file = anon_inode_getfile("[pers_event]", &perf_fops,
-					desc->event, O_RDONLY);
-	if (IS_ERR(event_file))
-		goto err_event_file;
-
-	desc->fd = event_fd;
-	fd_install(event_fd, event_file);
-
-	goto out;
-
-
- err_event_file:
-	put_unused_fd(event_fd);
-
- out:
-	return event_fd;
-}
-
 /*
  * Create and enable the persistent version of the perf event described by
  * @attr.
@@ -165,11 +138,17 @@ int perf_add_persistent_event_by_id(int id)
 int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
 {
 	struct pers_event_desc *desc = get_persistent_event(cpu, attr);
+	int event_fd;
 
 	if (!desc)
 		return -ENODEV;
 
-	return __alloc_persistent_event_fd(desc);
+	event_fd = anon_inode_getfd("[pers_event]", &perf_fops,
+				desc->event, O_RDONLY);
+	if (event_fd >= 0)
+		desc->fd = event_fd;
+
+	return event_fd;
 }
 
 
-- 
1.8.1.1

