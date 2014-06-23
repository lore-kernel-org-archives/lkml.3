Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaFWItD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:49:03 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55542 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Chris Boot <crb@tiger-computing.co.uk>,
        Philip Gaw <pgaw@darktech.org.uk>, Hannes Reinecke <hare@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 065/111] target: Allow READ_CAPACITY opcode in ALUA Standby access state
Date: Mon, 23 Jun 2014 10:31:40 +0200
Message-Id: <bf8af413dcf4591bcc8f823133c4a2355c189458.1403512281.git.jslaby@suse.cz>
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

commit e7810c2d2c37fa8e58dda74b00790dab60fe6fba upstream.

This patch allows READ_CAPACITY + SAI_READ_CAPACITY_16 opcode
processing to occur while the associated ALUA group is in Standby
access state.

This is required to avoid host side LUN probe failures during the
initial scan if an ALUA group has already implicitly changed into
Standby access state.

This addresses a bug reported by Chris + Philip using dm-multipath
+ ESX hosts configured with ALUA multipath.

(Drop v3.15 specific set_ascq usage - nab)

Reported-by: Chris Boot <crb@tiger-computing.co.uk>
Reported-by: Philip Gaw <pgaw@darktech.org.uk>
Cc: Chris Boot <crb@tiger-computing.co.uk>
Cc: Philip Gaw <pgaw@darktech.org.uk>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_alua.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 47244102281e..792424ffa53b 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -409,7 +409,16 @@ static inline int core_alua_state_standby(
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
+	case READ_CAPACITY:
 		return 0;
+	case SERVICE_ACTION_IN:
+		switch (cdb[1] & 0x1f) {
+		case SAI_READ_CAPACITY_16:
+			return 0;
+		default:
+			*alua_ascq = ASCQ_04H_ALUA_TG_PT_STANDBY;
+			return 1;
+		}
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
-- 
2.0.0

