Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaHYQ53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:57:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbaHYQzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:55:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 06/13] target: Explicitly clear ramdisk_mcp backend pages
Date: Mon, 25 Aug 2014 09:54:52 -0700
Message-Id: <1408985699-31838-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408985699-31838-1-git-send-email-kamal@canonical.com>
References: <1408985699-31838-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

[Note that a different patch to address the same issue went in during
v3.15-rc1 (commit 4442dc8a), but includes a bunch of other changes that
don't strictly apply to fixing the bug.]

This patch changes rd_allocate_sgl_table() to explicitly clear
ramdisk_mcp backend memory pages by passing __GFP_ZERO into
alloc_pages().

This addresses a potential security issue where reading from a
ramdisk_mcp could return sensitive information, and follows what
>= v3.15 does to explicitly clear ramdisk_mcp memory at backend
device initialization time.

Reported-by: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>
Cc: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Reference: CVE-2014-4027
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_rd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 0457de3..51968ed 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -174,7 +174,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-- 
1.9.1

