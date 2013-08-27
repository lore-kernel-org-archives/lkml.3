Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3H0BTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:19:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3H0BHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 08/74] NFC: llcp: Fix non blocking sockets connections
Date: Mon, 26 Aug 2013 18:08:06 -0700
Message-Id: <20130827010426.259043153@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Ortiz <sameo@linux.intel.com>

commit b4011239a08e7e6c2c6e970dfa9e8ecb73139261 upstream.

Without the new LLCP_CONNECTING state, non blocking sockets will be
woken up with a POLLHUP right after calling connect() because their
state is stuck at LLCP_CLOSED.
That prevents userspace from implementing any proper non blocking
socket based NFC p2p client.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/llcp.h      |    1 +
 net/nfc/llcp_sock.c |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/net/nfc/llcp.h
+++ b/net/nfc/llcp.h
@@ -19,6 +19,7 @@
 
 enum llcp_state {
 	LLCP_CONNECTED = 1, /* wait_for_packet() wants that */
+	LLCP_CONNECTING,
 	LLCP_CLOSED,
 	LLCP_BOUND,
 	LLCP_LISTEN,
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -571,7 +571,7 @@ static unsigned int llcp_sock_poll(struc
 	if (sk->sk_shutdown == SHUTDOWN_MASK)
 		mask |= POLLHUP;
 
-	if (sock_writeable(sk))
+	if (sock_writeable(sk) && sk->sk_state == LLCP_CONNECTED)
 		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
 	else
 		set_bit(SOCK_ASYNC_NOSPACE, &sk->sk_socket->flags);
@@ -722,14 +722,16 @@ static int llcp_sock_connect(struct sock
 	if (ret)
 		goto sock_unlink;
 
+	sk->sk_state = LLCP_CONNECTING;
+
 	ret = sock_wait_state(sk, LLCP_CONNECTED,
 			      sock_sndtimeo(sk, flags & O_NONBLOCK));
-	if (ret)
+	if (ret && ret != -EINPROGRESS)
 		goto sock_unlink;
 
 	release_sock(sk);
 
-	return 0;
+	return ret;
 
 sock_unlink:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);


