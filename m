Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbaGOGA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:00:26 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50409 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaGOGAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:00:24 -0400
Subject: [PATCH ftrace/core v3 0/3] ftrace,
 kprobes: Introduce IPMODIFY flag for ftrace_ops to detect conflicts
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Tue, 15 Jul 2014 06:00:15 +0000
Message-ID: <20140715060015.12195.74457.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the 3rd version of the series of patches which introduces
IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
who can modify regs->ip in their handler.
This version is basically an update of previous version, however
I've descided to split the kprobe/x86 side fix to an independent
patch (which is [1/3])

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

The 3rd patch adds a special reservation of IPMODIFY on the
jprobed address, since it is the only user who will change
the regs->ip. Other kprobes do not change it anymore. 

For testing, see the testcase in the previous version.
 https://lkml.org/lkml/2014/6/17/175 

Thank you,

---

Masami Hiramatsu (3):
      [BUGFIX]kprobes/ftrace: Recover original IP if pre_handler doesn't change it
      ftrace, kprobes: Support IPMODIFY flag to find IP modify conflict
      kprobes: Set IPMODIFY flag only if the probe can change regs->ip


 Documentation/kprobes.txt        |   12 +--
 Documentation/trace/ftrace.txt   |    5 +
 arch/x86/kernel/kprobes/ftrace.c |    9 ++-
 include/linux/ftrace.h           |   15 ++++
 kernel/kprobes.c                 |  122 +++++++++++++++++++++++++++++++----
 kernel/trace/ftrace.c            |  132 +++++++++++++++++++++++++++++++++++++-
 6 files changed, 266 insertions(+), 29 deletions(-)

--

