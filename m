Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3A1Fe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:34:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:12695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab3A1Fe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:34:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,548,1355126400"; 
   d="scan'208";a="277315685"
Subject: [PATCH] perf: Add the rcu_read_lock to protect the
 list_for_each_entry_rcu.
From: Jun Chen <jun.d.chen@intel.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Jun Chen <jun.d.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jan 2013 08:36:28 -0500
Message-ID: <1359380188.8410.11.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The list_for_each_entry_rcu should be guarded by rcu_read_lock().This patch add
rcu_read_lock to protect the list_for_each_entry_rcu.

Signed-off-by: Chen Jun <jun.d.chen@intel.com>
---
 kernel/events/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 301079d..e2f2fa5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2442,6 +2442,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 
 	raw_spin_lock(&ctx->lock);
 	perf_pmu_disable(ctx->pmu);
+	rcu_read_lock();
 
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
@@ -2483,6 +2484,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		event->pmu->start(event, delta > 0 ? PERF_EF_RELOAD : 0);
 	}
 
+	rcu_read_unlock();
 	perf_pmu_enable(ctx->pmu);
 	raw_spin_unlock(&ctx->lock);
 }
-- 
1.7.4.1



