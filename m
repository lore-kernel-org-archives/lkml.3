Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaCPSdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 14:33:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17994 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbaCPSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 14:33:34 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] improve_stack: make stack dump output useful again
Date: Sun, 16 Mar 2014 14:33:19 -0400
Message-Id: <1394994799-2221-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
in the stack dump into line numbers. Which means that the stack dump
would look like this:

[  324.019502]  dump_stack+0x52/0x7f (lib/dump_stack.c:52)
[  324.020206]  warn_slowpath_common+0x8c/0xc0 (kernel/panic.c:418)
[  324.020289]  ? noop_count+0x10/0x10 (kernel/locking/lockdep.c:1315)
[  324.020289]  warn_slowpath_null+0x1a/0x20 (kernel/panic.c:453)
[  324.020289]  __bfs+0x113/0x240 (kernel/locking/lockdep.c:962 kernel/locking/lockdep.c:1027)
[  324.020289]  find_usage_backwards+0x80/0x90 (kernel/locking/lockdep.c:1365)
[  324.020289]  check_usage_backwards+0xb7/0x100 (kernel/locking/lockdep.c:2379)

It's pretty obvious why this is better than the previous stack dump before.

Usage is pretty simple:

        ./improve_stack.sh [vmlinux] [base path]

Where vmlinux is the vmlinux to extract line numbers from and base path is
the path that points to the root of the build tree, for example:

        ./improve_stack.sh vmlinux /home/sasha/linux/ < input.log > output.log

The stack trace should be piped through it (I, for example, just pipe
the output of the serial console of my KVM test box through it).

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---

Changes from RFC:
 - Drop the useless hex numbers from output
 - Use 'nm vmlinux' to translate symbol names to base address


 scripts/improve_stack.sh |   84 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100755 scripts/improve_stack.sh

diff --git a/scripts/improve_stack.sh b/scripts/improve_stack.sh
new file mode 100755
index 0000000..925e335
--- /dev/null
+++ b/scripts/improve_stack.sh
@@ -0,0 +1,84 @@
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
+function parse_symbol() {
+	# The structure of symbol at this point is:
+	#   [name]+[offset]/[total length]
+	#
+	# For example:
+	#   do_basic_setup+0x9c/0xbf
+
+
+	# Strip the symbol name so that we could look it up
+	name=${symbol%+*}
+
+	# Use 'nm vmlinux' to figure out the base address of said symbol.
+	# It's actually faster to call it every time than to load it
+	# all into bash.
+	base_addr=$(nm $vmlinux | grep " $name\$" | awk {'print $1'})
+
+	# Let's start doing the math to get the exact address into the
+	# symbol. First, strip out the symbol total length.
+	expr=${symbol%/*}
+
+	# Now, replace the symbol name with the base address we found
+	# before.
+	expr=${expr/$name/0x$base_addr}
+
+	# Evaluate it to find the actual address
+	expr=$((expr))
+
+	# Pass it to addr2line to get filename and line number
+	code=`addr2line -i -e $vmlinux $(printf "%x\n" $expr)`
+
+	# Strip out the base of the path
+	code=${code//$basepath/""}
+
+	# In the case of inlines, move everything to same line
+	code=${code//$'\n'/' '}
+
+	# Replace old address with pretty line numbers
+	symbol=$(echo $symbol "("$code")")
+}
+
+function handle_line() {
+	line="$1"
+
+	# Tokenize
+	words=$(echo $line | tr "\r " "\n")
+
+	# Remove hex numbers. Do it ourselves until it happens in the
+	# kernel
+	for i in $words; do
+		if [[ $i =~ \[\<([^]]+)\>\] ]]; then
+			line=${line/" $i"/""}
+		fi
+	done
+
+	# The symbol is the last element, process it
+	symbol="$i"
+	parse_symbol
+
+	# Add up the line number to the symbol
+	line=${line/$i/$symbol}
+	echo "$line"
+}
+
+while read line; do
+	# Let's see if we have an address in the line
+	if [[ $line =~ \[\<([^]]+)\>\]  ]]; then
+		# Translate address to line numbers
+		handle_line "$line"
+	else
+		# Nothing special in this line, show it as is
+		echo "$line"
+	fi
+done
-- 
1.7.2.5

