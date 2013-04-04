Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab3DDKmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:42:47 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46487 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974Ab3DDKmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:42:45 -0400
X-AuditID: 85900ec0-d2ec7b900000151e-1a-515d5922deb6
Subject: [PATCH -tip ] kprobes: Move __kprobes definition into compiler.h
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Date: Thu, 04 Apr 2013 19:40:50 +0900
Message-ID: <20130404104049.21071.20908.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, __kprobes is defined in linux/kprobes.h which
is too big to be included in small or basic headers
only for using this attribute.

This moves __kprobes definition into linux/compiler.h
in which other compiler attributes are defined.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/compiler.h |    6 ++++++
 include/linux/kprobes.h  |    6 +-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 10b8f23..9382db2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -351,4 +351,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+#ifdef CONFIG_KPROBES
+/* Attach to insert probes on any functions which should be ignored */
+#define __kprobes	__attribute__((__section__(".kprobes.text")))
+#else
+#define __kprobes
+#endif
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 4b6ef4d..ca1d27a 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -29,6 +29,7 @@
  *		<jkenisto@us.ibm.com>  and Prasanna S Panchamukhi
  *		<prasanna@in.ibm.com> added function-return probes.
  */
+#include <linux/compiler.h>	/* for __kprobes */
 #include <linux/linkage.h>
 #include <linux/list.h>
 #include <linux/notifier.h>
@@ -49,16 +50,11 @@
 #define KPROBE_REENTER		0x00000004
 #define KPROBE_HIT_SSDONE	0x00000008
 
-/* Attach to insert probes on any functions which should be ignored*/
-#define __kprobes	__attribute__((__section__(".kprobes.text")))
-
 #else /* CONFIG_KPROBES */
 typedef int kprobe_opcode_t;
 struct arch_specific_insn {
 	int dummy;
 };
-#define __kprobes
-
 #endif /* CONFIG_KPROBES */
 
 struct kprobe;

