Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826AbaFTIrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:47:12 -0400
Received: from smtp2.macqel.be ([109.135.2.61]:58263 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934598AbaFTIrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:47:10 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2014 04:47:09 EDT
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] VFS: mount must return EACCES, not EROFS
Date: Fri, 20 Jun 2014 10:39:22 +0200
Message-Id: <1403253562-29248-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <20140619230924.GO4453@dastard>
References: <20140619230924.GO4453@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mount must return EACCES, not EROFS, when one attempts to mount a
read-only filesystem in read-write mode, but the file-system layer
only transmits the error given by the block layer, and many block
drivers return EROFS in that case, so let's fix it in do_mount.

Actually it is only a small problem for a user using the mount(1)
command, because EROFS is actually a more explicit answer than
EACCES, but init/do_mounts.c checks only for EACCES, not EROFS,
to decide to retry to mount the root file-system in read-only mode,
and so we are left with an unbootable kernel, and with a cryptic
error message (*) if the root partition happens to be read-only

(*): VFS: Cannot open root device "mmcblk0p2" or unknown-block(179,2):
error -30

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/namespace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 182bc41..6291a3f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2411,6 +2411,8 @@ long do_mount(const char *dev_name, const char *dir_name,
 
 	retval = security_sb_mount(dev_name, &path,
 				   type_page, flags, data_page);
+	if (retval == -EROFS)
+		retval = -EACCES;
 	if (!retval && !may_mount())
 		retval = -EPERM;
 	if (retval)
-- 
1.7.5.3

