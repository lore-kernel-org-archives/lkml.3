Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaARE2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 23:28:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:31906 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752144AbaARE2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 23:28:06 -0500
Date: Fri, 17 Jan 2014 23:28:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL][PATCH] tracing: Fix buggered tee(2) on tracing_pipe
Message-ID: <20140117232801.59b11e0f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Al Viro has concerns with the trace_pipe release method calling
__free_page() instead of using the generic_pipe_buf_release() which
does a page_cache_release(). Looking at the differences between
__free_page() and page_cache_release() I do not think there's a real
issue here. But to be on the safe side, and at least to be symmetric
with generic_pipe_buf_get(), this patch is fine to add.

Please pull the latest trace-fixes-v3.13-rc8 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.13-rc8

Tag SHA1: 5a8329936de8662773042fa76bc3c3d0c48fe5c3
Head SHA1: c50b3d58415b1f46bdb044fbd4e807cda49f0aa2


Al Viro (1):
      tracing: Fix buggered tee(2) on tracing_pipe

----
 kernel/trace/trace.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)
---------------------------
commit c50b3d58415b1f46bdb044fbd4e807cda49f0aa2
Author: Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri Jan 17 07:53:39 2014 -0500

    tracing: Fix buggered tee(2) on tracing_pipe
    
    In kernel/trace/trace.c we have this:
    static void tracing_pipe_buf_release(struct pipe_inode_info *pipe,
                                         struct pipe_buffer *buf)
    {
            __free_page(buf->page);
    }
    static const struct pipe_buf_operations tracing_pipe_buf_ops = {
            .can_merge              = 0,
            .map                    = generic_pipe_buf_map,
            .unmap                  = generic_pipe_buf_unmap,
            .confirm                = generic_pipe_buf_confirm,
            .release                = tracing_pipe_buf_release,
            .steal                  = generic_pipe_buf_steal,
            .get                    = generic_pipe_buf_get,
    };
    with
    void generic_pipe_buf_get(struct pipe_inode_info *pipe, struct pipe_buffer *buf)
    {
            page_cache_get(buf->page);
    }
    
    and I don't see anything that would've prevented tee(2) called on the pipe
    that got stuff spliced into it from that sucker.  ->ops->get() will be
    called, then buf gets copied into target pipe's ->bufs[] and eventually
    readers get to both copies of the buffer.  With
    	get_page(page)
    	look at that page
    	__free_page(page)
    	look at that page
    	__free_page(page)
    which is not a good thing, to put it mildly.  AFAICS, that ought to use
    the normal generic_pipe_buf_release() (aka page_cache_release(buf->page)),
    shouldn't it?
    
    [
     SDR - As trace_pipe just allocates the page with alloc_page(GFP_KERNEL),
      and doesn't do anything special with it (no LRU logic). The __free_page()
      should be fine, as it wont actually free a page with reference count.
      Maybe there's a chance to leak memory? Anyway, This change is at a minimum
      good for being symmetric with generic_pipe_buf_get, it is fine to add.
    ]
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    [ SDR - Removed no longer used tracing_pipe_buf_release ]
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d20cd9..8f86143 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4212,12 +4212,6 @@ out:
 	return sret;
 }
 
-static void tracing_pipe_buf_release(struct pipe_inode_info *pipe,
-				     struct pipe_buffer *buf)
-{
-	__free_page(buf->page);
-}
-
 static void tracing_spd_release_pipe(struct splice_pipe_desc *spd,
 				     unsigned int idx)
 {
@@ -4229,7 +4223,7 @@ static const struct pipe_buf_operations tracing_pipe_buf_ops = {
 	.map			= generic_pipe_buf_map,
 	.unmap			= generic_pipe_buf_unmap,
 	.confirm		= generic_pipe_buf_confirm,
-	.release		= tracing_pipe_buf_release,
+	.release		= generic_pipe_buf_release,
 	.steal			= generic_pipe_buf_steal,
 	.get			= generic_pipe_buf_get,
 };
