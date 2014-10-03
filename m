Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbaJCXDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:03:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbaJCWXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:23:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Vittitoe <scvitti@google.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.10 026/143] HID: picolcd: sanity check report size in raw_event() callback
Date: Fri,  3 Oct 2014 14:33:41 -0700
Message-Id: <20141003213315.281779370@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 844817e47eef14141cf59b8d5ac08dd11c0a9189 upstream.

The report passed to us from transport driver could potentially be
arbitrarily large, therefore we better sanity-check it so that raw_data
that we hold in picolcd_pending structure are always kept within proper
bounds.

Reported-by: Steven Vittitoe <scvitti@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-picolcd_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -350,6 +350,12 @@ static int picolcd_raw_event(struct hid_
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


