Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbaIOUbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:31:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbaIOThE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 037/114] drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure
Date: Mon, 15 Sep 2014 12:25:37 -0700
Message-Id: <20140915192642.604711417@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 3533f8603d28b77c62d75ec899449a99bc6b77a1 upstream.

On some Windows hosts on FC SANs, TEST_UNIT_READY can return SRB_STATUS_ERROR.
Correctly handle this. Note that there is sufficient sense information to
support scsi error handling even in this case.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1018,6 +1018,13 @@ static void storvsc_handle_error(struct
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


