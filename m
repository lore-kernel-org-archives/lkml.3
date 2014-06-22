Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbaFVWrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 18:47:16 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:54888 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaFVWrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 18:47:15 -0400
From: Mathias Krause <minipli@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Joe Perches <joe@perches.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        Mathias Krause <minipli@googlemail.com>
Subject: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
Date: Mon, 23 Jun 2014 00:46:46 +0200
Message-Id: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This RFC series tries to address the problem of dangling strings of
__init functions after initialization, as well as __exit strings for
code not even included in the final kernel image. The code might get
freed, but the format strings are not.

One solution to the problem might be to declare variables in the code
and mark those variables as __initconst. That, though, makes the code
ugly, as can be seen, e.g., in drivers/hwmon/w83627ehf.c -- a pile of
'static const char[] __initconst' lines just for the pr_info() call.

To be able to mark strings easily patch 1 adds macros to init.h to do so
without the need to explicitly define variables in the code. Internally
it'll declare ones nonetheless, as this seem to be the only way to
attach an __attribute__() to a verbatim string. That's already enough to
solve the problem -- mark the corresponding stings by using these
macros. But patch 2 adds some syntactical sugar for the most popular use
case, by providing pr_<level> alike macros, namely pi_<level> for __init
code and pe_<level> for __exit code. This hides the use of the marker
macros behind the commonly known printing functions -- with just a
single character changed.

Patch 3 exemplarily changes all strings and format strings in
arch/x86/kernel/acpi/boot.c to use the new macros. It also addresses a
few styling issues, though. But this already leads to ~1.7 kB of r/o
data moved to the .init.rodata section, marking it for release after
init.


Open issues with this approach:

1/ When CONFIG_DYNAMIC_DEBUG is enabled, pi_debug() and pe_debug()
fall-back to pr_debug() as there is currently no way of removing the
dynamic entries from the dynamic debug code after init.

2/ The variables used in the macros of patch 1 will pollute the symtab
with unneeded entries. That'll be a problem in the KALLSYMS_ALL case
only, though. But the symtab will be huge then, anyway. However,
filtering those even in this case might be desirable.

3/ It only seamlessly integrates for the pr_<level>() kind of use cases.
For other literal strings it gets slightly less readable, e.g. this:

   strncmp(str, "s4_nohwsig", 10)

becomes this:

   strncmp(str, __init_str("s4_nohwsig"), 10)

That might be okay, though, as it marks the string clearly as an init
string, so might actually increase the understanding of the life time of
the string literal.


So, is there interest in having such macros and markings? Patch 3 shows,
that there's actual value in it. A hacked up script, dully changing
pr_<level> to pi_<level> for __init functions under arch/x86/ already is
able to move ~8kB of r/o data into the .init section. The script,
though, is dump. It does not handle any of the printk() calls, nor does
it handle panic() calls or other strings used only in initialization
code. So there's more to squeeze out. I just want to get some feedback
first.

Also documentation of the new macros is missing, maybe even a
checkpatch.pl change to propose using the new macros instead of pr_*()
or plain printk() in __init / __exit functions.

What do you think?

Regards,
Mathias

Mathias Krause (3):
  init.h: Add __init_str / __exit_str macros
  printk: Provide pi_<level> / pe_<level> macros for __init / __exit
    code
  x86, acpi: Mark __init strings as such

 arch/x86/kernel/acpi/boot.c |  162 ++++++++++++++++++++-----------------------
 include/linux/init.h        |   18 +++++
 include/linux/printk.h      |   52 ++++++++++++++
 3 files changed, 144 insertions(+), 88 deletions(-)

-- 
1.7.10.4

