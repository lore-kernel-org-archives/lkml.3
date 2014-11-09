Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaKIJMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:12:41 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:60325 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbaKIJLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:11:43 -0500
X-IronPort-AV: E=Sophos;i="5.07,345,1413237600"; 
   d="scan'208";a="105805276"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: kernel-janitors@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: lustre: osc: remove final uses of the GOTO macro
Date: Sun,  9 Nov 2014 10:06:32 +0100
Message-Id: <1415523994-12520-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415523994-12520-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1415523994-12520-1-git-send-email-Julia.Lawall@lip6.fr>
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

In one case (OES_INV), consecutive gotos were factorized and a break was
removed.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/osc/osc_cache.c |  168 +++++++++++++++++---------
 1 file changed, 110 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index ec04935..f8c8b66 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -178,76 +178,113 @@ static int osc_extent_sanity_check0(struct osc_extent *ext,
 	int page_count;
 	int rc = 0;
 
-	if (!osc_object_is_locked(obj))
-		GOTO(out, rc = 9);
+	if (!osc_object_is_locked(obj)) {
+		rc = 9;
+		goto out;
+	}
 
-	if (ext->oe_state >= OES_STATE_MAX)
-		GOTO(out, rc = 10);
+	if (ext->oe_state >= OES_STATE_MAX) {
+		rc = 10;
+		goto out;
+	}
 
-	if (atomic_read(&ext->oe_refc) <= 0)
-		GOTO(out, rc = 20);
+	if (atomic_read(&ext->oe_refc) <= 0) {
+		rc = 20;
+		goto out;
+	}
 
-	if (atomic_read(&ext->oe_refc) < atomic_read(&ext->oe_users))
-		GOTO(out, rc = 30);
+	if (atomic_read(&ext->oe_refc) < atomic_read(&ext->oe_users)) {
+		rc = 30;
+		goto out;
+	}
 
 	switch (ext->oe_state) {
 	case OES_INV:
 		if (ext->oe_nr_pages > 0 || !list_empty(&ext->oe_pages))
-			GOTO(out, rc = 35);
-		GOTO(out, rc = 0);
-		break;
+			rc = 35;
+		else
+			rc = 0;
+		goto out;
 	case OES_ACTIVE:
-		if (atomic_read(&ext->oe_users) == 0)
-			GOTO(out, rc = 40);
-		if (ext->oe_hp)
-			GOTO(out, rc = 50);
-		if (ext->oe_fsync_wait && !ext->oe_urgent)
-			GOTO(out, rc = 55);
+		if (atomic_read(&ext->oe_users) == 0) {
+			rc = 40;
+			goto out;
+		}
+		if (ext->oe_hp) {
+			rc = 50;
+			goto out;
+		}
+		if (ext->oe_fsync_wait && !ext->oe_urgent) {
+			rc = 55;
+			goto out;
+		}
 		break;
 	case OES_CACHE:
-		if (ext->oe_grants == 0)
-			GOTO(out, rc = 60);
-		if (ext->oe_fsync_wait && !ext->oe_urgent && !ext->oe_hp)
-			GOTO(out, rc = 65);
+		if (ext->oe_grants == 0) {
+			rc = 60;
+			goto out;
+		}
+		if (ext->oe_fsync_wait && !ext->oe_urgent && !ext->oe_hp) {
+			rc = 65;
+			goto out;
+		}
 	default:
-		if (atomic_read(&ext->oe_users) > 0)
-			GOTO(out, rc = 70);
+		if (atomic_read(&ext->oe_users) > 0) {
+			rc = 70;
+			goto out;
+		}
 	}
 
-	if (ext->oe_max_end < ext->oe_end || ext->oe_end < ext->oe_start)
-		GOTO(out, rc = 80);
+	if (ext->oe_max_end < ext->oe_end || ext->oe_end < ext->oe_start) {
+		rc = 80;
+		goto out;
+	}
 
-	if (ext->oe_osclock == NULL && ext->oe_grants > 0)
-		GOTO(out, rc = 90);
+	if (ext->oe_osclock == NULL && ext->oe_grants > 0) {
+		rc = 90;
+		goto out;
+	}
 
 	if (ext->oe_osclock) {
 		struct cl_lock_descr *descr;
 		descr = &ext->oe_osclock->cll_descr;
 		if (!(descr->cld_start <= ext->oe_start &&
-		      descr->cld_end >= ext->oe_max_end))
-			GOTO(out, rc = 100);
+		      descr->cld_end >= ext->oe_max_end)) {
+			rc = 100;
+			goto out;
+		}
 	}
 
-	if (ext->oe_nr_pages > ext->oe_mppr)
-		GOTO(out, rc = 105);
+	if (ext->oe_nr_pages > ext->oe_mppr) {
+		rc = 105;
+		goto out;
+	}
 
 	/* Do not verify page list if extent is in RPC. This is because an
 	 * in-RPC extent is supposed to be exclusively accessible w/o lock. */
-	if (ext->oe_state > OES_CACHE)
-		GOTO(out, rc = 0);
+	if (ext->oe_state > OES_CACHE) {
+		rc = 0;
+		goto out;
+	}
 
