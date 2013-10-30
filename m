Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3J3Lp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:45:28 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63316 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3J3LpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:25 -0400
X-Nat-Received: from [202.181.97.72]:57505 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1383133512.16657
To: jack@suse.cz, mike.marciniszyn@intel.com, roland@purestorage.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH linux-next-20131029] IB/ipath: Fix random stack overflow.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201310302045.AEH12985.FSOOJOQLHFtMFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 30 Oct 2013 20:45:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 30102013 #10426834, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bbba584a502b9417af06e4a55401c013a7e90eb1 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 30 Oct 2013 16:12:58 +0900
Subject: [PATCH linux-next-20131029] IB/ipath: Fix random stack overflow.

Commit 18fec3c6 "IB/ipath: Convert ipath_user_sdma_pin_pages() to use
get_user_pages_fast()" requested for undefined number of pages with buffer for
2 pages.

  drivers/infiniband/hw/ipath/ipath_user_sdma.c: In function 'ipath_user_sdma_pin_pages':
  drivers/infiniband/hw/ipath/ipath_user_sdma.c:283: warning: 'j' is used uninitialized in this function

ipath_user_sdma_pin_pages() assumes that npages is either 1 or 2 because
ipath_user_sdma_queue_pkts() checks that 0 < iov->iov_len <= PAGE_SIZE
which lets ipath_user_sdma_num_pages() return either 1 or 2.

Please check whether commit 18fec3c6 was backported
because that commit has "Cc: <stable@vger.kernel.org>" line.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.c b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
index 06cbfd4..cc04b7b 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -280,7 +280,7 @@ static int ipath_user_sdma_pin_pages(const struct ipath_devdata *dd,
 	int j;
 	int ret;
 
-	ret = get_user_pages_fast(addr, j, 0, pages);
+	ret = get_user_pages_fast(addr, npages, 0, pages);
 	if (ret != npages) {
 		int i;
 
-- 
1.7.1
