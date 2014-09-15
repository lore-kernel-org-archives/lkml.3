Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbaIOXLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:11:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbaIOWLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 101/187] drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure
Date: Mon, 15 Sep 2014 15:08:31 -0700
Message-Id: <1410818997-9432-102-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 3533f8603d28b77c62d75ec899449a99bc6b77a1 upstream.

On some Windows hosts on FC SANs, TEST_UNIT_READY can return SRB_STATUS_ERROR.
Correctly handle this. Note that there is sufficient sense information to
support scsi error handling even in this case.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/storvsc_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index b529ae8..ed0f899 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1018,6 +1018,13 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 		case ATA_12:
 			set_host_byte(scmnd, DID_PASSTHROUGH);
 			break;
+		/*
+		 * On Some Windows hosts TEST_UNIT_READY command can return
+		 * SRB_STATUS_ERROR, let the upper level code deal with it
+		 * based on the sense information.
+		 */
+		case TEST_UNIT_READY:
+			break;
 		default:
 			set_host_byte(scmnd, DID_TARGET_FAILURE);
 		}
-- 
1.9.1

