Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3BRJMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:12:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38177 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3BRJMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:12:33 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] param, charp: Cache val length
Date: Mon, 18 Feb 2013 10:12:30 +0100
Message-Id: <1361178750-17915-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... instead of doing strlen twice.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/params.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index ed35345be536..d9401d66f5be 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -262,7 +262,10 @@ STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
-	if (strlen(val) > 1024) {
+	unsigned len;
+
+	len = strlen(val);
+	if (len > 1024) {
 		pr_err("%s: string parameter too long\n", kp->name);
 		return -ENOSPC;
 	}
@@ -272,7 +275,7 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 	/* This is a hack.  We can't kmalloc in early boot, and we
 	 * don't need to; this mangled commandline is preserved. */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(strlen(val)+1);
+		*(char **)kp->arg = kmalloc_parameter(len + 1);
 		if (!*(char **)kp->arg)
 			return -ENOMEM;
 		strcpy(*(char **)kp->arg, val);
-- 
1.8.1.3.535.ga923c31

