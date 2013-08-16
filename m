Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3HPNSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:18:46 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49159 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3HPNSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:18:38 -0400
Subject: [RFC PATCH v2 07/11] pstore: Add file extension to pstore file if
 compressed
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, benh@kernel.crashing.org,
        cbouatmailru@gmail.com, mahesh@linux.vnet.ibm.com, ccross@android.com
Date: Fri, 16 Aug 2013 18:48:28 +0530
Message-ID: <20130816131828.3338.65602.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081613-2000-0000-0000-00000D572BDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case decompression fails, add a ".enc.z" to indicate the file has
compressed data. This will help user space utilities to figure
out the file contents.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/inode.c    |    7 ++++---
 fs/pstore/internal.h |    5 +++--
 fs/pstore/platform.c |    4 +++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 71bf5f4..519d278 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -275,8 +275,8 @@ int pstore_is_mounted(void)
  * Set the mtime & ctime to the date that this record was originally stored.
  */
 int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
-		  char *data, size_t size, struct timespec time,
-		  struct pstore_info *psi)
+		  char *data, bool compressed, size_t size,
+		  struct timespec time, struct pstore_info *psi)
 {
 	struct dentry		*root = pstore_sb->s_root;
 	struct dentry		*dentry;
@@ -315,7 +315,8 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 
 	switch (type) {
 	case PSTORE_TYPE_DMESG:
-		sprintf(name, "dmesg-%s-%lld", psname, id);
+		sprintf(name, "dmesg-%s-%lld%s", psname, id,
+						compressed ? ".enc.z" : "");
 		break;
 	case PSTORE_TYPE_CONSOLE:
 		sprintf(name, "console-%s", psname);
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 937d820..3b3d305 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -50,8 +50,9 @@ extern struct pstore_info *psinfo;
 extern void	pstore_set_kmsg_bytes(int);
 extern void	pstore_get_records(int);
 extern int	pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
-			      int count, char *data, size_t size,
-			      struct timespec time, struct pstore_info *psi);
+			      int count, char *data, bool compressed,
+			      size_t size, struct timespec time,
+			      struct pstore_info *psi);
 extern int	pstore_is_mounted(void);
 
 #endif
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 0195cca0..cf0b53f 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -479,13 +479,15 @@ void pstore_get_records(int quiet)
 			if (unzipped_len > 0) {
 				buf = big_oops_buf;
 				size = unzipped_len;
+				compressed = false;
 			} else {
 				pr_err("pstore: decompression failed;"
 					"returned %d\n", unzipped_len);
+				compressed = true;
 			}
 		}
 		rc = pstore_mkfile(type, psi->name, id, count, buf,
-				  (size_t)size, time, psi);
+				  compressed, (size_t)size, time, psi);
 		if (unzipped_len < 0) {
 			/* Free buffer other than big oops */
 			kfree(buf);

