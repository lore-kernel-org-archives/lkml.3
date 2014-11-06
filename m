Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaKFOhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:37:25 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:65099 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaKFOhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:37:22 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Colin Cross <ccross@android.com>,
        kernel-team@android.com, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [RESEND PATCH v5 3.18-rc3 0/8] kdb: Allow selective reduction in capabilities
Date: Thu,  6 Nov 2014 14:36:39 +0000
Message-Id: <1415284607-7628-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements restricted modes for the KDB debugger. These
can be used to provide some diagnostic capability to a users with access
to the debug console without giving unrestricted access to the system.

There are no outstanding review comments for this patchset.

Most obvious use cases are to realize a diagnostic mode to tackle
in-the-field failures of systems such as mobile phones, web kiosks or
embedded devices. An concrete example is the serial debugger found in
some android devices which is typically multiplexed over the headphone
or USB socket. Currently Android cannot use kdb for this purpose
because it introduces risks to user data if the phone were connected to
"evil" audio hardware.

The feature is conceptually similarly to the existing code to mask the
available magic SysRq commands. For this reason it is implemented in a
similar way with modes for disable-all (0), enable-all(1) and a bitmask
to enable/disable groups of functionality.

The implementation of the mask check includes a feature to allow a
command to change which group it belongs to based on whether or not the
command has arguments (for example, go without arguments is a very safe
command whilst go with an argument allows arbitrary changes to the
program counter).

There are a few patches, some are just cleanups, some are churn-ish
cleanups, but inevitable. And the rest implements the mode -- after all
the preparations, everything is pretty straightforward.

Changes since v4:
 * Drop patches to avoid deadlock on sysrq spin lock (Rik van Riel's
   984d74a72076... is a much better approach).

Changes since v3:
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

Daniel Thompson (2):
  kdb: Categorize kdb commands (similar to SysRq categorization)
  kdb: Allow access to sensitive commands to be restricted by default

 include/linux/kdb.h            |  62 ++++++++--
 kernel/debug/kdb/kdb_bp.c      |  37 +++---
 kernel/debug/kdb/kdb_main.c    | 263 ++++++++++++++++++++++++++---------------
 kernel/debug/kdb/kdb_private.h |   3 +-
 kernel/trace/trace_kdb.c       |   4 +-
 lib/Kconfig.kgdb               |  25 ++++
 6 files changed, 271 insertions(+), 123 deletions(-)

--
1.9.3

