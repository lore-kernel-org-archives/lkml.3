Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3CNLyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:54:32 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58570 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab3CNLya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:54:30 -0400
X-AuditID: 85900ec0-d38c8b900000151e-1d-5141ba73afa4
Subject: [PATCH -tip v2 1/2] [BUGFIX] kprobes: make hash_64() as always inlined
To: Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Date: Thu, 14 Mar 2013 20:52:30 +0900
Message-ID: <20130314115230.19690.39387.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because hash_64() is called from the get_kprobe() inside
int3 handler, kernel causes int3 recursion and crashes if
kprobes user puts a probe on it.

Usually hash_64() is inlined into caller function, but in
some cases, it has instances by gcc's interprocedural
constant propagation.

This patch uses __always_inline instead of inline to
prevent gcc from doing such things.

Changes in v2:
 - Use __always_inline instead of using __kprobes

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/hash.h |    3 ++-
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
 

