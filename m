Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbaIOWRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:17:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaIOWRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 080/187] Bluetooth: never linger on process exit
Date: Mon, 15 Sep 2014 15:08:10 -0700
Message-Id: <1410818997-9432-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/l2cap_sock.c  | 3 ++-
 net/bluetooth/rfcomm/sock.c | 3 ++-
 net/bluetooth/sco.c         | 6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index c9e0915..eaa5ad5 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -978,7 +978,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 		l2cap_chan_close(chan, 0);
 		lock_sock(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED,
 						 sk->sk_lingertime);
 	}
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 3c2d3e4..a0050de 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -898,7 +898,8 @@ static int rfcomm_sock_shutdown(struct socket *sock, int how)
 		sk->sk_shutdown = SHUTDOWN_MASK;
 		__rfcomm_sock_close(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 	}
 	release_sock(sk);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 24fa396..316dd4e 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -909,7 +909,8 @@ static int sco_sock_shutdown(struct socket *sock, int how)
 		sco_sock_clear_timer(sk);
 		__sco_sock_close(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED,
 						 sk->sk_lingertime);
 	}
@@ -929,7 +930,8 @@ static int sco_sock_release(struct socket *sock)
 
 	sco_sock_close(sk);
 
-	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime) {
+	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+	    !(current->flags & PF_EXITING)) {
 		lock_sock(sk);
 		err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 		release_sock(sk);
-- 
1.9.1

