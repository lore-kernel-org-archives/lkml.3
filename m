Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3KVRKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:10:19 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:34796 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3KVRKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:10:17 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH tty-next 0/5] Halve tty buffer memory consumption
Date: Fri, 22 Nov 2013 12:09:53 -0500
Message-Id: <1385140198-5822-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Greg,

This patchset implements a method of encoding tty 'flip' buffers
such that storage is not allocated for per-byte-received 'flag' bytes
if the data received contains no error.

The N_TTY line discipline already contains logic which assumes that
if the flags buffer ptr is NULL, all data is assumed to be TTY_NORMAL.

Patch 1 documents this behavior and fixes line disciplines not already
handling this condition. The INPUT maintainer is Cc'd on the N_MOUSE
changes.
Patch 2 enables the port driver to alter the default 64k limit
imposed by the tty_buffer core. Hi-throughput drivers (>10MB/sec) can
use this to reduce/eliminate dropped data. A forthcoming fwserial patchset
does just this to remove local rx buffering (and 100 lines of code).
Patch 3 s/memory_used/mem_used
Patch 4 removes the unused tty_prepare_flip_string_flags() function
Patch 5 implements the NULL flag buffer encoding scheme.

For each allocated flip buffer, a bitfield is added which is
used to differentiate a flip buffer without a flags buffer (in which
all data is TTY_NORMAL) from a flip buffer containing 'flagged' data.

If the current flip buffer has no flags field and new 'flagged' data
is inserted, the current flip buffer is committed and a new current
flip buffer is allocated with a flags buffer.

Users of tty_insert_flip_string_flag() always allocates a flags
buffer on the assumption that data is not entirely TTY_NORMAL.

Regards,

Peter Hurley (5):
  tty: Always handle NULL flag ptr
  tty: Enable configurable tty flip buffer limit
  tty: Rename tty buffer memory_used field
  tty: Remove tty_prepare_flip_string_flags()
  tty: Halve flip buffer GFP_ATOMIC memory consumption

 drivers/input/serio/serport.c |  28 +++++------
 drivers/tty/n_gsm.c           |   5 +-
 drivers/tty/n_r3964.c         |   2 +-
 drivers/tty/tty_buffer.c      | 105 ++++++++++++++++++++++++------------------
 include/linux/tty.h           |   7 ++-
 include/linux/tty_flip.h      |  11 +++--
 include/linux/tty_ldisc.h     |   6 ++-
 7 files changed, 96 insertions(+), 68 deletions(-)

-- 
1.8.1.2

