Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaBQPXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:23:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaBQPXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:23:41 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 2/4] x86: Fix ftrace patching recovery code to work on x86_64
Date: Mon, 17 Feb 2014 16:22:51 +0100
Message-Id: <1392650573-3390-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftrace modifies function calls using Int3 breakpoints on x86. It patches
all functions in parallel to reduce the number of sync() calls. If some
function cannot be modified, it tries to recover and remove the other
pending breakpoints.

The recovery currently does not work on x86_64 because the address
is read-only. We need to use ftrace_write() that gets write access
via the kernel identity mapping. It is used everywhere else in the
code.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e7f3f3f565de..30d63c4a4195 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -449,7 +449,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 
  update:
 	/* Put back the first byte */
-	return probe_kernel_write((void *)ip, valid_ins, 1);
+	return ftrace_write(ip, valid_ins, 1);
 }
 
 static int add_update_code(unsigned long ip, unsigned const char *new)
-- 
1.8.4

