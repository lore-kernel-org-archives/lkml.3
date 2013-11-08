Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab3KHJNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:13:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab3KHJND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:13:03 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v2 0/8] x86: use new text_poke_bp in ftrace
Date: Fri,  8 Nov 2013 10:12:03 +0100
Message-Id: <1383901932-1945-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit fd4363fff3d9 (x86: Introduce int3 (breakpoint)-based instruction
patching) uses the same technique that has been used in ftrace since 08d636b
("ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine")

This patch set merge the two implementations and remove duplicities from
the ftrace side. It adds a generic function to efficiently patch more
instructions at once. It also makes the generic int3-based framework
and the ftrace code a bit faster.

The first patch speed up the existing text_poke_bp.

The next 3 patches improve the generic int3-based framework to be usable
with ftrace. All the changes are based on ideas already used in ftrace.
They are needed to keep the functionality and efficiency.

The 5th patch speedups the original ftrace code but it is useful also
with the generic functions.

The last three patches modifies different parts of the current
x86-specific ftrace implementation and use the generic function there.


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


Unfortunately, the size of the code is almost the same. But most of it is
generic and can be reused.

Also I tried to switch between 7 tracers: blk, branch, function_graph, wakeup_rt,
irqsoff, function, and nop. Every tracer has also been enabled and disabled.
With 500 cycles, I got these times before the change:

    real    18m2.477s     18m8.654s     18m9.196s
    user    0m0.008s      0m0.008s	0m0.012s
    sys     0m17.316s     0m17.104s	0m17.300s

and after

    real    17m9.753s     17m12.272s    17m11.424s
    user    0m0.004s      0m0.004s	0m0.004s
    sys     0m18.244s     0m18.252s	0m18.308s


The patches are against kernel/git/tip/tip.git on top of the commit
af7949e870d4632b Merge branch 'tools/kvm perf fixes'

Petr Mladek (8):
  x86: speed up int3-based patching using less paranoid write
  x86: return error code in text_poke_bp
  x86: allow to call text_poke_bp during boot
  x86: add generic function to modify more calls using int3 framework
  x86: do not trace __probe_kernel_read
  x86: modify ftrace function using the new int3-based framework
  x86: patch all traced function calls using the int3-based framework
  x86: enable/disable ftrace graph call using new int3-based framework

 arch/x86/include/asm/alternative.h |  39 ++-
 arch/x86/kernel/alternative.c      | 321 +++++++++++++++++++--
 arch/x86/kernel/ftrace.c           | 571 ++++++++-----------------------------
 arch/x86/kernel/traps.c            |  10 -
 include/linux/ftrace.h             |   6 -
 mm/maccess.c                       |   2 +-
 6 files changed, 462 insertions(+), 487 deletions(-)

-- 
1.8.4
