Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaD1VNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:13:08 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:20077 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666AbaD1VNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:13:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgTAP/CXlNXQw00/2dsb2JhbABZgwasDQUBAQEFmXICAoEaF3SCUxMcIxiBAiQTiEUByHWFWoh/hEABA458ig8BinOHa4MzOw
Date: Mon, 28 Apr 2014 23:15:08 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: jack <jack@suse.cz>, hch <hch@infradead.org>,
        Viro <viro@zeniv.linux.org.uk>, tytso <tytso@mit.edu>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH V3 2/2] fs/ext4/fsync.c: generic_file_fsync call based on
 barrier flag
Message-Id: <20140428231508.a101532b3154e7742489abf2@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_file_fsync has been updated to issue a flush for
older filesystems.

This patch tests for barrier flag in ext4 mount flags
and calls the right function.

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/fsync.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index a8bc47f..fa82c0a 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -108,6 +108,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!journal) {
 		ret = generic_file_fsync(file, start, end, datasync);
+		if (test_opt(inode->i_sb, BARRIER))
+			ret = generic_file_fsync(file, start, end, datasync);
+		else
+			ret = __generic_file_fsync(file, start, end, datasync);
 		if (!ret && !hlist_empty(&inode->i_dentry))
 			ret = ext4_sync_parent(inode);
 		goto out;
-- 
1.8.4.5

