Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab3GCTHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:07:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004Ab3GCTA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:28 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=aDXAM2X0vYkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=25fURvdQ0P4A:10 a=cm27Pg_UAAAA:8 a=L8c3rYF_AAAA:8 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=d9kbP3LUXTLhuQBzhLoA:9 a=zv9_9hqRWm8A:10 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=NWVoK91CQyQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184101.117757976@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paul Taysom <taysom@chromium.org>, Tyler Hicks <tyhicks@canonical.com>
Subject: [094/141] ecryptfs: fixed msync to flush data
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0094-ecryptfs-fixed-msync-to-flush-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Paul Taysom <taysom@chromium.org>

[ Upstream commit c15cddd900e867c5adfb3c79596479dc5975f743 ]

When msync is called on a memory mapped file, that
data is not flushed to the disk.

In Linux, msync calls fsync for the file. For ecryptfs,
fsync just calls the lower level file system's fsync.
Changed the ecryptfs fsync code to call filemap_write_and_wait
before calling the lower level fsync.

Addresses the problem described in http://crbug.com/239536

Signed-off-by: Paul Taysom <taysom@chromium.org>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: stable@vger.kernel.org # v3.6+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ecryptfs/file.c |    1 +
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
1.7.10.4


