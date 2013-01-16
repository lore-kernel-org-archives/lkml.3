Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab3APQCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761Ab3APQCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 072/222] Bluetooth: Add missing lock nesting notation
Date: Wed, 16 Jan 2013 13:54:32 -0200
Message-Id: <1358351822-7675-73-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit dc2a0e20fbc85a71c63aa4330b496fda33f6bf80 upstream.

This patch fixes the following report, it happens when accepting rfcomm
connections:

[  228.165378] =============================================
[  228.165378] [ INFO: possible recursive locking detected ]
[  228.165378] 3.7.0-rc1-00536-gc1d5dc4 #120 Tainted: G        W
[  228.165378] ---------------------------------------------
[  228.165378] bluetoothd/1341 is trying to acquire lock:
[  228.165378]  (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+...}, at:
[<ffffffffa0000aa0>] bt_accept_dequeue+0xa0/0x180 [bluetooth]
[  228.165378]
[  228.165378] but task is already holding lock:
[  228.165378]  (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+...}, at:
[<ffffffffa0205118>] rfcomm_sock_accept+0x58/0x2d0 [rfcomm]
[  228.165378]
[  228.165378] other info that might help us debug this:
[  228.165378]  Possible unsafe locking scenario:
[  228.165378]
[  228.165378]        CPU0
[  228.165378]        ----
[  228.165378]   lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
[  228.165378]   lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
[  228.165378]
[  228.165378]  *** DEADLOCK ***
[  228.165378]
[  228.165378]  May be due to missing lock nesting notation

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/bluetooth/rfcomm/sock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 2df6956..20bd148 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -486,7 +486,7 @@ static int rfcomm_sock_accept(struct socket *sock, struct socket *newsock, int f
 	long timeo;
 	int err = 0;
 
-	lock_sock(sk);
+	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 
 	if (sk->sk_type != SOCK_STREAM) {
 		err = -EINVAL;
@@ -523,7 +523,7 @@ static int rfcomm_sock_accept(struct socket *sock, struct socket *newsock, int f
 
 		release_sock(sk);
 		timeo = schedule_timeout(timeo);
-		lock_sock(sk);
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	}
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(sk_sleep(sk), &wait);
-- 
1.7.9.5

