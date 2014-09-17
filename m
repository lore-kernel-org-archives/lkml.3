Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaIQO6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:58:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:54669 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaIQO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:58:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Russell King <linux@arm.linux.org.uk>
CC: Dinh Nguyen <dinh.linux@gmail.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Dinh Nguyen <dinguyen@altera.com>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <arm@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Revert "init: make rootdelay=N consistent with rootwait behaviour"
Date: Wed, 17 Sep 2014 10:57:45 -0400
Message-ID: <1410965865-5547-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <20140917142542.GA5225@windriver.com>
References: <20140917142542.GA5225@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 4dfe694f616e00e6fd83e5bbcd7a3c4d7113493d.

In that, we did:

  Here we move the rootdelay code to be right beside the rootwait code, so
  that their behaviour is consistent.

...which is fine, but in hindsight, perhaps moving the rootwait to be
beside the rootdelay would have been better.  We also indicated:

  It should be noted that in doing so, the actions based on the
  saved_root_name[0] and initrd_load() were previously put on hold by
  rootdelay=N and now currently will not be delayed.  However, I think
  consistent behaviour is more important than matching historical behaviour
  of delaying the above two operations.

But Pavel reported an instance where an ARM target with root on MMC
was failing to mount root, and Russell diagnosed it to the fact that
the call to set ROOT_DEV within the saved_root_name[0] processing
block mentioned above was no longer being delayed.

Rather than moving both wait clauses to the original position of
rootdelay and risking unearthing other possible corner case breakage
at this point in time, we simply revert now and we can revisit
trying the alternate/earlier location in another development cycle.

Cc: Pavel Machek <pavel@denx.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/init/do_mounts.c b/init/do_mounts.c
index b6237c31b0e2..82f22885c87e 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -539,6 +539,12 @@ void __init prepare_namespace(void)
 {
 	int is_floppy;
 
+	if (root_delay) {
+		printk(KERN_INFO "Waiting %d sec before mounting root device...\n",
+		       root_delay);
+		ssleep(root_delay);
+	}
+
 	/*
 	 * wait for the known devices to complete their probing
 	 *
@@ -565,12 +571,6 @@ void __init prepare_namespace(void)
 	if (initrd_load())
 		goto out;
 
-	if (root_delay) {
-		pr_info("Waiting %d sec before mounting root device...\n",
-			root_delay);
-		ssleep(root_delay);
-	}
-
 	/* wait for any asynchronous scanning to complete */
 	if ((ROOT_DEV == 0) && root_wait) {
 		printk(KERN_INFO "Waiting for root device %s...\n",
-- 
1.9.2

