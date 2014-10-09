Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaJINBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:01:20 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60596 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaJINBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:01:11 -0400
Subject: [PATCH ftrace/for-next v5 0/5] ftrace,
 kprobes: Introduce IPMODIFY flag for ftrace_ops to detect conflicts
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Thu, 09 Oct 2014 13:00:59 +0000
Message-ID: <20141009130059.4698.21616.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the 5th version of the series of patches which introduces
IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
who can modify regs->ip in their handler.

The previous version is here;
 https://lkml.org/lkml/2014/7/28/13

This version is basically an update of previous version to the
latest ftrace tree, and adding a test code to selftest.

Currently, only kprobes can change the regs->ip in the handler,
but recently kpatch is also want to change it. Moreover, since
the ftrace itself exported to modules, it might be considerable
senario.

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

The 3rd patch adds a special reservation of IPMODIFY on the
jprobed address, since it is the only user who will change
the regs->ip. Other kprobes do not change it anymore. 

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
 kernel/kprobes.c                                   |  123 +++++++++++++--
 kernel/trace/ftrace.c                              |  142 +++++++++++++++++
 tools/testing/selftests/ftrace/Makefile            |   11 +
 tools/testing/selftests/ftrace/ipmodify/Makefile   |   15 ++
 tools/testing/selftests/ftrace/ipmodify/ipmodify.c |  168 ++++++++++++++++++++
 .../selftests/ftrace/ipmodify/run_ipmodify.sh      |    6 +
 10 files changed, 478 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/Makefile
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/ipmodify.c
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/run_ipmodify.sh

--

