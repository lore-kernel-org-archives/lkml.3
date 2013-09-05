Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763425Ab3IEMiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:38:51 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47208 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762579Ab3IEMis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:38:48 -0400
Date: Thu, 5 Sep 2013 14:39:11 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 04/11] vfs: check unlinked ancestors before mount
Message-ID: <20130905123911.GA25538@tucsk.piliscsaba.szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
 <1378374284-1484-5-git-send-email-miklos@szeredi.hu>
 <20130905111852.GP13318@ZenIV.linux.org.uk>
 <CAJfpeguzpkw3SYm6kBP-acLSHTgYLXMFRZDf2T0U4aowYhfQdA@mail.gmail.com>
 <20130905120230.GA21170@tucsk.piliscsaba.szeredi.hu>
 <CAJfpegtXQebPEQqw8ESmM-Bp0QgCefmRwoNeJNtN-_bV35b-pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtXQebPEQqw8ESmM-Bp0QgCefmRwoNeJNtN-_bV35b-pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one actually has a slight chance of working.

Thanks,
Miklos

---
Subject: vfs: check unlinked ancestors before mount
From: Miklos Szeredi <mszeredi@suse.cz>

We check submounts before doing d_drop() on a non-empty directory dentry in
NFS (have_submounts()), but we do not exclude a racing mount.  Nor do we
prevent mounts to be added to the disconnected subtree using relative paths
after the d_drop().

This patch fixes these issues by checking for unlinked (unhashed, non-root)
ancestors before proceeding with the mount.  This is done after setting
DCACHE_MOUNTED on the soon-to-be mountpoint and with the rename seqlock
taken for write.  This ensures that the only one of
check_submounts_and_drop() or has_unlinked_ancestor() can succeed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: David Howells <dhowells@redhat.com>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dcache.c    |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/internal.h  |    1 +
 fs/namespace.c |   11 +++++------
 3 files changed, 58 insertions(+), 6 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1159,6 +1159,58 @@ int have_submounts(struct dentry *parent
 }
 EXPORT_SYMBOL(have_submounts);
 
+static bool __has_unlinked_ancestor(struct dentry *dentry)
+{
+	struct dentry *this;
+
+	for (this = dentry; !IS_ROOT(this); this = this->d_parent) {
+		int is_unhashed;
+
+		/* Need exclusion wrt. check_submounts_and_drop() */
+		spin_lock(&this->d_lock);
+		is_unhashed = d_unhashed(this);
+		spin_unlock(&this->d_lock);
+
+		if (is_unhashed)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * Called by mount code to set a mountpoint and check if the mountpoint is
+ * reachable (e.g. NFS can unhash a directory dentry and then the complete
+ * subtree can become unreachable).
+ *
+ * Only one of check_submounts_and_drop() and d_set_mounted() must succeed.  For
+ * this reason take rename_lock and d_lock on dentry and ancestors.
+ */
+int d_set_mounted(struct dentry *dentry)
+{
+	int ret = -ENOENT;
+
+	write_seqlock(&rename_lock);
+	spin_lock(&dentry->d_lock);
+	if (d_unlinked(dentry)) {
+		spin_unlock(&dentry->d_lock);
+		goto out;
+	}
+
+	dentry->d_flags |= DCACHE_MOUNTED;
+	spin_unlock(&dentry->d_lock);
+
+	if (__has_unlinked_ancestor(dentry->d_parent)) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags &= ~DCACHE_MOUNTED;
+		spin_unlock(&dentry->d_lock);
+		goto out;
+	}
+	ret = 0;
+out:
+	write_sequnlock(&rename_lock);
+	return ret;
+}
+
 /*
  * Search the dentry child list of the specified parent,
  * and move any unused dentries to the end of the unused
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -126,6 +126,7 @@ extern int invalidate_inodes(struct supe
  * dcache.c
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
+extern int d_set_mounted(struct dentry *dentry);
 
 /*
  * read_write.c
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -611,6 +611,7 @@ static struct mountpoint *new_mountpoint
 {
 	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
 	struct mountpoint *mp;
+	int ret;
 
 	list_for_each_entry(mp, chain, m_hash) {
 		if (mp->m_dentry == dentry) {
@@ -626,14 +627,12 @@ static struct mountpoint *new_mountpoint
 	if (!mp)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock(&dentry->d_lock);
-	if (d_unlinked(dentry)) {
-		spin_unlock(&dentry->d_lock);
+	ret = d_set_mounted(dentry);
+	if (ret) {
 		kfree(mp);
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(ret);
 	}
-	dentry->d_flags |= DCACHE_MOUNTED;
-	spin_unlock(&dentry->d_lock);
+
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
 	list_add(&mp->m_hash, chain);
