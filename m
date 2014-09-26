Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaIZJ5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:57:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbaIZJqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vladimir Davydov <vdavydov@parallels.com>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 091/142] Bluetooth: never linger on process exit
Date: Fri, 26 Sep 2014 11:45:02 +0200
Message-Id: <14e870b94f25ee268fc220766eadbf67b3a14557.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Davydov <vdavydov@parallels.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/l2cap_sock.c  | 3 ++-
 net/bluetooth/rfcomm/sock.c | 3 ++-
 net/bluetooth/sco.c         | 6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index a3a81d96314b..2710e850b74c 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -882,7 +882,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 		l2cap_chan_close(chan, 0);
 		lock_sock(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED,
 						 sk->sk_lingertime);
 	}
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index c1c6028e389a..7ca014daa5ab 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -887,7 +887,8 @@ static int rfcomm_sock_shutdown(struct socket *sock, int how)
 		sk->sk_shutdown = SHUTDOWN_MASK;
 		__rfcomm_sock_close(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 	}
 	release_sock(sk);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index d021e441b6e6..4f5f01b779b5 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -913,7 +913,8 @@ static int sco_sock_shutdown(struct socket *sock, int how)
 		sco_sock_clear_timer(sk);
 		__sco_sock_close(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED,
 						 sk->sk_lingertime);
 	}
@@ -933,7 +934,8 @@ static int sco_sock_release(struct socket *sock)
 
 	sco_sock_close(sk);
 
-	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime) {
+	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+	    !(current->flags & PF_EXITING)) {
 		lock_sock(sk);
 		err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 		release_sock(sk);
-- 
2.1.0

