Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbbA2C7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:59:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965316AbbA2CiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Norris <computersforpeace@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 117/139] mtd: tests: abort torturetest on erase errors
Date: Wed, 28 Jan 2015 14:21:00 -0800
Message-Id: <1422483682-15393-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit 68f29815034e9dc9ed53cad85946c32b07adc8cc upstream.

The torture test should quit once it actually induces an error in the
flash. This step was accidentally removed during refactoring.

Without this fix, the torturetest just continues infinitely, or until
the maximum cycle count is reached. e.g.:

   ...
   [ 7619.218171] mtd_test: error -5 while erasing EB 100
   [ 7619.297981] mtd_test: error -5 while erasing EB 100
   [ 7619.377953] mtd_test: error -5 while erasing EB 100
   [ 7619.457998] mtd_test: error -5 while erasing EB 100
   [ 7619.537990] mtd_test: error -5 while erasing EB 100
   ...

Fixes: 6cf78358c94f ("mtd: mtd_torturetest: use mtd_test helpers")
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/tests/torturetest.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/tests/torturetest.c b/drivers/mtd/tests/torturetest.c
index eeab969..b55bc52 100644
--- a/drivers/mtd/tests/torturetest.c
+++ b/drivers/mtd/tests/torturetest.c
@@ -264,7 +264,9 @@ static int __init tort_init(void)
 		int i;
 		void *patt;
 
-		mtdtest_erase_good_eraseblocks(mtd, bad_ebs, eb, ebcnt);
+		err = mtdtest_erase_good_eraseblocks(mtd, bad_ebs, eb, ebcnt);
+		if (err)
+			goto out;
 
 		/* Check if the eraseblocks contain only 0xFF bytes */
 		if (check) {
-- 
1.9.1

