Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3DOPaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:30:08 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45522 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3DOPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:04 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/9] mostly lockless tty echo
Date: Mon, 15 Apr 2013 11:29:38 -0400
Message-Id: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
References: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

