Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaBWAUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 19:20:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36302 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaBWAT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 19:19:59 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC] improve_stack: make stack dump output useful again
Date: Sat, 22 Feb 2014 19:19:37 -0500
Message-Id: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now when people try to report issues in the kernel they send stack
dumps to eachother, which looks something like this:

[    6.906437]  [<ffffffff811f0e90>] ? backtrace_test_irq_callback+0x20/0x20
[    6.907121]  [<ffffffff84388ce8>] dump_stack+0x52/0x7f
[    6.907640]  [<ffffffff811f0ec8>] backtrace_regression_test+0x38/0x110
[    6.908281]  [<ffffffff813596a0>] ? proc_create_data+0xa0/0xd0
[    6.908870]  [<ffffffff870a8040>] ? proc_modules_init+0x22/0x22
[    6.909480]  [<ffffffff810020c2>] do_one_initcall+0xc2/0x1e0
[...]

However, most of the text you get is pure garbage.

The only useful thing above is the function name. Due to the amount of
different kernel code versions and various configurations being used, the
kernel address and the offset into the function are not really helpful in
determining where the problem actually occured.

Too often the result of someone looking at a stack dump is asking the person
who sent it for a translation for one or more 'addr2line' translations. Which
slows down the entire process of debugging the issue (and really annoying).

The "improve_stack" script (wanted: better name) is an attempt to make the
output more useful and easy to work with by translating all kernel addresses
in the stack dump into line numbers. Which means that the stack dump we saw
before would look like this:

[    6.906437]  [<kernel/backtracetest.c:73>] ? backtrace_test_irq_callback+0x20/0x20
[    6.907121]  [<lib/dump_stack.c:52>] dump_stack+0x52/0x7f
[    6.907640]  [<kernel/backtracetest.c:40 kernel/backtracetest.c:77>] backtrace_regression_test+0x38/0x110
[    6.908281]  [<fs/proc/generic.c:445>] ? proc_create_data+0xa0/0xd0
[    6.908870]  [<kernel/kallsyms.c:611>] ? proc_modules_init+0x22/0x22
[    6.909480]  [<init/main.c:696>] do_one_initcall+0xc2/0x1e0

It's pretty obvious why this is better than the previous stack dump before.

Usage is pretty simple:

	./improve_stack.sh [vmlinux] [base path]

Where vmlinux is the vmlinux to extract line numbers from and base path is
the path that points to the root of the build tree, for example:

	./improve_stack.sh vmlinux /home/sasha/linux/

And the stack trace should be piped through it (I, for example, just pipe
the output of the serial console of my KVM test box through it).

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 scripts/improve_stack.sh |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100755 scripts/improve_stack.sh

diff --git a/scripts/improve_stack.sh b/scripts/improve_stack.sh
new file mode 100755
index 0000000..03a4a90
--- /dev/null
+++ b/scripts/improve_stack.sh
@@ -0,0 +1,32 @@
+#!/bin/bash
+
+if [ $# != "2" ]; then
+	echo "Usage:"
+	echo "	$0 [vmlinux] [base path]"
+	exit 1
+fi
+
+vmlinux=$1
+basepath=$2
+
+while read line; do
+	# Let's see if we have an address in the line
+	if [[ $line =~ \[\<([^]]+)\>\]  ]]; then
+		# Translate address to line numbers
+		code=`addr2line -i -e $vmlinux ${BASH_REMATCH[1]}`
+
+		# Strip useless base path
+		code=${code//$basepath/""}
+
+		# In the case of inlines, move everything to same line
+		code=${code//$'\n'/' '}
+
+		# Replace old address with pretty line numbers
+		newline=${line//${BASH_REMATCH[1]}/$code}
+
+		echo "$newline"
+	else
+		# Nothing special in this line, show it as is
+		echo "$line"
+	fi
+done
-- 
1.7.2.5

