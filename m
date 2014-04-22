Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbaDVUWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:22:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaDVUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:22:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 110/133] nfsd4: fix memory leak in nfsd4_encode_fattr()
Date: Tue, 22 Apr 2014 13:14:08 -0700
Message-Id: <1398197671-12786-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit 18df11d0eacf67bbcd8dda755b568bbbd7264735 upstream.

fh_put() does not free the temporary file handle.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index dc12d02..1418028 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2430,8 +2430,10 @@ out_acl:
 
 out:
 	kfree(acl);
-	if (fhp == &tempfh)
+	if (fhp == &tempfh) {
 		fh_put(&tempfh);
+		kfree(tempfh);
+	}
 	return status;
 out_nfserr:
 	status = nfserrno(err);
-- 
1.9.1

