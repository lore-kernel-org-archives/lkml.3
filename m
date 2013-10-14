Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab3JNM1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:27:05 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14803 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab3JNM0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:26:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 Oct 2013 05:26:08 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>
Subject: [PATCHv2 1/4] gpu: host1x: Add 'flags' field to syncpt request
Date: Mon, 14 Oct 2013 15:21:52 +0300
Message-ID: <1381753315-21778-2-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
References: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions host1x_syncpt_request() and _host1x_syncpt_alloc() have
been taking a separate boolean flag ('client_managed') for indicating
if the syncpoint value should be tracked by the host1x driver.

This patch converts the field into generic 'flags' field so that
we can easily add more information while requesting a syncpoint.
Clients are adapted to use the new interface accordingly.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/gr2d.c |  2 +-
 drivers/gpu/host1x/syncpt.c   | 14 +++++++-------
 drivers/gpu/host1x/syncpt.h   |  3 ++-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 27ffcf1..7efd97b 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -285,7 +285,7 @@ static int gr2d_probe(struct platform_device *pdev)
 	if (!gr2d->channel)
 		return -ENOMEM;
 
-	*syncpts = host1x_syncpt_request(dev, false);
+	*syncpts = host1x_syncpt_request(dev, 0);
 	if (!(*syncpts)) {
 		host1x_channel_free(gr2d->channel);
 		return -ENOMEM;
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 409745b..d376cd4 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -30,9 +30,9 @@
 #define SYNCPT_CHECK_PERIOD (2 * HZ)
 #define MAX_STUCK_CHECK_COUNT 15
 
-static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
-						  struct device *dev,
-						  bool client_managed)
+static struct host1x_syncpt *host1x_syncpt_alloc(struct host1x *host,
+						 struct device *dev,
+						 unsigned long flags)
 {
 	int i;
 	struct host1x_syncpt *sp = host->syncpt;
@@ -51,7 +51,7 @@ static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
 
 	sp->dev = dev;
 	sp->name = name;
-	sp->client_managed = client_managed;
+	sp->client_managed = !!(flags & HOST1X_SYNCPT_CLIENT_MANAGED);
 
 	return sp;
 }
@@ -321,7 +321,7 @@ int host1x_syncpt_init(struct host1x *host)
 	host1x_syncpt_restore(host);
 
 	/* Allocate sync point to use for clearing waits for expired fences */
-	host->nop_sp = _host1x_syncpt_alloc(host, NULL, false);
+	host->nop_sp = host1x_syncpt_alloc(host, NULL, 0);
 	if (!host->nop_sp)
 		return -ENOMEM;
 
@@ -329,10 +329,10 @@ int host1x_syncpt_init(struct host1x *host)
 }
 
 struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
-					    bool client_managed)
+					    unsigned long flags)
 {
 	struct host1x *host = dev_get_drvdata(dev->parent);
-	return _host1x_syncpt_alloc(host, dev, client_managed);
+	return host1x_syncpt_alloc(host, dev, flags);
 }
 
 void host1x_syncpt_free(struct host1x_syncpt *sp)
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index 267c0b9..1de7b58 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -153,8 +153,9 @@ int host1x_syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr);
 u32 host1x_syncpt_id(struct host1x_syncpt *sp);
 
 /* Allocate a sync point for a device. */
+#define HOST1X_SYNCPT_CLIENT_MANAGED	(1 << 0)
 struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
-					    bool client_managed);
+					    unsigned long flags);
 
 /* Free a sync point. */
 void host1x_syncpt_free(struct host1x_syncpt *sp);
-- 
1.8.1.5

