Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaKYLem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:34:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaKYKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 094/254] missing data dependency barrier in prepend_name()
Date: Tue, 25 Nov 2014 10:37:24 +0000
Message-Id: <1416912004-5928-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 6d13f69444bd3d4888e43f7756449748f5a98bad upstream.

AFAICS, prepend_name() is broken on SMP alpha.  Disclaimer: I don't have
SMP alpha boxen to reproduce it on.  However, it really looks like the race
is real.

CPU1: d_path() on /mnt/ramfs/<255-character>/foo
CPU2: mv /mnt/ramfs/<255-character> /mnt/ramfs/<63-character>

CPU2 does d_alloc(), which allocates an external name, stores the name there
including terminating NUL, does smp_wmb() and stores its address in
dentry->d_name.name.  It proceeds to d_add(dentry, NULL) and d_move()
old dentry over to that.  ->d_name.name value ends up in that dentry.

In the meanwhile, CPU1 gets to prepend_name() for that dentry.  It fetches
->d_name.name and ->d_name.len; the former ends up pointing to new name
(64-byte kmalloc'ed array), the latter - 255 (length of the old name).
Nothing to force the ordering there, and normally that would be OK, since we'd
run into the terminating NUL and stop.  Except that it's alpha, and we'd need
a data dependency barrier to guarantee that we see that store of NUL
__d_alloc() has done.  In a similar situation dentry_cmp() would survive; it
does explicit smp_read_barrier_depends() after fetching ->d_name.name.
prepend_name() doesn't and it risks walking past the end of kmalloc'ed object
and possibly oops due to taking a page fault in kernel mode.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/dcache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index e1308c5423ed..f9cec9d4dbe0 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2806,6 +2806,9 @@ static int prepend(char **buffer, int *buflen, const char *str, int namelen)
  * the beginning of the name. The sequence number check at the caller will
  * retry it again when a d_move() does happen. So any garbage in the buffer
  * due to mismatched pointer and length will be discarded.
+ *
+ * Data dependency barrier is needed to make sure that we see that terminating
+ * NUL.  Alpha strikes again, film at 11...
  */
 static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 {
@@ -2813,6 +2816,8 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 	u32 dlen = ACCESS_ONCE(name->len);
 	char *p;
 
+	smp_read_barrier_depends();
+
 	*buflen -= dlen + 1;
 	if (*buflen < 0)
 		return -ENAMETOOLONG;
-- 
2.1.0

