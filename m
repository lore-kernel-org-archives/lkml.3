Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3IWVMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:12:54 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58686 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab3IWVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:12:53 -0400
X-Nat-Received: from [202.181.97.72]:60097 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379970759.15244
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, viro@zeniv.linux.org.uk, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] kmod: Check for NULL at call_usermodehelper_exec().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309152323.GDG73435.VLOQFHOJtOFFSM@I-love.SAKURA.ne.jp>
	<20130915163157.GB13344@redhat.com>
	<201309160202.FBC60981.FQOHSLFMFtOJVO@I-love.SAKURA.ne.jp>
	<20130915171549.GA15346@redhat.com>
	<201309160226.DGH90134.QLSFtOJOOMFHVF@I-love.SAKURA.ne.jp>
In-Reply-To: <201309160226.DGH90134.QLSFtOJOOMFHVF@I-love.SAKURA.ne.jp>
Message-Id: <201309240612.ADE82877.MSFHVtOOFLFOQJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 24 Sep 2013 06:12:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 23092013 #11062479, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, would you pick up this patch?

Regards.
----------
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
