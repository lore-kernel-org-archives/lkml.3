Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3EJOoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:44:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57038 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542Ab3EJOUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ding Tianhong" <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Karel Srot" <ksrot@redhat.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.413517077@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [091/118] af_unix: If we don't care about credentials coallesce 
 all messages
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 0e82e7f6dfeec1013339612f74abc2cdd29d43d2 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1956,7 +1956,7 @@ static int unix_stream_recvmsg(struct ki
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
 			    (UNIXCB(skb).cred != siocb->scm->cred))
 				break;
-		} else {
+		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
 			/* Copy credentials */
 			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
 			check_creds = 1;

