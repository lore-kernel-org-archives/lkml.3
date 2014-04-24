Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaDXJGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:06:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaDXI4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Neil Horman <nhorman@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 175/182] coredump: fix va_list corruption
Date: Thu, 24 Apr 2014 09:51:40 +0100
Message-Id: <1398329507-5911-176-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 404ca80eb5c2727d78cd517d12108b040c522e12 upstream.

A va_list needs to be copied in case it needs to be used twice.

Thanks to Hugh for debugging this issue, leading to various panics.

Tested:

  lpq84:~# echo "|/foobar12345 %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h" >/proc/sys/kernel/core_pattern

'produce_core' is simply : main() { *(int *)0 = 1;}

  lpq84:~# ./produce_core
  Segmentation fault (core dumped)
  lpq84:~# dmesg | tail -1
  [  614.352947] Core dump to |/foobar12345 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 (null) pipe failed

Notice the last argument was replaced by a NULL (we were lucky enough to
not crash, but do not try this on your production machine !)

After fix :

  lpq83:~# echo "|/foobar12345 %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h" >/proc/sys/kernel/core_pattern
  lpq83:~# ./produce_core
  Segmentation fault
  lpq83:~# dmesg | tail -1
  [  740.800441] Core dump to |/foobar12345 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 pipe failed

Fixes: 5fe9d8ca21cc ("coredump: cn_vprintf() has no reason to call vsnprintf() twice")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Diagnosed-by: Hugh Dickins <hughd@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/coredump.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 72f816d..729a2ed 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -74,10 +74,15 @@ static int expand_corename(struct core_name *cn, int size)
 static int cn_vprintf(struct core_name *cn, const char *fmt, va_list arg)
 {
 	int free, need;
+	va_list arg_copy;
 
 again:
 	free = cn->size - cn->used;
-	need = vsnprintf(cn->corename + cn->used, free, fmt, arg);
+
+	va_copy(arg_copy, arg);
+	need = vsnprintf(cn->corename + cn->used, free, fmt, arg_copy);
+	va_end(arg_copy);
+
 	if (need < free) {
 		cn->used += need;
 		return 0;
-- 
1.9.1

