Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3CZRgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:36:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3CZRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:05 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=degw5TcBr5IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Fku6-PDZvqYA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=otUtUUsR4LFzuAY0LTMA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173600.675534293@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 05/86] tcp: fix MSG_SENDPAGE_NOTLAST logic
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0005-tcp-fix-MSG_SENDPAGE_NOTLAST-logic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 fs/splice.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 41514dd..c69fbb7 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -696,8 +696,10 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
 		return -EINVAL;
 
 	more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
-	if (sd->len < sd->total_len)
+
+	if (sd->len < sd->total_len && pipe->nrbufs > 1)
 		more |= MSG_SENDPAGE_NOTLAST;
+
 	return file->f_op->sendpage(file, buf->page, buf->offset,
 				    sd->len, &pos, more);
 }
-- 
1.7.10.4


