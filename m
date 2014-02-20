Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaBTXxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:53:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbaBTXw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.12 77/82] ring-buffer: Fix first commit on sub-buffer having non-zero delta
Date: Thu, 20 Feb 2014 15:53:00 -0800
Message-Id: <20140220235021.787380002@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit d651aa1d68a2f0a7ee65697b04c6a92f8c0a12f2 upstream.

Each sub-buffer (buffer page) has a full 64 bit timestamp. The events on
that page use a 27 bit delta against that timestamp in order to save on
bits written to the ring buffer. If the time between events is larger than
what the 27 bits can hold, a "time extend" event is added to hold the
entire 64 bit timestamp again and the events after that hold a delta from
that timestamp.

As a "time extend" is always paired with an event, it is logical to just
allocate the event with the time extend, to make things a bit more efficient.

Unfortunately, when the pairing code was written, it removed the "delta = 0"
from the first commit on a page, causing the events on the page to be
slightly skewed.

Fixes: 69d1b839f7ee "ring-buffer: Bind time extend and data events together"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2397,6 +2397,13 @@ __rb_reserve_next(struct ring_buffer_per
 	write &= RB_WRITE_MASK;
 	tail = write - length;
 
+	/*
+	 * If this is the first commit on the page, then it has the same
+	 * timestamp as the page itself.
+	 */
+	if (!tail)
+		delta = 0;
+
 	/* See if we shot pass the end of this buffer page */
 	if (unlikely(write > BUF_PAGE_SIZE))
 		return rb_move_tail(cpu_buffer, length, tail,


