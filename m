Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaEMPdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:33:12 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:57287 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaEMPcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:32:55 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] drivers/base: Allow driver-data to be attached to a master
Date: Tue, 13 May 2014 17:30:45 +0200
Message-Id: <1399995050-28435-3-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Similarly to what can be done for device drivers, allow driver-specific
data to be attached to a master. This is necessary for masters whose
device is already bound to by a different driver and therefore cannot be
used to store the driver-specific data.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Note that I'd like to merge this patch through the Tegra DRM tree so
that the Tegra DRM changes later in this patch can be merged at the same
time to avoid them being delayed for another release cycle.

In particular I'm looking for an Acked-by from Greg and Russell.

 drivers/base/component.c  | 13 +++++++++++++
 include/linux/component.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index c4778995cd72..fb4510707281 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -25,6 +25,8 @@ struct master {
 
 	const struct component_master_ops *ops;
 	struct device *dev;
+
+	void *drvdata;
 };
 
 struct component {
@@ -53,6 +55,17 @@ static struct master *__master_find(struct device *dev,
 	return NULL;
 }
 
+void master_set_drvdata(struct master *master, void *data)
+{
+	if (master)
+		master->drvdata = data;
+}
+
+void *master_get_drvdata(struct master *master)
+{
+	return master ? master->drvdata : NULL;
+}
+
 /* Attach an unattached component to a master. */
 static void component_attach_master(struct master *master, struct component *c)
 {
diff --git a/include/linux/component.h b/include/linux/component.h
index 68870182ca1e..f130b34b1575 100644
--- a/include/linux/component.h
+++ b/include/linux/component.h
@@ -26,6 +26,9 @@ int component_master_add(struct device *, const struct component_master_ops *);
 void component_master_del(struct device *,
 	const struct component_master_ops *);
 
+void master_set_drvdata(struct master *, void *);
+void *master_get_drvdata(struct master *);
+
 int component_master_add_child(struct master *master,
 	int (*compare)(struct device *, void *), void *compare_data);
 
-- 
1.9.2

