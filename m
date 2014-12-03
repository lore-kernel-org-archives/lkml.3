Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaLCLjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:39:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbaLCL1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vyacheslav Dubeyko <slava@dubeyko.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 085/101] hfsplus: fix remount issue
Date: Wed,  3 Dec 2014 12:26:47 +0100
Message-Id: <291e7f11b9028ac9e418e15ebae1d30a94b59382.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bd2c00353286d63542a8a0896a8c747f7c880edd upstream.

Current implementation of HFS+ driver has small issue with remount
option.  Namely, for example, you are unable to remount from RO mode
into RW mode by means of command "mount -o remount,rw /dev/loop0
/mnt/hfsplus".  Trying to execute sequence of commands results in an
error message:

  mount /dev/loop0 /mnt/hfsplus
  mount -o remount,ro /dev/loop0 /mnt/hfsplus
  mount -o remount,rw /dev/loop0 /mnt/hfsplus

  mount: you must specify the filesystem type

  mount -t hfsplus -o remount,rw /dev/loop0 /mnt/hfsplus

  mount: /mnt/hfsplus not mounted or bad option

The reason of such issue is failure of mount syscall:

  mount("/dev/loop0", "/mnt/hfsplus", 0x2282a60, MS_MGC_VAL|MS_REMOUNT, NULL) = -1 EINVAL (Invalid argument)

Namely, hfsplus_parse_options_remount() method receives empty "input"
argument and return false in such case.  As a result, hfsplus_remount()
returns -EINVAL error code.

This patch fixes the issue by means of return true for the case of empty
"input" argument in hfsplus_parse_options_remount() method.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/hfsplus/options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 968eab5bc1f5..68537e8b7a09 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -75,7 +75,7 @@ int hfsplus_parse_options_remount(char *input, int *force)
 	int token;
 
 	if (!input)
-		return 0;
+		return 1;
 
 	while ((p = strsep(&input, ",")) != NULL) {
 		if (!*p)
-- 
2.1.3

