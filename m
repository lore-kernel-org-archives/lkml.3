Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaKQVQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:16:24 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:49219 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaKQVQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:16:22 -0500
Date: Mon, 17 Nov 2014 16:16:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH block/for-next 4/4] block: implement bio_associate_blkcg()
Message-ID: <20141117211619.GG23126@htj.dyndns.org>
References: <20141117211321.GD23126@htj.dyndns.org>
 <20141117211357.GE23126@htj.dyndns.org>
 <20141117211546.GF23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117211546.GF23126@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a bio can only be associated with the io_context and blkcg
of %current using bio_associate_current().  This is too restrictive
for cgroup writeback support.  Implement bio_associate_blkcg() which
associates a bio with the specified blkcg.

bio_associate_blkcg() leaves the io_context unassociated.
bio_associate_current() is updated so that it considers a bio as
already associated if it has a blkcg_css, instead of an io_context,
associated with it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/bio.c         |   24 +++++++++++++++++++++++-
 include/linux/bio.h |    3 +++
 2 files changed, 26 insertions(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1981,6 +1981,28 @@ struct bio_set *bioset_create_nobvec(uns
 EXPORT_SYMBOL(bioset_create_nobvec);
 
 #ifdef CONFIG_BLK_CGROUP
+
+/**
+ * bio_associate_blkcg - associate a bio with the specified blkcg
+ * @bio: target bio
+ * @blkcg_css: the css of the blkcg to associate
+ *
+ * Associate @bio with the blkcg specified by @blkcg_css.  Block layer will
+ * treat @bio as if it were issued by a task which belongs to the blkcg.
+ *
+ * This function takes an extra reference of @blkcg_css which will be put
+ * when @bio is released.  The caller must own @bio and is responsible for
+ * synchronizing calls to this function.
+ */
+int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css)
+{
+	if (unlikely(bio->bi_css))
+		return -EBUSY;
+	css_get(blkcg_css);
+	bio->bi_css = blkcg_css;
+	return 0;
+}
+
 /**
  * bio_associate_current - associate a bio with %current
  * @bio: target bio
@@ -1998,7 +2020,7 @@ int bio_associate_current(struct bio *bi
 {
 	struct io_context *ioc;
 
-	if (bio->bi_ioc)
+	if (bio->bi_css)
 		return -EBUSY;
 
 	ioc = current->io_context;
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -470,9 +470,12 @@ extern void bvec_free(mempool_t *, struc
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
 #ifdef CONFIG_BLK_CGROUP
+int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css);
 int bio_associate_current(struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
 #else	/* CONFIG_BLK_CGROUP */
+static inline int bio_associate_blkcg(struct bio *bio,
+			struct cgroup_subsys_state *blkcg_css) { return 0; }
 static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }
 static inline void bio_disassociate_task(struct bio *bio) { }
 #endif	/* CONFIG_BLK_CGROUP */
