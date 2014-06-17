Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967734AbaFQWgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:36:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54045 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966229AbaFQVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Boot <crb@tiger-computing.co.uk>, Philip Gaw <pgaw@darktech.org.uk>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 210/212] target: Fix alua_access_state attribute OOPs for un-configured devices
Date: Tue, 17 Jun 2014 14:45:04 -0700
Message-Id: <1403041506-13646-211-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_configfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 272755d..afcbb04 100644
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
1.9.1

