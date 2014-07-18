Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbaGRKWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:22:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36680 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761559AbaGRKWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:22:43 -0400
Date: Fri, 18 Jul 2014 03:21:26 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-d81b4253b0f0f1e7b7e03b0cd0f80cab18bc4d7b@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        mpe@ellerman.id.au, tony.luck@intel.com, arnd@arndb.de,
        jeremy@goop.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, paulus@samba.org, haokexin@gmail.com,
        tony.luck@gmail.com, davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, benh@kernel.crashing.org,
        suzuki@in.ibm.com, chrisw@sous-sol.org, fenghua.yu@intel.com
Reply-To: mingo@kernel.org, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, mpe@ellerman.id.au, tony.luck@intel.com,
        arnd@arndb.de, jeremy@goop.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
        haokexin@gmail.com, tony.luck@gmail.com, davem@davemloft.net,
        ananth@in.ibm.com, benh@kernel.crashing.org,
        masami.hiramatsu.pt@hitachi.com, chrisw@sous-sol.org,
        suzuki@in.ibm.com, fenghua.yu@intel.com
In-Reply-To: <20140717114411.13401.2632.stgit@kbuild-fedora.novalocal>
References: <20140717114411.13401.2632.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes: Fix "Failed to find blacklist"
  probing errors on ia64 and ppc64
Git-Commit-ID: d81b4253b0f0f1e7b7e03b0cd0f80cab18bc4d7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d81b4253b0f0f1e7b7e03b0cd0f80cab18bc4d7b
Gitweb:     http://git.kernel.org/tip/d81b4253b0f0f1e7b7e03b0cd0f80cab18bc4d7b
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 17 Jul 2014 11:44:11 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Jul 2014 06:23:40 +0200

kprobes: Fix "Failed to find blacklist" probing errors on ia64 and ppc64

On ia64 and ppc64, function pointers do not point to the
entry address of the function, but to the address of a
function descriptor (which contains the entry address and misc
data).

Since the kprobes code passes the function pointer stored
by NOKPROBE_SYMBOL() to kallsyms_lookup_size_offset() for
initalizing its blacklist, it fails and reports many errors,
such as:

  Failed to find blacklist 0001013168300000
  Failed to find blacklist 0001013000f0a000
  [...]

To fix this bug, use arch_deref_entry_point() to get the
function entry address for kallsyms_lookup_size_offset()
instead of the raw function pointer.

Suzuki also pointed out that blacklist entries should also
be updated as well.

Reported-by: Tony Luck <tony.luck@gmail.com>
Fixed-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (for powerpc)
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: sparse@chrisli.org
Cc: Paul Mackerras <paulus@samba.org>
Cc: akataria@vmware.com
Cc: anil.s.keshavamurthy@intel.com
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: Kevin Hao <haokexin@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: rdunlap@infradead.org
Cc: dl9pf@gmx.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-ia64@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/20140717114411.13401.2632.stgit@kbuild-fedora.novalocal
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/kprobes.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3214289..734e9a7 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2037,19 +2037,23 @@ static int __init populate_kprobe_blacklist(unsigned long *start,
 {
 	unsigned long *iter;
 	struct kprobe_blacklist_entry *ent;
-	unsigned long offset = 0, size = 0;
+	unsigned long entry, offset = 0, size = 0;
 
 	for (iter = start; iter < end; iter++) {
-		if (!kallsyms_lookup_size_offset(*iter, &size, &offset)) {
-			pr_err("Failed to find blacklist %p\n", (void *)*iter);
+		entry = arch_deref_entry_point((void *)*iter);
+
+		if (!kernel_text_address(entry) ||
+		    !kallsyms_lookup_size_offset(entry, &size, &offset)) {
+			pr_err("Failed to find blacklist at %p\n",
+				(void *)entry);
 			continue;
 		}
 
 		ent = kmalloc(sizeof(*ent), GFP_KERNEL);
 		if (!ent)
 			return -ENOMEM;
-		ent->start_addr = *iter;
-		ent->end_addr = *iter + size;
+		ent->start_addr = entry;
+		ent->end_addr = entry + size;
 		INIT_LIST_HEAD(&ent->list);
 		list_add_tail(&ent->list, &kprobe_blacklist);
 	}
