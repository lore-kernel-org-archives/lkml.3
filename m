Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbaDVPLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:11:16 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:56360 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbaDVPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:10:54 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [RFC 2/5] drivers/base: Allow driver-data to be attached to a master
Date: Tue, 22 Apr 2014 17:09:30 +0200
Message-Id: <1398179373-29966-3-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
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
 drivers/base/component.c  | 13 +++++++++++++
 include/linux/component.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index 14fe81bf5ed2..e3693c6d552f 100644
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
index 89fe8bb35053..9c2ec9fe48d6 100644
--- a/include/linux/component.h
+++ b/include/linux/component.h
@@ -25,6 +25,9 @@ int component_master_add(struct device *, const struct component_master_ops *);
 void component_master_del(struct device *,
 	const struct component_master_ops *);
 
+void master_set_drvdata(struct master *, void *);
+void *master_get_drvdata(struct master *);
+
 int component_master_add_child(struct master *master,
 	int (*compare)(struct device *, void *), void *compare_data);
 
-- 
1.9.2

