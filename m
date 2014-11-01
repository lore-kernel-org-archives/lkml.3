Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaKAXBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:01:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60043 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.175915992@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 102/102] ring-buffer: Fix infinite spin in reading buffer
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 24607f114fd14f2f37e3e0cb3d47bce96e81e848 upstream.

Commit 651e22f2701b "ring-buffer: Always reset iterator to reader page"
fixed one bug but in the process caused another one. The reset is to
update the header page, but that fix also changed the way the cached
reads were updated. The cache reads are used to test if an iterator
needs to be updated or not.

A ring buffer iterator, when created, disables writes to the ring buffer
but does not stop other readers or consuming reads from happening.
Although all readers are synchronized via a lock, they are only
synchronized when in the ring buffer functions. Those functions may
be called by any number of readers. The iterator continues down when
its not interrupted by a consuming reader. If a consuming read
occurs, the iterator starts from the beginning of the buffer.

The way the iterator sees that a consuming read has happened since
its last read is by checking the reader "cache". The cache holds the
last counts of the read and the reader page itself.

Commit 651e22f2701b changed what was saved by the cache_read when
the rb_iter_reset() occurred, making the iterator never match the cache.
Then if the iterator calls rb_iter_reset(), it will go into an
infinite loop by checking if the cache doesn't match, doing the reset
and retrying, just to see that the cache still doesn't match! Which
should never happen as the reset is suppose to set the cache to the
current value and there's locks that keep a consuming reader from
having access to the data.

Fixes: 651e22f2701b "ring-buffer: Always reset iterator to reader page"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2847,7 +2847,7 @@ static void rb_iter_reset(struct ring_bu
 	iter->head = cpu_buffer->reader_page->read;
 
 	iter->cache_reader_page = iter->head_page;
-	iter->cache_read = iter->head;
+	iter->cache_read = cpu_buffer->read;
 
 	if (iter->head)
 		iter->read_stamp = cpu_buffer->read_stamp;

