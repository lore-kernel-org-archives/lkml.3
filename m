Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab3GOQ4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:56:41 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57927 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3GOQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:56:39 -0400
Subject: [PATCH 07/11] pstore: Add file extension to pstore file if
 compressed
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:26:19 +0530
Message-ID: <20130715165619.1520.72602.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-5490-0000-0000-000003D237AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case decompression fails, add a ".enc.z" to indicate the file has
compressed data. This will help user space utilities to figure
out the file contents.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/inode.c    |    9 +++++----
 fs/pstore/internal.h |    5 +++--
 fs/pstore/platform.c |    4 +++-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 71bf5f4..259e92c 100644
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
@@ -328,7 +329,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 		break;
 	case PSTORE_TYPE_PPC_RTAS:
 		sprintf(name, "rtas-%s-%lld", psname, id);
-		break;
+	break;
 	case PSTORE_TYPE_PPC_OF:
 		sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
 		break;
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
index 119db58..8f3e5f0 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -481,13 +481,15 @@ void pstore_get_records(int quiet)
 			if (unzipped_len > 0) {
 				buf = big_buf;
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
 		kfree(buf);
 		kfree(stream.workspace);
 		kfree(big_buf);

