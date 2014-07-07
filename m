Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaGHBOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:14:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaGGXxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.15 003/122] ibmvscsi: Abort init sequence during error recovery
Date: Mon,  7 Jul 2014 16:56:05 -0700
Message-Id: <20140707235734.344064364@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit 9ee755974bea2f9880e517ec985dc9dede1b3a36 upstream.

If a CRQ reset is triggered for some reason while in the middle
of performing VSCSI adapter initialization, we don't want to
call the done function for the initialization MAD commands as
this will only result in two threads attempting initialization
at the same time, resulting in failures.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -797,7 +797,8 @@ static void purge_requests(struct ibmvsc
 				       evt->hostdata->dev);
 			if (evt->cmnd_done)
 				evt->cmnd_done(evt->cmnd);
-		} else if (evt->done)
+		} else if (evt->done && evt->crq.format != VIOSRP_MAD_FORMAT &&
+			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
 			evt->done(evt);
 		free_event_struct(&evt->hostdata->pool, evt);
 		spin_lock_irqsave(hostdata->host->host_lock, flags);


