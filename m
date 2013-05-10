Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3EJSsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:48:39 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2171 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab3EJSsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:48:37 -0400
Subject: [PATCH] IDE: bugfix of IDE PIO size calculation
To: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: <davem@davemloft.net>
Date: Fri, 10 May 2013 11:47:11 -0700
Message-ID: <20130510184711.32151.70337.stgit@linux-yegoshin>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SEF-Processed: 7_3_0_01181__2013_05_10_19_48_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IDE PIO calculates size wrong.
Proven by test on MIPS Malta platform with multiple CPU types
with bootparam flag "ide-core.nodma=0.0".

It is still needed to test non-DMA IO.

Change-Id: Id82c2bc5965d85960846db53d84846d9a05d75a3
Author: Leonid Yegoshin <yegoshin@mips.com>
Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
(imported from commit 43cee988ce0aa8d2ca1eec014d25f014e95eefe6)
(imported from commit d74805b8b12cada05df811e112eb7e3ec197d565)
---
 drivers/ide/ide-taskfile.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 729428e..dabb88b 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -239,9 +239,6 @@ void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
 		unsigned nr_bytes = min(len, cursg->length - cmd->cursg_ofs);
 		int page_is_high;
 
-		if (nr_bytes > PAGE_SIZE)
-			nr_bytes = PAGE_SIZE;
-
 		page = sg_page(cursg);
 		offset = cursg->offset + cmd->cursg_ofs;
 
@@ -249,6 +246,8 @@ void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
 		page = nth_page(page, (offset >> PAGE_SHIFT));
 		offset %= PAGE_SIZE;
 
+		nr_bytes = min_t(unsigned, nr_bytes, (PAGE_SIZE - offset));
+
 		page_is_high = PageHighMem(page);
 		if (page_is_high)
 			local_irq_save(flags);


