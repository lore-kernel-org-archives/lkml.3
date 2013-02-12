Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289Ab3BLOxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:53:40 -0500
Received: from science.horizon.com ([71.41.210.146]:57496 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761253Ab3BLOxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:37 -0500
MBOX-Line: From ba7ad5b9cd57cae807823676f5a386ca57e997fe Mon Sep 17 00:00:00 2001
Message-Id: <cover.1360677367.git.linux@horizon.com>
From: George Spelvin <linux@horizon.com>
Date: Tue, 12 Feb 2013 08:56:07 -0500
Subject: [PATCH v2 0/9] 3.8-rc regression with pps-ldisc due to 70ece7a731
To: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, giometti@linux.it, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard N_TTY line discipline used to not use the tty->disc_data
field, so N_PPS felt free to use it.  That has now changed, requiring
that N_PPS use a different method to find its private data.

(In the current, buggy, state, N_PPS follows a wild pointer and explodes
in an interrupt hander as soon as a pulse actually arrives.)

Compared to v1, this has been rearranges to the first three patches are
the minimial bugfixes:

* 1/9 "Add pps_lookup_dev() function"
  This adds the infrastructure necessary to bypass disc_data use.

* 2/9 "Use pps_lookup_dev to reduce ldisc coupling"
  This actually fixes the bug.

* 3/9 "Fix a use-after free bug when unregistering a source."
  This is actually an old bug, present before 3.7.  I'd like to solicit
  feedback from folks who know device drivers better to ask if I did
  things right.  I'd also appreciate a look at patch 8/9 which is a more
  aggressive cleanup of the same bug.

The remaining ones are various cleanups enabled or inspired by the
above.

* 4/9 "Don't crash the machine when exiting will do"
  This downgrades some BUG() checks do future bugs will be less deadly.
* 5/9 "Move timestamp read into PPS code proper"
  This changes the internal kernel DCD change interface to capture the
  timestamp inside the called function, cleaning up the generic tty code.
* 6/9 "Additional cleanups in uart_handle_dcd_change"
  Just a slight code reorganization to shrink the source.
* 7/9 "Remove ancient hardpps()"
  Eliminate dead code.
* 8/9 "Use a single cdev"
  This is a more ambitious overhaul of the cdev business that patch
  #3 fixes.
* 9/9 "use test_and_clear_bit in tty_ldisc_close"
  Just a two-liner I noticed while working on the above.

George Spelvin (8):
  pps: Add pps_lookup_dev() function
  pps: Use pps_lookup_dev to reduce ldisc coupling
  pps: Fix a use-after free bug when unregistering a source.
  pps: Additional cleanups in uart_handle_dcd_change
  pps: Use a single cdev
  tty/tty_ldisc.c: use test_and_clear_bit in tty_ldisc_close

Peter Hurley (1):
  pps: Move timestamp read into PPS code proper
  pps: Don't crash the machine when exiting will do
  tty: Remove ancient hardpps()

 drivers/pps/clients/pps-ldisc.c     |  30 +++++++----
 drivers/pps/pps.c                   | 103 +++++++++++++++++++++++++-----------
 drivers/staging/speakup/selection.c |   1 +
 drivers/tty/amiserial.c             |   5 --
 drivers/tty/n_tty.c                 |   3 +-
 drivers/tty/serial/serial_core.c    |  24 +++------
 drivers/tty/tty_buffer.c            |   1 +
 drivers/tty/tty_ldisc.c             |   3 +-
 include/linux/pps_kernel.h          |  18 +++++--
 include/linux/serial_core.h         |   1 -
 include/linux/tty_ldisc.h           |  11 ++--
 11 files changed, 122 insertions(+), 78 deletions(-)

-- 
1.8.1.3

