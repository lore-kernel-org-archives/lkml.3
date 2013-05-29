Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965649Ab3E2K2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:28:04 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10721 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965596Ab3E2K2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:28:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 29 May 2013 03:27:59 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@gmail.com>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <tbergstrom@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCHv2 6/7] gpu: host1x: Fix client_managed type
Date: Wed, 29 May 2013 13:26:07 +0300
Message-ID: <1369823168-5396-7-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

client_managed field in syncpoint structure was defined as an
integer. The field holds, however, only a boolean value. This patch
modifies the type to boolean.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/gr2d.c | 2 +-
 drivers/gpu/host1x/syncpt.c   | 8 ++++----
 drivers/gpu/host1x/syncpt.h   | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 6a45ae0..6c3a27b 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -281,7 +281,7 @@ static int gr2d_probe(struct platform_device *pdev)
 	if (!gr2d->channel)
 		return -ENOMEM;
 
-	*syncpts = host1x_syncpt_request(dev, 0);
+	*syncpts = host1x_syncpt_request(dev, false);
 	if (!(*syncpts)) {
 		host1x_channel_free(gr2d->channel);
 		return -ENOMEM;
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 2b03f1b..27201b5 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -32,7 +32,7 @@
 
 static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
 						  struct device *dev,
-						  int client_managed)
+						  bool client_managed)
 {
 	int i;
 	struct host1x_syncpt *sp = host->syncpt;
@@ -332,7 +332,7 @@ int host1x_syncpt_init(struct host1x *host)
 	host1x_syncpt_restore(host);
 
 	/* Allocate sync point to use for clearing waits for expired fences */
-	host->nop_sp = _host1x_syncpt_alloc(host, NULL, 0);
+	host->nop_sp = _host1x_syncpt_alloc(host, NULL, false);
 	if (!host->nop_sp)
 		return -ENOMEM;
 
@@ -340,7 +340,7 @@ int host1x_syncpt_init(struct host1x *host)
 }
 
 struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
-					    int client_managed)
+					    bool client_managed)
 {
 	struct host1x *host = dev_get_drvdata(dev->parent);
 	return _host1x_syncpt_alloc(host, dev, client_managed);
@@ -354,7 +354,7 @@ void host1x_syncpt_free(struct host1x_syncpt *sp)
 	kfree(sp->name);
 	sp->dev = NULL;
 	sp->name = NULL;
-	sp->client_managed = 0;
+	sp->client_managed = false;
 }
 
 void host1x_syncpt_deinit(struct host1x *host)
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index c998061..d00e758 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -36,7 +36,7 @@ struct host1x_syncpt {
 	atomic_t max_val;
 	u32 base_val;
 	const char *name;
-	int client_managed;
+	bool client_managed;
 	struct host1x *host;
 	struct device *dev;
 
@@ -94,7 +94,7 @@ static inline bool host1x_syncpt_check_max(struct host1x_syncpt *sp, u32 real)
 }
 
 /* Return true if sync point is client managed. */
-static inline int host1x_syncpt_client_managed(struct host1x_syncpt *sp)
+static inline bool host1x_syncpt_client_managed(struct host1x_syncpt *sp)
 {
 	return sp->client_managed;
 }
@@ -157,7 +157,7 @@ u32 host1x_syncpt_id(struct host1x_syncpt *sp);
 
 /* Allocate a sync point for a device. */
 struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
-		int client_managed);
+					    bool client_managed);
 
 /* Free a sync point. */
 void host1x_syncpt_free(struct host1x_syncpt *sp);
-- 
1.8.1.5

