Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3IOR0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:26:55 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54278 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187Ab3IOR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:26:54 -0400
X-Nat-Received: from [202.181.97.72]:53952 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379266002.5645
To: oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309150910.CCE73459.VMOFtJFLSHOQFO@I-love.SAKURA.ne.jp>
	<201309152323.GDG73435.VLOQFHOJtOFFSM@I-love.SAKURA.ne.jp>
	<20130915163157.GB13344@redhat.com>
	<201309160202.FBC60981.FQOHSLFMFtOJVO@I-love.SAKURA.ne.jp>
	<20130915171549.GA15346@redhat.com>
In-Reply-To: <20130915171549.GA15346@redhat.com>
Message-Id: <201309160226.DGH90134.QLSFtOJOOMFHVF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 16 Sep 2013 02:26:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 15092013 #11084683, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d6ff218545060c5f8b75b15d5b34bffcf625508f Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 16 Sep 2013 02:19:10 +0900
Subject: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().

If /proc/sys/kernel/core_pattern contains only "|", NULL pointer dereference
happens upon core dump because argv_split("") returns argv[0] == NULL.

This bug was once fixed by commit 264b83c0 "usermodehelper: check
subprocess_info->path != NULL" but was by error reintroduced by commit
7f57cfa4 "usermodehelper: kill the sub_info->path[0] check".

This bug seems to exist since 2.6.19 (the version which core dump to pipe was
added). Depending on kernel version and config, some side effect might happen
immediately after this oops (e.g. kernel panic with 2.6.32-358.18.1.el6).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index fb32636..a962470 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -571,6 +571,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	if (!sub_info->path) {
+		call_usermodehelper_freeinfo(sub_info);
+		return -ENOENT;
+	}
 	helper_lock();
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
-- 
1.7.1
