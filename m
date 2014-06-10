Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064AbaFJKuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:50:13 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33773 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaFJKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:50:11 -0400
Subject: [PATCH ftrace/core  0/2] ftrace,
 kprobes: Introduce IPMODIFY flag for ftrace_ops to detect conflicts
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Tue, 10 Jun 2014 10:50:01 +0000
Message-ID: <20140610105001.8732.93502.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a pair of patches which introduces IPMODIFY flag for
ftrace_ops to detect conflicts of ftrace users who can modify
regs->ip in their handler.
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

At this point, all kprobes will reserve regs->ip, since jprobe
requires it.

Thank you,

---

Masami Hiramatsu (2):
      ftrace: Simplify ftrace_hash_disable/enable path in ftrace_hash_move
      ftrace, kprobes: Support IPMODIFY flag to find IP modify conflict


 Documentation/trace/ftrace.txt |    5 +
 include/linux/ftrace.h         |   10 ++-
 kernel/kprobes.c               |    2 -
 kernel/trace/ftrace.c          |  152 ++++++++++++++++++++++++++++++++++------
 4 files changed, 143 insertions(+), 26 deletions(-)

--


