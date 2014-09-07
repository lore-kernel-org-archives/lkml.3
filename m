Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaIGQW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 12:22:27 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44979
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbaIGQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 12:22:25 -0400
X-IronPort-AV: E=Sophos;i="5.04,483,1406584800"; 
   d="scan'208";a="78047702"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 2/7] staging: lustre: libcfs: expand the GOTO macro
Date: Sun,  7 Sep 2014 18:18:30 +0200
Message-Id: <1410106715-9573-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier lbl;
identifier rc;
constant c;
@@

- GOTO(lbl,\(rc\|c\));
+ goto lbl;

@@
identifier lbl;
expression rc;
@@

- GOTO(lbl,rc);
+ rc;
+ goto lbl;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/libcfs/module.c       |    3 ++-
 drivers/staging/lustre/lustre/libcfs/upcall_cache.c |   20 +++++++++++++-------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/module.c b/drivers/staging/lustre/lustre/libcfs/module.c
index 8267aa9..2c4fc74 100644
--- a/drivers/staging/lustre/lustre/libcfs/module.c
+++ b/drivers/staging/lustre/lustre/libcfs/module.c
@@ -301,7 +301,8 @@ static int libcfs_ioctl(struct cfs_psdev_file *pfile, unsigned long cmd, void *a
 	/* 'cmd' and permissions get checked in our arch-specific caller */
 	if (libcfs_ioctl_getdata(buf, buf + 800, (void *)arg)) {
 		CERROR("PORTALS ioctl: data error\n");
-		GOTO(out, err = -EINVAL);
+		err = -EINVAL;
+		goto out;
 	}
 	data = (struct libcfs_ioctl_data *)buf;
 
diff --git a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
index 0e95588..f5e08caa 100644
--- a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
+++ b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
@@ -205,7 +205,8 @@ find_again:
 			wake_up_all(&entry->ue_waitq);
 			if (unlikely(rc == -EREMCHG)) {
 				put_entry(cache, entry);
-				GOTO(out, entry = ERR_PTR(rc));
+				entry = ERR_PTR(rc);
+				goto out;
 			}
 		}
 	}
@@ -232,14 +233,16 @@ find_again:
 			CERROR("acquire for key %llu: error %d\n",
 			       entry->ue_key, rc);
 			put_entry(cache, entry);
-			GOTO(out, entry = ERR_PTR(rc));
+			entry = ERR_PTR(rc);
+			goto out;
 		}
 	}
 
 	/* invalid means error, don't need to try again */
 	if (UC_CACHE_IS_INVALID(entry)) {
 		put_entry(cache, entry);
-		GOTO(out, entry = ERR_PTR(-EIDRM));
+		entry = ERR_PTR(-EIDRM);
+		goto out;
 	}
 
 	/* check expired
@@ -312,19 +315,22 @@ int upcall_cache_downcall(struct upcall_cache *cache, __u32 err, __u64 key,
 	if (err) {
 		CDEBUG(D_OTHER, "%s: upcall for key %llu returned %d\n",
 		       cache->uc_name, entry->ue_key, err);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	if (!UC_CACHE_IS_ACQUIRING(entry)) {
 		CDEBUG(D_RPCTRACE, "%s: found uptodate entry %p (key %llu)\n",
 		       cache->uc_name, entry, entry->ue_key);
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}
 
 	if (UC_CACHE_IS_INVALID(entry) || UC_CACHE_IS_EXPIRED(entry)) {
 		CERROR("%s: found a stale entry %p (key %llu) in ioctl\n",
 		       cache->uc_name, entry, entry->ue_key);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	spin_unlock(&cache->uc_lock);
@@ -332,7 +338,7 @@ int upcall_cache_downcall(struct upcall_cache *cache, __u32 err, __u64 key,
 		rc = cache->uc_ops->parse_downcall(cache, entry, args);
 	spin_lock(&cache->uc_lock);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	entry->ue_expire = cfs_time_shift(cache->uc_entry_expire);
 	UC_CACHE_SET_VALID(entry);
