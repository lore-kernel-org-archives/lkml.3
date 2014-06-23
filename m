Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaFWNIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:08:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaFWNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Boot <crb@tiger-computing.co.uk>, Philip Gaw <pgaw@darktech.org.uk>,
        Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 84/93] target: Allow READ_CAPACITY opcode in ALUA Standby access state
Date: Mon, 23 Jun 2014 14:03:03 +0100
Message-Id: <1403528592-2163-85-git-send-email-luis.henriques@canonical.com>
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
[ luis: backported to 3.11: Used nab's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_alua.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index f608fbc14a27..df58a67f81e0 100644
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
1.9.1

