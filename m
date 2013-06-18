Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3FRL4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:56:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3FRLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 55/93] libceph: clear messenger auth_retry flag when we authenticate
Date: Tue, 18 Jun 2013 12:43:03 +0100
Message-Id: <1371555821-12820-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 20e55c4cc758e4dccdfd92ae8e9588dd624b2cd7 upstream.

We maintain a counter of failed auth attempts to allow us to retry once
before failing.  However, if the second attempt succeeds, the flag isn't
cleared, which makes us think auth failed again later when the connection
resets for other reasons (like a socket error).

This is one part of the sorry sequence of events in bug

	http://tracker.ceph.com/issues/4282

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/messenger.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 692243a..559690f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1548,7 +1548,6 @@ static int process_connect(struct ceph_connection *con)
 			con->error_msg = "connect authorization failure";
 			return -1;
 		}
-		con->auth_retry = 1;
 		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
@@ -1633,7 +1632,7 @@ static int process_connect(struct ceph_connection *con)
 
 		BUG_ON(con->state != CON_STATE_NEGOTIATING);
 		con->state = CON_STATE_OPEN;
-
+		con->auth_retry = 0;    /* we authenticated; clear flag */
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;
-- 
1.8.1.2

