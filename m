Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3FEGxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:53:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52230 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3FEGxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:53:10 -0400
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paul Taysom <taysom@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: [PATCH] eCryptfs: Check return of filemap_write_and_wait during fsync
Date: Tue,  4 Jun 2013 23:53:03 -0700
Message-Id: <1370415183-17023-1-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130524233139.GA4029@boyd>
References: <20130524233139.GA4029@boyd>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error out of ecryptfs_fsync() if filemap_write_and_wait() fails.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Paul Taysom <taysom@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
---

After giving Paul's patch one more look, I noticed that we were ignoring
filemap_write_and_wait()'s return value. I plan to push this patch along with
Paul's original patch.

 fs/ecryptfs/file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 16f509d..a7abbea 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -295,7 +295,12 @@ static int ecryptfs_release(struct inode *inode, struct file *file)
 static int
 ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	filemap_write_and_wait(file->f_mapping);
+	int rc;
+
+	rc = filemap_write_and_wait(file->f_mapping);
+	if (rc)
+		return rc;
+
 	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
 }
 
-- 
1.8.1.2

