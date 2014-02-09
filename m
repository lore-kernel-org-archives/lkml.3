Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaBIHwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:52:39 -0500
Received: from linuxhacker.ru ([217.76.32.60]:37356 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaBIHw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:52:29 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 5/5] lustre: don't leak llog handle in llog_cat_process_cb()
Date: Sun,  9 Feb 2014 02:51:49 -0500
Message-Id: <1391932309-6009-6-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
References: <1391932309-6009-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

An early return from llog_cat_process_cb() was leaking the llog
handle. Fix this by not doing that.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/7847
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4054
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/llog_cat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/llog_cat.c b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
index c0f3af7..1d999310 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_cat.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
@@ -551,9 +551,8 @@ int llog_cat_process_cb(const struct lu_env *env, struct llog_handle *cat_llh,
 
 	if (rec->lrh_index < d->lpd_startcat)
 		/* Skip processing of the logs until startcat */
-		return 0;
-
-	if (d->lpd_startidx > 0) {
+		rc = 0;
+	else if (d->lpd_startidx > 0) {
 		struct llog_process_cat_data cd;
 
 		cd.lpcd_first_idx = d->lpd_startidx;
@@ -566,6 +565,7 @@ int llog_cat_process_cb(const struct lu_env *env, struct llog_handle *cat_llh,
 		rc = llog_process_or_fork(env, llh, d->lpd_cb, d->lpd_data,
 					  NULL, false);
 	}
+
 	llog_handle_put(llh);
 
 	return rc;
-- 
1.8.5.3

