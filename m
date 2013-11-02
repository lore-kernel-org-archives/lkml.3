Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3KBV2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 17:28:23 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:64671 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3KBV1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 17:27:44 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Pax Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/2] ipc, msg: fix message length check for negative values
Date: Sat,  2 Nov 2013 22:26:38 +0100
Message-Id: <1383427599-1980-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1383427599-1980-1-git-send-email-minipli@googlemail.com>
References: <1383427599-1980-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit systems the test for negative message sizes is bogus as the
size, which may be positive when evaluated as a long, will get truncated
to an int when passed to load_msg(). So a long might very well contain a
positive value but when truncated to an int it would become negative.

That in combination with a small negative value of msg_ctlmax (which will
be promoted to an unsigned type for the comparison against msgsz, making
it a big positive value and therefore make it pass the check) will lead
to two problems: 1/ The kmalloc() call in alloc_msg() will allocate a
too small buffer as the addition of alen is effectively a subtraction.
2/ The copy_from_user() call in load_msg() will first overflow the
buffer with userland data and then, when the userland access generates
an access violation, the fixup handler copy_user_handle_tail() will try
to fill the remainder with zeros -- roughly 4GB. That almost instantly
results in a system crash or reset.

,-[ Reproducer (needs to be run as root) ]--
| #include <sys/stat.h>
| #include <sys/msg.h>
| #include <unistd.h>
| #include <fcntl.h>
|
| int main(void) {
|     long msg = 1;
|     int fd;
|
|     fd = open("/proc/sys/kernel/msgmax", O_WRONLY);
|     write(fd, "-1", 2);
|     close(fd);
|
|     msgsnd(0, &msg, 0xfffffff0, IPC_NOWAIT);
|
|     return 0;
| }
'---

Fix the issue by checking for negative values the way they're used by
casting msgsz to int.

Hardening mechanisms for user copy operations would have catched that
bug early -- e.g. checking slab object sizes on user copy operations as
the usercopy feature of the PaX patch does. Or, for that matter, detect
the long vs. int sign change due to truncation, as the size overflow
plugin of the very same patch does.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pax Team <pageexec@freemail.hu>
Cc: <stable@vger.kernel.org>	# v2.3.27+ -- yes, that old ;)
---
 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 558aa91..d139b1e 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -667,7 +667,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 
 	ns = current->nsproxy->ipc_ns;
 
-	if (msgsz > ns->msg_ctlmax || (long) msgsz < 0 || msqid < 0)
+	if (msgsz > ns->msg_ctlmax || (int) msgsz < 0 || msqid < 0)
 		return -EINVAL;
 	if (mtype < 1)
 		return -EINVAL;
-- 
1.7.10.4

