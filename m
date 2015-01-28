Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbbA2Joc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:44:32 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44829 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752259AbbA2JE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:56 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brian Norris <computersforpeace@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 043/176] mtd: tests: abort torturetest on erase errors
Date: Wed, 28 Jan 2015 15:27:53 +0100
Message-Id: <a3c563629b22bdf1fc61a294dcc345d341f41e9e.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Norris <computersforpeace@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mtd/tests/torturetest.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/tests/torturetest.c b/drivers/mtd/tests/torturetest.c
index eeab96973cf0..b55bc52a1340 100644
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
2.2.2

