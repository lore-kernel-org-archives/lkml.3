Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab3FDWyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:54:21 -0400
Received: from 1wt.eu ([62.212.114.60]:35792 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab3FDWns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:48 -0400
Message-Id: <20130604172135.078814276@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 115/184] sysfs: sysfs_pathname/sysfs_add_one: Use strlcat()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 instead of strcat()

From: Geert Uytterhoeven <geert@linux-m68k.org>

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/sysfs/dir.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e020183..5e7279a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -440,20 +440,18 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
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
 
@@ -486,9 +484,11 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
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
1.7.12.2.21.g234cd45.dirty



