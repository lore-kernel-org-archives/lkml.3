Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab3EGOI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:08:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42286 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925Ab3EGNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 048/118] af_unix: If we don't care about credentials coallesce all messages
Date: Tue,  7 May 2013 14:38:14 +0100
Message-Id: <1367933964-1564-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 0e82e7f6dfeec1013339612f74abc2cdd29d43d2 upstream.

It was reported that the following LSB test case failed
https://lsbbugs.linuxfoundation.org/attachment.cgi?id=2144 because we
were not coallescing unix stream messages when the application was
expecting us to.

The problem was that the first send was before the socket was accepted
and thus sock->sk_socket was NULL in maybe_add_creds, and the second
send after the socket was accepted had a non-NULL value for sk->socket
and thus we could tell the credentials were not needed so we did not
bother.

The unnecessary credentials on the first message cause
unix_stream_recvmsg to start verifying that all messages had the same
credentials before coallescing and then the coallescing failed because
the second message had no credentials.

Ignoring credentials when we don't care in unix_stream_recvmsg fixes a
long standing pessimization which would fail to coallesce messages when
reading from a unix stream socket if the senders were different even if
we did not care about their credentials.

I have tested this and verified that the in the LSB test case mentioned
above that the messages do coallesce now, while the were failing to
coallesce without this change.

Reported-by: Karel Srot <ksrot@redhat.com>
Reported-by: Ding Tianhong <dingtianhong@huawei.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 023db69..ce7db4b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1996,7 +1996,7 @@ again:
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
 			    (UNIXCB(skb).cred != siocb->scm->cred))
 				break;
-		} else {
+		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
 			/* Copy credentials */
 			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
 			check_creds = 1;
-- 
1.8.1.2

