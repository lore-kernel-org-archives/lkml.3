Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaBIVtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:49:07 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55183 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaBIVtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:49:05 -0500
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        keescook@chromium.org
Subject: [PATCH 3/3] lkdtm: add "WRITE_KERN" test
Date: Sun,  9 Feb 2014 13:48:48 -0800
Message-Id: <1391982528-21083-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391982528-21083-1-git-send-email-keescook@chromium.org>
References: <1391982528-21083-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "WRITE_KERN" crash target to validate that kernel executable memory
is not writable.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index d6ee1aae3e72..d30301149242 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -102,6 +102,7 @@ enum ctype {
 	CT_EXEC_USERSPACE,
 	CT_ACCESS_USERSPACE,
 	CT_WRITE_RO,
+	CT_WRITE_KERN,
 };
 
 static char* cp_name[] = {
@@ -138,6 +139,7 @@ static char* cp_type[] = {
 	"EXEC_USERSPACE",
 	"ACCESS_USERSPACE",
 	"WRITE_RO",
+	"WRITE_KERN",
 };
 
 static struct jprobe lkdtm;
@@ -317,6 +319,13 @@ static void do_nothing(void)
 	return;
 }
 
+/* Must immediately follow do_nothing for size calculuations to work out. */
+static void do_overwritten(void)
+{
+	pr_info("do_overwritten wasn't overwritten!\n");
+	return;
+}
+
 static noinline void corrupt_stack(void)
 {
 	/* Use default char array length that triggers stack protection. */
@@ -496,6 +505,22 @@ static void lkdtm_do_action(enum ctype which)
 
 		break;
 	}
+	case CT_WRITE_KERN: {
+		size_t size;
+		unsigned char *ptr;
+
+		size = (unsigned long)do_overwritten -
+		       (unsigned long)do_nothing;
+		ptr = (unsigned char *)do_overwritten;
+
+		pr_info("attempting bad %zu byte write at %p\n", size, ptr);
+		memcpy(ptr, (unsigned char *)do_nothing, size);
+		flush_icache_range((unsigned long)ptr,
+				   (unsigned long)(ptr + size));
+
+		do_overwritten();
+		break;
+	}
 	case CT_NONE:
 	default:
 		break;
-- 
1.7.9.5

