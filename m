Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbaE3Olr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:41:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:55120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564AbaE3Olo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548947148"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, bsegall@google.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [RFC PATCH 12/16 v3] Bias select wakee than waker in WAKE_AFFINE
Date: Fri, 30 May 2014 14:36:08 +0800
Message-Id: <1401431772-14320-13-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In WAKE_AFFINE, we do not simply select idle, but bias wakee than waker
if the cc of the wakee and waker (in this order) is capable of handling
the wakee task

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0c188df..d40ec9e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4370,7 +4370,18 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_group *sg;
 	int i = task_cpu(p);
 
-	if (idle_cpu(target))
+	/*
+	 * we do not select idle, if the cc of the wakee and
+	 * waker (in this order) is capable of handling the wakee task
+	 */
+	if (sysctl_sched_cc_wakeup_threshold) {
+		if (idle_cpu(i) || cpu_cc_capable(i))
+			return i;
+
+		if (i != target && (idle_cpu(target) || cpu_cc_capable(target)))
+			return target;
+	}
+	else if (idle_cpu(target))
 		return target;
 
 	/*
-- 
1.7.9.5

