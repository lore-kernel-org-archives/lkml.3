Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaBCCDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 21:03:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaBCCDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 21:03:52 -0500
Date: Sun, 2 Feb 2014 18:03:36 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-507h7cq5e45eg6ygtykon3bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, toyoa@mvista.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, toyoa@mvista.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] compat: Fix sparse address space warnings
Git-Commit-ID: dce44e03b0a3448ad11ac6c6e0cbe299e0400791
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 18:03:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dce44e03b0a3448ad11ac6c6e0cbe299e0400791
Gitweb:     http://git.kernel.org/tip/dce44e03b0a3448ad11ac6c6e0cbe299e0400791
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sun, 2 Feb 2014 17:57:28 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 2 Feb 2014 18:00:29 -0800

compat: Fix sparse address space warnings

In compat_sys_old_getrlimit() we pass a kernel pointer to
sys_old_getrlimit() inside a set_fs() bracket.  This is okay, so we
can safely cast the affected pointer to __user.

In compat_clock_nanosleep_restart(), the variable "rmtp" holds a user
pointer.  Annotate it as such.

Both of these warnings are ancient, but were reported by Fengguang
Wu's test system due to other changes.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Toyo Abe <toyoa@mvista.com>
Link: http://lkml.kernel.org/n/tip-507h7cq5e45eg6ygtykon3bf@git.kernel.org
---
 kernel/compat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/compat.c b/kernel/compat.c
index 3afc524..7076b57 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -451,7 +451,7 @@ asmlinkage long compat_sys_old_getrlimit(unsigned int resource,
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	ret = sys_old_getrlimit(resource, &r);
+	ret = sys_old_getrlimit(resource, (struct rlimit __user *)&r);
 	set_fs(old_fs);
 
 	if (!ret) {
@@ -799,7 +799,7 @@ static long compat_clock_nanosleep_restart(struct restart_block *restart)
 	long err;
 	mm_segment_t oldfs;
 	struct timespec tu;
-	struct compat_timespec *rmtp = restart->nanosleep.compat_rmtp;
+	struct compat_timespec __user *rmtp = restart->nanosleep.compat_rmtp;
 
 	restart->nanosleep.rmtp = (struct timespec __user *) &tu;
 	oldfs = get_fs();
