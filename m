Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaFWNFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37153 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaFWNFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Boot <crb@tiger-computing.co.uk>, Philip Gaw <pgaw@darktech.org.uk>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 72/93] target: Fix alua_access_state attribute OOPs for un-configured devices
Date: Mon, 23 Jun 2014 14:02:51 +0100
Message-Id: <1403528592-2163-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_configfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index e4d22933efaf..304811e09649 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2031,6 +2031,11 @@ static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
 			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
 	}
+	if (!(dev->dev_flags & DF_CONFIGURED)) {
+		pr_err("Unable to set alua_access_state while device is"
+		       " not configured\n");
+		return -ENODEV;
+	}
 
 	ret = strict_strtoul(page, 0, &tmp);
 	if (ret < 0) {
-- 
1.9.1

