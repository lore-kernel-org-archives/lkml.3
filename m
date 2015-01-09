Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbbAIVUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:20:00 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:5066 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbbAIVT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:19:59 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsQAKBFsFRR9MI3/2dsb2JhbABcgwaBKrM2BwIBAQUBd5c6gRZEAQEBAQF9hDovI4EaNxuIFQG8ZI4ZhgWJdB2EEwWOF4kskXQigUUBOR+BUT0xgkMBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/affs/file.c: fix direct IO writes beyond EOF
Date: Fri,  9 Jan 2015 22:19:43 +0100
Message-Id: <1420838383-6638-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the same fallback to normal IO in case of write
operations beyond EOF as fat direct IO. This patch fixes

fsx file -d -Z -r 4096 -w 4096

Report:
129(129 mod 256): TRUNCATE DOWN from 0x3ff01 to 0xb3f6
130(130 mod 256): WRITE    0x22000 thru 0x2dfff (0xc000 bytes) HOLE

Thanks to Jan for helping me on this problem.

Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
Ideal solution suggested by Jan Kara would be to use cont_write_begin but
 affs direct_IO shouldn't be used a lot anyway...

 fs/affs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 7e83ba2..d2468bf 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -398,6 +398,13 @@ affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
+	if (rw == WRITE) {
+		loff_t size = offset + count;
+
+		if (AFFS_I(inode)->mmu_private < size)
+			return 0;
+	}
+
 	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, affs_get_block);
 	if (ret < 0 && (rw & WRITE))
 		affs_write_failed(mapping, offset + count);
-- 
2.1.0

