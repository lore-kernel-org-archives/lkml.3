Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaFEEXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:23:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaFEEWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Dionne <marc.c.dionne@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 214/214] HID: logitech: dont use stack based dj_report structures
Date: Wed,  4 Jun 2014 21:19:37 -0700
Message-Id: <20140605041708.243134847@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Dionne <marc.c.dionne@gmail.com>

commit d8dc3494f77a5cc3b274bae36f7e74e85cf8a407 upstream.

On a system with a logitech wireless keyboard/mouse and DMA-API debugging
enabled, this warning appears at boot:

kernel: WARNING: at lib/dma-debug.c:929 check_for_stack.part.12+0x70/0xa7()
kernel: Hardware name: MS-7593
kernel: uhci_hcd 0000:00:1d.1: DMA-API: device driver maps memory fromstack [addr=ffff8801b0079c29]

Make logi_dj_recv_query_paired_devices and logi_dj_recv_switch_to_dj_mode
use a structure allocated with kzalloc rather than a stack based one.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-dj.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -474,28 +474,38 @@ static int logi_dj_recv_send_report(stru
 
 static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
 {
-	struct dj_report dj_report;
+	struct dj_report *dj_report;
+	int retval;
 
-	memset(&dj_report, 0, sizeof(dj_report));
-	dj_report.report_id = REPORT_ID_DJ_SHORT;
-	dj_report.device_index = 0xFF;
-	dj_report.report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
-	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
+	dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
+	if (!dj_report)
+		return -ENOMEM;
+	dj_report->report_id = REPORT_ID_DJ_SHORT;
+	dj_report->device_index = 0xFF;
+	dj_report->report_type = REPORT_TYPE_CMD_GET_PAIRED_DEVICES;
+	retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
+	kfree(dj_report);
+	return retval;
 }
 
 
 static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 					  unsigned timeout)
 {
-	struct dj_report dj_report;
+	struct dj_report *dj_report;
+	int retval;
 
-	memset(&dj_report, 0, sizeof(dj_report));
-	dj_report.report_id = REPORT_ID_DJ_SHORT;
-	dj_report.device_index = 0xFF;
-	dj_report.report_type = REPORT_TYPE_CMD_SWITCH;
-	dj_report.report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
-	dj_report.report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
-	return logi_dj_recv_send_report(djrcv_dev, &dj_report);
+	dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
+	if (!dj_report)
+		return -ENOMEM;
+	dj_report->report_id = REPORT_ID_DJ_SHORT;
+	dj_report->device_index = 0xFF;
+	dj_report->report_type = REPORT_TYPE_CMD_SWITCH;
+	dj_report->report_params[CMD_SWITCH_PARAM_DEVBITFIELD] = 0x3F;
+	dj_report->report_params[CMD_SWITCH_PARAM_TIMEOUT_SECONDS] = (u8)timeout;
+	retval = logi_dj_recv_send_report(djrcv_dev, dj_report);
+	kfree(dj_report);
+	return retval;
 }
 
 


