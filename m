Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3FONgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:36:35 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:39750 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3FONgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:36:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 00/16] lockless tty flip buffers
Date: Sat, 15 Jun 2013 09:36:00 -0400
Message-Id: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

** v2 changes **
- Rebased on v4 of 'lockless n_tty receive path'

This 2nd of 4 patchsets implements lockless receive from the tty driver.
By lockless, I'm referring to the 'lock' spin lock formerly used to
serialize access to the flip buffer list.

Since the driver-side flip buffer usage is already single-threaded and
line discipline receiving is already single-threaded, implementing
a lockless flip buffer list was the primary hurdle. [The only 2 flip
buffer consumers, flush_to_ldisc() and tty_buffer_flush() were already
mutually exclusive and this exclusion remains although the mechanism
is changed.]

Since the flip buffer consumers, flush_to_ldisc() and tty_buffer_flush(),
already leave the last-consumed flip buffer on the list, and since the
existing flip buffer api is already divided into an add/commit interface,
most of the requirement for a lockless algorithm was already
in-place. The main differences are;
1) the initial state of the flip buffer list points head and tail
   to a 0-sized sentinel flip buffer. This eliminates head & tail NULL
   testing and assigning the head ptr from the driver-side thread. This
   sentinel is 'consumed' on the first iteration of ldisc receiving and
   does not require special-case logic.
2) the free list uses the atomic singly-linked llist interface. While
   this guarantees safe concurrent usage by both producer and consumer,
   it's not optimal. Both producer and consumer unnecessarily contend
   over the free list head ptr; a better approach would be to maintain
   an unconsumed buffer in the same way the flip buffer list works.
   Light testing has shown this contention accounts for roughly 5% of
   total cpu time in end-to-end copying.
3) The mutual exclusion between consumers is reimplemented as a mutex;
   this eliminates the need to drop the lock across the ldisc
   receive_buf() method. This mutual exclusion is extended to a public
   interface which the vt driver now uses to safely utilize the ldisc
   receive_buf() interface when pasting a selection.

Peter Hurley (16):
  tty: Compute flip buffer ptrs
  tty: Fix flip buffer free list
  tty: Factor flip buffer initialization into helper function
  tty: Merge tty_buffer_find() into tty_buffer_alloc()
  tty: Use generic names for flip buffer list cursors
  tty: Use lockless flip buffer free list
  tty: Simplify flip buffer list with 0-sized sentinel
  tty: Track flip buffer memory limit atomically
  tty: Make driver-side flip buffers lockless
  tty: Ensure single-threaded flip buffer consumer with mutex
  tty: Only perform flip buffer flush from tty_buffer_flush()
  tty: Avoid false-sharing flip buffer ptrs
  tty: Use non-atomic state to signal flip buffer flush pending
  tty: Merge __tty_flush_buffer() into lone call site
  tty: Fix unsafe vt paste_selection()
  tty: Remove private constant from global namespace

 drivers/staging/dgrp/dgrp_tty.c |   2 +
 drivers/tty/pty.c               |  10 +-
 drivers/tty/tty_buffer.c        | 395 +++++++++++++++++++---------------------
 drivers/tty/vt/selection.c      |   4 +-
 include/linux/llist.h           |  23 +++
 include/linux/tty.h             |  39 ++--
 include/linux/tty_flip.h        |   8 +-
 7 files changed, 244 insertions(+), 237 deletions(-)

-- 
1.8.1.2

