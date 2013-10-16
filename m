Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495Ab3JPRqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761305Ab3JPRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Colin Cross <ccross@google.com>
Subject: [ 25/69] cope with potentially long ->d_dname() output for shmem/hugetlb
Date: Wed, 16 Oct 2013 10:44:34 -0700
Message-Id: <20131016174315.970697646@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 118b23022512eb2f41ce42db70dc0568d00be4ba upstream.

dynamic_dname() is both too much and too little for those - the
output may be well in excess of 64 bytes dynamic_dname() assumes
to be enough (thanks to ashmem feeding really long names to
shmem_file_setup()) and vsnprintf() is an overkill for those
guys.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Colin Cross <ccross@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c            |   11 +++++++++++
 fs/hugetlbfs/inode.c   |    8 +-------
 include/linux/dcache.h |    1 +
 mm/shmem.c             |    8 +-------
 4 files changed, 14 insertions(+), 14 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2724,6 +2724,17 @@ char *dynamic_dname(struct dentry *dentr
 	return memcpy(buffer, temp, sz);
 }
 
+char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	char *end = buffer + buflen;
+	/* these dentries are never renamed, so d_lock is not needed */
+	if (prepend(&end, &buflen, " (deleted)", 11) ||
+	    prepend_name(&end, &buflen, &dentry->d_name) ||
+	    prepend(&end, &buflen, "/", 1))
+		end = ERR_PTR(-ENAMETOOLONG);
+	return end;
+}
+
 /*
  * Write full pathname from the root of the filesystem into the buffer.
  */
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -916,14 +916,8 @@ static int get_hstate_idx(int page_size_
 	return h - hstates;
 }
 
-static char *hugetlb_dname(struct dentry *dentry, char *buffer, int buflen)
-{
-	return dynamic_dname(dentry, buffer, buflen, "/%s (deleted)",
-				dentry->d_name.name);
-}
-
 static struct dentry_operations anon_ops = {
-	.d_dname = hugetlb_dname
+	.d_dname = simple_dname
 };
 
 /*
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -332,6 +332,7 @@ extern int d_validate(struct dentry *, s
  * helper function for dentry_operations.d_dname() members
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
+extern char *simple_dname(struct dentry *, char *, int);
 
 extern char *__d_path(const struct path *, const struct path *, char *, int);
 extern char *d_absolute_path(const struct path *, char *, int);
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2879,14 +2879,8 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
 /* common code */
 
-static char *shmem_dname(struct dentry *dentry, char *buffer, int buflen)
-{
-	return dynamic_dname(dentry, buffer, buflen, "/%s (deleted)",
-				dentry->d_name.name);
-}
-
 static struct dentry_operations anon_ops = {
-	.d_dname = shmem_dname
+	.d_dname = simple_dname
 };
 
 /**


