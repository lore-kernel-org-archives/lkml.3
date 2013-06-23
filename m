Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3FWRNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 13:13:21 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44532 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3FWRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 13:13:19 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Cc: <raghavendra.kt@linux.vnet.ibm.com>
Date: Sun, 23 Jun 2013 22:47:11 +0530
Message-Id: <20130623171711.7127.16248.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH] block:Remove extra condition in end of disk check
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062317-5140-0000-0000-0000036AD5AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Since #sector is always positive the reduced condition check
encompasses maxsector < nr_sectors check.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
An userspace program looping with:
maxsector - 0-9999
nr_sector - 0-999
sector - 0-999 gave 6.4% improvement with new condition though I agree that
it is not the best way to test it perhaps :)

diff --git a/block/blk-core.c b/block/blk-core.c
index 33c33bc..4a78583 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1656,7 +1656,7 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
 	if (maxsector) {
 		sector_t sector = bio->bi_sector;
 
-		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
+		if (maxsector - nr_sectors < sector) {
 			/*
 			 * This may well happen - the kernel calls bread()
 			 * without checking the size of the device, e.g., when

