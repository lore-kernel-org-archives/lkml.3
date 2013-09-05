Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581Ab3IEMCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:02:11 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38824 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3IEMCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:02:08 -0400
Date: Thu, 5 Sep 2013 14:02:30 +0200
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
Message-ID: <20130905120230.GA21170@tucsk.piliscsaba.szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
 <1378374284-1484-5-git-send-email-miklos@szeredi.hu>
 <20130905111852.GP13318@ZenIV.linux.org.uk>
 <CAJfpeguzpkw3SYm6kBP-acLSHTgYLXMFRZDf2T0U4aowYhfQdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguzpkw3SYm6kBP-acLSHTgYLXMFRZDf2T0U4aowYhfQdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 01:32:10PM +0200, Miklos Szeredi wrote:
> On Thu, Sep 5, 2013 at 1:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:

> > Something's really odd with locking here.  You are take d_lock, do one
> > check, set flag, drop d_lock, grab rename_lock, do another check (taking
> > and dropping d_lock in process), and, in case that check fails, grab
> > d_lock again to clear the flag.
> >
> > At the very least it's a massive overkill.  Just grab rename_lock, then
> > d_lock, then do the damn check and set the flag only on success.  Moreover,
> > with rename_lock held, do you need d_lock on ancestors to mess with in
> > has_unlinked_ancestor()?
> 
> Yes, we need hard exclusion for the __d_drop() part.  rename_lock can
> provide one if we always take it for write in
> check_submounts_and_drop().  But if we only take it for read then
> that's not enough.
> 
> And we do in fact also need DCACHE_MOUNTED set *before* checking
> ancestors.  Otherwise check_submounts_and_drop() could succeed and
> has_unlinked_ancestor() return false, resulting in a dropped dentry
> and a mount below it.  Though this is mostly theoretical at this
> point.

Maybe something like this.  Has less ugly locking.  Untested.

Thanks,
Miklos


---
 fs/dcache.c    |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/internal.h  |    1 +
 fs/namespace.c |   11 +++++------
 3 files changed, 55 insertions(+), 6 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1159,6 +1159,55 @@ int have_submounts(struct dentry *parent
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
+ * Called by mount code to check if the mountpoint is reachable (e.g. NFS can
+ * unhash a directory dentry and then the complete subtree can become
+ * unreachable).
+ */
+int d_set_mounted(struct dentry *dentry)
+{
+	int ret = 0;
+
+	write_seqlock(&rename_lock);
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_MOUNTED;
+	if (!IS_ROOT(dentry)) {
+		ret = -ENOENT;
+		if (d_unhashed(dentry)) {
+			dentry->d_flags &= ~DCACHE_MOUNTED;
+			goto out;
+		}
+		spin_unlock(&dentry->d_lock);
+		if (__has_unlinked_ancestor(dentry->d_parent)) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags &= ~DCACHE_MOUNTED;
+			spin_unlock(&dentry->d_lock);
+		}
+		ret = 0;
+	}
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
