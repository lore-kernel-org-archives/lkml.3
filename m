Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3AaSpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:45:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab3AaSlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672835"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 04/13] workqueue: clear cwq when cancel the work
Date: Fri, 1 Feb 2013 02:41:27 +0800
Message-Id: <1359657696-2767-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:45,
	Serialize complete at 2013/02/01 02:40:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clear_work_cwq() which clear the CWQ bit when the work is offq when it is
cancelled.

It is the other important step of killing CWQ bit of the work which is
not queued on any pool.

Now, when a work is offq, it has no CWQ bit.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b12b30e..50d3dd5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -556,6 +556,12 @@ static void set_work_cwq(struct work_struct *work,
 		      WORK_STRUCT_PENDING | WORK_STRUCT_CWQ | extra_flags);
 }
 
+static void clear_work_cwq(struct work_struct *work, int pool_id)
+{
+	set_work_data(work, pool_id << WORK_OFFQ_POOL_SHIFT,
+		      WORK_STRUCT_PENDING);
+}
+
 static void set_work_pool_and_clear_pending(struct work_struct *work,
 					    int pool_id)
 {
@@ -1115,6 +1121,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			cwq_dec_nr_in_flight(get_work_cwq(work),
 				get_work_color(work));
 
+			clear_work_cwq(work, pool->id);
 			spin_unlock(&pool->lock);
 			return 1;
 		}
-- 
1.7.7.6

