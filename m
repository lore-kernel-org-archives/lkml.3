Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843Ab3D2TDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:03:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab3D2TDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Karel Srot <ksrot@redhat.com>, Ding Tianhong <dingtianhong@huawei.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/34] af_unix: If we dont care about credentials coallesce all messages
Date: Mon, 29 Apr 2013 12:02:31 -0700
Message-Id: <20130429184703.626754418@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1986,7 +1986,7 @@ again:
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
 			    (UNIXCB(skb).cred != siocb->scm->cred))
 				break;
-		} else {
+		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
 			/* Copy credentials */
 			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
 			check_creds = 1;


