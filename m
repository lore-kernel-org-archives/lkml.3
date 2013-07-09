Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3GIBUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:20:42 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:21738 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3GIBRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:17:44 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v6 05/14] ceph-fs: replace direct access of d_count with the d_count() helper
Date: Mon,  8 Jul 2013 21:09:55 -0400
Message-Id: <1373332204-10379-6-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All readonly references to d_count outside of the core dcache code
should be changed to use the new d_count() helper as they shouldn't
access its value directly.  There is no change in logic and everything
should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/ceph/inode.c      |    4 ++--
 fs/ceph/mds_client.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index be0f7e2..bd2289a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -903,8 +903,8 @@ static struct dentry *splice_dentry(struct dentry *dn, struct inode *in,
 	} else if (realdn) {
 		dout("dn %p (%d) spliced with %p (%d) "
 		     "inode %p ino %llx.%llx\n",
-		     dn, dn->d_count,
-		     realdn, realdn->d_count,
+		     dn, d_count(dn),
+		     realdn, d_count(realdn),
 		     realdn->d_inode, ceph_vinop(realdn->d_inode));
 		dput(dn);
 		dn = realdn;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 74fd289..99890b0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1553,7 +1553,7 @@ retry:
 	*base = ceph_ino(temp->d_inode);
 	*plen = len;
 	dout("build_path on %p %d built %llx '%.*s'\n",
-	     dentry, dentry->d_count, *base, len, path);
+	     dentry, d_count(dentry), *base, len, path);
 	return path;
 }
 
-- 
1.7.1

