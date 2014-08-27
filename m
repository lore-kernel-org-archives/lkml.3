Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaH0HNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:13:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaH0HNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:13:17 -0400
Date: Wed, 27 Aug 2014 09:13:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: linux-input@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: [PATCH 2/2] HID: picolcd: sanity check report size in raw_event()
 callback
In-Reply-To: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1408270912310.2992@pobox.suse.cz>
References: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The report passed to us from transport driver could potentially be 
arbitrarily large, therefore we better sanity-check it so that raw_data 
that we hold in picolcd_pending structure are always kept within proper 
bounds.

Cc: stable@vger.kernel.org
Reported-by: Steven Vittitoe <scvitti@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-picolcd_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index acbb0210..020df3c 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -350,6 +350,12 @@ static int picolcd_raw_event(struct hid_device *hdev,
 	if (!data)
 		return 1;
 
+	if (size > 64) {
+		hid_warn(hdev, "invalid size value (%d) for picolcd raw event\n",
+				size);
+		return 0;
+	}
+
 	if (report->id == REPORT_KEY_STATE) {
 		if (data->input_keys)
 			ret = picolcd_raw_keypad(data, report, raw_data+1, size-1);
-- 
1.9.2
