Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3KKOrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:47:19 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40874 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab3KKOrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:47:05 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2] panic: setup panic_timeout early
Date: Mon, 11 Nov 2013 08:40:14 -0600
Message-Id: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we might not reboot when the user needs it the most (early
on).

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---

This time using kstrtol() instead of get_option().

Interdiff:

diff --git a/kernel/panic.c b/kernel/panic.c
index 46e37ff..d865263 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -470,12 +470,14 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 
-static int __init set_panic_timeout(char *str)
+static int __init set_panic_timeout(char *val)
 {
-	int timeout;
+	long timeout;
+	int ret;
 
-	if (!get_option(&str, &timeout))
-		return -EINVAL;
+	ret = kstrtol(val, 0, &timeout);
+	if (ret < 0)
+		return ret;
 
 	panic_timeout = timeout;
 	return 0;

 kernel/panic.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b6c482c..d865263 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -468,9 +468,23 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 #endif
 
-core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 
+static int __init set_panic_timeout(char *val)
+{
+	long timeout;
+	int ret;
+
+	ret = kstrtol(val, 0, &timeout);
+	if (ret < 0)
+		return ret;
+
+	panic_timeout = timeout;
+	return 0;
+}
+
+early_param("panic_timeout", set_panic_timeout);
+
 static int __init oops_setup(char *s)
 {
 	if (!s)
-- 
1.8.4.2+fc1

