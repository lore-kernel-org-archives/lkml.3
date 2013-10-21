Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3JUPVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:21:53 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62532 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3JUPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:21:49 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 2/4] staging/lustre/llite: fix mkdir endless loop
Date: Mon, 21 Oct 2013 23:18:23 +0800
Message-Id: <1382368705-4199-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382368705-4199-1-git-send-email-bergwolf@gmail.com>
References: <1382368705-4199-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running on 3.11-rc4 kernel, I got below endless loop. It turns to be that Lustre
always saves the first page of a dir inode mapping at index ~0UL.  And after
commit 5a720394 (mm: teach truncate_inode_pages_range() to handle non page
aligned ranges), truncate_inode_pages_range() _NO LONGER_ truncates the page
that is sitting at index ~0UL.

[16768.998006] mkdir           R  running task        0  2717   2716 0x00000080
[16768.998073]  000000000000000e 0000000000000000 0000000000000000 ffff88000be00460
[16768.998157]  ffff88000ea65908 ffffffff810fec3e ffff88000ea65968 ffff8800229e7750
[16768.998241]  ffff88000ea658b8 0000000000000000 0000000000000000 ffff88000ea65958
[16768.998326] Call Trace:
[16768.998401]  [<ffffffff810fc6ed>] ? rcu_read_unlock+0x1c/0x2d
[16768.998473]  [<ffffffff810fec3e>] ? find_get_pages+0xf5/0x11b
[16768.998530]  [<ffffffff811078f0>] ? pagevec_lookup+0x20/0x2a
[16768.998586]  [<ffffffff8110920e>] ? truncate_inode_pages_range.part.2+0x161/0x39a
[16768.998680]  [<ffffffffa02ad5dc>] ? ll_md_blocking_ast+0x338/0x62f [lustre]
[16768.998744]  [<ffffffff8110947f>] ? truncate_inode_pages_range+0x38/0x3f
[16768.998805]  [<ffffffff811094f8>] ? truncate_inode_pages+0x12/0x14
[16768.998871]  [<ffffffffa02ad6e8>] ? ll_md_blocking_ast+0x444/0x62f [lustre]
[16768.998948]  [<ffffffff810981b5>] ? arch_local_irq_save+0x9/0xc
[16768.999022]  [<ffffffffa07ee0e8>] ? ldlm_cancel_callback+0x67/0x12a [ptlrpc]
[16768.999100]  [<ffffffffa07f85b2>] ? ldlm_cli_cancel_local+0xf3/0x2bc [ptlrpc]
[16768.999176]  [<ffffffffa07f9163>] ? ldlm_cli_cancel_list_local+0x7e/0x1e4 [ptlrpc]
[16768.999268]  [<ffffffffa07f9473>] ? ldlm_cancel_resource_local+0x1aa/0x1b9 [ptlrpc]
[16768.999385]  [<ffffffffa0657bad>] ? mdc_resource_get_unused+0xf8/0x115 [mdc]
[16768.999472]  [<ffffffff8109c887>] ? trace_hardirqs_on+0xd/0xf
[16768.999533]  [<ffffffffa06583d8>] ? mdc_create+0x11e/0x4db [mdc]
[16768.999597]  [<ffffffff8152ed84>] ? mutex_unlock+0xe/0x10
[16768.999654]  [<ffffffffa0350e99>] ? lmv_create+0x355/0x3e9 [lmv]
[16768.999712]  [<ffffffff811553b7>] ? final_putname+0x35/0x39
[16768.999775]  [<ffffffffa02ae167>] ? ll_new_node+0x33b/0x3ff [lustre]
[16768.999841]  [<ffffffffa02ae62c>] ? ll_mkdir+0xf2/0x127 [lustre]
[16768.999897]  [<ffffffff81156996>] ? vfs_mkdir+0x84/0xc9
[16768.999961]  [<ffffffff81158cf8>] ? SyS_mkdirat+0x77/0xad
[16769.000014]  [<ffffffff81158d47>] ? SyS_mkdir+0x19/0x1b
[16769.000066]  [<ffffffff81538652>] ? system_call_fastpath+0x16/0x1b

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/include/lustre_lite.h    |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_lite.h b/drivers/staging/lustre/lustre/include/lustre_lite.h
index 25f8bfa..beccb5e 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lite.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lite.h
@@ -139,7 +139,11 @@ static inline unsigned long hash_x_index(__u64 hash, int hash64)
 {
 	if (BITS_PER_LONG == 32 && hash64)
 		hash >>= 32;
-	return ~0UL - hash;
+	/* save hash 0 as index 0 because otherwise we'll save it at
+	 * page index end (~0UL) and it causes truncate_inode_pages_range()
+	 * to loop forever.
+	 */
+	return ~0UL - (hash + !hash);
 }
 
 /** @} lite */
-- 
1.7.9.5

