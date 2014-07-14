Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaGNOjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:39:07 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50770 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaGNOir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:38:47 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] printk: Fix %pB when there's no symbol at the address
Date: Mon, 14 Jul 2014 23:38:40 +0900
Message-Id: <1405348720-2837-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __sprint_symbol() should restore original address when
kallsyms_lookup() failed to find a symbol.  It's reported when
dumpstack shows an address in a dynamically allocated trampoline
for ftrace.

  [ 1314.612287]  [<ffffffff81700312>] dump_stack+0x45/0x56
  [ 1314.612290]  [<ffffffff8125f5b0>] ? meminfo_proc_open+0x30/0x30
  [ 1314.612293]  [<ffffffffa080a494>] kpatch_ftrace_handler+0x14/0xf0 [kpatch]
  [ 1314.612306]  [<ffffffffa00160c4>] 0xffffffffa00160c3

You can see a difference in the hex address - c4 and c3.  Fix it.

Reported-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/kallsyms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index cb0cf37dac3a..ae5167087845 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -364,7 +364,7 @@ static int __sprint_symbol(char *buffer, unsigned long address,
 	address += symbol_offset;
 	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
 	if (!name)
-		return sprintf(buffer, "0x%lx", address);
+		return sprintf(buffer, "0x%lx", address - symbol_offset);
 
 	if (name != buffer)
 		strcpy(buffer, name);
-- 
2.0.0

