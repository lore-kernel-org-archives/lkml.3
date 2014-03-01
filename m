Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaCACTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:19:35 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42606 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaCACRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:21 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Bruno Faccini <bruno.faccini@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 10/17] lustre/ldlm: set l_lvb_type coherent when layout is returned
Date: Fri, 28 Feb 2014 21:16:39 -0500
Message-Id: <1393640206-20286-11-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruno Faccini <bruno.faccini@intel.com>

In case layout has been packed into server reply when not
requested, lock l_lvb_type must be set accordingly.

Signed-off-by: Bruno Faccini <bruno.faccini@intel.com>
Reviewed-on: http://review.whamcloud.com/8270
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4194
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Johann Lombardi <johann.lombardi@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c | 1 +
 drivers/staging/lustre/lustre/mdc/mdc_locks.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index 3ed020e..d87048d 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -228,6 +228,7 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 
 			lock_res_and_lock(lock);
 			LASSERT(lock->l_lvb_data == NULL);
+			lock->l_lvb_type = LVB_T_LAYOUT;
 			lock->l_lvb_data = lvb_data;
 			lock->l_lvb_len = lvb_len;
 			unlock_res_and_lock(lock);
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 81adc2b..b0d0e2a 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -753,6 +753,7 @@ static int mdc_finish_enqueue(struct obd_export *exp,
 		/* install lvb_data */
 		lock_res_and_lock(lock);
 		if (lock->l_lvb_data == NULL) {
+			lock->l_lvb_type = LVB_T_LAYOUT;
 			lock->l_lvb_data = lmm;
 			lock->l_lvb_len = lvb_len;
 			lmm = NULL;
-- 
1.8.5.3

