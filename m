Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaLPULc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:11:32 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53707
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaLPULL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:11:11 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/4] Drivers: scsi: storvsc: Fix a bug in storvsc limits
Date: Tue, 16 Dec 2014 13:21:44 -0800
Message-Id: <1418764905-11250-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1418764905-11250-1-git-send-email-kys@microsoft.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4cd83ecdac20d30725b4f96e5d7814a1e290bc7e changed the limits to
reflect the values on the host. It turns out that WS2008R2 cannot
correctly handle these new limits. Fix this bug by setting the limits
based on the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a7163c6..fdc5164 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1782,6 +1782,9 @@ static int storvsc_probe(struct hv_device *device,
 	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
 	int target = 0;
 	struct storvsc_device *stor_device;
+	int max_luns_per_target;
+	int max_targets;
+	int max_channels;
 
 	/*
 	 * Based on the windows host we are running on,
@@ -1795,12 +1798,18 @@ static int storvsc_probe(struct hv_device *device,
 		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 		vmstor_current_major = VMSTOR_WIN7_MAJOR;
 		vmstor_current_minor = VMSTOR_WIN7_MINOR;
+		max_luns_per_target = STORVSC_IDE_MAX_LUNS_PER_TARGET;
+		max_targets = STORVSC_IDE_MAX_TARGETS;
+		max_channels = STORVSC_IDE_MAX_CHANNELS;
 		break;
 	default:
 		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
 		vmscsi_size_delta = 0;
 		vmstor_current_major = VMSTOR_WIN8_MAJOR;
 		vmstor_current_minor = VMSTOR_WIN8_MINOR;
+		max_luns_per_target = STORVSC_MAX_LUNS_PER_TARGET;
+		max_targets = STORVSC_MAX_TARGETS;
+		max_channels = STORVSC_MAX_CHANNELS;
 		break;
 	}
 
@@ -1848,9 +1857,9 @@ static int storvsc_probe(struct hv_device *device,
 		break;
 
 	case SCSI_GUID:
-		host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
-		host->max_id = STORVSC_MAX_TARGETS;
-		host->max_channel = STORVSC_MAX_CHANNELS - 1;
+		host->max_lun = max_luns_per_target;
+		host->max_id = max_targets;
+		host->max_channel = max_channels - 1;
 		break;
 
 	default:
-- 
1.7.4.1

