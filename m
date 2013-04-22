Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3DVOft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:35:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51632 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854Ab3DVOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Roland Dreier" <roland@purestorage.com>,
        "Christoph Hellwig" <hch@lst.de>, "Hannes Reinecke" <hare@suse.de>,
        "Rob Evers" <revers@redhat.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.13937383@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [36/75] target: Fix MAINTENANCE_IN service action CDB checks to
 use lower 5 bits
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit ba539743b70cd160c84bab1c82910d0789b820f8 upstream.

This patch fixes the MAINTENANCE_IN service action type checks to only
look at the proper lower 5 bits of cdb byte 1.  This addresses the case
where MI_REPORT_TARGET_PGS w/ extended header using the upper three bits of
cdb byte 1 was not processed correctly in transport_generic_cmd_sequencer,
as well as the three cases for standby, unavailable, and transition ALUA
primary access state checks.

Also add MAINTENANCE_IN to the excluded list in transport_generic_prepare_cdb()
to prevent the PARAMETER DATA FORMAT bits from being cleared.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Rob Evers <revers@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_alua.c      |    6 +++---
 drivers/target/target_core_transport.c |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -394,7 +394,7 @@ static inline int core_alua_state_standb
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
 	case MAINTENANCE_IN:
-		switch (cdb[1]) {
+		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
@@ -436,7 +436,7 @@ static inline int core_alua_state_unavai
 	case INQUIRY:
 	case REPORT_LUNS:
 	case MAINTENANCE_IN:
-		switch (cdb[1]) {
+		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
@@ -476,7 +476,7 @@ static inline int core_alua_state_transi
 	case INQUIRY:
 	case REPORT_LUNS:
 	case MAINTENANCE_IN:
-		switch (cdb[1]) {
+		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1445,6 +1445,7 @@ static inline void transport_generic_pre
 	case VERIFY_16: /* SBC - VRProtect */
 	case WRITE_VERIFY: /* SBC - VRProtect */
 	case WRITE_VERIFY_12: /* SBC - VRProtect */
+	case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
 		break;
 	default:
 		cdb[1] &= 0x1f; /* clear logical unit number */
@@ -2683,7 +2684,7 @@ static int transport_generic_cmd_sequenc
 			/*
 			 * Check for emulated MI_REPORT_TARGET_PGS.
 			 */
-			if (cdb[1] == MI_REPORT_TARGET_PGS &&
+			if ((cdb[1] & 0x1f) == MI_REPORT_TARGET_PGS &&
 			    su_dev->t10_alua.alua_type == SPC3_ALUA_EMULATED) {
 				cmd->execute_task =
 					target_emulate_report_target_port_groups;

