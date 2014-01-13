Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaAMQED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:04:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53365 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbaAMQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 115/208] ceph: fix null pointer dereference
Date: Mon, 13 Jan 2014 15:59:16 +0000
Message-Id: <1389628849-1614-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>

commit c338c07c51e3106711fad5eb599e375eadb6855d upstream.

When register_session() is given an out-of-range argument for mds,
ceph_mdsmap_get_addr() will return a null pointer, which would be given to
ceph_con_open() & be dereferenced, causing a kernel oops. This fixes bug #4685
in the Ceph bug tracker <http://tracker.ceph.com/issues/4685>.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/mds_client.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 17b97ff..96d03db 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -414,6 +414,9 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 {
 	struct ceph_mds_session *s;
 
+	if (mds >= mdsc->mdsmap->m_max_mds)
+		return ERR_PTR(-EINVAL);
+
 	s = kzalloc(sizeof(*s), GFP_NOFS);
 	if (!s)
 		return ERR_PTR(-ENOMEM);
-- 
1.8.3.2

