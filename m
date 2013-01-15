Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab3AOWzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:55:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:47687 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933997Ab3AOWzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:55:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Jeffery <djeffery@redhat.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 10/71] SCSI: qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.
Date: Tue, 15 Jan 2013 14:54:07 -0800
Message-Id: <20130115225341.166544347@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3406,9 +3406,9 @@ qla2x00_do_dpc(void *data)
 			    base_vha->host_no));
 		}
 
-		if (test_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags)) {
+		if (test_and_clear_bit(FCPORT_UPDATE_NEEDED,
+		    &base_vha->dpc_flags)) {
 			qla2x00_update_fcports(base_vha);
-			clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		}
 
 		if (test_bit(ISP_QUIESCE_NEEDED, &base_vha->dpc_flags)) {


