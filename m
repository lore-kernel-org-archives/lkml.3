Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872Ab3GWWsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:48:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600Ab3GWW1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tejun Heo <tj@kernel.org>
Subject: [ 041/103] libata-zpodd: must use ata_tf_init()
Date: Tue, 23 Jul 2013 15:25:52 -0700
Message-Id: <20130723220423.164254551@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit d0887c43f51c308b01605346e55d906ba858a6f9 upstream.

There are  some SATA controllers which have both devices 0 and 1 but this module
just zeroes out taskfile and sets then ATA_TFLAG_DEVICE (not sure that's needed)
which could  lead to a wrong device being selected just before issuing command.
Thus we should  call ata_tf_init()  which sets  up the device register value
properly, like  all other users of ata_exec_internal() do...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-zpodd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -32,13 +32,14 @@ struct zpodd {
 
 static int eject_tray(struct ata_device *dev)
 {
-	struct ata_taskfile tf = {};
+	struct ata_taskfile tf;
 	const char cdb[] = {  GPCMD_START_STOP_UNIT,
 		0, 0, 0,
 		0x02,     /* LoEj */
 		0, 0, 0, 0, 0, 0, 0,
 	};
 
+	ata_tf_init(dev, &tf);
 	tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.command = ATA_CMD_PACKET;
 	tf.protocol = ATAPI_PROT_NODATA;
@@ -52,8 +53,7 @@ static enum odd_mech_type zpodd_get_mech
 	char buf[16];
 	unsigned int ret;
 	struct rm_feature_desc *desc = (void *)(buf + 8);
-	struct ata_taskfile tf = {};
-
+	struct ata_taskfile tf;
 	char cdb[] = {  GPCMD_GET_CONFIGURATION,
 			2,      /* only 1 feature descriptor requested */
 			0, 3,   /* 3, removable medium feature */
@@ -62,6 +62,7 @@ static enum odd_mech_type zpodd_get_mech
 			0, 0, 0,
 	};
 
+	ata_tf_init(dev, &tf);
 	tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.command = ATA_CMD_PACKET;
 	tf.protocol = ATAPI_PROT_PIO;


