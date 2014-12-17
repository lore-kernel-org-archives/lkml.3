Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaLQWsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:48:43 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36563 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaLQWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:48:42 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH resend] x86, tls: Don't validate lm in set_thread_area after all
Date: Wed, 17 Dec 2014 14:48:30 -0800
Message-Id: <d7875b60e28c512f6a6fc0baf5714d58e7eaadbb.1418856405.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that there's a lurking ABI issue.  GCC, when compiling
this in a 32-bit program:

struct user_desc desc = {
	.entry_number    = idx,
	.base_addr       = base,
	.limit           = 0xfffff,
	.seg_32bit       = 1,
	.contents        = 0, /* Data, grow-up */
	.read_exec_only  = 0,
	.limit_in_pages  = 1,
	.seg_not_present = 0,
	.useable         = 0,
};

will leave .lm uninitialized.  This means that anything in the
kernel that reads user_desc.lm for 32-bit tasks is unreliable.

Revert the .lm check in set_thread_area.  The value never did
anything in the first place.

Fixes: 0e58af4e1d21 x86/tls: Disallow unusual TLS segments
Cc: stable@vger.kernel.org # Only if 0e58af4e1d21 is backported
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

I think that this got eaten by gmail's SMTP server.  It showed up in
my inbox, but it never made it to lkml.

 arch/x86/include/uapi/asm/ldt.h | 7 +++++++
 arch/x86/kernel/tls.c           | 6 ------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/uapi/asm/ldt.h b/arch/x86/include/uapi/asm/ldt.h
index 46727eb37bfe..6e1aaf73852a 100644
--- a/arch/x86/include/uapi/asm/ldt.h
+++ b/arch/x86/include/uapi/asm/ldt.h
@@ -28,6 +28,13 @@ struct user_desc {
 	unsigned int  seg_not_present:1;
 	unsigned int  useable:1;
 #ifdef __x86_64__
+	/*
+	 * Because this bit is not present in 32-bit user code, user
+	 * programs can pass uninitialized values here.  Therefore, in
+	 * any context in which a user_desc comes from a 32-bit program,
+	 * the kernel must act as though lm == 0, regardless of the
+	 * actual value.
+	 */
 	unsigned int  lm:1;
 #endif
 };
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 3e551eee87b9..4e942f31b1a7 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -55,12 +55,6 @@ static bool tls_desc_okay(const struct user_desc *info)
 	if (info->seg_not_present)
 		return false;
 
-#ifdef CONFIG_X86_64
-	/* The L bit makes no sense for data. */
-	if (info->lm)
-		return false;
-#endif
-
 	return true;
 }
 
-- 
2.1.0

