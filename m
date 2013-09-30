Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3I3UB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:01:26 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:34381 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3I3UBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:01:25 -0400
Date: Mon, 30 Sep 2013 22:01:23 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-scsi@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, support@lsi.com,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH] [SCSI] mpt3sas: don't leak 'fw_event' in
 mpt3sas_send_trigger_data_event()
Message-ID: <alpine.LNX.2.00.1309302158340.4992@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we successfully allocate 'fw_event' but subsequently fail to
allocate 'fw_event->event_data' then we'll return from the function
without properly freeing 'fw_event'.
This patch takes care of that leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..e90fbf3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2518,8 +2518,10 @@ mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
 	if (!fw_event)
 		return;
 	fw_event->event_data = kzalloc(sizeof(*event_data), GFP_ATOMIC);
-	if (!fw_event->event_data)
+	if (!fw_event->event_data) {
+		kfree(fw_event);
 		return;
+	}
 	fw_event->event = MPT3SAS_PROCESS_TRIGGER_DIAG;
 	fw_event->ioc = ioc;
 	memcpy(fw_event->event_data, event_data, sizeof(*event_data));
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

