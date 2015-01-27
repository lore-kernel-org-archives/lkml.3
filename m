Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbbA0Mii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:38:38 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36557 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbbA0Mif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:38:35 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH v2] nbd: fix possible memory leak
Date: Tue, 27 Jan 2015 18:08:22 +0530
Message-Id: <1422362302-25252-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have already allocated memory for nbd_dev, but we were not
releasing that memory and just returning the error value.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

v2: moved kcalloc after the returns.

 drivers/block/nbd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4bc2a5c..db93c75 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -803,10 +803,6 @@ static int __init nbd_init(void)
 		return -EINVAL;
 	}
 
-	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
-	if (!nbd_dev)
-		return -ENOMEM;
-
 	part_shift = 0;
 	if (max_part > 0) {
 		part_shift = fls(max_part);
@@ -827,6 +823,10 @@ static int __init nbd_init(void)
 
 	if (nbds_max > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
+
+	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
+	if (!nbd_dev)
+		return -ENOMEM;
 
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = alloc_disk(1 << part_shift);
-- 
1.8.1.2

