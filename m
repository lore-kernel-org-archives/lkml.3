Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3IOOXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 10:23:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62053 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3IOOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 10:23:48 -0400
X-Nat-Received: from [202.181.97.72]:59291 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379255014.3234
To: oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309141632.GHD86439.VLOOOFQFJtSMFH@I-love.SAKURA.ne.jp>
	<20130914154144.GA7884@redhat.com>
	<201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp>
Message-Id: <201309152323.GDG73435.VLOQFHOJtOFFSM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 15 Sep 2013 23:23:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 15092013 #11084683, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fe6723ba2816b42e26697472a3f2a3045614032b Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 15 Sep 2013 23:17:15 +0900
Subject: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().

If /proc/sys/kernel/core_pattern contains only "|", NULL pointer dereference
happens upon core dump because argv_split("") returns argv[0] == NULL.

This bug seems to exist since 2.6.19 (the version which core dump to pipe was
added). Depending on kernel version and config, some side effect might happen
immediately after this oops (e.g. kernel panic with 2.6.32-358.18.1.el6).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/kmod.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index fb32636..3b59f6e 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -572,6 +572,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	int retval = 0;
 
 	helper_lock();
+	if (!sub_info->path) {
+		retval = -ENOENT;
+		goto out;
+	}
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
 		goto out;
-- 
1.7.1
