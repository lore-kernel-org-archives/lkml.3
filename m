Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3LERi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:38:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456Ab3LERiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Junxiao Bi <junxiao.bi@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 70/90] configfs: fix race between dentry put and lookup
Date: Thu,  5 Dec 2013 17:35:52 +0000
Message-Id: <1386264972-5399-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 76ae281f6307331aa063288edb6422ae99f435f0 upstream.

A race window in configfs, it starts from one dentry is UNHASHED and end
before configfs_d_iput is called.  In this window, if a lookup happen,
since the original dentry was UNHASHED, so a new dentry will be
allocated, and then in configfs_attach_attr(), sd->s_dentry will be
updated to the new dentry.  Then in configfs_d_iput(),
BUG_ON(sd->s_dentry != dentry) will be triggered and system panic.

sys_open:                     sys_close:
 ...                           fput
                                dput
                                 dentry_kill
                                  __d_drop <--- dentry unhashed here,
                                           but sd->dentry still point
                                           to this dentry.

 lookup_real
  configfs_lookup
   configfs_attach_attr---> update sd->s_dentry
                            to new allocated dentry here.

                                   d_kill
                                     configfs_d_iput <--- BUG_ON(sd->s_dentry != dentry)
                                                     triggered here.

To fix it, change configfs_d_iput to not update sd->s_dentry if
sd->s_count > 2, that means there are another dentry is using the sd
beside the one that is going to be put.  Use configfs_dirent_lock in
configfs_attach_attr to sync with configfs_d_iput.

With the following steps, you can reproduce the bug.

1. enable ocfs2, this will mount configfs at /sys/kernel/config and
   fill configure in it.

2. run the following script.
	while [ 1 ]; do cat /sys/kernel/config/cluster/$your_cluster_name/idle_timeout_ms > /dev/null; done &
	while [ 1 ]; do cat /sys/kernel/config/cluster/$your_cluster_name/idle_timeout_ms > /dev/null; done &

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/configfs/dir.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7e6c52d..c91f6d1 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -56,10 +56,19 @@ static void configfs_d_iput(struct dentry * dentry,
 	struct configfs_dirent *sd = dentry->d_fsdata;
 
 	if (sd) {
-		BUG_ON(sd->s_dentry != dentry);
 		/* Coordinate with configfs_readdir */
 		spin_lock(&configfs_dirent_lock);
-		sd->s_dentry = NULL;
+		/* Coordinate with configfs_attach_attr where will increase
+		 * sd->s_count and update sd->s_dentry to new allocated one.
+		 * Only set sd->dentry to null when this dentry is the only
+		 * sd owner.
+		 * If not do so, configfs_d_iput may run just after
+		 * configfs_attach_attr and set sd->s_dentry to null
+		 * even it's still in use.
+		 */
+		if (atomic_read(&sd->s_count) <= 2)
+			sd->s_dentry = NULL;
+
 		spin_unlock(&configfs_dirent_lock);
 		configfs_put(sd);
 	}
@@ -426,8 +435,11 @@ static int configfs_attach_attr(struct configfs_dirent * sd, struct dentry * den
 	struct configfs_attribute * attr = sd->s_element;
 	int error;
 
+	spin_lock(&configfs_dirent_lock);
 	dentry->d_fsdata = configfs_get(sd);
 	sd->s_dentry = dentry;
+	spin_unlock(&configfs_dirent_lock);
+
 	error = configfs_create(dentry, (attr->ca_mode & S_IALLUGO) | S_IFREG,
 				configfs_init_file);
 	if (error) {
-- 
1.8.3.2

