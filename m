Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab3DDCGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:06:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17418 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab3DDCGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:06:02 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363104000"; 
   d="scan'208";a="6998075"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 7/7] workqueue: avoid false negative WARN_ON()
Date: Thu, 4 Apr 2013 10:05:38 +0800
Message-Id: <1365041143-3088-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:05:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:05:01,
	Serialize complete at 2013/04/04 10:05:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is very common wq->dfl_pwq->refcnt > 1.

[    7.939873] WARNING: at kernel/workqueue.c:4201 destroy_workqueue+0x6a/0x13e()
[    7.943601] Hardware name: 4286C12
[    7.947250] Modules linked in: sdhci_pci sdhci mmc_core usb_storage i915 drm_kms_helper drm i2c_algo_bit i2c_core video
[    7.951313] Pid: 361, comm: umount Not tainted 3.9.0-rc5+ #29
[    7.955309] Call Trace:
[    7.959346]  [<c04314a7>] warn_slowpath_common+0x7c/0x93
[    7.963506]  [<c044796a>] ? destroy_workqueue+0x6a/0x13e
[    7.967748]  [<c044796a>] ? destroy_workqueue+0x6a/0x13e
[    7.971981]  [<c04314e0>] warn_slowpath_null+0x22/0x24
[    7.976383]  [<c044796a>] destroy_workqueue+0x6a/0x13e
[    7.980875]  [<c056dc01>] ext4_put_super+0x43/0x2c4
[    7.985407]  [<c050bd48>] ? dispose_list+0x28/0x32
[    7.989987]  [<c050c652>] ? evict_inodes+0xcf/0xd7
[    7.994509]  [<c04fb7b8>] generic_shutdown_super+0x4b/0xb9
[    7.999130]  [<c04fb848>] kill_block_super+0x22/0x60
[    8.003594]  [<c04fb960>] deactivate_locked_super+0x2f/0x56
[    8.008077]  [<c04fc41b>] deactivate_super+0x2e/0x31
[    8.012523]  [<c050f1e6>] mntput_no_expire+0x103/0x108
[    8.017050]  [<c050fdce>] sys_umount+0x2a2/0x2c4
[    8.021429]  [<c050fe0e>] sys_oldumount+0x1e/0x20
[    8.025678]  [<c085ba4d>] sysenter_do_call+0x12/0x38

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3f33077..f015c38 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4198,7 +4198,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 			}
 		}
 
-		if (WARN_ON(pwq->refcnt > 1) ||
+		if (WARN_ON((pwq != wq->dfl_pwq) && (pwq->refcnt > 1)) ||
 		    WARN_ON(pwq->nr_active) ||
 		    WARN_ON(!list_empty(&pwq->delayed_works))) {
 			mutex_unlock(&wq->mutex);
-- 
1.7.7.6

