Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaBRXbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:31:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaBRWqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 24/24] nfs: tear down caches in nfs_init_writepagecache when allocation fails
Date: Tue, 18 Feb 2014 14:47:11 -0800
Message-Id: <20140218224550.908833511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 3dd4765fce04c0b4af1e0bc4c0b10f906f95fabc upstream.

...and ensure that we tear down the nfs_commit_data cache too when
unloading the module.

Cc: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2: drop the nfs_cdata_cachep cleanup; it doesn't exist]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/write.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1751,12 +1751,12 @@ int __init nfs_init_writepagecache(void)
 	nfs_wdata_mempool = mempool_create_slab_pool(MIN_POOL_WRITE,
 						     nfs_wdata_cachep);
 	if (nfs_wdata_mempool == NULL)
-		return -ENOMEM;
+		goto out_destroy_write_cache;
 
 	nfs_commit_mempool = mempool_create_slab_pool(MIN_POOL_COMMIT,
 						      nfs_wdata_cachep);
 	if (nfs_commit_mempool == NULL)
-		return -ENOMEM;
+		goto out_destroy_write_mempool;
 
 	/*
 	 * NFS congestion size, scale with available memory.
@@ -1779,6 +1779,12 @@ int __init nfs_init_writepagecache(void)
 		nfs_congestion_kb = 256*1024;
 
 	return 0;
+
+out_destroy_write_mempool:
+	mempool_destroy(nfs_wdata_mempool);
+out_destroy_write_cache:
+	kmem_cache_destroy(nfs_wdata_cachep);
+	return -ENOMEM;
 }
 
 void nfs_destroy_writepagecache(void)


