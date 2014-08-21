Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaHUMXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:23:36 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44042 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaHUMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:34 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv3 0/9] Mark literal strings in __init / __exit code
Date: Thu, 21 Aug 2014 14:23:03 +0200
Message-Id: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v3 of the patch series initially posted here:

  https://lkml.org/lkml/2014/6/22/149

This series tries to address the problem of dangling strings of __init
functions after initialization, as well as __exit strings for code not
even included in the final kernel image. The code might get freed, but
the format strings are not, as they're in the wrong section.

One solution to the problem might be to declare variables in the code
and mark those variables as __initconst. That, though, makes the code
ugly, as can be seen, e.g., in drivers/hwmon/w83627ehf.c -- a pile of
'static const char[] __initconst' lines just for the pr_info() call.

To be able to mark strings easily patch 1 adds macros to init.h to do so
without the need to explicitly define variables in the code. (Internally
it'll declare ones nonetheless, as this seem to be the only way to
attach an __attribute__() to a verbatim string.) That's already enough to
solve the problem -- mark the corresponding stings by using these
macros. But patch 2 adds some syntactical sugar for the most popular use
case, by providing pr_<level> alike macros, namely pi_<level> for __init
code and pe_<level> for __exit code. This hides the use of the marker
macros behind the commonly known printing functions -- with just a
single character changed. For code that cannot be changed to use the
pi_<level>() / pe_<level>() helpers printk_init() and printk_exit()
macros are provided, too.

The (hidden) variables used in the macros of patch 1 will pollute the
kernel's symbol table with unneeded entries. It'll be a problem in the
KALLSYMS_ALL case only, however, patch 3 takes care of filtering the
pseudo symbols. They have no value for us beside being the only way to
attach an __attribute__ to a string literal.

If users of the new macros get it wrong, e.g. use printk_init() /
pi_<level>() in non-init code or vice versa printk_exit() / pe_<level>()
in non-exit code, modpost will detect the error as a section mismatch
and report it accordingly. Still, the message printed by modpost with
CONFIG_DEBUG_SECTION_MISMATCH=y is rather confusing as the __initconst /
__exitdata annotation is hidden behind the macros. That's what patch 4
takes care of -- detecting such cases and providing better modpost
messages, guiding the user on how to fix the error.

The remaining patches (5 to 9) exemplarily change strings and format
strings in a selection of files under arch/x86/ to use the new macros.
They also address a few styling issues, e.g., patches 4 and 5 are
cleanup patches I stumbled across while changing the corresponding code
to make use of the new pi_*() helpers. The changes to arch/x86/ already
lead to moving ~3kb of memory from .rodata to .init.rodata. This should
free up a page after init on almost any x86 system.

To show that there's actual more value to it: A hacked up script, dully
changing pr_<level> to pi_<level> for __init functions under arch/x86/
is able to move ~8kB of r/o data into the .init section (partly already
covered by the patches of this series). The script, though, is dump. It
does not handle any of the printk() calls, nor does it handle panic()
calls or other strings used only in initialization code. So there's more
to squeeze out.


Open issues:

1/ When CONFIG_DYNAMIC_DEBUG is enabled, pi_debug() and pe_debug()
fall-back to pr_debug() as there is currently no way of removing the
dynamic entries from the dynamic debug code after init.

2/ It only seamlessly integrates for the pr_<level>() / printk() kind of
use cases. For other literal strings it gets slightly less readable,
e.g. this:

   strncmp(str, "s4_nohwsig", 10)

becomes that:

   strncmp(str, __init_str("s4_nohwsig"), 10)

That might be okay, though, as it marks the string clearly as an init
string, so might actually increase the understanding of the life time of
the string literal.

3/ Documentation: Should the new helpers be documented any further than
already done with the patches themselves, e.g. through a new entry to
Documentation/DocBook/kernel-hacking.tmpl? I'm uncertain as there is no
entry for the pr_<level>() helpers but for the __init / __exit markers.


If this series looks good to you as is, I think patches 1 to 4 should be
merged through Andrew, patches 5 to 9 through the x86 maintainers tree.
Would that work?


Regards,
Mathias

v3: 
- mention modpost error catching on wrong usage in patch 2 (Andrew)
- handle __init / __exit strings in modpost for better diagnostics
- reordered patches: 1-4: arch agnostic, 5-9: x86 specific
- rebased to v3.17-rc1

v2:
- introduce printk_init / printk_exit macros (suggested by Joe)
- filter __init / __exit string pseudo symols in kallsyms
- more x86 related patches making use of the new helpers


Mathias Krause (9):
  init.h: Add __init_str / __exit_str macros
  printk: Provide pi_<level> / pe_<level> macros for __init / __exit
    code
  kallsyms: exclude pseudo symbols for __init / __exit strings
  modpost: provide better diagnostics for __init / __exit strings
  x86, acpi: Mark __init strings as such
  x86, mm: Make x86_init.memory_setup() return a const char *
  x86, mm: early_panic() - pass on the message as string
  x86, mm: e820 - mark __init strings as such
  x86: setup - mark __init strings as such

 arch/x86/include/asm/e820.h     |    4 +-
 arch/x86/include/asm/x86_init.h |    2 +-
 arch/x86/kernel/acpi/boot.c     |  155 ++++++++++++++++++---------------------
 arch/x86/kernel/acpi/sleep.c    |   17 ++---
 arch/x86/kernel/e820.c          |   95 ++++++++++++------------
 arch/x86/kernel/setup.c         |   70 +++++++++---------
 arch/x86/lguest/boot.c          |    2 +-
 arch/x86/xen/setup.c            |    4 +-
 arch/x86/xen/xen-ops.h          |    4 +-
 include/linux/init.h            |   23 ++++++
 include/linux/printk.h          |   59 +++++++++++++++
 scripts/kallsyms.c              |   13 ++++
 scripts/mod/modpost.c           |   94 +++++++++++++++++++-----
 13 files changed, 339 insertions(+), 203 deletions(-)

-- 
1.7.10.4

