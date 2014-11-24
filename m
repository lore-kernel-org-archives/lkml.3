Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaKXNZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:25:38 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51253 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaKXNZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:25:36 -0500
Date: Mon, 24 Nov 2014 14:25:44 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH resend] init: fix read-write root mount
Message-ID: <20141124132544.GD3596@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If mount flags don't have MS_RDONLY, iso9660 returns EACCES without actually
checking if it's an iso image.

This tricks mount_block_root() into retrying with MS_RDONLY.  This results
in a read-only root despite the "rw" boot parameter if the actual
filesystem was checked after iso9660.

I believe the behavior of iso9660 is okay, while that of mount_block_root()
is not.  It should rather try all types without MS_RDONLY and only then
retry with MS_RDONLY.

This change also makes the code more robust against the case when EACCES is
returned despite MS_RDONLY, which would've resulted in a lockup.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 init/do_mounts.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -395,8 +395,6 @@ void __init mount_block_root(char *name,
 			case 0:
 				goto out;
 			case -EACCES:
-				flags |= MS_RDONLY;
-				goto retry;
 			case -EINVAL:
 				continue;
 		}
@@ -419,6 +417,10 @@ void __init mount_block_root(char *name,
 #endif
 		panic("VFS: Unable to mount root fs on %s", b);
 	}
+	if (!(flags & MS_RDONLY)) {
+		flags |= MS_RDONLY;
+		goto retry;
+	}
 
 	printk("List of all partitions:\n");
 	printk_all_partitions();
