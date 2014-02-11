Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaBKUyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:54:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaBKTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.13 045/120] nfs4: fix discover_server_trunking use after free
Date: Tue, 11 Feb 2014 11:04:46 -0800
Message-Id: <20140211184824.895728026@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@primarydata.com>

commit abad2fa5ba67725a3f9c376c8cfe76fbe94a3041 upstream.

If clp is new (cl_count = 1) and it matches another client in
nfs4_discover_server_trunking, the nfs_put_client will free clp before
->cl_preserve_clid is set.

Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4client.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -409,13 +409,11 @@ struct nfs_client *nfs4_init_client(stru
 	error = nfs4_discover_server_trunking(clp, &old);
 	if (error < 0)
 		goto error;
-	nfs_put_client(clp);
-	if (clp != old) {
-		clp->cl_preserve_clid = true;
-		clp = old;
-	}
 
-	return clp;
+	if (clp != old)
+		clp->cl_preserve_clid = true;
+	nfs_put_client(clp);
+	return old;
 
 error:
 	nfs_mark_client_ready(clp, error);


