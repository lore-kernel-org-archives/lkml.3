Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaCACSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:18:15 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42633 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbaCACRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:31 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Niu Yawei <yawei.niu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 16/17] lustre/quota: improper assert in osc_quota_chkdq()
Date: Fri, 28 Feb 2014 21:16:45 -0500
Message-Id: <1393640206-20286-17-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niu Yawei <yawei.niu@intel.com>

In osc_quota_chkdq(), we should never try to access oqi found
from hash, since it could have been freed by osc_quota_setdq().

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-on: http://review.whamcloud.com/8460
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4336
Reviewed-by: Johann Lombardi <johann.lombardi@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_quota.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_quota.c b/drivers/staging/lustre/lustre/osc/osc_quota.c
index 6045a78..f395ae4 100644
--- a/drivers/staging/lustre/lustre/osc/osc_quota.c
+++ b/drivers/staging/lustre/lustre/osc/osc_quota.c
@@ -51,11 +51,8 @@ int osc_quota_chkdq(struct client_obd *cli, const unsigned int qid[])
 
 		oqi = cfs_hash_lookup(cli->cl_quota_hash[type], &qid[type]);
 		if (oqi) {
-			obd_uid id = oqi->oqi_id;
-
-			LASSERTF(id == qid[type],
-				 "The ids don't match %u != %u\n",
-				 id, qid[type]);
+			/* do not try to access oqi here, it could have been
+			 * freed by osc_quota_setdq() */
 
 			/* the slot is busy, the user is about to run out of
 			 * quota space on this OST */
-- 
1.8.5.3

