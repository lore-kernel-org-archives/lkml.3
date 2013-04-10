Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936583Ab3DJJXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:23:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3DJJXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:23:14 -0400
Date: Wed, 10 Apr 2013 02:21:40 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-324670b620ab1ed00ba160e435686bd2ae4a59ce@git.kernel.org>
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
In-Reply-To: <20130404104049.21071.20908.stgit@mhiramat-M0-7522>
References: <20130404104049.21071.20908.stgit@mhiramat-M0-7522>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes:
  Move __kprobes definition into compiler.h
Git-Commit-ID: 324670b620ab1ed00ba160e435686bd2ae4a59ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 02:21:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  324670b620ab1ed00ba160e435686bd2ae4a59ce
Gitweb:     http://git.kernel.org/tip/324670b620ab1ed00ba160e435686bd2ae4a59ce
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 4 Apr 2013 19:40:50 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 17:28:34 +0200

kprobes: Move __kprobes definition into compiler.h

Currently, __kprobes is defined in linux/kprobes.h which
is too big to be included in small or basic headers
that want to make use of this simple attribute.

So move __kprobes definition into linux/compiler.h
in which other compiler attributes are defined.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130404104049.21071.20908.stgit@mhiramat-M0-7522
[ Improved the attribute explanation a bit. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/compiler.h | 6 ++++++
 include/linux/kprobes.h  | 6 +-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 10b8f23..92669cd 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -351,4 +351,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+/* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
+#ifdef CONFIG_KPROBES
+# define __kprobes	__attribute__((__section__(".kprobes.text")))
+#else
+# define __kprobes
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
