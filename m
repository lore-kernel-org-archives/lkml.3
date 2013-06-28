Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3F1SzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:55:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41696 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3F1SzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 034/105] libceph: clear messenger auth_retry flag when we authenticate
Date: Fri, 28 Jun 2013 11:50:56 -0700
Message-Id: <1372445527-24414-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/messenger.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5ccf87e..be626db 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1546,7 +1546,6 @@ static int process_connect(struct ceph_connection *con)
 			con->error_msg = "connect authorization failure";
 			return -1;
 		}
-		con->auth_retry = 1;
 		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
@@ -1631,7 +1630,7 @@ static int process_connect(struct ceph_connection *con)
 
 		WARN_ON(con->state != CON_STATE_NEGOTIATING);
 		con->state = CON_STATE_OPEN;
-
+		con->auth_retry = 0;    /* we authenticated; clear flag */
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;
-- 
1.8.1.2

