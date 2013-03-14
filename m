Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab3CNLFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:05:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3CNKgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Engelhardt <jengelh@inai.de>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 05/88] target: Add missing mapped_lun bounds checking during make_mappedlun setup
Date: Thu, 14 Mar 2013 10:34:58 +0000
Message-Id: <1363257381-15900-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit fbbf8555a986ed31e54f006b6cc637ea4ff1425b upstream.

This patch adds missing bounds checking for the configfs provided
mapped_lun value during target_fabric_make_mappedlun() setup ahead
of se_lun_acl initialization.

This addresses a potential OOPs when using a mapped_lun value that
exceeds the hardcoded TRANSPORT_MAX_LUNS_PER_TPG-1 value within
se_node_acl->device_list[].

Reported-by: Jan Engelhardt <jengelh@inai.de>
Cc: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_fabric_configfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index c42143b..8b07a88 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -358,6 +358,14 @@ static struct config_group *target_fabric_make_mappedlun(
 		ret = -EINVAL;
 		goto out;
 	}
+	if (mapped_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
+		pr_err("Mapped LUN: %lu exceeds TRANSPORT_MAX_LUNS_PER_TPG"
+			"-1: %u for Target Portal Group: %u\n", mapped_lun,
+			TRANSPORT_MAX_LUNS_PER_TPG-1,
+			se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
+		ret = -EINVAL;
+		goto out;
+	}
 
 	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, se_nacl,
 			mapped_lun, &ret);
-- 
1.8.1.2

