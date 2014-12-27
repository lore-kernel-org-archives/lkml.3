Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaL0UsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:48:23 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49650 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaL0UsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:48:08 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Greg Donald <gdonald@gmail.com>, Anton Saraev <antonysaraev@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, Joe Perches <joe@perches.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 5/5] staging: lustre: selftest: fix _recycle_buffer context imbalance
Date: Sat, 27 Dec 2014 12:46:50 -0800
Message-Id: <1419713210-8198-6-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
References: <1419713210-8198-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the sparse warning about a context imbalance in the
srpc_service_recycle_buffer function by telling sparse that it
should expect the lock to be held on entry and held on exit.

  drivers/staging/lustre/lnet/selftest/rpc.c:725:20: warning: context imbalance in 'srpc_service_recycle_buffer' - unexpected unlock

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/selftest/rpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index 2e9094b..1f7d9a6 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -698,6 +698,7 @@ srpc_finish_service(struct srpc_service *sv)
 /* called with sv->sv_lock held */
 static void
 srpc_service_recycle_buffer(struct srpc_service_cd *scd, srpc_buffer_t *buf)
+	__must_hold(&scd->scd_lock)
 {
 	if (!scd->scd_svc->sv_shuttingdown && scd->scd_buf_adjust >= 0) {
 		if (srpc_service_post_buffer(scd, buf) != 0) {
-- 
2.1.4

