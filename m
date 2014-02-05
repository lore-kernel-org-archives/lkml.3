Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaBEUDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:03:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:54170 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaBEUDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tyler Hicks <tyhicks@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 013/213] libceph: Fix NULL pointer dereference in auth client code
Date: Wed, 5 Feb 2014 14:59:28 -0500
Message-ID: <1391630568-49251-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
[PG: in v2.6.34, file is fs/ceph and not net/ceph]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ceph/auth_none.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/auth_none.c b/fs/ceph/auth_none.c
index 8cd9e3af07f7..1d1f9b4cbd87 100644
--- a/fs/ceph/auth_none.c
+++ b/fs/ceph/auth_none.c
@@ -31,6 +31,11 @@ static int is_authenticated(struct ceph_auth_client *ac)
 	return !xi->starting;
 }
 
+static int build_request(struct ceph_auth_client *ac, void *buf, void *end)
+{
+	return 0;
+}
+
 /*
  * the generic auth code decode the global_id, and we carry no actual
  * authenticate state, so nothing happens here.
@@ -97,6 +102,7 @@ static const struct ceph_auth_client_ops ceph_auth_none_ops = {
 	.reset = reset,
 	.destroy = destroy,
 	.is_authenticated = is_authenticated,
+	.build_request = build_request,
 	.handle_reply = handle_reply,
 	.create_authorizer = ceph_auth_none_create_authorizer,
 	.destroy_authorizer = ceph_auth_none_destroy_authorizer,
-- 
1.8.5.2

