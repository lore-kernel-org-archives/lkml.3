Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3CATqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3CATqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Engelhardt <jengelh@inai.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 08/30] target: Add missing mapped_lun bounds checking during make_mappedlun setup
Date: Fri,  1 Mar 2013 11:45:29 -0800
Message-Id: <20130301194528.885001700@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_fabric_configfs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -355,6 +355,14 @@ static struct config_group *target_fabri
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
 
 	lacl = core_dev_init_initiator_node_lun_acl(se_tpg, mapped_lun,
 			config_item_name(acl_ci), &ret);


