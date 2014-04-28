Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaD1CiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:38:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:44291 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaD1Ch6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:37:58 -0400
From: Shan Hai <shan.hai@windriver.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ftrace/ring_buffer: reset reader page after consuming read was performed to the page
Date: Mon, 28 Apr 2014 10:37:40 +0800
Message-ID: <1398652660-4560-2-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1398652660-4560-1-git-send-email-shan.hai@windriver.com>
References: <1398652660-4560-1-git-send-email-shan.hai@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset the reader page to avoid reading old trace entries repeatedly
in non-consuming read after a force stopped(by signal) consuming read.
The force stopped reader might left the reader page half filled by the
writer while the commit and tail pages are on the page when it is stopped.

The reader page holds the old trace entries until next consuming reader
swaps the page into ring buffer because the reader page is not part of
ring buffer. The non-consuming reader gets the old data repeatedly because
the reading of ring buffer starts from reader page and the reader would not
swap the reader page into ring buffer for its non-consuming nature.

The issue can be reproduced as below:

echo 0 > tracing_on
echo function > current_tracer
echo 1 > tracing_on

1, read the trace file as normal
	cat trace | head -n 20
	...
	cat trace | head -n 20

	The trace entries are changing at the head of the output.
	NOTE:
	If it's not changing at the start please repeat the reading
	several times because the tracer need time to fill up the
	whole buffer.

2, read the trace file after stopping 'cat trace_pipe' by Ctrl-C
	cat trace_pipe
	Ctrl-C
	cat trace | head -n 200
	...
	cat trace | head -n 200

	The trace entries at the head of the output stop changing,
	followed by changing trace entries.
	NOTE:
	Please carefully check the time stamps of the trace entries,
	the time stamps of some of them at the head stop changing
	in the consecutive read.

	The results of test 1 and 2 are not consistent with respect to the
	updating of trace buffers, some part of the trace buffers are
	not updated in the test 2 while all of them are updated in the
	test 1.

	And the result of test 1 is correct because the trace entries
	supposed to be changed for the reason the tracer works under
	overwrite mode by default.

Cc: stable@vger.kernel.org
Signed-off-by: Shan Hai <shan.hai@windriver.com>
---
 kernel/trace/ring_buffer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c634868..76cf402 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3364,6 +3364,14 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
 			return;
 		iter->head = iter->head_page->read;
 	} else {
+		/* Reset the pointers because a force stopped(by signal)
+		 * consuming reader might left the page half filled.
+		 */
+		local_set(&cpu_buffer->reader_page->write, 0);
+		local_set(&cpu_buffer->reader_page->entries, 0);
+		local_set(&cpu_buffer->reader_page->page->commit, 0);
+		cpu_buffer->reader_page->read = 0;
+
 		iter->head_page = cpu_buffer->reader_page;
 		iter->head = cpu_buffer->reader_page->read;
 	}
-- 
1.8.5.2.233.g932f7e4

