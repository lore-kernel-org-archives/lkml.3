Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab3LJIeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:34:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3LJIAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:00:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Kirby <sim@hostway.ca>, Ian Applegate <ia@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 17/52] vfs: fix subtle use-after-free of pipe_inode_info
Date: Tue, 10 Dec 2013 00:00:50 -0800
Message-Id: <20131210075955.417751046@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit b0d8d2292160bb63de1972361ebed100c64b5b37 upstream.

The pipe code was trying (and failing) to be very careful about freeing
the pipe info only after the last access, with a pattern like:

        spin_lock(&inode->i_lock);
        if (!--pipe->files) {
                inode->i_pipe = NULL;
                kill = 1;
        }
        spin_unlock(&inode->i_lock);
        __pipe_unlock(pipe);
        if (kill)
                free_pipe_info(pipe);

where the final freeing is done last.

HOWEVER.  The above is actually broken, because while the freeing is
done at the end, if we have two racing processes releasing the pipe
inode info, the one that *doesn't* free it will decrement the ->files
count, and unlock the inode i_lock, but then still use the
"pipe_inode_info" afterwards when it does the "__pipe_unlock(pipe)".

This is *very* hard to trigger in practice, since the race window is
very small, and adding debug options seems to just hide it by slowing
things down.

Simon originally reported this way back in July as an Oops in
kmem_cache_allocate due to a single bit corruption (due to the final
"spin_unlock(pipe->mutex.wait_lock)" incrementing a field in a different
allocation that had re-used the free'd pipe-info), it's taken this long
to figure out.

Since the 'pipe->files' accesses aren't even protected by the pipe lock
(we very much use the inode lock for that), the simple solution is to
just drop the pipe lock early.  And since there were two users of this
pattern, create a helper function for it.

Introduced commit ba5bb147330a ("pipe: take allocation and freeing of
pipe_inode_info out of ->i_mutex").

Reported-by: Simon Kirby <sim@hostway.ca>
Reported-by: Ian Applegate <ia@cloudflare.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pipe.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -726,11 +726,25 @@ pipe_poll(struct file *filp, poll_table
 	return mask;
 }
 
+static void put_pipe_info(struct inode *inode, struct pipe_inode_info *pipe)
+{
+	int kill = 0;
+
+	spin_lock(&inode->i_lock);
+	if (!--pipe->files) {
+		inode->i_pipe = NULL;
+		kill = 1;
+	}
+	spin_unlock(&inode->i_lock);
+
+	if (kill)
+		free_pipe_info(pipe);
+}
+
 static int
 pipe_release(struct inode *inode, struct file *file)
 {
-	struct pipe_inode_info *pipe = inode->i_pipe;
-	int kill = 0;
+	struct pipe_inode_info *pipe = file->private_data;
 
 	__pipe_lock(pipe);
 	if (file->f_mode & FMODE_READ)
@@ -743,17 +757,9 @@ pipe_release(struct inode *inode, struct
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
-	spin_lock(&inode->i_lock);
-	if (!--pipe->files) {
-		inode->i_pipe = NULL;
-		kill = 1;
-	}
-	spin_unlock(&inode->i_lock);
 	__pipe_unlock(pipe);
 
-	if (kill)
-		free_pipe_info(pipe);
-
+	put_pipe_info(inode, pipe);
 	return 0;
 }
 
@@ -1014,7 +1020,6 @@ static int fifo_open(struct inode *inode
 {
 	struct pipe_inode_info *pipe;
 	bool is_pipe = inode->i_sb->s_magic == PIPEFS_MAGIC;
-	int kill = 0;
 	int ret;
 
 	filp->f_version = 0;
@@ -1130,15 +1135,9 @@ err_wr:
 	goto err;
 
 err:
-	spin_lock(&inode->i_lock);
-	if (!--pipe->files) {
-		inode->i_pipe = NULL;
-		kill = 1;
-	}
-	spin_unlock(&inode->i_lock);
 	__pipe_unlock(pipe);
-	if (kill)
-		free_pipe_info(pipe);
+
+	put_pipe_info(inode, pipe);
 	return ret;
 }
 


