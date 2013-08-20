Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab3HTOEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:04:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54476 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3HTOEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:04:53 -0400
Date: Tue, 20 Aug 2013 15:04:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arun KS <arunks.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
        Bruce Fields <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Subject: Re: [PATCH v1] seq_file: Fix overflow condition in seq_commit
Message-ID: <20130820140447.GL27005@ZenIV.linux.org.uk>
References: <CAKZGPANQz5-uyf=uSp_0HxBq1_uH053H0XOohpAaWsbeoy7zhw@mail.gmail.com>
 <20130820055153.GH27005@ZenIV.linux.org.uk>
 <CAKZGPAN3W_FFHcxnatFJNQ9VDt-TL9c2Wyddqvdz98612U4gzQ@mail.gmail.com>
 <20130820073622.GK27005@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820073622.GK27005@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:36:22AM +0100, Al Viro wrote:

> Aha.  _That_ is a bug, all right - dynamic_dname() is simply not suitable
> for that kind of uses.  ashmem.c is certainly abusing shmem_file_setup();
> feeding that kind of mess as dentry name is a Bad Idea(tm).  Anyway,
> I'd suggest this for a fix:
> 
> 	va_list args;
> 	size_t sz;
> 	va_start(args, fmt);
> 	sz = vsnprintf(NULL, 0, fmt, args) + 1;
> 	va_end(args);
> 	if (sz > buflen)
> 		return ERR_PTR(-ENAMETOOLONG);
> 	va_start(args, fmt);
> 	buffer += buflen - sz;
> 	vsprintf(buffer, fmt, args);
> 	va_end(args);
> 	return buffer;
> 
> Either right in dynamic_dname(), or as possibly_fucking_long_dname(),
> to be used by shmem.c...

Actually, looking at the users of dynamic_dname()...  Most of them are
fine with dynamic_dname() as it is, with 2 possible exceptions:
hugetlb_dname() and shmem_dname().  Both are using "/%s (deleted)",
dentry->d_name.name as format...  So the solution above may very
well be an overkill; something like

char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
{
	char *end = buffer + buflen;
	/* these dentries are never renamed, so d_lock is not needed */
	if (prepend(&end, &buflen, " (deleted)", 11) ||
	    prepend_name(&end, &buflen, &dentry->d_name) ||
	    prepend(&end, &buflen, "/", 1))
		end = ERR_PTR(-ENAMETOOLONG);
	return end;
}

will do for those two.  Care to test the diff below?

cope with potentially long ->d_dname() output for shmem/hugetlb

dynamic_dname() is both too much and too little for those - the
output may be well in excess of 64 bytes dynamic_dname() assumes
to be enough (thanks to ashmem feeding really long names to
shmem_file_setup()) and vsnprintf() is an overkill for those
guys.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/dcache.c b/fs/dcache.c
index 87bdb53..83cfb83 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2724,6 +2724,17 @@ char *dynamic_dname(struct dentry *dentry, char *buffer, int buflen,
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
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index a3f868a..4e5f332 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -916,14 +916,8 @@ static int get_hstate_idx(int page_size_log)
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
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index b90337c..4a12532 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -336,6 +336,7 @@ extern int d_validate(struct dentry *, struct dentry *);
  * helper function for dentry_operations.d_dname() members
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
+extern char *simple_dname(struct dentry *, char *, int);
 
 extern char *__d_path(const struct path *, const struct path *, char *, int);
 extern char *d_absolute_path(const struct path *, char *, int);
diff --git a/mm/shmem.c b/mm/shmem.c
index 8335dbd..e43dc55 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2909,14 +2909,8 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
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
