Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3LSUKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:10:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35729 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3LSUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:10:13 -0500
Date: Thu, 19 Dec 2013 12:09:34 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-7e98b71920464b8d15fa95c74366416cd3c88861@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com
In-Reply-To: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
References: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/idle] x86, idle: Use static_cpu_has()
  for CLFLUSH workaround, add barriers
Git-Commit-ID: 7e98b71920464b8d15fa95c74366416cd3c88861
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 19 Dec 2013 12:09:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e98b71920464b8d15fa95c74366416cd3c88861
Gitweb:     http://git.kernel.org/tip/7e98b71920464b8d15fa95c74366416cd3c88861
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 19 Dec 2013 11:58:16 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Dec 2013 11:58:16 -0800

x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers

Use static_cpu_has() to conditionalize the CLFLUSH workaround, and add
memory barriers around it since the documentation is explicit that
CLFLUSH is only ordered with respect to MFENCE.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Len Brown <len.brown@intel.com>
Link: http://lkml.kernel.org/r/CA%2B55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com
---
 arch/x86/include/asm/mwait.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 361b02e..19b71c4 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -43,8 +43,11 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
 static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
 	if (!current_set_polling_and_test()) {
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+			mb();
 			clflush((void *)&current_thread_info()->flags);
+			mb();
+		}
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		if (!need_resched())
