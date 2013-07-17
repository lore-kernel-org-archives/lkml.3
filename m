Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197Ab3GQXYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:24:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab3GQWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:50:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hicks <tyhicks@canonical.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 118/145] libceph: Fix NULL pointer dereference in auth client code
Date: Wed, 17 Jul 2013 15:47:30 -0700
Message-Id: <1374101277-7915-119-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 2cb33cac622afde897aa02d3dcd9fbba8bae839e upstream.

A malicious monitor can craft an auth reply message that could cause a
NULL function pointer dereference in the client's kernel.

To prevent this, the auth_none protocol handler needs an empty
ceph_auth_client_ops->build_request() function.

CVE-2013-1059

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Chanam Park <chanam.park@hkpco.kr>
Reviewed-by: Seth Arnold <seth.arnold@canonical.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ceph/auth_none.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index 925ca58..8c93fa8 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -39,6 +39,11 @@ static int should_authenticate(struct ceph_auth_client *ac)
 	return xi->starting;
 }
 
+static int build_request(struct ceph_auth_client *ac, void *buf, void *end)
+{
+	return 0;
+}
+
 /*
  * the generic auth code decode the global_id, and we carry no actual
  * authenticate state, so nothing happens here.
@@ -106,6 +111,7 @@ static const struct ceph_auth_client_ops ceph_auth_none_ops = {
 	.destroy = destroy,
 	.is_authenticated = is_authenticated,
 	.should_authenticate = should_authenticate,
+	.build_request = build_request,
 	.handle_reply = handle_reply,
 	.create_authorizer = ceph_auth_none_create_authorizer,
 	.destroy_authorizer = ceph_auth_none_destroy_authorizer,
-- 
1.8.1.2

