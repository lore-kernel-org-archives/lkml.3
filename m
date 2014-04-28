Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaD1BdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42853 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>,
        "Jeff Mahoney" <jeffm@suse.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.269188649@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 72/94] reiserfs: fix race in readdir
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 01d8885785a60ae8f4c37b0ed75bdc96d0fc6a44 upstream.

jdm-20004 reiserfs_delete_xattrs: Couldn't delete all xattrs (-2)

The -ENOENT is due to readdir calling dir_emit on the same entry twice.

If the dir_emit callback sleeps and the tree is changed underneath us,
we won't be able to trust deh_offset(deh) anymore. We need to save
next_pos before we might sleep so we can find the next entry.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/reiserfs/dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -128,6 +128,7 @@ int reiserfs_readdir_dentry(struct dentr
 				char *d_name;
 				off_t d_off;
 				ino_t d_ino;
+				loff_t cur_pos = deh_offset(deh);
 
 				if (!de_visible(deh))
 					/* it is hidden entry */
@@ -200,8 +201,9 @@ int reiserfs_readdir_dentry(struct dentr
 				if (local_buf != small_buf) {
 					kfree(local_buf);
 				}
-				// next entry should be looked for with such offset
-				next_pos = deh_offset(deh) + 1;
+
+				/* deh_offset(deh) may be invalid now. */
+				next_pos = cur_pos + 1;
 
 				if (item_moved(&tmp_ih, &path_to_entry)) {
 					goto research;

