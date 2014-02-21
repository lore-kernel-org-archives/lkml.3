Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaBUNBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:01:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbaBUMvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 097/121] ring-buffer: Fix first commit on sub-buffer having non-zero delta
Date: Fri, 21 Feb 2014 12:48:41 +0000
Message-Id: <1392986945-9693-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/ring_buffer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cc2f66f..0e337ee 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2397,6 +2397,13 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
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
-- 
1.9.0

