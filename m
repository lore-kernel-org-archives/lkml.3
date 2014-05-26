Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaEZNmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:42:15 -0400
Received: from numidia.opendz.org ([98.142.220.152]:55216 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaEZNmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:42:14 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 1/9] procfs: use flags to deny or allow access to /proc/<pid>/$entry
Date: Mon, 26 May 2014 14:27:22 +0100
Message-Id: <1401110850-3552-2-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the deny or allow flags, so we can perform proper permission checks
and set the result accordingly. These flags are needed in case we have
to cache the result of permission checks that are done during ->open()
time. Later during ->read(), we can decide to allow or deny the read().

The pid entries that need these flags are:
/proc/<pid>/stat
/proc/<pid>/wchan
/proc/<pid>/maps  (will be handled in next patches).

These files are world readable, userspace depend on that. To prevent
ASLR leaks and to avoid breaking userspace, we follow this scheme:

a) Perform permission checks during ->open()
b) Cache the result of a) and return success
c) Recheck the cached result during ->read()
d) If cached == PID_ENTRY_DENY:
   then we replace the sensitive fields with zeros, userspace won't
   break and sensitive fields are protected.

These flags are internal to /proc/<pid>/*

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/internal.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 3ab6d14..e696284 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -19,6 +19,15 @@ struct ctl_table_header;
 struct mempolicy;
 
 /*
+ * Flags used to deny or allow current to access /proc/<pid>/$entry
+ * after proper permission checks.
+ */
+enum {
+	PID_ENTRY_DENY	= 0,	/* Deny access */
+	PID_ENTRY_ALLOW	= 1,	/* Allow access */
+};
+
+/*
  * This is not completely implemented yet. The idea is to
  * create an in-memory tree (like the actual /proc filesystem
  * tree) of these proc_dir_entries, so that we can dynamically
-- 
1.7.11.7

