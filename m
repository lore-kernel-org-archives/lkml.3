Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaBEUY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:24:59 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48490 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaBEUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 160/213] sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()
Date: Wed, 5 Feb 2014 15:01:55 -0500
Message-ID: <1391630568-49251-161-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 66081a72517a131430dcf986775f3268aafcb546 upstream.

The warning check for duplicate sysfs entries can cause a buffer overflow
when printing the warning, as strcat() doesn't check buffer sizes.
Use strlcat() instead.

Since strlcat() doesn't return a pointer to the passed buffer, unlike
strcat(), I had to convert the nested concatenation in sysfs_add_one() to
an admittedly more obscure comma operator construct, to avoid emitting code
for the concatenation if CONFIG_BUG is disabled.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/sysfs/dir.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 590717861c7a..37d7153d3f72 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -400,20 +400,18 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 /**
  *	sysfs_pathname - return full path to sysfs dirent
  *	@sd: sysfs_dirent whose path we want
- *	@path: caller allocated buffer
+ *	@path: caller allocated buffer of size PATH_MAX
  *
  *	Gives the name "/" to the sysfs_root entry; any path returned
  *	is relative to wherever sysfs is mounted.
- *
- *	XXX: does no error checking on @path size
  */
 static char *sysfs_pathname(struct sysfs_dirent *sd, char *path)
 {
 	if (sd->s_parent) {
 		sysfs_pathname(sd->s_parent, path);
-		strcat(path, "/");
+		strlcat(path, "/", PATH_MAX);
 	}
-	strcat(path, sd->s_name);
+	strlcat(path, sd->s_name, PATH_MAX);
 	return path;
 }
 
@@ -446,9 +444,11 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
 		WARN(1, KERN_WARNING
 		     "sysfs: cannot create duplicate filename '%s'\n",
-		     (path == NULL) ? sd->s_name :
-		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
-		            sd->s_name));
+		     (path == NULL) ? sd->s_name
+				    : (sysfs_pathname(acxt->parent_sd, path),
+				       strlcat(path, "/", PATH_MAX),
+				       strlcat(path, sd->s_name, PATH_MAX),
+				       path));
 		kfree(path);
 	}
 
-- 
1.8.5.2

