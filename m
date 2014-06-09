Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbaFIJME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:12:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58438 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754877AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 020/146] coredump: fix va_list corruption
Date: Mon,  9 Jun 2014 10:49:15 +0200
Message-Id: <059224c7436395da17cff18b2a9ed67ced0a9353.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/coredump.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 9bdeca12ae0e..02db009d1531 100644
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
1.9.3

