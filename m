Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394Ab3GCTSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:18:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582Ab3GCTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:12 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=U8Bzgq-G5S8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=A_9SkctnnjYA:10 a=DswfTcTIAAAA:8 a=SMDYw-MdfvoSUEmVC6sA:9 a=JfjM6313LcIA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184108.846794430@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [133/141] libceph: fix authorizer invalidation
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0133-libceph-fix-authorizer-invalidation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

[ Upstream commit 4b8e8b5d78b8322351d44487c1b76f7e9d3412bc ]

We were invalidating the authorizer by removing the ticket handler
entirely.  This was effective in inducing us to request a new authorizer,
but in the meantime it mean that any authorizer we generated would get a
new and initialized handler with secret_id=0, which would always be
rejected by the server side with a confusing error message:

 auth: could not find secret_id=0
 cephx: verify_authorizer could not get service secret for service osd secret_id=0

Instead, simply clear the validity field.  This will still induce the auth
code to request a new secret, but will let us continue to use the old
ticket in the meantime.  The messenger code will probably continue to fail,
but the exponential backoff will kick in, and eventually the we will get a
new (hopefully more valid) ticket from the mon and be able to continue.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ceph/auth_x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index a16bf14..bd8758d 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -630,7 +630,7 @@ static void ceph_x_invalidate_authorizer(struct ceph_auth_client *ac,
 
 	th = get_ticket_handler(ac, peer_type);
 	if (!IS_ERR(th))
-		remove_ticket_handler(ac, th);
+		memset(&th->validity, 0, sizeof(th->validity));
 }
 
 
-- 
1.7.10.4


