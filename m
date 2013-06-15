Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3FOOEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:04:52 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40183 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3FOOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:04:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 0/9] mostly lockless tty echo
Date: Sat, 15 Jun 2013 10:04:20 -0400
Message-Id: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

** v2 changes **
- Rebased on v2 of 'lockless tty flip buffers'

This 3rd of 4 patchsets implements a mostly-lockless tty echo output.

Because echoing is performed solely by the single-threaded ldisc
receive_buf() method, most of the lockless requirements are already
in-place. The main existing complications were;
1) Echoing could overrun itself. A fixed-size buffer is used to record
   the operations necessary when outputting the echoes; the most recent
   echo data is preserved.
2) An attempt to push unprocessed echoes is made by the n_tty_write method
   (on a different thread) before attempting write output.

The overrun condition is solved by outputting the echoes in blocks and
ensuring that at least that much space is available each time an echo
operation is committed. At the conclusion of each flip buffer received,
any remaining unprocessed echoes are output.

This block output method is particularly effective when there is no reader
(the tty is output-only) and termios is misconfigured with echo enabled.

The concurrent access by the n_tty_write() method is already excluded
by the existing output_lock mutex.

Peter Hurley (9):
  n_tty: Remove unused echo_overrun field
  n_tty: Use separate head and tail indices for echo_buf
  n_tty: Replace echo_cnt with computed value
  n_tty: Remove echo_lock
  n_tty: Eliminate echo_commit memory barrier
  n_tty: Process echoes in blocks
  n_tty: Only flush echo output if actually output
  n_tty: Eliminate counter in __process_echoes
  n_tty: Avoid false-sharing echo buffer indices

 drivers/tty/n_tty.c | 248 ++++++++++++++++++++++++----------------------------
 1 file changed, 113 insertions(+), 135 deletions(-)

-- 
1.8.1.2

