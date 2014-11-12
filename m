Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaKLBWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:22:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaKLBWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:22:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.17 063/319] missing data dependency barrier in prepend_name()
Date: Wed, 12 Nov 2014 10:13:21 +0900
Message-Id: <20141112011003.020530437@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2810,6 +2810,9 @@ static int prepend(char **buffer, int *b
  * the beginning of the name. The sequence number check at the caller will
  * retry it again when a d_move() does happen. So any garbage in the buffer
  * due to mismatched pointer and length will be discarded.
+ *
+ * Data dependency barrier is needed to make sure that we see that terminating
+ * NUL.  Alpha strikes again, film at 11...
  */
 static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 {
@@ -2817,6 +2820,8 @@ static int prepend_name(char **buffer, i
 	u32 dlen = ACCESS_ONCE(name->len);
 	char *p;
 
+	smp_read_barrier_depends();
+
 	*buflen -= dlen + 1;
 	if (*buflen < 0)
 		return -ENAMETOOLONG;


