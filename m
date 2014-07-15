Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaGOBhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbaGOBhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:37:36 -0400
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, kpatch@redhat.com
Subject: [PATCH v2 0/2] kpatch: dynamic kernel patching
Date: Mon, 14 Jul 2014 20:37:05 -0500
Message-Id: <cover.1405374204.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a v2 posting of the kpatch core module, based on 3.16-rc5.
There have been many improvements since v1
(https://lkml.org/lkml/2014/5/1/273):

- Dynamic relocation support
- Per-object patching
- Module patching and deferred module patching
- User load/unload hook functions
- Force unsafe flag for skipping activeness safety stack check
- Dump stack on activeness safety error
- Function graph tracer compatibility fix

kpatch enables dynamically patching a running kernel.  The kernel piece
of it ("core module") is completely self-contained in a GPL module.  It
compiles and works without needing to change any kernel code.  We
already have it working fine on Fedora and RHEL with stock kernels.
We've also gotten user reports of it working on Ubuntu, Debian and Arch
Linux.

This patch set is for the core module, which provides the kernel
infrastructure for kpatch.  It has a kpatch_register() interface which
allows kernel modules ("patch modules") to replace old functions with
new ones which are loaded with the modules.

There are also some user space tools [1] which convert source patches to
binary patch modules.  The user space tools aren't included in this
patch set.  But it might also make sense to merge them because of how
closely they integrate with the core module.


kpatch advantages compared to kGraft:

* 100% self-contained in its own module.

* Doesn't rely on changing all the kthreads.

* Patch is applied atomically using stop_machine(), so it's safer with
  respect to data semantic changes.

* Patching atomically also makes it much easier to understand and
  analyze a patch to determine whether it's safe for live patching.

* Already supports many advanced features which kGraft is lacking:
  - patched functions can access non-exported symbols, e.g. static
    variables and functions
  - safe unpatching
  - module patching (and deferred module patching)
  - atomic patch replacement
  - supports atomic load/unload user hook functions
  - proper duplicate symbol handling
  - address verification sanity checks
  - sophisticated user space tools for analyzing and converting source
    patches to binary patch modules
  - ability to properly deal with many special sections (__bug_table,
    .data..percpu, etc)


kpatch disadvantages compared to kGraft:

* There is some stop_machine() latency.  But we've found that
  stop_machine() is still pretty fast.  We measured ~1ms on an idle
  system and ~40ms on a heavily loaded 16 CPU system.


Other previously discussed issues:

* Ability to patch functions which are always in use:

  Before it was brought up that kpatch can't patch functions which are
  always on the stack of at least one task.  That limitation has now
  been removed with the new KPATCH_FORCE_UNSAFE macro which allows patch
  authors to skip the backtrace check for patches which don't change
  data semantics.

* Freezing/parking of kernel threads:

  Currently we don't freeze or park kernel threads.  Instead we just put
  them to sleep.  We _could_ do it, but many threads are not freezable
  or parkable.  And I think it would need more discussion anyway.  It's
  definitely not a cure-all because you still have to worry about user
  threads.

  With our current approach, when analyzing whether patches are safe to
  apply live, we assume that all kernel and user threads will be asleep.
  We make no assumptions that any threads will be frozen.  In general we
  avoid changing data and data semantics as much as possible, so it
  shouldn't matter in most cases.  Personally I haven't yet run into a
  case where freezing kernel threads would have made a patch become
  "safe".


Merge status:

I think the only real disadvantage of kpatch compared to kGraft is the
stop_machine() latency.  But the latency is quite small and I think it's
worth the trade-off to get the advantages listed above.

I think we have the same goals as kGraft, and it would be great if we
could find a way to combine our approaches somehow.  It seems to me that
the two approaches are incompatible because a patch author must know in
advance which context a patch will be applied before being able to deem
the patch safe.  For example a patch which changes data semantics might
be safe when applied in the kpatch context but unsafe in the kGraft
context.  But any ideas about how we can reasonably combine the two
approaches are welcome.

Otherwise, if there are no major objections, I think it's in pretty good
shape for being merged.  We've had a lot of user interest in kpatch, and
the number of users of our out-of-tree module on github [1] seems to be
growing.  It would be very helpful to move it in-tree so that we have a
standardized upstream implementation.


Special thanks to the following people who have contributed to this
code:

- Seth Jennings
- Masami Hiramatsu
- Jincheng Miao
- Jan Stancek
- Gaetan Trellu


[1] https://github.com/dynup/kpatch


Josh Poimboeuf (2):
  kpatch: add TAINT_KPATCH flag
  kpatch: add kpatch core module

 Documentation/kpatch.txt        |  209 ++++++++
 Documentation/oops-tracing.txt  |    3 +
 Documentation/sysctl/kernel.txt |    1 +
 MAINTAINERS                     |    9 +
 arch/Kconfig                    |   16 +
 include/linux/kernel.h          |    1 +
 include/linux/kpatch.h          |   95 ++++
 kernel/Makefile                 |    1 +
 kernel/kpatch/Makefile          |    1 +
 kernel/kpatch/kpatch.c          | 1041 +++++++++++++++++++++++++++++++++++++++
 kernel/panic.c                  |    2 +
 11 files changed, 1379 insertions(+)
 create mode 100644 Documentation/kpatch.txt
 create mode 100644 include/linux/kpatch.h
 create mode 100644 kernel/kpatch/Makefile
 create mode 100644 kernel/kpatch/kpatch.c

-- 
1.9.3

