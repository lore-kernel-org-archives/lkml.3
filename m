Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3F0Q07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:26:59 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:34359 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3F0Q04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:26:56 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/2] overlayfs -- follow change to do_splice_direct interface
Date: Thu, 27 Jun 2013 17:26:44 +0100
Message-Id: <1372350404-10359-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372350404-10359-1-git-send-email-apw@canonical.com>
References: <1372350404-10359-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit below changed the interface to do_splice_direct, follow that
change in copy_up:

  commit 7995bd287134f6c8f80d94bebe7396f05a9bc42b
  Author: Al Viro <viro@zeniv.linux.org.uk>
  Date:   Thu Jun 20 18:58:36 2013 +0400

    splice: don't pass the address of ->f_pos to methods

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/copy_up.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index eef85e0..8e1b09f 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -90,9 +90,10 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 
 	/* FIXME: copy up sparse files efficiently */
 	while (len) {
-		loff_t offset = new_file->f_pos;
 		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
 		long bytes;
+		loff_t pos = old_file->f_pos;
+		loff_t out_pos = new_file->f_pos;
 
 		if (len < this_len)
 			this_len = len;
@@ -102,7 +103,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 			break;
 		}
 
-		bytes = do_splice_direct(old_file, &offset, new_file, this_len,
+		bytes = do_splice_direct(old_file, &pos, new_file, &out_pos, this_len,
 				 SPLICE_F_MOVE);
 		if (bytes <= 0) {
 			error = bytes;
-- 
1.8.3.1

