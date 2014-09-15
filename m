Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbaIOThj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:37:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbaIOThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.14 072/114] ring-buffer: Up rb_iter_peek() loop count to 3
Date: Mon, 15 Sep 2014 12:26:12 -0700
Message-Id: <20140915192643.695147330@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 021de3d904b88b1771a3a2cfc5b75023c391e646 upstream.

After writting a test to try to trigger the bug that caused the
ring buffer iterator to become corrupted, I hit another bug:

 WARNING: CPU: 1 PID: 5281 at kernel/trace/ring_buffer.c:3766 rb_iter_peek+0x113/0x238()
 Modules linked in: ipt_MASQUERADE sunrpc [...]
 CPU: 1 PID: 5281 Comm: grep Tainted: G        W     3.16.0-rc3-test+ #143
 Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
  0000000000000000 ffffffff81809a80 ffffffff81503fb0 0000000000000000
  ffffffff81040ca1 ffff8800796d6010 ffffffff810c138d ffff8800796d6010
  ffff880077438c80 ffff8800796d6010 ffff88007abbe600 0000000000000003
 Call Trace:
  [<ffffffff81503fb0>] ? dump_stack+0x4a/0x75
  [<ffffffff81040ca1>] ? warn_slowpath_common+0x7e/0x97
  [<ffffffff810c138d>] ? rb_iter_peek+0x113/0x238
  [<ffffffff810c138d>] ? rb_iter_peek+0x113/0x238
  [<ffffffff810c14df>] ? ring_buffer_iter_peek+0x2d/0x5c
  [<ffffffff810c6f73>] ? tracing_iter_reset+0x6e/0x96
  [<ffffffff810c74a3>] ? s_start+0xd7/0x17b
  [<ffffffff8112b13e>] ? kmem_cache_alloc_trace+0xda/0xea
  [<ffffffff8114cf94>] ? seq_read+0x148/0x361
  [<ffffffff81132d98>] ? vfs_read+0x93/0xf1
  [<ffffffff81132f1b>] ? SyS_read+0x60/0x8e
  [<ffffffff8150bf9f>] ? tracesys+0xdd/0xe2

Debugging this bug, which triggers when the rb_iter_peek() loops too
many times (more than 2 times), I discovered there's a case that can
cause that function to legitimately loop 3 times!

rb_iter_peek() is different than rb_buffer_peek() as the rb_buffer_peek()
only deals with the reader page (it's for consuming reads). The
rb_iter_peek() is for traversing the buffer without consuming it, and as
such, it can loop for one more reason. That is, if we hit the end of
the reader page or any page, it will go to the next page and try again.

That is, we have this:

 1. iter->head > iter->head_page->page->commit
    (rb_inc_iter() which moves the iter to the next page)
    try again

 2. event = rb_iter_head_event()
    event->type_len == RINGBUF_TYPE_TIME_EXTEND
    rb_advance_iter()
    try again

 3. read the event.

But we never get to 3, because the count is greater than 2 and we
cause the WARNING and return NULL.

Up the counter to 3.

Fixes: 69d1b839f7ee "ring-buffer: Bind time extend and data events together"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1981,7 +1981,7 @@ rb_add_time_stamp(struct ring_buffer_eve
 
 /**
  * rb_update_event - update event type and data
- * @event: the even to update
+ * @event: the event to update
  * @type: the type of event
  * @length: the size of the event field in the ring buffer
  *
@@ -3756,12 +3756,14 @@ rb_iter_peek(struct ring_buffer_iter *it
 		return NULL;
 
 	/*
-	 * We repeat when a time extend is encountered.
-	 * Since the time extend is always attached to a data event,
-	 * we should never loop more than once.
-	 * (We never hit the following condition more than twice).
+	 * We repeat when a time extend is encountered or we hit
+	 * the end of the page. Since the time extend is always attached
+	 * to a data event, we should never loop more than three times.
+	 * Once for going to next page, once on time extend, and
+	 * finally once to get the event.
+	 * (We never hit the following condition more than thrice).
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 2))
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 3))
 		return NULL;
 
 	if (rb_per_cpu_empty(cpu_buffer))


