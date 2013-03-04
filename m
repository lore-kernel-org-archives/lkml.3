Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3CDD77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:59:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756668Ab3CDDoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:04 -0500
Message-Id: <20130304033714.778546002@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [ 073/153] target: Add missing mapped_lun bounds checking during make_mappedlun
 setup
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_fabric_configfs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -354,6 +354,14 @@ static struct config_group *target_fabri
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


