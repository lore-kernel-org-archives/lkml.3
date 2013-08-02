Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3HBEIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:08:01 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59383 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3HBEH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:07:59 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] fs: Fix file mode for O_TMPFILE
Date: Thu,  1 Aug 2013 21:07:52 -0700
Message-Id: <a07af884ef10dc72ac0066ec90cfa174abec85e3.1375416372.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O_TMPFILE, like O_CREAT, should respect the requested mode and should
create regular files.

This fixes two bugs: O_TMPFILE required privilege (because the mode
ended up as 000) and it produced bogus inodes with no type.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/open.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index d53e298..7931f76 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -823,7 +823,7 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 	int lookup_flags = 0;
 	int acc_mode;
 
-	if (flags & O_CREAT)
+	if (flags & (O_CREAT | __O_TMPFILE))
 		op->mode = (mode & S_IALLUGO) | S_IFREG;
 	else
 		op->mode = 0;
-- 
1.8.3.1

