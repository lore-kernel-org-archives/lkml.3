Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343Ab3DOPdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:33:22 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45968 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab3DOPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:33:18 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 00/20] streamline per-char receiving
Date: Mon, 15 Apr 2013 11:32:31 -0400
Message-Id: <1366039971-8770-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
References: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 4th of 4 patchsets implements efficient per-char receiving
in the N_TTY line discipline. As mentioned in the initial patchset,
'lockless n_tty receive path', casual performance measurements show
a 9~15x speedup in end-to-end copying.

Most of this patchset factors out modal conditions from the per-char
i/o path. For example, regardless of if ISTRIP is set or not, the modal
condition, I_ISTRIP(tty), was tested on every char received, despite
that ISTRIP can only be set by termios changes.

The modes handled by separate code paths are:
1) 'real raw' mode (which was already handled separately)
2) raw mode
3) EXTPROC when ISTRIP and IUCLC are not selected
4) tty closing mode
5) LNEXT mode
6) ISTRIP or IUCLC or IPARMRK set
7) everything else

The code duplication is kept to a minimum by carefully factoring out
shared slow paths (such as specially handled chars in canonical mode
or receiving PARITY or OVERRUN flags); only the per-char loops themselves
are duplicated.


Peter Hurley (20):
  n_tty: Fix EOF push handling
  n_tty: Remove alias ptrs in __receive_buf()
  n_tty: Move buffers into n_tty_data
  n_tty: Rename process_char_map to char_map
  n_tty: Simplify __receive_buf loop count
  n_tty: Factor 'real raw' receive_buf into standalone fn
  n_tty: Factor signal char handling into separate fn
  n_tty: Factor flagged char handling into separate fn
  n_tty: Factor raw mode receive_buf() into separate fn
  n_tty: Special case EXTPROC receive_buf() as raw mode
  n_tty: Factor tty->closing receive_buf() into separate fn
  n_tty: Factor standard per-char i/o into separate fn
  n_tty: Eliminate char tests from IXANY restart test
  n_tty: Split n_tty_receive_char()
  n_tty: Factor ISTRIP and IUCLC receive_buf into separate fn
  n_tty: Factor PARMRK from normal per-char i/o
  n_tty: Remove overflow tests from receive_buf() path
  n_tty: Un-inline single-use functions
  n_tty: Factor LNEXT processing from per-char i/o path
  tty: Remove extra wakeup from pty write() path

 drivers/tty/n_tty.c  | 617 +++++++++++++++++++++++++++++++--------------------
 drivers/tty/pty.c    |   4 +-
 drivers/tty/tty_io.c |   1 -
 include/linux/tty.h  |   1 -
 4 files changed, 381 insertions(+), 242 deletions(-)

-- 
1.8.1.2

