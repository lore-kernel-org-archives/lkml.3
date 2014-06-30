Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaF3MbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbaF3MbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jukka Taimisto <jtt@codenomicon.com>,
        Johan Hedberg <johan.hedberg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 147/181] Bluetooth: Fix L2CAP deadlock
Date: Mon, 30 Jun 2014 13:52:48 +0200
Message-Id: <1fb469d54d67cbcb5323f918e9901cc2ac125806.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jukka Taimisto <jtt@codenomicon.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8a96f3cd22878fc0bb564a8478a6e17c0b8dca73 upstream.

-[0x01 Introduction

We have found a programming error causing a deadlock in Bluetooth subsystem
of Linux kernel. The problem is caused by missing release_sock() call when
L2CAP connection creation fails due full accept queue.

The issue can be reproduced with 3.15-rc5 kernel and is also present in
earlier kernels.

-[0x02 Details

The problem occurs when multiple L2CAP connections are created to a PSM which
contains listening socket (like SDP) and left pending, for example,
configuration (the underlying ACL link is not disconnected between
connections).

When L2CAP connection request is received and listening socket is found the
l2cap_sock_new_connection_cb() function (net/bluetooth/l2cap_sock.c) is called.
This function locks the 'parent' socket and then checks if the accept queue
is full.

1178         lock_sock(parent);
1179
1180         /* Check for backlog size */
1181         if (sk_acceptq_is_full(parent)) {
1182                 BT_DBG("backlog full %d", parent->sk_ack_backlog);
1183                 return NULL;
1184         }

If case the accept queue is full NULL is returned, but the 'parent' socket
is not released. Thus when next L2CAP connection request is received the code
blocks on lock_sock() since the parent is still locked.

Also note that for connections already established and waiting for
configuration to complete a timeout will occur and l2cap_chan_timeout()
(net/bluetooth/l2cap_core.c) will be called. All threads calling this
function will also be blocked waiting for the channel mutex since the thread
which is waiting on lock_sock() alread holds the channel mutex.

We were able to reproduce this by sending continuously L2CAP connection
request followed by disconnection request containing invalid CID. This left
the created connections pending configuration.

After the deadlock occurs it is impossible to kill bluetoothd, btmon will not
get any more data etc. requiring reboot to recover.

-[0x03 Fix

Releasing the 'parent' socket when l2cap_sock_new_connection_cb() returns NULL
seems to fix the issue.

Signed-off-by: Jukka Taimisto <jtt@codenomicon.com>
Reported-by: Tommi Mäkilä <tmakila@codenomicon.com>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/l2cap_sock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 0098af80b213..07c9aea21244 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -949,13 +949,16 @@ static struct l2cap_chan *l2cap_sock_new_connection_cb(struct l2cap_chan *chan)
 	/* Check for backlog size */
 	if (sk_acceptq_is_full(parent)) {
 		BT_DBG("backlog full %d", parent->sk_ack_backlog);
+		release_sock(parent);
 		return NULL;
 	}
 
 	sk = l2cap_sock_alloc(sock_net(parent), NULL, BTPROTO_L2CAP,
 			      GFP_ATOMIC);
-	if (!sk)
+	if (!sk) {
+		release_sock(parent);
 		return NULL;
+        }
 
 	bt_sock_reclassify_lock(sk, BTPROTO_L2CAP);
 
-- 
2.0.0

