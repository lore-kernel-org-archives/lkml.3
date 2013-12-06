Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3LFMEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:04:11 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62701 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab3LFMEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:04:07 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-4d-52a1bd351de4
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] USB: gadget: s3c-hsotg: add flush TX FIFO when kill all
 requests
Date: Fri, 06 Dec 2013 13:03:45 +0100
Message-id: <1386331425-16594-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386331425-16594-1-git-send-email-r.baldyga@samsung.com>
References: <1386331425-16594-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jAV3TvQuDDA5/trKY9bKdxWLjjPWs
	Fgfv11s0L17PZnG26Q27xeVdc9gsFi1rZbZYe+Quu8WDwzvZHTg99s9dw+7Rt2UVo8fxG9uZ
	PD5vkgtgieKySUnNySxLLdK3S+DKmDzzOHPBKY6Kj/8usjcwTmLvYuTkkBAwkTj8fBYjhC0m
	ceHeerYuRi4OIYFFjBJ7p+5kh3DamSR+th4D62AT0JHY8n0CWIeIgIDE+heXwIqYBf4yStx+
	2MkGkhAWCJf4fOQcC4jNIqAqMXHbKuYuRg4OXgFXic93s0FMCQEFiTmTbEBMTgE3iXPL5UCK
	hYAKjk3dwDSBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODQeia9g3FVg8UhRgEO
	RiUeXo5VC4KEWBPLiitzDzFKcDArifDaLF8YJMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1
	oJBAemJJanZqakFqEUyWiYNTqoGx5saRVDn5VcviTe/KqT4M+eib7nmv8YklS++CFv43IYcs
	fxS4LFtm3Ma0jLv5QN3lM7Lv3OfVTnOR2/6yRUoyKn1Hvv2VIxf572l3Jf3+1n1j6fzrCrdN
	rr96MyuW+ZHG1vszjfx7tSJWTb1of4zNc83UPlvRjnqGTYFOW328X1yT3CcXfsFWiaU4I9FQ
	i7moOBEAb1cyGykCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds flushing TX FIFO in kill_all_requests() function in
dedicated-fifo mode. It's because when requests are killed (when endpoint is
disabled or in case of device reset/disconnection) in FIFO can stay some
unsent data. In the worst case FIFO can stay full, and then if endpoint will
be back enabled, sending new data will be impossible.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 drivers/usb/gadget/s3c-hsotg.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index ad9a4ed..4a085e6 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2156,6 +2156,9 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
 		s3c_hsotg_complete_request(hsotg, ep, req,
 					   result);
 	}
+	if(hsotg->dedicated_fifos)
+		if ((readl(hsotg->regs + DTXFSTS(ep->index)) & 0xffff) * 4 < 3072)
+			s3c_hsotg_txfifo_flush(hsotg, ep->index);
 }
 
 #define call_gadget(_hs, _entry) \
-- 
1.7.9.5

