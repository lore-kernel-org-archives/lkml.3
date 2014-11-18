Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbaKRPFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:05:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbaKROJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/206] pstore: Fix duplicate {console,ftrace}-efi entries
Date: Tue, 18 Nov 2014 15:07:16 +0100
Message-Id: <77bbc2f5844a52a6b3d56a3df504e8e1387bdea1.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d4bf205da618bbd0b038e404d646f14e76915718 upstream.

The pstore filesystem still creates duplicate filename/inode pairs for
some pstore types.  Add the id to the filename to prevent that.

Before patch:

[/sys/fs/pstore] ls -li
total 0
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi

After:

[/sys/fs/pstore] ls -li
total 0
1232 -r--r--r--. 1 root root 148 Sep 29 17:09 console-efi-141202499100000
1231 -r--r--r--. 1 root root  67 Sep 29 17:09 console-efi-141202499200000
1230 -r--r--r--. 1 root root 148 Sep 29 17:44 console-efi-141202705400000
1229 -r--r--r--. 1 root root  67 Sep 29 17:44 console-efi-141202705500000
1228 -r--r--r--. 1 root root  67 Sep 29 20:42 console-efi-141203772600000
1227 -r--r--r--. 1 root root 148 Sep 29 23:42 console-efi-141204854900000
1226 -r--r--r--. 1 root root  67 Sep 29 23:42 console-efi-141204855000000
1225 -r--r--r--. 1 root root 148 Sep 29 23:59 console-efi-141204954200000
1224 -r--r--r--. 1 root root  67 Sep 29 23:59 console-efi-141204954400000

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/pstore/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 12823845d324..14120a3c6195 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -319,10 +319,10 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 						compressed ? ".enc.z" : "");
 		break;
 	case PSTORE_TYPE_CONSOLE:
-		sprintf(name, "console-%s", psname);
+		sprintf(name, "console-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_FTRACE:
-		sprintf(name, "ftrace-%s", psname);
+		sprintf(name, "ftrace-%s-%lld", psname, id);
 		break;
 	case PSTORE_TYPE_MCE:
 		sprintf(name, "mce-%s-%lld", psname, id);
-- 
2.1.3

