Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab3EQI1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:27:08 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:49263 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3EQI1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:27:07 -0400
MIME-Version: 1.0
Date: Fri, 17 May 2013 16:27:05 +0800
Message-ID: <CAPgLHd_9mq_dR7+BKd628Si3aTH9xPXjFsv0hSThB7OHdn7pmA@mail.gmail.com>
Subject: [PATCH -next] staging: lustre: fix to use list_for_each_entry_safe()
 when delete items
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com, tao.peng@emc.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Since we will remove items off the list using list_del_init() we need
to use a safe version of the list_for_each_entry() macro aptly named
list_for_each_entry_safe().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/lustre/lustre/osc/osc_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index 206fead..116ea31 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -2620,7 +2620,7 @@ int osc_queue_sync_pages(const struct lu_env *env, struct osc_object *obj,
 {
 	struct client_obd     *cli = osc_cli(obj);
 	struct osc_extent     *ext;
-	struct osc_async_page *oap;
+	struct osc_async_page *oap, *tmp;
 	int     page_count = 0;
 	int     mppr       = cli->cl_max_pages_per_rpc;
 	pgoff_t start      = CL_PAGE_EOF;
@@ -2639,7 +2639,7 @@ int osc_queue_sync_pages(const struct lu_env *env, struct osc_object *obj,
 
 	ext = osc_extent_alloc(obj);
 	if (ext == NULL) {
-		list_for_each_entry(oap, list, oap_pending_item) {
+		list_for_each_entry_safe(oap, tmp, list, oap_pending_item) {
 			list_del_init(&oap->oap_pending_item);
 			osc_ap_completion(env, cli, oap, 0, -ENOMEM);
 		}

