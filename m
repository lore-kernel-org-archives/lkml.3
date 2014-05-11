Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbaEKTYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:24:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353AbaEKTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.10 16/48] s390/chsc: fix SEI usage on old FW levels
Date: Sun, 11 May 2014 21:19:50 +0200
Message-Id: <20140511191950.332685045@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

commit 06cd7a874ec6e09d151aeb1fa8600e14f1ff89f6 upstream.

Using a notification type mask for the store event information chsc
is unsupported on some firmware levels. Retry SEI with that mask set
to zero (which is the old way of requesting only channel subsystem
related events).

Reported-and-tested-by: Stefan Haberland <stefan.haberland@de.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/cio/chsc.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -500,18 +500,27 @@ static void chsc_process_sei_nt0(struct
 
 static void chsc_process_event_information(struct chsc_sei *sei, u64 ntsm)
 {
-	do {
+	static int ntsm_unsupported;
+
+	while (true) {
 		memset(sei, 0, sizeof(*sei));
 		sei->request.length = 0x0010;
 		sei->request.code = 0x000e;
-		sei->ntsm = ntsm;
+		if (!ntsm_unsupported)
+			sei->ntsm = ntsm;
 
 		if (chsc(sei))
 			break;
 
 		if (sei->response.code != 0x0001) {
-			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x)\n",
-				      sei->response.code);
+			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x, ntsm=%llx)\n",
+				      sei->response.code, sei->ntsm);
+
+			if (sei->response.code == 3 && sei->ntsm) {
+				/* Fallback for old firmware. */
+				ntsm_unsupported = 1;
+				continue;
+			}
 			break;
 		}
 
@@ -527,7 +536,10 @@ static void chsc_process_event_informati
 			CIO_CRW_EVENT(2, "chsc: unhandled nt: %d\n", sei->nt);
 			break;
 		}
-	} while (sei->u.nt0_area.flags & 0x80);
+
+		if (!(sei->u.nt0_area.flags & 0x80))
+			break;
+	}
 }
 
 /*


