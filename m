Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbaELC2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:28:21 -0400
Received: from 1wt.eu ([62.212.114.60]:34331 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaELBl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:27 -0400
Message-Id: <20140512003200.969215034@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 008/143] kernel/kmod.c: check for NULL in call_usermodehelper_exec()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

If /proc/sys/kernel/core_pattern contains only "|", a NULL pointer
dereference happens upon core dump because argv_split("") returns
argv[0] == NULL.

This bug was once fixed by commit 264b83c07a84 ("usermodehelper: check
subprocess_info->path != NULL") but was by error reintroduced by commit
7f57cfa4e2aa ("usermodehelper: kill the sub_info->path[0] check").

This bug seems to exist since 2.6.19 (the version which core dump to
pipe was added).  Depending on kernel version and config, some side
effect might happen immediately after this oops (e.g.  kernel panic with
2.6.32-358.18.1.el6).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 4c1c7be95c345cf2ad537a0c48e9aeadc7304527)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/kmod.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 8ecc509..3da09a9 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -560,6 +560,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
 	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
 	validate_creds(sub_info->cred);
 
+	if (!sub_info->path) {
+		call_usermodehelper_freeinfo(sub_info);
+		return -EINVAL;
+	}
 	helper_lock();
 	if (sub_info->path[0] == '\0')
 		goto out;
-- 
1.7.12.2.21.g234cd45.dirty



