Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbaICW70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:59:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbaICW0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:26:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scott Mayhew <smayhew@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 120/125] nfs: reject changes to resvport and sharecache during remount
Date: Wed,  3 Sep 2014 15:07:57 -0700
Message-Id: <20140903220627.296900659@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit 71a6ec8ac587418ceb6b420def1ca44b334c1ff7 upstream.

Commit c8e47028 made it possible to change resvport/noresvport and
sharecache/nosharecache via a remount operation, neither of which should be
allowed.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Fixes: c8e47028 (nfs: Apply NFS_MOUNT_CMP_FLAGMASK to nfs_compare_remount_data)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/super.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2180,7 +2180,7 @@ out_no_address:
 	return -EINVAL;
 }
 
-#define NFS_MOUNT_CMP_FLAGMASK ~(NFS_MOUNT_INTR \
+#define NFS_REMOUNT_CMP_FLAGMASK ~(NFS_MOUNT_INTR \
 		| NFS_MOUNT_SECURE \
 		| NFS_MOUNT_TCP \
 		| NFS_MOUNT_VER3 \
@@ -2188,15 +2188,16 @@ out_no_address:
 		| NFS_MOUNT_NONLM \
 		| NFS_MOUNT_BROKEN_SUID \
 		| NFS_MOUNT_STRICTLOCK \
-		| NFS_MOUNT_UNSHARED \
-		| NFS_MOUNT_NORESVPORT \
 		| NFS_MOUNT_LEGACY_INTERFACE)
 
+#define NFS_MOUNT_CMP_FLAGMASK (NFS_REMOUNT_CMP_FLAGMASK & \
+		~(NFS_MOUNT_UNSHARED | NFS_MOUNT_NORESVPORT))
+
 static int
 nfs_compare_remount_data(struct nfs_server *nfss,
 			 struct nfs_parsed_mount_data *data)
 {
-	if ((data->flags ^ nfss->flags) & NFS_MOUNT_CMP_FLAGMASK ||
+	if ((data->flags ^ nfss->flags) & NFS_REMOUNT_CMP_FLAGMASK ||
 	    data->rsize != nfss->rsize ||
 	    data->wsize != nfss->wsize ||
 	    data->version != nfss->nfs_client->rpc_ops->version ||


