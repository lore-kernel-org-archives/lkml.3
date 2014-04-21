Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaDUEex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:34:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaDUEej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sven Neumann <s.neumann@raumfeld.com>, Daniel Mack <zonque@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.13 12/32] SCSI: sd: dont fail if the device doesnt recognize SYNCHRONIZE CACHE
Date: Sun, 20 Apr 2014 19:13:29 -0700
Message-Id: <20140421021135.539340472@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 7aae51347b21eb738dc1981df1365b57a6c5ee4e upstream.

Evidently some wacky USB-ATA bridges don't recognize the SYNCHRONIZE
CACHE command, as shown in this email thread:

	http://marc.info/?t=138978356200002&r=1&w=2

The fact that we can't tell them to drain their caches shouldn't
prevent the system from going into suspend.  Therefore sd_sync_cache()
shouldn't return an error if the device replies with an Invalid
Command ASC.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Sven Neumann <s.neumann@raumfeld.com>
Tested-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1463,8 +1463,8 @@ static int sd_sync_cache(struct scsi_dis
 			sd_print_sense_hdr(sdkp, &sshdr);
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(&sshdr) &&
-			/* 0x3a is medium not present */
-			sshdr.asc == 0x3a)
+			(sshdr.asc == 0x3a ||	/* medium not present */
+			 sshdr.asc == 0x20))	/* invalid command */
 				/* this is no error here */
 				return 0;
 


