Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbaIKNPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:15:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51504 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcel Holtmann" <marcel@holtmann.org>,
        "Vladimir Davydov" <vdavydov@parallels.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.523368870@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 011/131] Bluetooth: never linger on process exit
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/l2cap_sock.c  | 3 ++-
 net/bluetooth/rfcomm/sock.c | 3 ++-
 net/bluetooth/sco.c         | 6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -804,7 +804,8 @@ static int l2cap_sock_shutdown(struct so
 		sk->sk_shutdown = SHUTDOWN_MASK;
 		l2cap_chan_close(chan, 0);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED,
 							sk->sk_lingertime);
 	}
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -901,7 +901,8 @@ static int rfcomm_sock_shutdown(struct s
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
@@ -774,7 +774,8 @@ static int sco_sock_shutdown(struct sock
 		sco_sock_clear_timer(sk);
 		__sco_sock_close(sk);
 
-		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
+		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+		    !(current->flags & PF_EXITING))
 			err = bt_sock_wait_state(sk, BT_CLOSED,
 							sk->sk_lingertime);
 	}
@@ -794,7 +795,8 @@ static int sco_sock_release(struct socke
 
 	sco_sock_close(sk);
 
-	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime) {
+	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+	    !(current->flags & PF_EXITING)) {
 		lock_sock(sk);
 		err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
 		release_sock(sk);

