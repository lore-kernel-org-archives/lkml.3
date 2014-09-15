Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaIOTyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:54:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbaIOTrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.10 45/71] Bluetooth: never linger on process exit
Date: Mon, 15 Sep 2014 12:26:43 -0700
Message-Id: <20140915192640.188805319@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Davydov <vdavydov@parallels.com>

commit 093facf3634da1b0c2cc7ed106f1983da901bbab upstream.

If the current process is exiting, lingering on socket close will make
it unkillable, so we should avoid it.

Reproducer:

  #include <sys/types.h>
  #include <sys/socket.h>

  #define BTPROTO_L2CAP   0
  #define BTPROTO_SCO     2
  #define BTPROTO_RFCOMM  3

  int main()
  {
          int fd;
          struct linger ling;

          fd = socket(PF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
          //or: fd = socket(PF_BLUETOOTH, SOCK_DGRAM, BTPROTO_L2CAP);
          //or: fd = socket(PF_BLUETOOTH, SOCK_SEQPACKET, BTPROTO_SCO);

          ling.l_onoff = 1;
          ling.l_linger = 1000000000;
          setsockopt(fd, SOL_SOCKET, SO_LINGER, &ling, sizeof(ling));

          return 0;
  }

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_sock.c  |    3 ++-
 net/bluetooth/rfcomm/sock.c |    3 ++-
 net/bluetooth/sco.c         |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -887,7 +887,8 @@ static int l2cap_sock_shutdown(struct so
 		l2cap_chan_close(chan, 0);
 		lock_sock(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED,
 						 sk->sk_lingertime);
 	}
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -887,7 +887,8 @@ static int rfcomm_sock_shutdown(struct s
 		sk->sk_shutdown = SHUTDOWN_MASK;
 		__rfcomm_sock_close(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 	}
 	release_sock(sk);
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -858,7 +858,8 @@ static int sco_sock_shutdown(struct sock
 		sco_sock_clear_timer(sk);
 		__sco_sock_close(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED,
 						 sk->sk_lingertime);
 	}
@@ -878,7 +879,8 @@ static int sco_sock_release(struct socke
 
 	sco_sock_close(sk);
 
-	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime) {
+	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+	    !(current->flags & PF_EXITING)) {
 		lock_sock(sk);
 		err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 		release_sock(sk);


