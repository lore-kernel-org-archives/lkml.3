Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965228AbaGCJ3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:29:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52629 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbaGCJZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 184/198] target: Explicitly clear ramdisk_mcp backend pages
Date: Thu,  3 Jul 2014 10:20:27 +0100
Message-Id: <1404379241-8590-185-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes rd_allocate_sgl_table() to explicitly clear
ramdisk_mcp backend memory pages by passing __GFP_ZERO into
alloc_pages().

This addresses a potential security issue where reading from a
ramdisk_mcp could return sensitive information, and follows what
>= v3.15 does to explicitly clear ramdisk_mcp memory at backend
device initialization time.

[ Note that a different patch to address the same issue went in during
  v3.15-rc1 (commit 4442dc8a), but includes a bunch of other changes that
  don't strictly apply to fixing the bug.

  This is a one-liner that addresses the bug for all <= v3.14 versions. ]

Reported-by: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>
Cc: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_rd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 51127d15d5c5..d71cdbed413b 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -179,7 +179,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-- 
1.9.1

