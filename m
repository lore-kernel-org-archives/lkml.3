Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaFWIwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:52:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55544 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Chris Boot <crb@tiger-computing.co.uk>,
        Philip Gaw <pgaw@darktech.org.uk>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 058/111] target: Fix alua_access_state attribute OOPs for un-configured devices
Date: Mon, 23 Jun 2014 10:31:33 +0200
Message-Id: <ca55f49d628c4b9805d6567b45c6cc27503ac32f.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f1453773514bb8b0bba0716301e8c8f17f8d39c7 upstream.

This patch fixes a OOPs where an attempt to write to the per-device
alua_access_state configfs attribute at:

  /sys/kernel/config/target/core/$HBA/$DEV/alua/$TG_PT_GP/alua_access_state

results in an NULL pointer dereference when the backend device has not
yet been configured.

This patch adds an explicit check for DF_CONFIGURED, and fails with
-ENODEV to avoid this case.

Reported-by: Chris Boot <crb@tiger-computing.co.uk>
Reported-by: Philip Gaw <pgaw@darktech.org.uk>
Cc: Chris Boot <crb@tiger-computing.co.uk>
Cc: Philip Gaw <pgaw@darktech.org.uk>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_configfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 82e81c542e43..45d0867853b0 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2040,6 +2040,11 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
 	}
+	if (!(dev->dev_flags & DF_CONFIGURED)) {
+		pr_err("Unable to set alua_access_state while device is"
+		       " not configured\n");
+		return -ENODEV;
+	}
 
 	ret = kstrtoul(page, 0, &tmp);
 	if (ret < 0) {
-- 
2.0.0

