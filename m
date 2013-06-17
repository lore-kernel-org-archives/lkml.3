Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3FQRdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:33:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50511 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab3FQRdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Taysom <taysom@chromium.org>, Tyler Hicks <tyhicks@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 33/84] ecryptfs: fixed msync to flush data
Date: Mon, 17 Jun 2013 10:30:37 -0700
Message-Id: <1371490288-23167-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Taysom <taysom@chromium.org>

commit c15cddd900e867c5adfb3c79596479dc5975f743 upstream.

When msync is called on a memory mapped file, that
data is not flushed to the disk.

In Linux, msync calls fsync for the file. For ecryptfs,
fsync just calls the lower level file system's fsync.
Changed the ecryptfs fsync code to call filemap_write_and_wait
before calling the lower level fsync.

Addresses the problem described in http://crbug.com/239536

Signed-off-by: Paul Taysom <taysom@chromium.org>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ecryptfs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index d45ba45..4f9a25e 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -296,6 +296,7 @@ static int ecryptfs_release(struct inode *inode, struct file *file)
 static int
 ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
+	filemap_write_and_wait(file->f_mapping);
 	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
 }
 
-- 
1.8.1.2

