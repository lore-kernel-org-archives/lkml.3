Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaAGNLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:11:37 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:39063 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaAGNL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:11:27 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 21:11:25 +0800
Message-ID: <CAPgLHd_AO6mEwaemSobCMwCg2J=xmH+-FF0Ek+PS8ZYdHJStXw@mail.gmail.com>
Subject: [PATCH -next] xen/evtchn_fifo: fix error return code in evtchn_fifo_setup()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: yongjun_wei@trendmicro.com.cn, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM from the error handling case instead of
0 (overwrited to 0 by the HYPERVISOR_event_channel_op call),
otherwise the error condition cann't be reflected from the
return value.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/xen/events/events_fifo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index e2bf957..89e4893 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -109,7 +109,7 @@ static int evtchn_fifo_setup(struct irq_info *info)
 {
 	unsigned port = info->evtchn;
 	unsigned new_array_pages;
-	int ret = -ENOMEM;
+	int ret;
 
 	new_array_pages = port / EVENT_WORDS_PER_PAGE + 1;
 
@@ -124,8 +124,10 @@ static int evtchn_fifo_setup(struct irq_info *info)
 		array_page = event_array[event_array_pages];
 		if (!array_page) {
 			array_page = (void *)__get_free_page(GFP_KERNEL);
-			if (array_page == NULL)
+			if (array_page == NULL) {
+				ret = -ENOMEM;
 				goto error;
+			}
 			event_array[event_array_pages] = array_page;
 		}
 

