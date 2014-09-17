Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaIQCF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:05:58 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:14603 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbaIQCF5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:05:57 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "'Srinivas Kandagatla'" <srinivas.kandagatla@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        "'dwalker@fifo99.com'" <dwalker@fifo99.com>,
        "'bryanh@codeaurora.org'" <bryanh@codeaurora.org>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>
Date: Wed, 17 Sep 2014 10:05:04 +0800
Subject: [RFC] msm:rpm-smd:change msm_rpm_smd_work method
Thread-Topic: [RFC] msm:rpm-smd:change msm_rpm_smd_work method
Thread-Index: Ac/SG8vbkB74diVXSpOnrgb0v+akHA==
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB491612@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this change msm_rpm_smd_work method to let it
run not as a forever loop, this can improve some
performance, because if the work_struct callback run
forever, it will hold the work thread forever, and other
work_struct can use it, it is not suitable for performance.

Change-Id: Ic99b36f8a3720b2bdfe45e4263a69f3d58c47cd1
Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm/mach-msm/rpm-smd.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-msm/rpm-smd.c b/arch/arm/mach-msm/rpm-smd.c
index 2a01a36..243463d 100644
--- a/arch/arm/mach-msm/rpm-smd.c
+++ b/arch/arm/mach-msm/rpm-smd.c
@@ -464,8 +464,6 @@ struct msm_rpm_ack_msg {
 
 LIST_HEAD(msm_rpm_ack_list);
 
-static DECLARE_COMPLETION(data_ready);
-
 static void msm_rpm_notify_sleep_chain(struct rpm_message_header *hdr,
 		struct msm_rpm_kvp_data *kvp)
 {
@@ -654,7 +652,7 @@ static void msm_rpm_notify(void *data, unsigned event)
 
 	switch (event) {
 	case SMD_EVENT_DATA:
-		complete(&data_ready);
+		queue_work(msm_rpm_smd_wq, &msm_rpm_data.work);
 		break;
 	case SMD_EVENT_OPEN:
 		complete(&pdata->smd_open);
@@ -849,19 +847,15 @@ static void msm_rpm_smd_work(struct work_struct *work)
 	int errno;
 	char buf[MAX_ERR_BUFFER_SIZE] = {0};
 
-	while (1) {
-		wait_for_completion(&data_ready);
-
-		spin_lock(&msm_rpm_data.smd_lock_read);
-		while (smd_is_pkt_avail(msm_rpm_data.ch_info)) {
-			if (msm_rpm_read_smd_data(buf))
-				break;
-			msg_id = msm_rpm_get_msg_id_from_ack(buf);
-			errno = msm_rpm_get_error_from_ack(buf);
-			msm_rpm_process_ack(msg_id, errno);
-		}
-		spin_unlock(&msm_rpm_data.smd_lock_read);
+	spin_lock(&msm_rpm_data.smd_lock_read);
+	while (smd_is_pkt_avail(msm_rpm_data.ch_info)) {
+		if (msm_rpm_read_smd_data(buf))
+			break;
+		msg_id = msm_rpm_get_msg_id_from_ack(buf);
+		errno = msm_rpm_get_error_from_ack(buf);
+		msm_rpm_process_ack(msg_id, errno);
 	}
+	spin_unlock(&msm_rpm_data.smd_lock_read);
 }
 
 static void msm_rpm_log_request(struct msm_rpm_request *cdata)
@@ -1237,7 +1231,7 @@ wait_ack_cleanup:
 	spin_unlock_irqrestore(&msm_rpm_data.smd_lock_read, flags);
 
 	if (smd_is_pkt_avail(msm_rpm_data.ch_info))
-		complete(&data_ready);
+		queue_work(msm_rpm_smd_wq, &msm_rpm_data.work);
 	return rc;
 }
 EXPORT_SYMBOL(msm_rpm_wait_for_ack_noirq);
@@ -1385,10 +1379,10 @@ static int __devinit msm_rpm_dev_probe(struct platform_device *pdev)
 
 	if (!standalone) {
 		msm_rpm_smd_wq = alloc_workqueue("rpm-smd",
-				WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+				WQ_UNBOUND | WQ_MEM_RECLAIM |
+				WQ_HIGHPRI | WQ_NON_REENTRANT, 1);
 		if (!msm_rpm_smd_wq)
 			return -EINVAL;
-		queue_work(msm_rpm_smd_wq, &msm_rpm_data.work);
 	}
 
 	of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
-- 
2.1.0
