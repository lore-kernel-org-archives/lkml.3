Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaEDQjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:39:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaEDPlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.14 077/158] nfsd4: fix memory leak in nfsd4_encode_fattr()
Date: Sun,  4 May 2014 11:39:46 -0400
Message-Id: <20140504154040.376748779@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit 18df11d0eacf67bbcd8dda755b568bbbd7264735 upstream.

fh_put() does not free the temporary file handle.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2501,8 +2501,10 @@ out:
 		security_release_secctx(context, contextlen);
 #endif /* CONFIG_NFSD_V4_SECURITY_LABEL */
 	kfree(acl);
-	if (tempfh)
+	if (tempfh) {
 		fh_put(tempfh);
+		kfree(tempfh);
+	}
 	return status;
 out_nfserr:
 	status = nfserrno(err);


