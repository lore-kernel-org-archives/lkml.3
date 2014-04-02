Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbaDBPoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:44:14 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37904 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665AbaDBPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:44:12 -0400
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
Subject: [RFC v2 00/10] kdb: Kiosk (reduced capabilities) mode
Date: Wed,  2 Apr 2014 16:43:50 +0100
Message-Id: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements "kiosk" mode for KDB debugger and is a 
continuation of previous work by Anton Vorontsov (dating back to late
2012).

When kiosk mode is engaged several kdb commands become disabled leaving
only status reporting functions working normally. In particular arbitrary
memory read/write is prevented and it is no longer possible to alter
program flow.

Note that the commands that remain enabled are sufficient to run the
post-mortem macro commands, dumpcommon, dumpall and dumpcpu. One of the
motivating use-cases for this work is to realize post-mortem on embedded
devices (such as phones) without allowing the debug facility to be easily
exploited to compromise user privacy. In principle this means the feature
can be enabled on production devices.

There are a few patches, some are just cleanups, some are churn-ish
cleanups, but inevitable. And the rest implements the mode -- after all
the preparations, everything is pretty straightforward. The first patch
is actually a pure bug fix (arguably unrelated to kiosk mode) but
collides with the kiosk code to honour the sysrq mask so I have included
it here.

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

Anton Vorontsov (7):
  kdb: Remove currently unused kdbtab_t->cmd_flags
  kdb: Rename kdb_repeat_t to kdb_cmdflags_t, cmd_repeat to cmd_flags
  kdb: Rename kdb_register_repeat() to kdb_register_flags()
  kdb: Use KDB_REPEAT_* values as flags
  kdb: Remove KDB_REPEAT_NONE flag
  kdb: Mark safe commands as KDB_SAFE and KDB_SAFE_NO_ARGS
  kdb: Add kiosk mode

Daniel Thompson (3):
  sysrq: Implement __handle_sysrq_nolock to avoid recursive locking in
    kdb
  kdb: Improve usability of help text when running in kiosk mode
  kdb: Allow access to sensitive commands to be restricted by default

 drivers/tty/sysrq.c            |  11 ++-
 include/linux/kdb.h            |  20 ++--
 include/linux/sysrq.h          |   1 +
 kernel/debug/kdb/kdb_bp.c      |  22 ++---
 kernel/debug/kdb/kdb_main.c    | 207 +++++++++++++++++++++++------------------
 kernel/debug/kdb/kdb_private.h |   3 +-
 kernel/trace/trace_kdb.c       |   4 +-
 lib/Kconfig.kgdb               |  21 +++++
 8 files changed, 172 insertions(+), 117 deletions(-)

-- 
1.9.0

