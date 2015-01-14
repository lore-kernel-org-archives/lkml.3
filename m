Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbbANHgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:36:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbbANHgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:36:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3.14 54/77] mtd: tests: abort torturetest on erase errors
Date: Tue, 13 Jan 2015 23:23:34 -0800
Message-Id: <20150114072227.230278504@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/tests/torturetest.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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


