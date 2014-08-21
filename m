Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaHUPmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:42:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaHUPmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:42:01 -0400
Date: Thu, 21 Aug 2014 10:41:58 -0500 (CDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Ben Hawkes <hawkes@google.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: logitech: fix bounds checking on LED report size
Message-ID: <alpine.LNX.2.00.1408211039560.23162@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check on report size for REPORT_TYPE_LEDS in logi_dj_ll_raw_request()
is wrong; the current check doesn't make any sense -- the report allocated
by HID core in hid_hw_raw_request() can be much larger than
DJREPORT_SHORT_LENGTH, and currently logi_dj_ll_raw_request() doesn't
handle this properly at all.

Fix the check by actually trimming down the report size properly if it is
too large.

Cc: stable@vger.kernel.org
Reported-by: Ben Hawkes <hawkes@google.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-logitech-dj.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 486dbde..ca0ab51 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -557,7 +557,7 @@ static int logi_dj_ll_raw_request(struct hid_device *hid,
 	if (!out_buf)
 		return -ENOMEM;
 
-	if (count < DJREPORT_SHORT_LENGTH - 2)
+	if (count > DJREPORT_SHORT_LENGTH - 2)
 		count = DJREPORT_SHORT_LENGTH - 2;
 
 	out_buf[0] = REPORT_ID_DJ_SHORT;

-- 
Jiri Kosina
SUSE Labs
