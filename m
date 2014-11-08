Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaKHQRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 11:17:31 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58753 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaKHQR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 11:17:29 -0500
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Subject: [PATCH] Fix entering suspend-to-IDLE if no freeze_oops is set
Date: Sat,  8 Nov 2014 19:17:13 +0300
Message-Id: <1415463433-5267-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no freeze_ops is set, trying to enter suspend-to-IDLE will cause a
nice oops in platform_suspend_prepare_late(). Add respective checks to
platform_suspend_prepare_late() and platform_resume_early() functions.

Fixes: a8d46b9e (ACPI / sleep: Rework the handling of ACPI GPE wakeup ...)
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 kernel/power/suspend.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4ca9a33..c347e3c 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -146,7 +146,7 @@ static int platform_suspend_prepare(suspend_state_t state)
 
 static int platform_suspend_prepare_late(suspend_state_t state)
 {
-	return state == PM_SUSPEND_FREEZE && freeze_ops->prepare ?
+	return state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->prepare ?
 		freeze_ops->prepare() : 0;
 }
 
@@ -164,7 +164,7 @@ static void platform_resume_noirq(suspend_state_t state)
 
 static void platform_resume_early(suspend_state_t state)
 {
-	if (state == PM_SUSPEND_FREEZE && freeze_ops->restore)
+	if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->restore)
 		freeze_ops->restore();
 }
 
-- 
2.1.1

