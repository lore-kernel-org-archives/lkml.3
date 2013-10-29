Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab3J2OIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:08:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab3J2OIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:08:51 -0400
Date: Tue, 29 Oct 2013 07:08:16 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-3ea2f2b96f9e636f49eb10962e96db3e19cab157@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131016201004.GC23214@redhat.com>
References: <20131016201004.GC23214@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Do not waste PAGE_SIZE bytes for ALIGN(8)
  in perf_event_mmap_event()
Git-Commit-ID: 3ea2f2b96f9e636f49eb10962e96db3e19cab157
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:08:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ea2f2b96f9e636f49eb10962e96db3e19cab157
Gitweb:     http://git.kernel.org/tip/3ea2f2b96f9e636f49eb10962e96db3e19cab157
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 16 Oct 2013 22:10:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:52 +0100

perf: Do not waste PAGE_SIZE bytes for ALIGN(8) in perf_event_mmap_event()

perf_event_mmap_event() does kzalloc(PATH_MAX + sizeof(u64)) to
ensure we can align the size later. However this means that we
actually allocate PAGE_SIZE * 2 buffer, seems too much.

Change this code to allocate PATH_MAX==PAGE_SIZE bytes, but tell
d_path() to not use the last sizeof(u64) bytes.

Note: it is not clear why do we need __GFP_ZERO, see the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131016201004.GC23214@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3ea5605..b409e75 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5113,17 +5113,18 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	if (file) {
 		struct inode *inode;
 		dev_t dev;
-		/*
-		 * d_path works from the end of the rb backwards, so we
-		 * need to add enough zero bytes after the string to handle
-		 * the 64bit alignment we do later.
-		 */
-		buf = kzalloc(PATH_MAX + sizeof(u64), GFP_KERNEL);
+
+		buf = kzalloc(PATH_MAX, GFP_KERNEL);
 		if (!buf) {
 			name = strncpy(tmp, "//enomem", sizeof(tmp));
 			goto got_name;
 		}
-		name = d_path(&file->f_path, buf, PATH_MAX);
+		/*
+		 * d_path() works from the end of the rb backwards, so we
+		 * need to add enough zero bytes after the string to handle
+		 * the 64bit alignment we do later.
+		 */
+		name = d_path(&file->f_path, buf, PATH_MAX - sizeof(u64));
 		if (IS_ERR(name)) {
 			name = strncpy(tmp, "//toolong", sizeof(tmp));
 			goto got_name;
