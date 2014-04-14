Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaDNQC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:02:58 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44539 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaDNQC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:02:56 -0400
From: Masami Ichikawa <masami256@gmail.com>
To: keescook@chromium.org, davem@davemloft.net, josh@joshtriplett.org,
        eparis@redhat.com, rashika.kheria@gmail.com, ast@plumgrid.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: masami256@gmail.com
Subject: [PATCH] seccomp: Release fp pointer when leaving from seccomp_attach_filter().
Date: Tue, 15 Apr 2014 01:02:13 +0900
Message-Id: <1397491333-13746-1-git-send-email-masami256@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak reported some memory leak as below.

unreferenced object 0xffff8800d6ea4000 (size 512):
  comm "sshd", pid 278, jiffies 4294898315 (age 46.653s)
  hex dump (first 32 bytes):
    21 00 00 00 04 00 00 00 15 00 01 00 3e 00 00 c0  !...........>...
    06 00 00 00 00 00 00 00 21 00 00 00 00 00 00 00  ........!.......
  backtrace:
    [<ffffffff8151414e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811a3a40>] __kmalloc+0x280/0x320
    [<ffffffff8110842e>] prctl_set_seccomp+0x11e/0x3b0
    [<ffffffff8107bb6b>] SyS_prctl+0x3bb/0x4a0
    [<ffffffff8152ef2d>] system_call_fastpath+0x1a/0x1f
    [<ffffffffffffffff>] 0xffffffffffffffff

This memory leak happend in seccomp_attach_filter().
The fp pointer was allocated via kzalloc so that it needs to realase memory
when leaving from function.

This patch changed two things.
One is set -ENOMEM to ret, if fp is unable to get memory.
The other is removes "return 0" statement, and frees fp pointer before
leaving.

Signed-off-by: Masami Ichikawa <masami256@gmail.com>
---
 kernel/seccomp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index d8d046c..a9ce7a9 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -259,8 +259,10 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	filter = kzalloc(sizeof(struct seccomp_filter) +
 			 sizeof(struct sock_filter_int) * new_len,
 			 GFP_KERNEL|__GFP_NOWARN);
-	if (!filter)
+	if (!filter) {
+		ret = -ENOMEM;
 		goto free_prog;
+	}
 
 	ret = sk_convert_filter(fp, fprog->len, filter->insnsi, &new_len);
 	if (ret)
@@ -275,10 +277,10 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	 */
 	filter->prev = current->seccomp.filter;
 	current->seccomp.filter = filter;
-	return 0;
 
 free_filter:
-	kfree(filter);
+	if (ret)
+		kfree(filter);
 free_prog:
 	kfree(fp);
 	return ret;
-- 
1.9.1

