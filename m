Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaFLXWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:22:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaFLXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Boot <crb@tiger-computing.co.uk>,
        Philip Gaw <pgaw@darktech.org.uk>, Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 09/18] target: Allow READ_CAPACITY opcode in ALUA Standby access state
Date: Thu, 12 Jun 2014 16:22:13 -0700
Message-Id: <20140612232213.375339661@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232212.960235342@linuxfoundation.org>
References: <20140612232212.960235342@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_alua.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -409,7 +409,16 @@ static inline int core_alua_state_standb
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


