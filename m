Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaBONWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 08:22:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:35985 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753050AbaBONWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:22:16 -0500
Message-Id: <20140215132214.688909341@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 15 Feb 2014 08:20:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] ring-buffer: Fix first commit on sub-buffer having non-zero delta
References: <20140215132057.012974140@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Fix-first-commit-on-sub-buffer-having-no.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

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
Cc: stable@vger.kernel.org # 2.6.37+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 294b8a2..fc4da2d 100644
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
1.8.4.3


