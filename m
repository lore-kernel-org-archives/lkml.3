Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaAMQ0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:26:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53491 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaAMQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Whitney <enwlinux@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 141/208] ext4: fix bigalloc regression
Date: Mon, 13 Jan 2014 15:59:42 +0000
Message-Id: <1389628849-1614-142-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Whitney <enwlinux@gmail.com>

commit d0abafac8c9162f39c4f6b2f8141b772a09b3770 upstream.

Commit f5a44db5d2 introduced a regression on filesystems created with
the bigalloc feature (cluster size > blocksize).  It causes xfstests
generic/006 and /013 to fail with an unexpected JBD2 failure and
transaction abort that leaves the test file system in a read only state.
Other xfstests run on bigalloc file systems are likely to fail as well.

The cause is the accidental use of a cluster mask where a cluster
offset was needed in ext4_ext_map_blocks().

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f8d6668..878338f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4145,7 +4145,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
 	newex.ee_block = cpu_to_le32(map->m_lblk);
-	cluster_offset = EXT4_LBLK_CMASK(sbi, map->m_lblk);
+	cluster_offset = EXT4_LBLK_COFF(sbi, map->m_lblk);
 
 	/*
 	 * If we are doing bigalloc, check to see if the extent returned
-- 
1.8.3.2

