Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbaKKLxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:53:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57435 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaKKLKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Tony Luck <tony.luck@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 067/170] pstore: Fix duplicate {console,ftrace}-efi entries
Date: Tue, 11 Nov 2014 11:07:06 +0000
Message-Id: <1415704129-12709-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/pstore/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 192297b0090d..fafb7a02a5d6 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -320,10 +320,10 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
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
2.1.0

