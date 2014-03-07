Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaCGVvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:51:51 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:27889 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbaCGVvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:51:50 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlIGAN4+GlNXQ5vB/2dsb2JhbABagwbCQYEXF3SCUxMcIxiBAiQTh30B0C2OW4Q/AQOYQgGSK4MuPA
Date: Fri, 7 Mar 2014 22:51:47 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: sage <sage@inktank.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/ceph/super.c: Undefined field set to 0 +
 clean-up
Message-Id: <20140307225147.84632d2ad186e657af4e9812@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-statfs(2) /undefined
-Don't recalculate f_frsize and f_bavail.
-Remove ?? comment.
-Use defined CEPH_BLOCK.
-Directly work with >> 12 for 4Kb conversions (like in dir.c)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ceph/super.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 10a4ccb..7ceecd8 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -67,7 +67,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 		return err;
 
 	/* fill in kstatfs */
-	buf->f_type = CEPH_SUPER_MAGIC;  /* ?? */
+	buf->f_type = CEPH_SUPER_MAGIC;
 
 	/*
 	 * express utilization in terms of large blocks to avoid
@@ -78,14 +78,14 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 * Someday, we will probably want to report a real block
 	 * size...  whatever that may mean for a network file system!
 	 */
-	buf->f_bsize = 1 << CEPH_BLOCK_SHIFT;
-	buf->f_frsize = 1 << CEPH_BLOCK_SHIFT;
-	buf->f_blocks = le64_to_cpu(st.kb) >> (CEPH_BLOCK_SHIFT-10);
-	buf->f_bfree = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
-	buf->f_bavail = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
+	buf->f_bsize = CEPH_BLOCK;
+	buf->f_frsize = buf->f_bsize;
+	buf->f_blocks = le64_to_cpu(st.kb) >> 12;
+	buf->f_bfree = le64_to_cpu(st.kb_avail) >> 12;
+	buf->f_bavail = buf->f_bfree;
 
 	buf->f_files = le64_to_cpu(st.num_objects);
-	buf->f_ffree = -1;
+	buf->f_ffree = 0;
 	buf->f_namelen = NAME_MAX;
 
 	/* leave fsid little-endian, regardless of host endianness */
-- 
1.8.1.4
