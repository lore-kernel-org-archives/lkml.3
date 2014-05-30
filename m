Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaE3UGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:06:03 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:51254 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaE3UF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu
Subject: [RFC 10/32] fs/coda: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:34 +0200
Message-Id: <1401480116-1973111-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:uvsM7PVQP6iDubt83709QGE9R4iKQNPG1VkHY29xq9m
 TwezJpj4rKzcInCJC2s5D4vlEfw/6omu/7OHGH+6m029OtZjxo
 D9XG/DnDWhQQcKimmawrUAbeEI/+JthdByyduUTN7tqf/+FbRN
 f/AnWtbheEAyslmDfWzoNoWvg6HwsorqSakSjRuLAsBA2tWiAv
 WU2oyQG7LHqFMCdKIlag0K1F7KqRazEODfF5ls0TCX5Stq9f+4
 L2tY9SHEyhhB5sgcsNsLpiDf7hLGYAYfiPly44pPHJmFXsbmxg
 9bB6C+G/OsE/zXDGUTxLn8sbWmDo3pInBioXVUk1q2fh/dHLtr
 Nip1qrD8EzQ0NAYhtawyHFIFphpQRjAz4Xd/YeNQR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the coda file system to use inode_time, which we will
need to fix the y2038 limit. However, inode time stamps in coda
are communicated to user space through coda_pioctl() as a 'struct
timespec', so this cannot be fixed for coda without changing the
user space interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: coda@cs.cmu.edu
Cc: codalist@coda.cs.cmu.edu
---
 fs/coda/coda_linux.c      | 18 ++++++++++++------
 include/uapi/linux/coda.h |  1 +
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/coda/coda_linux.c b/fs/coda/coda_linux.c
index 2849f41..f2fcec5 100644
--- a/fs/coda/coda_linux.c
+++ b/fs/coda/coda_linux.c
@@ -110,11 +110,14 @@ void coda_vattr_to_iattr(struct inode *inode, struct coda_vattr *attr)
 	if (attr->va_size != -1)
 		inode->i_blocks = (attr->va_size + 511) >> 9;
 	if (attr->va_atime.tv_sec != -1) 
-	        inode->i_atime = attr->va_atime;
+	        inode->i_atime = (struct inode_time)
+			{ attr->va_atime.tv_sec, attr->va_atime.tv_nsec };
 	if (attr->va_mtime.tv_sec != -1)
-	        inode->i_mtime = attr->va_mtime;
+	        inode->i_mtime = (struct inode_time)
+			{ attr->va_mtime.tv_sec, attr->va_mtime.tv_nsec };
         if (attr->va_ctime.tv_sec != -1)
-	        inode->i_ctime = attr->va_ctime;
+	        inode->i_ctime = (struct inode_time)
+			{ attr->va_ctime.tv_sec, attr->va_ctime.tv_nsec };
 }
 
 
@@ -180,13 +183,16 @@ void coda_iattr_to_vattr(struct iattr *iattr, struct coda_vattr *vattr)
                 vattr->va_size = iattr->ia_size;
 	}
         if ( valid & ATTR_ATIME ) {
-                vattr->va_atime = iattr->ia_atime;
+                vattr->va_atime = (struct timespec)
+			{ iattr->ia_atime.tv_sec, iattr->ia_atime.tv_nsec };
 	}
         if ( valid & ATTR_MTIME ) {
-                vattr->va_mtime = iattr->ia_mtime;
+                vattr->va_mtime = (struct timespec)
+			{ iattr->ia_mtime.tv_sec, iattr->ia_mtime.tv_nsec };
 	}
         if ( valid & ATTR_CTIME ) {
-                vattr->va_ctime = iattr->ia_ctime;
+                vattr->va_ctime = (struct timespec)
+			{ iattr->ia_ctime.tv_sec, iattr->ia_ctime.tv_nsec };
 	}
 }
 
diff --git a/include/uapi/linux/coda.h b/include/uapi/linux/coda.h
index 695fade..e7258f7 100644
--- a/include/uapi/linux/coda.h
+++ b/include/uapi/linux/coda.h
@@ -220,6 +220,7 @@ struct coda_vattr {
 	long		va_fileid;	/* file id */
 	u_quad_t	va_size;	/* file size in bytes */
 	long		va_blocksize;	/* blocksize preferred for i/o */
+	/* FIXME: timespec in user API */
 	struct timespec	va_atime;	/* time of last access */
 	struct timespec	va_mtime;	/* time of last modification */
 	struct timespec	va_ctime;	/* time file changed */
-- 
1.8.3.2

