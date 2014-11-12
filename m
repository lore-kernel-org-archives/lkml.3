Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904AbaKLDhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:37:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaKLBaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:30:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.17 182/319] fix inode leaks on d_splice_alias() failure exits
Date: Wed, 12 Nov 2014 10:15:20 +0900
Message-Id: <20141112011022.837411643@linuxfoundation.org>
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

commit 51486b900ee92856b977eacfc5bfbe6565028070 upstream.

d_splice_alias() callers expect it to either stash the inode reference
into a new alias, or drop the inode reference.  That makes it possible
to just return d_splice_alias() result from ->lookup() instance, without
any extra housekeeping required.

Unfortunately, that should include the failure exits.  If d_splice_alias()
returns an error, it leaves the dentry it has been given negative and
thus it *must* drop the inode reference.  Easily fixed, but it goes way
back and will need backporting.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2675,11 +2675,13 @@ struct dentry *d_splice_alias(struct ino
 			if (!IS_ROOT(new)) {
 				spin_unlock(&inode->i_lock);
 				dput(new);
+				iput(inode);
 				return ERR_PTR(-EIO);
 			}
 			if (d_ancestor(new, dentry)) {
 				spin_unlock(&inode->i_lock);
 				dput(new);
+				iput(inode);
 				return ERR_PTR(-EIO);
 			}
 			write_seqlock(&rename_lock);


