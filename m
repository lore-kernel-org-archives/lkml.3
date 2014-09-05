Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaIEG4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:56:25 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47647 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaIEG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:56:24 -0400
Message-ID: <54095E79.9010306@huawei.com>
Date: Fri, 5 Sep 2014 14:55:53 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <viro@zeniv.linux.org.uk>, <eparis@redhat.com>, <jlayton@primarydata.com>,
        <jlayton@redhat.com>, <hujyang@gmail.com>
Subject: [PATCH] audit: vfs: fix audit records error when write to a file
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 33e2208acfc1

audit: vfs: fix audit_inode call in O_CREAT case of do_last

fix a regression in auditing of open(..., O_CREAT) syscalls but
import a new problem which lead the records of write operation
confusion.

This error can be reproduced by these steps:

	touch /etc/test
	echo "-w /etc/test" >>/etc/audit/audit.rules
	/etc/init.d/auditd restart

	echo "abc" >> /etc/test

audit_name records are:

type=PATH msg=audit(1409764556.196:67): item=0 name="/etc/" inode=5097 dev=00:01 mode=040755 ouid=0 ogid=0 rdev=00:00 nametype=PARENT
type=PATH msg=audit(1409764556.196:67): item=1 name=(null) inode=23161 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL
type=PATH msg=audit(1409764556.196:67): item=2 name=(null) inode=23161 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL

but if we revert commit 33e2208acfc1, records are correct:

type=PATH msg=audit(1409763058.192:219): item=0 name="/etc/test" inode=1275 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL

We shouldn't leave audit_inode(.., LOOKUP_PARENT) in O_CREAT case
of do_last() because this branch don't really know if vfs need to
create a new file. There is no need to do vfs_create() if we open
an existing file with O_CREAT flag and write to it. But this
audit_inode() in O_CREAT case will record a msg as we create a new
file and confuse the records of write.

This patch moves the audit for create operation to where a file
really need to be created, the O_CREAT case in lookup_open().
We have to add the pointer of struct filename as a parameter of
lookup_open(). By doing this, the records of both create and write
are correct.

Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 fs/namei.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a996bb4..0bc7734 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2808,7 +2808,8 @@ looked_up:
 static int lookup_open(struct nameidata *nd, struct path *path,
 			struct file *file,
 			const struct open_flags *op,
-			bool got_write, int *opened)
+			bool got_write, int *opened,
+			struct filename *name)
 {
 	struct dentry *dir = nd->path.dentry;
 	struct inode *dir_inode = dir->d_inode;
@@ -2854,6 +2855,9 @@ static int lookup_open(struct nameidata *nd, struct path *path,
 			error = -EROFS;
 			goto out_dput;
 		}
+
+		audit_inode(name, dir, LOOKUP_PARENT);
+
 		*opened |= FILE_CREATED;
 		error = security_path_mknod(&nd->path, dentry, mode, 0);
 		if (error)
@@ -2926,7 +2930,6 @@ static int do_last(struct nameidata *nd, struct path *path,
 		if (error)
 			return error;

-		audit_inode(name, dir, LOOKUP_PARENT);
 		error = -EISDIR;
 		/* trailing slashes? */
 		if (nd->last.name[nd->last.len])
@@ -2945,7 +2948,7 @@ retry_lookup:
 		 */
 	}
 	mutex_lock(&dir->d_inode->i_mutex);
-	error = lookup_open(nd, path, file, op, got_write, opened);
+	error = lookup_open(nd, path, file, op, got_write, opened, name);
 	mutex_unlock(&dir->d_inode->i_mutex);

 	if (error <= 0) {
-- 
1.8.5.5

