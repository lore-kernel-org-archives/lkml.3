Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaD0RTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:19:20 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48036 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaD0RIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:06 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Jinshan Xiong <jinshan.xiong@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 22/47] staging/lustre/lov: to not hold sub locks at initialization
Date: Sun, 27 Apr 2014 13:06:46 -0400
Message-Id: <1398618431-29757-23-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

Otherwise, it will cause deadlock because it essentially holds
some sub locks and then to request others in an arbitrary order.

Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-on: http://review.whamcloud.com/9152
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/lov/lov_lock.c | 36 +---------------------------
 1 file changed, 1 insertion(+), 35 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_lock.c b/drivers/staging/lustre/lustre/lov/lov_lock.c
index 0bbe141..08ac374 100644
--- a/drivers/staging/lustre/lustre/lov/lov_lock.c
+++ b/drivers/staging/lustre/lustre/lov/lov_lock.c
@@ -346,41 +346,7 @@ static int lov_lock_sub_init(const struct lu_env *env,
 		}
 	}
 	LASSERT(nr == lck->lls_nr);
-	/*
-	 * Then, create sub-locks. Once at least one sub-lock was created,
-	 * top-lock can be reached by other threads.
-	 */
-	for (i = 0; i < lck->lls_nr; ++i) {
-		struct cl_lock       *sublock;
-		struct lov_lock_link *link;
 
-		if (lck->lls_sub[i].sub_lock == NULL) {
-			sublock = lov_sublock_alloc(env, io, lck, i, &link);
-			if (IS_ERR(sublock)) {
-				result = PTR_ERR(sublock);
-				break;
-			}
-			cl_lock_get_trust(sublock);
-			cl_lock_mutex_get(env, sublock);
-			cl_lock_mutex_get(env, parent);
-			/*
-			 * recheck under mutex that sub-lock wasn't created
-			 * concurrently, and that top-lock is still alive.
-			 */
-			if (lck->lls_sub[i].sub_lock == NULL &&
-			    parent->cll_state < CLS_FREEING) {
-				lov_sublock_adopt(env, lck, sublock, i, link);
-				cl_lock_mutex_put(env, parent);
-			} else {
-				OBD_SLAB_FREE_PTR(link, lov_lock_link_kmem);
-				cl_lock_mutex_put(env, parent);
-				cl_lock_unhold(env, sublock,
-					       "lov-parent", parent);
-			}
-			cl_lock_mutex_put(env, sublock);
-			cl_lock_put(env, sublock);
-		}
-	}
 	/*
 	 * Some sub-locks can be missing at this point. This is not a problem,
 	 * because enqueue will create them anyway. Main duty of this function
@@ -533,7 +499,7 @@ static int lov_lock_enqueue_one(const struct lu_env *env, struct lov_lock *lck,
 static int lov_sublock_fill(const struct lu_env *env, struct cl_lock *parent,
 			    struct cl_io *io, struct lov_lock *lck, int idx)
 {
-	struct lov_lock_link *link;
+	struct lov_lock_link *link = NULL;
 	struct cl_lock       *sublock;
 	int		   result;
 
-- 
1.8.5.3

