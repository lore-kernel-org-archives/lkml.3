Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaDYQ3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:29:51 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:60125 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaDYQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:29:46 -0400
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
Subject: [RFC v3 0/9] kdb: Allow selective reduction in capabilities (was "kiosk mode")
Date: Fri, 25 Apr 2014 17:29:21 +0100
Message-Id: <1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

### This RFC has significant updates since v2. Comments appreciated (I
### hope the next iteration can be PATCH rather than RFC).

This patchset implements restricted modes for the KDB debugger. It is a 
continuation of previous kiosk mode work of Anton Vorontsov (dating 
back to late 2012).

Modelled of the SysRq masking functionality it provides a means for the
root user to choose the set of kdb commands that are available on the
kdb console.

There are a few patches, some are just cleanups, some are churn-ish
cleanups, but inevitable. And the rest implements the mode -- after all
the preparations, everything is pretty straightforward. The first patch
is actually a pure bug fix (arguably unrelated to kiosk mode) but
collides with the code to honour the sysrq mask when capabilities
are stricted so I have included it here.

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
 include/linux/kdb.h            |  66 +++++++++--
 include/linux/sysrq.h          |   1 +
 kernel/debug/kdb/kdb_bp.c      |  37 ++++---
 kernel/debug/kdb/kdb_main.c    | 243 +++++++++++++++++++++++++----------------
 kernel/debug/kdb/kdb_private.h |   3 +-
 kernel/trace/trace_kdb.c       |   4 +-
 lib/Kconfig.kgdb               |  25 +++++
 8 files changed, 264 insertions(+), 126 deletions(-)

-- 
1.9.0

