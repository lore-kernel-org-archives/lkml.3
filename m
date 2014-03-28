Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaC2PYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:24:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58903 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaC2PX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:23:27 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 01/29] ktap: add tools/ktap/README.md file
Date: Fri, 28 Mar 2014 10:44:56 -0400
Message-Id: <1396017924-7754-2-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/README.md | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 149 insertions(+)
 create mode 100644 tools/ktap/README.md

diff --git a/tools/ktap/README.md b/tools/ktap/README.md
new file mode 100644
index 0000000..66dc2d1
--- /dev/null
+++ b/tools/ktap/README.md
@@ -0,0 +1,149 @@
+# ktap
+
+A New Scripting Dynamic Tracing Tool For Linux  
+[www.ktap.org][homepage]
+
+ktap is a new scripting dynamic tracing tool for Linux,
+it uses a scripting language and lets users trace the Linux kernel dynamically.
+ktap is designed to give operational insights with interoperability
+that allows users to tune, troubleshoot and extend the kernel and applications.
+It's similar to Linux Systemtap and Solaris Dtrace.
+
+ktap has different design principles from Linux mainstream dynamic tracing
+language in that it's based on bytecode, so it doesn't depend upon GCC,
+doesn't require compiling kernel module for each script, safe to use in
+production environment, fulfilling the embedded ecosystem's tracing needs.
+
+More information can be found at [ktap homepage][homepage].
+
+[homepage]: http://www.ktap.org
+
+## Highlights
+
+* a simple but powerful scripting language
+* register based interpreter (heavily optimized) in Linux kernel
+* small and lightweight
+* not depend on the gcc toolchain for each script run
+* easy to use in embedded environments without debugging info
+* support for tracepoint, kprobe, uprobe, function trace, timer, and more
+* supported in x86, arm, ppc, mips
+* safety in sandbox
+
+
+## Building & Running
+
+1. Clone ktap from github
+
+        $ git clone http://github.com/ktap/ktap.git
+2. Compiling ktap
+
+        $ cd ktap
+        $ make       #generate ktapvm kernel module and ktap binary
+3. Load ktapvm kernel module(make sure debugfs mounted)
+
+        $ make load  #need to be root or have sudo access
+4. Running ktap
+
+        $ ./ktap samples/helloworld.kp
+
+
+## Examples
+
+1. simplest one-liner command to enable all tracepoints
+
+        ktap -e "trace *:* { print(argstr) }"
+2. syscall tracing on target process
+
+        ktap -e "trace syscalls:* { print(argstr) }" -- ls
+3. ftrace(kernel newer than 3.3, and must compiled with CONFIG_FUNCTION_TRACER)
+
+        ktap -e "trace ftrace:function { print(argstr) }"
+
+        ktap -e "trace ftrace:function /ip==mutex*/ { print(argstr) }"
+4. simple syscall tracing
+
+        trace syscalls:* {
+                print(cpu, pid, execname, argstr)
+        }
+5. syscall tracing in histogram style
+
+        var s = {}
+
+        trace syscalls:sys_enter_* {
+                s[probename] += 1
+        }
+
+        trace_end {
+                print_hist(s)
+        }
+6. kprobe tracing
+
+        trace probe:do_sys_open dfd=%di fname=%dx flags=%cx mode=+4($stack) {
+                print("entry:", execname, argstr)
+        }
+
+        trace probe:do_sys_open%return fd=$retval {
+                print("exit:", execname, argstr)
+        }
+7. uprobe tracing
+
+        trace probe:/lib/libc.so.6:malloc {
+                print("entry:", execname, argstr)
+        }
+
+        trace probe:/lib/libc.so.6:malloc%return {
+                print("exit:", execname, argstr)
+        }
+8. stapsdt tracing (userspace static marker)
+
+        trace sdt:/lib64/libc.so.6:lll_futex_wake {
+                print("lll_futex_wake", execname, argstr)
+        }
+
+        or:
+
+        #trace all static mark in libc
+        trace sdt:/lib64/libc.so.6:* {
+                print(execname, argstr)
+        }
+9. timer
+
+        tick-1ms {
+                printf("time fired on one cpu\n");
+        }
+
+        profile-2s {
+                printf("time fired on every cpu\n");
+        }
+
+More examples can be found at [samples][samples_dir] directory.
+
+[samples_dir]: https://github.com/ktap/ktap/tree/master/samples
+
+## Mailing list
+
+ktap@freelists.org  
+You can subscribe to ktap mailing list at link (subscribe before posting):
+http://www.freelists.org/list/ktap
+
+
+## Copyright and License
+
+ktap is licensed under GPL v2
+
+Copyright (C) 2012-2014, Jovi Zhangwei <jovi.zhangwei@gmail.com>.
+All rights reserved.
+
+
+## Contribution
+
+ktap is still under active development, so contributions are welcome.
+You are encouraged to report bugs, provide feedback, send feature request,
+or hack on it.
+
+
+## See More
+
+More info can be found at [documentation][tutorial]
+[tutorial]: http://www.ktap.org/doc/tutorial.html
+
-- 
1.8.1.4