-	if (!extent_debug)
-		GOTO(out, rc = 0);
+	if (!extent_debug) {
+		rc = 0;
+		goto out;
+	}
 
 	page_count = 0;
 	list_for_each_entry(oap, &ext->oe_pages, oap_pending_item) {
 		pgoff_t index = oap2cl_page(oap)->cp_index;
 		++page_count;
-		if (index > ext->oe_end || index < ext->oe_start)
-			GOTO(out, rc = 110);
+		if (index > ext->oe_end || index < ext->oe_start) {
+			rc = 110;
+			goto out;
+		}
+	}
+	if (page_count != ext->oe_nr_pages) {
+		rc = 120;
+		goto out;
 	}
-	if (page_count != ext->oe_nr_pages)
-		GOTO(out, rc = 120);
 
 out:
 	if (rc != 0)
@@ -774,8 +811,10 @@ restart:
 		rc = osc_extent_wait(env, conflict, OES_INV);
 		osc_extent_put(env, conflict);
 		conflict = NULL;
-		if (rc < 0)
-			GOTO(out, found = ERR_PTR(rc));
+		if (rc < 0) {
+			found = ERR_PTR(rc);
+			goto out;
+		}
 
 		goto restart;
 	}
@@ -932,7 +971,7 @@ static int osc_extent_truncate(struct osc_extent *ext, pgoff_t trunc_index,
 	io->ci_obj = cl_object_top(osc2cl(obj));
 	rc = cl_io_init(env, io, CIT_MISC, io->ci_obj);
 	if (rc < 0)
-		GOTO(out, rc);
+		goto out;
 
 	/* discard all pages with index greater then trunc_index */
 	list_for_each_entry_safe(oap, tmp, &ext->oe_pages,
@@ -1112,21 +1151,27 @@ static int osc_extent_expand(struct osc_extent *ext, pgoff_t index, int *grants)
 	osc_object_lock(obj);
 	LASSERT(sanity_check_nolock(ext) == 0);
 	end_chunk = ext->oe_end >> ppc_bits;
-	if (chunk > end_chunk + 1)
-		GOTO(out, rc = -ERANGE);
+	if (chunk > end_chunk + 1) {
+		rc = -ERANGE;
+		goto out;
+	}
 
-	if (end_chunk >= chunk)
-		GOTO(out, rc = 0);
+	if (end_chunk >= chunk) {
+		rc = 0;
+		goto out;
+	}
 
 	LASSERT(end_chunk + 1 == chunk);
 	/* try to expand this extent to cover @index */
 	end_index = min(ext->oe_max_end, ((chunk + 1) << ppc_bits) - 1);
 
 	next = next_extent(ext);
-	if (next != NULL && next->oe_start <= end_index)
+	if (next != NULL && next->oe_start <= end_index) {
 		/* complex mode - overlapped with the next extent,
 		 * this case will be handled by osc_extent_find() */
-		GOTO(out, rc = -EAGAIN);
+		rc = -EAGAIN;
+		goto out;
+	}
 
 	ext->oe_end = end_index;
 	ext->oe_grants += chunksize;
@@ -1495,12 +1540,16 @@ static int osc_enter_cache(const struct lu_env *env, struct client_obd *cli,
 	 * of queued writes and create a discontiguous rpc stream */
 	if (OBD_FAIL_CHECK(OBD_FAIL_OSC_NO_GRANT) ||
 	    cli->cl_dirty_max < PAGE_CACHE_SIZE     ||
-	    cli->cl_ar.ar_force_sync || loi->loi_ar.ar_force_sync)
-		GOTO(out, rc = -EDQUOT);
+	    cli->cl_ar.ar_force_sync || loi->loi_ar.ar_force_sync) {
+		rc = -EDQUOT;
+		goto out;
+	}
 
 	/* Hopefully normal case - cache space and write credits available */
-	if (osc_enter_cache_try(cli, oap, bytes, 0))
-		GOTO(out, rc = 0);
+	if (osc_enter_cache_try(cli, oap, bytes, 0)) {
+		rc = 0;
+		goto out;
+	}
 
 	/* We can get here for two reasons: too many dirty pages in cache, or
 	 * run out of grants. In both cases we should write dirty pages out.
@@ -1528,16 +1577,18 @@ static int osc_enter_cache(const struct lu_env *env, struct client_obd *cli,
 		/* l_wait_event is interrupted by signal */
 		if (rc < 0) {
 			list_del_init(&ocw.ocw_entry);
-			GOTO(out, rc);
+			goto out;
 		}
 
 		LASSERT(list_empty(&ocw.ocw_entry));
 		rc = ocw.ocw_rc;
 
 		if (rc != -EDQUOT)
-			GOTO(out, rc);
-		if (osc_enter_cache_try(cli, oap, bytes, 0))
-			GOTO(out, rc = 0);
+			goto out;
+		if (osc_enter_cache_try(cli, oap, bytes, 0)) {
+			rc = 0;
+			goto out;
+		}
 	}
 out:
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
@@ -2399,14 +2450,15 @@ int osc_flush_async_page(const struct lu_env *env, struct cl_io *io,
 		 * one making the extent active, we could deadlock waiting for
 		 * the page writeback to clear but it won't because the extent
 		 * is active and won't be written out. */
-		GOTO(out, rc = -EAGAIN);
+		rc = -EAGAIN;
+		goto out;
 	default:
 		break;
 	}
 
 	rc = cl_page_prep(env, io, cl_page_top(cp), CRT_WRITE);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	spin_lock(&oap->oap_lock);
 	oap->oap_async_flags |= ASYNC_READY|ASYNC_URGENT;

