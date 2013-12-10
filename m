Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3LJPma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:42:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3LJPm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:42:29 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v6 0/8] x86: use new text_poke_bp in ftrace
Date: Tue, 10 Dec 2013 16:42:12 +0100
Message-Id: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resubmit primary adds text_poke*_or_die wrappers as suggested by
Masami Hiramatsu. See below for more details. It basically modifies
only the first patch in the set.

The commit fd4363fff3d9 (x86: Introduce int3 (breakpoint)-based instruction
patching) uses the same technique that has been used in ftrace since 08d636b
("ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine")

This patch set merge the two implementations and remove duplicities from
the ftrace side.

    + First four patches improve the generic int3-based framework to be usable
      with ftrace. All the changes are based on ideas already used in ftrace.
      They are needed to keep the functionality and efficiency.

    + The 5th patch speedups the original ftrace code but it is useful also
      with the generic functions.

    + The last three patches modifies different parts of the current
      x86-specific ftrace implementation and use the generic functions there.


Changes in v6:
    + added text_poke_or_die and text_poke_bp_or_die wrappers as suggested
      by Masami Hiramatsu
    + modified text_poke_early to return void instead of zero to make it
      clear that it did not return any real error code
    + used the text_poke*_or_die functions where appropriate

Changes in v5:

    + rebased on top of current kernel/git/tip/tip.git

Changes in v4:

    + reverted one change in text_poke in the first patch as suggested by
      Masami Hiramatsu; it means to still call BUG_ON() when the error is
      unclear

Changes in v3:

    + use the new text_poke_part only in text_poke_bp_list because it
      works only with read-write code
    + update all text_poke functions to return error instead on calling BUG()
    + handle text_poke* function return values whenever they were used

Changes in v2:

    + check for number of CPUs instead of enabling IRQs when syncing CPUs;
      suggested by Steven Rostedt, Paul E. McKenney, and Masami Hiramatsu
    + return error codes in text_poke_part and text_poke_bp; needed by ftrace
    + reverted changes in text_poke_bp; it patches only single address again
    + introduce text_poke_bp_iter for patching multiple addresses:
	+ uses iterator and callbacks instead of copying data
	+ checks old code before patching
	+ returns error code and more info about error; needed by ftrace
	+ provides recovery mechanism in case of errors
    + update ftrace.c to use the new text_poke_bp_iter
    + split notrace __probe_kernel_read into separate patch because it
      is useful for original ftrace code as well
    + rebased on current kernel tip and updated performance statistics;
      it started to be slower on idle machine after the commit commit
      c229828ca6bc62d6c654 (rcu: Throttle rcu_try_advance_all_cbs() execution)

I tried to switch between 7 tracers: blk, branch, function_graph, wakeup_rt,
irqsoff, function, and nop. Every tracer has also been enabled and disabled.
With 500 cycles, I got these times before the change:

    real    18m2.477s     18m8.654s     18m9.196s
    user    0m0.008s      0m0.008s	0m0.012s
    sys     0m17.316s     0m17.104s	0m17.300s

and after

    real    17m19.055s    17m29.200s    17m27.456
    user    0m0.052s      0m0.056s	0m0.052s
    sys     0m20.236s     0m20.068s	0m20.264s

The patches are against kernel/git/tip/tip.git on top of the commit
631d5ea8b461f906f87c864f1c27db6eb5211591 (Merge branch 'linus')

Petr Mladek (8):
  x86: allow to handle errors in text_poke function family
  x86: allow to call text_poke_bp during boot
  x86: add generic function to modify more calls using int3 framework
  x86: speed up int3-based patching using direct write
  x86: do not trace __probe_kernel_read
  x86: modify ftrace function using the new int3-based framework
  x86: patch all traced function calls using the int3-based framework
  x86: enable/disable ftrace graph call using new int3-based framework

 arch/x86/include/asm/alternative.h |  46 ++-
 arch/x86/kernel/alternative.c      | 372 +++++++++++++++++++++--
 arch/x86/kernel/ftrace.c           | 583 ++++++++-----------------------------
 arch/x86/kernel/jump_label.c       |   7 +-
 arch/x86/kernel/kgdb.c             |  11 +-
 arch/x86/kernel/kprobes/core.c     |   5 +-
 arch/x86/kernel/kprobes/opt.c      |   8 +-
 arch/x86/kernel/traps.c            |  10 -
 include/linux/ftrace.h             |   6 -
 mm/maccess.c                       |   2 +-
 10 files changed, 525 insertions(+), 525 deletions(-)

-- 
1.8.4

