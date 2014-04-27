Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaD0VRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:17:45 -0400
Received: from linuxhacker.ru ([217.76.32.60]:49644 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbaD0VRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:17:43 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 3/5] staging/lustre/lnet: fix potential null pointer dereference
Date: Sun, 27 Apr 2014 17:17:24 -0400
Message-Id: <1398633446-16719-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Pointer 'tsc' returned from call to function 'sfw_find_test_case'
at line 571 may be NULL and will be dereferenced at line 572.
found by Klocwork Insight tool

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9386
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/selftest/framework.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index 050723a..c141f93 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -547,10 +547,16 @@ sfw_test_rpc_fini (srpc_client_rpc_t *rpc)
 static inline int
 sfw_test_buffers(sfw_test_instance_t *tsi)
 {
-	struct sfw_test_case	*tsc = sfw_find_test_case(tsi->tsi_service);
-	struct srpc_service	*svc = tsc->tsc_srv_service;
+	struct sfw_test_case	*tsc;
+	struct srpc_service	*svc;
 	int			nbuf;
 
+	LASSERT(tsi != NULL);
+	tsc = sfw_find_test_case(tsi->tsi_service);
+	LASSERT(tsc != NULL);
+	svc = tsc->tsc_srv_service;
+	LASSERT(svc != NULL);
+
 	nbuf = min(svc->sv_wi_total, tsi->tsi_loop) / svc->sv_ncpts;
 	return max(SFW_TEST_WI_MIN, nbuf + SFW_TEST_WI_EXTRA);
 }
@@ -595,8 +601,10 @@ sfw_load_test(struct sfw_test_instance *tsi)
 void
 sfw_unload_test(struct sfw_test_instance *tsi)
 {
-	struct sfw_test_case *tsc = sfw_find_test_case(tsi->tsi_service);
+	struct sfw_test_case *tsc;
 
+	LASSERT(tsi != NULL);
+	tsc = sfw_find_test_case(tsi->tsi_service);
 	LASSERT(tsc != NULL);
 
 	if (tsi->tsi_is_client)
-- 
1.9.0

