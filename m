Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaGKKBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:01:20 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43528 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaGKKBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:01:19 -0400
From: Silesh C V <svellattu@mvista.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Silesh C V <svellattu@mvista.com>, Oleg Nesterov <oleg@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH] coredump: Fix the setting of PF_DUMPCORE
Date: Fri, 11 Jul 2014 15:30:39 +0530
Message-Id: <1405072839-4137-1-git-send-email-svellattu@mvista.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 079148b91 (coredump: factor out the setting of PF_DUMPCORE)
cleaned up the setting of PF_DUMPCORE by removing it from all the
linux_binfmt->core_dump() and moving it to zap_threads().But this
ended up clearing all the previously set flags. This causes issues
during core generation when tsk->flags is checked again
(eg. for PF_USED_MATH to dump floating point registers). Fix this.

Signed-off-by: Silesh C V <svellattu@mvista.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>

---
 fs/coredump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 0b2528f..a93f7e6 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -306,7 +306,7 @@ static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
 	if (unlikely(nr < 0))
 		return nr;
 
-	tsk->flags = PF_DUMPCORE;
+	tsk->flags |= PF_DUMPCORE;
 	if (atomic_read(&mm->mm_users) == nr + 1)
 		goto done;
 	/*
-- 
1.8.1.2

