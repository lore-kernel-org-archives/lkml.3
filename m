Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3JDUSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:18:40 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:51575 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3JDUSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:18:38 -0400
From: Erik Faye-Lund <kusmabite@gmail.com>
To: linux-tegra@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: host1x: check relocs after all gathers are consumed
Date: Fri,  4 Oct 2013 20:18:33 +0000
Message-Id: <1380917913-20482-1-git-send-email-kusmabite@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The num_relocs count are passed to the kernel per job, not per gather.

For multi-gather jobs, we would previously fail if there were relocs in
other gathers aside from the first one.

Fix this by simply moving the check until all gathers have been
consumed.

Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>
---
 drivers/gpu/host1x/job.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index c4e1050..c9ddff8 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -436,10 +436,6 @@ static int validate(struct host1x_firewall *fw, struct host1x_job_gather *g)
 		}
 	}
 
-	/* No relocs should remain at this point */
-	if (fw->num_relocs)
-		err = -EINVAL;
-
 out:
 	return err;
 }
@@ -493,6 +489,10 @@ static inline int copy_gathers(struct host1x_job *job, struct device *dev)
 		offset += g->words * sizeof(u32);
 	}
 
+	/* No relocs should remain at this point */
+	if (fw.num_relocs)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
1.7.9.5

