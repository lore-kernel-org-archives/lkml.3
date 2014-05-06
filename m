Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaEFNEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:04:39 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:51617 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaEFNEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:04:37 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [PATCH v4 0/9] kdb: Allow selective reduction in capabilities (was "kiosk mode")
Date: Tue,  6 May 2014 14:03:40 +0100
Message-Id: <1399381429-16194-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
References: <1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements restricted modes for the KDB debugger. It is a 
continuation of previous kiosk mode work of Anton Vorontsov.

It provides a means for the root user to choose the set of kdb commands
that are available on the kdb console. It is implemented similarly to
the existing code to mask the available magic SysRq commands with modes
for disable-all (0), enable-all(1) and a bitmask to enable/disable
groups of functionality.

The implementation of the mask check includes a feature to allow command
to change which group they belong to based on whether or not the command
has arguments (for example, go without arguments is a very safe command
whilst go with an argument allows arbitrary changes to the program
counter).

There are a few patches, some are just cleanups, some are churn-ish
cleanups, but inevitable. And the rest implements the mode -- after all
the preparations, everything is pretty straightforward. The first patch
is actually a pure bug fix (arguably unrelated to kiosk mode) but
collides with the code to honour the SysRq mask when capabilities are
restricted so I have included it here.

Changes since v3:
 * Rebase to latest mainline (3.15rc4).
 * Improved commenting on safety of calls to __handle_sysrq_nolock
 * Remove magic shift value in the command categorization values and
   expressed the flags using shifts to make code review of the defined
   shift value easier.

Changes since v2:
 * Fixed stupid build error when CONFIG_KDB[_KIOSK]_DEFAULT_ENABLE was not
   defined.
 * Increase flexibility by allowing the userspace greater control over the
   commands to be restricted.
 * Removed the "kiosk" terminology. Its confusing.

Changes since v1 (circa 2012):

 * ef (Display exception frame) is essentially an overly complex peek
   and has therefore been marked unsafe
 * bt (Stack traceback) has been marked safe only with no arguments
 * sr (Magic SysRq key) honours the sysrq mask when called in kiosk
   mode
 * Fixed over-zealous blocking of macro commands
 * Symbol lookup is forbidden by kdbgetaddrarg (more robust, better 
   error reporting to user)
 * Fix deadlock in sr (Magic SysRq key)
 * Better help text in kiosk mode
 * Default (kiosk on/off) can be changed From the config file.


Anton Vorontsov (6):
  kdb: Remove currently unused kdbtab_t->cmd_flags
  kdb: Rename kdb_repeat_t to kdb_cmdflags_t, cmd_repeat to cmd_flags
  kdb: Rename kdb_register_repeat() to kdb_register_flags()
  kdb: Use KDB_REPEAT_* values as flags
  kdb: Remove KDB_REPEAT_NONE flag
  kdb: Add enable mask for groups of commands

Daniel Thompson (3):
  sysrq: Implement __handle_sysrq_nolock to avoid recursive locking in
    kdb
  kdb: Categorize kdb commands (similar to SysRq categorization)
  kdb: Allow access to sensitive commands to be restricted by default

 drivers/tty/sysrq.c            |  11 +-
 include/linux/kdb.h            |  82 ++++++++++++--
 include/linux/sysrq.h          |   1 +
 kernel/debug/kdb/kdb_bp.c      |  37 +++---
 kernel/debug/kdb/kdb_main.c    | 250 +++++++++++++++++++++++++----------------
 kernel/debug/kdb/kdb_private.h |   3 +-
 kernel/trace/trace_kdb.c       |   4 +-
 lib/Kconfig.kgdb               |  25 +++++
 8 files changed, 287 insertions(+), 126 deletions(-)

-- 
1.9.0

