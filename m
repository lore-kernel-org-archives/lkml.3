Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab3GKWTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:19:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab3GKWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:19:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>,
        Chanam Park <chanam.park@hkpco.kr>,
        Seth Arnold <seth.arnold@canonical.com>, Sage Weil <sage@inktank.com>
Subject: [ 01/15] libceph: Fix NULL pointer dereference in auth client code
Date: Thu, 11 Jul 2013 15:19:31 -0700
Message-Id: <20130711221256.160285989@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711221255.925669600@linuxfoundation.org>
References: <20130711221255.925669600@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/auth_none.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -39,6 +39,11 @@ static int should_authenticate(struct ce
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
@@ -106,6 +111,7 @@ static const struct ceph_auth_client_ops
 	.destroy = destroy,
 	.is_authenticated = is_authenticated,
 	.should_authenticate = should_authenticate,
+	.build_request = build_request,
 	.handle_reply = handle_reply,
 	.create_authorizer = ceph_auth_none_create_authorizer,
 	.destroy_authorizer = ceph_auth_none_destroy_authorizer,


