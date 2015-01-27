Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbbA0PBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:01:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbbA0PB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:01:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] Infiniband: Fix potential NULL d_inode dereference
From: David Howells <dhowells@redhat.com>
Cc: infinipath@intel.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        "Bryan O'Sullivan" <bos@pathscale.com>, viro@zeniv.linux.org.uk,
        Roland Dreier <rolandd@cisco.com>
Date: Tue, 27 Jan 2015 15:01:18 +0000
Message-ID: <20150127150118.24110.99894.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code that does this:

	if (!(d_unhashed(tmp) && tmp->d_inode)) {
		...
		simple_unlink(parent->d_inode, tmp);
	}

is broken because:

	!(d_unhashed(tmp) && tmp->d_inode)

is equivalent to:

	!d_unhashed(tmp) || !tmp->d_inode

so it is possible to get into simple_unlink() with tmp->d_inode == NULL.

simple_unlink(), however, assumes tmp->d_inode cannot be NULL.

I think that what was meant is this:

	!d_unhashed(tmp) && tmp->d_inode

and that the logical-not operator or the final close-bracket was misplaced.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Bryan O'Sullivan <bos@pathscale.com>
cc: Roland Dreier <rolandd@cisco.com>
---

 drivers/infiniband/hw/ipath/ipath_fs.c |    2 +-
 drivers/infiniband/hw/qib/qib_fs.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 4977082e081f..33c45dfcbd88 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -277,7 +277,7 @@ static int remove_file(struct dentry *parent, char *name)
 	}
 
 	spin_lock(&tmp->d_lock);
-	if (!(d_unhashed(tmp) && tmp->d_inode)) {
+	if (!d_unhashed(tmp) && tmp->d_inode) {
 		dget_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 81854586c081..d2427640d7e9 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -455,7 +455,7 @@ static int remove_file(struct dentry *parent, char *name)
 	}
 
 	spin_lock(&tmp->d_lock);
-	if (!(d_unhashed(tmp) && tmp->d_inode)) {
+	if (!d_unhashed(tmp) && tmp->d_inode) {
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);

