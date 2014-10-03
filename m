Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaJCUUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:20:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:62721 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750AbaJCUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:20:46 -0400
Date: Fri, 3 Oct 2014 16:20:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [GIT PULL] ring-buffer: Fix infinite spin in reading buffer
Message-ID: <20141003162043.6817a486@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

While testing some new changes for 3.18, I kept hitting a bug every so
often in the ring buffer. At first I thought it had to do with some
of the changes I was working on, but then testing something else I
realized that the bug was in 3.17 itself. I ran several bisects as the
bug was not very reproducible, and finally came up with the commit
that I could reproduce easily within a few minutes, and without the change
I could run the tests over an hour without issue. The change fit the
bug and I figured out a fix. That bad commit was:

Commit 651e22f2701b "ring-buffer: Always reset iterator to reader page"

This commit fixed a bug, but in the process created another one. It used
the wrong value as the cached value that is used to see if things changed
while an iterator was in use. This made it look like a change always
happened, and could cause the iterator to go into an infinite loop.


Greg (and stable et al),

This fixes a commit that was marked for stable as far back as 2.6.28.
This patch needs to be added to all stable trees that included the
first fix. Obviously after Linus applies it.

Please pull the latest trace-fixes-v3.17-rc7 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.17-rc7

Tag SHA1: 0c08f2a68c694e7d95dcf2109dc08772056b4746
Head SHA1: 24607f114fd14f2f37e3e0cb3d47bce96e81e848


Steven Rostedt (Red Hat) (1):
      ring-buffer: Fix infinite spin in reading buffer

----
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit 24607f114fd14f2f37e3e0cb3d47bce96e81e848
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Thu Oct 2 16:51:18 2014 -0400

    ring-buffer: Fix infinite spin in reading buffer
    
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

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b38fb2b9e237..2d75c94ae87d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3359,7 +3359,7 @@ static void rb_iter_reset(struct ring_buffer_iter *iter)
 	iter->head = cpu_buffer->reader_page->read;
 
 	iter->cache_reader_page = iter->head_page;
-	iter->cache_read = iter->head;
+	iter->cache_read = cpu_buffer->read;
 
 	if (iter->head)
 		iter->read_stamp = cpu_buffer->read_stamp;
