Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab3GCTAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:00:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588Ab3GCTAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:13 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Vpf41Lafiw8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=s2ztC6CPknsA:10 a=DswfTcTIAAAA:8 a=4u6H09k7AAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=JfjM6313LcIA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184108.679107562@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [132/141] libceph: clear messenger auth_retry flag when we authenticate
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0132-libceph-clear-messenger-auth_retry-flag-when-we-auth.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

[ Upstream commit 20e55c4cc758e4dccdfd92ae8e9588dd624b2cd7 ]

We maintain a counter of failed auth attempts to allow us to retry once
before failing.  However, if the second attempt succeeds, the flag isn't
cleared, which makes us think auth failed again later when the connection
resets for other reasons (like a socket error).

This is one part of the sorry sequence of events in bug

	http://tracker.ceph.com/issues/4282

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ceph/messenger.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3ef1759..c245379 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1552,7 +1552,6 @@ static int process_connect(struct ceph_connection *con)
 			con->error_msg = "connect authorization failure";
 			return -1;
 		}
-		con->auth_retry = 1;
 		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
 		if (ret < 0)
@@ -1637,7 +1636,7 @@ static int process_connect(struct ceph_connection *con)
 
 		BUG_ON(con->state != CON_STATE_NEGOTIATING);
 		con->state = CON_STATE_OPEN;
-
+		con->auth_retry = 0;    /* we authenticated; clear flag */
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;
-- 
1.7.10.4


