Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3A2Dge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:36:34 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:50069 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756424Ab3A2Dft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:49 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 09/11] staging/fwserial: add diagnostic for buffer overflow
Date: Mon, 28 Jan 2013 22:34:43 -0500
Message-Id: <1359430485-5301-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 912b17a..912ab77 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -569,8 +569,11 @@ static int fwtty_buffer_rx(struct fwtty_port *port, unsigned char *d, size_t n)
 	struct buffered_rx *buf;
 	size_t size = (n + sizeof(struct buffered_rx) + 0xFF) & ~0xFF;
 
-	if (port->buffered + n > HIGH_WATERMARK)
+	if (port->buffered + n > HIGH_WATERMARK) {
+		fwtty_err_ratelimited(port, "overflowed rx buffer: buffered: %d new: %ld wtrmk: %d",
+				      port->buffered, n, HIGH_WATERMARK);
 		return 0;
+	}
 	buf = kmalloc(size, GFP_ATOMIC);
 	if (!buf)
 		return 0;
-- 
1.8.1.1

