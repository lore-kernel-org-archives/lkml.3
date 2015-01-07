Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbbAGC6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:58:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbbAGBwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.18 40/84] x86/tls: Dont validate lm in set_thread_area() after all
Date: Tue,  6 Jan 2015 17:49:43 -0800
Message-Id: <20150107014030.322760318@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/uapi/asm/ldt.h |    7 +++++++
 arch/x86/kernel/tls.c           |    6 ------
 2 files changed, 7 insertions(+), 6 deletions(-)

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
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -55,12 +55,6 @@ static bool tls_desc_okay(const struct u
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
 


