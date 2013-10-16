Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761899Ab3JPURG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761874Ab3JPURE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:17:04 -0400
Date: Wed, 16 Oct 2013 22:10:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf: Do not waste PAGE_SIZE bytes for ALIGN(8) in
	perf_event_mmap_event()
Message-ID: <20131016201004.GC23214@redhat.com>
References: <20131012192203.GA21738@redhat.com> <20131014102426.GX3081@twins.programming.kicks-ass.net> <20131016200924.GA23214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016200924.GA23214@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event_mmap_event() does kzalloc(PATH_MAX + sizeof(u64)) to
ensure we can align the size later. However this means that we
actually allocate PAGE_SIZE * 2 buffer, seems too much.

Change this code to allocate PATH_MAX==PAGE_SIZE bytes, but tell
d_path() to not use the last sizeof(u64) bytes.

Note: it is not clear why do we need __GFP_ZERO, see the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/core.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e27d8f8..4a1e7b8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5107,17 +5107,18 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	if (file) {
 		struct inode *inode;
 		dev_t dev;
+
+		buf = kzalloc(PATH_MAX, GFP_KERNEL);
+		if (!buf) {
+			name = strncpy(tmp, "//enomem", sizeof(tmp));
+			goto got_name;
+		}
 		/*
 		 * d_path works from the end of the rb backwards, so we
 		 * need to add enough zero bytes after the string to handle
 		 * the 64bit alignment we do later.
 		 */
-		buf = kzalloc(PATH_MAX + sizeof(u64), GFP_KERNEL);
-		if (!buf) {
-			name = strncpy(tmp, "//enomem", sizeof(tmp));
-			goto got_name;
-		}
-		name = d_path(&file->f_path, buf, PATH_MAX);
+		name = d_path(&file->f_path, buf, PATH_MAX - sizeof(u64));
 		if (IS_ERR(name)) {
 			name = strncpy(tmp, "//toolong", sizeof(tmp));
 			goto got_name;
-- 
1.5.5.1


