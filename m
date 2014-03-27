Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaC0Wgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 18:36:50 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:61715 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756879AbaC0Wgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 18:36:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlIOAPCmNFNXQyx2/2dsb2JhbABZgwbDbAICgRkXdIJTExwjGIECJBOHfQHRZ456hD8EmEwBiluHWYMwPA
Date: Thu, 27 Mar 2014 23:38:31 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, "fengguang.wu" <fengguang.wu@intel.com>
Subject: [PATCH linux-next v2] ufs: sb mutex merge + mutex_destroy: fix
Message-Id: <20140327233831.c32f99a8fbabb31a5e37e598@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mutex_destroy was also called when trying to mount volume in read/write
without write support enabled.

Reported by Fengguang Wu.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
v2: failed_noreadwrite is only used with CONFIG_UFS_FS_WRITE
    -> add ifndef

 fs/ufs/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index d05cf89..432baa1 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -798,7 +798,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		goto failed;
+		goto failed_noreadwrite;
 	}
 #endif
 	mutex_init(&sbi->mutex);
@@ -1255,10 +1255,14 @@ magic_found:
 	return 0;
 
 failed:
+	mutex_destroy(&sbi->mutex);
+
+#ifndef CONFIG_UFS_FS_WRITE
+failed_noreadwrite:
+#endif
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
-	mutex_destroy(&sbi->mutex);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
-- 
1.8.4.5

