Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3F1S46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41836 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3F1S44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 035/105] libceph: fix authorizer invalidation
Date: Fri, 28 Jun 2013 11:50:57 -0700
Message-Id: <1372445527-24414-36-git-send-email-kamal@canonical.com>
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

commit 4b8e8b5d78b8322351d44487c1b76f7e9d3412bc upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/auth_x.c | 2 +-
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
1.8.1.2

