Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3KXXmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 18:42:32 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752957Ab3KXXm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 18:42:28 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        shawnlandden@gmail.com, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, herbert@gondor.hengli.com.au,
        Richard Weinberger <richard@nod.at>, Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <stable@vger.kernel.org>
Subject: [PATCH] pipe_to_sendpage: Ensure that MSG_MORE is set if we set MSG_SENDPAGE_NOTLAST
Date: Mon, 25 Nov 2013 00:42:07 +0100
Message-Id: <1385336527-27304-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <CAJusiZXN4dOxg9S4ZiCziVXfNZ+=yu7a=84vUikV2RhbhYU7QA@mail.gmail.com>
References: <CAJusiZXN4dOxg9S4ZiCziVXfNZ+=yu7a=84vUikV2RhbhYU7QA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 35f9c09fe (tcp: tcp_sendpages() should call tcp_push() once)
added an internal flag MSG_SENDPAGE_NOTLAST.
We have to ensure that MSG_MORE is also set if we set MSG_SENDPAGE_NOTLAST.
Otherwise users that check against MSG_MORE will not see it.

This fixes sendfile() on AF_ALG.

Cc: Tom Herbert <therbert@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org> # 3.4.x
Reported-and-tested-by: Shawn Landden <shawnlandden@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/splice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3b7ee65..b93f1b8 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -701,7 +701,7 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
 	more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
 
 	if (sd->len < sd->total_len && pipe->nrbufs > 1)
-		more |= MSG_SENDPAGE_NOTLAST;
+		more |= MSG_SENDPAGE_NOTLAST | MSG_MORE;
 
 	return file->f_op->sendpage(file, buf->page, buf->offset,
 				    sd->len, &pos, more);
-- 
1.8.1.4

