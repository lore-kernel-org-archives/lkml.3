Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaC2EHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 00:07:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49753 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaC2EHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 00:07:23 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, michael.ploujnikov@oracle.com,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v3] decode_stacktrace: make stack dump output useful again
Date: Sat, 29 Mar 2014 00:07:08 -0400
Message-Id: <1396066028-29051-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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

The decode_stacktrace script is an attempt to make the output more useful and
easy to work with by translating all kernel addresses in the stack dump into
line numbers. Which means that the stack dump would look like this:

[  635.148361]  dump_stack (lib/dump_stack.c:52)
[  635.149127]  warn_slowpath_common (kernel/panic.c:418)
[  635.150214]  warn_slowpath_null (kernel/panic.c:453)
[  635.151031]  _oalloc_pages_slowpath+0x6a/0x7d0
[  635.152171]  ? zone_watermark_ok (mm/page_alloc.c:1728)
[  635.152988]  ? get_page_from_freelist (mm/page_alloc.c:1939)
[  635.154766]  __alloc_pages_nodemask (mm/page_alloc.c:2766)

It's pretty obvious why this is better than the previous stack dump before.

Usage is pretty simple:

        ./decode_stacktrace.sh [vmlinux] [base path]

Where vmlinux is the vmlinux to extract line numbers from and base path is
the path that points to the root of the build tree, for example:

        ./decode_stacktrace.sh vmlinux /home/sasha/linux/ < input.log > output.log

The stack trace should be piped through it (I, for example, just pipe
the output of the serial console of my KVM test box through it).

Reviewed-by: Michael Ploujnikov <michael.ploujnikov@oracle.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 scripts/decode_stacktrace.sh |  105 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)
 create mode 100755 scripts/decode_stacktrace.sh

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
new file mode 100755
index 0000000..222fcf4
--- /dev/null
+++ b/scripts/decode_stacktrace.sh
@@ -0,0 +1,105 @@
+#!/bin/bash
+# (c) 2014, Sasha Levin <sasha.levin@oracle.com>
+#set -x
+if [[ $# != 2 ]]; then
+	echo "Usage:"
+	echo "	$0 [vmlinux] [base path]"
+	exit 1
+fi
+
+vmlinux=$1
+basepath=$2
+
+parse_symbol() {
+	# The structure of symbol at this point is:
+	#   [name]+[offset]/[total length]
+	#
+	# For example:
+	#   do_basic_setup+0x9c/0xbf
+
+
+	# Strip the symbol name so that we could look it up
+	local name=${symbol%+*}
+
+	# Use 'nm vmlinux' to figure out the base address of said symbol.
+	# It's actually faster to call it every time than to load it
+	# all into bash.
+	local base_addr=$(nm "$vmlinux" | awk "/ $name\$/ {print \$1}" | head -n1)
+
+	# Let's start doing the math to get the exact address into the
+	# symbol. First, strip out the symbol total length.
+	local expr=${symbol%/*}
+
+	# Now, replace the symbol name with the base address we found
+	# before.
+	expr=${expr/$name/0x$base_addr}
+
+	# Evaluate it to find the actual address
+	expr=$((expr))
+	local address=$(printf "%x\n" "$expr")
+
+	# Pass it to addr2line to get filename and line number
+        # Could get more than one result
+	local code=$(addr2line -i -e "$vmlinux" "$address")
+
+	# addr2line doesn't return a proper error code if it fails, so
+	# we detect it using the value it prints so that we could preserve
+	# the offset/size into the function and bail out
+	if [[ $code == "??:0" ]]; then
+		return
+	fi
+
+	# Strip out the base of the path
+	code=${code//$basepath/""}
+
+	# In the case of inlines, move everything to same line
+	code=${code//$'\n'/' '}
+
+	# Replace old address with pretty line numbers
+	symbol="$name ($code)"
+}
+
+handle_line() {
+	local words
+	# Tokenize
+	read -a words <<<"$1"
+
+	# Remove hex numbers. Do it ourselves until it happens in the
+	# kernel
+
+	# We need to know the index of the last element before we
+	# remove elements because arrays are sparse
+	local last=$(( ${#words[@]} - 1 ))
+
+	for i in "${!words[@]}"; do
+		# Remove the address
+		if [[ ${words[$i]} =~ \[\<([^]]+)\>\] ]]; then
+			unset words[$i]
+		fi
+
+		# Format timestamps with tabs
+		if [[ ${words[$i]} == \[ && ${words[$i+1]} == *\] ]]; then
+			unset words[$i]
+			words[$i+1]=$(printf "[%13s\n" "${words[$i+1]}")
+		fi
+	done
+
+	# The symbol is the last element, process it
+	symbol=${words[$last]}
+	unset words[$last]
+	parse_symbol # modifies $symbol
+
+	# Add up the line number to the symbol
+	echo "${words[@]}" "$symbol"
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
1.7.10.4

