Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbaEMKQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:16:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933624AbaEMKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 137/182] s390/chsc: fix SEI usage on old FW levels
Date: Tue, 13 May 2014 11:28:09 +0200
Message-Id: <dde7970471c5187ecc3f7dcadfe33020413e636d.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 06cd7a874ec6e09d151aeb1fa8600e14f1ff89f6 upstream.

Using a notification type mask for the store event information chsc
is unsupported on some firmware levels. Retry SEI with that mask set
to zero (which is the old way of requesting only channel subsystem
related events).

Reported-and-tested-by: Stefan Haberland <stefan.haberland@de.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/s390/cio/chsc.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 13299f902676..ec0951a788fc 100644
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
1.9.3

