Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab3APQBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:01:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab3APQBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Jeffery <djeffery@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 064/222] qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.
Date: Wed, 16 Jan 2013 13:54:24 -0200
Message-Id: <1358351822-7675-65-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

commit a394aac88506159e047630fc90dc2242568382d8 upstream.

When the qla2xxx driver loses access to multiple, remote ports, there is a race
condition which can occur which will keep the request stuck on a scsi request
queue indefinitely.

This bad state occurred do to a race condition with how the FCPORT_UPDATE_NEEDED
bit is set in qla2x00_schedule_rport_del(), and how it is cleared in
qla2x00_do_dpc().  The problem port has its drport pointer set, but it has never
been processed by the driver to inform the fc transport that the port has been
lost.  qla2x00_schedule_rport_del() sets drport, and then sets the
FCPORT_UPDATE_NEEDED bit.  In qla2x00_do_dpc(), the port lists are walked and
any drport pointer is handled and the fc transport informed of the port loss,
then the FCPORT_UPDATE_NEEDED bit is cleared.  This leaves a race where the
dpc thread is processing one port removal, another port removal is marked
with a call to qla2x00_schedule_rport_del(), and the dpc thread clears the
bit for both removals, even though only the first removal was actually
handled.  Until another event occurs to set FCPORT_UPDATE_NEEDED, the later
port removal is never finished and qla2xxx stays in a bad state which causes
requests to become stuck on request queues.

This patch updates the driver to test and clear FCPORT_UPDATE_NEEDED
atomically.  This ensures the port state changes are processed and not lost.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6d1d873..f6f555a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3801,9 +3801,9 @@ qla2x00_do_dpc(void *data)
 			    "ISP abort end.\n");
 		}
 
-		if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
+		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
+		    &base_vha->dpc_flags)) {
 			qla2x00_update_fcports(base_vha);
-			clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		}
 
 		if (test_bit(SCR_PENDING, &base_vha->dpc_flags)) {
-- 
1.7.9.5

