Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaATPBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:01:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16448 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754033AbaATPBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:01:08 -0500
Message-Id: <20140120150105.464357676@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 20 Jan 2014 10:00:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [for-next][PATCH 2/2] tracing: Fix buggered tee(2) on tracing_pipe
References: <20140120150042.470689818@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-buggered-tee-2-on-tracing_pipe.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>

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
---
 kernel/trace/trace.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cee9c1a..20c755e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4243,12 +4243,6 @@ out:
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
@@ -4260,7 +4254,7 @@ static const struct pipe_buf_operations tracing_pipe_buf_ops = {
 	.map			= generic_pipe_buf_map,
 	.unmap			= generic_pipe_buf_unmap,
 	.confirm		= generic_pipe_buf_confirm,
-	.release		= tracing_pipe_buf_release,
+	.release		= generic_pipe_buf_release,
 	.steal			= generic_pipe_buf_steal,
 	.get			= generic_pipe_buf_get,
 };
-- 
1.8.4.3


