Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab3FRQfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:35:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab3FRQOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:14:45 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 19/26] libceph: clear messenger auth_retry flag when we authenticate
Date: Tue, 18 Jun 2013 09:14:59 -0700
Message-Id: <20130618161237.111452515@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161231.154881788@linuxfoundation.org>
References: <20130618161231.154881788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/messenger.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1542,7 +1542,6 @@ static int process_connect(struct ceph_c
 			con->error_msg = "connect authorization failure";
 			return -1;
 		}
-		con->auth_retry = 1;
 		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
@@ -1627,7 +1626,7 @@ static int process_connect(struct ceph_c
 
 		WARN_ON(con->state != CON_STATE_NEGOTIATING);
 		con->state = CON_STATE_OPEN;
-
+		con->auth_retry = 0;    /* we authenticated; clear flag */
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;


