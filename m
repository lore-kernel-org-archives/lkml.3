Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaBHCQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 21:16:18 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:41496 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaBHCQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 21:16:16 -0500
Message-ID: <52F59365.5090001@huawei.com>
Date: Sat, 8 Feb 2014 10:16:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
        <linux-mtd@lists.infradead.org>
Subject: [PATCH 3/3] jffs2: remove wait queue after schedule()
References: <52F592F2.6010008@huawei.com>
In-Reply-To: <52F592F2.6010008@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@wait is a local variable, so if we don't remove it from the wait queue
list, later wake_up() may end up accessing invalid memory.

This was spotted by eyes.

Cc: <stable@vger.kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/jffs2/nodemgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index fb30161..610a22c 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -179,6 +179,7 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 					spin_unlock(&c->erase_completion_lock);
 
 					schedule();
+					remove_wait_queue(&c->erase_wait, &wait);
 				} else
 					spin_unlock(&c->erase_completion_lock);
 			} else if (ret)
-- 
1.8.0.2

