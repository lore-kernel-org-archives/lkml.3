Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3FKUEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:04:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab3FKUEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Taysom <taysom@chromium.org>, Tyler Hicks <tyhicks@canonical.com>
Subject: [ 50/79] ecryptfs: fixed msync to flush data
Date: Tue, 11 Jun 2013 13:03:16 -0700
Message-Id: <20130611195322.669669204@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -294,6 +294,7 @@ static int ecryptfs_release(struct inode
 static int
 ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
+	filemap_write_and_wait(file->f_mapping);
 	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
 }
 


