Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3KOToa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:44:30 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35197 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3KOToW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:44:22 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v3] panic: setup panic_timeout early
Date: Fri, 15 Nov 2013 13:37:22 -0600
Message-Id: <1384544242-8602-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we might not reboot when the user needs it the most (early
on).

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---

Since v2:

There's no need for a temporary variable because kstrtoint() is already taking
care of that (if there's an error panic_timeout is not updated).

diff --git a/kernel/panic.c b/kernel/panic.c
index d865263..fa3c187 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -472,15 +472,7 @@ core_param(pause_on_oops, pause_on_oops, int, 0644);
 
 static int __init set_panic_timeout(char *val)
 {
-	long timeout;
-	int ret;
-
-	ret = kstrtol(val, 0, &timeout);
-	if (ret < 0)
-		return ret;
-
-	panic_timeout = timeout;
-	return 0;
+	return kstrtoint(val, 0, &panic_timeout);
 }
 
 early_param("panic_timeout", set_panic_timeout);

 kernel/panic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b6c482c..fa3c187 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -468,9 +468,15 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 #endif
 
-core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 
+static int __init set_panic_timeout(char *val)
+{
+	return kstrtoint(val, 0, &panic_timeout);
+}
+
+early_param("panic_timeout", set_panic_timeout);
+
 static int __init oops_setup(char *s)
 {
 	if (!s)
-- 
1.8.4.2+fc1

