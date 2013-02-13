Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab3BMLVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:21:42 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55366 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3BMLVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:21:40 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Jean Sacren <sakiwit@gmail.com>, "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>, Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH -next 1/1] net: skbuff: fix compile error in skb_panic()
Date: Wed, 13 Feb 2013 11:20:27 +0000
Message-ID: <1360754427-9051-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_13_11_21_21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following build error on next-20130213 due to the following
commit:

commit f05de73bf82fbbc00265c06d12efb7273f7dc54a ("skbuff: create
skb_panic() function and its wrappers").

It adds an argument called panic to a function that uses the BUG() macro
which tries to call panic, but the argument masks the panic() function
declaration, resulting in the following error (gcc 4.2.4):

net/core/skbuff.c In function 'skb_panic':
net/core/skbuff.c +126 : error: called object 'panic' is not a function

This is fixed by renaming the argument to msg.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Jean Sacren <sakiwit@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: David S. Miller <davem@davemloft.net>
---

Feel free to rename panic to something else or squash this into the
offending commit.

 net/core/skbuff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8731c39..21a22cc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -109,7 +109,7 @@ static const struct pipe_buf_operations sock_pipe_buf_ops = {
  *	@skb:	buffer
  *	@sz:	size
  *	@addr:	address
- *	@panic: skb_over_panic or skb_under_panic
+ *	@msg:	skb_over_panic or skb_under_panic
  *
  *	Out-of-line support for skb_put() and skb_push().
  *	Called via the wrapper skb_over_panic() or skb_under_panic().
@@ -117,10 +117,10 @@ static const struct pipe_buf_operations sock_pipe_buf_ops = {
  *	__builtin_return_address is not used because it is not always reliable.
  */
 static void skb_panic(struct sk_buff *skb, unsigned int sz, void *addr,
-		      const char panic[])
+		      const char msg[])
 {
 	pr_emerg("%s: text:%p len:%d put:%d head:%p data:%p tail:%#lx end:%#lx dev:%s\n",
-		 panic, addr, skb->len, sz, skb->head, skb->data,
+		 msg, addr, skb->len, sz, skb->head, skb->data,
 		 (unsigned long)skb->tail, (unsigned long)skb->end,
 		 skb->dev ? skb->dev->name : "<NULL>");
 	BUG();
-- 
1.8.1.2


