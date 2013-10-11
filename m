Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795Ab3JKTpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:45:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab3JKTmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emil Karlson <jekarlson@gmail.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 128/135] Btrfs: skip subvol entries when checking if weve created a dir already
Date: Fri, 11 Oct 2013 12:40:09 -0700
Message-Id: <20131011193959.174784517@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit a05254143cd183b18002cbba7759a1e4629aa762 upstream.

We have logic to see if we've already created a parent directory by check to see
if an inode inside of that directory has a lower inode number than the one we
are currently processing.  The logic is that if there is a lower inode number
then we would have had to made sure the directory was created at that previous
point.  The problem is that subvols inode numbers count from the lowest objectid
in the root tree, which may be less than our current progress.  So just skip if
our dir item key is a root item.  This fixes the original test and the xfstest
version I made that added an extra subvol create.  Thanks,

Reported-by: Emil Karlson <jekarlson@gmail.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2519,7 +2519,8 @@ static int did_create_dir(struct send_ct
 		di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
 		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
 
-		if (di_key.objectid < sctx->send_progress) {
+		if (di_key.type != BTRFS_ROOT_ITEM_KEY &&
+		    di_key.objectid < sctx->send_progress) {
 			ret = 1;
 			goto out;
 		}


