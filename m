Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaGLPx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 11:53:28 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58285
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaGLPxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 11:53:23 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: jasowang@redhat.com, apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 7/7] drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure
Date: Sat, 12 Jul 2014 09:48:32 -0700
Message-Id: <1405183712-23967-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1405183712-23967-1-git-send-email-kys@microsoft.com>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some Windows hosts on FC SANs, TEST_UNIT_READY can return SRB_STATUS_ERROR.
Correctly handle this. Note that there is sufficient sense information to
support scsi error handling even in this case.

In this version of the patch I have addressed comments from
Christoph Hellwig <hch@infradead.org>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9342ba4..29d0329 100644
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
1.7.4.1

