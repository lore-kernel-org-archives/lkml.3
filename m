Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaHXRIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:08:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:47726 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752318AbaHXRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:08:51 -0400
Message-Id: <20140824170808.753599145@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 24 Aug 2014 13:08:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/5] [GIT PULL] ftrace: Fix issue between function tracer and function profiler
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

The rewrite of the ftrace code that makes it possible to allow for
separate trampolines had a design flaw with the interaction between
the function and function_graph tracers.

The main flaw was the simplification of the use of multiple tracers having
the same filter (like function and function_graph, that use the
set_ftrace_filter file to filter their code). The design assumed that the
two tracers could never run simultaneously as only one tracer can be
used at a time. The problem with this assumption was that the function
profiler could be implemented on top of the function graph tracer, and
the function profiler could run at the same time as the function tracer.
This caused the assumption to be broken and when ftrace detected this
failed assumpiton it would spit out a nasty warning and shut itself down.

Instead of using a single ftrace_ops that switches between the function
and function_graph callbacks, the two tracers can again use their own
ftrace_ops. But instead of having a complex hierarchy of ftrace_ops,
the filter fields are placed in its own structure and the ftrace_ops
can carefully use the same filter. This change took a bit to be able
to allow for this and currently only the global_ops can share the same
filter, but this new design can easily be modified to allow for any
ftrace_ops to share its filter with another ftrace_ops.

The first four patches deal with the change of allowing the ftrace_ops
to share the filter (and this needs to go to 3.16 as well).

The fifth patch fixes a bug that was also caused by the new changes
but only for archs other than x86, and only if those archs implement
a direct call to the function_graph tracer which they do not do yet
but will in the future. It does not need to go to stable, but needs
to be fixed before the other archs update their code to allow direct
calls to the function_graph trampoline.

Please pull the latest trace-fixes-v3.17-rc1 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.17-rc1

Tag SHA1: 12ecec5f97f49cca5f959c484a6ad1450eb759a6
Head SHA1: 39b5552cd5090d4c210d278cd2732f493075f033


Steven Rostedt (Red Hat) (5):
      ftrace: Allow ftrace_ops to use the hashes from other ops
      ftrace: Update all ftrace_ops for a ftrace_hash_ops update
      ftrace: Fix up trampoline accounting with looping on hash ops
      ftrace: Fix function_profiler and function tracer together
      ftrace: Use current addr when converting to nop in __ftrace_replace_code()

----
 include/linux/ftrace.h |  14 ++-
 kernel/trace/ftrace.c  | 246 +++++++++++++++++++++++++++++++------------------
 2 files changed, 168 insertions(+), 92 deletions(-)
