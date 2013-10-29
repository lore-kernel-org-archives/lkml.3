Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3J2OJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:09:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45936 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3J2OJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:09:01 -0400
Date: Tue, 29 Oct 2013 07:08:26 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8jirlm99m6if2z13wd6rbyu6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Change zero-padding of strings in perf_event_mmap_event()
Git-Commit-ID: 2c42cfbfe10872929c2ba1f8130e31063ff59b94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:08:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c42cfbfe10872929c2ba1f8130e31063ff59b94
Gitweb:     http://git.kernel.org/tip/2c42cfbfe10872929c2ba1f8130e31063ff59b94
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 17 Oct 2013 00:06:46 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:53 +0100

perf: Change zero-padding of strings in perf_event_mmap_event()

Oleg complained about the excessive 0-ing in perf_event_mmap_event(),
so try and be smarter about it while keeping it fairly fool proof and
avoid leaking random bits out to userspace.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-8jirlm99m6if2z13wd6rbyu6@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b409e75..85a8bbd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5106,15 +5106,13 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
-	const char *name;
-
-	memset(tmp, 0, sizeof(tmp));
+	char *name;
 
 	if (file) {
 		struct inode *inode;
 		dev_t dev;
 
-		buf = kzalloc(PATH_MAX, GFP_KERNEL);
+		buf = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!buf) {
 			name = strncpy(tmp, "//enomem", sizeof(tmp));
 			goto got_name;
@@ -5137,7 +5135,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		min = MINOR(dev);
 
 	} else {
-		name = arch_vma_name(vma);
+		name = (char *)arch_vma_name(vma);
 		if (name) {
 			name = strncpy(tmp, name, sizeof(tmp) - 1);
 			tmp[sizeof(tmp) - 1] = '\0';
@@ -5160,7 +5158,14 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	}
 
 got_name:
-	size = ALIGN(strlen(name)+1, sizeof(u64));
+	/*
+	 * Since our buffer works in 8 byte units we need to align our string
+	 * size to a multiple of 8. However, we must guarantee the tail end is
+	 * zero'd out to avoid leaking random bits to userspace.
+	 */
+	size = strlen(name)+1;
+	while (!IS_ALIGNED(size, sizeof(u64)))
+		name[size++] = '\0';
 
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;
