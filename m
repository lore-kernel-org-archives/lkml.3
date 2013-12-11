Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3LKW4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:56:19 -0500
Received: from fieldses.org ([174.143.236.118]:39025 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3LKW4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:56:18 -0500
Date: Wed, 11 Dec 2013 17:56:16 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [PATCH v3 1/6] locks: consolidate common code in the
 flock_to_posix_lock routines
Message-ID: <20131211225616.GA3483@fieldses.org>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
 <1386703055-22308-2-git-send-email-jlayton@redhat.com>
 <20131210212253.GC20831@fieldses.org>
 <20131210232204.GD20831@fieldses.org>
 <20131211061856.615c39ba@tlielax.poochiereds.net>
 <20131211143724.GA29300@fieldses.org>
 <20131211151931.GC29300@fieldses.org>
 <20131211140741.292028e8@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211140741.292028e8@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 02:07:41PM -0500, Jeff Layton wrote:
> On Wed, 11 Dec 2013 10:19:31 -0500
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
...
> > +	if (l->l_len > 0)
> > +		fl->fl_end = fl->fl_start + l->l_len - 1;
> > +	else if (l->l_len < 0) {
> > +		fl->fl_end = start - 1;
> 
> Erm... I think this is not quite right...
> 
> "start" is uninitialized here. I think this should be:
> 
>     fl->fl_end = fl->fl_start - 1
> 
> With that too, we can get rid of the local "start" variable. I think
> this may explain why I'm tripping over the BUG() in locks_remove_file.

Yep.

One other bug: I think l_start < 0 is actually fine in the
SEEK_CUR/SEEK_END cases.

With that fixed and another comment (though I don't know how much it
helps), it looks like the below.

--b.

commit 052f395880af17919d4c13037deed581f367b2a8
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Tue Dec 10 18:14:28 2013 -0500

    locks: fix posix lock range overflow handling
    
    In the 32-bit case fcntl assigns f_pos and i_size to a 32-bit off_t,
    with probably incorrect results.
    
    So instead let's return -EOVERFLOW as described in SUSv3, whenever "the
    smallest or, if l_len is non-zero, the largest offset of any byte in the
    requested segment cannot be represented correctly in an object of type
    off_t."
    
    While we're here, do some cleanup including consolidating code for the
    flock and flock64 cases.
    
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/fs/locks.c b/fs/locks.c
index 92a0f0a..39f2ca9 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -344,48 +344,42 @@ static int assign_type(struct file_lock *fl, long type)
 	return 0;
 }
 
-/* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
- * style lock.
- */
-static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
-			       struct flock *l)
+static int flock_to_posix_lock_common(struct file *filp, struct file_lock *fl,
+					struct flock64 *l, loff_t offset_max)
 {
-	off_t start, end;
-
 	switch (l->l_whence) {
 	case SEEK_SET:
-		start = 0;
+		fl->fl_start = 0;
 		break;
 	case SEEK_CUR:
-		start = filp->f_pos;
+		fl->fl_start = filp->f_pos;
 		break;
 	case SEEK_END:
-		start = i_size_read(file_inode(filp));
+		fl->fl_start = i_size_read(file_inode(filp));
 		break;
 	default:
 		return -EINVAL;
 	}
+	if (l->l_start > offset_max - fl->fl_start)
+		return -EOVERFLOW;
+	fl->fl_start += l->l_start;
+	if (fl->fl_start < 0)
+		return -EINVAL;
+	if (l->l_len > offset_max - fl->fl_start)
+		return -EOVERFLOW;
+	if (fl->fl_start + l->l_len < 0)
+		return -EINVAL;
 
 	/* POSIX-1996 leaves the case l->l_len < 0 undefined;
 	   POSIX-2001 defines it. */
-	start += l->l_start;
-	if (start < 0)
-		return -EINVAL;
-	fl->fl_end = OFFSET_MAX;
-	if (l->l_len > 0) {
-		end = start + l->l_len - 1;
-		fl->fl_end = end;
-	} else if (l->l_len < 0) {
-		end = start - 1;
-		fl->fl_end = end;
-		start += l->l_len;
-		if (start < 0)
-			return -EINVAL;
-	}
-	fl->fl_start = start;	/* we record the absolute position */
-	if (fl->fl_end < fl->fl_start)
-		return -EOVERFLOW;
-	
+	if (l->l_len > 0)
+		fl->fl_end = fl->fl_start + l->l_len - 1;
+	else if (l->l_len < 0) {
+		fl->fl_end = fl->fl_start - 1;
+		fl->fl_start += l->l_len;
+	} else
+		fl->fl_end = OFFSET_MAX;
+
 	fl->fl_owner = current->files;
 	fl->fl_pid = current->tgid;
 	fl->fl_file = filp;
@@ -396,50 +390,32 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
 	return assign_type(fl, l->l_type);
 }
 
+/* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
+ * style lock.
+ */
+static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
+			       struct flock *l)
+{
+	struct flock64 ll = {
+		.l_type = l->l_type,
+		.l_whence = l->l_whence,
+		.l_start = l->l_start,
+		.l_len = l->l_len,
+	};
+
+	/*
+	 * The use of OFFT_OFFSET_MAX here ensures we return -EOVERFLOW
+	 * if the start or end of the lock could not be represented as
+	 * an off_t, following SUSv3.
+	 */
+	return flock_to_posix_lock_common(filp, fl, &ll, OFFT_OFFSET_MAX);
+}
+
 #if BITS_PER_LONG == 32
 static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 				 struct flock64 *l)
 {
-	loff_t start;
-
-	switch (l->l_whence) {
-	case SEEK_SET:
-		start = 0;
-		break;
-	case SEEK_CUR:
-		start = filp->f_pos;
-		break;
-	case SEEK_END:
-		start = i_size_read(file_inode(filp));
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	start += l->l_start;
-	if (start < 0)
-		return -EINVAL;
-	fl->fl_end = OFFSET_MAX;
-	if (l->l_len > 0) {
-		fl->fl_end = start + l->l_len - 1;
-	} else if (l->l_len < 0) {
-		fl->fl_end = start - 1;
-		start += l->l_len;
-		if (start < 0)
-			return -EINVAL;
-	}
-	fl->fl_start = start;	/* we record the absolute position */
-	if (fl->fl_end < fl->fl_start)
-		return -EOVERFLOW;
-	
-	fl->fl_owner = current->files;
-	fl->fl_pid = current->tgid;
-	fl->fl_file = filp;
-	fl->fl_flags = FL_POSIX;
-	fl->fl_ops = NULL;
-	fl->fl_lmops = NULL;
-
-	return assign_type(fl, l->l_type);
+	return flock_to_posix_lock_common(filp, fl, l, OFFSET_MAX);
 }
 #endif
 
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 95e46c8..36025f7 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -186,8 +186,6 @@ struct flock {
 };
 #endif
 
-#ifndef CONFIG_64BIT
-
 #ifndef HAVE_ARCH_STRUCT_FLOCK64
 #ifndef __ARCH_FLOCK64_PAD
 #define __ARCH_FLOCK64_PAD
@@ -202,6 +200,5 @@ struct flock64 {
 	__ARCH_FLOCK64_PAD
 };
 #endif
-#endif /* !CONFIG_64BIT */
 
 #endif /* _ASM_GENERIC_FCNTL_H */
