Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbaLJWWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:22:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758227AbaLJWVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:21:55 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCHv6 0/3] Kernel Live Patching
Date: Wed, 10 Dec 2014 16:21:06 -0600
Message-Id: <cover.1418248631.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for all the patches and comments for v5.  Seth is out this week,
so I'm sending this latest patch set in his absence.

Changelog:

changes in v6:
- add empty patch release function
- Petr's patches 2-5:
  - do not quietly ignore wrong usage
  - find and verify the old address in klp_*_init()
  - clean up ordering of functions
  - split init and free code that is done only for loaded modules
- minor cleanups

changes in v5:
- TODO: set IPMODIFY
- Mira and Petr patches
- add livepatch subdir to samples Makefile
- kernel-doc for internal struct fields and other cleanups (colons)
- s/klp_find_symbol/klp_find_object_symbol/
- remove redundant error checks
- protect API functions from init failure
- protect API functions from unregistered patches
- return -EBUSY in klp_unregister_patch()
- remove unneeded comments
- propagate error in klp_init_objects()
- s/free/err/ for error handling labels
- fix broken patch release handling
- add asm/livepatch.h and asm/elf.h includes
- add comment for numpages
- handle NULL obj->name in kobject_create_and_add()
- add notrace to ftrace handler
- mutex protect all of klp_init_patch()
- generate compile error when asm/livepatch.h included but disabled
- add WARN_ON checks
- rename struct klp_reloc fields
- make readonly bool and optimize
- smaller cleanups

changes in v4:
- TODO: set IPMODIFY (Masami patch heading to -next)
- kernel-doc for structures
- dynamically allocate ftrace ops (add ktype and release for func)
- add sample live patch module
- add CC_USING_FENTRY check
- s/LPC_/KLP_/
- objname NULL for vmlinux rather than "vmlinux"
- remove module unload code and licensing (since we are builtin now)
- remove code section headers
- narrow mutex hold to only include list_add() in register path
- split WARN_ON with compound condition
- add inline to static function defined in header file

changes in v3:
- TODO: FTRACE_OPS_FL_DYNAMIC? allocate fops in core?
- TODO: kernel-doc for API structs once agreed upon
- merge API and core data structures (Miroslav)
- replace lp_ and lpc_ prefixes with klp_
- add ARCH_HAVE_LIVE_PATCHING
- guard livepatch.h content with IS_ENABLED(CONFIG_LIVE_PATCHING)
- smaller cleanups

changes in v2:
- TODO: kernel-doc for API structs once agreed upon
- rebase to next-20141113
- add copyright/license block to livepatch.h
- add _LINUX prefix to header defines
- replace semaphore with mutex
- add LPC_ prefix to state enum
- convert BUGs to WARNs and handle properly
- change Kconfig default to n
- remove [old|new] attrs from function sysfs dir (KASLR leak, no use)
- disregard user provided old_addr if kernel uses KASLR
- s/out/err for error path labels
- s/unregister/disable for uniform terminology
- s/lp/lpc for module notifier elements
- replace module ref'ing with unload notifier + mutex protection
- adjust notifier priority to run before ftrace
- make LIVE_PATCHING boolean (about to depend on arch stuff)
- move x86-specific reloc code to arch/x86
- s/dynrela/reloc/
- add live patching sysfs documentation
- add API function kernel-doc

Summary:

This patchset implements an ftrace-based mechanism and kernel interface for
doing live patching of kernel and kernel module functions.  It represents the
greatest common functionality set between kpatch [1] and kGraft [2] and can
accept patches built using either method.  This solution was discussed in the
Live Patching Mini-conference at LPC 2014 [3].

The model consists of a live patching "core" that provides an interface for
other "patch" kernel modules to register patches with the core.

Patch modules contain the new function code and create an klp_patch structure
containing the required data about what functions to patch, where the new code
for each patched function resides, and in which kernel object (vmlinux or
module) the function to be patch resides.  The patch module then invokes the
klp_register_patch() function to register with the core, then klp_enable_patch()
to have the core redirect the execution paths using ftrace.

The live patching core creates a sysfs hierarchy for user-level access to live
patching information.  The hierarchy is structured like this:

/sys/kernel/livepatch
/sys/kernel/livepatch/<patch>
/sys/kernel/livepatch/<patch>/enabled
/sys/kernel/livepatch/<patch>/<object>
/sys/kernel/livepatch/<patch>/<object>/<func>

The old function is located using one of two methods: it is either provided by
the patch module (only possible for a function in vmlinux) or kallsyms lookup.
Symbol ambiguity results in a failure.

The core takes a reference on the patch module itself to keep it from
unloading.  This is because, without a mechanism to ensure that no thread is
currently executing in the patched function, we can not determine whether it is
safe to unload the patch module.  For this reason, unloading patch modules is
currently not allowed.

Disabling patches can be done using the "enabled" attribute of the patch:

echo 0 > /sys/kernel/livepatch/<patch>/enabled

If a patch module contains a patch for a module that is not currently loaded,
there is nothing to patch so the core does nothing for that patch object.
However, the core registers a module notifier that looks for COMING events so
that if the module is ever loaded, it is immediately patched.  If a module with
patch code is removed, the notifier looks for GOING events and disables any
patched functions for that object before it unloads.  The notifier has a higher
priority than that of the ftrace notifier so that it runs before the ftrace
notifier for GOING events and we can cleanly unregister from ftrace.

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

Seth Jennings (3):
  kernel: add TAINT_LIVEPATCH
  kernel: add support for live patching
  samples: add sample live patching module

 Documentation/ABI/testing/sysfs-kernel-livepatch |  44 ++
 Documentation/oops-tracing.txt                   |   2 +
 Documentation/sysctl/kernel.txt                  |   1 +
 MAINTAINERS                                      |  14 +
 arch/x86/Kconfig                                 |   3 +
 arch/x86/include/asm/livepatch.h                 |  36 +
 arch/x86/kernel/Makefile                         |   1 +
 arch/x86/kernel/livepatch.c                      |  89 +++
 include/linux/kernel.h                           |   1 +
 include/linux/livepatch.h                        | 132 ++++
 kernel/Makefile                                  |   1 +
 kernel/livepatch/Kconfig                         |  18 +
 kernel/livepatch/Makefile                        |   3 +
 kernel/livepatch/core.c                          | 935 +++++++++++++++++++++++
 kernel/panic.c                                   |   2 +
 samples/Kconfig                                  |   7 +
 samples/Makefile                                 |   2 +-
 samples/livepatch/Makefile                       |   1 +
 samples/livepatch/livepatch-sample.c             |  87 +++
 19 files changed, 1378 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-livepatch
 create mode 100644 arch/x86/include/asm/livepatch.h
 create mode 100644 arch/x86/kernel/livepatch.c
 create mode 100644 include/linux/livepatch.h
 create mode 100644 kernel/livepatch/Kconfig
 create mode 100644 kernel/livepatch/Makefile
 create mode 100644 kernel/livepatch/core.c
 create mode 100644 samples/livepatch/Makefile
 create mode 100644 samples/livepatch/livepatch-sample.c

-- 
2.1.0

