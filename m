Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3L2CXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:23:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55581 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab3L2CLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:09 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Pax Team" <pageexec@freemail.hu>,
        "Mathias Krause" <minipli@googlemail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Manfred Spraul" <manfred@colorfullife.com>,
        "Brad Spengler" <spender@grsecurity.net>,
        "Davidlohr Bueso" <davidlohr@hp.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.185607300@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 062/185] ipc, msg: fix message length check for
 negative values
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 4e9b45a19241354daec281d7a785739829b52359 upstream.

On 64 bit systems the test for negative message sizes is bogus as the
size, which may be positive when evaluated as a long, will get truncated
to an int when passed to load_msg().  So a long might very well contain a
positive value but when truncated to an int it would become negative.

That in combination with a small negative value of msg_ctlmax (which will
be promoted to an unsigned type for the comparison against msgsz, making
it a big positive value and therefore make it pass the check) will lead to
two problems: 1/ The kmalloc() call in alloc_msg() will allocate a too
small buffer as the addition of alen is effectively a subtraction.  2/ The
copy_from_user() call in load_msg() will first overflow the buffer with
userland data and then, when the userland access generates an access
violation, the fixup handler copy_user_handle_tail() will try to fill the
remainder with zeros -- roughly 4GB.  That almost instantly results in a
system crash or reset.

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

Fix the issue by preventing msgsz from getting truncated by consistently
using size_t for the message length.  This way the size checks in
do_msgsnd() could still be passed with a negative value for msg_ctlmax but
we would fail on the buffer allocation in that case and error out.

Also change the type of m_ts from int to size_t to avoid similar nastiness
in other code paths -- it is used in similar constructs, i.e.  signed vs.
unsigned checks.  It should never become negative under normal
circumstances, though.

Setting msg_ctlmax to a negative value is an odd configuration and should
be prevented.  As that might break existing userland, it will be handled
in a separate commit so it could easily be reverted and reworked without
reintroducing the above described bug.

Hardening mechanisms for user copy operations would have catched that bug
early -- e.g.  checking slab object sizes on user copy operations as the
usercopy feature of the PaX patch does.  Or, for that matter, detect the
long vs.  int sign change due to truncation, as the size overflow plugin
of the very same patch does.

[akpm@linux-foundation.org: fix i386 min() warnings]
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Pax Team <pageexec@freemail.hu>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - Drop changes to alloc_msg() and copy_msg(), which don't exist]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -76,9 +76,9 @@ struct msginfo {
 
 /* one msg_msg structure for each message */
 struct msg_msg {
-	struct list_head m_list; 
-	long  m_type;          
-	int m_ts;           /* message text size */
+	struct list_head m_list;
+	long m_type;
+	size_t m_ts;		/* message text size */
 	struct msg_msgseg* next;
 	void *security;
 	/* the actual message follows immediately */
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -37,15 +37,15 @@ struct msg_msgseg {
 	/* the next part of the message follows immediately */
 };
 
-#define DATALEN_MSG	(PAGE_SIZE-sizeof(struct msg_msg))
-#define DATALEN_SEG	(PAGE_SIZE-sizeof(struct msg_msgseg))
+#define DATALEN_MSG	((size_t)PAGE_SIZE-sizeof(struct msg_msg))
+#define DATALEN_SEG	((size_t)PAGE_SIZE-sizeof(struct msg_msgseg))
 
-struct msg_msg *load_msg(const void __user *src, int len)
+struct msg_msg *load_msg(const void __user *src, size_t len)
 {
 	struct msg_msg *msg;
 	struct msg_msgseg **pseg;
 	int err;
-	int alen;
+	size_t alen;
 
 	alen = len;
 	if (alen > DATALEN_MSG)
@@ -99,9 +99,9 @@ out_err:
 	return ERR_PTR(err);
 }
 
-int store_msg(void __user *dest, struct msg_msg *msg, int len)
+int store_msg(void __user *dest, struct msg_msg *msg, size_t len)
 {
-	int alen;
+	size_t alen;
 	struct msg_msgseg *seg;
 
 	alen = len;
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -138,8 +138,8 @@ int ipc_parse_version (int *cmd);
 #endif
 
 extern void free_msg(struct msg_msg *msg);
-extern struct msg_msg *load_msg(const void __user *src, int len);
-extern int store_msg(void __user *dest, struct msg_msg *msg, int len);
+extern struct msg_msg *load_msg(const void __user *src, size_t len);
+extern int store_msg(void __user *dest, struct msg_msg *msg, size_t len);
 
 extern void recompute_msgmni(struct ipc_namespace *);
 

