Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaJPTAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:00:04 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33304 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751472AbaJPTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:00:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 00/10] Fixes to controlling tty handling
Date: Thu, 16 Oct 2014 14:59:40 -0400
Message-Id: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch series:
1. removes stale code from the controlling tty handling functions
2. relocates the ctty functions to eliminate forward declarations
3. fixes several unsafe races when setting the controlling tty
4. eliminates holding tty_mutex as a necessary condition of
   setting the controlling terminal

#4 is part of an overall effort to reduce the tty_mutex footprint.

Unfortunately, this series does not fix two other race conditions:
1. disassociate_ctty()/no_tty() does not teardown the tty<->process
associations atomically wrt job control, so it is possible to
observe spurious error conditions from job control (tty_check_change()
and job_control()). I'm looking into inverting the lock order of
tty->ctrl_lock and tsk->sighand->siglock() to see if holding ctrl_lock
is a suitable solution for atomic teardown. Especially now that
ctrl_lock is not used for flow control anymore :)
2. task_pgrp() and task_session() are used unsafely. These fixes
will be clearer after #1 is fixed.

Regards,

Peter Hurley (10):
  tty: Remove tty_pair_get_tty()/tty_pair_get_pty() api
  tty: Reorder proc_set_tty() and related fns
  tty: Remove tsk parameter from proc_set_tty()
  uml: Fix unsafe pid reference to foreground process group
  tty: Replace open-coded tty_get_pgrp()
  tty: Remove !tty condition from __proc_set_tty()
  tty: Fix multiple races when setting the controlling terminal
  tty: Move session_of_pgrp() and make static
  tty: Serialize proc_set_tty() with tty_lock
  tty: Update code comment in __proc_set_tty()

 arch/um/drivers/line.c |   6 +-
 drivers/tty/pty.c      |  24 ++----
 drivers/tty/tty_io.c   | 204 +++++++++++++++++++++++++++----------------------
 include/linux/kernel.h |   3 -
 include/linux/tty.h    |   3 -
 kernel/exit.c          |  21 -----
 6 files changed, 123 insertions(+), 138 deletions(-)

-- 
2.1.1

