Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab3JKUV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:21:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab3JKTkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emil Karlson <jekarlson@gmail.com>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 104/110] Btrfs: skip subvol entries when checking if weve created a dir already
Date: Fri, 11 Oct 2013 12:39:24 -0700
Message-Id: <20131011193819.119001289@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2524,7 +2524,8 @@ static int did_create_dir(struct send_ct
 		di = btrfs_item_ptr(eb, slot, struct btrfs_dir_item);
 		btrfs_dir_item_key_to_cpu(eb, di, &di_key);
 
-		if (di_key.objectid < sctx->send_progress) {
+		if (di_key.type != BTRFS_ROOT_ITEM_KEY &&
+		    di_key.objectid < sctx->send_progress) {
 			ret = 1;
 			goto out;
 		}


