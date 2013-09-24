Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3IXMJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:09:32 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4305 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3IXMJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:09:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Sep 2013 05:09:26 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv3 1/4] gpu: host1x: shuffle job APIs
Date: Tue, 24 Sep 2013 15:05:22 +0300
Message-ID: <1380024325-18280-2-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com>
References: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mayuresh Kulkarni <mkulkarni@nvidia.com>

This patch moves function host1x_job_submit() to job.c file where
all other host1x_job_* functions are placed. This patch also
introduces function host1x_job_complete().

Signed-off-by: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/cdma.c    |  2 ++
 drivers/gpu/host1x/channel.c |  8 --------
 drivers/gpu/host1x/channel.h |  1 -
 drivers/gpu/host1x/job.c     | 12 ++++++++++++
 drivers/gpu/host1x/job.h     |  3 +++
 5 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/host1x/cdma.c b/drivers/gpu/host1x/cdma.c
index de72172..910087b 100644
--- a/drivers/gpu/host1x/cdma.c
+++ b/drivers/gpu/host1x/cdma.c
@@ -252,6 +252,8 @@ static void update_cdma_locked(struct host1x_cdma *cdma)
 				signal = true;
 		}
 
+		host1x_job_complete(job);
+
 		list_del(&job->list);
 		host1x_job_put(job);
 	}
diff --git a/drivers/gpu/host1x/channel.c b/drivers/gpu/host1x/channel.c
index 83ea51b..c381441 100644
--- a/drivers/gpu/host1x/channel.c
+++ b/drivers/gpu/host1x/channel.c
@@ -21,7 +21,6 @@
 
 #include "channel.h"
 #include "dev.h"
-#include "job.h"
 
 /* Constructor for the host1x device list */
 int host1x_channel_list_init(struct host1x *host)
@@ -37,13 +36,6 @@ int host1x_channel_list_init(struct host1x *host)
 	return 0;
 }
 
-int host1x_job_submit(struct host1x_job *job)
-{
-	struct host1x *host = dev_get_drvdata(job->channel->dev->parent);
-
-	return host1x_hw_channel_submit(host, job);
-}
-
 struct host1x_channel *host1x_channel_get(struct host1x_channel *channel)
 {
 	int err = 0;
diff --git a/drivers/gpu/host1x/channel.h b/drivers/gpu/host1x/channel.h
index 48723b8..8401f25 100644
--- a/drivers/gpu/host1x/channel.h
+++ b/drivers/gpu/host1x/channel.h
@@ -44,7 +44,6 @@ struct host1x_channel *host1x_channel_request(struct device *dev);
 void host1x_channel_free(struct host1x_channel *channel);
 struct host1x_channel *host1x_channel_get(struct host1x_channel *channel);
 void host1x_channel_put(struct host1x_channel *channel);
-int host1x_job_submit(struct host1x_job *job);
 
 #define host1x_for_each_channel(host, channel)				\
 	list_for_each_entry(channel, &host->chlist.list, list)
diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index c4e1050..3928b4e 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -585,3 +585,15 @@ void host1x_job_dump(struct device *dev, struct host1x_job *job)
 	dev_dbg(dev, "    NUM_SLOTS   %d\n", job->num_slots);
 	dev_dbg(dev, "    NUM_HANDLES %d\n", job->num_unpins);
 }
+
+int host1x_job_submit(struct host1x_job *job)
+{
+	struct host1x *host = dev_get_drvdata(job->channel->dev->parent);
+
+	return host1x_hw_channel_submit(host, job);
+}
+
+int host1x_job_complete(struct host1x_job *job)
+{
+	return 0;
+}
diff --git a/drivers/gpu/host1x/job.h b/drivers/gpu/host1x/job.h
index fba45f2..e0249c3 100644
--- a/drivers/gpu/host1x/job.h
+++ b/drivers/gpu/host1x/job.h
@@ -159,4 +159,7 @@ void host1x_job_unpin(struct host1x_job *job);
  */
 void host1x_job_dump(struct device *dev, struct host1x_job *job);
 
+int host1x_job_submit(struct host1x_job *job);
+int host1x_job_complete(struct host1x_job *job);
+
 #endif
-- 
1.8.1.5

