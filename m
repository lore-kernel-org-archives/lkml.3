Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaA3GWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:22:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaA3GWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:22:10 -0500
Date: Wed, 29 Jan 2014 22:22:01 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-dff38e3e93bbc10653a232f68077e5d031624464@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1382458079-24450-6-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-6-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86:
  Use inline assembler instead of global register variable to get sp
Git-Commit-ID: dff38e3e93bbc10653a232f68077e5d031624464
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 29 Jan 2014 22:22:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dff38e3e93bbc10653a232f68077e5d031624464
Gitweb:     http://git.kernel.org/tip/dff38e3e93bbc10653a232f68077e5d031624464
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 22 Oct 2013 09:07:57 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Jan 2014 22:17:17 -0800

x86: Use inline assembler instead of global register variable to get sp

LTO in gcc 4.6/47. has trouble with global register variables. They were used
to read the stack pointer. Use a simple inline assembler statement with
a mov instead.

This also helps LLVM/clang, which does not support global register
variables.

[ hpa: Ideally this should become a builtin in both gcc and clang. ]

v2: More general asm constraint. Fix description (Jan Beulich)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1382458079-24450-6-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/thread_info.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 3ba3de4..e1940c0 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -163,9 +163,11 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-
-/* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("esp") __used;
+#define current_stack_pointer ({		\
+	unsigned long sp;			\
+	asm("mov %%esp,%0" : "=g" (sp));	\
+	sp;					\
+})
 
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
