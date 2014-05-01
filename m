Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaEAPw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:52:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaEAPw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:52:27 -0400
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Date: Thu,  1 May 2014 10:52:04 -0500
Message-Id: <cover.1398958771.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since Jiri posted the kGraft patches [1], I wanted to share an
alternative live patching solution called kpatch, which is something
we've been working on at Red Hat for quite a while.

The kernel piece of it ("kpatch core module") is completely
self-contained in a GPL module.  It compiles and works without needing
to change any kernel code, and in fact we already have it working fine
with Fedora 20 [2] without any distro kernel patches needed.  We'd
definitely like to see it (or some combination of it and kGraft) merged
into Linux.

This patch set is for the core module, which provides the kernel
infrastructure for kpatch.  It has a kpatch_register() interface which
allows kernel modules ("patch modules") to replace old functions with
new functions which are loaded with the modules.

There are also some user space tools [2] which aren't included in this
patch set, which magically generate binary patch modules from source
diffs, and manage the loading and unloading of these modules.   I didn't
include them here because I think we should agree on what the kernel
parts should look like before trying to discuss the user space tools
(and whether they should be in-tree).


kpatch vs kGraft
----------------

I think the biggest difference between kpatch and kGraft is how they
ensure that the patch is applied atomically and safely.

kpatch checks the backtraces of all tasks in stop_machine() to ensure
that no instances of the old function are running when the new function
is applied.  I think the biggest downside of this approach is that
stop_machine() has to idle all other CPUs during the patching process,
so it inserts a small amount of latency (a few ms on an idle system).

Instead, kGraft uses per-task consistency: each task either sees the old
version or the new version of the function.  This gives a consistent
view with respect to functions, but _not_ data, because the old and new
functions are allowed to run simultaneously and share data.  This could
be dangerous if a patch changes how a function uses a data structure.
The new function could make a data change that the old function wasn't
expecting.

With kpatch, that's not an issue because all the functions are patched
at the same time.  So kpatch is safer with respect to data interactions.

Other advantages of the kpatch stop_machine() approach:

- IMO, the kpatch code is much simpler than kGraft.  The implementation
  is very straightforward and is completely self-contained.  It requires
  zero changes to the kernel.
 
  (However a new TAINT_KPATCH flag would be a good idea, and we do
  anticipate some minor changes to kprobes and ftrace for better
  compatibility.)

- The use of stop_machine() will enable an important not-yet-implemented
  feature to call a user-supplied callback function at loading time
  which can be used to atomically update data structures when applying a
  patch.  I don't see how such a feature would be possible with the
  kGraft approach.

- kpatch applies patches immediately without having to send signals to
  sleeping processes, and without having to hope that those processes
  handle the signal appropriately.

- kpatch's patching behavior is more deterministic because
  stop_machine() ensures that all tasks are sleeping and interrupts are
  disabled when the patching occurs.

- kpatch already supports other cool features like:
    - removing patches and rolling back to the original functions
    - atomically replacing existing patches
    - incremental patching
    - loading multiple patch modules


TODO
----

Here are the only outstanding issues:

- A new FTRACE_OPS_FL_PERMANENT flag is needed to tell ftrace to never
  disable the handler.  Otherwise a patch could be temporarily or
  permanently removed in certain situations.

- A few kprobes compatibility issues:
    - Patching of a kprobed function doesn't take effect until the
      kprobe is removed.
    - kretprobes removes the probed function's calling function's IP
      from the stack, which could lead to a false negative in the kpatch
      backtrace safety check.

[1] http://thread.gmane.org/gmane.linux.kernel/1694304
[2] https://github.com/dynup/kpatch


Josh Poimboeuf (2):
  kpatch: add TAINT_KPATCH flag
  kpatch: add kpatch core module

 Documentation/kpatch.txt        | 193 +++++++++++++
 Documentation/oops-tracing.txt  |   3 +
 Documentation/sysctl/kernel.txt |   1 +
 MAINTAINERS                     |   9 +
 arch/Kconfig                    |  14 +
 include/linux/kernel.h          |   1 +
 include/linux/kpatch.h          |  61 ++++
 kernel/Makefile                 |   1 +
 kernel/kpatch/Makefile          |   1 +
 kernel/kpatch/kpatch.c          | 615 ++++++++++++++++++++++++++++++++++++++++
 kernel/panic.c                  |   2 +
 11 files changed, 901 insertions(+)
 create mode 100644 Documentation/kpatch.txt
 create mode 100644 include/linux/kpatch.h
 create mode 100644 kernel/kpatch/Makefile
 create mode 100644 kernel/kpatch/kpatch.c

-- 
1.9.0

