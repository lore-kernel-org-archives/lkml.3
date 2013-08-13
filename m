Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab3HMQ3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:29:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab3HMQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:57 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=T_KT70vjljoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=AmNDZQdQMsYA:10 a=DfNHnWVPAAAA:8 a=DswfTcTIAAAA:8 a=VwQbUJbxAAAA:8 a=YpVaBtUBoim2dtOaiIEA:9 a=lBRciGGoxdUA:10 a=JfjM6313LcIA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155832.009484979@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tyler Hicks <tyhicks@canonical.com>, Chanam Park <chanam.park@hkpco.kr>,
        Seth Arnold <seth.arnold@canonical.com>, Sage Weil <sage@inktank.com>
Subject: [53/88] libceph: Fix NULL pointer dereference in auth client code
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0053-libceph-Fix-NULL-pointer-dereference-in-auth-client-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

[ Upstream commit 2cb33cac622afde897aa02d3dcd9fbba8bae839e ]

A malicious monitor can craft an auth reply message that could cause a
NULL function pointer dereference in the client's kernel.

To prevent this, the auth_none protocol handler needs an empty
ceph_auth_client_ops->build_request() function.

CVE-2013-1059

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Chanam Park <chanam.park@hkpco.kr>
Reviewed-by: Seth Arnold <seth.arnold@canonical.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ceph/auth_none.c |    6 ++++++
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
1.7.10.4


