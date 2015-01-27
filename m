Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbbA0PSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:18:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbbA0PSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:18:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] configfs: Fix potential NULL d_inode dereference
From: David Howells <dhowells@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        Joel Becker <joel.becker@oracle.com>, linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 15:18:39 +0000
Message-ID: <20150127151839.31483.83547.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code that does this:

		if (!(d_unhashed(dentry) && dentry->d_inode)) {
			...
			simple_unlink(parent->d_inode, dentry);
		}

is broken because:

    !(d_unhashed(dentry) && dentry->d_inode)

is equivalent to:

    !d_unhashed(dentry) || !dentry->d_inode

so it is possible to get into simple_unlink() with dentry->d_inode == NULL.

simple_unlink(), however, assumes dentry->d_inode cannot be NULL.

I think that what was meant is this:

    !d_unhashed(dentry) && dentry->d_inode

and that the logical-not operator or the final close-bracket was misplaced.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Joel Becker <joel.becker@oracle.com>
---

 fs/configfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 5946ad98053f..e5a7c18a9bee 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -249,7 +249,7 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
 
 	if (dentry) {
 		spin_lock(&dentry->d_lock);
-		if (!(d_unhashed(dentry) && dentry->d_inode)) {
+		if (!d_unhashed(dentry) && dentry->d_inode) {
 			dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);

