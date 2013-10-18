Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3JRO1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:27:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab3JRO1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:27:30 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 0/6] x86: use new text_poke_bp in ftrace
Date: Fri, 18 Oct 2013 16:27:19 +0200
Message-Id: <1382106445-31468-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit fd4363fff3d9 (x86: Introduce int3 (breakpoint)-based instruction
patching) uses the same technique that has been used in ftrace since 08d636b
("ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine")

This patch set merge the two implemetations and remove duplicities from
the ftrace side.

The first three patches speed up and extend the existing text_poke_bp
function to be usable in ftrace. All the changes are based on ideas
already used in ftrace. They need to be moved to the generic framework
to keep the functinality and efficiency.

The other three patches modifies different parts of the current
x86-specific ftrace implemetation and use text_poke_bp there.

The result is an improved generic code that has already been used
in jump labels and kprobe. It reduces the amount of arch-specific
ftrace code. It is also a bit faster. For example, I tried to modify
the ftrace function, enable, and disable the tracer in a cycle.
With 9 different trace functions and 500 cycles, I got these times:

	original code:                  with this patch set:

	real    20m8.123s               real    18m47.042s
	user    0m0.004s                user    0m0.008s
	sys     0m28.400s               sys     0m42.760s

	real    19m59.777s              real    18m41.668s
	user    0m0.004s                user    0m0.000s
	sys     0m28.344s               sys     0m43.576s

	real    19m57.598s              real    18m38.203s
	user    0m0.004s                user    0m0.004s
	sys     0m28.728s               sys     0m43.104s

This is my first patch set for Linux kernel. I did a lot of checks
and test but it is possible that I have missed something. I am looking
forward to hear your opinion, hints and update the patches accordingly.

The patches are agaist kernel/git/tip/tip.git on top of the commit
f3db36699379159b761cdbc (Merge branch 'sched/core').

Petr Mladek (6)
  x86: speed up int3-based patching using less paranoid
  x86: allow to call text_poke_bp during boot
  x86: allow to modify more instructions in one
  x86: modify ftrace function using the new int3-based
  x86: patch all traced function calls using the
  x86: enable/disable ftrace graph call using new

 arch/x86/include/asm/alternative.h |   3 +-
 arch/x86/kernel/alternative.c      | 135 ++++++--
 arch/x86/kernel/ftrace.c           | 605 ++++++++---------------------------
 arch/x86/kernel/jump_label.c       |   3 +-
 arch/x86/kernel/kprobes/opt.c      |   8 +-
 arch/x86/kernel/traps.c            |  10 -
 lib/bsearch.c                      |   2 +-
 7 files changed, 264 insertions(+), 502 deletions(-)
