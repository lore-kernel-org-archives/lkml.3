Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3CKOY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:24:58 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59476 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3CKOYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:24:33 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-56-513de91eee72
Subject: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe
 section
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Date: Mon, 11 Mar 2013 23:22:33 +0900
Message-ID: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beacuse hash_64() is called from the get_kprobe() inside
int3 handler, kernel causes int3 recursion and crashes if
kprobes user puts a probe on it.

Usually hash_64() is inlined into caller function, but in
some cases, it has instances by gcc's interprocedural
constant propagation.

This patch adds __kprobes tag on the hash_64() and moves
all those instances into .text.kprobe section so that
kprobes can refuse probing on the instances.

I've ensured that all hash_64 instances moves to the
address between __kprobes_text_start and __kprobes_text_end
with this patch as below.

ffffffff8138bea0 T __kprobes_text_start
ffffffff8138bec0 t hash_64.constprop.8
ffffffff8138ef98 t hash_64.constprop.26
ffffffff8138efae t hash_64
ffffffff8138f066 t hash_64.constprop.43
ffffffff8138f649 t hash_64.constprop.25
ffffffff8139103a t hash_64.constprop.77
ffffffff81391050 t hash_64.constprop.24
ffffffff81391066 t hash_64.constprop.40
ffffffff8139107c t hash_64.constprop.15
ffffffff81391092 T __kprobes_text_end

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 include/linux/hash.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/hash.h b/include/linux/hash.h
index 61c97ae..d83f62f 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -15,6 +15,7 @@
  */
 
 #include <asm/types.h>
+#include <linux/kprobes.h>
 
 /* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
 #define GOLDEN_RATIO_PRIME_32 0x9e370001UL
@@ -31,7 +32,7 @@
 #error Wordsize not 32 or 64
 #endif
 
-static inline u64 hash_64(u64 val, unsigned int bits)
+static __kprobes inline u64 hash_64(u64 val, unsigned int bits)
 {
 	u64 hash = val;
 

