Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3D2CwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 22:52:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19080 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab3D2CwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 22:52:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,570,1363104000"; 
   d="scan'208";a="7156569"
From: liguang <lig.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH] cpu: rid cpu_hotplug_disabled check for cpu_down()
Date: Mon, 29 Apr 2013 10:49:51 +0800
Message-Id: <1367203791-9723-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/29 10:50:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/29 10:50:38,
	Serialize complete at 2013/04/29 10:50:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in cpu_down(), _cpu_down() will do
"
        if (num_online_cpus() == 1)
                 return -EBUSY;
"
when cpu_hotplug_disabled was set, num_online_cpus
will return 1 for there's only 1 boot cpu.
so, it's unnecessary to check cpu_hotplug_disabled
here.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/cpu.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b5e4ab2..cd166d3 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -330,14 +330,8 @@ int __ref cpu_down(unsigned int cpu)
 
 	cpu_maps_update_begin();
 
-	if (cpu_hotplug_disabled) {
-		err = -EBUSY;
-		goto out;
-	}
-
 	err = _cpu_down(cpu, 0);
 
-out:
 	cpu_maps_update_done();
 	return err;
 }
-- 
1.7.2.5

