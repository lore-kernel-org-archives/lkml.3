Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaKFOjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:39:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbaKFOjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:39:21 -0500
From: Seth Jennings <sjenning@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Kernel Live Patching
Date: Thu,  6 Nov 2014 08:39:06 -0600
Message-Id: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements an ftrace-based mechanism and kernel interface for
doing live patching of kernel and kernel module functions.  It represents the
greatest common functionality set between kpatch [1] and kGraft [2] and can
accept patches built using either method.  This solution was discussed in the
Live Patching Mini-conference at LPC 2014 [3].

The model consists of a live patching "core" that provides an interface for
other "patch" kernel modules to register patches with the core.

Patch modules contain the new function code and create an lp_patch
structure containing the required data about what functions to patch, where the
new code for each patched function resides, and in which kernel object (vmlinux
or module) the function to be patch resides.  The patch module then invokes the
lp_register_patch() function to register with the core module, then
lp_enable_patch() to have to core module redirect the execution paths using
ftrace.

An example patch module can be found here:
https://github.com/spartacus06/livepatch/blob/master/patch/patch.c

The live patching core creates a sysfs hierarchy for user-level access to live
patching information.  The hierarchy is structured like this:

/sys/kernel/livepatch
/sys/kernel/livepatch/<patch>
/sys/kernel/livepatch/<patch>/enabled
/sys/kernel/livepatch/<patch>/<object>
/sys/kernel/livepatch/<patch>/<object>/<func>
/sys/kernel/livepatch/<patch>/<object>/<func>/new_addr
/sys/kernel/livepatch/<patch>/<object>/<func>/old_addr

The new_addr attribute provides the location of the new version of the function
within the patch module.  The old_addr attribute provides the location of the
old function.  The old function is located using one of two methods: it is
either provided by the patch module (only possible for a function in vmlinux)
or kallsyms lookup.  Symbol ambiguity results in a failure.

The core holds a reference on any kernel module that is patched to ensure it
does not unload while we are redirecting calls from it.  Also, the core takes a
reference on the patch module itself to keep it from unloading.  This is
because, without a mechanism to ensure that no thread is currently executing in
the patched function, we can not determine whether it is safe to unload the
patch module.  For this reason, unloading patch modules is currently not
allowed.

The core is able to release its reference on patched modules by disabling all
patches that patch a function in that module.  Disabling patches can be done
like this:

echo 0 > /sys/kernel/livepatch/<patch>/enabled

Patches can also be re-enabled, however, the core with retake any reference on a
kernel module that contains a patched function.

If a patch module contains a patch for a module that is not currently loaded,
there is nothing to patch so the core does nothing for that object.  However,
the core registers a module notifier so that if the module is ever loaded, it
is immediately patched.

kpatch and kGraft each have their own mechanisms for ensuring system
consistency during the patching process. This first version does not implement
any consistency mechanism that ensures that old and new code do not run
together.  In practice, ~90% of CVEs are safe to apply in this way, since they
simply add a conditional check.  However, any function change that can not
execute safely with the old version of the function can _not_ be safely applied
for now.

[1] https://github.com/dynup/kpatch
[2] https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/
[3] https://etherpad.fr/p/LPC2014_LivePatching

Seth Jennings (2):
  kernel: add TAINT_LIVEPATCH
  kernel: add support for live patching

 Documentation/oops-tracing.txt  |    2 +
 Documentation/sysctl/kernel.txt |    1 +
 MAINTAINERS                     |   10 +
 arch/x86/Kconfig                |    2 +
 include/linux/kernel.h          |    1 +
 include/linux/livepatch.h       |   45 ++
 kernel/Makefile                 |    1 +
 kernel/livepatch/Kconfig        |   11 +
 kernel/livepatch/Makefile       |    3 +
 kernel/livepatch/core.c         | 1020 +++++++++++++++++++++++++++++++++++++++
 kernel/panic.c                  |    2 +
 11 files changed, 1098 insertions(+)
 create mode 100644 include/linux/livepatch.h
 create mode 100644 kernel/livepatch/Kconfig
 create mode 100644 kernel/livepatch/Makefile
 create mode 100644 kernel/livepatch/core.c

-- 
1.9.3

