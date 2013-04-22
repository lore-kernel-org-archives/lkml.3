Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3DVOiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:38:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51607 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754955Ab3DVOaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Hannes Reinecke" <hare@suse.de>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.789292799@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [37/75] target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition
 CDBs
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

commit 30f359a6f9da65a66de8cadf959f0f4a0d498bba upstream.

This patch fixes a bug where a handful of informational / control CDBs
that should be allowed during ALUA access state Standby/Offline/Transition
where incorrectly returning CHECK_CONDITION + ASCQ_04H_ALUA_TG_PT_*.

This includes INQUIRY + REPORT_LUNS, which would end up preventing LUN
registration when LUN scanning occured during these ALUA access states.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_alua.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -393,6 +393,7 @@ static inline int core_alua_state_standb
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -435,6 +436,7 @@ static inline int core_alua_state_unavai
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
@@ -475,6 +477,7 @@ static inline int core_alua_state_transi
 	switch (cdb[0]) {
 	case INQUIRY:
 	case REPORT_LUNS:
+		return 0;
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:

