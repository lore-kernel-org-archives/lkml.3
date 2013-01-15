Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab3AOXKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:10:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:48086 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934186Ab3AOW42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:56:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 24/71] ring-buffer: Fix race between integrity check and readers
Date: Tue, 15 Jan 2013 14:54:21 -0800
Message-Id: <20130115225342.176297340@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 9366c1ba13fbc41bdb57702e75ca4382f209c82f upstream.

The function rb_check_pages() was added to make sure the ring buffer's
pages were sane. This check is done when the ring buffer size is modified
as well as when the iterator is released (closing the "trace" file),
as that was considered a non fast path and a good place to do a sanity
check.

The problem is that the check does not have any locks around it.
If one process were to read the trace file, and another were to read
the raw binary file, the check could happen while the reader is reading
the file.

The issues with this is that the check requires to clear the HEAD page
before doing the full check and it restores it afterward. But readers
require the HEAD page to exist before it can read the buffer, otherwise
it gives a nasty warning and disables the buffer.

By adding the reader lock around the check, this keeps the race from
happening.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ring_buffer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2926,6 +2926,8 @@ rb_get_reader_page(struct ring_buffer_pe
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
+	if (!reader)
+		goto out;
 	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 


