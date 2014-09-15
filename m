Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaIOThM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:37:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaIOThC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 032/114] Drivers: scsi: storvsc: Filter commands based on the storage protocol version
Date: Mon, 15 Sep 2014 12:25:32 -0700
Message-Id: <20140915192642.445755030@linuxfoundation.org>
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

commit 8caf92d80526f3d7cc96831ec18b384ebcaccdf0 upstream.

Going forward it is possible that some of the commands that are not currently
implemented will be implemented on future Windows hosts. Even if they are not
implemented, we are told the host will corrrectly handle unsupported
commands (by returning appropriate return code and sense information).
Make command filtering depend on the host version.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1564,9 +1564,19 @@ static int storvsc_queuecommand(struct S
 	struct vmscsi_request *vm_srb;
 	struct stor_mem_pools *memp = scmnd->device->hostdata;
 
-	if (!storvsc_scsi_cmd_ok(scmnd)) {
-		scmnd->scsi_done(scmnd);
-		return 0;
+	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
+		/*
+		 * On legacy hosts filter unimplemented commands.
+		 * Future hosts are expected to correctly handle
+		 * unsupported commands. Furthermore, it is
+		 * possible that some of the currently
+		 * unsupported commands maybe supported in
+		 * future versions of the host.
+		 */
+		if (!storvsc_scsi_cmd_ok(scmnd)) {
+			scmnd->scsi_done(scmnd);
+			return 0;
+		}
 	}
 
 	request_size = sizeof(struct storvsc_cmd_request);


