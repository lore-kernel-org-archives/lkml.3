Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3CRLNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:13:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3CRLNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:13:37 -0400
Date: Mon, 18 Mar 2013 04:10:18 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-65c10553552b487a71bf5e4676743435046fae6f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, xemul@parallels.com, jkosina@suse.cz,
        davem@davemloft.net, nyc@holomorphy.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        timo.lindfors@iki.fi
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, xemul@parallels.com, jkosina@suse.cz,
        davem@davemloft.net, ananth@in.ibm.com, nyc@holomorphy.com,
        masami.hiramatsu.pt@hitachi.com, timo.lindfors@iki.fi,
        tglx@linutronix.de
In-Reply-To: <20130314115230.19690.39387.stgit@mhiramat-M0-7522>
References: <20130314115230.19690.39387.stgit@mhiramat-M0-7522>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes: Make hash_64() as always inlined
Git-Commit-ID: 65c10553552b487a71bf5e4676743435046fae6f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:10:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65c10553552b487a71bf5e4676743435046fae6f
Gitweb:     http://git.kernel.org/tip/65c10553552b487a71bf5e4676743435046fae6f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Mar 2013 20:52:30 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Mar 2013 10:21:23 +0100

kprobes: Make hash_64() as always inlined

Because hash_64() is called from the get_kprobe() inside
int3 handler, kernel causes int3 recursion and crashes if
kprobes user puts a probe on it.

Usually hash_64() is inlined into caller function, but in
some cases, it has instances by gcc's interprocedural
constant propagation.

This patch uses __always_inline instead of inline to
prevent gcc from doing such things.

Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130314115230.19690.39387.stgit@mhiramat-M0-7522
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/hash.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/hash.h b/include/linux/hash.h
index 61c97ae..f09a0ae 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -15,6 +15,7 @@
  */
 
 #include <asm/types.h>
+#include <linux/compiler.h>
 
 /* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
 #define GOLDEN_RATIO_PRIME_32 0x9e370001UL
@@ -31,7 +32,7 @@
 #error Wordsize not 32 or 64
 #endif
 
-static inline u64 hash_64(u64 val, unsigned int bits)
+static __always_inline u64 hash_64(u64 val, unsigned int bits)
 {
 	u64 hash = val;
 
