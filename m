Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaIZK13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:27:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbaIZJqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 064/142] drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure
Date: Fri, 26 Sep 2014 11:44:35 +0200
Message-Id: <92eaf5be80602f3465611d349ee7adaf9c803d10.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3533f8603d28b77c62d75ec899449a99bc6b77a1 upstream.

On some Windows hosts on FC SANs, TEST_UNIT_READY can return SRB_STATUS_ERROR.
Correctly handle this. Note that there is sufficient sense information to
support scsi error handling even in this case.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/storvsc_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index b529ae8e8fff..ed0f899e8aa5 100644
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
2.1.0

