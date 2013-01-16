Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab3APQBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:01:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab3APQBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:43 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 067/222] ring-buffer: Fix NULL pointer if rb_set_head_page() fails
Date: Wed, 16 Jan 2013 13:54:27 -0200
Message-Id: <1358351822-7675-68-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 54f7be5b831254199522523ccab4c3d954bbf576 upstream.

The function rb_set_head_page() searches the list of ring buffer
pages for a the page that has the HEAD page flag set. If it does
not find it, it will do a WARN_ON(), disable the ring buffer and
return NULL, as this should never happen.

But if this bug happens to happen, not all callers of this function
can handle a NULL pointer being returned from it. That needs to be
fixed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/trace/ring_buffer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index db6dff1..35bf8f7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1396,6 +1396,8 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer)
 		struct list_head *head_page_with_bit;
 
 		head_page = &rb_set_head_page(cpu_buffer)->list;
+		if (!head_page)
+			break;
 		prev_page = head_page->prev;
 
 		first_page = pages->next;
@@ -2934,7 +2936,7 @@ unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
 	unsigned long flags;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
-	unsigned long ret;
+	unsigned long ret = 0;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
@@ -2949,7 +2951,8 @@ unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
 		bpage = cpu_buffer->reader_page;
 	else
 		bpage = rb_set_head_page(cpu_buffer);
-	ret = bpage->page->time_stamp;
+	if (bpage)
+		ret = bpage->page->time_stamp;
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return ret;
@@ -3256,6 +3259,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
+	if (!reader)
+		goto out;
 	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
-- 
1.7.9.5

