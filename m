Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaAFNMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:12:47 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25869 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaAFNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:12:33 -0500
X-IronPort-AV: E=Sophos;i="4.95,612,1384329600"; 
   d="scan'208";a="7867308"
From: Kamlakant Patel <kamlakant.patel@broadcom.com>
To: <linux-mtd@lists.infradead.org>
CC: Kamlakant Patel <kamlakant.patel@broadcom.com>, <dwmw2@infradead.org>,
        <linux-kernel@vger.kernel.org>, Jayachandran C <jchandra@broadcom.com>
Subject: [PATCH 1/2] jffs2: Fix segmentation fault found in stress test
Date: Mon, 6 Jan 2014 19:06:54 +0530
Message-ID: <1389015415-25196-1-git-send-email-kamlakant.patel@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creating a large file on a JFFS2 partition sometimes crashes with this call
trace:

[  306.476000] CPU 13 Unable to handle kernel paging request at virtual address c0000000dfff8002, epc == ffffffffc03a80a8, ra == ffffffffc03a8044
[  306.488000] Oops[#1]:
[  306.488000] Cpu 13
[  306.492000] $ 0   : 0000000000000000 0000000000000000 0000000000008008 0000000000008007
[  306.500000] $ 4   : c0000000dfff8002 000000000000009f c0000000e0007cde c0000000ee95fa58
[  306.508000] $ 8   : 0000000000000001 0000000000008008 0000000000010000 ffffffffffff8002
[  306.516000] $12   : 0000000000007fa9 000000000000ff0e 000000000000ff0f 80e55930aebb92bb
[  306.524000] $16   : c0000000e0000000 c0000000ee95fa5c c0000000efc80000 ffffffffc09edd70
[  306.532000] $20   : ffffffffc2b60000 c0000000ee95fa58 0000000000000000 c0000000efc80000
[  306.540000] $24   : 0000000000000000 0000000000000004
[  306.548000] $28   : c0000000ee950000 c0000000ee95f738 0000000000000000 ffffffffc03a8044
[  306.556000] Hi    : 00000000000574a5
[  306.560000] Lo    : 6193b7a7e903d8c9
[  306.564000] epc   : ffffffffc03a80a8 jffs2_rtime_compress+0x98/0x198
[  306.568000]     Tainted: G        W
[  306.572000] ra    : ffffffffc03a8044 jffs2_rtime_compress+0x34/0x198
[  306.580000] Status: 5000f8e3    KX SX UX KERNEL EXL IE
[  306.584000] Cause : 00800008
[  306.588000] BadVA : c0000000dfff8002
[  306.592000] PrId  : 000c1100 (Netlogic XLP)
[  306.596000] Modules linked in:
[  306.596000] Process dd (pid: 170, threadinfo=c0000000ee950000, task=c0000000ee6e0858, tls=0000000000c47490)
[  306.608000] Stack : 7c547f377ddc7ee4 7ffc7f967f5d7fae 7f617f507fc37ff4 7e7d7f817f487f5f
        7d8e7fec7ee87eb3 7e977ff27eec7f9e 7d677ec67f917f67 7f3d7e457f017ed7
        7fd37f517f867eb2 7fed7fd17ca57e1d 7e5f7fe87f257f77 7fd77f0d7ede7fdb
        7fba7fef7e197f99 7fde7fe07ee37eb5 7f5c7f8c7fc67f65 7f457fb87f847e93
        7f737f3e7d137cd9 7f8e7e9c7fc47d25 7dbb7fac7fb67e52 7ff17f627da97f64
        7f6b7df77ffa7ec5 80057ef17f357fb3 7f767fa27dfc7fd5 7fe37e8e7fd07e53
        7e227fcf7efb7fa1 7f547e787fa87fcc 7fcb7fc57f5a7ffb 7fc07f6c7ea97e80
        7e2d7ed17e587ee0 7fb17f9d7feb7f31 7f607e797e887faa 7f757fdd7c607ff3
        7e877e657ef37fbd 7ec17fd67fe67ff7 7ff67f797ff87dc4 7eef7f3a7c337fa6
        7fe57fc97ed87f4b 7ebe7f097f0b8003 7fe97e2a7d997cba 7f587f987f3c7fa9
        ...
[  306.676000] Call Trace:
[  306.680000] [<ffffffffc03a80a8>] jffs2_rtime_compress+0x98/0x198
[  306.684000] [<ffffffffc0394f10>] jffs2_selected_compress+0x110/0x230
[  306.692000] [<ffffffffc039508c>] jffs2_compress+0x5c/0x388
[  306.696000] [<ffffffffc039dc58>] jffs2_write_inode_range+0xd8/0x388
[  306.704000] [<ffffffffc03971bc>] jffs2_write_end+0x16c/0x2d0
[  306.708000] [<ffffffffc01d3d90>] generic_file_buffered_write+0xf8/0x2b8
[  306.716000] [<ffffffffc01d4e7c>] __generic_file_aio_write+0x1ac/0x350
[  306.720000] [<ffffffffc01d50a0>] generic_file_aio_write+0x80/0x168
[  306.728000] [<ffffffffc021f7dc>] do_sync_write+0x94/0xf8
[  306.732000] [<ffffffffc021ff6c>] vfs_write+0xa4/0x1a0
[  306.736000] [<ffffffffc02202e8>] SyS_write+0x50/0x90
[  306.744000] [<ffffffffc0116cc0>] handle_sys+0x180/0x1a0
[  306.748000]
[  306.748000]
Code: 020b202d  0205282d  90a50000 <90840000> 14a40038  00000000  0060602d  0000282d  016c5823
[  306.760000] ---[ end trace 79dd088435be02d0 ]---
Segmentation fault

This crash is caused because the 'positions' is declared as an array of signed
short. The value of position is in the range 0..65535, and will be converted
to a negative number when the position is greater than 32767 and causes a
corruption and crash. Changing the definition to 'unsigned short' fixes this
issue

Signed-off-by: Jayachandran C <jchandra@broadcom.com>
Signed-off-by: Kamlakant Patel <kamlakant.patel@broadcom.com>
---
 fs/jffs2/compr_rtime.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jffs2/compr_rtime.c b/fs/jffs2/compr_rtime.c
index 16a5047..406d9cc 100644
--- a/fs/jffs2/compr_rtime.c
+++ b/fs/jffs2/compr_rtime.c
@@ -33,7 +33,7 @@ static int jffs2_rtime_compress(unsigned char *data_in,
 				unsigned char *cpage_out,
 				uint32_t *sourcelen, uint32_t *dstlen)
 {
-	short positions[256];
+	unsigned short positions[256];
 	int outpos = 0;
 	int pos=0;
 
@@ -74,7 +74,7 @@ static int jffs2_rtime_decompress(unsigned char *data_in,
 				  unsigned char *cpage_out,
 				  uint32_t srclen, uint32_t destlen)
 {
-	short positions[256];
+	unsigned short positions[256];
 	int outpos = 0;
 	int pos=0;
 
-- 
1.8.1.3

