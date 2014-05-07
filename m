Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364AbaEGNPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:15:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbaEGNPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:15:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 51/70] s390/chsc: fix SEI usage on old FW levels
Date: Wed,  7 May 2014 14:12:54 +0100
Message-Id: <1399468393-10140-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/cio/chsc.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 13299f9..ec0951a 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -560,18 +560,27 @@ static void chsc_process_sei_nt0(struct chsc_sei_nt0_area *sei_area)
 
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
 
@@ -587,7 +596,10 @@ static void chsc_process_event_information(struct chsc_sei *sei, u64 ntsm)
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
-- 
1.9.1

