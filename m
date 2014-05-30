Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934367AbaE3UkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:40:22 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51131 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934289AbaE3UkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:40:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>, logfs@logfs.org
Subject: [RFC 23/32] logfs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:47 +0200
Message-Id: <1401480116-1973111-24-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:m6JSSQ7elUstDWdzMdFzYGY0edS+y6tmJ/32teMVBiX
 bk9MicDMNxKCBMKTXeB7u3A6pQ1YsBxLDDbdk+craZkthjAdD0
 0VoCNMCUwT6un/L47HykITIgmZv+UOx/RmehLUbrKJu/lnIFiw
 V0LICvG0icWYD8JoVByqUVqtJlRjKdvnAFqOtCxbVPaMRpSZAS
 tplhETq3XZg22GgxiY9ozkVpDQ0HcE1jAn7VbruDtgiZz5tm/L
 8ojeAy8tEqsrEsRJzLCAThTzHYgzquQo2nAqPdgxtxCryow8Op
 xJongwc9U5jwEqy/9F6IJUkPLJWEzo4enCex1q3u5geZTk3fFW
 7kDsXJdwwl34LOMbMBe64JjQmB1nxiru+4TKahmSr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logfs uses 64-bit integers for inode timestamps, which will work
for the next 550 years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in logfs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: logfs@logfs.org
---
 fs/logfs/readwrite.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 4814031..df44698 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -101,12 +101,12 @@ void logfs_unpack_index(pgoff_t index, u64 *bix, level_t *level)
 /*
  * Time is stored as nanoseconds since the epoch.
  */
-static struct timespec be64_to_timespec(__be64 betime)
+static struct inode_time be64_to_inode_time(__be64 betime)
 {
-	return ns_to_timespec(be64_to_cpu(betime));
+	return ns_to_inode_time(be64_to_cpu(betime));
 }
 
-static __be64 timespec_to_be64(struct timespec tsp)
+static __be64 inode_time_to_be64(struct inode_time tsp)
 {
 	return cpu_to_be64((u64)tsp.tv_sec * NSEC_PER_SEC + tsp.tv_nsec);
 }
@@ -123,9 +123,9 @@ static void logfs_disk_to_inode(struct logfs_disk_inode *di, struct inode*inode)
 	i_gid_write(inode, be32_to_cpu(di->di_gid));
 	inode->i_size	= be64_to_cpu(di->di_size);
 	logfs_set_blocks(inode, be64_to_cpu(di->di_used_bytes));
-	inode->i_atime	= be64_to_timespec(di->di_atime);
-	inode->i_ctime	= be64_to_timespec(di->di_ctime);
-	inode->i_mtime	= be64_to_timespec(di->di_mtime);
+	inode->i_atime	= be64_to_inode_time(di->di_atime);
+	inode->i_ctime	= be64_to_inode_time(di->di_ctime);
+	inode->i_mtime	= be64_to_inode_time(di->di_mtime);
 	set_nlink(inode, be32_to_cpu(di->di_refcount));
 	inode->i_generation = be32_to_cpu(di->di_generation);
 
@@ -160,9 +160,9 @@ static void logfs_inode_to_disk(struct inode *inode, struct logfs_disk_inode*di)
 	di->di_gid	= cpu_to_be32(i_gid_read(inode));
 	di->di_size	= cpu_to_be64(i_size_read(inode));
 	di->di_used_bytes = cpu_to_be64(li->li_used_bytes);
-	di->di_atime	= timespec_to_be64(inode->i_atime);
-	di->di_ctime	= timespec_to_be64(inode->i_ctime);
-	di->di_mtime	= timespec_to_be64(inode->i_mtime);
+	di->di_atime	= inode_time_to_be64(inode->i_atime);
+	di->di_ctime	= inode_time_to_be64(inode->i_ctime);
+	di->di_mtime	= inode_time_to_be64(inode->i_mtime);
 	di->di_refcount	= cpu_to_be32(inode->i_nlink);
 	di->di_generation = cpu_to_be32(inode->i_generation);
 
-- 
1.8.3.2

