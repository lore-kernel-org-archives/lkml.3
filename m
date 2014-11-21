Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbaKUC3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:29:23 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36803 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbaKUC3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:29:21 -0500
Subject: [PATCH ftrace/core v6 0/5] ftrace,
 kprobes: Introduce IPMODIFY flag for ftrace_ops to detect conflicts
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 21 Nov 2014 05:25:02 -0500
Message-ID: <20141121102502.11844.82696.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the 6th version of the series of patches which introduces
IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
who can modify regs->ip in their handler.

This version is basically an update of previous version to the
latest ftrace/core tree.

Currently, only kprobes can change the regs->ip in the handler,
but recent Kernel Live Patching also changes it.

Here we talked on github.
 https://github.com/dynup/kpatch/issues/47

To protect modified regs-ip from each other, this series
introduces FTRACE_OPS_FL_IPMODIFY flag and ftrace now ensures
the flag can be set on each function entry location. If there
is someone who already reserve regs->ip on target function
entry, ftrace_set_filter_ip or register_ftrace_function will
return -EBUSY. Users must handle that.
The ftrace_ops with IPMODIFY flag requires at least one
entry for filter hash, and its notrace_hash must be empty,
because the IPMODIFY action is very address sensitve and
user must consider the ip address.

Thank you,

---

Masami Hiramatsu (5):
      kprobes/ftrace: Recover original IP if pre_handler doesn't change it
      ftrace, kprobes: Support IPMODIFY flag to find IP modify conflict
      kprobes: Add IPMODIFY flag to kprobe_ftrace_ops
      kprobes: Set IPMODIFY flag only if the probe can change regs->ip
      kselftest,ftrace: Add ftrace IPMODIFY flag test


 Documentation/kprobes.txt                          |   12 +
 Documentation/trace/ftrace.txt                     |    5 +
 arch/x86/kernel/kprobes/ftrace.c                   |    9 +
 include/linux/ftrace.h                             |   16 ++
 kernel/kprobes.c                                   |  123 +++++++++++++-
 kernel/trace/ftrace.c                              |  142 ++++++++++++++++-
 tools/testing/selftests/ftrace/Makefile            |   11 +
 tools/testing/selftests/ftrace/ipmodify/Makefile   |   15 ++
 tools/testing/selftests/ftrace/ipmodify/ipmodify.c |  170 ++++++++++++++++++++
 .../selftests/ftrace/ipmodify/run_ipmodify.sh      |    6 +
 10 files changed, 480 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/Makefile
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/ipmodify.c
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/run_ipmodify.sh

--

