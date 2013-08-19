Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab3HSR1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:27:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51146 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3HSR0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:26:24 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V2 08/10] kexec: Disable at runtime if the kernel enforces module loading restrictions
Date: Mon, 19 Aug 2013 13:26:09 -0400
Message-Id: <1376933171-9854-9-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec permits the loading and execution of arbitrary code in ring 0, which
is something that module signing enforcement is meant to prevent. It makes
sense to disable kexec in this situation.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/kexec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f7b55..1a7690f 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1645,6 +1646,9 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	if (secure_modules())
+		return -EPERM;
+
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		lock_system_sleep();
-- 
1.8.3.1

