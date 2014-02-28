Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaB1CND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:13:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37928 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB1CNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:13:00 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-bf-530ff0a91068
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH] f2fs: fix dirty page accounting when redirty
Date: Fri, 28 Feb 2014 10:12:05 +0800
Message-id: <000001cf342a$95864830$c092d890$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac80KB2pPVC0MC+AQFCPZKSJB1syhA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd2VH/iDDbYe5re4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PU+neMBUv5Ku5N
	XMTWwPiRu4uRk0NCwESie+ZGRghbTOLCvfVsILaQwHRGiVNvKyHsH4wS3StLQWw2ARWJ5R3/
	mUBsEQFFiQ3vN7CD2MwCmRJzXk9mBbGFBTwkHs28BjaHRUBV4uGyc8wgNq+ApcTe1T+gbEGJ
	H5PvsUD0akms33mcCcKWl9i85i0zxD0KEjvOvmaE2KUn8eH9Q6gacYmNR26xTGAUmIVk1Cwk
	o2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFh/Ex6B+OqBotDjAIcjEo8
	vBM8+YOFWBPLiitzDzFKcDArifD6zgEK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCe
	WJKanZpakFoEk2Xi4JRqYOxkeq7tIGcyrz7w0qkan5kmrsWVjHflIrJz109/aTbDbWrH/suH
	Zd1ET+fam8wszd6wjPnEQv8vna82P5PiCuGtdPAJb3gV/X3b2VChxM2fDkx0zSn56/ftjd2l
	E7VLNBkf3ZAK7e6W2Nwk88H56O7774Nfz/u9xa7ikVzo25etx4ocfiaXv1ViKc5INNRiLipO
	BACyK+bsXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should de-account dirty counters for page when redirty in ->writepage().

Wu Fengguang described in 'commit 971767caf632190f77a40b4011c19948232eed75':
"writeback: fix dirtied pages accounting on redirty
De-account the accumulative dirty counters on page redirty.

Page redirties (very common in ext4) will introduce mismatch between
counters (a) and (b)

a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
b) NR_WRITTEN, BDI_WRITTEN

This will introduce systematic errors in balanced_rate and result in
dirty page position errors (ie. the dirty pages are no longer balanced
around the global/bdi setpoints)."

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |    1 +
 fs/f2fs/data.c       |    1 +
 fs/f2fs/node.c       |    1 +
 3 files changed, 3 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index c8516ee..f069249 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -178,6 +178,7 @@ no_write:
 redirty_out:
 	dec_page_count(sbi, F2FS_DIRTY_META);
 	wbc->pages_skipped++;
+	account_page_redirty(page);
 	set_page_dirty(page);
 	return AOP_WRITEPAGE_ACTIVATE;
 }
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 93d80ea..101b4cd 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -839,6 +839,7 @@ out:
 
 redirty_out:
 	wbc->pages_skipped++;
+	account_page_redirty(page);
 	set_page_dirty(page);
 	return AOP_WRITEPAGE_ACTIVATE;
 }
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1f9cf21..8c14110 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1193,6 +1193,7 @@ static int f2fs_write_node_page(struct page *page,
 redirty_out:
 	dec_page_count(sbi, F2FS_DIRTY_NODES);
 	wbc->pages_skipped++;
+	account_page_redirty(page);
 	set_page_dirty(page);
 	return AOP_WRITEPAGE_ACTIVATE;
 }
-- 
1.7.9.5

