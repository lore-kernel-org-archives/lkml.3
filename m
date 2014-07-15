Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaGOBFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:05:38 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62213 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaGOBFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:05:34 -0400
Message-ID: <53C47E59.8030502@gmail.com>
Date: Tue, 15 Jul 2014 09:05:29 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
CC: linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/ext4/super.c: Let 'counters' switched by SMP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SMP is disabled, 'struct percpu_counter' has no 'counters' member,
so need skip it when in !SMP.

The related git commit:

  "feab139 ext4: rearrange initialization to fix EXT4FS_DEBUG".

The related error (with allmodconfig under score):

    CC [M]  fs/ext4/super.o
  fs/ext4/super.c: In function 'ext4_commit_super':
  fs/ext4/super.c:4546:41: error: 'struct percpu_counter' has no member named 'counters'
    if (EXT4_SB(sb)->s_freeclusters_counter.counters)
                                           ^
  fs/ext4/super.c:4550:39: error: 'struct percpu_counter' has no member named 'counters'
    if (EXT4_SB(sb)->s_freeinodes_counter.counters)
                                         ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 fs/ext4/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 30767cd..3cd4fe1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4543,11 +4543,15 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	else
 		es->s_kbytes_written =
 			cpu_to_le64(EXT4_SB(sb)->s_kbytes_written);
+#ifdef CONFIG_SMP
 	if (EXT4_SB(sb)->s_freeclusters_counter.counters)
+#endif
 		ext4_free_blocks_count_set(es,
 			EXT4_C2B(EXT4_SB(sb), percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeclusters_counter)));
+#ifdef CONFIG_SMP
 	if (EXT4_SB(sb)->s_freeinodes_counter.counters)
+#endif
 		es->s_free_inodes_count =
 			cpu_to_le32(percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeinodes_counter));
-- 
1.9.2.459.g68773ac
