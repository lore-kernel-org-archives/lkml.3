Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaDQJ1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:27:08 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48166 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQJ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:27:05 -0400
Message-ID: <534F9E0A.8050201@huawei.com>
Date: Thu, 17 Apr 2014 17:25:30 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: <openipmi-developer@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ipmi: fix seq number of bt msg in debug message
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.191]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The seq number of HOST2BMC message in debug message
is not the real seq number but the next seq number;
we could directly just use bt->write_data[2].

pre:
[99477.760284] BT: +++++++++++++++++ New command
[99477.760286] BT: NetFn/LUN CMD [1 data]: 28 10 0c
[99477.760296] BT: write 5 bytes seq=0x88 04 28 87 10 0c
                                 ^^^^^^^^       ^^
[99477.772078] BT: got 8 bytes seq=0x87 07 2c 87 10 00 f8 07 00
[99477.772091] BT: result 6 bytes: 2c 10 00 f8 07 00

post:
[99477.760284] BT: +++++++++++++++++ New command
[99477.760286] BT: NetFn/LUN CMD [1 data]: 28 10 0c
[99477.760296] BT: write 5 bytes seq=0x87 04 28 87 10 0c
                                 ^^^^^^^^       ^^
[99477.772078] BT: got 8 bytes seq=0x87 07 2c 87 10 00 f8 07 00
[99477.772091] BT: result 6 bytes: 2c 10 00 f8 07 00

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/char/ipmi/ipmi_bt_sm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index f5e4cd7..1a2056f 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -341,7 +341,7 @@ static inline void write_all_bytes(struct si_sm_data *bt)

 	if (bt_debug & BT_DEBUG_MSG) {
 		printk(KERN_WARNING "BT: write %d bytes seq=0x%02X",
-			bt->write_count, bt->seq);
+			bt->write_count, bt->write_data[2]);
 		for (i = 0; i < bt->write_count; i++)
 			printk(" %02x", bt->write_data[i]);
 		printk("\n");
-- 
1.6.0.2


