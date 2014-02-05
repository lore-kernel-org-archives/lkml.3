Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbaBEUMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:12:32 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48651 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbaBEUIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tyler Hicks <tyhicks@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 208/213] eCryptfs: Properly check for O_RDONLY flag before doing privileged open
Date: Wed, 5 Feb 2014 15:02:43 -0500
Message-ID: <1391630568-49251-209-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9fe79d7600497ed8a95c3981cbe5b73ab98222f0 upstream.

If the first attempt at opening the lower file read/write fails,
eCryptfs will retry using a privileged kthread. However, the privileged
retry should not happen if the lower file's inode is read-only because a
read/write open will still be unsuccessful.

The check for determining if the open should be retried was intended to
be based on the access mode of the lower file's open flags being
O_RDONLY, but the check was incorrectly performed. This would cause the
open to be retried by the privileged kthread, resulting in a second
failed open of the lower file. This patch corrects the check to
determine if the open request should be handled by the privileged
kthread.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ecryptfs/kthread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index d8c3a373aafa..920d5d9a0cdb 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -149,7 +149,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	(*lower_file) = dentry_open(lower_dentry, lower_mnt, flags, cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
-	if (flags & O_RDONLY) {
+	if ((flags & O_ACCMODE) == O_RDONLY) {
 		rc = PTR_ERR((*lower_file));
 		goto out;
 	}
-- 
1.8.5.2

