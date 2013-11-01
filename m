Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3KAWFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:05:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3KAWE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 33/54] net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race
Date: Fri,  1 Nov 2013 15:04:01 -0700
Message-Id: <20131101220215.034738387@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 90c6bd34f884cd9cee21f1d152baf6c18bcac949 ]

In the case of credentials passing in unix stream sockets (dgram
sockets seem not affected), we get a rather sparse race after
commit 16e5726 ("af_unix: dont send SCM_CREDENTIALS by default").

We have a stream server on receiver side that requests credential
passing from senders (e.g. nc -U). Since we need to set SO_PASSCRED
on each spawned/accepted socket on server side to 1 first (as it's
not inherited), it can happen that in the time between accept() and
setsockopt() we get interrupted, the sender is being scheduled and
continues with passing data to our receiver. At that time SO_PASSCRED
is neither set on sender nor receiver side, hence in cmsg's
SCM_CREDENTIALS we get eventually pid:0, uid:65534, gid:65534
(== overflow{u,g}id) instead of what we actually would like to see.

On the sender side, here nc -U, the tests in maybe_add_creds()
invoked through unix_stream_sendmsg() would fail, as at that exact
time, as mentioned, the sender has neither SO_PASSCRED on his side
nor sees it on the server side, and we have a valid 'other' socket
in place. Thus, sender believes it would just look like a normal
connection, not needing/requesting SO_PASSCRED at that time.

As reverting 16e5726 would not be an option due to the significant
performance regression reported when having creds always passed,
one way/trade-off to prevent that would be to set SO_PASSCRED on
the listener socket and allow inheriting these flags to the spawned
socket on server side in accept(). It seems also logical to do so
if we'd tell the listener socket to pass those flags onwards, and
would fix the race.

Before, strace:

recvmsg(4, {msg_name(0)=NULL, msg_iov(1)=[{"blub\n", 4096}],
        msg_controllen=32, {cmsg_len=28, cmsg_level=SOL_SOCKET,
        cmsg_type=SCM_CREDENTIALS{pid=0, uid=65534, gid=65534}},
        msg_flags=0}, 0) = 5

After, strace:

recvmsg(4, {msg_name(0)=NULL, msg_iov(1)=[{"blub\n", 4096}],
        msg_controllen=32, {cmsg_len=28, cmsg_level=SOL_SOCKET,
        cmsg_type=SCM_CREDENTIALS{pid=11580, uid=1000, gid=1000}},
        msg_flags=0}, 0) = 5

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1245,6 +1245,15 @@ static int unix_socketpair(struct socket
 	return 0;
 }
 
+static void unix_sock_inherit_flags(const struct socket *old,
+				    struct socket *new)
+{
+	if (test_bit(SOCK_PASSCRED, &old->flags))
+		set_bit(SOCK_PASSCRED, &new->flags);
+	if (test_bit(SOCK_PASSSEC, &old->flags))
+		set_bit(SOCK_PASSSEC, &new->flags);
+}
+
 static int unix_accept(struct socket *sock, struct socket *newsock, int flags)
 {
 	struct sock *sk = sock->sk;
@@ -1279,6 +1288,7 @@ static int unix_accept(struct socket *so
 	/* attach accepted sock to socket */
 	unix_state_lock(tsk);
 	newsock->state = SS_CONNECTED;
+	unix_sock_inherit_flags(sock, newsock);
 	sock_graft(tsk, newsock);
 	unix_state_unlock(tsk);
 	return 0;


