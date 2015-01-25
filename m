Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbbAYTVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:21:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbbAYSJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Long Li <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 43/98] storvsc: ring buffer failures may result in I/O freeze
Date: Sun, 25 Jan 2015 10:07:01 -0800
Message-Id: <20150125180714.738632223@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit e86fb5e8ab95f10ec5f2e9430119d5d35020c951 upstream.

When ring buffer returns an error indicating retry, storvsc may not
return a proper error code to SCSI when bounce buffer is not used.
This has introduced I/O freeze on RAID running atop storvsc devices.
This patch fixes it by always returning a proper error code.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1690,13 +1690,12 @@ static int storvsc_queuecommand(struct S
 	if (ret == -EAGAIN) {
 		/* no more space */
 
-		if (cmd_request->bounce_sgl_count) {
+		if (cmd_request->bounce_sgl_count)
 			destroy_bounce_buffer(cmd_request->bounce_sgl,
 					cmd_request->bounce_sgl_count);
 
-			ret = SCSI_MLQUEUE_DEVICE_BUSY;
-			goto queue_error;
-		}
+		ret = SCSI_MLQUEUE_DEVICE_BUSY;
+		goto queue_error;
 	}
 
 	return 0;


