Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaAOTb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:31:26 -0500
Received: from mail.windriver.com ([147.11.1.11]:37777 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaAOTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:31:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Colin Cross <ccross@android.com>, Jesse Barker <jesse.barker@arm.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: don't use module_init in non-modular ion_dummy_driver.c
Date: Wed, 15 Jan 2014 14:30:41 -0500
Message-ID: <1389814241-26016-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ION_DUMMY option is bool, and hence this code is either
present or absent.  It will never be modular, so using
module_init as an alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of device_initcall
directly in this change means that the runtime impact is
zero -- it will remain at level 6 in initcall ordering.

Cc: Colin Cross <ccross@android.com>
Cc: Jesse Barker <jesse.barker@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 55b2002753f2..8e7f8912af46 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
 #include <linux/sizes.h>
@@ -128,6 +129,7 @@ err:
 	}
 	return err;
 }
+device_initcall(ion_dummy_init);
 
 static void __exit ion_dummy_exit(void)
 {
@@ -152,7 +154,4 @@ static void __exit ion_dummy_exit(void)
 
 	return;
 }
-
-module_init(ion_dummy_init);
-module_exit(ion_dummy_exit);
-
+__exitcall(ion_dummy_exit);
-- 
1.8.5.2

