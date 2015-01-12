Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbbALSk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:40:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbbALSap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 187/216] x86/tls: Don't validate lm in set_thread_area() after all
Date: Mon, 12 Jan 2015 18:29:25 +0000
Message-Id: <1421087394-2712-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0 upstream.

It turns out that there's a lurking ABI issue.  GCC, when
compiling this in a 32-bit program:

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

Revert the .lm check in set_thread_area().  The value never did
anything in the first place.

Fixes: 0e58af4e1d21 ("x86/tls: Disallow unusual TLS segments")
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/d7875b60e28c512f6a6fc0baf5714d58e7eaadbb.1418856405.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
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
2.1.4

