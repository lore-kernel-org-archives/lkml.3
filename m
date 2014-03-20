Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbaCTS1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:27:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56164 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaCTS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:27:35 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-ce-532b3316a0bc
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH v2 1/3] ata: ahci_platform: fix ahci_platform_data->suspend
 method handling
Date: Thu, 20 Mar 2014 19:27:04 +0100
Message-id: <1395340026-3969-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395340026-3969-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395340026-3969-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jQV0xY+1gg5e7pSw2zljPanHuVgOr
	xZvj05ks7qxgttj0+BqrxbEdj5gsLu+aw2axv3cDk0VDdw+7xZwZm1ktfi0/ymix8uJfZgce
	j+uv/jN57Jx1l91j06pONo8505pYPE5eOMnisXlJvcf7fVfZPPq2rGL0ePpjL7PH8RvbmTw+
	b5IL4I7isklJzcksSy3St0vgyuj7s5itYDFXxaL2TywNjIc4uhg5OSQETCTeHPvHCmGLSVy4
	t56ti5GLQ0hgOqPEp117mCCcLiaJ0282M4JUsQlYSUxsXwVmiwjISlyZ9pARpIhZoItZYsns
	LWAJYYFYieZNk8HGsgioSuz51gkW5xVwl+hZsIQZYp2iRPezCWwgNqeAh8T//klgcSGgmvPd
	p9gmMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcws+kdzCuarA4xCjAwajEw1vB
	qR0sxJpYVlyZe4hRgoNZSYT3mi5QiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU
	7NTUgtQimCwTB6dUA+PEfy9+ndUxWLRogr1ZzypDW5ZHRe9Dvk406GPInsR6vUE/xGuJgfib
	0odbV/qrv99iyN5sVtK2tWvJuSWFh4oeiL6QF1i8q0Q9+qC07L1MHiWNzSlxPL5vrPN4tzAz
	Jb0NXMq4c/rG/w9Eypd/nnlm66/Ex+xs17clXj42fV/ozi1x1Q9kjJ8psRRnJBpqMRcVJwIA
	ArxeO10CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at ST SPEAr1340 AHCI code (the only user of the deprecated
pdata->suspend and pdata->resume) it is obvious the we should return
after calling pdata->suspend() only if the function have returned
non-zero return value.  The code has been broken since commit 1e70c2
("ata/ahci_platform: Add clock framework support").  Fix it.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v2:
- updated patch description

 drivers/ata/ahci_platform.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 70fbf66..7bd6adf 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -521,12 +521,19 @@ int ahci_platform_suspend(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (pdata && pdata->suspend)
-		return pdata->suspend(dev);
+	if (pdata && pdata->suspend) {
+		rc = pdata->suspend(dev);
+		if (rc)
+			goto resume_host;
+	}
 
 	ahci_platform_disable_resources(hpriv);
 
 	return 0;
+
+resume_host:
+	ahci_platform_resume_host(dev);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(ahci_platform_suspend);
 
-- 
1.8.2.3

