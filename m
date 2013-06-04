Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3FDWnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:43:04 -0400
Received: from 1wt.eu ([62.212.114.60]:35624 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3FDWm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:59 -0400
Message-Id: <20130604172136.892217862@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 159/184] tcp: fix MSG_SENDPAGE_NOTLAST logic
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ae62ca7b03217be5e74759dc6d7698c95df498b3 ]

commit 35f9c09fe9c72e (tcp: tcp_sendpages() should call tcp_push() once)
added an internal flag : MSG_SENDPAGE_NOTLAST meant to be set on all
frags but the last one for a splice() call.

The condition used to set the flag in pipe_to_sendpage() relied on
splice() user passing the exact number of bytes present in the pipe,
or a smaller one.

But some programs pass an arbitrary high value, and the test fails.

The effect of this bug is a lack of tcp_push() at the end of a
splice(pipe -> socket) call, and possibly very slow or erratic TCP
sessions.

We should both test sd->total_len and fact that another fragment
is in the pipe (pipe->nrbufs > 1)

Many thanks to Willy for providing very clear bug report, bisection
and test programs.

Reported-by: Willy Tarreau <w@1wt.eu>
Bisected-by: Willy Tarreau <w@1wt.eu>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/splice.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index f5d5a2b..cdad986 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -639,8 +639,10 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
 	ret = buf->ops->confirm(pipe, buf);
 	if (!ret) {
 		more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
-		if (sd->len < sd->total_len)
+
+		if (sd->len < sd->total_len && pipe->nrbufs > 1)
 			more |= MSG_SENDPAGE_NOTLAST;
+
 		if (file->f_op && file->f_op->sendpage)
 			ret = file->f_op->sendpage(file, buf->page, buf->offset,
 						   sd->len, &pos, more);
-- 
1.7.12.2.21.g234cd45.dirty



