Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3KFNXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:23:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48931 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab3KFNUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:14 -0500
Date: Wed, 6 Nov 2013 05:19:42 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-c7e548b45ce85f765f6262149dd60d9956a31d60@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131017182417.GA17753@redhat.com>
References: <20131017182417.GA17753@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Factor out strncpy()
  in perf_event_mmap_event()
Git-Commit-ID: c7e548b45ce85f765f6262149dd60d9956a31d60
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:19:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7e548b45ce85f765f6262149dd60d9956a31d60
Gitweb:     http://git.kernel.org/tip/c7e548b45ce85f765f6262149dd60d9956a31d60
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 17 Oct 2013 20:24:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:28 +0100

perf: Factor out strncpy() in perf_event_mmap_event()

While this is really minor, but strncpy() does the unnecessary
zero-padding till the end of tmp[16] and it is called every time
we are going to use the string literal.

Turn these strncpy()'s into the single strlcpy() under the new
label, saves 72 bytes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131017182417.GA17753@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 17b3c6c..4dc078d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5144,8 +5144,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 
 		buf = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!buf) {
-			name = strncpy(tmp, "//enomem", sizeof(tmp));
-			goto got_name;
+			name = "//enomem";
+			goto cpy_name;
 		}
 		/*
 		 * d_path() works from the end of the rb backwards, so we
@@ -5154,8 +5154,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		 */
 		name = d_path(&file->f_path, buf, PATH_MAX - sizeof(u64));
 		if (IS_ERR(name)) {
-			name = strncpy(tmp, "//toolong", sizeof(tmp));
-			goto got_name;
+			name = "//toolong";
+			goto cpy_name;
 		}
 		inode = file_inode(vma->vm_file);
 		dev = inode->i_sb->s_dev;
@@ -5163,30 +5163,30 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		gen = inode->i_generation;
 		maj = MAJOR(dev);
 		min = MINOR(dev);
-
+		goto got_name;
 	} else {
 		name = (char *)arch_vma_name(vma);
-		if (name) {
-			name = strncpy(tmp, name, sizeof(tmp) - 1);
-			tmp[sizeof(tmp) - 1] = '\0';
-			goto got_name;
-		}
+		if (name)
+			goto cpy_name;
 
 		if (vma->vm_start <= vma->vm_mm->start_brk &&
 				vma->vm_end >= vma->vm_mm->brk) {
-			name = strncpy(tmp, "[heap]", sizeof(tmp));
-			goto got_name;
+			name = "[heap]";
+			goto cpy_name;
 		}
 		if (vma->vm_start <= vma->vm_mm->start_stack &&
 				vma->vm_end >= vma->vm_mm->start_stack) {
-			name = strncpy(tmp, "[stack]", sizeof(tmp));
-			goto got_name;
+			name = "[stack]";
+			goto cpy_name;
 		}
 
-		name = strncpy(tmp, "//anon", sizeof(tmp));
-		goto got_name;
+		name = "//anon";
+		goto cpy_name;
 	}
 
+cpy_name:
+	strlcpy(tmp, name, sizeof(tmp));
+	name = tmp;
 got_name:
 	/*
 	 * Since our buffer works in 8 byte units we need to align our string
