Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaLSMQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:16:42 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45543 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaLSMQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:16:41 -0500
Date: Fri, 19 Dec 2014 13:16:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [GIT PULL] x86 fix
Message-ID: <20141219121634.GA19164@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0 x86/tls: Don't validate lm in set_thread_area() after all

This tree contains a single TLS ABI validation fix from Andy 
Lutomirski.

 Thanks,

	Ingo

------------------>
Andy Lutomirski (1):
      x86/tls: Don't validate lm in set_thread_area() after all


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
 
