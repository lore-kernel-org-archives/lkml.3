Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599Ab3EGEmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:42:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab3EGEZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:41 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=af_Nmj-ES7MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=93VWXKks2GIA:10 a=PtDNVHqPAAAA:8 a=ag1SF4gXAAAA:8 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8 a=J1Y8HTJGAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=wYE_KDyynt4A:10 a=jEp0ucaQiEUA:10 a=hPjdaMEvmhQA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035900.164047030@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Karel Srot <ksrot@redhat.com>, Ding Tianhong <dingtianhong@huawei.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [115/126] af_unix: If we dont care about credentials coallesce all messages
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0115-af_unix-If-we-don-t-care-about-credentials-coallesce.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/unix/af_unix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 1b3abc8..37292d8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1998,7 +1998,7 @@ again:
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
 			    (UNIXCB(skb).cred != siocb->scm->cred))
 				break;
-		} else {
+		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
 			/* Copy credentials */
 			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
 			check_creds = 1;
-- 
1.7.10.4


