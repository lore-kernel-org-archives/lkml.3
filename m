Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaGHXqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:46:43 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:40506
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaGHXqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:46:34 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 8/8] drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure
Date: Tue,  8 Jul 2014 17:46:52 -0700
Message-Id: <1404866812-26950-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some Windows hosts on FC SANs, TEST_UNIT_READY can return SRB_STATUS_ERROR.
Correctly handle this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6540fb6..9afdd6d 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1023,6 +1023,13 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
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
1.7.4.1

